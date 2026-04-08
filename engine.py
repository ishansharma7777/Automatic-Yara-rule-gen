import json
import pathlib
from typing import Dict, Any, List

from .utils_common import _now_utc

# CHAIN-OF-THOUGHT-ENHANCED LLM ENGINE
def load_domain_malware_knowledge_base(source_path: str) -> Dict[str, Any]:
    path = pathlib.Path(source_path)
    if path.exists() and path.is_file():
        try:
            with open(path, "r", encoding="utf-8") as f:
                data = json.load(f)
            if isinstance(data, dict):
                return data
        except Exception:
            pass

    
    return {
        "families": {
            "loader": ["download", "urlmon", "wininet", "http://", "https://"],
            "credential_stealer": ["login data", "cookies", "vault", "keylogger"],
            "ransomware": ["encrypt", "ransom", "bitcoin", "recover"],
            "backdoor": ["socket", "cmd.exe", "powershell", "c2"],
        },
        "tactics": {
            "persistence": ["startup", "taskschd", "reg add", "run key"],
            "defense_evasion": ["disable", "amsi", "uac", "bypass"],
            "command_and_control": ["c2", "socket", "beacon", "http://", "https://"],
        },
        "thresholds": {"high_entropy": 7.2, "medium_entropy": 6.5},
        "loaded_at": _now_utc(),
    }


def retrieve_domain_context(
    normalized_features: Dict[str, Any], knowledge_base: Dict[str, Any]
) -> Dict[str, Any]:
    searchable = " ".join(
        [
            " ".join(str(x).lower() for x in normalized_features.get("top_strings", [])[:100]),
            " ".join(str(x).lower() for x in normalized_features.get("suspicious_keywords", [])),
            " ".join(str(x).lower() for x in normalized_features.get("imports", [])),
        ]
    )

    families_hit: Dict[str, int] = {}
    for family, markers in knowledge_base.get("families", {}).items():
        score = sum(1 for marker in markers if str(marker).lower() in searchable)
        if score:
            families_hit[family] = score

    tactics_hit: Dict[str, int] = {}
    for tactic, markers in knowledge_base.get("tactics", {}).items():
        score = sum(1 for marker in markers if str(marker).lower() in searchable)
        if score:
            tactics_hit[tactic] = score

    return {
        "families_hit": families_hit,
        "tactics_hit": tactics_hit,
        "high_confidence_family": max(families_hit, key=families_hit.get) if families_hit else "",
        "retrieved_at": _now_utc(),
    }


def reasoning_module(
    embeddings: List[float], domain_context: Dict[str, Any]
) -> Dict[str, Any]:
    entropy_signal = sum(embeddings[:4]) / 4 if embeddings else 0.0
    behavior_signal = sum(embeddings[4:8]) / 4 if len(embeddings) >= 8 else 0.0

    ctx_weight = float(sum(domain_context.get("tactics_hit", {}).values()))
    fam_weight = float(sum(domain_context.get("families_hit", {}).values()))

    raw_score = (entropy_signal * 0.35) + (behavior_signal * 0.25) + (ctx_weight * 0.2) + (fam_weight * 0.2)
    suspicious_score = max(0.0, min(1.0, raw_score / 3.5))

    steps = [
        "Step 1: Evaluated embedding-derived entropy and behavior signals.",
        f"Step 2: Matched domain tactics ({len(domain_context.get('tactics_hit', {}))}) and families ({len(domain_context.get('families_hit', {}))}).",
        f"Step 3: Aggregated weighted evidence into suspicious score={suspicious_score:.4f}.",
    ]

    if suspicious_score >= 0.7:
        verdict = "high_risk"
    elif suspicious_score >= 0.4:
        verdict = "moderate_risk"
    else:
        verdict = "low_risk"

    return {
        "verdict": verdict,
        "suspicious_score": round(suspicious_score, 6),
        "reasoning_steps": steps,
        "reasoning_trace": {
            "entropy_signal": round(entropy_signal, 6),
            "behavior_signal": round(behavior_signal, 6),
            "ctx_weight": ctx_weight,
            "fam_weight": fam_weight,
        },
        "reasoned_at": _now_utc(),
    }


def secure_inference_sandbox(
    reasoning_input: Dict[str, Any], sandbox_config: Dict[str, Any]
) -> Dict[str, Any]:
    max_tokens = int(sandbox_config.get("max_tokens", 5000))
    deny_patterns = sandbox_config.get("deny_patterns", ["rm -rf", "subprocess", "os.system"])
    serialized = json.dumps(reasoning_input, ensure_ascii=True)

    policy_flags: List[str] = []
    if len(serialized) > max_tokens * 8:
        policy_flags.append("input_truncated")
        serialized = serialized[: max_tokens * 8]

    lowered = serialized.lower()
    for pattern in deny_patterns:
        if str(pattern).lower() in lowered:
            policy_flags.append(f"blocked_pattern:{pattern}")

    return {
        "allowed": not any(flag.startswith("blocked_pattern") for flag in policy_flags),
        "policy_flags": policy_flags,
        "sanitized_payload": json.loads(serialized) if serialized.startswith("{") else reasoning_input,
        "sandboxed_at": _now_utc(),
    }


def run_cot_llm_engine(preprocessed_data: Dict[str, Any]) -> Dict[str, Any]:
    normalized = preprocessed_data.get("normalized_features", {})
    embeddings = preprocessed_data.get("embeddings", [])

    kb = load_domain_malware_knowledge_base("knowledge_base.json")
    context = retrieve_domain_context(normalized, kb)
    reasoning = reasoning_module(embeddings, context)
    sandbox = secure_inference_sandbox(
        {
            "normalized_features": normalized,
            "context": context,
            "reasoning": reasoning,
        },
        {"max_tokens": 8000},
    )

    if not sandbox.get("allowed", False):
        reasoning["verdict"] = "blocked"
        reasoning["suspicious_score"] = 0.0
        reasoning["reasoning_steps"].append("Step 4: Sandbox blocked unsafe inference payload.")

    return {
        "domain_context": context,
        "reasoning": reasoning,
        "sandbox": sandbox,
        "llm_engine_at": _now_utc(),
    }

