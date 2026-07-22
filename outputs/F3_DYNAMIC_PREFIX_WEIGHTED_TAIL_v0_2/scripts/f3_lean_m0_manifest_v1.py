#!/usr/bin/env python3
"""Create and verify the F3 Lean M0 custody manifest."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
MANIFEST = ROOT / "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_LEAN_M0_MANIFEST_v1.json"

FILES = (
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_LEAN_M0_BUDGET_v1.md",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_LEAN_M0_PRECHECK_v1.json",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_LEAN_M0A_GENERATION_SUMMARY_v1.json",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_lean_m0_generate_certificate.py",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_lean_m0_manifest_v1.py",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_LEAN_M0A_v1/F3_LEAN_M0A_REPORT_v1.md",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_LEAN_M0A_v1/axiom_audit.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_LEAN_M0A_v1/certificate_compile.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_LEAN_M0B_PILOT_v1/F3_LEAN_M0B_PILOT_REPORT_v1.md",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_LEAN_M0B_PILOT_v1/axiom_audit.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_LEAN_M0B_PILOT_v1/pilot_compile.txt",
    "CollatzClassical/KL2003/F3ReturnExcursionM0ACertificate.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionM0ACertificateAxiomAudit.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionM0BPilot.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionM0BPilotAxiomAudit.lean",
)


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def records() -> list[dict[str, object]]:
    result = []
    for rel in FILES:
        path = ROOT / rel
        if not path.is_file():
            raise SystemExit(f"missing manifest input: {rel}")
        result.append({"path": rel, "bytes": path.stat().st_size, "sha256": digest(path)})
    return result


def main() -> None:
    payload = {
        "manifest_version": "F3_LEAN_M0_MANIFEST_v1",
        "base_commit": "98d073a07e6be26d9748049f353605579847b0e4",
        "scope": "F3 M0-a certificate checker + M0-b isolated pilot",
        "budgets": {
            "m0a_seconds": 1800,
            "m0b_pilot_seconds": 600,
            "global_seconds": 2400,
        },
        "statuses": {
            "m0a": "PASS_CERTIFICATE_CHECKER_ONLY",
            "m0b": "PASS_PILOT_ONLY",
            "formal_rho_certificate": "NO",
            "density_theorem": "NO",
            "global_collatz_claim": "NO",
        },
        "files": records(),
    }
    MANIFEST.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    failures = []
    for record in payload["files"]:
        path = ROOT / record["path"]
        if path.stat().st_size != record["bytes"] or digest(path) != record["sha256"]:
            failures.append(record["path"])
    result = {"manifest": str(MANIFEST), "checked_files": len(payload["files"]), "failure_count": len(failures), "failures": failures}
    print(json.dumps(result, indent=2))
    if failures:
        raise SystemExit("F3 LEAN M0 MANIFEST VALIDATION FAILED")
    print("F3 LEAN M0 MANIFEST VALIDATION PASS")


if __name__ == "__main__":
    main()
