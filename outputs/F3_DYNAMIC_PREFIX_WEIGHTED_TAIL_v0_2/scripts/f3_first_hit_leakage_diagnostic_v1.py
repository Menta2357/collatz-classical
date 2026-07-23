#!/usr/bin/env python3
"""Finite diagnostic for raw advanced sources versus first-hit fibres.

This is a calibration diagnostic only.  It does not certify a uniform
leakage bound, an operator-to-piStar theorem, a rho certificate, or density.
For each parent a and inverse child c=(2a-1)/3, it enumerates the raw direct
and parity-lift source populations and filters them by the first visit to a.
The discarded members are reported as a possible path-leakage quantity.
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


def first_hit_through(parent: int, child: int, n: int, bound: int) -> bool:
    """Whether n reaches child before its first visit to parent.

    The finite orbit check is deliberately explicit.  A member is retained
    only if there is a first visit to parent and the immediately preceding
    orbit prefix reaches child before that first visit.  The bound is the
    piStar window, so leaving it makes the member irrelevant to this row.
    """
    cur = n
    seen: set[int] = set()
    while 0 < cur <= bound:
        if cur == parent:
            return False
        nxt = T(cur)
        # The Lean predicate requires the *first* hit of parent to have
        # immediate predecessor c, not merely an earlier visit to c.
        if nxt == parent:
            return cur == child
        if cur in seen:
            return False
        seen.add(cur)
        cur = nxt
    return False


def source_members(kind: str, c: int, x_child: int) -> set[int]:
    root = c if kind == "direct" else 2 * c
    return set(pi_star_members(root, x_child))


def digest_rows(rows: list[dict[str, object]]) -> str:
    encoded = json.dumps(rows, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(encoded).hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--a-start", type=int, default=3)
    parser.add_argument("--a-stop", type=int, default=1024)
    parser.add_argument("--y", type=int, nargs="+", default=[8])
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=BASE / "results/F3_FIRST_HIT_LEAKAGE_DIAGNOSTIC_v1",
    )
    args = parser.parse_args()
    if args.a_start < 1 or args.a_start >= args.a_stop:
        raise SystemExit("require 1 <= a-start < a-stop")
    if any(y < 2 for y in args.y):
        raise SystemExit("y must be at least 2")

    args.output_dir.mkdir(parents=True, exist_ok=True)
    rows: list[dict[str, object]] = []
    for a in range(args.a_start, args.a_stop):
        if a <= 2 or (2 * a - 1) % 3:
            continue
        c = (2 * a - 1) // 3
        for y in args.y:
            x = (2**y) * a
            x_child = (2**y) * c
            for kind in ("direct", "parityLift"):
                raw = source_members(kind, c, x_child)
                first_hit = {
                    n for n in raw if first_hit_through(a, c, n, x)
                }
                discarded = raw - first_hit
                rows.append(
                    {
                        "a": a,
                        "c": c,
                        "y": y,
                        "x": x,
                        "kind": kind,
                        "raw_count": len(raw),
                        "first_hit_count": len(first_hit),
                        "discarded_count": len(discarded),
                        "discarded_fraction": (
                            len(discarded) / len(raw) if raw else 0.0
                        ),
                    }
                )

    csv_path = args.output_dir / "raw_vs_first_hit.csv"
    fields = list(rows[0]) if rows else []
    with csv_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        if fields:
            writer.writeheader()
            writer.writerows(rows)

    raw_total = sum(int(row["raw_count"]) for row in rows)
    first_total = sum(int(row["first_hit_count"]) for row in rows)
    discarded_total = raw_total - first_total
    summary = {
        "status": "DIAGNOSTIC_ONLY",
        "a_interval": [args.a_start, args.a_stop],
        "y_values": args.y,
        "rows": len(rows),
        "raw_total": raw_total,
        "first_hit_total": first_total,
        "discarded_total": discarded_total,
        "discarded_fraction": discarded_total / raw_total if raw_total else 0.0,
        "csv_sha256": hashlib.sha256(csv_path.read_bytes()).hexdigest(),
        "rows_sha256": digest_rows(rows),
        "no_claims": [
            "NO_UNIFORM_LEAKAGE_BOUND",
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
