#!/usr/bin/env python3
"""Create and verify custody for the Real pilot and semantic bridge."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
MANIFEST = ROOT / "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_LEAN_M0B_REAL_BRIDGE_MANIFEST_v1.json"
FILES = (
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_LEAN_M0B_REAL_PILOT_BUDGET_v1.md",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_LEAN_M0B_REAL_PRECHECK_v1.json",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_LEAN_M0B_REAL_PILOT_v1/F3_LEAN_M0B_REAL_PILOT_REPORT_v1.md",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_LEAN_M0B_REAL_PILOT_v1/pilot_compile.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_LEAN_M0B_REAL_PILOT_v1/axiom_audit.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_LEAN_M0B_REAL_PILOT_v1/pilot_compile_latest.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_LEAN_M0B_REAL_PILOT_v1/axiom_audit_latest.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_SEMANTIC_BRIDGE_v1/F3_SEMANTIC_BRIDGE_REPORT_v1.md",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_SEMANTIC_BRIDGE_v1/bridge_compile.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_SEMANTIC_BRIDGE_v1/axiom_audit.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_SEMANTIC_INVENTORY_v1/F3_SEMANTIC_INVENTORY_REPORT_v1.md",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_SEMANTIC_INVENTORY_v1/inventory_compile.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_SEMANTIC_INVENTORY_v1/axiom_audit.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_REAL_OPERATOR_BRIDGE_v1/F3_REAL_OPERATOR_BRIDGE_REPORT_v1.md",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_REAL_OPERATOR_BRIDGE_v1/bridge_compile.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_REAL_OPERATOR_BRIDGE_v1/axiom_audit.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_REAL_OPERATOR_BRIDGE_v1/iterate_bridge_compile.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_REAL_OPERATOR_BRIDGE_v1/iterate_bridge_axiom_audit.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_LEAN_M0B_REAL_OPERATOR_INSTANCE_BUDGET_v1.md",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_EXACT_CORE_MATRIX_SUMMARY_v1.json",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_EXACT_CORE_MATRIX_v1/F3_EXACT_CORE_MATRIX_REPORT_v1.md",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_EXACT_CORE_MATRIX_v1/matrix_compile.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_EXACT_CORE_MATRIX_v1/axiom_audit.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_generate_exact_core_matrix_v1.py",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_orientation_audit_v1.py",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_ORIENTATION_AUDIT_v1/F3_ORIENTATION_AUDIT_REPORT_v1.md",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_ORIENTATION_AUDIT_v1/orientation_rows.csv",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_ORIENTATION_AUDIT_v1/summary.json",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_ORIENTATION_AUDIT_v1/manifest_sha256.csv",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_ORIENTATION_AUDIT_v1/axiom_audit.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_ORIENTATION_AUDIT_v1/orientation_compile.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_ORIENTATION_AUDIT_v1/axiom_audit_latest.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_ORIENTATION_AUDIT_v1/orientation_compile_latest.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_SEMANTIC_INVENTORY_SUMMARY_v1.json",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_lean_m0b_real_bridge_manifest_v1.py",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_generate_semantic_inventory_v1.py",
    "CollatzClassical/KL2003/F3ReturnExcursionM0BRealPilot.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionM0BRealPilotAxiomAudit.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionSemanticBridge.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionSemanticBridgeAxiomAudit.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionRealIterateBridge.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionRealIterateBridgeAxiomAudit.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionFrozenSemanticInventory.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionFrozenSemanticInventoryAxiomAudit.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionRealOperatorBridge.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionRealOperatorBridgeAxiomAudit.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionExactCoreMatrix.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionExactCoreMatrixAxiomAudit.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionExactCoreMatrixOrientation.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionExactCoreMatrixOrientationAxiomAudit.lean",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CHANNEL_SCALAR_BOUNDS_v1/F3_CHANNEL_SCALAR_BOUNDS_REPORT_v1.md",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CHANNEL_SCALAR_BOUNDS_v1/channel_compile.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CHANNEL_SCALAR_BOUNDS_v1/channel_axiom_audit.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CHANNEL_SCALAR_BOUNDS_v1/exact_matrix_channel_compile.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CHANNEL_SCALAR_BOUNDS_v1/exact_matrix_channel_axiom_audit.txt",
    "CollatzClassical/KL2003/F3ReturnExcursionChannelBounds.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionExactCoreMatrixChannelBounds.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionExactCoreMatrixChannelBoundsAxiomAudit.lean",
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    records = []
    for rel in FILES:
        path = ROOT / rel
        if not path.is_file():
            raise SystemExit(f"missing: {rel}")
        records.append({"path": rel, "bytes": path.stat().st_size, "sha256": sha256(path)})
    payload = {
        "manifest_version": "F3_LEAN_M0B_REAL_BRIDGE_MANIFEST_v1",
        "base_commit": "ad1a1d7b9eb8cf5af7250fff951537c17aeee0fe",
        "real_pilot_budget_seconds": 900,
        "operator_instance_budget_seconds": 600,
        "scope": [
            "Real renewal pilot",
            "rule-to-piStar semantic bridge API",
            "exact 243-state core matrix representation"
        ],
        "statuses": {
            "real_pilot": "REAL_RENEWAL_LEMMA_PILOT_PASS",
            "semantic_bridge": "RULE_TO_PISTAR_FINSET_CARD_BRIDGE_PASS_COVERAGE_OPEN",
            "semantic_inventory": "1215_ROWS_NATIVE_DECIDE_PASS",
            "exact_core_matrix": "EXACT_MATRIX_DEFINED_ORIENTATION_AUDIT_REOPENED_SCALAR_COMPATIBILITY_PASS",
            "row_certificate": "BLOCKED_BY_ORIENTATION_CONVENTION_AUDIT",
            "orientation_audit": "ORIENTATION_CONVENTION_REOPENED",
            "real_operator_bridge": "REAL_OPERATOR_ITERATED_MASS_BRIDGE_PASS_ORIENTATION_OPEN",
            "rho_certificate": "NO",
            "density_theorem": "NO",
            "global_collatz_claim": "NO",
        },
        "files": records,
    }
    MANIFEST.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    failures = []
    for record in records:
        path = ROOT / record["path"]
        if path.stat().st_size != record["bytes"] or sha256(path) != record["sha256"]:
            failures.append(record["path"])
    print(json.dumps({"manifest": str(MANIFEST), "checked_files": len(records), "failure_count": len(failures), "failures": failures}, indent=2))
    if failures:
        raise SystemExit("REAL/BRIDGE MANIFEST VALIDATION FAILED")
    print("REAL/BRIDGE MANIFEST VALIDATION PASS")


if __name__ == "__main__":
    main()
