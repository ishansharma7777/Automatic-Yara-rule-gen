import hashlib
import re
from typing import Dict, Any, List

from .utils_common import _safe_filename, _yara_escape, _now_utc
from .validation import validate_yara_syntax

def extract_detection_patterns(reasoning_output: Dict[str, Any]) -> Dict[str, Any]:
    normalized = reasoning_output.get("normalized_features", {})
    context = reasoning_output.get("domain_context", {})
    reasoning = reasoning_output.get("reasoning", {})

    top_strings = list(normalized.get("top_strings", []))[:20]
    imports = [str(x) for x in normalized.get("imports", [])][:10]
    keywords = [str(x) for x in normalized.get("suspicious_keywords", [])][:10]

    selected_strings = []
    for s in top_strings:
        low = s.lower()
        if len(s) >= 6 and (
            any(k in low for k in keywords)
            or any(x in low for x in ["http", ".dll", "socket", "powershell", "cmd"])
        ):
            selected_strings.append(s)

    if not selected_strings:
        selected_strings = top_strings[:8]

    return {
        "selected_strings": selected_strings[:20],
        "import_indicators": imports,
        "keyword_indicators": keywords,
        "risk_level": reasoning.get("verdict", "unknown"),
        "family_hint": context.get("high_confidence_family", ""),
    }


def synthesize_yara_rule(
    rule_name: str, patterns: Dict[str, Any], constraints: Dict[str, Any]
) -> str:
    min_strings = int(constraints.get("min_strings", 1))
    default_condition = str(constraints.get("condition", "1 of them"))
    selected = [str(x) for x in patterns.get("selected_strings", []) if str(x).strip()]
    if not selected:
        selected = ["fallback_indicator"]

    selected = selected[:40]
    safe_name = _safe_filename(rule_name)
    family_hint = str(patterns.get("family_hint", "unknown"))
    risk_level = str(patterns.get("risk_level", "unknown"))

    strings_lines = []
    for idx, s in enumerate(selected, start=1):
        strings_lines.append(f'        $s{idx} = "{_yara_escape(s)}" nocase')

    condition = default_condition
    if min_strings > 1 and default_condition == "1 of them":
        condition = f"{min_strings} of them"

    return "\n".join(
        [
            f"rule {safe_name}",
            "{",
            "    meta:",
            '        generated_by = "cot_multi_agent_framework"',
            f'        family_hint = "{_yara_escape(family_hint)}"',
            f'        risk_level = "{_yara_escape(risk_level)}"',
            f'        generated_at = "{_now_utc()}"',
            "    strings:",
            *strings_lines,
            "    condition:",
            f"        {condition}",
            "}",
        ]
    )


def attach_explainability(
    rule_text: str, reasoning_trace: Dict[str, Any]
) -> Dict[str, Any]:
    return {
        "rule_text": rule_text,
        "explainability": {
            "reasoning_trace": reasoning_trace,
            "summary": "Rule strings are selected from high-signal indicators and domain-context matches.",
            "generated_at": _now_utc(),
        },
    }


def score_rule_confidence(
    rule_text: str, reasoning_output: Dict[str, Any]
) -> float:
    syntax = validate_yara_syntax(rule_text)
    score = float(reasoning_output.get("reasoning", {}).get("suspicious_score", 0.0))
    string_hits = len(re.findall(r"^\s*\$s\d+\s*=", rule_text, flags=re.MULTILINE))
    score += min(0.3, string_hits * 0.015)
    if not syntax.get("is_valid", False):
        score *= 0.3
    return round(max(0.0, min(1.0, score)), 6)


def filter_noise_in_rules(candidate_rules: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    min_confidence = 0.35
    dedup: Dict[str, Dict[str, Any]] = {}
    for item in candidate_rules:
        rule_text = str(item.get("rule_text", ""))
        confidence = float(item.get("confidence", 0.0))
        if not rule_text or confidence < min_confidence:
            continue
        key = hashlib.sha256(rule_text.encode("utf-8", errors="ignore")).hexdigest()
        prev = dedup.get(key)
        if not prev or confidence > float(prev.get("confidence", 0.0)):
            dedup[key] = item
    return list(dedup.values())


def generate_yara_rule_package(llm_output: Dict[str, Any]) -> Dict[str, Any]:
    patterns = extract_detection_patterns(llm_output)
    risk_level = str(patterns.get("risk_level", "unknown"))
    base_name = f"{risk_level}_auto_rule"
    constraints = {"min_strings": 1, "condition": "1 of them"}
    rule_text = synthesize_yara_rule(base_name, patterns, constraints)
    confidence = score_rule_confidence(rule_text, llm_output)
    explained = attach_explainability(rule_text, llm_output.get("reasoning", {}).get("reasoning_trace", {}))

    candidates = [
        {
            "rule_name": base_name,
            "rule_text": explained["rule_text"],
            "confidence": confidence,
            "patterns": patterns,
            "explainability": explained["explainability"],
        }
    ]
    filtered = filter_noise_in_rules(candidates)
    final = filtered[0] if filtered else candidates[0]
    return {
        "rule_name": final["rule_name"],
        "rule_text": final["rule_text"],
        "confidence": final["confidence"],
        "patterns": final["patterns"],
        "explainability": final["explainability"],
        "generated_at": _now_utc(),
    }
