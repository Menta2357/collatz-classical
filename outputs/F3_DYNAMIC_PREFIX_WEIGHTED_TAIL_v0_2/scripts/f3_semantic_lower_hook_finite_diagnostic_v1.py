#!/usr/bin/env python3
"""Finite, one-layer diagnostic for the F3 semantic lower hook.

This compares the frozen row left mass with actual first-hit source-fibre
cardinalities.  It is calibration only: the row mass and the fibre counts are
reported with their definitions, and no uniform or asymptotic conclusion is
drawn from the finite interval.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import sys
from pathlib import Path


BASE = Path(__file__).resolve().parents[1]
PACKAGE_ROOT = Path(__file__).resolve().parents[2] / "F3_DENSITY_CAPTURE_GATE_v1"
sys.path.insert(0, str(PACKAGE_ROOT / "scripts"))

from f3_e5_memberwise_gap_audit_v1 import pi_star_members  # noqa: E402


def T(n: int) -> int:
    return n // 2 if n % 2 == 0 else (3 * n + 1) // 2


def state_label(n: int, depth: int = 5) -> str:
    bucket = 0 if n % 2 else (2 if n % 4 == 0 else 1)
    parity = "odd" if n % 2 else "even"
    return f"d{depth}:r{n % (3**depth)}:p{parity}:b{bucket}"


def first_entry_predecessor(parent: int, predecessor: int, n: int, bound: int) -> bool:
    """Check that the first visit to parent has the requested predecessor."""
    cur = n
    seen: set[int] = set()
    while 0 < cur <= bound:
        if cur == parent:
            return False
        nxt = T(cur)
        if nxt == parent:
            return cur == predecessor
        if cur in seen:
            return False
        seen.add(cur)
        cur = nxt
    return False


def file_sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--a-start", type=int, default=3)
    parser.add_argument("--a-stop", type=int, default=128)
    parser.add_argument("--y", type=int, default=8)
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=BASE / "results/F3_SEMANTIC_LOWER_HOOK_FINITE_DIAGNOSTIC_v1",
    )
    args = parser.parse_args()
    if args.a_start >= args.a_stop or args.a_start < 1:
        raise SystemExit("require 1 <= a-start < a-stop")
    if args.y < 2:
        raise SystemExit("require y >= 2")

    frozen_path = (
        BASE / "results/F3_RETURN_EXCURSION_SUPPORT_REPAIR_v1/frozen_w_core.csv"
    )
    lhs_by_state: dict[str, float] = {}
    with frozen_path.open(newline="", encoding="utf-8") as handle:
        for row in csv.DictReader(handle):
            lhs_by_state[row["state"]] = float(row["lhs_wM_decimal"])

    rows: list[dict[str, object]] = []
    for a in range(args.a_start, args.a_stop):
        if a <= 2 or (2 * a - 1) % 3:
            continue
        state = state_label(a)
        if state not in lhs_by_state:
            continue
        c = (2 * a - 1) // 3
        x = (2**args.y) * a
        x_phase_b = x - 2 ** (args.y - 1)
        source_specs = [("retarded", 4 * a, 2 * a, x)]
        if c % 3 == 2:
            source_specs.append(("advanced_direct", c, c, x_phase_b))
        elif c % 3 == 1:
            source_specs.append(("parity_lift", 2 * c, c, x_phase_b))

        fibres: list[set[int]] = []
        counts: dict[str, int] = {}
        for channel, source, predecessor, child_window in source_specs:
            raw = pi_star_members(source, child_window)
            fibre = {
                n
                for n in raw
                if first_entry_predecessor(a, predecessor, n, x)
            }
            fibres.append(fibre)
            counts[channel] = len(fibre)

        disjoint = all(
            fibres[i].isdisjoint(fibres[j])
            for i in range(len(fibres))
            for j in range(i + 1, len(fibres))
        )
        fibre_total = sum(counts.values())
        lhs = lhs_by_state[state]
        rows.append(
            {
                "a": a,
                "state": state,
                "c": c,
                "y": args.y,
                "x": x,
                "lhs_row_mass": lhs,
                "retarded_first_hit_count": counts.get("retarded", 0),
                "advanced_direct_first_hit_count": counts.get("advanced_direct", 0),
                "parity_lift_first_hit_count": counts.get("parity_lift", 0),
                "first_hit_fibre_total": fibre_total,
                "fibre_sets_disjoint": "yes" if disjoint else "no",
                "fibre_total_over_lhs": fibre_total / lhs if lhs else 0.0,
            }
        )

    args.output_dir.mkdir(parents=True, exist_ok=True)
    csv_path = args.output_dir / "finite_hook_rows.csv"
    fields = list(rows[0]) if rows else []
    with csv_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        if fields:
            writer.writeheader()
            writer.writerows(rows)

    min_ratio = min((float(row["fibre_total_over_lhs"]) for row in rows), default=0.0)
    summary = {
        "status": "FINITE_DIAGNOSTIC_ONLY",
        "a_interval": [args.a_start, args.a_stop],
        "y": args.y,
        "rows": len(rows),
        "min_fibre_total_over_lhs": min_ratio,
        "all_fibre_sets_disjoint": all(
            row["fibre_sets_disjoint"] == "yes" for row in rows
        ),
        "csv_sha256": file_sha256(csv_path),
        "row_mass_definition": "frozen_w_core.csv lhs_wM_decimal per source state",
        "fibre_definition": "first predecessor of parent is the declared channel predecessor",
        "no_claims": [
            "NO_UNIFORM_HSEMANTIC",
            "NO_OPERATOR_TO_PISTAR_GROWTH_THEOREM",
            "NO_RHO_CERTIFICATE",
            "NO_DENSITY_THEOREM",
        ],
    }
    (args.output_dir / "summary.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
