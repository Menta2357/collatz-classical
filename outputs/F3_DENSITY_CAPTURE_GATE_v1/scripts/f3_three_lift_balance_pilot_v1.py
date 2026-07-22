#!/usr/bin/env python3
"""Preregistered calibration/holdout pilot for F3 three-lift balance.

Run calibration first.  It writes a frozen contract containing hashes of this
script and the preregistration.  Run holdout only with that contract.  The
holdout result is local and cannot become a formal coordinated verdict until
the complete package has public custody.
"""

from __future__ import annotations

import argparse
import bisect
import csv
import hashlib
import json
import sys
import time
from collections import defaultdict, deque
from fractions import Fraction
from pathlib import Path


MODULI = (36, 108)
PARENT_CLASSES = (2, 8)
SCALES_Y = (8, 9, 10)
CALIBRATION_Q = tuple(range(0, 8))
HOLDOUT_Q = tuple(range(8, 16))
FREEZE_MARGIN = Fraction(1, 50)  # 0.02
FREEZE_GRID = 1000
UTILITY_FLOOR = Fraction(1, 5)  # 0.200

PACKAGE_ROOT = Path(__file__).resolve().parent.parent
PREREGISTRATION = PACKAGE_ROOT / "F3_THREE_LIFT_BALANCE_PILOT_PREREGISTRATION_v1.md"
DEFAULT_OUTPUT_ROOT = PACKAGE_ROOT / "results/F3_THREE_LIFT_BALANCE_PILOT_v1"


def T(n: int) -> int:
    if n < 0:
        raise ValueError("T expects a nonnegative integer")
    return n // 2 if n % 2 == 0 else (3 * n + 1) // 2


def inverse_predecessors(z: int) -> tuple[int, ...]:
    even = 2 * z
    numerator = 2 * z - 1
    if numerator % 3 == 0:
        return even, numerator // 3
    return (even,)


def file_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def fraction_text(value: Fraction) -> str:
    return f"{value.numerator}/{value.denominator}"


def decimal_text(value: Fraction, digits: int = 12) -> str:
    return f"{float(value):.{digits}f}"


def advanced_child(a: int, parent_class: int) -> tuple[int, int]:
    numerator = 2 * a - 1
    if numerator % 3 != 0:
        raise AssertionError(f"nonintegral c for a={a}")
    c = numerator // 3
    if parent_class == 2:
        return c, 2 * c
    if parent_class == 8:
        return c, c
    raise ValueError(f"unsupported parent class {parent_class}")


class PiStarCounter:
    def __init__(self) -> None:
        self.cache: dict[tuple[int, int], tuple[int, ...]] = {}
        self.computations = 0

    def path_maxima(self, root: int, max_bound: int) -> tuple[int, ...]:
        key = (root, max_bound)
        cached = self.cache.get(key)
        if cached is not None:
            return cached
        if root < 1 or root > max_bound:
            self.cache[key] = ()
            return ()

        best_path_max: dict[int, int] = {root: root}
        frontier: deque[int] = deque([root])
        while frontier:
            z = frontier.popleft()
            z_path_max = best_path_max[z]
            for pred in inverse_predecessors(z):
                if not (1 <= pred <= max_bound) or T(pred) != z:
                    continue
                candidate = max(z_path_max, pred)
                old = best_path_max.get(pred)
                if old is None or candidate < old:
                    best_path_max[pred] = candidate
                    frontier.append(pred)

        result = tuple(sorted(best_path_max.values()))
        self.cache[key] = result
        self.computations += 1
        if self.computations % 100 == 0:
            print(
                f"piStar_profiles={self.computations} latest_root={root} "
                f"latest_bound={max_bound} latest_members={len(result)}",
                file=sys.stderr,
                flush=True,
            )
        return result

    def count(self, root: int, query_bound: int, max_bound: int) -> int:
        maxima = self.path_maxima(root, max_bound)
        return bisect.bisect_right(maxima, query_bound)


def phase_q_values(phase: str) -> tuple[int, ...]:
    if phase == "calibration":
        return CALIBRATION_Q
    if phase == "holdout":
        return HOLDOUT_Q
    raise ValueError(phase)


def config_payload() -> dict[str, object]:
    return {
        "moduli": list(MODULI),
        "parent_classes": list(PARENT_CLASSES),
        "scales_y": list(SCALES_Y),
        "calibration_q": list(CALIBRATION_Q),
        "holdout_q": list(HOLDOUT_Q),
        "freeze_margin": fraction_text(FREEZE_MARGIN),
        "freeze_grid": FREEZE_GRID,
        "utility_floor": fraction_text(UTILITY_FLOOR),
    }


def generate_phase(phase: str, output_dir: Path) -> dict[str, object]:
    started = time.perf_counter()
    q_values = phase_q_values(phase)
    output_dir.mkdir(parents=True, exist_ok=True)
    root_rows_path = output_dir / "root_rows.csv"
    group_rows_path = output_dir / "group_rows.csv"
    mismatch_path = output_dir / "mismatches.csv"

    counter = PiStarCounter()
    root_rows: list[dict[str, object]] = []
    mismatches: list[dict[str, object]] = []
    group_target: defaultdict[tuple[int, int, int, int], int] = defaultdict(int)
    group_advanced: defaultdict[tuple[int, int, int, int], int] = defaultdict(int)

    for modulus in MODULI:
        for parent_class in PARENT_CLASSES:
            for parent_residue in range(modulus):
                if parent_residue % 9 != parent_class:
                    continue
                for lift in range(3):
                    for q in q_values:
                        a = parent_residue + lift * modulus + 3 * modulus * q
                        c, child = advanced_child(a, parent_class)
                        max_y = max(SCALES_Y)
                        max_x = (2**max_y) * a
                        max_x_adv = max_x - 2 ** (max_y - 1)

                        static_hooks = {
                            "root_residue": a % modulus == parent_residue,
                            "lift_index": ((a - parent_residue) // modulus) % 3 == lift,
                            "q_membership": q in q_values,
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
                            target_count = counter.count(a, x, max_x)
                            advanced_count = counter.count(child, x_adv, max_x_adv)
                            dynamic_hooks = {
                                "window": child <= x_adv <= x,
                                "member_count_transfer": advanced_count <= target_count,
                            }
                            all_hooks = all(static_hooks.values()) and all(
                                dynamic_hooks.values()
                            )
                            row = {
                                "phase": phase,
                                "modulus": modulus,
                                "parent_class": parent_class,
                                "parent_residue": parent_residue,
                                "lift": lift,
                                "q": q,
                                "a": a,
                                "c": c,
                                "advanced_child": child,
                                "y": y,
                                "x": x,
                                "xAdv": x_adv,
                                "target_count": target_count,
                                "advanced_count": advanced_count,
                                "root_residue_hook": static_hooks["root_residue"],
                                "lift_index_hook": static_hooks["lift_index"],
                                "q_membership_hook": static_hooks["q_membership"],
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
    shares: list[tuple[Fraction, tuple[int, int, int, int]]] = []
    for modulus in MODULI:
        for parent_class in PARENT_CLASSES:
            for parent_residue in range(modulus):
                if parent_residue % 9 != parent_class:
                    continue
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
                    if advanced_total == 0:
                        lift_shares = [Fraction(0, 1)] * 3
                    else:
                        lift_shares = [
                            Fraction(mass, advanced_total) for mass in advanced_masses
                        ]
                    for lift, share in enumerate(lift_shares):
                        shares.append(
                            (share, (modulus, parent_class, parent_residue, lift, y))
                        )
                    min_share = min(lift_shares)
                    max_share = max(lift_shares)
                    group_rows.append(
                        {
                            "phase": phase,
                            "modulus": modulus,
                            "parent_class": parent_class,
                            "parent_residue": parent_residue,
                            "y": y,
                            "roots_per_lift": len(q_values),
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
                            "min_advanced_share": decimal_text(min_share),
                            "max_advanced_share": decimal_text(max_share),
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
    with root_rows_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=root_fields)
        writer.writeheader()
        writer.writerows(root_rows)
    with group_rows_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=group_fields)
        writer.writeheader()
        writer.writerows(group_rows)
    with mismatch_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=root_fields)
        writer.writeheader()
        writer.writerows(mismatches)

    minimum_share, minimum_location = min(shares, key=lambda item: item[0])
    elapsed = time.perf_counter() - started
    return {
        "phase": phase,
        "q_values": list(q_values),
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
        "elapsed_seconds": elapsed,
        "paths": {
            "root_rows_csv": str(root_rows_path),
            "group_rows_csv": str(group_rows_path),
            "mismatches_csv": str(mismatch_path),
        },
    }


def write_manifest(output_dir: Path, extra_paths: list[Path]) -> Path:
    manifest_path = output_dir / "manifest_sha256.csv"
    paths = [Path(__file__).resolve(), PREREGISTRATION, *extra_paths]
    with manifest_path.open("w", newline="", encoding="utf-8") as handle:
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
    return manifest_path


def run_calibration(output_root: Path) -> None:
    output_dir = output_root / "calibration"
    summary = generate_phase("calibration", output_dir)
    minimum = Fraction(summary["minimum_advanced_share_fraction"])
    raw_beta = max(Fraction(0, 1), minimum - FREEZE_MARGIN)
    beta_frozen = Fraction(
        (raw_beta * FREEZE_GRID).numerator // (raw_beta * FREEZE_GRID).denominator,
        FREEZE_GRID,
    )
    contract = {
        "status": "FROZEN_BEFORE_HOLDOUT",
        "public_custody": False,
        "config": config_payload(),
        "script_sha256": file_sha256(Path(__file__).resolve()),
        "preregistration_sha256": file_sha256(PREREGISTRATION),
        "calibration_minimum_share_fraction": fraction_text(minimum),
        "calibration_minimum_share": float(minimum),
        "freeze_rule": "floor_0.001(max(0, calibration_minimum_share - 0.02))",
        "beta_frozen_fraction": fraction_text(beta_frozen),
        "beta_frozen": float(beta_frozen),
        "utility_floor_fraction": fraction_text(UTILITY_FLOOR),
        "utility_floor": float(UTILITY_FLOOR),
        "utility_pass": beta_frozen >= UTILITY_FLOOR,
        "holdout_q": list(HOLDOUT_Q),
        "holdout_accessed": False,
    }
    summary["status"] = "PASS" if summary["mismatch_count"] == 0 else "FAIL"
    summary["classification"] = "CALIBRATION_ONLY_HOLDOUT_UNACCESSED"
    summary["config"] = config_payload()
    summary["beta_frozen_fraction"] = fraction_text(beta_frozen)
    summary["beta_frozen"] = float(beta_frozen)
    summary["utility_pass"] = beta_frozen >= UTILITY_FLOOR
    summary["public_custody"] = False
    summary_path = output_dir / "summary.json"
    contract_path = output_root / "FROZEN_CONTRACT.json"
    summary_path.write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    contract_path.write_text(
        json.dumps(contract, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    manifest_path = write_manifest(
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
                "manifest": str(manifest_path),
            },
            indent=2,
            sort_keys=True,
        )
    )


def run_holdout(output_root: Path, contract_path: Path) -> None:
    contract = json.loads(contract_path.read_text(encoding="utf-8"))
    integrity_failures: list[str] = []
    if contract.get("status") != "FROZEN_BEFORE_HOLDOUT":
        integrity_failures.append("contract_status")
    if contract.get("config") != config_payload():
        integrity_failures.append("config")
    if contract.get("script_sha256") != file_sha256(Path(__file__).resolve()):
        integrity_failures.append("script_sha256")
    if contract.get("preregistration_sha256") != file_sha256(PREREGISTRATION):
        integrity_failures.append("preregistration_sha256")
    if contract.get("holdout_q") != list(HOLDOUT_Q):
        integrity_failures.append("holdout_q")
    if integrity_failures:
        raise RuntimeError(f"frozen contract integrity failure: {integrity_failures}")

    output_dir = output_root / "holdout"
    summary = generate_phase("holdout", output_dir)
    minimum = Fraction(summary["minimum_advanced_share_fraction"])
    beta_frozen = Fraction(contract["beta_frozen_fraction"])
    holdout_balance_pass = minimum >= beta_frozen
    utility_pass = beta_frozen >= UTILITY_FLOOR
    hooks_pass = summary["mismatch_count"] == 0
    local_verdict = (
        "LOCAL_PROVISIONAL_GO_TO_BALANCE_LEMMA"
        if holdout_balance_pass and utility_pass and hooks_pass
        else "STOP_OR_REDESIGN"
    )
    summary.update(
        {
            "status": "PASS" if hooks_pass else "FAIL",
            "classification": "HOLDOUT_RESULT_LOCAL_PENDING_PUBLIC_CUSTODY",
            "config": config_payload(),
            "contract_path": str(contract_path),
            "contract_sha256": file_sha256(contract_path),
            "beta_frozen_fraction": fraction_text(beta_frozen),
            "beta_frozen": float(beta_frozen),
            "holdout_balance_pass": holdout_balance_pass,
            "utility_pass": utility_pass,
            "hooks_pass": hooks_pass,
            "local_verdict": local_verdict,
            "formal_coordinated_verdict": "PENDING_PUBLIC_CUSTODY",
            "public_custody": False,
        }
    )
    summary_path = output_dir / "summary.json"
    summary_path.write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    manifest_path = write_manifest(
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
                "manifest": str(manifest_path),
            },
            indent=2,
            sort_keys=True,
        )
    )


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
