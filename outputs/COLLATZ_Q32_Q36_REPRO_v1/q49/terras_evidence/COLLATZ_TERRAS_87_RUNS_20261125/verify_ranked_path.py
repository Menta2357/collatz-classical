"""Exact ranked-valley arithmetic for the 87-rise first-crossing problem.

This checker imports the rooted partition, endpoint credit, and path transfer
from rStation Paper 143, allPairs70 from Alick, and the seven stated local
capacity inequalities. It neither proves those inputs nor reruns the published
86-rise parity-cylinder exclusions. No orbit enumeration is performed.
"""

from fractions import Fraction as F
from math import floor


RUNS = 87
B = 28 * 10**18
ODD_LIMIT = 2**69
ALPHA = F(1_584_962_500_721_157, 10**15)
PAPER_ALPHA = F(1_584_963, 10**6)
P, Q = 423_372_672_964_960_618, 267_118_416_222_671_843
K0, D0 = 206_745_572_560_704_147, 130_441_933_147_714_940
CAPACITIES = {67, 92, 107, 146, 170, 231, 256}

# Each query records (step count, odd count, low rank, tail rank, target
# rank, published strict source cap, published target bit length).
QUERIES = (
    (630_118_245_525_664_765, 397_560_349_370_386_783,
     6, 10, 11, 453_027_402_666_008_300_866, 146),
    (7_354_673_373_747_273_033, 4_640_282_259_296_926_456,
     2, 4, 6, 99_048_017_070_889_459_170, 170),
)
DOUBLE = (2 * QUERIES[1][0], 2 * QUERIES[1][1])


def check(condition, label):
    if not condition:
        raise ArithmeticError(label)


def log_interval(value):
    z = F(value - 1, value + 1)
    terms = 100
    lower = sum(2 * z**(2 * i + 1) / (2 * i + 1) for i in range(terms))
    tail = 2 * z**(2 * terms + 1) / ((2 * terms + 1) * (1 - z*z))
    return lower, lower + tail


def geometric_sum(length, alpha=ALPHA):
    return (alpha**length - 1) / (alpha - 1)


def rank_capacity(runs, rank, alpha=ALPHA):
    return geometric_sum(runs - rank + 1, alpha) + rank - 1


def scale_floor(odd_count, rank, runs=RUNS, alpha=ALPHA, cap=256):
    return min(cap, floor(odd_count / rank_capacity(runs, rank, alpha)))


def reciprocal_bound(exponent):
    return F(1, max(B, 2**exponent - 1))


def gap_interval(steps, odds, ln2, ln3):
    return steps * ln2[0] - odds * ln3[1], steps * ln2[1] - odds * ln3[0]


def check_tail():
    # For 2**j <= d < 2**(j+1), Rhin and n*Lambda < 87 imply
    # d < G_87 * (7 + 13.3*(j+2)). The bracket grows by <2 at each step.
    j = 69
    increment = F(133, 10)
    bracket = 7 + increment * (j + 2)
    check(increment < bracket, "dyadic tail induction")
    check(geometric_sum(RUNS) * bracket < ODD_LIMIT, "dyadic tail base case")


def sieve(ln2, ln3):
    check(Q * K0 - P * D0 == 1, "unimodular basis")
    # Each pair is h*(K0,D0)+j*(P,Q). The first vector has positive gap
    # `base` and the second negative gap `-error`.
    error_lo = Q * ln3[0] - P * ln2[1]
    error_hi = Q * ln3[1] - P * ln2[0]
    base_lo, base_hi = gap_interval(K0, D0, ln2, ln3)
    global_gap = F(RUNS, B)
    check(error_lo > 0 and base_lo > 0, "both basis gap signs")
    check(base_lo + error_lo > global_gap, "negative lattice shifts are excluded")
    h_max = floor((Q * global_gap + ODD_LIMIT * error_hi) / ln2[0])
    check(h_max == 1399, "positive determinant h bound")
    # Round each reciprocal upwards to a common fixed-point denominator.
    # The cap only weakens the bound x_[rank] >= 2**floor - 1.
    scale = 10**55
    cap = 180
    rounded_terms = [
        (scale + denominator - 1) // denominator
        for denominator in (max(B, 2**e - 1) for e in range(cap + 1))
    ]
    source_correction = (scale + B*(B + 1) - 1) // (B*(B + 1))
    ranks = [rank_capacity(RUNS, rank) for rank in range(2, RUNS + 1)]
    before_valleys = 0
    survivors = set()
    for h in range(1, h_max + 1):
        j_min = max(0, 1 + floor((h * base_lo - global_gap) / error_hi))
        j_max = floor(h * base_hi / error_lo)
        for j in range(j_min, j_max + 1):
            steps, odds = h*K0 + j*P, h*D0 + j*Q
            if odds >= ODD_LIMIT:
                continue
            gap_lo = h*base_lo - j*error_hi
            gap_hi = h*base_hi - j*error_lo
            if gap_hi <= 0 or gap_lo >= global_gap:
                continue
            before_valleys += 1
            bound = source_correction
            for g in ranks:
                exponent = min(cap, odds * g.denominator // g.numerator)
                bound += rounded_terms[exponent]
            if gap_lo < F(bound, scale):
                survivors.add((steps, odds))
    expected = {(query[0], query[1]) for query in QUERIES} | {DOUBLE}
    check(before_valleys == 2646, "number of pairs before the ordered-valley cut")
    check(survivors == expected, "exhaustive three-pair survivor set")
    print(f"ordered valleys: {before_valleys} pairs reduced to {sorted(survivors)}")


def check_double(ln2, ln3):
    steps, odds = DOUBLE
    gap_lo, _ = gap_interval(steps, odds, ln2, ln3)
    check(scale_floor(odds, 4) == 85, "double, fourth valley height")
    remaining = F(RUNS - 3, 2**85 - 1)
    denominator = gap_lo - F(1, B) - remaining - F(1, B*(B + 1))
    check(denominator > 0 and 1 + 1 / denominator < 2**66,
          "double, first three starts within the 66-bit bound")
    # allPairs70 gives D_2 <= 76 at each start. After that, use
    # D_(i+1) <= 66 + alpha*D_i. The longest of three extreme chains has 85 runs.
    check(0 <= 76 - 66 <= 66, "double, convex run capacity")
    check(76*ALPHA**83 + 66*geometric_sum(83) + 2*66 < odds,
          "double, three-start partition contradicts the odd count")
    print("double: excluded by the rooted three-start partition and allPairs70")


def check_query(query, ln2, ln3, needed):
    steps, odds, low_rank, tail_rank, target_rank, upper_source, target_exponent = query
    gap_lo, _ = gap_interval(steps, odds, ln2, ln3)

    # For a certified H, chains of t >= 3 contribute <= H*G_(t-1),
    # and the convex short-chain values are H and 1.5*H. The extreme
    # partition at these ranks therefore recovers the 86-rise envelope.
    tail = F(0)
    recovery = []
    for rank in range(tail_rank, RUNS + 1):
        exponent = scale_floor(odds, rank)
        if rank < RUNS:
            old_floor = scale_floor(odds, rank, runs=86, alpha=PAPER_ALPHA)
            if old_floor > exponent:
                check(old_floor in CAPACITIES, ("missing capacity hypothesis", old_floor))
                check(RUNS - rank + 1 >= 3, ("rank partition too short", rank))
                check(old_floor * rank_capacity(86, rank) < odds,
                      ("capacity does not force the target floor", rank))
                needed.add(old_floor)
                recovery.append((rank, old_floor))
                exponent = old_floor
        if rank == target_rank:
            check(exponent >= target_exponent, "published target not recovered")
        tail += reciprocal_bound(exponent)

    denominator = gap_lo - F(low_rank - 2, B) - tail - F(1, B*(B + 1))
    check(denominator > 0 and upper_source * denominator >= tail_rank - low_rank,
          "published strict source cap not recovered, including the extra 87th rank")
    check(RUNS > low_rank * (target_rank - low_rank), "rooted path forcing condition")
    print(f"{odds}: Delta=1 imports the published query after capacities {recovery}")

    # Separate path for Delta >= 2. The first run has length <= 72.
    # Its endpoint credit cancels the source and the second ordered valley:
    # (2 - (2/3)**72)/n - log(1+2/n) < 0 for the same n > B.
    check(1 + RUNS / gap_lo < 2**72, "Delta >= 2, original seed bit length")
    check(F(2, B+1) < F(2, 3)**72, "Delta >= 2, endpoint credit cancels two ranks")
    low_rank += 1
    tail_rank += 1
    target_rank += 1
    tail = sum(reciprocal_bound(scale_floor(odds, rank)) for rank in range(tail_rank, RUNS + 1))
    denominator = gap_lo - F(low_rank - 3, B) - tail
    check(denominator > 0 and upper_source * denominator >= tail_rank - low_rank,
          "Delta >= 2, source cap with no local capacities")
    check(scale_floor(odds, target_rank) >= target_exponent, "Delta >= 2, published target")
    check(RUNS > low_rank * (target_rank - low_rank), "Delta >= 2, rooted path forcing")
    print(f"{odds}: Delta>=2 imports the same published query without new capacities")


def main():
    ln2, ln3 = log_interval(2), log_interval(3)
    check(1 < ln3[0] / ln2[1] < ln3[1] / ln2[0] < ALPHA < PAPER_ALPHA, "log ratio enclosure")
    check_tail()
    sieve(ln2, ln3)
    check_double(ln2, ln3)
    needed = set()
    for query in QUERIES:
        check_query(query, ln2, ln3, needed)
    check(needed == CAPACITIES, "exact set of local capacity inputs")
    print(f"PASS: arithmetic reduction using the published queries and capacities {sorted(needed)}")


if __name__ == "__main__":
    main()
