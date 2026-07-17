#!/usr/bin/env python3
"""Create the KL2003 F2 k=3 generator/verifier pilot inventory.

This script is an inventory and schema draft only.  It does not generate k=3
mathematical rows, does not solve an LP, and does not open or inspect a k=3
Lean proof.  Its job is to turn the k=3 pilot scoping note into versioned
artifacts that make the generator/verifier trust boundary explicit.
"""

from __future__ import annotations

import csv
import hashlib
import json
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


RUN_ID = "KL2003_F2_K3_PILOT_INVENTORY_v1"
REPO_ROOT = Path(__file__).resolve().parents[1]
SCOPING = REPO_ROOT / "docs" / "KL2003_F2_K3_GENERATOR_VERIFIER_PILOT_SCOPING_v1.md"
PREVIOUS_F2_DIR = REPO_ROOT / "outputs" / "KL2003_F2_K9_FEASIBILITY_GATE_v1"
PREVIOUS_F2_SUMMARY = PREVIOUS_F2_DIR / "summary.json"
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID


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


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
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


def tracked_classes() -> dict[str, int | str]:
    k2 = 3 ** (2 - 1)
    k3 = 3 ** (3 - 1)
    k9 = 3 ** (9 - 1)
    k11 = 3 ** (11 - 1)
    return {
        "formula": "tracked_classes(k) = 3^(k - 1)",
        "k2": k2,
        "k3": k3,
        "k3_pre_reduction": 3**3,
        "k9": k9,
        "k11": k11,
        "scale_factor_k3_from_k2": k3 // k2,
        "scale_factor_k9_from_k3": k9 // k3,
        "scale_factor_k11_from_k3": k11 // k3,
    }


def high_k_lean_files() -> list[str]:
    lean_dir = REPO_ROOT / "CollatzClassical" / "KL2003"
    if not lean_dir.exists():
        return []
    files: list[Path] = []
    for pattern in ("*K3*.lean", "*K9*.lean", "*K11*.lean", "*HighK*.lean"):
        files.extend(lean_dir.glob(pattern))
    return sorted({repo_rel(path) for path in files})


def architecture_checklist(high_k_files: list[str]) -> list[dict[str, Any]]:
    no_high_k_status = "PASS" if not high_k_files else "FAIL_REVIEW_REQUIRED"
    return [
        {
            "item_id": "generator_untrusted",
            "status": "SCOPED",
            "trust_layer": "generator",
            "expected_artifact": "candidate JSON/CSV only",
            "notes": "Python may search or emit candidates, but Lean/data verifiers must recheck all mathematical claims.",
        },
        {
            "item_id": "data_artifacts_versioned",
            "status": "SCOPED",
            "trust_layer": "data",
            "expected_artifact": "versioned JSON/CSV with manifest_sha256.csv",
            "notes": "Generator output must be stable, hashed, and reviewable before any Lean checker consumes it.",
        },
        {
            "item_id": "lean_verifier_trusted",
            "status": "SCOPED",
            "trust_layer": "Lean checker",
            "expected_artifact": "future data verifier module and axiom audit",
            "notes": "Lean verifier checks well-formedness, residues, inverse words, deletion/cobertura, rationals, and slacks.",
        },
        {
            "item_id": "empirical_hooks_nontrusted",
            "status": "SCOPED",
            "trust_layer": "diagnostic scripts",
            "expected_artifact": "future finite-grid/member-wise hook outputs",
            "notes": "Empirical hooks are useful diagnostics but not part of the logical proof base.",
        },
        {
            "item_id": "no_manual_mass_transcription",
            "status": "SCOPED",
            "trust_layer": "process guardrail",
            "expected_artifact": "generator schema plus manifests",
            "notes": "A k=3 pilot that only succeeds by hand transcription is not evidence for k=9/k=11.",
        },
        {
            "item_id": "no_high_k_lean_opened",
            "status": no_high_k_status,
            "trust_layer": "repository check",
            "expected_artifact": "no K3/K9/K11 Lean modules in CollatzClassical/KL2003",
            "notes": "Detected files: " + (", ".join(high_k_files) if high_k_files else "none"),
        },
    ]


def k3_artifact_schema() -> dict[str, Any]:
    return {
        "run_id": RUN_ID,
        "schema_status": "TENTATIVE_NO_ROWS_GENERATED",
        "source_scoping": repo_rel(SCOPING),
        "classes": {
            "file": "classes.json",
            "purpose": "Declare tracked and pre-reduction class conventions.",
            "required_fields": [
                "k",
                "tracked_class_convention",
                "tracked_class_id",
                "pre_reduction_residue",
                "modulus",
                "representative",
                "source_rule",
            ],
        },
        "rows": {
            "file": "rows.json",
            "purpose": "Declare generated abstract rows without trusting their truth.",
            "required_fields": [
                "row_id",
                "caller_class",
                "row_family",
                "terms",
                "deletion_rule_id",
                "source_ref",
                "normalization_ref",
            ],
        },
        "inverse_words": {
            "file": "inverse_words.csv",
            "purpose": "Materialize finite inverse words for row populations.",
            "required_fields": [
                "word_id",
                "row_id",
                "literal_id",
                "edge_word",
                "root_formula",
                "forward_route",
                "target_class",
                "residue_side_conditions",
            ],
        },
        "deletion_marks": {
            "file": "deletion_marks.csv",
            "purpose": "Record kept/deleted literals and the source rule justifying each mark.",
            "required_fields": [
                "row_id",
                "literal_id",
                "is_deleted",
                "deletion_rule_id",
                "boundary_correction",
                "source_ref",
            ],
        },
        "rational_certificate": {
            "file": "certificate.json",
            "purpose": "Exact rational certificate candidate for the pilot rows.",
            "required_fields": [
                "lambda_interval",
                "coefficient_intervals",
                "variables",
                "rows",
                "source_or_solver_manifest",
                "float_diagnostics_only",
            ],
        },
        "slacks": {
            "file": "row_slacks.csv",
            "purpose": "Exact rational row slack ledger.",
            "required_fields": [
                "row_id",
                "lhs_rational",
                "rhs_rational",
                "slack_rational",
                "slack_positive",
                "denominator_bits",
            ],
        },
        "manifest": {
            "file": "manifest_sha256.csv",
            "purpose": "Bind generated artifacts to hashes.",
            "required_fields": [
                "path",
                "sha256",
            ],
        },
        "guardrails": [
            "NO_K3_ROWS_GENERATED_BY_THIS_SCRIPT",
            "NO_LP_SOLVED_BY_THIS_SCRIPT",
            "NO_HIGH_K_LEAN_OPENED",
            "NO_K9_THEOREM_CLAIM",
            "NO_K11_084_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }


def lean_verifier_obligations() -> list[dict[str, str]]:
    return [
        {
            "obligation_id": "row_well_formed",
            "category": "schema",
            "trusted_checker_role": "Check every generated row id, term list, coefficient reference, and class reference is valid.",
            "expected_reuse": "data verifier style from k=2 certificate modules",
            "status": "PENDING_FUTURE_LEAN",
        },
        {
            "obligation_id": "residue_compatibility",
            "category": "arithmetic",
            "trusted_checker_role": "Check declared residues/classes against exact Nat arithmetic.",
            "expected_reuse": "M0B residue proof patterns; generated norm_num facts if needed",
            "status": "PENDING_FUTURE_LEAN",
        },
        {
            "obligation_id": "inverse_word_forward_route",
            "category": "combinatorial",
            "trusted_checker_role": "Check each inverse word forward-maps to its declared parent/root.",
            "expected_reuse": "M0A T function and reachability API",
            "status": "PENDING_FUTURE_LEAN",
        },
        {
            "obligation_id": "deletion_rule_soundness",
            "category": "source normalization",
            "trusted_checker_role": "Check kept/deleted marks obey the declared deletion rule and boundary correction.",
            "expected_reuse": "k=2 deletion ledger pattern only; rule is high-k data",
            "status": "PENDING_FUTURE_LEAN",
        },
        {
            "obligation_id": "disjointness_or_fiber_partition",
            "category": "semantic/combinatorial",
            "trusted_checker_role": "Check summed populations are disjoint or partitioned by first-entry fibers.",
            "expected_reuse": "entry-predecessor fiber disjointness",
            "status": "PENDING_FUTURE_LEAN",
        },
        {
            "obligation_id": "rational_slack_positive",
            "category": "exact arithmetic",
            "trusted_checker_role": "Check every emitted rational row slack is strictly positive.",
            "expected_reuse": "k=2 rational verifier style; generated exact rational facts",
            "status": "PENDING_FUTURE_LEAN",
        },
        {
            "obligation_id": "abstract_row_discharge",
            "category": "row theorem",
            "trusted_checker_role": "Discharge each abstract row from checked combinatorial and rational data.",
            "expected_reuse": "M0C row-contract shape if the pilot reaches abstract rows",
            "status": "PENDING_FUTURE_LEAN",
        },
    ]


def reuse_map() -> list[dict[str, str]]:
    return [
        {
            "asset_id": "M0A_piStar_semantics",
            "path": "CollatzClassical/KL2003/KL2003M0APiStarSemantics.lean",
            "classification": "reusable_as_is",
            "reason": "T, bounded reachability, piStar, and root-count semantics are not k=2-specific.",
            "k3_action": "Import/use if semantic hooks enter the pilot checker.",
        },
        {
            "asset_id": "M0B_reachability_api",
            "path": "CollatzClassical/KL2003/KL2003M0BReachabilityAPI.lean",
            "classification": "reusable_as_is",
            "reason": "Bool/Prop reachability bridge is root/window generic.",
            "k3_action": "Reuse for inverse-word route validation if needed.",
        },
        {
            "asset_id": "entry_predecessor_fibers",
            "path": "CollatzClassical/KL2003/KL2003M0BEntryPredecessorDisjointness.lean",
            "classification": "reusable_as_is",
            "reason": "First-entry fiber disjointness is independent of k=2 row labels.",
            "k3_action": "Reuse for generated disjointness obligations.",
        },
        {
            "asset_id": "root_count_unit_base",
            "path": "CollatzClassical/KL2003/KL2003RootCountUnitBase.lean",
            "classification": "reusable_as_is",
            "reason": "Root counts itself in its own window is generic.",
            "k3_action": "Reuse if base/unit hooks are part of the pilot.",
        },
        {
            "asset_id": "two_branch_core",
            "path": "CollatzClassical/KL2003/KL2003M0BTwoBranchCore.lean",
            "classification": "reusable_with_parameterization",
            "reason": "The proof pattern is useful, but k=3 rows may need generated arities beyond the k=2 two-branch shape.",
            "k3_action": "Treat as template/pattern, not as complete row family.",
        },
        {
            "asset_id": "D123_core_instantiations",
            "path": "CollatzClassical/KL2003/KL2003M0BD123CoreInstantiations.lean",
            "classification": "k2_cabled",
            "reason": "D1/D2/D3 are k=2 row instantiations.",
            "k3_action": "Replace with generated k=3 row instantiations if the pilot reaches Lean rows.",
        },
        {
            "asset_id": "K2_certificate_data",
            "path": "CollatzClassical/KL2003/KL2003K2CertificateData.lean",
            "classification": "k2_cabled",
            "reason": "Constants, classes, variables, endpoints, and slacks are k=2-specific.",
            "k3_action": "Replace with generated k=3 data artifact or data-only module.",
        },
        {
            "asset_id": "K2_certificate_verifier",
            "path": "CollatzClassical/KL2003/KL2003K2CertificateVerifier.lean",
            "classification": "reusable_with_parameterization",
            "reason": "Verifier style is reusable; row shape and constants are k=2-specific.",
            "k3_action": "Port pattern to generated data verifier.",
        },
        {
            "asset_id": "K2_alpha_endpoints",
            "path": "CollatzClassical/KL2003/KL2003K2TranscendentalEndpoints.lean",
            "classification": "reusable_with_parameterization",
            "reason": "Real/log/rpow techniques are reusable, but lambda/endpoints are pilot-specific.",
            "k3_action": "Reuse theorem patterns only after k=3 lambda policy exists.",
        },
        {
            "asset_id": "M0C_retarded_induction",
            "path": "CollatzClassical/KL2003/KL2003M0CRetardedInduction.lean",
            "classification": "reusable_with_parameterization",
            "reason": "Retarded-induction architecture is reusable; rows, coefficients, and pads are k=2-specific.",
            "k3_action": "Do not consume until k=3 abstract rows and certificate are generated.",
        },
        {
            "asset_id": "ConcretePhi_realization",
            "path": "CollatzClassical/KL2003/KL2003ConcretePhiRealization.lean",
            "classification": "k2_cabled",
            "reason": "ClassRoots, concretePhi, row22/25/28 seams, and V3 row28 case tree are mod-9/k=2-specific.",
            "k3_action": "Replace with generated k=3 class envelope if the pilot reaches concrete Phi.",
        },
        {
            "asset_id": "M1_surrogate_final",
            "path": "CollatzClassical/KL2003/KL2003M1Surrogate.lean",
            "classification": "reusable_with_parameterization",
            "reason": "The final logb/arbitrary-x packaging pattern is useful, but theorem constants and Phi are k=2-specific.",
            "k3_action": "Out of scope for inventory-only pilot.",
        },
        {
            "asset_id": "M0A_examples",
            "path": "CollatzClassical/KL2003/KL2003M0APiStarSemanticsExamples.lean",
            "classification": "unknown",
            "reason": "Example module may help diagnostics but is not needed for the first inventory.",
            "k3_action": "Review only if empirical hooks need Lean #eval examples.",
        },
    ]


def output_manifest(paths: list[Path]) -> list[dict[str, str]]:
    return [{"path": repo_rel(path), "sha256": sha256(path)} for path in paths]


def main() -> None:
    if not SCOPING.exists():
        raise FileNotFoundError(f"Missing k=3 pilot scoping note: {SCOPING}")
    if not PREVIOUS_F2_SUMMARY.exists():
        raise FileNotFoundError(f"Missing previous F2 inventory summary: {PREVIOUS_F2_SUMMARY}")

    previous_summary = read_json(PREVIOUS_F2_SUMMARY)
    high_k_files = high_k_lean_files()
    tracked = tracked_classes()
    arch_rows = architecture_checklist(high_k_files)
    obligations = lean_verifier_obligations()
    reuse_rows = reuse_map()

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    summary_path = OUT_DIR / "summary.json"
    architecture_path = OUT_DIR / "architecture_checklist.csv"
    schema_path = OUT_DIR / "k3_artifact_schema.json"
    obligations_path = OUT_DIR / "lean_verifier_obligations.csv"
    reuse_path = OUT_DIR / "reuse_map.csv"
    manifest_path = OUT_DIR / "manifest_sha256.csv"

    summary = {
        "run_id": RUN_ID,
        "generated_at_utc": datetime.now(timezone.utc).isoformat(),
        "verdict_placeholder": "K3_PILOT_INVENTORY_ONLY",
        "repo_root": str(REPO_ROOT),
        "inputs": {
            "scoping_path": repo_rel(SCOPING),
            "scoping_sha256": sha256(SCOPING),
            "previous_f2_summary": repo_rel(PREVIOUS_F2_SUMMARY),
            "previous_f2_summary_sha256": sha256(PREVIOUS_F2_SUMMARY),
            "previous_f2_status_counts": previous_summary.get("checklist_status_counts", {}),
        },
        "tracked_classes": tracked,
        "scale_factors": {
            "k3_from_k2": tracked["scale_factor_k3_from_k2"],
            "k9_from_k3": tracked["scale_factor_k9_from_k3"],
            "k11_from_k3": tracked["scale_factor_k11_from_k3"],
        },
        "high_k_lean_files_detected": high_k_files,
        "artifact_schema_status": "DRAFT_ONLY",
        "generated_math_rows": False,
        "lp_solved": False,
        "lean_opened": False,
        "go_no_go_declared": False,
        "output_files": [
            repo_rel(summary_path),
            repo_rel(architecture_path),
            repo_rel(schema_path),
            repo_rel(obligations_path),
            repo_rel(reuse_path),
            repo_rel(manifest_path),
        ],
        "guardrails": [
            "NO_K3_ROWS_GENERATED",
            "NO_LP_SOLVED",
            "NO_HIGH_K_LEAN_OPENED",
            "NO_GO_NO_GO_DECLARED",
            "NO_K9_THEOREM_CLAIM",
            "NO_K11_084_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
        "classifications": [
            "F2_K3_PILOT_INVENTORY_CREATED",
            "GENERATOR_VERIFIER_SCHEMA_DRAFTED",
            "LEAN_VERIFIER_OBLIGATIONS_LISTED",
            "NO_K3_ROWS_GENERATED",
            "NO_HIGH_K_LEAN_OPENED",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }

    write_json(summary_path, summary)
    write_csv(
        architecture_path,
        arch_rows,
        ["item_id", "status", "trust_layer", "expected_artifact", "notes"],
    )
    write_json(schema_path, k3_artifact_schema())
    write_csv(
        obligations_path,
        obligations,
        ["obligation_id", "category", "trusted_checker_role", "expected_reuse", "status"],
    )
    write_csv(
        reuse_path,
        reuse_rows,
        ["asset_id", "path", "classification", "reason", "k3_action"],
    )

    generated = [
        summary_path,
        architecture_path,
        schema_path,
        obligations_path,
        reuse_path,
    ]
    write_csv(manifest_path, output_manifest(generated), ["path", "sha256"])

    print(f"run_id={RUN_ID}")
    print(f"tracked_classes.k2={tracked['k2']}")
    print(f"tracked_classes.k3={tracked['k3']}")
    print(f"tracked_classes.k9={tracked['k9']}")
    print(f"tracked_classes.k11={tracked['k11']}")
    print(f"scale_factor.k3_from_k2={tracked['scale_factor_k3_from_k2']}")
    print(f"scale_factor.k9_from_k3={tracked['scale_factor_k9_from_k3']}")
    print(f"scale_factor.k11_from_k3={tracked['scale_factor_k11_from_k3']}")
    print(f"output_dir={repo_rel(OUT_DIR)}")
    print("inventory only: no k=3 rows, no LP solve, no high-k Lean, no global Collatz claim")


if __name__ == "__main__":
    main()
