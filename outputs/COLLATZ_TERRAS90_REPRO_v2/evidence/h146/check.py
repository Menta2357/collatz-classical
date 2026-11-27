"""Exact check for the two six-rise capacity windows used by Terras 90."""

import json
from functools import cache

H = 146
FIRST_RISE_CUTOFF = 124
LIMIT = (6**H).bit_length() - 1


def require(condition, message):
    if not condition:
        raise ArithmeticError(message)


def v2(n):
    return (n & -n).bit_length() - 1


@cache
def power_of_three(exponent):
    return 3**exponent


def next_valley(x):
    shifted = x + 1
    rise = v2(shifted)
    peak = power_of_three(rise) * (shifted >> rise) - 1
    return rise, peak >> v2(peak)


def direct_rises(x):
    """Independent shortcut-map replay for controls, including the maximum."""
    lengths = []
    for _ in range(6):
        rise = 0
        while x % 2:
            x = (3*x + 1) // 2
            rise += 1
        while x % 2 == 0:
            x //= 2
        lengths.append(rise)
    return lengths


def main():
    # Published universal rise bounds used as external premises.
    require(2**156 <= 6**92, "H92 using B7(100) <= 156")
    require(3**123 * 2**(H-123) < 2**230, "upper bound on first peak")
    require(123 + 254 <= LIMIT, "H146 lower first rise using B5(229)=254")

    # x+1 < 2^146 and a_1 >= 124 iff x+1=2^124*u with 1 <= u < 2^22.
    cap = 2**(H-FIRST_RISE_CUTOFF)
    counts = [0] * (H-FIRST_RISE_CUTOFF)
    top = 0
    witness = None
    for u in range(1, cap):
        extra = v2(u)
        a1 = FIRST_RISE_CUTOFF + extra
        peak = power_of_three(a1) * (u >> extra) - 1
        valley = peak >> v2(peak)
        score = a1
        for _ in range(5):
            rise, valley = next_valley(valley)
            score += rise
        counts[extra] += 1
        if score > top:
            top, witness = score, u
        require(score <= LIMIT, f"H146 violation at cofactor {u}: {score}")

    require(counts == [2**i for i in reversed(range(H-FIRST_RISE_CUTOFF))],
            "first-rise strata")
    require(sum(counts) == cap-1, "full cofactor interval")
    for u in (1, 2, 3, witness, cap-1):
        start = (u << FIRST_RISE_CUTOFF) - 1
        x = start
        block_rises = []
        for _ in range(6):
            rise, x = next_valley(x)
            block_rises.append(rise)
        require(block_rises == direct_rises(start), f"independent control {u}")

    witness_start = (witness << FIRST_RISE_CUTOFF) - 1
    witness_rises = direct_rises(witness_start)
    require(sum(witness_rises) == top, "independent replay of maximum")
    print(json.dumps({
        "status": "PASS",
        "external_universal_bounds": {"B7(100)_upper": 156, "B5(229)": 254},
        "H92_D6_upper": 156,
        "H146_D6_upper_a1_at_most_123": 377,
        "H146_limit": LIMIT,
        "H146_long_first_rise": {
            "minimum_a1": FIRST_RISE_CUTOFF,
            "maximum_a1": H-1,
            "cofactors_checked": cap-1,
            "counts_by_a1": counts,
            "maximum_D6": top,
            "minimum_cofactor_at_maximum": witness,
            "witness_rises": witness_rises,
        },
        "direct_replay_controls": 5,
    }, indent=2))


if __name__ == "__main__":
    main()
