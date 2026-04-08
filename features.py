import pathlib
import re
from typing import Dict, Any, List
from collections import Counter
from .utils_common import _entropy, _now_utc

def extract_strings_and_byte_patterns(sample_bytes: bytes) -> Dict[str, Any]:
    strings = [
        s.decode("ascii", errors="ignore").strip()
        for s in re.findall(rb"[ -~]{5,120}", sample_bytes)
    ]
    strings = [s for s in strings if s]
    string_counter = Counter(strings)
    top_strings = [s for s, _ in string_counter.most_common(50)]

    ngram_counter: Counter[str] = Counter()
    cap = min(len(sample_bytes), 4096)
    for i in range(max(0, cap - 2)):
        chunk = sample_bytes[i : i + 3]
        ngram_counter[chunk.hex()] += 1

    return {
        "top_strings": top_strings,
        "string_count": len(strings),
        "byte_3grams_top": [k for k, _ in ngram_counter.most_common(30)],
    }


def extract_opcode_indicators(disassembly_text: str) -> Dict[str, Any]:
    common_opcodes = {
        "mov",
        "push",
        "pop",
        "call",
        "jmp",
        "cmp",
        "xor",
        "lea",
        "int",
        "syscall",
        "ret",
        "test",
        "add",
        "sub",
    }
    words = re.findall(r"[A-Za-z_][A-Za-z0-9_]*", disassembly_text.lower())
    opcode_counter = Counter(w for w in words if w in common_opcodes)
    return {
        "opcodes_top": [k for k, _ in opcode_counter.most_common(20)],
        "opcode_counts": dict(opcode_counter),
    }


def extract_suspicious_keywords(text_content: str) -> List[str]:
    keywords = [
        "powershell",
        "cmd.exe",
        "wmic",
        "reg add",
        "rundll32",
        "base64",
        "download",
        "http://",
        "https://",
        "socket",
        "c2",
        "keylogger",
        "inject",
        "persistence",
        "taskschd",
        "startup",
    ]
    lowered = text_content.lower()
    hits = [k for k in keywords if k in lowered]
    return sorted(set(hits))


def parse_file_headers_and_imports(sample_path: str) -> Dict[str, Any]:
    path = pathlib.Path(sample_path)
    if not path.exists() or not path.is_file():
        return {"format": "unknown", "imports": [], "error": "file not found"}

    raw = path.read_bytes()
    fmt = "unknown"
    if raw.startswith(b"MZ"):
        fmt = "pe"
    elif raw.startswith(b"\x7fELF"):
        fmt = "elf"
    elif raw.startswith(b"\xcf\xfa\xed\xfe") or raw.startswith(b"\xfe\xed\xfa\xcf"):
        fmt = "mach-o"
    elif raw.startswith(b"#!/"):
        fmt = "script"

    strings = [
        s.decode("ascii", errors="ignore")
        for s in re.findall(rb"[ -~]{4,100}", raw[:200000])
    ]
    import_like = []
    for s in strings:
        low = s.lower()
        if (
            ".dll" in low
            or ".so" in low
            or "kernel32" in low
            or "ws2_32" in low
            or "urlmon" in low
            or "wininet" in low
        ):
            import_like.append(s.strip())
    return {"format": fmt, "imports": sorted(set(import_like))[:80]}


def compute_entropy_features(sample_bytes: bytes) -> Dict[str, Any]:
    overall = _entropy(sample_bytes)
    block_size = 1024
    blocks = [
        sample_bytes[i : i + block_size]
        for i in range(0, min(len(sample_bytes), 1024 * 128), block_size)
    ]
    block_entropy = [_entropy(b) for b in blocks if b]
    if block_entropy:
        avg = round(sum(block_entropy) / len(block_entropy), 6)
        mx = max(block_entropy)
    else:
        avg = 0.0
        mx = 0.0
    return {
        "entropy_overall": overall,
        "entropy_blocks": block_entropy,
        "entropy_avg_block": avg,
        "entropy_max_block": mx,
    }


def run_feature_extraction(input_record: Dict[str, Any]) -> Dict[str, Any]:
    sample = input_record.get("sample", {})
    sample_bytes = sample.get("sample_bytes", b"")
    if not isinstance(sample_bytes, (bytes, bytearray)):
        sample_bytes = b""
    sample_bytes = bytes(sample_bytes)

    preview_text = str(sample.get("preview_text", ""))
    header_info = parse_file_headers_and_imports(str(sample.get("path", "")))
    string_patterns = extract_strings_and_byte_patterns(sample_bytes)
    entropy = compute_entropy_features(sample_bytes)
    suspicious_kw = extract_suspicious_keywords(preview_text)

    telemetry_events = input_record.get("telemetry", {}).get("events", [])
    metadata_tags = input_record.get("metadata", {}).get("tags", [])

    return {
        "sample_sha256": sample.get("sha256", ""),
        "header_info": header_info,
        "string_patterns": string_patterns,
        "entropy": entropy,
        "suspicious_keywords": suspicious_kw,
        "telemetry_events": telemetry_events if isinstance(telemetry_events, list) else [],
        "metadata_tags": metadata_tags if isinstance(metadata_tags, list) else [],
        "extracted_at": _now_utc(),
    }

