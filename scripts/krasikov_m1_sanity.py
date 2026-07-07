#!/usr/bin/env python3
"""Finite sanity check for the k=2 Krasikov/KL2003 inequalities.

This checks the branch-count inequalities behind the k=2 system for
actual bounded inverse trees up to X <= 10000. It is not a proof of the
infimum statements for phi_k^m and makes no global Collatz claim.
"""

from functools import lru_cache

N = 10_000


def T(n: int) -> int:
    if n % 2 == 0:
        return n // 2
    return (3 * n + 1) // 2


@lru_cache(maxsize=None)
def pi_star(a: int, x: int) -> int:
    """Count the bounded inverse tree rooted at a inside [1, x]."""
    if a > x:
        return 0
    seen = {a}
    frontier = [a]
    while frontier:
        z = frontier.pop()
        candidates = [2 * z]
        if (2 * z - 1) % 3 == 0:
            candidates.append((2 * z - 1) // 3)
        for p in candidates:
            if 1 <= p <= x and p not in seen and T(p) == z:
                seen.add(p)
                frontier.append(p)
    return len(seen)


def check() -> None:
    failures = []
    checked = {2: 0, 5: 0, 8: 0}
    equalities = {2: 0, 5: 0, 8: 0}

    for a in range(1, N + 1):
        # KL2003 defines phi using roots a that are not in a cycle; in the
        # positive range covered here, the known positive cycle is 1 <-> 2.
        if a in (1, 2):
            continue
        if a % 3 == 0:
            continue
        residue = a % 9
        if residue not in (2, 5, 8):
            continue
        y = 2
        while (1 << y) * a <= N:
            x = (1 << y) * a
            lhs = pi_star(a, x)

            if residue == 2:
                b = (4 * a - 2) // 3
                rhs = pi_star(4 * a, x) + pi_star(b, x - (1 << (y - 1)))
            elif residue == 5:
                rhs = pi_star(4 * a, x)
            else:
                b = (2 * a - 1) // 3
                rhs = pi_star(4 * a, x) + pi_star(b, x - (1 << (y - 1)))

            checked[residue] += 1
            if lhs == rhs:
                equalities[residue] += 1
            if lhs < rhs:
                failures.append((a, residue, y, x, lhs, rhs))
            y += 1

    total = sum(checked.values())
    print(f"N={N}")
    print(f"checked inequalities={total}")
    for residue in (2, 5, 8):
        print(
            f"residue {residue} mod 9: checked={checked[residue]}, "
            f"equalities={equalities[residue]}"
        )
    print(f"failures={len(failures)}")
    if failures:
        for failure in failures[:20]:
            print("failure", failure)
        raise SystemExit(1)


if __name__ == "__main__":
    check()
