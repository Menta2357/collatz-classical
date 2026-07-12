#!/usr/bin/env python3
"""Empirical chain check for the KL2003 concrete-Phi rowsV2 seam.

This script checks the Nat-level row22/row25/row28 chains described in
KL2003_CONCRETE_PHI_ROWS_V2_SEAM_SCOPING_v1.md.  It is a finite diagnostic
only: it does not prove the seam, does not construct K2RetardedInductionInputsV2,
and makes no M1 or global Collatz claim.
"""

from __future__ import annotations

import csv
import hashlib
import json
from collections import Counter, deque
from functools import lru_cache
from fractions import Fraction
from pathlib import Path
from typing import Any


MAX_A = 500
MAX_X_GLOBAL = 10_000
X_FACTOR = 32
RESIDUES = (2, 5, 8)
TRACKED_CLASSES = (2, 5, 8)

OUTPUT_DIR = Path("outputs/KL2003_CONCRETE_PHI_ROWS_V2_CHAIN_EMPIRICAL_v1")
SUMMARY_JSON = OUTPUT_DIR / "summary.json"
GRID_CSV = OUTPUT_DIR / "grid.csv"
MISMATCH_CSV = OUTPUT_DIR / "mismatch.csv"
ROW22_PARITY_LIFT_CASES_CSV = OUTPUT_DIR / "row22_parity_lift_cases.csv"
MANIFEST_SHA256_CSV = OUTPUT_DIR / "manifest_sha256.csv"

SCRIPT_PATH = Path("scripts/kl2003_concrete_phi_rows_v2_chain_empirical_v1.py")
INPUT_PATHS = [
    SCRIPT_PATH,
    Path("docs/KL2003_CONCRETE_PHI_ROWS_V2_SEAM_SCOPING_v1.md"),
    Path("scripts/kl2003_m0a_pi_star_cross_validation_v1.py"),
    Path("scripts/krasikov_m1_sanity.py"),
]


def T(n: int) -> int:
    if n < 0:
        raise ValueError("T is defined only on Nat-compatible integers")
    return n // 2 if n % 2 == 0 else (3 * n + 1) // 2


def inverse_predecessors(z: int) -> list[int]:
    candidates = [2 * z]
    numerator = 2 * z - 1
    if numerator % 3 == 0:
        candidates.append(numerator // 3)
    return candidates


def ceil_div(n: int, d: int) -> int:
    if d <= 0:
        raise ValueError("ceil_div expects a positive denominator")
    return (n + d - 1) // d


def bool_text(value: bool) -> str:
    return "yes" if value else "no"


def row_name_for_residue(residue: int) -> str:
    return {2: "row22", 5: "row25", 8: "row28"}[residue]


def branch_label_for_mod9(residue: int) -> str:
    if residue == 2:
        return "phi22_outer_arm"
    if residue == 5:
        return "M1V2_nested_class25_elimination"
    if residue == 8:
        return "phi28_plus_M1V2_outer_arm"
    return f"untracked_mod9_{residue}"


def frac_str(value: Fraction) -> str:
    if value.denominator == 1:
        return str(value.numerator)
    return f"{value.numerator}/{value.denominator}"


def file_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


@lru_cache(maxsize=None)
def pi_star_prefix_counts(root: int) -> tuple[int, ...]:
    """Return counts[x] = piStar(root, x) for 0 <= x <= MAX_X_GLOBAL."""

    if root < 1 or root > MAX_X_GLOBAL:
        return tuple(0 for _ in range(MAX_X_GLOBAL + 1))

    best_path_max: dict[int, int] = {root: root}
    frontier: deque[int] = deque([root])

    while frontier:
        z = frontier.popleft()
        z_path_max = best_path_max[z]
        for pred in inverse_predecessors(z):
            if not (1 <= pred <= MAX_X_GLOBAL):
                continue
            if T(pred) != z:
                continue
            pred_path_max = max(z_path_max, pred)
            old = best_path_max.get(pred)
            if old is None or pred_path_max < old:
                best_path_max[pred] = pred_path_max
                frontier.append(pred)

    by_path_max = [0] * (MAX_X_GLOBAL + 1)
    for path_max in best_path_max.values():
        by_path_max[path_max] += 1

    running = 0
    prefix: list[int] = []
    for x in range(MAX_X_GLOBAL + 1):
        running += by_path_max[x]
        prefix.append(running)
    return tuple(prefix)


def pi_star(root: int | None, x: int) -> int:
    if root is None or x < 0:
        return 0
    if x > MAX_X_GLOBAL:
        raise ValueError("x exceeds MAX_X_GLOBAL")
    return pi_star_prefix_counts(root)[x]


def advanced_child(a: int) -> int:
    numerator = 2 * a - 1
    if numerator % 3 != 0:
        raise ValueError(f"advanced child is not integral for a={a}")
    return numerator // 3


def expected_row22_lift_mod9(t_mod3: int) -> int:
    return {0: 2, 1: 5, 2: 8}[t_mod3]


def expected_row28_child_mod9(t_mod3: int) -> int:
    return {0: 5, 1: 2, 2: 8}[t_mod3]


def row22_parity_lift_record(a: int) -> dict[str, Any]:
    t = (a - 2) // 9
    c = advanced_child(a)
    lifted = 2 * c
    direct_ratio = Fraction(3 * c, 2 * a)
    lifted_ratio = Fraction(3 * lifted, 4 * a)
    ideal_ratio = Fraction(2 * a - 1, 2 * a)
    t_mod3 = t % 3

    return {
        "a": a,
        "t": t,
        "known_cycle_root": bool_text(a in (1, 2)),
        "c": c,
        "c_mod3": c % 3,
        "c_mod9": c % 9,
        "lifted_2c": lifted,
        "lifted_mod9": lifted % 9,
        "t_mod3": t_mod3,
        "expected_lifted_mod9": expected_row22_lift_mod9(t_mod3),
        "c_mod3_is_one": bool_text(c % 3 == 1),
        "lifted_tracked_class": bool_text(lifted % 9 in TRACKED_CLASSES),
        "lifted_residue_expected": bool_text(lifted % 9 == expected_row22_lift_mod9(t_mod3)),
        "T_lifted_eq_c": bool_text(T(lifted) == c),
        "T_c_eq_a": bool_text(T(c) == a),
        "direct_advanced_ratio": frac_str(direct_ratio),
        "lifted_shift_ratio": frac_str(lifted_ratio),
        "ideal_advanced_ratio": frac_str(ideal_ratio),
        "shift_alpha_minus_2_accounting_ok": bool_text(
            direct_ratio == lifted_ratio == ideal_ratio
        ),
    }


def write_manifest() -> None:
    paths = [
        *INPUT_PATHS,
        SUMMARY_JSON,
        GRID_CSV,
        MISMATCH_CSV,
        ROW22_PARITY_LIFT_CASES_CSV,
    ]
    with MANIFEST_SHA256_CSV.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=["path", "sha256", "bytes"])
        writer.writeheader()
        for path in paths:
            writer.writerow(
                {
                    "path": str(path),
                    "sha256": file_sha256(path),
                    "bytes": path.stat().st_size,
                }
            )


def main() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    total_rows = 0
    mismatch_count = 0
    known_cycle_skipped_rows = 0
    row_counts: Counter[str] = Counter()
    core_ok_counts: Counter[str] = Counter()
    core_fail_counts: Counter[str] = Counter()
    route_ok_counts: Counter[str] = Counter()
    route_fail_counts: Counter[str] = Counter()
    row22_lift_subset_fail_count = 0
    row22_lift_class_counts: Counter[str] = Counter()
    row28_child_class_counts: Counter[str] = Counter()
    row28_branch_counts: Counter[str] = Counter()
    row25_retarded_exact_fail_count = 0
    row25_single_branch_fail_count = 0
    row22_parity_lift_fail_roots = 0
    row22_parity_lift_ok_roots = 0

    grid_digest = hashlib.sha256()

    grid_fields = [
        "a",
        "x",
        "residue",
        "row",
        "known_cycle_root",
        "t",
        "c",
        "c_mod3",
        "c_mod9",
        "lifted_2c",
        "lifted_mod9",
        "row28_branch",
        "xRet",
        "qAdv",
        "xAdv",
        "xRet_eq_x",
        "xAdv_le_x",
        "advanced_window_contains_c",
        "advanced_window_contains_lifted",
        "target_count",
        "retarded_count",
        "advanced_c_count",
        "advanced_lifted_count",
        "direct_two_branch_lhs",
        "tracked_lhs",
        "core_status",
        "core_ok",
        "route_ok",
        "retarded_route_ok",
        "row25_retarded_source_mod9_ok",
        "row22_c_mod3_is_one",
        "row22_lifted_tracked_class",
        "row22_lifted_residue_expected",
        "row22_shift_accounting_ok",
        "row22_lift_count_le_c_count",
        "row28_child_residue_expected",
        "mismatch_reason",
    ]

    parity_fields = [
        "a",
        "t",
        "known_cycle_root",
        "c",
        "c_mod3",
        "c_mod9",
        "lifted_2c",
        "lifted_mod9",
        "t_mod3",
        "expected_lifted_mod9",
        "c_mod3_is_one",
        "lifted_tracked_class",
        "lifted_residue_expected",
        "T_lifted_eq_c",
        "T_c_eq_a",
        "direct_advanced_ratio",
        "lifted_shift_ratio",
        "ideal_advanced_ratio",
        "shift_alpha_minus_2_accounting_ok",
    ]

    with ROW22_PARITY_LIFT_CASES_CSV.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=parity_fields)
        writer.writeheader()
        for a in range(1, MAX_A + 1):
            if a % 9 != 2:
                continue
            record = row22_parity_lift_record(a)
            writer.writerow(record)
            ok = all(
                record[field] == "yes"
                for field in [
                    "c_mod3_is_one",
                    "lifted_tracked_class",
                    "lifted_residue_expected",
                    "T_lifted_eq_c",
                    "T_c_eq_a",
                    "shift_alpha_minus_2_accounting_ok",
                ]
            )
            if ok:
                row22_parity_lift_ok_roots += 1
            else:
                row22_parity_lift_fail_roots += 1

    with (
        GRID_CSV.open("w", newline="", encoding="utf-8") as grid_handle,
        MISMATCH_CSV.open("w", newline="", encoding="utf-8") as mismatch_handle,
    ):
        grid_writer = csv.DictWriter(grid_handle, fieldnames=grid_fields)
        mismatch_writer = csv.DictWriter(mismatch_handle, fieldnames=grid_fields)
        grid_writer.writeheader()
        mismatch_writer.writeheader()

        for a in range(1, MAX_A + 1):
            residue = a % 9
            if residue not in RESIDUES:
                continue

            row_name = row_name_for_residue(residue)
            t = (a - residue) // 9
            c = advanced_child(a)
            lifted = 2 * c
            known_cycle_root = a in (1, 2)
            max_x_for_a = min(MAX_X_GLOBAL, X_FACTOR * a)

            retarded_route_ok = T(4 * a) == 2 * a and T(2 * a) == a
            row25_retarded_source_mod9_ok = (4 * a) % 9 == 2 if residue == 5 else True

            row22_c_mod3_is_one = True
            row22_lifted_tracked_class = True
            row22_lifted_residue_expected = True
            row22_shift_accounting_ok = True
            row28_child_residue_expected = True
            row28_branch = ""

            if residue == 2:
                row22_c_mod3_is_one = c % 3 == 1
                row22_lifted_tracked_class = lifted % 9 in TRACKED_CLASSES
                row22_lifted_residue_expected = lifted % 9 == expected_row22_lift_mod9(t % 3)
                row22_shift_accounting_ok = (
                    Fraction(3 * c, 2 * a)
                    == Fraction(3 * lifted, 4 * a)
                    == Fraction(2 * a - 1, 2 * a)
                )
                row22_lift_class_counts[str(lifted % 9)] += max_x_for_a - a + 1
            elif residue == 8:
                row28_child_residue_expected = c % 9 == expected_row28_child_mod9(t % 3)
                row28_branch = branch_label_for_mod9(c % 9)
                row28_child_class_counts[str(c % 9)] += max_x_for_a - a + 1
                row28_branch_counts[row28_branch] += max_x_for_a - a + 1

            advanced_route_ok = True
            if residue == 2:
                advanced_route_ok = T(lifted) == c and T(c) == a
            elif residue == 8:
                advanced_route_ok = T(c) == a

            route_static_ok = (
                retarded_route_ok
                and advanced_route_ok
                and row25_retarded_source_mod9_ok
                and row22_c_mod3_is_one
                and row22_lifted_tracked_class
                and row22_lifted_residue_expected
                and row22_shift_accounting_ok
                and row28_child_residue_expected
            )

            for x in range(a, max_x_for_a + 1):
                xRet = x
                qAdv = ceil_div(x, 2 * a)
                xAdv = x - qAdv
                xRet_eq_x = xRet == x
                xAdv_le_x = xAdv <= x
                advanced_window_contains_c = c <= xAdv
                advanced_window_contains_lifted = lifted <= xAdv

                target_count = pi_star(a, x)
                retarded_count = pi_star(4 * a, xRet)
                advanced_c_count = pi_star(c, xAdv)
                advanced_lifted_count = pi_star(lifted, xAdv)

                direct_two_branch_lhs = retarded_count + advanced_c_count
                if residue == 2:
                    tracked_lhs = retarded_count + advanced_lifted_count
                elif residue == 5:
                    tracked_lhs = retarded_count
                else:
                    tracked_lhs = direct_two_branch_lhs

                row22_lift_count_le_c_count = advanced_lifted_count <= advanced_c_count
                if residue == 2 and not row22_lift_count_le_c_count:
                    row22_lift_subset_fail_count += 1

                core_ok_raw = tracked_lhs <= target_count
                if known_cycle_root:
                    core_status = "skipped_known_cycle_root"
                    core_ok = True
                    known_cycle_skipped_rows += 1
                else:
                    core_status = "ok" if core_ok_raw else "fail"
                    core_ok = core_ok_raw

                if core_ok and not known_cycle_root:
                    core_ok_counts[row_name] += 1
                elif not core_ok:
                    core_fail_counts[row_name] += 1

                route_ok = (
                    route_static_ok
                    and xRet_eq_x
                    and xAdv_le_x
                    and row22_lift_count_le_c_count
                )
                if route_ok:
                    route_ok_counts[row_name] += 1
                else:
                    route_fail_counts[row_name] += 1

                if residue == 5:
                    if not xRet_eq_x:
                        row25_retarded_exact_fail_count += 1
                    if not core_ok:
                        row25_single_branch_fail_count += 1

                mismatch_reasons: list[str] = []
                if not route_ok:
                    mismatch_reasons.append("route_or_chain_failure")
                if not core_ok:
                    mismatch_reasons.append(core_status)

                csv_row = {
                    "a": a,
                    "x": x,
                    "residue": residue,
                    "row": row_name,
                    "known_cycle_root": bool_text(known_cycle_root),
                    "t": t,
                    "c": c,
                    "c_mod3": c % 3,
                    "c_mod9": c % 9,
                    "lifted_2c": lifted if residue == 2 else "",
                    "lifted_mod9": lifted % 9 if residue == 2 else "",
                    "row28_branch": row28_branch,
                    "xRet": xRet,
                    "qAdv": qAdv,
                    "xAdv": xAdv,
                    "xRet_eq_x": bool_text(xRet_eq_x),
                    "xAdv_le_x": bool_text(xAdv_le_x),
                    "advanced_window_contains_c": bool_text(advanced_window_contains_c),
                    "advanced_window_contains_lifted": bool_text(advanced_window_contains_lifted),
                    "target_count": target_count,
                    "retarded_count": retarded_count,
                    "advanced_c_count": advanced_c_count,
                    "advanced_lifted_count": advanced_lifted_count if residue == 2 else "",
                    "direct_two_branch_lhs": direct_two_branch_lhs,
                    "tracked_lhs": tracked_lhs,
                    "core_status": core_status,
                    "core_ok": bool_text(core_ok),
                    "route_ok": bool_text(route_ok),
                    "retarded_route_ok": bool_text(retarded_route_ok),
                    "row25_retarded_source_mod9_ok": bool_text(row25_retarded_source_mod9_ok),
                    "row22_c_mod3_is_one": bool_text(row22_c_mod3_is_one),
                    "row22_lifted_tracked_class": bool_text(row22_lifted_tracked_class),
                    "row22_lifted_residue_expected": bool_text(row22_lifted_residue_expected),
                    "row22_shift_accounting_ok": bool_text(row22_shift_accounting_ok),
                    "row22_lift_count_le_c_count": bool_text(row22_lift_count_le_c_count),
                    "row28_child_residue_expected": bool_text(row28_child_residue_expected),
                    "mismatch_reason": ";".join(mismatch_reasons),
                }

                grid_writer.writerow(csv_row)
                grid_digest.update(
                    (
                        f"{a},{x},{row_name},{target_count},{tracked_lhs},"
                        f"{csv_row['core_status']},{csv_row['route_ok']}\n"
                    ).encode("utf-8")
                )
                row_counts[row_name] += 1
                total_rows += 1

                if mismatch_reasons:
                    mismatch_writer.writerow(csv_row)
                    mismatch_count += 1

    status = "PASS" if mismatch_count == 0 and row22_parity_lift_fail_roots == 0 else "FAIL"
    summary: dict[str, Any] = {
        "status": status,
        "grid": {
            "max_a": MAX_A,
            "max_x_global": MAX_X_GLOBAL,
            "x_factor": X_FACTOR,
            "residues": list(RESIDUES),
            "x_range": "a <= x <= min(MAX_X_GLOBAL, X_FACTOR * a)",
        },
        "total_rows": total_rows,
        "mismatch_count": mismatch_count,
        "known_cycle_skipped_rows": known_cycle_skipped_rows,
        "row_counts": dict(sorted(row_counts.items())),
        "core_ok_counts": dict(sorted(core_ok_counts.items())),
        "core_fail_counts": dict(sorted(core_fail_counts.items())),
        "route_ok_counts": dict(sorted(route_ok_counts.items())),
        "route_fail_counts": dict(sorted(route_fail_counts.items())),
        "row22": {
            "parity_lift_root_cases": row22_parity_lift_ok_roots
            + row22_parity_lift_fail_roots,
            "parity_lift_ok_roots": row22_parity_lift_ok_roots,
            "parity_lift_fail_roots": row22_parity_lift_fail_roots,
            "lift_class_counts_over_grid": dict(sorted(row22_lift_class_counts.items())),
            "lift_count_le_direct_child_count_failures": row22_lift_subset_fail_count,
            "validated_chain": "2c -> c -> a",
            "shift_accounting": "(alpha - 1) direct advanced plus parity -1 = alpha - 2",
        },
        "row25": {
            "retarded_exact_window_failures": row25_retarded_exact_fail_count,
            "single_branch_failures": row25_single_branch_fail_count,
            "validated_chain": "4a -> 2a -> a",
            "advanced_branch_consumed": False,
        },
        "row28": {
            "child_class_counts_over_grid": dict(sorted(row28_child_class_counts.items())),
            "branch_counts_over_grid": dict(sorted(row28_branch_counts.items())),
            "validated_chain": "c -> a",
        },
        "grid_digest_sha256": grid_digest.hexdigest(),
        "outputs": {
            "summary_json": str(SUMMARY_JSON),
            "grid_csv": str(GRID_CSV),
            "mismatch_csv": str(MISMATCH_CSV),
            "row22_parity_lift_cases_csv": str(ROW22_PARITY_LIFT_CASES_CSV),
            "manifest_sha256_csv": str(MANIFEST_SHA256_CSV),
        },
        "no_claims": {
            "no_m1_theorem": True,
            "no_global_collatz_claim": True,
            "no_k2_inputs_v2_proof": True,
            "no_lean": True,
        },
    }

    SUMMARY_JSON.write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    write_manifest()
    print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
