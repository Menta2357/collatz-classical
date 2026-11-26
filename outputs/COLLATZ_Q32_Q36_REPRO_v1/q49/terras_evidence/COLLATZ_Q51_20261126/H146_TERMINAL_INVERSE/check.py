#!/usr/bin/env python3
"""Exhaust the H146 failure candidates backwards when D3 <= 146."""

from collections import Counter
from fractions import Fraction
from hashlib import sha256
import json
from math import ceil
from pathlib import Path


HEIGHT = 146
FAILURE = 378
ROOT = Path(__file__).resolve().parent


def require(condition, label):
    if not condition:
        raise ArithmeticError(label)


def envelope_coefficient(blocks):
    return 2**(HEIGHT-blocks) + blocks


def val2(n):
    return (n & -n).bit_length()-1


def replay(seed):
    """Recompute five exact maximal rises and complete gaps."""
    x = seed
    divisions = odd = additive = 0
    word = []
    for _ in range(5):
        a = val2(x+1)
        peak = 3**a * ((x+1) >> a)-1
        b = val2(peak)
        require(a > 0 and b > 0, ("positive run and gap", x, a, b))
        x = peak >> b
        additive = 3**a * additive + 2**divisions*(3**a-2**a)
        odd += a
        divisions += a+b
        require(2**divisions*x == 3**odd*seed+additive, ("exact physical book", seed, word))
        word.append((a,b))
    return word


def trace_back(x, odds, blocks, counters):
    """Yield all physical sources for the fixed endpoint, within the envelope."""
    if blocks == 0:
        if odds == 0 and 0 < x and x % 2 == 1 and x+1 < 2**HEIGHT:
            yield x
        return
    require(0 < x and x % 2 == 1 and blocks <= odds, ("inversion state", x, odds, blocks))
    if 2**odds*(x+1) >= envelope_coefficient(blocks)*3**odds:
        counters["above_envelope"] += 1
        return
    b = 1
    while x*2**(odds+b) < envelope_coefficient(blocks-1)*3**odds:
        counters["inverse_gaps"] += 1
        cofactor = 2**b*x+1
        for a in range(1,odds-blocks+2):
            if cofactor % 3:
                break
            cofactor //= 3
            prev = 2**a * cofactor-1
            counters["inverse_branches"] += 1
            require(val2(prev+1) == a and val2(3**a*cofactor-1) == b,
                    ("exact inverse valuation", prev, x, a, b))
            yield from trace_back(prev,odds-a,blocks-1,counters)
        b += 1


def terminal_candidates(counters):
    require(envelope_coefficient(4)*3**HEIGHT < 2**FAILURE, "D4<=H")
    fourth_limit = (envelope_coefficient(3)*3**HEIGHT-1).bit_length()-1
    require(2**(FAILURE-1) <= 6**HEIGHT < 2**FAILURE, "exact integer target")
    for odds in range(HEIGHT+1,fourth_limit+1):
        exponent = FAILURE-odds
        modulus = 3**(odds-HEIGHT)
        main = Fraction(envelope_coefficient(3)*3**odds,2**FAILURE)
        shift = Fraction(1,2**exponent)
        b = 1
        while (limit := ceil(main/2**b+shift)-1) > 0:
            counters["terminal_gaps"] += 1
            require(limit < modulus, ("unique candidate", odds, b))
            residue = (2**b-1)*pow(2**(b+exponent),-1,modulus) % modulus
            if 0 < residue <= limit:
                yield odds,b,residue,limit
            b += 1


def main():
    counters = Counter()
    candidates = []
    hits = set()
    for odds,b,t,limit in terminal_candidates(counters):
        x4 = t*2**(FAILURE-odds)-1
        z = 2**b*x4+1
        residual = z//3**(odds-HEIGHT)
        require(z == residual*3**(odds-HEIGHT), ("necessary last congruence", odds, b, t))
        branches = 0
        for a4 in range(odds-HEIGHT,odds-2):
            if a4 > odds-HEIGHT:
                if residual % 3:
                    break
                residual //= 3
            x3 = 2**a4 * residual-1
            require(val2(x3+1) == a4 and val2(3**a4*residual-1) == b, "last physical block")
            branches += 1
            for seed in trace_back(x3,odds-a4,3,counters):
                word = replay(seed)
                require(sum(a for a,_ in word[:3]) <= HEIGHT and
                        sum(a for a,_ in word[:4]) == odds and
                        sum(a for a,_ in word) >= FAILURE, ("counterexample to promised scope", seed))
                hits.add(seed)
        candidates.append(dict(D4=odds,b4=b,t=t,limit=limit,a4_branches=branches))
    require(not hits, ("counterexamples", sorted(hits)))
    print(json.dumps(dict(status="PASS_H146_D3_AT_MOST_146", height=HEIGHT, D3_at_most=HEIGHT,
                          D5_at_most=FAILURE-1, candidates=candidates, counters=dict(counters),
                          full_seed_replays=len(hits), scripts_sha256={
                              name:sha256((ROOT/name).read_bytes()).hexdigest()
                              for name in ("check.py","PREREGISTRO.md")}), indent=2))


if __name__ == "__main__":
    main()
