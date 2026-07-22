#!/usr/bin/env python3
"""Member-wise audit of the F3/E5 aggregate closure ratio.

This is a finite empirical diagnostic.  It uses the same bounded inverse-tree
semantics as KL2003 M0a:

  piStar(a, x) = #{n in [1,x] whose T-orbit reaches a without exceeding x}.

For roots a == 8 (mod 9), c = (2a-1)/3 is integral.  The script checks the
finite-set partition

  P_a(x) = {a, 2a} disjoint-union P_{4a}(x) disjoint-union P_c(x)

and decomposes the E5 shortfall exactly into

  target - [1 + piStar(4a,x) + piStar(c,xAdv)]
    = 1 + [piStar(c,x) - piStar(c,xAdv)].

The first 1 is a deterministic atom-accounting term, not advanced-window
leakage.  No asymptotic, density, almost-all, or global Collatz claim is made.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import platform
import sys
import time
from collections import deque
from pathlib import Path


DEFAULT_MAX_A = 1200
DEFAULT_SCALE = 2**9
DEFAULT_RESIDUE = 8
DEFAULT_MODULUS = 9


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


def pi_star_members(root: int, bound: int) -> set[int]:
    """Return the bounded inverse-tree member set P_root(bound)."""

    if root < 1 or bound < root:
        return set()

    seen = {root}
    frontier: deque[int] = deque([root])
    while frontier:
        z = frontier.popleft()
        for pred in inverse_predecessors(z):
            if 1 <= pred <= bound and pred not in seen and T(pred) == z:
                seen.add(pred)
                frontier.append(pred)
    return seen


def ceil_div(numerator: int, denominator: int) -> int:
    if denominator <= 0:
        raise ValueError("ceil_div expects a positive denominator")
    return (numerator + denominator - 1) // denominator


def members_sha256(members: set[int]) -> str:
    digest = hashlib.sha256()
    for value in sorted(members):
        digest.update(f"{value}\n".encode("ascii"))
    return digest.hexdigest()


def file_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def yes_no(value: bool) -> str:
    return "yes" if value else "no"


def percentage(numerator: int, denominator: int) -> float:
    return 100.0 * numerator / denominator if denominator else 0.0


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--max-a", type=int, default=DEFAULT_MAX_A)
    parser.add_argument("--scale", type=int, default=DEFAULT_SCALE)
    parser.add_argument("--residue", type=int, default=DEFAULT_RESIDUE)
    parser.add_argument("--modulus", type=int, default=DEFAULT_MODULUS)
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=Path("results/F3_E5_MEMBERWISE_GAP_AUDIT_v1"),
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    if args.max_a < 1 or args.scale < 1 or args.modulus < 1:
        raise ValueError("max-a, scale, and modulus must be positive")

    started = time.perf_counter()
    output_dir: Path = args.output_dir
    output_dir.mkdir(parents=True, exist_ok=True)
    rows_path = output_dir / "memberwise.csv"
    mismatches_path = output_dir / "mismatches.csv"
    summary_path = output_dir / "summary.json"
    manifest_path = output_dir / "manifest_sha256.csv"

    fieldnames = [
        "a",
        "c",
        "x",
        "qAdv",
        "xAdv",
        "target_count",
        "retarded_count",
        "advanced_full_count",
        "advanced_window_count",
        "e5_numerator",
        "e5_gap",
        "deterministic_atom_gap",
        "advanced_window_gap",
        "closure_percent",
        "partition_ok",
        "pairwise_disjoint_ok",
        "advanced_subset_ok",
        "gap_identity_ok",
        "route_hooks_ok",
        "window_hooks_ok",
        "all_hooks_ok",
        "target_sha256",
        "retarded_sha256",
        "advanced_full_sha256",
        "advanced_window_sha256",
        "advanced_boundary_examples",
    ]

    rows: list[dict[str, object]] = []
    mismatch_rows: list[dict[str, object]] = []
    total_target = 0
    total_numerator = 0
    total_atom_gap = 0
    total_advanced_gap = 0

    roots = [
        a
        for a in range(1, args.max_a + 1)
        if a % args.modulus == args.residue % args.modulus
    ]

    for a in roots:
        numerator_c = 2 * a - 1
        if numerator_c % 3 != 0:
            raise AssertionError(f"advanced child is not integral for a={a}")
        c = numerator_c // 3
        x = args.scale * a
        q_adv = ceil_div(x, 2 * a)
        x_adv = x - q_adv

        target = pi_star_members(a, x)
        retarded = pi_star_members(4 * a, x)
        advanced_full = pi_star_members(c, x)
        advanced_window = pi_star_members(c, x_adv)

        atom_set = {a, 2 * a}
        reconstructed = atom_set | retarded | advanced_full
        partition_ok = target == reconstructed
        pairwise_disjoint_ok = (
            atom_set.isdisjoint(retarded)
            and atom_set.isdisjoint(advanced_full)
            and retarded.isdisjoint(advanced_full)
        )
        advanced_subset_ok = advanced_window <= advanced_full

        target_count = len(target)
        retarded_count = len(retarded)
        advanced_full_count = len(advanced_full)
        advanced_window_count = len(advanced_window)
        e5_numerator = 1 + retarded_count + advanced_window_count
        e5_gap = target_count - e5_numerator
        deterministic_atom_gap = 1
        advanced_window_gap = advanced_full_count - advanced_window_count
        gap_identity_ok = e5_gap == deterministic_atom_gap + advanced_window_gap

        route_hooks_ok = (
            T(4 * a) == 2 * a
            and T(2 * a) == a
            and T(c) == a
            and (4 * a - 1) % 3 != 0
        )
        window_hooks_ok = (
            a <= x
            and 4 * a <= x
            and c <= x_adv <= x
            and q_adv == ceil_div(x, 2 * a)
        )
        all_hooks_ok = all(
            [
                partition_ok,
                pairwise_disjoint_ok,
                advanced_subset_ok,
                gap_identity_ok,
                route_hooks_ok,
                window_hooks_ok,
                e5_numerator <= target_count,
            ]
        )

        boundary_members = sorted(advanced_full - advanced_window)
        row: dict[str, object] = {
            "a": a,
            "c": c,
            "x": x,
            "qAdv": q_adv,
            "xAdv": x_adv,
            "target_count": target_count,
            "retarded_count": retarded_count,
            "advanced_full_count": advanced_full_count,
            "advanced_window_count": advanced_window_count,
            "e5_numerator": e5_numerator,
            "e5_gap": e5_gap,
            "deterministic_atom_gap": deterministic_atom_gap,
            "advanced_window_gap": advanced_window_gap,
            "closure_percent": f"{percentage(e5_numerator, target_count):.9f}",
            "partition_ok": yes_no(partition_ok),
            "pairwise_disjoint_ok": yes_no(pairwise_disjoint_ok),
            "advanced_subset_ok": yes_no(advanced_subset_ok),
            "gap_identity_ok": yes_no(gap_identity_ok),
            "route_hooks_ok": yes_no(route_hooks_ok),
            "window_hooks_ok": yes_no(window_hooks_ok),
            "all_hooks_ok": yes_no(all_hooks_ok),
            "target_sha256": members_sha256(target),
            "retarded_sha256": members_sha256(retarded),
            "advanced_full_sha256": members_sha256(advanced_full),
            "advanced_window_sha256": members_sha256(advanced_window),
            "advanced_boundary_examples": " ".join(
                str(value) for value in boundary_members[:12]
            ),
        }
        rows.append(row)
        if not all_hooks_ok:
            mismatch_rows.append(row)

        total_target += target_count
        total_numerator += e5_numerator
        total_atom_gap += deterministic_atom_gap
        total_advanced_gap += advanced_window_gap

    with rows_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)

    with mismatches_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(mismatch_rows)

    total_gap = total_target - total_numerator
    elapsed = time.perf_counter() - started
    summary = {
        "status": "PASS" if not mismatch_rows else "FAIL",
        "classification": "FINITE_EMPIRICAL_MEMBERWISE_AUDIT",
        "parameters": {
            "max_a": args.max_a,
            "scale": args.scale,
            "root_filter": f"a % {args.modulus} == {args.residue % args.modulus}",
            "root_count": len(roots),
            "x_formula": "scale * a",
            "xAdv_formula": "x - ceil(x/(2*a))",
        },
        "aggregate": {
            "target_sum": total_target,
            "e5_numerator_sum": total_numerator,
            "total_gap": total_gap,
            "deterministic_atom_gap": total_atom_gap,
            "advanced_window_gap": total_advanced_gap,
            "gap_decomposition_ok": total_gap == total_atom_gap + total_advanced_gap,
            "closure_percent": percentage(total_numerator, total_target),
            "shortfall_percent": percentage(total_gap, total_target),
            "atom_gap_percent_of_target": percentage(total_atom_gap, total_target),
            "advanced_gap_percent_of_target": percentage(total_advanced_gap, total_target),
            "advanced_share_of_total_gap_percent": percentage(
                total_advanced_gap, total_gap
            ),
        },
        "memberwise": {
            "rows": len(rows),
            "mismatches": len(mismatch_rows),
            "partition_passes": sum(row["partition_ok"] == "yes" for row in rows),
            "gap_identity_passes": sum(
                row["gap_identity_ok"] == "yes" for row in rows
            ),
            "all_hooks_passes": sum(row["all_hooks_ok"] == "yes" for row in rows),
        },
        "runtime": {
            "python": sys.version.split()[0],
            "platform": platform.platform(),
            "elapsed_seconds": elapsed,
        },
        "outputs": {
            "memberwise_csv": str(rows_path),
            "mismatches_csv": str(mismatches_path),
            "summary_json": str(summary_path),
            "manifest_sha256_csv": str(manifest_path),
        },
        "no_claims": {
            "no_density_theorem": True,
            "no_asymptotic_infimum_claim": True,
            "no_almost_all_claim": True,
            "no_global_collatz_claim": True,
            "no_lean": True,
        },
    }
    summary_path.write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )

    manifest_inputs = [Path(__file__).resolve(), rows_path, mismatches_path, summary_path]
    with manifest_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=["path", "sha256", "bytes"])
        writer.writeheader()
        for path in manifest_inputs:
            writer.writerow(
                {
                    "path": str(path),
                    "sha256": file_sha256(path),
                    "bytes": path.stat().st_size,
                }
            )

    print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
