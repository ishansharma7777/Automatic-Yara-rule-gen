import pathlib
import re
import time
from typing import Dict, Any
from .utils_common import _now_utc, _sha256_bytes

def ingest_malware_sample(sample_path: str) -> Dict[str, Any]:
    path = pathlib.Path(sample_path)
    if not path.exists() or not path.is_file():
        return {
            "ok": False,
            "path": sample_path,
            "error": "sample file not found",
            "ingested_at": _now_utc(),
        }

    raw = path.read_bytes()
    preview = " ".join(
        s.decode("ascii", errors="ignore")
        for s in re.findall(rb"[ -~]{6,48}", raw[:8192])[:10]
    )

    return {
        "ok": True,
        "path": str(path),
        "filename": path.name,
        "extension": path.suffix.lower(),
        "size_bytes": len(raw),
        "sha256": _sha256_bytes(raw),
        "sample_bytes": raw,
        "preview_text": preview,
        "ingested_at": _now_utc(),
    }


def ingest_telemetry(telemetry_payload: Dict[str, Any]) -> Dict[str, Any]:
    payload = telemetry_payload if isinstance(telemetry_payload, dict) else {}
    events = payload.get("events", [])
    if not isinstance(events, list):
        events = [events]
    return {
        "ok": True,
        "events": events,
        "host": str(payload.get("host", "unknown")),
        "source": str(payload.get("source", "local")),
        "received_at": _now_utc(),
        "raw": payload,
    }


def ingest_metadata(metadata_payload: Dict[str, Any]) -> Dict[str, Any]:
    payload = metadata_payload if isinstance(metadata_payload, dict) else {}
    return {
        "ok": True,
        "threat_intel": payload.get("threat_intel", {}),
        "sandbox_report": payload.get("sandbox_report", {}),
        "tags": payload.get("tags", []),
        "received_at": _now_utc(),
        "raw": payload,
    }


def build_input_record(
    malware_sample: Dict[str, Any],
    telemetry: Dict[str, Any],
    metadata: Dict[str, Any],
) -> Dict[str, Any]:
    sample_sha = malware_sample.get("sha256", "unknown")
    return {
        "record_id": f"record_{sample_sha[:12]}_{int(time.time())}",
        "sample": malware_sample,
        "telemetry": telemetry,
        "metadata": metadata,
        "created_at": _now_utc(),
    }
