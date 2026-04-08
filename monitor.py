import hashlib
import json
import pathlib
import re
import time
from typing import Any, Dict, List, Optional, Set

import gradio as gr

MONITOR_DIR = pathlib.Path("monitor")
RULES_DIR = pathlib.Path("rules")
HISTORY_FILE = pathlib.Path("history.json")
SUSPICIOUS_RULES_FILE = RULES_DIR / "suspicious_auto.yar"
NON_SUSPICIOUS_RULES_FILE = RULES_DIR / "non_suspicious_auto.yar"

SKIP_PREFIXES = (".", "~")
SKIP_SUFFIXES = (".tmp", ".swp", ".partial", ".crdownload")
SIMILARITY_THRESHOLD = 0.82


def now_utc() -> str:
    return time.strftime("%Y-%m-%d %H:%M:%S UTC", time.gmtime())


def ensure_paths() -> None:
    MONITOR_DIR.mkdir(exist_ok=True)
    RULES_DIR.mkdir(exist_ok=True)


def load_state() -> Dict[str, Any]:
    """Load normalized state format: {'files': {filename: info}}."""
    if not HISTORY_FILE.exists():
        return {"files": {}}

    try:
        with open(HISTORY_FILE, "r", encoding="utf-8") as f:
            raw = json.load(f)
    except Exception:
        return {"files": {}}

    if isinstance(raw, dict) and isinstance(raw.get("files"), dict):
        return {"files": dict(raw["files"])}

    return {"files": {}}


def save_state(state: Dict[str, Any]) -> None:
    with open(HISTORY_FILE, "w", encoding="utf-8") as f:
        json.dump(state, f, indent=2)


def should_track_file(path: pathlib.Path) -> bool:
    if not path.is_file():
        return False
    name = path.name
    if any(name.startswith(prefix) for prefix in SKIP_PREFIXES):
        return False
    if any(name.endswith(suffix) for suffix in SKIP_SUFFIXES):
        return False
    return True


def sha256_file(path: pathlib.Path) -> str:
    digest = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def _tokenize_text(text: str, limit: int = 600) -> List[str]:
    parts = re.findall(r"[A-Za-z_][A-Za-z0-9_]{2,}", text.lower())
    out: List[str] = []
    seen: Set[str] = set()
    for p in parts:
        if p in seen:
            continue
        seen.add(p)
        out.append(p)
        if len(out) >= limit:
            break
    return out


def _line_fingerprints(text: str, limit: int = 300) -> List[str]:
    out: List[str] = []
    seen: Set[str] = set()
    for line in text.splitlines():
        norm = re.sub(r"\s+", " ", line.strip().lower())
        if len(norm) < 4:
            continue
        digest = hashlib.sha256(norm.encode("utf-8", errors="ignore")).hexdigest()[:16]
        if digest in seen:
            continue
        seen.add(digest)
        out.append(digest)
        if len(out) >= limit:
            break
    return out


def _jaccard(a: Set[str], b: Set[str]) -> float:
    if not a and not b:
        return 0.0
    union = a | b
    if not union:
        return 0.0
    return len(a & b) / len(union)


def build_content_features(path: pathlib.Path, indicators: List[str]) -> Dict[str, Any]:
    try:
        raw = path.read_bytes()[: 1024 * 1024]
    except Exception:
        raw = b""

    try:
        text = raw.decode("utf-8")
    except UnicodeDecodeError:
        text = raw.decode("latin-1", errors="ignore")

    indicator_set = sorted({str(x).strip().lower() for x in indicators if str(x).strip()})
    indicator_tokens = _tokenize_text(" ".join(indicator_set), limit=300)
    code_tokens = _tokenize_text(text, limit=600)
    line_prints = _line_fingerprints(text, limit=300)

    combined_tokens = []
    seen: Set[str] = set()
    for t in code_tokens + indicator_tokens:
        if t in seen:
            continue
        seen.add(t)
        combined_tokens.append(t)
        if len(combined_tokens) >= 800:
            break

    return {
        "tokens": combined_tokens,
        "lines": line_prints,
        "indicators": indicator_set,
        "size": int(path.stat().st_size) if path.exists() else 0,
        "extension": path.suffix.lower(),
    }


def similarity_score(a: Dict[str, Any], b: Dict[str, Any]) -> float:
    a_tokens = set(str(x) for x in a.get("tokens", []))
    b_tokens = set(str(x) for x in b.get("tokens", []))
    a_lines = set(str(x) for x in a.get("lines", []))
    b_lines = set(str(x) for x in b.get("lines", []))
    a_inds = set(str(x) for x in a.get("indicators", []))
    b_inds = set(str(x) for x in b.get("indicators", []))

    token_sim = _jaccard(a_tokens, b_tokens)
    line_sim = _jaccard(a_lines, b_lines)
    indicator_sim = _jaccard(a_inds, b_inds)

    size_a = int(a.get("size", 0))
    size_b = int(b.get("size", 0))
    max_size = max(size_a, size_b, 1)
    size_sim = 1.0 - (abs(size_a - size_b) / max_size)
    if size_sim < 0.0:
        size_sim = 0.0

    ext_sim = 1.0 if str(a.get("extension", "")) == str(b.get("extension", "")) else 0.0
    score = (
        (0.45 * line_sim)
        + (0.35 * token_sim)
        + (0.12 * indicator_sim)
        + (0.05 * size_sim)
        + (0.03 * ext_sim)
    )
    return round(max(0.0, min(1.0, score)), 6)


def infer_auto_label(
    files_state: Dict[str, Any], candidate_features: Dict[str, Any], exclude_name: Optional[str] = None
) -> str:
    best_similarity = 0.0
    for name, info in files_state.items():
        if exclude_name and name == exclude_name:
            continue
        if info.get("label") != "suspicious":
            continue
        ref_features = info.get("features", {})
        if not isinstance(ref_features, dict):
            continue
        score = similarity_score(candidate_features, ref_features)
        if score > best_similarity:
            best_similarity = score
    if best_similarity >= SIMILARITY_THRESHOLD:
        return "suspicious"
    return "non_suspicious"


def promote_similar_files_to_suspicious(files_state: Dict[str, Any]) -> bool:
    suspicious_features = []
    for name, info in files_state.items():
        if info.get("label") != "suspicious":
            continue
        features = info.get("features", {})
        if isinstance(features, dict):
            suspicious_features.append((name, features))

    if not suspicious_features:
        return False

    dirty = False
    for name, info in files_state.items():
        if info.get("label") == "suspicious":
            continue
        if info.get("label_source") == "manual" and info.get("label") == "non_suspicious":
            # Respect explicit user demotion unless file content changes.
            continue
        features = info.get("features", {})
        if not isinstance(features, dict):
            continue
        max_score = 0.0
        for _, s_features in suspicious_features:
            score = similarity_score(features, s_features)
            if score > max_score:
                max_score = score
        if max_score >= SIMILARITY_THRESHOLD:
            if info.get("label") != "suspicious":
                info["label"] = "suspicious"
                info["updated_at"] = now_utc()
                dirty = True

    return dirty


def propagate_label_to_similar(
    files_state: Dict[str, Any], source_name: str, target_label: str
) -> bool:
    source = files_state.get(source_name, {})
    source_features = source.get("features", {})
    if not isinstance(source_features, dict):
        return False

    dirty = False
    for name, info in files_state.items():
        if name == source_name:
            continue
        features = info.get("features", {})
        if not isinstance(features, dict):
            continue
        score = similarity_score(source_features, features)
        if score >= SIMILARITY_THRESHOLD and info.get("label") != target_label:
            info["label"] = target_label
            info["label_source"] = "propagated"
            info["updated_at"] = now_utc()
            dirty = True

    return dirty


def sync_monitor_state() -> Dict[str, Any]:
    """Sync monitor/ contents into history state."""
    ensure_paths()
    state = load_state()
    files_state = state.setdefault("files", {})
    dirty = False

    current_names = set()
    for path in sorted(MONITOR_DIR.iterdir(), key=lambda p: p.name.lower()):
        if not should_track_file(path):
            continue

        name = path.name
        current_names.add(name)
        stats = path.stat()
        digest = sha256_file(path)
        prev = files_state.get(name)

        if not prev:
            indicators = extract_indicators(path)
            features = build_content_features(path, indicators)
            label = infer_auto_label(files_state, features, exclude_name=name)
            files_state[name] = {
                "name": name,
                "path": str(path),
                "size": stats.st_size,
                "sha256": digest,
                "label": label,
                "label_source": "auto",
                "indicators": indicators,
                "features": features,
                "updated_at": now_utc(),
            }
            dirty = True
            continue

        changed = prev.get("sha256") != digest
        prev.update({"path": str(path), "size": stats.st_size, "sha256": digest})
        if changed:
            indicators = extract_indicators(path)
            features = build_content_features(path, indicators)
            prev["label"] = infer_auto_label(files_state, features, exclude_name=name)
            prev["label_source"] = "auto"
            prev["indicators"] = indicators
            prev["features"] = features
            prev["updated_at"] = now_utc()
            dirty = True
        elif "label_source" not in prev:
            prev["label_source"] = "auto"
            dirty = True
        elif "features" not in prev:
            prev["features"] = build_content_features(
                path, prev.get("indicators", []) if isinstance(prev.get("indicators"), list) else []
            )
            dirty = True

    for name in list(files_state.keys()):
        if name not in current_names:
            del files_state[name]
            dirty = True

    if promote_similar_files_to_suspicious(files_state):
        dirty = True

    if dirty:
        write_auto_rules(state)
    save_state(state)
    return state


def extract_indicators(path: pathlib.Path, limit: int = 12) -> List[str]:
    """Extract printable strings quickly; no model, no long processing."""
    try:
        data = path.read_bytes()[: 1024 * 1024]
    except Exception:
        return []

    chunks = re.findall(rb"[ -~]{5,120}", data)
    out: List[str] = []
    seen = set()
    for chunk in chunks:
        text = chunk.decode("ascii", errors="ignore").strip()
        if not text:
            continue
        if text in seen:
            continue
        seen.add(text)
        out.append(text)
        if len(out) >= limit:
            break
    return out


def yara_escape(text: str) -> str:
    return text.replace("\\", "\\\\").replace('"', '\\"')


def sanitize_rule_name(prefix: str, filename: str) -> str:
    clean = re.sub(r"[^A-Za-z0-9_]", "_", filename)
    if not clean:
        clean = "file"
    if clean[0].isdigit():
        clean = f"_{clean}"
    return f"{prefix}_{clean}"[:120]


def build_rule_text(filename: str, info: Dict[str, Any]) -> str:
    label = info.get("label", "unlabeled")
    indicators = [str(x) for x in info.get("indicators", []) if str(x).strip()]
    if not indicators:
        indicators = [f"fallback::{filename}"]

    prefix = "suspicious" if label == "suspicious" else "non_suspicious"
    rule_name = sanitize_rule_name(prefix, filename)
    condition = "1 of them" if label == "suspicious" else "all of them"

    strings_lines = [
        f'        $s{i} = "{yara_escape(ind)}" nocase'
        for i, ind in enumerate(indicators, start=1)
    ]

    return "\n".join(
        [
            f"rule {rule_name}",
            "{",
            "    meta:",
            f'        source_file = "{yara_escape(filename)}"',
            f'        label = "{label}"',
            f'        sha256 = "{info.get("sha256", "")}"',
            f'        updated_at = "{info.get("updated_at", "")}"',
            "    strings:",
            *strings_lines,
            "    condition:",
            f"        {condition}",
            "}",
        ]
    )


def write_auto_rules(state: Dict[str, Any]) -> None:
    files_state = state.get("files", {})
    suspicious_rules: List[str] = []
    non_suspicious_rules: List[str] = []

    for filename in sorted(files_state.keys()):
        info = files_state[filename]
        label = info.get("label")
        if label not in {"suspicious", "non_suspicious"}:
            continue
        rule_text = build_rule_text(filename, info)
        if label == "suspicious":
            suspicious_rules.append(rule_text)
        else:
            non_suspicious_rules.append(rule_text)

    suspicious_content = [
        "/* Auto-generated from dashboard labels */",
        "",
        *suspicious_rules,
        "",
    ]
    non_suspicious_content = [
        "/* Auto-generated from dashboard labels */",
        "",
        *non_suspicious_rules,
        "",
    ]

    SUSPICIOUS_RULES_FILE.write_text("\n".join(suspicious_content), encoding="utf-8")
    NON_SUSPICIOUS_RULES_FILE.write_text(
        "\n".join(non_suspicious_content), encoding="utf-8"
    )


def label_file(filename: str, label: str) -> str:
    if not filename:
        return "Select a file first."

    state = sync_monitor_state()
    files_state = state.get("files", {})
    info = files_state.get(filename)
    if not info:
        return f"File not found: {filename}"

    path = pathlib.Path(info.get("path", ""))
    if not path.exists():
        return f"File not found on disk: {filename}"

    info["label"] = label
    info["label_source"] = "manual"
    info["indicators"] = extract_indicators(path)
    info["features"] = build_content_features(path, info["indicators"])
    info["updated_at"] = now_utc()

    # Propagate manual label to similar files in both directions.
    propagate_label_to_similar(files_state, filename, label)

    save_state(state)
    write_auto_rules(state)
    return f"Saved as {label}: {filename}"


def mark_suspicious(filename: str) -> str:
    return label_file(filename, "suspicious")


def mark_non_suspicious(filename: str) -> str:
    return label_file(filename, "non_suspicious")


def selected_file_details(filename: str) -> tuple[str, str]:
    if not filename:
        return "Current label: -", "Select a file."

    state = load_state()
    info = state.get("files", {}).get(filename)
    if not info:
        return "Current label: -", "File not found."

    label = info.get("label", "unlabeled")
    if label not in {"suspicious", "non_suspicious"}:
        return f"Current label: {label}", "No rule yet."
    return f"Current label: {label}", build_rule_text(filename, info)


def build_rows(state: Dict[str, Any]) -> List[List[str]]:
    rows: List[List[str]] = []
    for filename in sorted(state.get("files", {}).keys()):
        info = state["files"][filename]
        rows.append(
            [
                filename,
                info.get("label", "unlabeled"),
                str(info.get("size", "")),
                str(info.get("sha256", ""))[:12],
            ]
        )
    return rows


def refresh_dashboard(
    selected_file: Optional[str],
) -> tuple[str, List[List[str]], gr.update, str, str]:
    selected_file = selected_file or ""
    state = sync_monitor_state()
    files_state = state.get("files", {})
    choices = sorted(files_state.keys())

    if selected_file not in choices:
        selected_file = choices[0] if choices else ""
    selected_value = selected_file if selected_file else None

    suspicious_count = sum(
        1 for v in files_state.values() if v.get("label") == "suspicious"
    )
    non_suspicious_count = sum(
        1 for v in files_state.values() if v.get("label") == "non_suspicious"
    )

    status = (
        f"Files: {len(choices)} | "
        f"Suspicious: {suspicious_count} | Non-suspicious: {non_suspicious_count}"
    )
    label_text, preview = selected_file_details(selected_file)

    return (
        status,
        build_rows(state),
        gr.update(choices=choices, value=selected_value),
        label_text,
        preview,
    )


def refresh_dashboard_no_input() -> tuple[str, List[List[str]], gr.update, str, str]:
    return refresh_dashboard(None)


def build_ui() -> gr.Blocks:
    with gr.Blocks(title="Monitor") as demo:
        gr.Markdown("# Monitor")
        gr.Markdown(
            "Put files in `monitor/`, pick file, click `Suspicious` or `Non-Suspicious`."
        )

        status_md = gr.Markdown("Files: 0 | Suspicious: 0 | Non-suspicious: 0")

        with gr.Row():
            refresh_btn = gr.Button("Refresh")
            file_selector = gr.Dropdown(
                label="File",
                choices=[],
                value=None,
                allow_custom_value=False,
                interactive=True,
            )

        table = gr.Dataframe(
            headers=["File", "Label", "Size", "SHA256"],
            datatype=["str", "str", "str", "str"],
            interactive=False,
            row_count=8,
        )

        with gr.Row():
            suspicious_btn = gr.Button("Suspicious", variant="stop")
            non_suspicious_btn = gr.Button("Non-Suspicious", variant="primary")

        action_msg = gr.Textbox(label="Action", interactive=False, lines=1)
        current_label = gr.Textbox(label="Current Label", interactive=False, lines=1)
        preview = gr.Textbox(label="Rule Preview", interactive=False, lines=14)

        gr.Markdown(f"Rules auto-saved to `{SUSPICIOUS_RULES_FILE}`")
        gr.Markdown(f"Rules auto-saved to `{NON_SUSPICIOUS_RULES_FILE}`")

        outputs = [status_md, table, file_selector, current_label, preview]

        refresh_btn.click(refresh_dashboard, inputs=[file_selector], outputs=outputs)
        file_selector.change(refresh_dashboard, inputs=[file_selector], outputs=outputs)

        suspicious_btn.click(
            mark_suspicious, inputs=[file_selector], outputs=[action_msg]
        ).then(refresh_dashboard, inputs=[file_selector], outputs=outputs)

        non_suspicious_btn.click(
            mark_non_suspicious, inputs=[file_selector], outputs=[action_msg]
        ).then(refresh_dashboard, inputs=[file_selector], outputs=outputs)

        demo.load(refresh_dashboard_no_input, outputs=outputs)
        gr.Timer(2.0).tick(refresh_dashboard, inputs=[file_selector], outputs=outputs)

    return demo


if __name__ == "__main__":
    ensure_paths()
    state = sync_monitor_state()
    write_auto_rules(state)
    app = build_ui()
    app.launch()