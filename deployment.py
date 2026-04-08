import json
import pathlib
import re
from typing import Dict, Any, List

from .utils_common import _safe_filename, _now_utc

def store_rule_in_repository(
    rule_package: Dict[str, Any], repository_path: str
) -> Dict[str, Any]:
    repo = pathlib.Path(repository_path)
    repo.mkdir(parents=True, exist_ok=True)

    rule_name = _safe_filename(str(rule_package.get("rule_name", "generated_rule")))
    rule_text = str(rule_package.get("rule_text", ""))
    rule_file = repo / f"{rule_name}.yar"
    meta_file = repo / f"{rule_name}.json"

    rule_file.write_text(rule_text, encoding="utf-8")
    meta_file.write_text(json.dumps(rule_package, indent=2, ensure_ascii=True), encoding="utf-8")

    return {
        "stored": True,
        "rule_path": str(rule_file),
        "meta_path": str(meta_file),
        "stored_at": _now_utc(),
    }


def prepare_versioned_rule_artifact(
    rule_package: Dict[str, Any], version_tag: str
) -> Dict[str, Any]:
    return {
        "artifact_id": f"{rule_package.get('rule_name', 'rule')}:{version_tag}",
        "version": version_tag,
        "rule_package": rule_package,
        "created_at": _now_utc(),
    }


def adapt_rule_for_endpoint(
    rule_text: str, endpoint_profile: Dict[str, Any]
) -> str:
    max_strings = int(endpoint_profile.get("max_strings", 20))
    lines = rule_text.splitlines()
    output: List[str] = []
    string_count = 0
    in_strings = False

    for line in lines:
        stripped = line.strip().lower()
        if stripped == "strings:":
            in_strings = True
            output.append(line)
            continue
        if stripped == "condition:":
            in_strings = False
            output.append(line)
            continue

        if in_strings and re.match(r"^\$s\d+\s*=", line.strip()):
            string_count += 1
            if string_count > max_strings:
                continue

        output.append(line)

    return "\n".join(output)


def distribute_rule_to_endpoints(
    rule_artifact: Dict[str, Any], endpoint_targets: List[str]
) -> Dict[str, Any]:
    dispatch = []
    for endpoint in endpoint_targets:
        dispatch.append(
            {
                "endpoint": endpoint,
                "artifact_id": rule_artifact.get("artifact_id", ""),
                "status": "queued",
                "queued_at": _now_utc(),
            }
        )
    return {"dispatched": dispatch, "count": len(dispatch)}


def deploy_validated_rule(validated_rule_package: Dict[str, Any]) -> Dict[str, Any]:
    if validated_rule_package.get("gate_status") != "approved":
        return {"deployed": False, "reason": "rule_not_approved", "details": validated_rule_package}

    stored = store_rule_in_repository(validated_rule_package, "rules_repo")
    artifact = prepare_versioned_rule_artifact(validated_rule_package, "v1")
    delivery = distribute_rule_to_endpoints(artifact, ["endpoint-a", "endpoint-b"])
    return {
        "deployed": True,
        "storage": stored,
        "artifact": artifact,
        "delivery": delivery,
        "deployed_at": _now_utc(),
    }

