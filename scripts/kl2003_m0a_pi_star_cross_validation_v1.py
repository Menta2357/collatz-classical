#!/usr/bin/env python3
"""Reference generator for the KL2003 M0a computable piStar semantics.

This script is a generator/check aid only.  It compares three independent
finite definitions before any D1/D2/D3 work:

* a forward-orbit reference with explicit cycle detection;
* a Lean-mirroring reference with fixed fuel x+1;
* an inverse-tree BFS reference rooted at a.
"""

from __future__ import annotations

import csv
import hashlib
import json
from collections import deque
from pathlib import Path


MAX_A = 30
MAX_X = 200
OUTPUT_DIR = Path("outputs/KL2003_M0A_PI_STAR_CROSS_VALIDATION_v1")
OUTPUT_CSV = OUTPUT_DIR / "pi_star_grid.csv"
THREE_WAY_OUTPUT_DIR = Path("outputs/KL2003_M0A_PI_STAR_THREE_WAY_VALIDATION_v1")
THREE_WAY_GRID_CSV = THREE_WAY_OUTPUT_DIR / "three_way_grid.csv"
THREE_WAY_MISMATCH_CSV = THREE_WAY_OUTPUT_DIR / "mismatch.csv"
THREE_WAY_SUMMARY_JSON = THREE_WAY_OUTPUT_DIR / "summary.json"
THREE_WAY_HASH_CERTIFICATE_JSON = THREE_WAY_OUTPUT_DIR / "hash_certificate.json"


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


def lean_mirroring_members(a: int, x: int) -> list[int]:
    return [n for n in range(1, x + 1) if bounded_reaches(a, x, n)]


def forward_reaches_bounded(a: int, x: int, n: int) -> bool:
    if min(a, x, n) < 0:
        raise ValueError("all arguments must be Nat-compatible integers")
    if not 1 <= n <= x:
        return False
    cur = n
    seen: set[int] = set()
    while True:
        if cur > x:
            return False
        if cur == a:
            return True
        if cur in seen:
            return False
        seen.add(cur)
        cur = T(cur)


def forward_orbit_members(a: int, x: int) -> list[int]:
    return [n for n in range(1, x + 1) if forward_reaches_bounded(a, x, n)]


def inverse_predecessors(z: int) -> list[int]:
    candidates = [2 * z]
    numerator = 2 * z - 1
    if numerator % 3 == 0:
        candidates.append(numerator // 3)
    return candidates


def inverse_tree_bfs_members(a: int, x: int) -> list[int]:
    if min(a, x) < 0:
        raise ValueError("all arguments must be Nat-compatible integers")
    if not 1 <= a <= x:
        return []

    seen = {a}
    frontier: deque[int] = deque([a])
    while frontier:
        z = frontier.popleft()
        for p in inverse_predecessors(z):
            if 1 <= p <= x and p not in seen and T(p) == z:
                seen.add(p)
                frontier.append(p)
    return sorted(seen)


def pi_star_members(a: int, x: int) -> list[int]:
    return lean_mirroring_members(a, x)


def members_digest(members: list[int]) -> tuple[str, str]:
    encoded = " ".join(str(n) for n in members)
    digest = hashlib.sha256(encoded.encode("utf-8")).hexdigest()
    return encoded, digest


def file_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


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


def write_three_way_validation() -> dict[str, object]:
    THREE_WAY_OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    mismatches: list[dict[str, object]] = []
    row_count = 0
    overall_digest = hashlib.sha256()

    with THREE_WAY_GRID_CSV.open("w", newline="", encoding="utf-8") as grid_handle:
        fieldnames = [
            "a",
            "x",
            "forward_count",
            "lean_mirroring_count",
            "inverse_bfs_count",
            "members_sha256",
            "forward_members_sha256",
            "lean_mirroring_members_sha256",
            "inverse_bfs_members_sha256",
            "agree",
            "fuel",
        ]
        writer = csv.DictWriter(grid_handle, fieldnames=fieldnames)
        writer.writeheader()

        for a in range(1, MAX_A + 1):
            for x in range(0, MAX_X + 1):
                forward = forward_orbit_members(a, x)
                lean = lean_mirroring_members(a, x)
                inverse = inverse_tree_bfs_members(a, x)

                forward_encoded, forward_hash = members_digest(forward)
                lean_encoded, lean_hash = members_digest(lean)
                inverse_encoded, inverse_hash = members_digest(inverse)
                agree = forward == lean == inverse
                canonical_hash = lean_hash if agree else ""

                row = {
                    "a": a,
                    "x": x,
                    "forward_count": len(forward),
                    "lean_mirroring_count": len(lean),
                    "inverse_bfs_count": len(inverse),
                    "members_sha256": canonical_hash,
                    "forward_members_sha256": forward_hash,
                    "lean_mirroring_members_sha256": lean_hash,
                    "inverse_bfs_members_sha256": inverse_hash,
                    "agree": "yes" if agree else "no",
                    "fuel": x + 1,
                }
                writer.writerow(row)
                row_count += 1
                overall_digest.update(
                    f"{a},{x},{canonical_hash},{row['agree']}\n".encode("utf-8")
                )

                if not agree:
                    mismatches.append(
                        {
                            "a": a,
                            "x": x,
                            "forward_members": forward_encoded,
                            "lean_mirroring_members": lean_encoded,
                            "inverse_bfs_members": inverse_encoded,
                            "forward_members_sha256": forward_hash,
                            "lean_mirroring_members_sha256": lean_hash,
                            "inverse_bfs_members_sha256": inverse_hash,
                            "fuel": x + 1,
                        }
                    )

    with THREE_WAY_MISMATCH_CSV.open("w", newline="", encoding="utf-8") as mismatch_handle:
        fieldnames = [
            "a",
            "x",
            "forward_members",
            "lean_mirroring_members",
            "inverse_bfs_members",
            "forward_members_sha256",
            "lean_mirroring_members_sha256",
            "inverse_bfs_members_sha256",
            "fuel",
        ]
        writer = csv.DictWriter(mismatch_handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(mismatches)

    summary: dict[str, object] = {
        "status": "PASS" if not mismatches else "FAIL",
        "max_a": MAX_A,
        "max_x": MAX_X,
        "grid_rows": row_count,
        "mismatch_count": len(mismatches),
        "forward_orbit_equals_lean_mirroring": not mismatches,
        "forward_orbit_equals_inverse_tree_bfs": not mismatches,
        "lean_mirroring_equals_inverse_tree_bfs": not mismatches,
        "grid_digest_sha256": overall_digest.hexdigest(),
        "outputs": {
            "three_way_grid_csv": str(THREE_WAY_GRID_CSV),
            "mismatch_csv": str(THREE_WAY_MISMATCH_CSV),
            "summary_json": str(THREE_WAY_SUMMARY_JSON),
            "hash_certificate_json": str(THREE_WAY_HASH_CERTIFICATE_JSON),
        },
    }

    THREE_WAY_SUMMARY_JSON.write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    hash_certificate = {
        "files": {
            str(OUTPUT_CSV): file_sha256(OUTPUT_CSV),
            str(THREE_WAY_GRID_CSV): file_sha256(THREE_WAY_GRID_CSV),
            str(THREE_WAY_MISMATCH_CSV): file_sha256(THREE_WAY_MISMATCH_CSV),
            str(THREE_WAY_SUMMARY_JSON): file_sha256(THREE_WAY_SUMMARY_JSON),
        }
    }
    THREE_WAY_HASH_CERTIFICATE_JSON.write_text(
        json.dumps(hash_certificate, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )

    if mismatches:
        raise SystemExit(
            f"three-way validation failed with {len(mismatches)} mismatches; "
            f"see {THREE_WAY_MISMATCH_CSV}"
        )
    return summary


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
    summary = write_three_way_validation()
    print(f"wrote {OUTPUT_CSV}")
    print(f"wrote {THREE_WAY_GRID_CSV}")
    print(f"wrote {THREE_WAY_SUMMARY_JSON}")
    print(f"three_way_status={summary['status']}")
    print(f"three_way_mismatch_count={summary['mismatch_count']}")
    print_reference_examples()


if __name__ == "__main__":
    main()
