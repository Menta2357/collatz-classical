#!/usr/bin/env python3
"""Measure the flat KL2003 L_9^NT certificate pipeline.

This script deliberately does not materialize EL trees and does not prove a
k=9 theorem.  It derives all flat row indices from the parametric source
rules, searches numerically for a positive vector, rounds it to canonical
rationals, and rechecks every emitted inequality with ``Fraction``.
"""

from __future__ import annotations

import csv
import hashlib
import json
import subprocess
import time
from decimal import Decimal, getcontext
from fractions import Fraction
from pathlib import Path
from typing import Any

import numpy as np


RUN_ID = "KL2003_F2_K9_LNT_MEASUREMENT_v1"
SCHEMA_VERSION = "KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2_1"
GENERATOR_VERSION = "kl2003_f2_k9_lnt_measurement_v1.py"
REPO_ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID
JSON_PATH = OUT_DIR / "kl2003_k9_lnt_certificate.candidate.json"
LEAN_PATH = OUT_DIR / "KL2003K9LNTCertificateDataCandidate.lean"
CHECKER_DIR = OUT_DIR / "lean_checker_shards"
ROWS_PATH = OUT_DIR / "l9nt_rows.csv"
SLACKS_PATH = OUT_DIR / "exact_slacks.csv"
CONDITIONS_PATH = OUT_DIR / "condition_status.csv"
PROJECTIONS_PATH = OUT_DIR / "kernel_budget_projection.csv"
SUMMARY_PATH = OUT_DIR / "generation_summary.json"
MISMATCH_PATH = OUT_DIR / "mismatch.csv"
MANIFEST_PATH = OUT_DIR / "manifest_sha256.csv"

SOURCE_PATH = Path(
    "/Users/MoiTam/Documents/Codex/2026-07-05/"
    "tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/"
    "kl2003_src/30apr02.tex"
)
K3_SUMMARY_PATH = (
    REPO_ROOT
    / "outputs"
    / "KL2003_F2_K3_GENERATOR_REAL_v1"
    / "generation_summary.json"
)

K = 9
MODULUS = 3**K
CLASS_STEP = 3 ** (K - 1)
TRACKED = np.arange(2, MODULUS, 3, dtype=np.int64)
AUXILIARY_MODES = np.arange(2, CLASS_STEP, 3, dtype=np.int64)

# Strictly below the source value 1.7615320.
LAMBDA = Fraction(1_761_525, 1_000_000)
ALPHA_LOWER = Fraction(569, 359)
# Decimal floor below lambda^(alphaLower-2), checked again by integer powers.
B_LOWER = Fraction(197_645_020_953, 250_000_000_000)
D_LOWER = LAMBDA * B_LOWER
A_COEFF = 1 / (LAMBDA**2)
ROUNDING_SCALE = 100_000_000
SOURCE_LAMBDA9 = Decimal("1.7615320")
SOURCE_GAMMA9 = Decimal("0.8168300")
SOURCE_CMAX9 = Decimal("43.3394210")
K3_KERNEL_CHECK_SECONDS = Decimal("14")


def repo_rel(path: Path) -> str:
    try:
        return str(path.resolve().relative_to(REPO_ROOT))
    except ValueError:
        return str(path)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def source_commit() -> str:
    return subprocess.check_output(
        ["git", "rev-parse", "HEAD"], cwd=REPO_ROOT, text=True
    ).strip()


def source_commit_time() -> str:
    return subprocess.check_output(
        ["git", "show", "-s", "--format=%cI", "HEAD"],
        cwd=REPO_ROOT,
        text=True,
    ).strip()


def fraction_text(value: Fraction) -> str:
    if value.denominator == 1:
        return str(value.numerator)
    return f"{value.numerator}/{value.denominator}"


def lean_fraction(value: Fraction) -> str:
    return f"({value.numerator} / {value.denominator} : Rat)"


def write_json(path: Path, payload: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )


def write_csv(path: Path, rows: list[dict[str, Any]], fields: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        for row in rows:
            writer.writerow({field: row.get(field, "") for field in fields})


def row_kind(mode: int) -> str:
    return {2: "D1", 5: "D2", 8: "D3"}[mode % 9]


def topology() -> dict[str, np.ndarray]:
    retarded = (((4 * TRACKED) % MODULUS) - 2) // 3
    kinds = TRACKED % 9
    lifts = np.stack(
        [((AUXILIARY_MODES + index * CLASS_STEP) - 2) // 3 for index in range(3)],
        axis=1,
    )
    auxiliary_index = np.full(len(TRACKED), -1, dtype=np.int64)
    for index, mode_value in enumerate(TRACKED):
        mode = int(mode_value)
        if mode % 9 == 2:
            auxiliary_mode = ((4 * mode - 2) // 3) % CLASS_STEP
            auxiliary_index[index] = (auxiliary_mode - 2) // 3
        elif mode % 9 == 8:
            auxiliary_mode = ((2 * mode - 1) // 3) % CLASS_STEP
            auxiliary_index[index] = (auxiliary_mode - 2) // 3
    return {
        "retarded": retarded,
        "kinds": kinds,
        "lifts": lifts,
        "auxiliary_index": auxiliary_index,
    }


def topology_checks(data: dict[str, np.ndarray]) -> list[dict[str, str]]:
    tracked_set = set(int(value) for value in TRACKED)
    retarded_modes = [2 + 3 * int(index) for index in data["retarded"]]
    checks = {
        "tracked_class_count": len(TRACKED) == 6561,
        "auxiliary_class_count": len(AUXILIARY_MODES) == 2187,
        "d1_count": int(np.sum(data["kinds"] == 2)) == 2187,
        "d2_count": int(np.sum(data["kinds"] == 5)) == 2187,
        "d3_count": int(np.sum(data["kinds"] == 8)) == 2187,
        "retarded_targets_tracked": all(mode in tracked_set for mode in retarded_modes),
        "auxiliary_indices_in_range": bool(
            np.all(
                (data["auxiliary_index"][data["auxiliary_index"] >= 0]
                 < len(AUXILIARY_MODES))
            )
        ),
        "three_lifts_per_auxiliary": data["lifts"].shape == (2187, 3),
    }
    return [
        {
            "check_id": check_id,
            "status": "pass" if passed else "fail",
        }
        for check_id, passed in checks.items()
    ]


def power_candidate(
    data: dict[str, np.ndarray],
    *,
    tolerance: float = 1e-14,
    max_iterations: int = 20_000,
) -> tuple[np.ndarray, int, float, float, float]:
    start = time.perf_counter()
    principal = np.ones(len(TRACKED), dtype=np.float64)
    a_float = float(A_COEFF)
    b_float = float(B_LOWER)
    d_float = float(D_LOWER)
    rho = 0.0
    relative_change = float("inf")
    for iteration in range(1, max_iterations + 1):
        auxiliary = principal[data["lifts"]].min(axis=1)
        image = a_float * principal[data["retarded"]]
        d1 = data["kinds"] == 2
        d3 = data["kinds"] == 8
        image[d1] += b_float * auxiliary[data["auxiliary_index"][d1]]
        image[d3] += d_float * auxiliary[data["auxiliary_index"][d3]]
        rho = float(image.min())
        next_principal = image / rho
        relative_change = float(
            np.max(np.abs(next_principal - principal) / (1 + np.abs(principal)))
        )
        principal = next_principal
        if relative_change < tolerance:
            break
    else:
        raise RuntimeError("K9_POWER_ITERATION_DID_NOT_CONVERGE")
    return principal, iteration, rho, relative_change, time.perf_counter() - start


def rationalize_and_verify(
    candidate: np.ndarray, data: dict[str, np.ndarray]
) -> dict[str, Any]:
    principal = [
        Fraction(round(float(value) * ROUNDING_SCALE), ROUNDING_SCALE)
        for value in candidate
    ]
    auxiliary = [
        min(principal[int(index)] for index in lift_row)
        for lift_row in data["lifts"]
    ]
    slacks: list[Fraction] = []
    for index, mode_value in enumerate(TRACKED):
        rhs = A_COEFF * principal[int(data["retarded"][index])]
        mode = int(mode_value)
        auxiliary_index = int(data["auxiliary_index"][index])
        if mode % 9 == 2:
            rhs += B_LOWER * auxiliary[auxiliary_index]
        elif mode % 9 == 8:
            rhs += D_LOWER * auxiliary[auxiliary_index]
        slacks.append(rhs - principal[index])

    l4_slacks = [
        principal[int(principal_index)] - auxiliary[aux_index]
        for aux_index, lift_row in enumerate(data["lifts"])
        for principal_index in lift_row
    ]
    endpoint_checks = {
        "B_lower_integer_power_witness": B_LOWER**359 * LAMBDA**149 <= 1,
        "D_lower_integer_power_witness": D_LOWER**359 <= LAMBDA**210,
    }
    exact_checks = {
        "principal_box_lower": all(value >= 1 for value in principal),
        "auxiliary_box_lower": all(value >= 1 for value in auxiliary),
        "l4_nonnegative": all(value >= 0 for value in l4_slacks),
        "all_row_slacks_positive": all(value > 0 for value in slacks),
        **endpoint_checks,
    }
    return {
        "principal": principal,
        "auxiliary": auxiliary,
        "slacks": slacks,
        "l4_slacks": l4_slacks,
        "exact_checks": exact_checks,
    }


def row_child(
    row_id: str,
    child_id: str,
    target_class: int,
    inverse_word: list[str],
    shift: str,
    reason: str,
) -> dict[str, Any]:
    return {
        "child_id": child_id,
        "inverse_word": inverse_word,
        "target_class": str(target_class),
        "shift": shift,
        "window_policy": "L9NT_flat_source_shift",
        "fiber_parent": row_id,
        "deleted": False,
        "reason": reason,
    }


def rows_payload(
    certificate: dict[str, Any], data: dict[str, np.ndarray]
) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    rows: list[dict[str, Any]] = []
    inverse_words: list[dict[str, Any]] = []
    for index, mode_value in enumerate(TRACKED):
        mode = int(mode_value)
        kind = row_kind(mode)
        row_id = f"L9NT_{kind}_m{mode}"
        retarded_mode = 2 + 3 * int(data["retarded"][index])
        children = [
            row_child(
                row_id,
                f"{row_id}_retarded",
                retarded_mode,
                ["e", "e"],
                "-2",
                "retarded L_k^NT term",
            )
        ]
        coefficient_terms: list[dict[str, str]] = [
            {
                "coefficient": "A_lambda_minus_2",
                "variable": f"c9_{retarded_mode}",
            }
        ]
        auxiliary_index = int(data["auxiliary_index"][index])
        if kind in {"D1", "D3"}:
            auxiliary_mode = int(AUXILIARY_MODES[auxiliary_index])
            coefficient = "B_lower" if kind == "D1" else "D_lower"
            children.append(
                row_child(
                    row_id,
                    f"{row_id}_advanced",
                    auxiliary_mode,
                    ["o", "e"] if kind == "D1" else ["o"],
                    "alpha-2" if kind == "D1" else "alpha-1",
                    "advanced auxiliary L_k^NT term",
                )
            )
            coefficient_terms.append(
                {"coefficient": coefficient, "variable": f"c8_{auxiliary_mode}"}
            )
        row = {
            "row_id": row_id,
            "source_class": str(mode),
            "row_kind": kind,
            "children": children,
            "deletion_policy": "not_applicable_flat_L9NT",
            "coefficient_terms": coefficient_terms,
            "target_bound": fraction_text(certificate["principal"][index]),
            "slack_id": f"slack_m{mode}",
        }
        rows.append(row)
        inverse_words.extend(dict(child) for child in children)
    return rows, inverse_words


def artifact_payload(
    certificate: dict[str, Any],
    data: dict[str, np.ndarray],
    rows: list[dict[str, Any]],
    inverse_words: list[dict[str, Any]],
    diagnostics: dict[str, str],
) -> dict[str, Any]:
    variables = {
        **{
            f"c9_{int(mode)}": fraction_text(certificate["principal"][index])
            for index, mode in enumerate(TRACKED)
        },
        **{
            f"c8_{int(mode)}": fraction_text(certificate["auxiliary"][index])
            for index, mode in enumerate(AUXILIARY_MODES)
        },
    }
    slacks = [
        {
            "slack_id": f"slack_m{int(mode)}",
            "row_id": f"L9NT_{row_kind(int(mode))}_m{int(mode)}",
            "slack": fraction_text(certificate["slacks"][index]),
            "strictly_positive": True,
        }
        for index, mode in enumerate(TRACKED)
    ]
    return {
        "metadata": {
            "run_id": RUN_ID,
            "schema_version": SCHEMA_VERSION,
            "generator_version": GENERATOR_VERSION,
            "generator_mode": "k9_flat_LNT_measurement",
            "k": str(K),
            "tracked_class_count": str(len(TRACKED)),
            "pre_reduction_class_count": str(MODULUS),
            "created_at": source_commit_time(),
            "source_commit": source_commit(),
            "scope": "k9_measurement_data_candidate_not_theorem",
            "mathematical_generation": True,
            "mathematical_content": "flat_L9NT_exact_rational_candidate",
            "proof_status": "exact_python_recheck_only_pending_lean_kernel_checker",
            "no_theorem_claim": True,
            "artifact_links": {
                "json_artifact": repo_rel(JSON_PATH),
                "lean_data_artifact": repo_rel(LEAN_PATH),
                "json_to_lean_generator": repo_rel(REPO_ROOT / "scripts" / GENERATOR_VERSION),
                "json_sha256": "RECORDED_IN_MANIFEST",
                "lean_data_sha256": "RECORDED_IN_MANIFEST",
                "json_to_lean_generator_sha256": sha256(REPO_ROOT / "scripts" / GENERATOR_VERSION),
            },
        },
        "tracked_classes": [
            {
                "class_id": f"m{int(mode)}",
                "modulus": str(MODULUS),
                "representative": str(int(mode)),
                "row_kind": row_kind(int(mode)),
            }
            for mode in TRACKED
        ],
        "rows": rows,
        "inverse_words": inverse_words,
        "deletion_marks": [],
        "rational_certificate": {
            "lambda_interval": {
                "lo": fraction_text(LAMBDA),
                "hi": fraction_text(LAMBDA),
            },
            "coefficient_intervals": [
                {
                    "coefficient_id": "A_lambda_minus_2",
                    "lo": fraction_text(A_COEFF),
                    "hi": fraction_text(A_COEFF),
                },
                {
                    "coefficient_id": "B_lower",
                    "lo": fraction_text(B_LOWER),
                    "hi": fraction_text(B_LOWER),
                },
                {
                    "coefficient_id": "D_lower",
                    "lo": fraction_text(D_LOWER),
                    "hi": fraction_text(D_LOWER),
                },
            ],
            "variables": variables,
            "transcendental_endpoint_witnesses": {
                "alpha_lower": fraction_text(ALPHA_LOWER),
                "B_power_witness": "B_lower^359 * lambda^149 <= 1",
                "B_power_witness_holds": True,
                "D_power_witness": "D_lower^359 <= lambda^210",
                "D_power_witness_holds": True,
            },
            "float_diagnostics_as_strings": diagnostics,
            "solver_manifest": {
                "solver": "nonlinear_Perron_iteration_plus_exact_Fraction_recheck",
                "fixed_lambda": fraction_text(LAMBDA),
                "rounding_scale": str(ROUNDING_SCALE),
                "exact_fraction_recheck": True,
                "lp_solved": False,
            },
        },
        "slacks": slacks,
        "nodes": [],
        "nested_blocks": [],
        "post_deletion_edges": [],
        "sibling_disjointness_groups": [],
        "overlap_guards": [
            {
                "guard_id": "flat_lnt_no_parent_descendant_sum",
                "guard_kind": "no_parent_descendant_sum",
                "status": "vacuous_flat_LNT",
            }
        ],
        "source_refs": [
            {
                "source_ref_id": "L9NT_rows",
                "source_kind": "primary_tex",
                "path": str(SOURCE_PATH),
                "lines": "494-570",
                "trust_role": "generator_rule",
            },
            {
                "source_ref_id": "L9NT_termination_not_applicable",
                "source_kind": "primary_tex",
                "path": str(SOURCE_PATH),
                "lines": "494-570",
                "trust_role": "flat_system_has_no_EL_expansion",
            },
        ],
        "termination_policy": {
            "kind": "expand_until_deletion_saturation",
            "status": "source_theorem_run_witness_unverified_in_lean",
            "termination_rule_ref": "source_refs.L9NT_termination_not_applicable",
            "notes": "Vacuous compatibility field: this artifact is flat L9NT, not an EL tree.",
        },
        "verification_targets": [
            {"target_id": "flat_topology", "required": True, "status": "PASS"},
            {"target_id": "exact_fraction_rows", "required": True, "status": "PASS"},
            {
                "target_id": "lean_kernel_certificate_checker",
                "required": True,
                "status": "PENDING",
            },
        ],
        "guardrails": [
            "K9_MEASUREMENT_ONLY",
            "GENERATED_DATA_CANDIDATE_NOT_A_THEOREM",
            "NO_EXPLICIT_EL_TREE_MATERIALIZATION",
            "NO_K9_FORMALIZATION_AUTHORIZATION",
            "K11_DEFERRED",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }


def lean_chunks(
    name: str,
    values: list[str],
    lean_type: str,
    *,
    chunk_size: int = 81,
) -> tuple[str, str]:
    chunks = [values[index : index + chunk_size] for index in range(0, len(values), chunk_size)]
    declarations = "\n\n".join(
        f"def {name}Chunk{index} : Array {lean_type} := #[\n    "
        + ",\n    ".join(chunk)
        + "\n  ]"
        for index, chunk in enumerate(chunks)
    )
    chunk_names = ",\n    ".join(f"{name}Chunk{index}" for index in range(len(chunks)))
    table = f"def {name}Chunks : Array (Array {lean_type}) := #[\n    {chunk_names}\n  ]"
    return declarations, table


def lean_data(certificate: dict[str, Any], data: dict[str, np.ndarray]) -> str:
    principal_declarations, principal_table = lean_chunks(
        "principal",
        [lean_fraction(value) for value in certificate["principal"]],
        "Rat",
    )
    auxiliary_declarations, auxiliary_table = lean_chunks(
        "auxiliary",
        [lean_fraction(value) for value in certificate["auxiliary"]],
        "Rat",
    )
    slack_declarations, slack_table = lean_chunks(
        "rowSlacks",
        [lean_fraction(value) for value in certificate["slacks"]],
        "Rat",
    )
    row_values = [
        "{ mode := "
        f"{int(mode)}, kind := {int(data['kinds'][index])}, "
        f"retardedIndex := {int(data['retarded'][index])}, "
        f"auxiliaryIndex := {max(int(data['auxiliary_index'][index]), 0)} }}"
        for index, mode in enumerate(TRACKED)
    ]
    row_declarations, row_table = lean_chunks(
        "rows", row_values, "FlatRowData"
    )
    return f'''import Mathlib.Data.Rat.Defs

/- Generated measurement data only.  This file is not imported by the project
and contains no k=9 theorem.  A separate kernel checker remains required. -/

namespace CollatzClassical.KL2003.GeneratedK9Measurement

structure FlatRowData where
  mode : Nat
  kind : Nat
  retardedIndex : Nat
  auxiliaryIndex : Nat
deriving Repr, DecidableEq

def lambda : Rat := {lean_fraction(LAMBDA)}
def aCoeff : Rat := {lean_fraction(A_COEFF)}
def bLower : Rat := {lean_fraction(B_LOWER)}
def dLower : Rat := {lean_fraction(D_LOWER)}

{principal_declarations}

{principal_table}

{auxiliary_declarations}

{auxiliary_table}

{slack_declarations}

{slack_table}

{row_declarations}

{row_table}

end CollatzClassical.KL2003.GeneratedK9Measurement
'''


def emit_checker_shards(
    certificate: dict[str, Any], data: dict[str, np.ndarray]
) -> list[Path]:
    """Emit independent kernel-check shards with literal exact arithmetic."""
    CHECKER_DIR.mkdir(parents=True, exist_ok=True)
    paths: list[Path] = []
    principal_chunk = len(TRACKED) // 9
    auxiliary_chunk = len(AUXILIARY_MODES) // 9
    for shard in range(9):
        lines = [
            "import Mathlib",
            "",
            "/- Generated arithmetic measurement only; no k=9 lower-bound theorem. -/",
            f"namespace CollatzClassical.KL2003.GeneratedK9CheckerShard{shard}",
            "",
        ]
        principal_start = shard * principal_chunk
        principal_end = principal_start + principal_chunk
        for index in range(principal_start, principal_end):
            mode = int(TRACKED[index])
            principal = certificate["principal"][index]
            retarded = certificate["principal"][int(data["retarded"][index])]
            rhs = f"{lean_fraction(A_COEFF)} * {lean_fraction(retarded)}"
            auxiliary_index = int(data["auxiliary_index"][index])
            if mode % 9 == 2:
                auxiliary = certificate["auxiliary"][auxiliary_index]
                rhs += f" + {lean_fraction(B_LOWER)} * {lean_fraction(auxiliary)}"
            elif mode % 9 == 8:
                auxiliary = certificate["auxiliary"][auxiliary_index]
                rhs += f" + {lean_fraction(D_LOWER)} * {lean_fraction(auxiliary)}"
            slack = certificate["slacks"][index]
            lines.extend(
                [
                    f"example : (1 : Rat) <= {lean_fraction(principal)} /\\",
                    f"    {lean_fraction(slack)} = {rhs} - {lean_fraction(principal)} /\\",
                    f"    (0 : Rat) < {lean_fraction(slack)} := by norm_num",
                    "",
                ]
            )

        auxiliary_start = shard * auxiliary_chunk
        auxiliary_end = auxiliary_start + auxiliary_chunk
        for aux_index in range(auxiliary_start, auxiliary_end):
            auxiliary = certificate["auxiliary"][aux_index]
            lift_values = [
                certificate["principal"][int(index)]
                for index in data["lifts"][aux_index]
            ]
            lines.extend(
                [
                    f"example : (1 : Rat) <= {lean_fraction(auxiliary)} /\\",
                    f"    {lean_fraction(auxiliary)} <= {lean_fraction(lift_values[0])} /\\",
                    f"    {lean_fraction(auxiliary)} <= {lean_fraction(lift_values[1])} /\\",
                    f"    {lean_fraction(auxiliary)} <= {lean_fraction(lift_values[2])} := by norm_num",
                    "",
                ]
            )
        lines.extend(
            [
                f"end CollatzClassical.KL2003.GeneratedK9CheckerShard{shard}",
                "",
            ]
        )
        path = CHECKER_DIR / f"KL2003K9LNTCertificateCheckerShard{shard}.lean"
        path.write_text("\n".join(lines), encoding="utf-8")
        paths.append(path)
    return paths


def diagnostics(certificate: dict[str, Any]) -> dict[str, str]:
    getcontext().prec = 60
    lambda_decimal = Decimal(LAMBDA.numerator) / Decimal(LAMBDA.denominator)
    gamma = lambda_decimal.ln() / Decimal(2).ln()
    cmax = max(certificate["principal"])
    cmax_decimal = Decimal(cmax.numerator) / Decimal(cmax.denominator)
    return {
        "lambda": str(lambda_decimal),
        "source_lambda9": str(SOURCE_LAMBDA9),
        "lambda_safe_gap": str(SOURCE_LAMBDA9 - lambda_decimal),
        "gamma": str(gamma),
        "source_gamma9": str(SOURCE_GAMMA9),
        "gamma_safe_gap": str(SOURCE_GAMMA9 - gamma),
        "cmax": str(cmax_decimal),
        "source_cmax9": str(SOURCE_CMAX9),
        "cmax_abs_diff": str(abs(SOURCE_CMAX9 - cmax_decimal)),
    }


def main() -> int:
    if not SOURCE_PATH.exists():
        raise FileNotFoundError("BLOCKED_ON_KL2003_TEX_SOURCE")
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    total_start = time.perf_counter()
    topology_start = time.perf_counter()
    data = topology()
    topology_runtime = time.perf_counter() - topology_start
    checks = topology_checks(data)
    if any(row["status"] != "pass" for row in checks):
        raise RuntimeError("K9_FLAT_TOPOLOGY_CHECK_FAILED")

    candidate, iterations, rho, relative_change, solver_runtime = power_candidate(data)
    exact_start = time.perf_counter()
    certificate = rationalize_and_verify(candidate, data)
    exact_runtime = time.perf_counter() - exact_start
    if not all(certificate["exact_checks"].values()):
        raise RuntimeError("K9_EXACT_FRACTION_RECHECK_FAILED")

    diag = diagnostics(certificate)
    rows, inverse_words = rows_payload(certificate, data)
    payload = artifact_payload(certificate, data, rows, inverse_words, diag)
    write_json(JSON_PATH, payload)
    LEAN_PATH.write_text(lean_data(certificate, data), encoding="utf-8")
    checker_shards = emit_checker_shards(certificate, data)

    row_csv = []
    for index, mode_value in enumerate(TRACKED):
        mode = int(mode_value)
        auxiliary_index = int(data["auxiliary_index"][index])
        row_csv.append(
            {
                "mode": mode,
                "row_kind": row_kind(mode),
                "retarded_mode": 2 + 3 * int(data["retarded"][index]),
                "auxiliary_mode": (
                    int(AUXILIARY_MODES[auxiliary_index])
                    if auxiliary_index >= 0
                    else ""
                ),
                "target": fraction_text(certificate["principal"][index]),
                "slack": fraction_text(certificate["slacks"][index]),
            }
        )
    write_csv(
        ROWS_PATH,
        row_csv,
        ["mode", "row_kind", "retarded_mode", "auxiliary_mode", "target", "slack"],
    )
    write_csv(
        SLACKS_PATH,
        [
            {
                "mode": int(mode),
                "slack": fraction_text(certificate["slacks"][index]),
                "strictly_positive": "true",
            }
            for index, mode in enumerate(TRACKED)
        ],
        ["mode", "slack", "strictly_positive"],
    )

    k3_summary = json.loads(K3_SUMMARY_PATH.read_text(encoding="utf-8"))
    scale = len(TRACKED) // int(k3_summary["lnt_row_count"])
    projected_kernel_seconds = K3_KERNEL_CHECK_SECONDS * Decimal(scale)
    projections = [
        {
            "metric": "row_count",
            "k3_measured": str(k3_summary["lnt_row_count"]),
            "k9_measured_or_projected": str(len(TRACKED)),
            "status": "measured",
        },
        {
            "metric": "kernel_checker_seconds_linear",
            "k3_measured": str(K3_KERNEL_CHECK_SECONDS),
            "k9_measured_or_projected": str(projected_kernel_seconds),
            "status": "projection_not_measurement",
        },
        {
            "metric": "rational_numerator_max_digits",
            "k3_measured": str(k3_summary["rational_numerator_max_digits"]),
            "k9_measured_or_projected": str(
                max(
                    len(str(abs(value.numerator)))
                    for value in certificate["principal"]
                    + certificate["auxiliary"]
                    + certificate["slacks"]
                )
            ),
            "status": "measured_exact_candidate",
        },
        {
            "metric": "rational_denominator_max_digits",
            "k3_measured": str(k3_summary["rational_denominator_max_digits"]),
            "k9_measured_or_projected": str(
                max(
                    len(str(value.denominator))
                    for value in certificate["principal"]
                    + certificate["auxiliary"]
                    + certificate["slacks"]
                )
            ),
            "status": "measured_exact_candidate",
        },
    ]
    write_csv(
        PROJECTIONS_PATH,
        projections,
        ["metric", "k3_measured", "k9_measured_or_projected", "status"],
    )

    conditions = [
        {
            "condition": "1_general_k_semantic_bridge",
            "status": "CLOSED",
            "evidence": "KL2003GeneralKDynamicRetardedLowerBound + KL2003K3LNTCertificate",
        },
        {
            "condition": "2_flat_k9_generator",
            "status": "MEASURED_DATA_CANDIDATE_PASS",
            "evidence": "6561 topology rows generated parametrically; exact Fraction recheck pass",
        },
        {
            "condition": "3_rational_size_and_slack",
            "status": "MEASURED_DATA_CANDIDATE_PASS",
            "evidence": "exact rational candidate metrics in generation_summary.json",
        },
        {
            "condition": "4_kernel_resource_budget",
            "status": "OPEN_REQUIRES_ACTUAL_K9_CHECKER",
            "evidence": "only data elaboration/projection available; no kernel certificate recheck",
        },
    ]
    write_csv(CONDITIONS_PATH, conditions, ["condition", "status", "evidence"])

    mismatches = [
        {"category": row["check_id"], "detail": "topology check failed"}
        for row in checks
        if row["status"] != "pass"
    ]
    write_csv(MISMATCH_PATH, mismatches, ["category", "detail"])

    all_values = (
        certificate["principal"] + certificate["auxiliary"] + certificate["slacks"]
    )
    min_slack = min(certificate["slacks"])
    min_slack_index = certificate["slacks"].index(min_slack)
    summary = {
        "run_id": RUN_ID,
        "verdict": "K9_LNT_EXACT_DATA_CANDIDATE_PASS_KERNEL_GATE_OPEN",
        "k": K,
        "tracked_class_count": len(TRACKED),
        "auxiliary_class_count": len(AUXILIARY_MODES),
        "pre_reduction_class_count": MODULUS,
        "row_counts": {
            "D1": int(np.sum(data["kinds"] == 2)),
            "D2": int(np.sum(data["kinds"] == 5)),
            "D3": int(np.sum(data["kinds"] == 8)),
        },
        "lambda": fraction_text(LAMBDA),
        "source_lambda9": str(SOURCE_LAMBDA9),
        "gamma_diagnostic": diag["gamma"],
        "source_gamma9": str(SOURCE_GAMMA9),
        "cmax": fraction_text(max(certificate["principal"])),
        "source_cmax9": str(SOURCE_CMAX9),
        "minimum_row_slack": fraction_text(min_slack),
        "minimum_row_slack_decimal": str(
            Decimal(min_slack.numerator) / Decimal(min_slack.denominator)
        ),
        "minimum_row_slack_mode": int(TRACKED[min_slack_index]),
        "rational_numerator_max_digits": max(
            len(str(abs(value.numerator))) for value in all_values
        ),
        "rational_denominator_max_digits": max(
            len(str(value.denominator)) for value in all_values
        ),
        "power_iterations": iterations,
        "power_rho": format(rho, ".17g"),
        "power_relative_change": format(relative_change, ".17g"),
        "topology_runtime_seconds": format(topology_runtime, ".6f"),
        "search_runtime_seconds": format(solver_runtime, ".6f"),
        "exact_recheck_runtime_seconds": format(exact_runtime, ".6f"),
        "total_generator_runtime_seconds": format(time.perf_counter() - total_start, ".6f"),
        "json_bytes": JSON_PATH.stat().st_size,
        "lean_data_bytes": LEAN_PATH.stat().st_size,
        "lean_checker_shard_count": len(checker_shards),
        "lean_checker_total_bytes": sum(path.stat().st_size for path in checker_shards),
        "mismatch_count": len(mismatches),
        "exact_checks": certificate["exact_checks"],
        "f2_conditions": {row["condition"]: row["status"] for row in conditions},
        "kernel_checker_status": "NOT_RUN_NOT_IMPLEMENTED",
        "z3_exact_monolithic_status": "ABANDONED_AFTER_NO_RESULT_WITHIN_INTERACTIVE_BUDGET",
        "classification": [
            "K9_FLAT_LNT_TOPOLOGY_GENERATED",
            "K9_EXACT_RATIONAL_DATA_CANDIDATE_FOUND",
            "K9_ALL_6561_ROW_SLACKS_POSITIVE_IN_FRACTION_RECHECK",
            "K9_KERNEL_CHECKER_NOT_YET_IMPLEMENTED",
            "K9_FORMALIZATION_NOT_AUTHORIZED",
            "K11_DEFERRED",
            "NO_K9_THEOREM_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }
    write_json(SUMMARY_PATH, summary)
    manifest_inputs = [
        JSON_PATH,
        LEAN_PATH,
        ROWS_PATH,
        SLACKS_PATH,
        CONDITIONS_PATH,
        PROJECTIONS_PATH,
        SUMMARY_PATH,
        MISMATCH_PATH,
        REPO_ROOT / "scripts" / GENERATOR_VERSION,
        *checker_shards,
    ]
    write_csv(
        MANIFEST_PATH,
        [{"path": repo_rel(path), "sha256": sha256(path)} for path in manifest_inputs],
        ["path", "sha256"],
    )
    print(
        json.dumps(
            {
                "verdict": summary["verdict"],
                "row_count": len(TRACKED),
                "minimum_row_slack": summary["minimum_row_slack"],
                "cmax": summary["cmax"],
                "runtime_seconds": summary["total_generator_runtime_seconds"],
                "kernel_checker_status": summary["kernel_checker_status"],
            },
            sort_keys=True,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
