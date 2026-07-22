#!/usr/bin/env python3
"""Corrected global-root calibration/holdout driver for F3 three-lift v2."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import sys
import time
from collections import defaultdict
from fractions import Fraction
from pathlib import Path

from f3_three_lift_balance_pilot_v1 import (
    MODULI,
    PARENT_CLASSES,
    SCALES_Y,
    FREEZE_GRID,
    FREEZE_MARGIN,
    UTILITY_FLOOR,
    PiStarCounter,
    T,
    advanced_child,
    decimal_text,
    file_sha256,
    fraction_text,
)


CALIBRATION_INTERVAL = (1, 10_369)
HOLDOUT_INTERVAL = (10_369, 20_737)

PACKAGE_ROOT = Path(__file__).resolve().parent.parent
PREREGISTRATION = PACKAGE_ROOT / "F3_THREE_LIFT_BALANCE_PILOT_PREREGISTRATION_v2.md"
INVALIDATION = PACKAGE_ROOT / "F3_THREE_LIFT_BALANCE_PILOT_V1_INVALIDATION.md"
V1_LIBRARY = Path(__file__).resolve().parent / "f3_three_lift_balance_pilot_v1.py"
DEFAULT_OUTPUT_ROOT = PACKAGE_ROOT / "results/F3_THREE_LIFT_BALANCE_PILOT_v2"


def phase_interval(phase: str) -> tuple[int, int]:
    if phase == "calibration":
        return CALIBRATION_INTERVAL
    if phase == "holdout":
        return HOLDOUT_INTERVAL
    raise ValueError(phase)


def roots_for_type(
    modulus: int,
    parent_residue: int,
    lift: int,
    interval: tuple[int, int],
) -> list[int]:
    lower, upper = interval
    residue_mod_3m = parent_residue + lift * modulus
    period = 3 * modulus
    first = residue_mod_3m
    if first < lower:
        first += ((lower - first + period - 1) // period) * period
    return list(range(first, upper, period))


def config_payload() -> dict[str, object]:
    return {
        "moduli": list(MODULI),
        "parent_classes": list(PARENT_CLASSES),
        "scales_y": list(SCALES_Y),
        "calibration_interval_half_open": list(CALIBRATION_INTERVAL),
        "holdout_interval_half_open": list(HOLDOUT_INTERVAL),
        "holdout_unit": "parent_root_a",
        "freeze_margin": fraction_text(FREEZE_MARGIN),
        "freeze_grid": FREEZE_GRID,
        "utility_floor": fraction_text(UTILITY_FLOOR),
    }


def generate_phase(phase: str, output_dir: Path) -> dict[str, object]:
    started = time.perf_counter()
    interval = phase_interval(phase)
    output_dir.mkdir(parents=True, exist_ok=True)
    root_rows_path = output_dir / "root_rows.csv"
    group_rows_path = output_dir / "group_rows.csv"
    mismatch_path = output_dir / "mismatches.csv"

    counter = PiStarCounter()
    profile_cache: dict[tuple[int, int], dict[int, tuple[int, int]]] = {}
    root_rows: list[dict[str, object]] = []
    mismatches: list[dict[str, object]] = []
    group_target: defaultdict[tuple[int, int, int, int, int], int] = defaultdict(int)
    group_advanced: defaultdict[tuple[int, int, int, int, int], int] = defaultdict(int)
    phase_parent_roots: set[int] = set()

    for modulus in MODULI:
        for parent_class in PARENT_CLASSES:
            for parent_residue in range(modulus):
                if parent_residue % 9 != parent_class:
                    continue
                for lift in range(3):
                    roots = roots_for_type(modulus, parent_residue, lift, interval)
                    for a in roots:
                        phase_parent_roots.add(a)
                        c, child = advanced_child(a, parent_class)
                        cache_key = (a, parent_class)
                        counts = profile_cache.get(cache_key)
                        if counts is None:
                            max_y = max(SCALES_Y)
                            max_x = (2**max_y) * a
                            max_x_adv = max_x - 2 ** (max_y - 1)
                            counts = {}
                            for y in SCALES_Y:
                                x = (2**y) * a
                                x_adv = x - 2 ** (y - 1)
                                counts[y] = (
                                    counter.count(a, x, max_x),
                                    counter.count(child, x_adv, max_x_adv),
                                )
                            profile_cache[cache_key] = counts

                        static_hooks = {
                            "interval": interval[0] <= a < interval[1],
                            "root_residue": a % modulus == parent_residue,
                            "lift_index": ((a - parent_residue) // modulus) % 3 == lift,
                            "integral_c": 3 * c + 1 == 2 * a,
                            "route": (
                                T(child) == c and T(c) == a
                                if parent_class == 2
                                else T(child) == a
                            ),
                        }
                        for y in SCALES_Y:
                            x = (2**y) * a
                            x_adv = x - 2 ** (y - 1)
                            target_count, advanced_count = counts[y]
                            dynamic_hooks = {
                                "window": child <= x_adv <= x,
                                "member_count_transfer": advanced_count <= target_count,
                            }
                            all_hooks = all(static_hooks.values()) and all(
                                dynamic_hooks.values()
                            )
                            row = {
                                "phase": phase,
                                "interval_lower": interval[0],
                                "interval_upper_exclusive": interval[1],
                                "modulus": modulus,
                                "parent_class": parent_class,
                                "parent_residue": parent_residue,
                                "lift": lift,
                                "a": a,
                                "c": c,
                                "advanced_child": child,
                                "y": y,
                                "x": x,
                                "xAdv": x_adv,
                                "target_count": target_count,
                                "advanced_count": advanced_count,
                                "interval_hook": static_hooks["interval"],
                                "root_residue_hook": static_hooks["root_residue"],
                                "lift_index_hook": static_hooks["lift_index"],
                                "integral_c_hook": static_hooks["integral_c"],
                                "route_hook": static_hooks["route"],
                                "window_hook": dynamic_hooks["window"],
                                "member_count_transfer_hook": dynamic_hooks[
                                    "member_count_transfer"
                                ],
                                "all_hooks": all_hooks,
                            }
                            root_rows.append(row)
                            if not all_hooks:
                                mismatches.append(row)
                            key = (modulus, parent_class, parent_residue, lift, y)
                            group_target[key] += target_count
                            group_advanced[key] += advanced_count

    group_rows: list[dict[str, object]] = []
    shares: list[tuple[Fraction, tuple[int, int, int, int, int]]] = []
    for modulus in MODULI:
        for parent_class in PARENT_CLASSES:
            for parent_residue in range(modulus):
                if parent_residue % 9 != parent_class:
                    continue
                root_counts = [
                    len(roots_for_type(modulus, parent_residue, lift, interval))
                    for lift in range(3)
                ]
                for y in SCALES_Y:
                    advanced_masses = [
                        group_advanced[(modulus, parent_class, parent_residue, lift, y)]
                        for lift in range(3)
                    ]
                    target_masses = [
                        group_target[(modulus, parent_class, parent_residue, lift, y)]
                        for lift in range(3)
                    ]
                    advanced_total = sum(advanced_masses)
                    target_total = sum(target_masses)
                    lift_shares = (
                        [Fraction(mass, advanced_total) for mass in advanced_masses]
                        if advanced_total
                        else [Fraction(0, 1)] * 3
                    )
                    for lift, share in enumerate(lift_shares):
                        shares.append(
                            (share, (modulus, parent_class, parent_residue, lift, y))
                        )
                    group_rows.append(
                        {
                            "phase": phase,
                            "modulus": modulus,
                            "parent_class": parent_class,
                            "parent_residue": parent_residue,
                            "y": y,
                            "roots_lift0": root_counts[0],
                            "roots_lift1": root_counts[1],
                            "roots_lift2": root_counts[2],
                            "target_mass_lift0": target_masses[0],
                            "target_mass_lift1": target_masses[1],
                            "target_mass_lift2": target_masses[2],
                            "target_mass_total": target_total,
                            "advanced_mass_lift0": advanced_masses[0],
                            "advanced_mass_lift1": advanced_masses[1],
                            "advanced_mass_lift2": advanced_masses[2],
                            "advanced_mass_total": advanced_total,
                            "advanced_share_lift0_fraction": fraction_text(lift_shares[0]),
                            "advanced_share_lift1_fraction": fraction_text(lift_shares[1]),
                            "advanced_share_lift2_fraction": fraction_text(lift_shares[2]),
                            "advanced_share_lift0": decimal_text(lift_shares[0]),
                            "advanced_share_lift1": decimal_text(lift_shares[1]),
                            "advanced_share_lift2": decimal_text(lift_shares[2]),
                            "min_advanced_share": decimal_text(min(lift_shares)),
                            "max_advanced_share": decimal_text(max(lift_shares)),
                            "advanced_capture_fraction": fraction_text(
                                Fraction(advanced_total, target_total)
                                if target_total
                                else Fraction(0, 1)
                            ),
                            "advanced_total_nonzero": advanced_total > 0,
                        }
                    )

    root_fields = list(root_rows[0].keys())
    group_fields = list(group_rows[0].keys())
    for path, rows, fields in (
        (root_rows_path, root_rows, root_fields),
        (group_rows_path, group_rows, group_fields),
        (mismatch_path, mismatches, root_fields),
    ):
        with path.open("w", newline="", encoding="utf-8") as handle:
            writer = csv.DictWriter(handle, fieldnames=fields)
            writer.writeheader()
            writer.writerows(rows)

    minimum_share, minimum_location = min(shares, key=lambda item: item[0])
    return {
        "phase": phase,
        "interval_half_open": list(interval),
        "unique_parent_roots": len(phase_parent_roots),
        "minimum_parent_root": min(phase_parent_roots),
        "maximum_parent_root": max(phase_parent_roots),
        "root_rows": len(root_rows),
        "group_rows": len(group_rows),
        "mismatch_count": len(mismatches),
        "minimum_advanced_share_fraction": fraction_text(minimum_share),
        "minimum_advanced_share": float(minimum_share),
        "minimum_location": {
            "modulus": minimum_location[0],
            "parent_class": minimum_location[1],
            "parent_residue": minimum_location[2],
            "lift": minimum_location[3],
            "y": minimum_location[4],
        },
        "piStar_profiles_computed": counter.computations,
        "elapsed_seconds": time.perf_counter() - started,
        "paths": {
            "root_rows_csv": str(root_rows_path),
            "group_rows_csv": str(group_rows_path),
            "mismatches_csv": str(mismatch_path),
        },
    }


def write_manifest(output_dir: Path, paths: list[Path]) -> Path:
    manifest_path = output_dir / "manifest_sha256.csv"
    inputs = [Path(__file__).resolve(), V1_LIBRARY, PREREGISTRATION, INVALIDATION, *paths]
    with manifest_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=["path", "sha256", "bytes"])
        writer.writeheader()
        for path in inputs:
            writer.writerow(
                {"path": str(path), "sha256": file_sha256(path), "bytes": path.stat().st_size}
            )
    return manifest_path


def run_calibration(output_root: Path) -> None:
    output_dir = output_root / "calibration"
    summary = generate_phase("calibration", output_dir)
    minimum = Fraction(summary["minimum_advanced_share_fraction"])
    raw_beta = max(Fraction(0, 1), minimum - FREEZE_MARGIN)
    scaled = raw_beta * FREEZE_GRID
    beta_frozen = Fraction(scaled.numerator // scaled.denominator, FREEZE_GRID)
    contract = {
        "status": "V2_FROZEN_BEFORE_HOLDOUT",
        "public_custody": False,
        "config": config_payload(),
        "script_sha256": file_sha256(Path(__file__).resolve()),
        "v1_library_sha256": file_sha256(V1_LIBRARY),
        "preregistration_sha256": file_sha256(PREREGISTRATION),
        "invalidation_sha256": file_sha256(INVALIDATION),
        "calibration_minimum_share_fraction": fraction_text(minimum),
        "beta_frozen_fraction": fraction_text(beta_frozen),
        "beta_frozen": float(beta_frozen),
        "utility_pass": beta_frozen >= UTILITY_FLOOR,
        "holdout_accessed": False,
    }
    summary.update(
        {
            "status": "PASS" if summary["mismatch_count"] == 0 else "FAIL",
            "classification": "V2_CALIBRATION_GLOBAL_SPLIT_HOLDOUT_UNACCESSED",
            "config": config_payload(),
            "beta_frozen_fraction": fraction_text(beta_frozen),
            "beta_frozen": float(beta_frozen),
            "utility_pass": beta_frozen >= UTILITY_FLOOR,
            "public_custody": False,
        }
    )
    summary_path = output_dir / "summary.json"
    contract_path = output_root / "FROZEN_CONTRACT.json"
    summary_path.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    contract_path.write_text(json.dumps(contract, indent=2, sort_keys=True) + "\n")
    manifest = write_manifest(
        output_dir,
        [
            Path(summary["paths"]["root_rows_csv"]),
            Path(summary["paths"]["group_rows_csv"]),
            Path(summary["paths"]["mismatches_csv"]),
            summary_path,
            contract_path,
        ],
    )
    print(
        json.dumps(
            {
                "summary": summary,
                "frozen_contract": str(contract_path),
                "frozen_contract_sha256": file_sha256(contract_path),
                "manifest": str(manifest),
            },
            indent=2,
            sort_keys=True,
        )
    )


def run_holdout(output_root: Path, contract_path: Path) -> None:
    contract = json.loads(contract_path.read_text())
    integrity_failures: list[str] = []
    expected = {
        "status": "V2_FROZEN_BEFORE_HOLDOUT",
        "config": config_payload(),
        "script_sha256": file_sha256(Path(__file__).resolve()),
        "v1_library_sha256": file_sha256(V1_LIBRARY),
        "preregistration_sha256": file_sha256(PREREGISTRATION),
        "invalidation_sha256": file_sha256(INVALIDATION),
    }
    for key, value in expected.items():
        if contract.get(key) != value:
            integrity_failures.append(key)
    calibration_roots = set(range(*CALIBRATION_INTERVAL))
    holdout_roots = set(range(*HOLDOUT_INTERVAL))
    if calibration_roots & holdout_roots:
        integrity_failures.append("global_parent_root_intersection")
    if integrity_failures:
        raise RuntimeError(f"v2 frozen contract integrity failure: {integrity_failures}")

    output_dir = output_root / "holdout"
    summary = generate_phase("holdout", output_dir)
    minimum = Fraction(summary["minimum_advanced_share_fraction"])
    beta_frozen = Fraction(contract["beta_frozen_fraction"])
    balance_pass = minimum >= beta_frozen
    utility_pass = beta_frozen >= UTILITY_FLOOR
    hooks_pass = summary["mismatch_count"] == 0
    verdict = (
        "LOCAL_PROVISIONAL_GO_TO_BALANCE_LEMMA"
        if balance_pass and utility_pass and hooks_pass
        else "STOP_OR_REDESIGN"
    )
    summary.update(
        {
            "status": "PASS" if hooks_pass else "FAIL",
            "classification": "V2_HOLDOUT_VALID_LOCAL_PENDING_PUBLIC_CUSTODY",
            "config": config_payload(),
            "contract_path": str(contract_path),
            "contract_sha256": file_sha256(contract_path),
            "global_parent_root_intersection_count": 0,
            "beta_frozen_fraction": fraction_text(beta_frozen),
            "beta_frozen": float(beta_frozen),
            "holdout_balance_pass": balance_pass,
            "utility_pass": utility_pass,
            "hooks_pass": hooks_pass,
            "local_verdict": verdict,
            "formal_coordinated_verdict": "PENDING_PUBLIC_CUSTODY",
            "public_custody": False,
        }
    )
    summary_path = output_dir / "summary.json"
    summary_path.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    manifest = write_manifest(
        output_dir,
        [
            Path(summary["paths"]["root_rows_csv"]),
            Path(summary["paths"]["group_rows_csv"]),
            Path(summary["paths"]["mismatches_csv"]),
            summary_path,
            contract_path,
        ],
    )
    print(json.dumps({"summary": summary, "manifest": str(manifest)}, indent=2, sort_keys=True))


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--phase", choices=("calibration", "holdout"), required=True)
    parser.add_argument("--output-root", type=Path, default=DEFAULT_OUTPUT_ROOT)
    parser.add_argument("--contract", type=Path)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    if args.phase == "calibration":
        if args.contract is not None:
            raise ValueError("calibration does not accept --contract")
        run_calibration(args.output_root)
    else:
        if args.contract is None:
            raise ValueError("holdout requires --contract")
        run_holdout(args.output_root, args.contract)


if __name__ == "__main__":
    main()
