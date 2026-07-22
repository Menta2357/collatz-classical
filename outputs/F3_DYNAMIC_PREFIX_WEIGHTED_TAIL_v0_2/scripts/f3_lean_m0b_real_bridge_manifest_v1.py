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
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_SEMANTIC_BRIDGE_v1/F3_SEMANTIC_BRIDGE_REPORT_v1.md",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_SEMANTIC_BRIDGE_v1/bridge_compile.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_SEMANTIC_BRIDGE_v1/axiom_audit.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_SEMANTIC_INVENTORY_v1/F3_SEMANTIC_INVENTORY_REPORT_v1.md",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_SEMANTIC_INVENTORY_v1/inventory_compile.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_SEMANTIC_INVENTORY_v1/axiom_audit.txt",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_SEMANTIC_INVENTORY_SUMMARY_v1.json",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_lean_m0b_real_bridge_manifest_v1.py",
    "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_generate_semantic_inventory_v1.py",
    "CollatzClassical/KL2003/F3ReturnExcursionM0BRealPilot.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionM0BRealPilotAxiomAudit.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionSemanticBridge.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionSemanticBridgeAxiomAudit.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionFrozenSemanticInventory.lean",
    "CollatzClassical/KL2003/F3ReturnExcursionFrozenSemanticInventoryAxiomAudit.lean",
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
        "base_commit": "515221dbf60dfff3a13da85fec423eb88fc028a8",
        "real_pilot_budget_seconds": 900,
        "scope": ["Real renewal pilot", "rule-to-piStar semantic bridge API"],
        "statuses": {
            "real_pilot": "REAL_RENEWAL_LEMMA_PILOT_PASS",
            "semantic_bridge": "RULE_TO_PISTAR_BRIDGE_FINITE_INVENTORY_PASS",
            "semantic_inventory": "1215_ROWS_NATIVE_DECIDE_PASS",
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
