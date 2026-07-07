#!/usr/bin/env python3
"""Empirical scaling-seam and rounding-ledger diagnostic for KL2003 k=2.

This script does not prove the rounding ledger.  It tests the Nat combinatorial
core on a finite grid and records a conservative diagnostic normalization for
floor/ceil losses.  It makes no M0/M1 theorem claim and no global Collatz claim.
"""

from __future__ import annotations

import csv
import hashlib
import json
from collections import deque
from functools import lru_cache
from fractions import Fraction
from pathlib import Path
from typing import Any


MAX_A = 500
MAX_X_GLOBAL = 10_000
RESIDUES = (2, 5, 8)
ROW_FOR_RESIDUE = {2: "D1", 5: "D2", 8: "D3"}
BUDGETS = {
    "D1": Fraction(29, 9720),
    "D2": Fraction(271, 729000),
    "D3": Fraction(2077, 145800),
}

OUTPUT_DIR = Path("outputs/KL2003_SCALING_SEAM_ROUNDING_EMPIRICAL_v1")
SUMMARY_JSON = OUTPUT_DIR / "summary.json"
GRID_CSV = OUTPUT_DIR / "grid.csv"
MISMATCH_CSV = OUTPUT_DIR / "mismatch.csv"
C25_CASES_CSV = OUTPUT_DIR / "c25_cases.csv"
MANIFEST_SHA256_CSV = OUTPUT_DIR / "manifest_sha256.csv"

SCRIPT_PATH = Path("scripts/kl2003_scaling_seam_rounding_empirical_v1.py")
INPUT_PATHS = [
    SCRIPT_PATH,
    Path("docs/KL2003_SCALING_SEAM_PAPER_DRAFT_v1.md"),
    Path("docs/KL2003_K2_CERTIFICATE_ENDPOINT_UNIFICATION_BLO_UPGRADE_v1.md"),
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


def frac_str(value: Fraction) -> str:
    if value.denominator == 1:
        return str(value.numerator)
    return f"{value.numerator}/{value.denominator}"


def frac_float(value: Fraction) -> float:
    return float(value.numerator) / float(value.denominator)


def class_name_mod_9(n: int | None) -> str:
    if n is None:
        return "none"
    residue = n % 9
    if residue == 2:
        return "c22"
    if residue == 5:
        return "c25"
    if residue == 8:
        return "c28"
    return f"other_mod9_{residue}"


@lru_cache(maxsize=None)
def pi_star_prefix_counts(root: int) -> tuple[int, ...]:
    """Return counts[x] = piStar(root, x) for 0 <= x <= MAX_X_GLOBAL.

    The BFS stores the maximum value on the inverse path from the root to each
    node.  A node contributes to piStar(root, x) exactly when that path maximum
    is at most x.
    """

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


def file_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def update_worst(
    store: dict[str, dict[str, Any]],
    key: str,
    candidate: Fraction,
    row: dict[str, Any],
) -> None:
    current = store.get(key)
    if current is None or candidate > current["value"]:
        store[key] = {
            "value": candidate,
            "row": row,
        }


def compact_case(row: dict[str, Any]) -> dict[str, Any]:
    keys = [
        "a",
        "x",
        "row",
        "residue",
        "c",
        "c_mod9",
        "advanced_class",
        "target_count",
        "ret_count",
        "adv_count",
        "row_lhs",
        "target_floor_loss",
        "advanced_floor_loss",
        "normalized_loss_candidate",
        "budget",
        "diagnostic_budget_margin",
        "advanced_usable",
        "core_nat_ok",
    ]
    return {key: row[key] for key in keys}


def write_manifest() -> None:
    paths = [
        *INPUT_PATHS,
        SUMMARY_JSON,
        GRID_CSV,
        MISMATCH_CSV,
        C25_CASES_CSV,
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
    core_nat_ok_count = 0
    core_nat_fail_count = 0
    core_nat_skipped_count = 0
    advanced_usable_count = 0
    advanced_not_usable_count = 0
    c25_case_count = 0
    advanced_c25_case_count = 0
    d2_row_count = 0
    mismatch_count = 0

    max_target_floor_loss = Fraction(0)
    max_advanced_floor_loss = Fraction(0)
    max_normalized_loss_by_row: dict[str, dict[str, Any]] = {}
    max_normalized_loss_by_row_all_grid: dict[str, dict[str, Any]] = {}
    max_normalized_loss_by_class: dict[str, dict[str, Any]] = {}
    c25_worst_case: dict[str, Any] | None = None

    grid_digest = hashlib.sha256()

    grid_fields = [
        "a",
        "x",
        "residue",
        "row",
        "known_cycle_root",
        "c_exists",
        "c",
        "c_mod9",
        "advanced_class",
        "xRet",
        "qAdv",
        "xAdv",
        "xRet_le_x",
        "xAdv_le_x",
        "advanced_usable",
        "target_count",
        "ret_count",
        "adv_count",
        "two_branch_lhs",
        "d2_one_branch_lhs",
        "row_lhs",
        "core_nat_ok",
        "core_nat_status",
        "target_floor_loss",
        "advanced_floor_loss",
        "normalized_loss_candidate",
        "budget",
        "diagnostic_budget_margin",
        "c25_or_d2_case",
    ]

    with (
        GRID_CSV.open("w", newline="", encoding="utf-8") as grid_handle,
        MISMATCH_CSV.open("w", newline="", encoding="utf-8") as mismatch_handle,
        C25_CASES_CSV.open("w", newline="", encoding="utf-8") as c25_handle,
    ):
        grid_writer = csv.DictWriter(grid_handle, fieldnames=grid_fields)
        mismatch_writer = csv.DictWriter(mismatch_handle, fieldnames=grid_fields)
        c25_writer = csv.DictWriter(c25_handle, fieldnames=grid_fields)
        grid_writer.writeheader()
        mismatch_writer.writeheader()
        c25_writer.writeheader()

        for a in range(1, MAX_A + 1):
            residue = a % 9
            if residue not in RESIDUES:
                continue

            row_name = ROW_FOR_RESIDUE[residue]
            max_x_for_a = min(MAX_X_GLOBAL, 32 * a)
            known_cycle_root = a in (1, 2)
            c_num = 2 * a - 1
            c_exists = c_num % 3 == 0
            c = c_num // 3 if c_exists else None
            advanced_class = class_name_mod_9(c)

            for x in range(a, max_x_for_a + 1):
                xRet = x
                qAdv = ceil_div(x, 2 * a)
                xAdv = x - qAdv
                xRet_le_x = xRet <= x
                xAdv_le_x = xAdv <= x
                advanced_usable = bool(c_exists and c is not None and c <= xAdv)

                target_count = pi_star(a, x)
                ret_count = pi_star(4 * a, xRet)
                adv_count = pi_star(c, xAdv) if c_exists else 0

                two_branch_lhs = ret_count + adv_count
                d2_one_branch_lhs = ret_count
                if row_name == "D2":
                    row_lhs = d2_one_branch_lhs
                    row_core_ok_raw = row_lhs <= target_count
                else:
                    row_lhs = two_branch_lhs
                    row_core_ok_raw = c_exists and row_lhs <= target_count

                if known_cycle_root:
                    core_nat_ok = True
                    core_nat_status = "skipped_known_cycle_root"
                    core_nat_skipped_count += 1
                elif not c_exists:
                    core_nat_ok = True
                    core_nat_status = "skipped_no_advanced_child"
                    core_nat_skipped_count += 1
                else:
                    core_nat_ok = bool(row_core_ok_raw)
                    core_nat_status = "ok" if core_nat_ok else "fail"
                    if core_nat_ok:
                        core_nat_ok_count += 1
                    else:
                        core_nat_fail_count += 1

                if advanced_usable:
                    advanced_usable_count += 1
                else:
                    advanced_not_usable_count += 1

                target_floor_loss = Fraction(0)
                ideal_advanced = Fraction(x * (2 * a - 1), 2 * a)
                advanced_floor_loss = ideal_advanced - Fraction(xAdv)
                if advanced_floor_loss < 0 or advanced_floor_loss >= 1:
                    raise AssertionError("advanced_floor_loss must lie in [0,1)")
                normalized_loss = advanced_floor_loss / x

                max_target_floor_loss = max(max_target_floor_loss, target_floor_loss)
                max_advanced_floor_loss = max(max_advanced_floor_loss, advanced_floor_loss)

                budget = BUDGETS[row_name]
                diagnostic_budget_margin = budget - normalized_loss

                row_for_worst = {
                    "a": a,
                    "x": x,
                    "row": row_name,
                    "residue": residue,
                    "c": c if c is not None else "",
                    "c_mod9": c % 9 if c is not None else "",
                    "advanced_class": advanced_class,
                    "target_count": target_count,
                    "ret_count": ret_count,
                    "adv_count": adv_count,
                    "row_lhs": row_lhs,
                    "target_floor_loss": frac_str(target_floor_loss),
                    "advanced_floor_loss": frac_str(advanced_floor_loss),
                    "normalized_loss_candidate": frac_str(normalized_loss),
                    "budget": frac_str(budget),
                    "diagnostic_budget_margin": frac_str(diagnostic_budget_margin),
                    "advanced_usable": "yes" if advanced_usable else "no",
                    "core_nat_ok": "yes" if core_nat_ok else "no",
                }
                update_worst(
                    max_normalized_loss_by_row_all_grid,
                    row_name,
                    normalized_loss,
                    row_for_worst,
                )
                if not known_cycle_root and c_exists:
                    update_worst(max_normalized_loss_by_row, row_name, normalized_loss, row_for_worst)
                update_worst(
                    max_normalized_loss_by_class,
                    advanced_class,
                    normalized_loss,
                    row_for_worst,
                )

                c25_or_d2_case = row_name == "D2" or advanced_class == "c25"
                if row_name == "D2":
                    d2_row_count += 1
                if advanced_class == "c25":
                    advanced_c25_case_count += 1
                if c25_or_d2_case:
                    c25_case_count += 1
                    if (
                        c25_worst_case is None
                        or normalized_loss > Fraction(c25_worst_case["normalized_loss_candidate"])
                    ):
                        c25_worst_case = {
                            **row_for_worst,
                            "normalized_loss_candidate": frac_str(normalized_loss),
                        }

                csv_row = {
                    "a": a,
                    "x": x,
                    "residue": residue,
                    "row": row_name,
                    "known_cycle_root": "yes" if known_cycle_root else "no",
                    "c_exists": "yes" if c_exists else "no",
                    "c": c if c is not None else "",
                    "c_mod9": c % 9 if c is not None else "",
                    "advanced_class": advanced_class,
                    "xRet": xRet,
                    "qAdv": qAdv,
                    "xAdv": xAdv,
                    "xRet_le_x": "yes" if xRet_le_x else "no",
                    "xAdv_le_x": "yes" if xAdv_le_x else "no",
                    "advanced_usable": "yes" if advanced_usable else "no",
                    "target_count": target_count,
                    "ret_count": ret_count,
                    "adv_count": adv_count,
                    "two_branch_lhs": two_branch_lhs,
                    "d2_one_branch_lhs": d2_one_branch_lhs,
                    "row_lhs": row_lhs,
                    "core_nat_ok": "yes" if core_nat_ok else "no",
                    "core_nat_status": core_nat_status,
                    "target_floor_loss": frac_str(target_floor_loss),
                    "advanced_floor_loss": frac_str(advanced_floor_loss),
                    "normalized_loss_candidate": frac_str(normalized_loss),
                    "budget": frac_str(budget),
                    "diagnostic_budget_margin": frac_str(diagnostic_budget_margin),
                    "c25_or_d2_case": "yes" if c25_or_d2_case else "no",
                }

                grid_writer.writerow(csv_row)
                grid_digest.update(
                    (
                        f"{a},{x},{row_name},{target_count},{ret_count},{adv_count},"
                        f"{csv_row['core_nat_status']},{frac_str(normalized_loss)}\n"
                    ).encode("utf-8")
                )
                total_rows += 1

                if not core_nat_ok or not xRet_le_x or not xAdv_le_x:
                    mismatch_writer.writerow(csv_row)
                    mismatch_count += 1
                if c25_or_d2_case:
                    c25_writer.writerow(csv_row)

    def worst_to_json(entry: dict[str, Any]) -> dict[str, Any]:
        value = entry["value"]
        return {
            "value": frac_str(value),
            "value_float": frac_float(value),
            "row": entry["row"],
        }

    max_norm_by_row_json = {
        key: worst_to_json(value) for key, value in sorted(max_normalized_loss_by_row.items())
    }
    max_norm_by_row_all_grid_json = {
        key: worst_to_json(value)
        for key, value in sorted(max_normalized_loss_by_row_all_grid.items())
    }
    max_norm_by_class_json = {
        key: worst_to_json(value) for key, value in sorted(max_normalized_loss_by_class.items())
    }

    diagnostic_budget_margin_by_row: dict[str, dict[str, Any]] = {}
    for row_name, budget in BUDGETS.items():
        max_loss = max_normalized_loss_by_row[row_name]["value"]
        margin = budget - max_loss
        diagnostic_budget_margin_by_row[row_name] = {
            "budget": frac_str(budget),
            "budget_float": frac_float(budget),
            "max_normalized_loss_candidate": frac_str(max_loss),
            "max_normalized_loss_candidate_float": frac_float(max_loss),
            "margin": frac_str(margin),
            "margin_float": frac_float(margin),
            "status": "DIAGNOSTIC_ONLY_NOT_FORMAL",
            "candidate_fits_budget": margin >= 0,
        }

    c25_budget = BUDGETS["D2"]
    c25_max_loss = max(
        [
            max_normalized_loss_by_class.get("c25", {"value": Fraction(0)})["value"],
            max_normalized_loss_by_row.get("D2", {"value": Fraction(0)})["value"],
        ]
    )
    c25_margin = c25_budget - c25_max_loss

    summary: dict[str, Any] = {
        "status": "PASS_CORE_NAT_DIAGNOSTIC_ROUNDING_ONLY"
        if core_nat_fail_count == 0 and mismatch_count == 0
        else "FAIL_CORE_NAT",
        "normalization_status": "DIAGNOSTIC_ONLY_NOT_FORMAL",
        "normalization_candidate": "advanced_floor_loss / x",
        "max_a": MAX_A,
        "max_x_global": MAX_X_GLOBAL,
        "residues": list(RESIDUES),
        "budgets": {key: frac_str(value) for key, value in BUDGETS.items()},
        "total_rows": total_rows,
        "core_nat_ok_count": core_nat_ok_count,
        "core_nat_fail_count": core_nat_fail_count,
        "core_nat_skipped_count": core_nat_skipped_count,
        "advanced_usable_count": advanced_usable_count,
        "advanced_not_usable_count": advanced_not_usable_count,
        "c25_case_count": c25_case_count,
        "advanced_c25_case_count": advanced_c25_case_count,
        "d2_row_count": d2_row_count,
        "max_target_floor_loss": frac_str(max_target_floor_loss),
        "max_target_floor_loss_float": frac_float(max_target_floor_loss),
        "max_advanced_floor_loss": frac_str(max_advanced_floor_loss),
        "max_advanced_floor_loss_float": frac_float(max_advanced_floor_loss),
        "max_normalized_loss_by_row": max_norm_by_row_json,
        "max_normalized_loss_by_row_all_grid": max_norm_by_row_all_grid_json,
        "max_normalized_loss_by_class": max_norm_by_class_json,
        "budget_margin_by_row_if_defined": diagnostic_budget_margin_by_row,
        "c25_worst_case": c25_worst_case,
        "c25_budget_diagnostic": {
            "budget_used": "D2",
            "budget": frac_str(c25_budget),
            "max_c25_or_d2_normalized_loss_candidate": frac_str(c25_max_loss),
            "margin": frac_str(c25_margin),
            "candidate_fits_budget": c25_margin >= 0,
            "status": "DIAGNOSTIC_ONLY_NOT_FORMAL",
        },
        "mismatch_count": mismatch_count,
        "grid_digest_sha256": grid_digest.hexdigest(),
        "outputs": {
            "summary_json": str(SUMMARY_JSON),
            "grid_csv": str(GRID_CSV),
            "mismatch_csv": str(MISMATCH_CSV),
            "c25_cases_csv": str(C25_CASES_CSV),
            "manifest_sha256_csv": str(MANIFEST_SHA256_CSV),
        },
        "no_claims": {
            "no_lean": True,
            "no_m0c": True,
            "no_m1_theorem": True,
            "no_global_collatz_claim": True,
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
