#!/usr/bin/env python3
"""Create the KL2003 F2 k=2 generator regression baseline inventory.

This script records the already-proved manual k=2 formalization as
machine-readable baseline data for a future generator regression.  It does not
generate k=3 rows, does not solve an LP, and does not open new Lean modules.
Any future generator output that differs mathematically from this baseline is a
generator blocker, not a request to change the proved k=2 theorems.
"""

from __future__ import annotations

import csv
import hashlib
import json
import subprocess
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


RUN_ID = "KL2003_F2_K2_GENERATOR_REGRESSION_BASELINE_v1"
REPO_ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID

SCOPING = REPO_ROOT / "docs" / "KL2003_F2_K2_GENERATOR_REGRESSION_SCOPING_v1.md"


def repo_rel(path: Path) -> str:
    try:
        return str(path.resolve().relative_to(REPO_ROOT))
    except ValueError:
        return str(path)


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def source_commit() -> str:
    try:
        return subprocess.check_output(
            ["git", "rev-parse", "HEAD"],
            cwd=REPO_ROOT,
            text=True,
            stderr=subprocess.DEVNULL,
        ).strip()
    except (OSError, subprocess.CalledProcessError):
        return "UNKNOWN_UNCOMMITTED"


def path_status(path_text: str) -> tuple[str, str]:
    path = REPO_ROOT / path_text
    if path.exists():
        return "present", sha256(path) if path.is_file() else "directory"
    return "missing", ""


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, lineterminator="\n")
        writer.writeheader()
        for row in rows:
            encoded: dict[str, Any] = {}
            for field in fieldnames:
                value = row.get(field, "")
                if isinstance(value, (dict, list)):
                    encoded[field] = json.dumps(value, sort_keys=True)
                else:
                    encoded[field] = value
            writer.writerow(encoded)


def theorem_baseline_rows() -> list[dict[str, str]]:
    return [
        {
            "theorem": "concretePhi_rowsV3",
            "module": "CollatzClassical/KL2003/KL2003ConcretePhiRealization.lean",
            "audit_file": "CollatzClassical/KL2003/KL2003ConcretePhiRealizationAxiomAudit.lean",
            "role": "concrete rows V3 seam",
            "baseline_status": "proved_manual_k2",
            "source_faithful_contract": "V3",
        },
        {
            "theorem": "concretePhi_retarded_lower_bound",
            "module": "CollatzClassical/KL2003/KL2003ConcretePhiRealization.lean",
            "audit_file": "CollatzClassical/KL2003/KL2003ConcretePhiRealizationAxiomAudit.lean",
            "role": "instantiates M0C V3 with concrete Phi",
            "baseline_status": "proved_manual_k2",
            "source_faithful_contract": "V3",
        },
        {
            "theorem": "m0c_retarded_induction_bound_v3",
            "module": "CollatzClassical/KL2003/KL2003M0CRetardedInduction.lean",
            "audit_file": "CollatzClassical/KL2003/KL2003M0CRetardedInductionAxiomAudit.lean",
            "role": "abstract retarded induction over rows V3",
            "baseline_status": "proved_manual_k2",
            "source_faithful_contract": "V3",
        },
        {
            "theorem": "kl2003_k2_m1_surrogate_ceil_window_lower_bound",
            "module": "CollatzClassical/KL2003/KL2003M1Surrogate.lean",
            "audit_file": "CollatzClassical/KL2003/KL2003M1SurrogateAxiomAudit.lean",
            "role": "technical ceil-window k=2 M1-surrogate theorem",
            "baseline_status": "proved_manual_k2",
            "source_faithful_contract": "V3",
        },
        {
            "theorem": "kl2003_k2_m1_surrogate_arbitrary_x_lower_bound",
            "module": "CollatzClassical/KL2003/KL2003M1Surrogate.lean",
            "audit_file": "CollatzClassical/KL2003/KL2003M1SurrogateAxiomAudit.lean",
            "role": "arbitrary large-x k=2 M1-surrogate theorem",
            "baseline_status": "proved_manual_k2",
            "source_faithful_contract": "V3",
        },
        {
            "theorem": "kl2003_k2_m1_surrogate_root8_lower_bound",
            "module": "CollatzClassical/KL2003/KL2003M1Surrogate.lean",
            "audit_file": "CollatzClassical/KL2003/KL2003M1SurrogateAxiomAudit.lean",
            "role": "public root-8 k=2 M1-surrogate instance",
            "baseline_status": "proved_manual_k2",
            "source_faithful_contract": "V3",
        },
    ]


def expected_rows_v3() -> list[dict[str, str]]:
    return [
        {
            "row_id": "row22",
            "source_class": "22",
            "tracked_residue_mod9": "2",
            "row_family": "D1",
            "expected_shape": "two-branch with retarded branch plus advanced branch using parity lift",
            "required_feature": "row22 parity lift",
            "v3_requirement": "unchanged from source-faithful k2 seam",
            "generator_blocker_if_missing": "yes",
            "baseline_refs": "concretePhi_row22_seam; d1_core_instantiation",
        },
        {
            "row_id": "row25",
            "source_class": "25",
            "tracked_residue_mod9": "5",
            "row_family": "D2",
            "expected_shape": "single-branch retarded row; no advanced contribution",
            "required_feature": "row25 single-branch",
            "v3_requirement": "advanced branch absent; D2 is immune to advanced rounding",
            "generator_blocker_if_missing": "yes",
            "baseline_refs": "concretePhi_row25_seam; d2_single_branch_core_instantiation",
        },
        {
            "row_id": "row28",
            "source_class": "28",
            "tracked_residue_mod9": "8",
            "row_family": "D3 / EL",
            "expected_shape": "two-branch row with nested EL block and row28 c-prime split",
            "required_feature": "row28 c' split / post-deletion behavior",
            "v3_requirement": "M1V3 uses phi25, not phi22",
            "generator_blocker_if_missing": "yes",
            "baseline_refs": "concretePhi_row28_seam_v3; row28_pointwise_seam_v3_mod8; I2ELAbstractRowsV3",
        },
        {
            "row_id": "M1V3",
            "source_class": "row28 nested block",
            "tracked_residue_mod9": "nested",
            "row_family": "EL auxiliary",
            "expected_shape": "min(phi28 + M2V3, phi25)",
            "required_feature": "meta-errata phi25 reinstated",
            "v3_requirement": "second arm is phi25; phi22 form is historical V2 only",
            "generator_blocker_if_missing": "yes",
            "baseline_refs": "M1V3; docs/KL2003_META_ERRATA_M1_PHI5_REINSTATEMENT_v1.md",
        },
    ]


def certificate_constants() -> list[dict[str, str]]:
    return [
        {
            "constant_id": "lambda",
            "lean_name": "lambdaR",
            "value": "27/20",
            "kind": "lambda",
            "source": "KL2003K2AlphaBounds.lean",
            "must_reproduce_exactly": "yes",
            "notes": "k=2 surrogate lambda",
        },
        {
            "constant_id": "gammaK2",
            "lean_name": "gammaK2",
            "value": "logb 2 (27/20)",
            "kind": "exponent",
            "source": "KL2003M1Surrogate.lean",
            "must_reproduce_exactly": "yes",
            "notes": "also proves gammaK2 > 3/7",
        },
        {
            "constant_id": "DeltaV2",
            "lean_name": "DeltaV2",
            "value": "(20/27)^14/2",
            "kind": "base_constant",
            "source": "KL2003M0CRetardedInduction.lean",
            "must_reproduce_exactly": "yes",
            "notes": "equivalent to 1/(2*lambdaR^14)",
        },
        {
            "constant_id": "c22",
            "lean_name": "c22R",
            "value": "73/40",
            "kind": "row_coefficient",
            "source": "KL2003M0CRetardedInduction.lean",
            "must_reproduce_exactly": "yes",
            "notes": "class 2 coefficient",
        },
        {
            "constant_id": "c25",
            "lean_name": "c25R",
            "value": "1001/1000",
            "kind": "row_coefficient",
            "source": "KL2003M0CRetardedInduction.lean",
            "must_reproduce_exactly": "yes",
            "notes": "class 5 coefficient; source-faithful M1V3 arm",
        },
        {
            "constant_id": "c28",
            "lean_name": "c28R",
            "value": "69/40",
            "kind": "row_coefficient",
            "source": "KL2003M0CRetardedInduction.lean",
            "must_reproduce_exactly": "yes",
            "notes": "class 8 coefficient",
        },
        {
            "constant_id": "L2NT_D1_slack",
            "lean_name": "L2NT_D1_slack",
            "value": "29/9720",
            "kind": "slack",
            "source": "KL2003K2CertificateData.lean",
            "must_reproduce_exactly": "yes",
            "notes": "row22/D1 slack after B_lo endpoint unification",
        },
        {
            "constant_id": "L2NT_D2_slack",
            "lean_name": "L2NT_D2_slack",
            "value": "271/729000",
            "kind": "slack",
            "source": "KL2003K2CertificateData.lean",
            "must_reproduce_exactly": "yes",
            "notes": "row25/D2 slack",
        },
        {
            "constant_id": "L2NT_D3_slack",
            "lean_name": "L2NT_D3_slack",
            "value": "2077/145800",
            "kind": "slack",
            "source": "KL2003K2CertificateData.lean",
            "must_reproduce_exactly": "yes",
            "notes": "row28/D3 slack",
        },
    ]


def manual_baseline_inventory() -> list[dict[str, str]]:
    items = [
        ("source_doc", "docs/KL2003_F2_K2_GENERATOR_REGRESSION_SCOPING_v1.md", "regression contract for future generator"),
        ("source_doc", "docs/KL2003_AUDIT_READY_FIDELITY_PACKAGE_v1.md", "audit-ready theorem and dependency package"),
        ("source_doc", "docs/KL2003_META_ERRATA_M1_PHI5_REINSTATEMENT_v1.md", "source-fidelity correction requiring phi25 in M1V3"),
        ("source_doc", "docs/KL2003_M0C_ROWS_V3_PHI5_CONTRACT_AND_RECHECK_SCOPING_v1.md", "V3 row contract scoping"),
        ("source_doc", "docs/KL2003_M0C_ROWS_V3_PHI5_LEAN_MIGRATION_v1.md", "V3 Lean migration record"),
        ("source_doc", "docs/KL2003_ROW28_V3_MOD8_CP_SPLIT_AND_ROWSV3_FINAL_LEAN_v1.md", "row28 V3 final seam record"),
        ("source_doc", "docs/KL2003_K2_CERTIFICATE_ENDPOINT_UNIFICATION_BLO_UPGRADE_v1.md", "B_lo endpoint unification record"),
        ("lean_module", "CollatzClassical/KL2003/KL2003M0CRetardedInduction.lean", "abstract rows V3, assemblies, and induction"),
        ("lean_module", "CollatzClassical/KL2003/KL2003ConcretePhiRealization.lean", "concrete Phi seam and rows V3"),
        ("lean_module", "CollatzClassical/KL2003/KL2003M1Surrogate.lean", "final k2 surrogate theorem package"),
        ("lean_module", "CollatzClassical/KL2003/KL2003K2CertificateData.lean", "exact rational certificate constants and slacks"),
        ("audit", "CollatzClassical/KL2003/KL2003M0CRetardedInductionAxiomAudit.lean", "abstract induction axiom audit"),
        ("audit", "CollatzClassical/KL2003/KL2003ConcretePhiRealizationAxiomAudit.lean", "concrete seam axiom audit"),
        ("audit", "CollatzClassical/KL2003/KL2003M1SurrogateAxiomAudit.lean", "M1 surrogate axiom audit"),
        ("certificate_data", "CollatzClassical/KL2003/KL2003K2CertificateData.lean", "k2 rational data baseline"),
        ("output_artifact", "outputs/KL2003_K2_INTERIOR_RATIONAL_CERTIFICATE_v1", "rational certificate script outputs"),
        ("output_artifact", "outputs/KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1", "Figure A1 graph transcription custody"),
        ("output_artifact", "outputs/KL2003_ROW28_V3_LITERAL_WORD_TABLE_RECOVERY_v1", "literal table recovery attempt custody"),
    ]

    rows: list[dict[str, str]] = []
    for kind, path_text, description in items:
        status, digest = path_status(path_text)
        rows.append(
            {
                "asset_kind": kind,
                "path": path_text,
                "status": status,
                "sha256": digest,
                "description": description,
            }
        )
    return rows


def generator_regression_requirements() -> list[dict[str, str]]:
    return [
        {
            "requirement_id": "reproduce_rows_v3",
            "required": "yes",
            "pass_condition": "Generated k=2 rows match row22/row25/row28 V3 mathematical shapes.",
            "fail_classification": "K2_REGRESSION_FAIL",
            "notes": "V2 rows are not acceptable as source-faithful KL2003 baseline.",
        },
        {
            "requirement_id": "reproduce_meta_errata_phi25",
            "required": "yes",
            "pass_condition": "M1V3 second arm is phi25, not phi22.",
            "fail_classification": "K2_REGRESSION_FAIL",
            "notes": "This is the explicit meta-errata baseline.",
        },
        {
            "requirement_id": "reproduce_deletion_behavior",
            "required": "yes",
            "pass_condition": "Generated deletion marks and post-deletion behavior match Figure A1/source-custody baseline.",
            "fail_classification": "K2_REGRESSION_FAIL",
            "notes": "Format-only id differences are allowed; mathematical deletion differences are blockers.",
        },
        {
            "requirement_id": "reproduce_certificate_constants",
            "required": "yes",
            "pass_condition": "lambda, coefficients, endpoint-derived rows, and slacks match exact rational baseline.",
            "fail_classification": "K2_REGRESSION_FAIL",
            "notes": "Includes B_lo endpoint unification and final slacks.",
        },
        {
            "requirement_id": "emit_json_lean_twin_artifacts_v2",
            "required": "yes",
            "pass_condition": "Generated k=2 artifacts use schema v2 JSON plus deterministic Lean data twins with cross-hashes.",
            "fail_classification": "K2_REGRESSION_FAIL",
            "notes": "Lean consumes generated Lean data, not JSON.",
        },
        {
            "requirement_id": "any_math_diff_is_generator_blocker",
            "required": "yes",
            "pass_condition": "Every mathematical diff is classified as generator blocker, not a request to change proved k=2 theorems.",
            "fail_classification": "K2_REGRESSION_FAIL",
            "notes": "Manual k=2 is the source of truth for regression.",
        },
    ]


def manifest_rows(paths: list[Path]) -> list[dict[str, str]]:
    rows: list[dict[str, str]] = []
    for path in sorted(paths, key=lambda p: repo_rel(p)):
        rows.append({"path": repo_rel(path), "sha256": sha256(path)})
    return rows


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    generated_at = datetime.now(timezone.utc).isoformat()
    commit = source_commit()

    theorem_rows = theorem_baseline_rows()
    row_rows = expected_rows_v3()
    constants_rows = certificate_constants()
    inventory_rows = manual_baseline_inventory()
    requirements_rows = generator_regression_requirements()

    theorem_path = OUT_DIR / "theorem_baseline.csv"
    rows_path = OUT_DIR / "expected_rows_v3.csv"
    constants_path = OUT_DIR / "certificate_constants.csv"
    inventory_path = OUT_DIR / "manual_baseline_inventory.csv"
    requirements_path = OUT_DIR / "generator_regression_requirements.csv"
    summary_path = OUT_DIR / "summary.json"
    manifest_path = OUT_DIR / "manifest_sha256.csv"

    write_csv(
        theorem_path,
        theorem_rows,
        ["theorem", "module", "audit_file", "role", "baseline_status", "source_faithful_contract"],
    )
    write_csv(
        rows_path,
        row_rows,
        [
            "row_id",
            "source_class",
            "tracked_residue_mod9",
            "row_family",
            "expected_shape",
            "required_feature",
            "v3_requirement",
            "generator_blocker_if_missing",
            "baseline_refs",
        ],
    )
    write_csv(
        constants_path,
        constants_rows,
        ["constant_id", "lean_name", "value", "kind", "source", "must_reproduce_exactly", "notes"],
    )
    write_csv(
        inventory_path,
        inventory_rows,
        ["asset_kind", "path", "status", "sha256", "description"],
    )
    write_csv(
        requirements_path,
        requirements_rows,
        ["requirement_id", "required", "pass_condition", "fail_classification", "notes"],
    )

    missing_assets = [row["path"] for row in inventory_rows if row["status"] != "present"]
    summary = {
        "run_id": RUN_ID,
        "generated_at": generated_at,
        "source_commit": commit,
        "verdict": "K2_REGRESSION_BASELINE_ONLY",
        "source_faithful_contract": "V3",
        "v2_status": "ABSTRACT_ONLY_NOT_SOURCE_FAITHFUL",
        "expected_generator_mode": "k2_regression",
        "no_k3_generation": True,
        "lp_solved": False,
        "lean_opened": False,
        "high_k_claim": False,
        "global_collatz_claim": False,
        "schema_version_expected": "KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2",
        "theorem_count": len(theorem_rows),
        "expected_row_record_count": len(row_rows),
        "certificate_constant_count": len(constants_rows),
        "manual_baseline_asset_count": len(inventory_rows),
        "manual_baseline_missing_asset_count": len(missing_assets),
        "manual_baseline_missing_assets": missing_assets,
        "regression_requirement_count": len(requirements_rows),
        "must_reproduce": [
            "rows_v3",
            "meta_errata_phi25",
            "deletion_behavior",
            "certificate_constants",
            "json_lean_twin_artifacts_v2",
        ],
        "guardrails": [
            "NO_K3_GENERATION",
            "NO_LP_SOLVED",
            "NO_NEW_LEAN_OPENED",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
        "output_files": [
            repo_rel(summary_path),
            repo_rel(theorem_path),
            repo_rel(rows_path),
            repo_rel(constants_path),
            repo_rel(inventory_path),
            repo_rel(requirements_path),
            repo_rel(manifest_path),
        ],
    }
    write_json(summary_path, summary)

    manifest_inputs = [
        summary_path,
        theorem_path,
        rows_path,
        constants_path,
        inventory_path,
        requirements_path,
    ]
    write_csv(manifest_path, manifest_rows(manifest_inputs), ["path", "sha256"])

    print(f"run_id={RUN_ID}")
    print(f"verdict={summary['verdict']}")
    print(f"source_faithful_contract={summary['source_faithful_contract']}")
    print(f"manual_baseline_missing_asset_count={summary['manual_baseline_missing_asset_count']}")
    print(f"output_dir={repo_rel(OUT_DIR)}")
    print("no k=3 generation, no LP, no high-k claim, no global Collatz claim")


if __name__ == "__main__":
    main()
