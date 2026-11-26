"""Exact Terras 88 rank arithmetic and bounded four-run falsification controls."""

from fractions import Fraction
from functools import cache
from math import ceil, floor
from pathlib import Path
import sys

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "COLLATZ_TERRAS_87_RUNS_20261125"))
from verify_ranked_path import (  # noqa: E402
    ALPHA, B, D0, DOUBLE, K0, P, Q, QUERIES, check, gap_interval,
    geometric_sum, log_interval, rank_capacity, reciprocal_bound, scale_floor,
)


RUNS = 88
ODD_LIMIT = 2**70
NEW_PAIR = (43_497_921_996_957_973_433, 27_444_133_206_411_171_953)
THREE_RUN_BITS = (66, 67, 92, 107, 146, 170, 231, 256)
FOUR_RUN_BITS = (66, 67, 92, 107, 146, 170)
SOURCE_CORRECTION = Fraction(1, B * (B + 1))


def sieve(ln2, ln3):
    check(Q*K0 - P*D0 == 1, "unimodular basis")
    error_lo = Q*ln3[0] - P*ln2[1]
    error_hi = Q*ln3[1] - P*ln2[0]
    base_lo, base_hi = gap_interval(K0, D0, ln2, ln3)
    global_gap = Fraction(RUNS, B)
    check(error_lo > 0 and base_lo > 0, "basis gap signs")
    check(base_lo + error_lo > global_gap, "negative lattice shifts excluded")
    h_max = floor((Q*global_gap + ODD_LIMIT*error_hi) / ln2[0])
    ranks = [rank_capacity(RUNS, r) for r in range(2, RUNS+1)]
    scale, cap = 10**55, 180
    rounded = []
    for e in range(cap+1):
        denominator = max(B, 2**e-1)
        rounded.append(ceil(Fraction(scale, denominator)))
    visited, survivors = 0, set()
    for h in range(1, h_max+1):
        lower = max(0, 1 + floor((h*base_lo - global_gap)/error_hi))
        upper = floor(h*base_hi/error_lo)
        for j in range(lower, upper+1):
            steps, odds = h*K0 + j*P, h*D0 + j*Q
            if odds >= ODD_LIMIT:
                continue
            lo = h*base_lo - j*error_hi
            hi = h*base_hi - j*error_lo
            if hi <= 0 or lo >= global_gap:
                continue
            visited += 1
            envelope = ceil(scale*SOURCE_CORRECTION)
            for capacity in ranks:
                exponent = min(cap, odds*capacity.denominator//capacity.numerator)
                envelope += rounded[exponent]
            if lo < Fraction(envelope, scale):
                survivors.add((steps, odds))
    expected = {(query[0], query[1]) for query in QUERIES} | {DOUBLE, NEW_PAIR}
    check(visited == 5356 and survivors == expected, "exact 88 lattice cover")
    print("sieve:", visited, "=>", sorted(survivors))


def check_new_pair(ln2, ln3):
    steps, odds = NEW_PAIR
    gap, _ = gap_interval(steps, odds, ln2, ln3)
    check(scale_floor(odds, 3, runs=RUNS) == 100, "new pair, rank 3")
    slack = gap - SOURCE_CORRECTION - Fraction(RUNS-2, 2**100-1)
    check(slack > 0 and 1+1/slack < 2**67, "new pair, rank 2 below 2^67")
    check(67*rank_capacity(87, 2) < odds, "new pair, certified H=67 capacity")
    print("new pair excluded with the already certified capacity at H=67")


@cache
def rank_height(odds, rank, capacity_runs):
    height = scale_floor(odds, rank, runs=RUNS)
    if capacity_runs >= 3 and rank < RUNS-1:
        heights = (h for h in THREE_RUN_BITS if h*rank_capacity(87, rank) < odds)
        height = max(height, *heights, 0)
    if capacity_runs >= 4 and RUNS > 3*rank:
        heights = (h for h in FOUR_RUN_BITS if h*rank_capacity(86, rank) < odds)
        height = max(height, *heights, 0)
    return height


def tail_bound(odds, start_rank, capacity_runs):
    return sum(reciprocal_bound(rank_height(odds, rank, capacity_runs))
               for rank in range(start_rank, RUNS+1))


def endpoint_credit(gap, displacement):
    check(1+RUNS/gap < 2**72, "first run at most 72")
    check(Fraction(displacement**2, B+displacement) < Fraction(2, 3)**72,
          ("endpoint credit dominates first gap", displacement))


def check_queries(ln2, ln3):
    expected_conditional = (453_027_402_666_008_300_866, 99_048_017_070_889_459_170)
    expected_reuse = (453_027_402_666_008_300_801, 99_048_017_070_889_459_164)
    for index, query in enumerate(QUERIES):
        steps, odds, low, tail, target, public_upper, need = query
        gap, _ = gap_interval(steps, odds, ln2, ln3)
        budget = gap - Fraction(low-2, B)
        height3 = rank_height(odds, target, 3)
        slack3 = budget-SOURCE_CORRECTION-tail_bound(odds, tail, 3)
        check(height3 < need and slack3 < 0, ("first failures", index))
        print(f"Q{index}: delta=1 current height {height3} < {need}, source slack negative")
        for shift, capacity in ((1, 3), (2, 0), (0, 4)):
            if shift:
                endpoint_credit(gap, shift+1)
            height = rank_height(odds, target+shift, capacity)
            slack = budget - tail_bound(odds, tail+shift, capacity)
            if shift == 0:
                slack -= SOURCE_CORRECTION
            check(height >= need, ("target", index, shift))
            check(slack > 0 and public_upper*slack >= tail-low, ("price", index, shift))
            check(RUNS > (low+shift)*(target-low), ("block bound", index, shift))
            upper = ceil(Fraction(tail-low, slack))
            if shift == 0:
                check(upper == expected_conditional[index], ("pending four-run certificate", index))
            else:
                check(upper == expected_reuse[index], ("shifted exact bound", index, shift))
            label = "conditional delta=1" if shift == 0 else f"delta>={shift+1} excluded"
            print(f"Q{index}: {label}, strict source cap {upper}, target 2^{height}-1, blocks {target-low}")


def check_double(ln2, ln3):
    steps, odds = DOUBLE
    gap, _ = gap_interval(steps, odds, ln2, ln3)
    slack3 = gap-Fraction(1, B)-SOURCE_CORRECTION-tail_bound(odds, 4, 3)
    check(rank_height(odds, 4, 3) == 67, "double actual rank 4")
    check(slack3 > 0 and 1+1/slack3 >= 2**66, "double fails known H66 bound")
    check(66*rank_capacity(87, 3) > odds, "even H=66 lacks one-run saving")
    endpoint_credit(gap, 2)
    check(scale_floor(odds, 5, runs=RUNS) == 85, "double, ordinary rank 5")
    slack2 = gap-Fraction(1, B)-Fraction(RUNS-4, 2**85-1)
    check(slack2 > 0 and 1+1/slack2 < 2**66, "double delta>=2 four low starts")
    check(66*rank_capacity(87, 4) < odds, "double delta>=2 uses H=66 capacity")
    slack4 = gap-Fraction(1, B)-SOURCE_CORRECTION-tail_bound(odds, 4, 4)
    check(slack4 > 0 and 1+1/slack4 < 2**66, "double conditional three low starts")
    check(66*rank_capacity(86, 3) < odds, "double conditional H=66 four-run cap")
    print("double: delta>=2 excluded; delta=1 depends on new four-run caps")


def v2(value):
    return (value & -value).bit_length()-1


def first_runs(x):
    counts = []
    for _ in range(4):
        a = v2(x+1)
        peak = 3**a*((x+1)>>a)-1
        counts.append(a)
        x = peak >> v2(peak)
    return counts


def falsification_controls():
    # First check every singleton with D2>H by the 87 congruence.
    # Also check small-cofactor starts with a1 within 8 of H and D2<=H.
    # No extrapolation to D3>H, D2<=H outside the small-cofactor panel.
    for height in FOUR_RUN_BITS:
        threshold = 6**height
        largest = checked = 0
        top_gap = ceil(ALPHA*height)
        for a in range(1, height):
            exponent = height+1-a
            inverse = pow(3**a, -1, 2**(top_gap+exponent))
            limit = 2**(height-a)
            for b in range(1, top_gap):
                modulus = 2**(b+exponent)
                u = ((1-2**b)*inverse) % modulus
                if not 1 <= u < limit:
                    continue
                x = 2**a*u-1
                widths = first_runs(x)
                check(sum(widths[:2]) > height, ("physical long-pair test", height, x))
                total = sum(widths)
                check(2**total < threshold, ("four-run counterexample", height, x, widths))
                checked += 1
                largest = max(largest, total)
        small_count = 0
        for a in range(height-8, height):
            for u in range(1, 2**(height-a), 2):
                x = 2**a*u-1
                widths = first_runs(x)
                if sum(widths[:2]) > height:
                    continue
                total = sum(widths)
                check(2**total < threshold, ("four-run counterexample", height, x, widths))
                small_count += 1
                largest = max(largest, total)
        print(f"H={height} falsification: {checked} long-pair lifts, {small_count} small-cofactor starts, max D4={largest}")


def main():
    ln2, ln3 = log_interval(2), log_interval(3)
    check(1 < ln3[0]/ln2[1] < ln3[1]/ln2[0] < ALPHA, "log ratio enclosure")
    check(geometric_sum(RUNS)*(7+Fraction(133, 10)*72) < ODD_LIMIT, "Rhin tail at log2(d)=70")
    sieve(ln2, ln3)
    check_new_pair(ln2, ln3)
    check_queries(ln2, ln3)
    check_double(ln2, ln3)
    falsification_controls()
    print("PASS arithmetic and falsification controls; all three delta=1 exclusions remain open.")


if __name__ == "__main__":
    main()
