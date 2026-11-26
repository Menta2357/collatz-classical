"""Exact affine cut on one fixed Front4b row through the next three returns."""

import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "q46"))
from check_label_switches import base_checker

checker = base_checker()
CASES = (
    (3, 4, (), 3, "descent"),
    (5, 16, (2,), 3, "descent"),
    (6, 8, (1,), 3, "capture_or_descent"),
    (2, 32, (1, 2), 3, "descent"),
    (8, 32, (1, 1), 4, "descent"),
    (13, 32, (2, 2), 2, "descent"),
    (25, 32, (2, 1), 3, "descent"),
)
FOURTH_STEP = (
    (17, 64, (2, 1, 1), 3, "capture_or_descent"),
    (26, 64, (1, 2, 1), 3, "capture_or_descent"),
    (32, 64, (1, 1, 2), 3, "capture_or_descent"),
)


def data(c):
    r, stride, moves, floor, method = c
    seed = checker.seed(428769801 + 2**31 * (12 + 64*r), 2**37*stride)
    history, word, book = checker.trace(seed, 60+len(moves))
    assert word[59:] == [6]+list(moves)
    terminal = history[-1]
    numerator = 3 * terminal[0]+1, 3 * terminal[1]
    modulus = 2**floor
    assert all(v % modulus == 0 for v in numerator)
    end = book[0]+1
    cost = 3*book[2]+2**book[1]
    record = {"s_offset": r, "s_modulus": stride, "valuations_after_T60": moves,
              "last_valuation_lower_bound": floor, "result": method,
              "original_book": [end, f"{book[1]}+b", cost]}
    if method == "descent":
        assert min(modulus*n-y for n, y in zip(seed, numerator)) > 0
    else:
        assert floor == 3
        assert min(16*n-y for n, y in zip(seed, numerator)) > 0
        divide8 = tuple(v//8 for v in numerator)
        assert divide8[0] % 3 == 2 and divide8[1] % 3 == 0
        assert min(3*n-2*y+int(i==0) for i,(n,y) in enumerate(zip(seed, divide8))) > 0
        record["source_book_at_b3"] = [1, 1, 1]
    return record, history[61:]


def main():
    covered = set()
    rows = []
    for case in CASES:
        residue, modulus = case[:2]
        lifts = set(range(residue, 32, modulus))
        assert not lifts & covered
        covered.update(lifts)
        rows.append(data(case)[0])
    assert len(covered) == 18
    lifted = {x for x in range(64) if x % 32 in covered}
    extra = {c[0] for c in FOURTH_STEP}
    assert not lifted & extra and len(lifted | extra) == 39
    print(json.dumps({"status": "PASS", "cases": rows, "covered_s_mod32": sorted(covered),
                      "outstanding_at_T63_s_mod32": sorted(set(range(32))-covered),
                      "fourth_step": [data(c)[0] for c in FOURTH_STEP],
                      "covered_at_T64_s_mod64": sorted(lifted | extra),
                      "outstanding_at_T64_s_mod64": sorted(set(range(64))-lifted-extra)}, indent=2))


if __name__ == "__main__":
    main()
