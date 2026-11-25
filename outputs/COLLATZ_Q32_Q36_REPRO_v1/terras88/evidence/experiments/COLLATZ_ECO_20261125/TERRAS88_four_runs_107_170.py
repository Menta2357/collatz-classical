"""Run the sealed four-run certificate algorithm at the two remaining Q1 heights."""

from argparse import ArgumentParser
from collections import Counter
from fractions import Fraction
from math import ceil
from pathlib import Path
import sys
from time import monotonic

sys.dont_write_bytecode = True
from TERRAS88_four_runs_66_67 import four_runs, require, run_certificate  # noqa: E402


def mask_certificate(height):
    """Use the same congruences, evaluating a long gap tail only once."""
    started = monotonic()
    powers3 = [3**a for a in range(height+1)]
    gap_bits = powers3[height].bit_length()
    wide_bits = 2*gap_bits+height+1
    powers2 = [1 << exponent for exponent in range(wide_bits+1)]
    masks = [power-1 for power in powers2]
    inverses = [pow(power, -1, powers2[wide_bits]) for power in powers3]
    limit = 6**height
    counts = Counter()
    largest, largest_x = 0, []

    def visit(a, u, prefix, d_range=None, runs=None):
        nonlocal largest, largest_x
        x = powers2[a]*u-1
        if runs is None:
            runs = four_runs(x)
        if d_range is not None and not d_range[0] <= runs[1][1] < d_range[1]:
            return
        if sum(pair[0] for pair in runs[:3]) <= height:
            return
        require(runs[:len(prefix)] == prefix, ("prefix", x, prefix, runs))
        long_pair = sum(pair[0] for pair in runs[:2]) > height
        counts["long_pairs" if long_pair else "other_long_triples"] += 1
        total = sum(pair[0] for pair in runs)
        require(2**total <= limit, ("physical counterexample", height, x, runs))
        if total > largest:
            largest, largest_x = total, [x]
        elif total == largest:
            largest_x.append(x)

    for a in range(1, height):
        bits = height-a
        upper = powers2[bits]
        peak1_upper = powers3[a]*(upper-1)-1
        inverse_a = inverses[a]
        for b in range(1, peak1_upper.bit_length()):
            power_b = powers2[b]
            # When the first gap already fixes the full allowed source width,
            # test its single lift instead of constructing any longer connector.
            if b+1 >= bits:
                counts["gap_projections"] += 1
                u = ((1+power_b)*inverse_a) & masks[b+1]
                if 1 <= u < upper:
                    visit(a, u, ((a, b),))
                continue

            u = ((1-power_b)*inverse_a) & masks[b+bits+1]
            if 1 <= u < upper:
                visit(a, u, ((a, b),))

            z1_upper = (peak1_upper >> b)+1
            c_limit = min(height-a, z1_upper.bit_length()-1)
            for c in range(1, c_limit+1):
                q = height+1-a-c
                peak2_upper = powers3[c]*(z1_upper >> c)-1
                d_limit = (peak2_upper//masks[q]).bit_length()
                if d_limit <= 1:
                    continue
                bc = b+c
                # The exact second run is another projection. In the
                # remaining branch its required residue tests are preserved.
                if bc+1 >= bits:
                    counts["second_run_projections"] += 1
                    u = ((powers2[bc]+1-power_b)*inverse_a) & masks[bc+1]
                    if 1 <= u < upper:
                        runs = four_runs(powers2[a]*u-1)
                        visit(a, u, ((a, b), (c, runs[1][1])), (1, d_limit), runs)
                    continue

                inv = inverses[a+c]
                part = powers2[bc]-powers3[c]*(power_b-1)
                scaled = part*inv
                stride = inv << bc
                transition = bits-bc
                for d in range(1, min(d_limit, transition)):
                    counts["explicit_gap_lifts"] += 1
                    u = (scaled-(stride << d)) & masks[b+d+bits+1]
                    if 1 <= u < upper:
                        visit(a, u, ((a, b), (c, d)))
                # For d>=bits-b-c the shifted term vanishes modulo 2^bits.
                # Every admissible lift in the tail therefore shares one u.
                if transition < d_limit:
                    counts["gap_tail_projections"] += 1
                    u = scaled & masks[bits]
                    if 1 <= u < upper:
                        runs = four_runs(powers2[a]*u-1)
                        visit(a, u, ((a, b), (c, runs[1][1])), (transition, d_limit), runs)
    print(f"H={height}: masked exact 4-run PASS in {monotonic()-started:.3f}s")
    print(" ", dict(sorted(counts.items())))
    print(f"  max D4 on D3>H: {largest}, attained at {sorted(largest_x)}")
    print("  D3<=H covered analytically by D4 < H + log2(3) D3")


def check_q1():
    """Exact inclusion in Weaver Q1 after the capacities have passed."""
    sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "COLLATZ_TERRAS_87_RUNS_20261125"))
    from verify_ranked_path import ALPHA, B, QUERIES, gap_interval, log_interval, rank_capacity

    k, d, low, tail_rank, target_rank, source, target = QUERIES[1]
    require((low, tail_rank, target_rank, target) == (2, 4, 6, 170), "published Q1 domain")
    ln2, ln3 = log_interval(2), log_interval(3)
    require(1 < ln3[0]/ln2[1] < ln3[1]/ln2[0] < ALPHA, "alpha rational bound")
    gap, _ = gap_interval(k, d, ln2, ln3)
    heights = ((4, 67, 86), (5, 107, 86), (6, 170, 86), (7, 170, 87), (8, 256, 87))
    for rank, height, effective_runs in heights:
        require(height*rank_capacity(effective_runs, rank) < d, ("rank height", rank, height))
    tail = (Fraction(1, 2**67-1) + Fraction(1, 2**107-1) + Fraction(2, 2**170-1)
            + Fraction(81, 2**256-1))
    slack = gap-Fraction(1, B*(B+1))-tail
    require(slack > 0 and 2 <= source*slack and ceil(2/slack) == source, "source upper limit")
    blocks = target_rank-low
    require(d.bit_length()-10 > low*blocks and 88 > low*blocks, "block bound")
    print(f"Q1 delta=1 lies in the reproduced Weaver query: x < {source}, y >= 2^{target}-1, <= {blocks} blocks")


if __name__ == "__main__":
    parser = ArgumentParser(description=__doc__)
    parser.add_argument("case", choices=("107", "170", "q1"))
    case = parser.parse_args().case
    if case == "107":
        run_certificate(107)
    elif case == "170":
        mask_certificate(170)
    else:
        check_q1()
