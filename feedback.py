from typing import Dict, Any, List
from .utils_common import _now_utc

from .input import (
    ingest_malware_sample,
    ingest_telemetry,
    ingest_metadata,
    build_input_record,
)

from .features import run_feature_extraction
from .preprocessing import preprocess_and_normalize
from .engine import run_cot_llm_engine
from .rule import generate_yara_rule_package
from .validation import validate_and_gate_rule
from .deployment import deploy_validated_rule

# 8. FEEDBACK & CONTINUOUS LEARNING LOOP
def collect_analyst_feedback(
    rule_id: str, verdict: str, notes: str
) -> Dict[str, Any]:
    verdict_norm = verdict.strip().lower()
    if verdict_norm not in {"true_positive", "false_positive", "false_negative", "true_negative"}:
        verdict_norm = "unclassified"
    return {
        "type": "analyst_feedback",
        "rule_id": rule_id,
        "verdict": verdict_norm,
        "notes": notes.strip(),
        "timestamp": _now_utc(),
    }


def collect_runtime_feedback(rule_id: str, telemetry_event: Dict[str, Any]) -> Dict[str, Any]:
    event = telemetry_event if isinstance(telemetry_event, dict) else {}
    return {
        "type": "runtime_feedback",
        "rule_id": rule_id,
        "matched": bool(event.get("matched", False)),
        "latency_ms": float(event.get("latency_ms", 0.0)),
        "host": str(event.get("host", "unknown")),
        "timestamp": _now_utc(),
        "raw_event": event,
    }


def refine_rules_with_feedback(
    rule_repository_state: Dict[str, Any], feedback_batch: List[Dict[str, Any]]
) -> Dict[str, Any]:
    state = dict(rule_repository_state) if isinstance(rule_repository_state, dict) else {}
    rules = state.setdefault("rules", {})

    for item in feedback_batch:
        if not isinstance(item, dict):
            continue
        rule_id = str(item.get("rule_id", "")).strip()
        if not rule_id:
            continue
        r = rules.setdefault(rule_id, {"confidence_adjustment": 0.0, "disable": False, "feedback_count": 0})
        r["feedback_count"] = int(r.get("feedback_count", 0)) + 1
        verdict = str(item.get("verdict", "")).lower()
        if verdict == "false_positive":
            r["confidence_adjustment"] = float(r.get("confidence_adjustment", 0.0)) - 0.05
        elif verdict == "true_positive":
            r["confidence_adjustment"] = float(r.get("confidence_adjustment", 0.0)) + 0.03
        if float(r.get("confidence_adjustment", 0.0)) < -0.3:
            r["disable"] = True

    state["refined_at"] = _now_utc()
    return state


def update_model_and_manage_drift(
    model_state: Dict[str, Any], drift_report: Dict[str, Any]
) -> Dict[str, Any]:
    state = dict(model_state) if isinstance(model_state, dict) else {}
    state["model_version"] = int(state.get("model_version", 0)) + 1
    state["last_drift_report"] = drift_report
    drift_detected = bool(drift_report.get("drift_detected", False))
    threshold = float(state.get("suspicion_threshold", 0.5))
    if drift_detected:
        threshold = min(0.9, threshold + 0.05)
    else:
        threshold = max(0.3, threshold - 0.01)
    state["suspicion_threshold"] = round(threshold, 6)
    state["updated_at"] = _now_utc()
    return state


def run_continuous_learning_loop(system_state: Dict[str, Any]) -> Dict[str, Any]:
    state = dict(system_state) if isinstance(system_state, dict) else {}
    feedback_batch = list(state.get("feedback_batch", []))
    repo_state = dict(state.get("rule_repository_state", {}))
    model_state = dict(state.get("model_state", {}))
    drift_report = dict(state.get("drift_report", {}))

    refined_repo = refine_rules_with_feedback(repo_state, feedback_batch)
    updated_model = update_model_and_manage_drift(model_state, drift_report)
    return {
        "rule_repository_state": refined_repo,
        "model_state": updated_model,
        "processed_feedback_count": len(feedback_batch),
        "loop_completed_at": _now_utc(),
    }


# END-TO-END ORCHESTRATION
def run_end_to_end_pipeline(sample_path: str) -> Dict[str, Any]:
    sample = ingest_malware_sample(sample_path)
    telemetry = ingest_telemetry({})
    metadata = ingest_metadata({})
    input_record = build_input_record(sample, telemetry, metadata)

    features = run_feature_extraction(input_record)
    preprocessed = preprocess_and_normalize(features)
    llm_output = run_cot_llm_engine(preprocessed)
    llm_output["normalized_features"] = preprocessed.get("normalized_features", {})

    rule_package = generate_yara_rule_package(llm_output)
    validated = validate_and_gate_rule(rule_package)
    deployment_result = deploy_validated_rule(validated)

    return {
        "input_record": input_record,
        "features": features,
        "preprocessed": preprocessed,
        "llm_output": llm_output,
        "rule_package": rule_package,
        "validated_rule": validated,
        "deployment_result": deployment_result,
        "completed_at": _now_utc(),
    }

