import hashlib
from typing import Dict, Any, List

from .utils_common import _flatten_tokens, _now_utc
def parse_static_dynamic_features(features: Dict[str, Any]) -> Dict[str, Any]:
    static_features = {
        "header_info": features.get("header_info", {}),
        "string_patterns": features.get("string_patterns", {}),
        "entropy": features.get("entropy", {}),
        "suspicious_keywords": features.get("suspicious_keywords", []),
    }
    dynamic_features = {
        "telemetry_events": features.get("telemetry_events", []),
        "metadata_tags": features.get("metadata_tags", []),
    }
    return {
        "sample_sha256": features.get("sample_sha256", ""),
        "static_features": static_features,
        "dynamic_features": dynamic_features,
        "parsed_at": _now_utc(),
    }


def normalize_feature_schema(parsed_features: Dict[str, Any]) -> Dict[str, Any]:
    static_features = parsed_features.get("static_features", {})
    dynamic_features = parsed_features.get("dynamic_features", {})

    header_info = static_features.get("header_info", {})
    string_patterns = static_features.get("string_patterns", {})
    entropy = static_features.get("entropy", {})

    normalized = {
        "sample_sha256": parsed_features.get("sample_sha256", ""),
        "file_format": str(header_info.get("format", "unknown")),
        "imports": list(header_info.get("imports", [])),
        "top_strings": list(string_patterns.get("top_strings", [])),
        "byte_3grams_top": list(string_patterns.get("byte_3grams_top", [])),
        "suspicious_keywords": list(static_features.get("suspicious_keywords", [])),
        "entropy_overall": float(entropy.get("entropy_overall", 0.0)),
        "entropy_avg_block": float(entropy.get("entropy_avg_block", 0.0)),
        "telemetry_events": list(dynamic_features.get("telemetry_events", [])),
        "metadata_tags": list(dynamic_features.get("metadata_tags", [])),
        "normalized_at": _now_utc(),
    }
    return normalized


def tokenize_features(normalized_features: Dict[str, Any]) -> List[str]:
    tokens: List[str] = []
    for key in [
        "file_format",
        "entropy_overall",
        "entropy_avg_block",
    ]:
        if key in normalized_features:
            tokens.append(f"{key}:{normalized_features[key]}")

    for key in ["imports", "top_strings", "byte_3grams_top", "suspicious_keywords", "metadata_tags"]:
        values = normalized_features.get(key, [])
        if isinstance(values, list):
            for value in values[:100]:
                v = str(value).strip()
                if v:
                    tokens.append(f"{key}:{v}")

    telemetry = normalized_features.get("telemetry_events", [])
    if isinstance(telemetry, list):
        for event in telemetry[:100]:
            tokens.extend(_flatten_tokens(event, "telemetry"))

    return tokens


def generate_contextual_embeddings(tokens: List[str]) -> List[float]:
    """
    Deterministic lightweight embedding.
    Produces a 16-dim vector by hashing tokens and accumulating normalized values.
    """
    dims = 16
    vec = [0.0] * dims
    if not tokens:
        return vec

    for token in tokens:
        digest = hashlib.sha256(token.encode("utf-8", errors="ignore")).digest()
        for i in range(dims):
            val = digest[i] / 255.0
            vec[i] += val

    count = float(len(tokens))
    return [round(v / count, 6) for v in vec]


def preprocess_and_normalize(features: Dict[str, Any]) -> Dict[str, Any]:
    parsed = parse_static_dynamic_features(features)
    normalized = normalize_feature_schema(parsed)
    tokens = tokenize_features(normalized)
    embeddings = generate_contextual_embeddings(tokens)
    return {
        "parsed_features": parsed,
        "normalized_features": normalized,
        "tokens": tokens,
        "embeddings": embeddings,
        "preprocessed_at": _now_utc(),
    }
