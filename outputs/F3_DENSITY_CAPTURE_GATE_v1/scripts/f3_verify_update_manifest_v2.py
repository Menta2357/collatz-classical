#!/usr/bin/env python3
"""Verify the F3 update manifest and enforce its path allowlist."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[3]
MANIFEST = REPO_ROOT / "outputs/F3_DENSITY_CAPTURE_GATE_v1/F3_UPDATE_MANIFEST_v2.json"
FORBIDDEN = ("outputs/KL2003_", "scripts/kl2003_", "CollatzClassical/KL2003/")
REQUIRED = (
    "outputs/F3_DENSITY_CAPTURE_GATE_v1/F3_CURRENT_STATUS_v2.json",
    "outputs/F3_DENSITY_CAPTURE_GATE_v1/F3_CLAUDE_REVIEW_PACKET_v3.md",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_PAPER_CONSOLIDATED_v3_1.md",
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    data = json.loads(MANIFEST.read_text(encoding="utf-8"))
    records = {record["path"]: record for record in data["files"]}
    failures: list[str] = []
    for path_text, record in records.items():
        if any(path_text.startswith(prefix) for prefix in FORBIDDEN):
            failures.append(f"forbidden path: {path_text}")
            continue
        path = REPO_ROOT / path_text
        if not path.is_file():
            failures.append(f"missing: {path_text}")
            continue
        if path.stat().st_size != record["bytes"]:
            failures.append(f"size mismatch: {path_text}")
        if sha256(path) != record["sha256"]:
            failures.append(f"hash mismatch: {path_text}")
    for required in REQUIRED:
        if required not in records:
            failures.append(f"required file absent from manifest: {required}")
    if "outputs/F3_DENSITY_CAPTURE_GATE_v1/PACKAGE_MANIFEST_v1.json" not in records:
        failures.append("historical PACKAGE_MANIFEST_v1.json not represented")
    result = {
        "checked_files": len(records),
        "failure_count": len(failures),
        "failures": failures,
        "manifest": str(MANIFEST),
    }
    print(json.dumps(result, indent=2))
    if failures:
        raise SystemExit("F3 UPDATE MANIFEST VALIDATION FAILED")
    print("F3 UPDATE MANIFEST VALIDATION PASS")


if __name__ == "__main__":
    main()
