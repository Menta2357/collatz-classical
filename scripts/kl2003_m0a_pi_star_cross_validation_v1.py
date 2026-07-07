#!/usr/bin/env python3
"""Reference generator for the KL2003 M0a computable piStar semantics.

This script is a generator/check aid only.  It mirrors the Lean definitions
from KL2003M0APiStarSemantics.lean and emits a deterministic CSV grid for
manual and future automated comparison before any D1/D2/D3 work.
"""

from __future__ import annotations

import csv
import hashlib
from pathlib import Path


MAX_A = 30
MAX_X = 200
OUTPUT_DIR = Path("outputs/KL2003_M0A_PI_STAR_CROSS_VALIDATION_v1")
OUTPUT_CSV = OUTPUT_DIR / "pi_star_grid.csv"


def T(n: int) -> int:
    if n < 0:
        raise ValueError("T is defined here only on Nat-compatible integers")
    return n // 2 if n % 2 == 0 else (3 * n + 1) // 2


def bounded_reaches_with_fuel(fuel: int, a: int, x: int, n: int) -> bool:
    if min(fuel, a, x, n) < 0:
        raise ValueError("all arguments must be Nat-compatible integers")
    cur = n
    for _ in range(fuel + 1):
        if cur > x:
            return False
        if cur == a:
            return True
        cur = T(cur)
    return False


def bounded_reaches(a: int, x: int, n: int) -> bool:
    return bounded_reaches_with_fuel(x + 1, a, x, n)


def pi_star_members(a: int, x: int) -> list[int]:
    return [n for n in range(1, x + 1) if bounded_reaches(a, x, n)]


def members_digest(members: list[int]) -> tuple[str, str]:
    encoded = " ".join(str(n) for n in members)
    digest = hashlib.sha256(encoded.encode("utf-8")).hexdigest()
    return encoded, digest


def write_grid() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    with OUTPUT_CSV.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=[
                "a",
                "x",
                "count",
                "members_space_separated",
                "members_sha256",
                "fuel",
            ],
        )
        writer.writeheader()
        for a in range(1, MAX_A + 1):
            for x in range(0, MAX_X + 1):
                members = pi_star_members(a, x)
                encoded, digest = members_digest(members)
                writer.writerow(
                    {
                        "a": a,
                        "x": x,
                        "count": len(members),
                        "members_space_separated": encoded,
                        "members_sha256": digest,
                        "fuel": x + 1,
                    }
                )


def print_reference_examples() -> None:
    examples = [
        ("piStarFinset 1 20", pi_star_members(1, 20)),
        ("piStarFinset 2 20", pi_star_members(2, 20)),
        ("piStarFinset 5 50", pi_star_members(5, 50)),
    ]
    for label, members in examples:
        print(f"{label} = {members}")
    counts = [(a, len(pi_star_members(a, 100))) for a in range(1, MAX_A + 1)]
    print(f"[(a, piStar a 100) for 1 <= a <= 30] = {counts}")


def main() -> None:
    write_grid()
    print(f"wrote {OUTPUT_CSV}")
    print_reference_examples()


if __name__ == "__main__":
    main()
