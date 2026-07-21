#!/usr/bin/env python3
"""F3 dynamic-prefix weighted-tail phase-replacement pilot.

This is a finite diagnostic only.  It tests the hook ledger created after the
three-lift obstruction was replaced by dynamic 3-adic prefix depth and after
the advanced window phase was conservatively replaced by a predeclared
monotone substitute.

No density, almost-all, rho, Lean, or global Collatz claim is made.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import platform
import sys
import time
from pathlib import Path


PACKAGE_ROOT = Path(__file__).resolve().parents[2] / "F3_DENSITY_CAPTURE_GATE_v1"
SEALED_SCRIPTS = PACKAGE_ROOT / "scripts"
sys.path.insert(0, str(SEALED_SCRIPTS))

from f3_e5_memberwise_gap_audit_v1 import pi_star_members  # noqa: E402


K = 5
Y_VALUES = (8, 9, 10)
CALIBRATION_INTERVAL = (1, 10_369)
HOLDOUT_INTERVAL = (10_369, 20_737)
DEFAULT_OUTPUT_ROOT = (
    Path(__file__).resolve().parents[1]
    / "results/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_PHASE_A_PILOT_v1"
)


def T(n: int) -> int:
    return n // 2 if n % 2 == 0 else (3 * n + 1) // 2


def file_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def yes_no(value: bool) -> str:
    return "yes" if value else "no"


def clipped_nu2(n: int) -> int:
    if n % 2:
        return 0
    if n % 4:
        return 1
    return 2


def parity(n: int) -> str:
    return "odd" if n % 2 else "even"


def type_label(n: int, depth: int) -> str:
    if depth <= 0:
        return "TAIL_DEPTH_0"
    modulus = 3**depth
    return f"d{depth}:r{n % modulus}:p{parity(n)}:b{clipped_nu2(n)}"


def phase_interval(phase: str) -> tuple[int, int]:
    if phase == "calibration":
        return CALIBRATION_INTERVAL
    if phase == "holdout":
        return HOLDOUT_INTERVAL
    raise ValueError(f"unknown phase {phase!r}")


def roots_for_phase(phase: str) -> list[int]:
    lower, upper = phase_interval(phase)
    return [a for a in range(lower, upper) if a > 2 and a % 3 == 2]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--phase",
        choices=("calibration", "holdout", "both"),
        default="both",
    )
    parser.add_argument("--output-root", type=Path, default=DEFAULT_OUTPUT_ROOT)
    parser.add_argument(
        "--phase-replacement",
        choices=("PHASE_A", "PHASE_B"),
        default="PHASE_A",
    )
    parser.add_argument(
        "--max-roots",
        type=int,
        default=0,
        help="optional smoke-test cap per phase; 0 means full interval",
    )
    return parser.parse_args()


def write_csv(path: Path, rows: list[dict[str, object]], fieldnames: list[str]) -> None:
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def phase_bound(phase_replacement: str, a: int, c: int, y: int) -> int:
    if phase_replacement == "PHASE_A":
        return (2**y) * c
    if phase_replacement == "PHASE_B":
        return (2**y) * a - 2 ** (y - 1)
    raise ValueError(phase_replacement)


def run_phase(
    phase: str,
    output_dir: Path,
    max_roots: int,
    phase_replacement: str,
) -> dict[str, object]:
    started = time.perf_counter()
    output_dir.mkdir(parents=True, exist_ok=True)

    roots = roots_for_phase(phase)
    if max_roots:
        roots = roots[:max_roots]

    root_rows: list[dict[str, object]] = []
    mismatches: list[dict[str, object]] = []

    totals = {
        "target": 0,
        "retarded_visible": 0,
        "advanced_visible_phase_a": 0,
        "advanced_tail_phase_a": 0,
        "atom_tail": 0,
        "phase_loss_tail": 0,
        "q_total": 0,
        "visible_total": 0,
    }

    member_cache: dict[tuple[int, int], set[int]] = {}

    def members(root: int, bound: int) -> set[int]:
        key = (root, bound)
        cached = member_cache.get(key)
        if cached is None:
            cached = pi_star_members(root, bound)
            member_cache[key] = cached
        return cached

    for a in roots:
        c_num = 2 * a - 1
        if c_num % 3 != 0:
            raise AssertionError(f"nonintegral advanced child for a={a}")
        c = c_num // 3
        source_type = type_label(a, K)
        retarded_type = type_label(4 * a, K)
        advanced_visible = True
        advanced_type = type_label(c, K - 1)

        for y in Y_VALUES:
            x = (2**y) * a
            x_phase_a = phase_bound(phase_replacement, a, c, y)

            target = members(a, x)
            retarded = members(4 * a, x)
            advanced_full = members(c, x)
            advanced_phase_a = members(c, x_phase_a)

            atom_count = 2
            target_count = len(target)
            retarded_count = len(retarded)
            advanced_full_count = len(advanced_full)
            advanced_phase_a_count = len(advanced_phase_a)
            phase_loss_count = advanced_full_count - advanced_phase_a_count

            reconstructed = {a, 2 * a} | retarded | advanced_full
            partition_pass = target == reconstructed
            disjoint_pass = (
                {a, 2 * a}.isdisjoint(retarded)
                and {a, 2 * a}.isdisjoint(advanced_full)
                and retarded.isdisjoint(advanced_full)
            )
            phase_subset_pass = advanced_phase_a <= advanced_full
            route_pass = T(4 * a) == 2 * a and T(2 * a) == a and T(c) == a

            advanced_visible_mass = (
                advanced_phase_a_count if advanced_visible else 0
            )
            advanced_tail_mass = 0 if advanced_visible else advanced_phase_a_count
            visible_total = retarded_count + advanced_visible_mass
            q_total = atom_count + phase_loss_count + advanced_tail_mass
            denominator_pass = visible_total + q_total == target_count
            all_hooks_pass = all(
                [
                    partition_pass,
                    disjoint_pass,
                    phase_subset_pass,
                    route_pass,
                    denominator_pass,
                    x_phase_a <= x,
                ]
            )

            row = {
                "phase": phase,
                "K": K,
                "a": a,
                "y": y,
                "x": x,
                "c": c,
                "x_phase_a": x_phase_a,
                "source_type": source_type,
                "retarded_type": retarded_type,
                "advanced_route": "visible" if advanced_visible else "Q_K:T0",
                "advanced_type_or_tail": advanced_type,
                "target_count": target_count,
                "retarded_visible_count": retarded_count,
                "advanced_full_count": advanced_full_count,
                "advanced_phase_a_count": advanced_phase_a_count,
                "advanced_visible_phase_a_count": advanced_visible_mass,
                "advanced_tail_phase_a_count": advanced_tail_mass,
                "atom_tail_count": atom_count,
                "phase_loss_tail_count": phase_loss_count,
                "visible_total": visible_total,
                "q_total": q_total,
                "capture_fraction": (
                    f"{visible_total / target_count:.12f}"
                    if target_count
                    else "0.000000000000"
                ),
                "tail_fraction": (
                    f"{q_total / target_count:.12f}"
                    if target_count
                    else "0.000000000000"
                ),
                "partition_pass": yes_no(partition_pass),
                "disjoint_pass": yes_no(disjoint_pass),
                "phase_subset_pass": yes_no(phase_subset_pass),
                "route_pass": yes_no(route_pass),
                "denominator_pass": yes_no(denominator_pass),
                "all_hooks_pass": yes_no(all_hooks_pass),
            }
            root_rows.append(row)
            if not all_hooks_pass:
                mismatches.append(row)

            totals["target"] += target_count
            totals["retarded_visible"] += retarded_count
            totals["advanced_visible_phase_a"] += advanced_visible_mass
            totals["advanced_tail_phase_a"] += advanced_tail_mass
            totals["atom_tail"] += atom_count
            totals["phase_loss_tail"] += phase_loss_count
            totals["q_total"] += q_total
            totals["visible_total"] += visible_total

    fields = list(root_rows[0].keys()) if root_rows else []
    root_rows_path = output_dir / "root_rows.csv"
    mismatches_path = output_dir / "mismatches.csv"
    summary_path = output_dir / "summary.json"
    manifest_path = output_dir / "manifest_sha256.csv"

    write_csv(root_rows_path, root_rows, fields)
    write_csv(mismatches_path, mismatches, fields)

    target_total = totals["target"]
    summary = {
        "phase": phase,
        "status": "PASS_HOOKS_ONLY" if not mismatches else "STOP_BAD_HOOKS",
        "K": K,
        "phase_replacement": phase_replacement,
        "finite_base_exceptions": [2],
        "interval_half_open": list(phase_interval(phase)),
        "max_roots_cap": max_roots,
        "unique_parent_roots": len(roots),
        "y_values": list(Y_VALUES),
        "root_rows": len(root_rows),
        "mismatch_count": len(mismatches),
        "totals": totals,
        "visible_capture_fraction": (
            totals["visible_total"] / target_total if target_total else 0.0
        ),
        "q_fraction": totals["q_total"] / target_total if target_total else 0.0,
        "phase_loss_fraction": (
            totals["phase_loss_tail"] / target_total if target_total else 0.0
        ),
        "advanced_tail_phase_a_fraction": (
            totals["advanced_tail_phase_a"] / target_total if target_total else 0.0
        ),
        "atom_tail_fraction": (
            totals["atom_tail"] / target_total if target_total else 0.0
        ),
        "elapsed_seconds": time.perf_counter() - started,
        "python": sys.version,
        "platform": platform.platform(),
        "non_claims": {
            "no_lean": True,
            "no_rho_certificate": True,
            "no_density_theorem": True,
            "no_almost_all": True,
            "no_global_collatz_claim": True,
        },
    }
    summary_path.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")

    manifest_rows = [
        {"path": path.name, "sha256": file_sha256(path)}
        for path in (root_rows_path, mismatches_path, summary_path)
    ]
    write_csv(manifest_path, manifest_rows, ["path", "sha256"])

    return summary


def main() -> None:
    args = parse_args()
    phases = ("calibration", "holdout") if args.phase == "both" else (args.phase,)
    summaries = [
        run_phase(
            phase,
            args.output_root / phase,
            args.max_roots,
            args.phase_replacement,
        )
        for phase in phases
    ]
    combined_path = args.output_root / "combined_summary.json"
    combined_path.write_text(json.dumps(summaries, indent=2, sort_keys=True) + "\n")
    print(json.dumps(summaries, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
