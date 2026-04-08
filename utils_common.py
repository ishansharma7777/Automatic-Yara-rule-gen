import hashlib
import time
import re
import math
from collections import Counter
from typing import Any, List

def _now_utc() -> str:
    return time.strftime("%Y-%m-%d %H:%M:%S UTC", time.gmtime())

def _sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()

def _yara_escape(value: str) -> str:
    return value.replace("\\", "\\\\").replace('"', '\\"')

def _safe_filename(value: str) -> str:
    out = re.sub(r"[^A-Za-z0-9_]", "_", value)
    if not out:
        out = "rule"
    if out[0].isdigit():
        out = f"_{out}"
    return out

def _flatten_tokens(data: Any, prefix: str = "") -> List[str]:
    tokens: List[str] = []
    if isinstance(data, dict):
        for key, value in sorted(data.items()):
            p = f"{prefix}.{key}" if prefix else str(key)
            tokens.extend(_flatten_tokens(value, p))
    elif isinstance(data, list):
        for idx, value in enumerate(data):
            p = f"{prefix}[{idx}]"
            tokens.extend(_flatten_tokens(value, p))
    else:
        text = str(data).strip()
        if text:
            tokens.append(f"{prefix}:{text}" if prefix else text)
    return tokens

def _entropy(data: bytes) -> float:
    if not data:
        return 0.0
    freq = Counter(data)
    total = len(data)
    ent = 0.0
    for count in freq.values():
        p = count / total
        ent -= p * math.log2(p)
    return round(ent, 6)