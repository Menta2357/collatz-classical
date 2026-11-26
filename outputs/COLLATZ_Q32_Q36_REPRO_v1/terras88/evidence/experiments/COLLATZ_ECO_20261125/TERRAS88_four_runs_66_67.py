"""Exhaustive local four-run certificates at the two fixed heights 66 and 67."""

from argparse import ArgumentParser
from fractions import Fraction
from math import ceil
from pathlib import Path
import sys
from time import monotonic


def require(condition, context):
    if not condition:
        raise ArithmeticError(context)


def v2(value):
    require(value > 0, ("valuation domain", value))
    return (value & -value).bit_length() - 1


def four_runs(start):
    records = []
    x = start
    for _ in range(4):
        rise = v2(x + 1)
        peak = 3**rise * ((x + 1) >> rise) - 1
        gap = v2(peak)
        records.append((rise, gap))
        x = peak >> gap
    return tuple(records)


def examine(x, height, prefix, minimum):
    runs = four_runs(x)
    require(0 < x and x % 2 == 1 and x + 1 < 2**height, ("source", x, height))
    require(runs[:len(prefix)] == prefix, ("precise connector", x, prefix, runs))
    subtotal = sum(run[0] for run in runs[:len(prefix)+1])
    require(subtotal >= minimum, ("partial odd count", x, runs, minimum))
    total = sum(run[0] for run in runs)
    require(2**total <= 6**height, ("physical counterexample", height, x, runs))
    return total


def run_certificate(height):
    start = monotonic()
    power3 = [3**a for a in range(height+1)]
    # Prior to peak two at most H odd steps have occurred in the branch
    # D2<=H. Its height, and similarly the first peak, is <3^H.
    gap_bits = power3[height].bit_length()
    wide_modulus = 2**(2*gap_bits+height+1)
    inverse = [pow(power, -1, wide_modulus) for power in power3]
    masks = [2**bits-1 for bits in range(wide_modulus.bit_length())]
    long_pairs = long_triples = certificates = 0
    largest = 0
    largest_starts = set()
    for a in range(1, height):
        cofactor_limit = 2**(height-a)
        peak1_upper = power3[a]*(cofactor_limit-1)-1
        for b in range(1, peak1_upper.bit_length()):
            # A unique lift for D2>H, since b>0 and u<2^(H-a).
            exponent = b+height+1-a
            u = ((1-2**b)*inverse[a]) & masks[exponent]
            if 1 <= u < cofactor_limit:
                x = 2**a*u-1
                total = examine(x, height, ((a, b),), height+1)
                long_pairs += 1
                if total > largest:
                    largest, largest_starts = total, {x}
                elif total == largest:
                    largest_starts.add(x)

            # Now D2<=H, with exact second odd length c and preceding gap b.
            valley1_plus_one_upper = (peak1_upper >> b) + 1
            second_limit = min(height-a, valley1_plus_one_upper.bit_length()-1)
            for c in range(1, second_limit+1):
                minimum_a3 = height+1-a-c
                valley2_lower = 2**minimum_a3-1
                peak2_upper = power3[c]*(valley1_plus_one_upper >> c)-1
                gap_limit = (peak2_upper//valley2_lower).bit_length()
                part = 2**(b+c) - power3[c]*(2**b-1)
                inv = inverse[a+c]
                for d in range(1, gap_limit):
                    certificates += 1
                    exponent = b+d+height+1-a
                    u = ((part-2**(b+c+d))*inv) & masks[exponent]
                    if not 1 <= u < cofactor_limit:
                        continue
                    x = 2**a*u-1
                    total = examine(x, height, ((a, b), (c, d)), height+1)
                    long_triples += 1
                    if total > largest:
                        largest, largest_starts = total, {x}
                    elif total == largest:
                        largest_starts.add(x)
    print(f"H={height}: exact 4-run PASS in {monotonic()-start:.3f}s")
    print(f"  {certificates} bounded tuples; {long_pairs} long pairs; {long_triples} other long triples")
    print(f"  max D4 on D3>H: {largest}, attained at {sorted(largest_starts)}")
    print(f"  D3<=H covered analytically by D4 < H + log2(3) D3")


def check_double_from_67():
    # Import arithmetic only. The older sieve and checks are not executed.
    sys.dont_write_bytecode = True
    sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "COLLATZ_TERRAS_87_RUNS_20261125"))
    from verify_ranked_path import ALPHA, B, DOUBLE, gap_interval, log_interval, rank_capacity

    k, d = DOUBLE
    ln2, ln3 = log_interval(2), log_interval(3)
    require(1 < ln3[0]/ln2[1] < ln3[1]/ln2[0] < ALPHA, "alpha rational bound")
    lower_gap, _ = gap_interval(k, d, ln2, ln3)
    require(67*rank_capacity(87, 4) < d, "old rank 4 floor")
    require(107*rank_capacity(87, 5) < d, "old rank 5 floor")
    slack = (lower_gap - Fraction(1, B) - Fraction(1, B*(B+1))
             - Fraction(1, 2**67-1) - Fraction(84, 2**107-1))
    require(slack > 0 and 1+1/slack < 2**67, "third ordered valley below H=67")
    capacity = 67*rank_capacity(86, 3)
    require(capacity < d, "new partition at H=67")
    print(f"double delta=1: x_[3]+1 < {ceil(1+1/slack)} < 2^67")
    print(f"  d <= rooted capacity < {ceil(capacity)} < {d}, contradiction")


if __name__ == "__main__":
    parser = ArgumentParser(description=__doc__)
    parser.add_argument("height", choices=(66, 67), type=int)
    height = parser.parse_args().height
    run_certificate(height)
    if height == 67:
        check_double_from_67()
