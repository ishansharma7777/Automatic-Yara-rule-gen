import re
from typing import Dict, Any, List

from .utils_common import _now_utc

def validate_yara_syntax(rule_text: str) -> Dict[str, Any]:
    errors: List[str] = []
    stripped = rule_text.strip()
    if not stripped.startswith("rule "):
        errors.append("missing_rule_declaration")
    if "{" not in stripped or "}" not in stripped:
        errors.append("missing_braces")
    if stripped.count("{") != stripped.count("}"):
        errors.append("unbalanced_braces")
    if "strings:" not in stripped:
        errors.append("missing_strings_section")
    if "condition:" not in stripped:
        errors.append("missing_condition_section")
    if not re.search(r"^\s*\$s\d+\s*=", stripped, flags=re.MULTILINE):
        errors.append("no_string_indicators")
    return {"is_valid": len(errors) == 0, "errors": errors}


def estimate_rule_performance(
    rule_text: str, benchmark_corpus: Dict[str, Any]
) -> Dict[str, Any]:
    total = int(benchmark_corpus.get("total_samples", 0))
    malicious = int(benchmark_corpus.get("malicious_samples", 0))
    matched = int(benchmark_corpus.get("matched_samples", 0))
    complexity = len(rule_text.splitlines())
    if total <= 0:
        precision = 0.0
        recall = 0.0
    else:
        precision = matched / max(1, total)
        recall = matched / max(1, malicious if malicious > 0 else total)

    estimated_latency_ms = round(0.1 * complexity + 0.05 * rule_text.count("$s"), 4)
    return {
        "estimated_precision": round(precision, 6),
        "estimated_recall": round(recall, 6),
        "estimated_latency_ms": estimated_latency_ms,
        "complexity_lines": complexity,
    }


def estimate_false_positive_rate(
    rule_text: str, benign_corpus: Dict[str, Any]
) -> Dict[str, Any]:
    benign_total = int(benign_corpus.get("total_benign", 0))
    benign_matches = int(benign_corpus.get("matched_benign", 0))
    if benign_total <= 0:
        fpr = 0.0
    else:
        fpr = benign_matches / benign_total
    return {"estimated_fpr": round(fpr, 6), "benign_total": benign_total}


def detect_rule_drift(rule_id: str, telemetry_stream: List[Dict[str, Any]]) -> Dict[str, Any]:
    rates: List[float] = []
    for event in telemetry_stream:
        if not isinstance(event, dict):
            continue
        if str(event.get("rule_id", "")) != rule_id:
            continue
        rate = event.get("detection_rate")
        if isinstance(rate, (int, float)):
            rates.append(float(rate))

    if len(rates) < 4:
        return {"rule_id": rule_id, "drift_score": 0.0, "drift_detected": False}

    half = len(rates) // 2
    baseline = sum(rates[:half]) / max(1, half)
    recent = sum(rates[half:]) / max(1, len(rates) - half)
    drift_score = abs(recent - baseline)
    return {
        "rule_id": rule_id,
        "baseline_rate": round(baseline, 6),
        "recent_rate": round(recent, 6),
        "drift_score": round(drift_score, 6),
        "drift_detected": drift_score >= 0.15,
    }


def run_compliance_checks(
    rule_text: str, compliance_policy: Dict[str, Any]
) -> Dict[str, Any]:
    max_len = int(compliance_policy.get("max_rule_length", 20000))
    forbidden_tokens = [str(x).lower() for x in compliance_policy.get("forbidden_tokens", ["exec", "shell"])]
    require_meta = bool(compliance_policy.get("require_meta", True))

    issues: List[str] = []
    if len(rule_text) > max_len:
        issues.append("rule_too_large")
    low = rule_text.lower()
    for token in forbidden_tokens:
        if token and token in low:
            issues.append(f"forbidden_token:{token}")
    if require_meta and "meta:" not in low:
        issues.append("missing_meta")

    return {"compliant": len(issues) == 0, "issues": issues}


def validate_and_gate_rule(rule_package: Dict[str, Any]) -> Dict[str, Any]:
    rule_text = str(rule_package.get("rule_text", ""))
    syntax = validate_yara_syntax(rule_text)
    perf = estimate_rule_performance(rule_text, {})
    fpr = estimate_false_positive_rate(rule_text, {})
    compliance = run_compliance_checks(rule_text, {})

    approved = (
        syntax.get("is_valid", False)
        and compliance.get("compliant", False)
        and float(rule_package.get("confidence", 0.0)) >= 0.25
    )

    return {
        **rule_package,
        "validation": {
            "syntax": syntax,
            "performance": perf,
            "false_positive": fpr,
            "compliance": compliance,
        },
        "gate_status": "approved" if approved else "rejected",
        "validated_at": _now_utc(),
    }

