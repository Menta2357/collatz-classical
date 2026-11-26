"""Check the paid Mahler transfer and the Q46 inverse-price barrier."""

import json
from pathlib import Path
import sys


q46 = Path(__file__).resolve().parents[1] / "q46"
sys.path.insert(0, str(q46))
from check_label_switches import base_checker, verify_recharge


oracle = base_checker()


def front4b_mahler():
    front_intercept = 71667327748009080469224948461
    front_stride = 84782316550432407028588866402
    pairs, valuation = 21, 5
    power = 3 * pairs
    modulus = 2**(power + valuation + 1)
    residue = (14 + 2**valuation) * 2**power * pow(3 * 9**pairs, -1, modulus) % modulus
    assert (residue - front_intercept - 5) % 2 == 0 and front_stride % 4 == 2
    s_period = modulus // 2
    s = ((residue - front_intercept - 5) // 2 *
         pow(front_stride // 2, -1, s_period)) % s_period
    assert s % 8 == 7 and s_period % 8 == 0
    k = 428769801 + 2**31 * (108 + 128 * s)
    k_period = 2**38 * s_period
    n = oracle.seed(k, k_period)
    values, word, book = oracle.trace(n, 61 + 2 * pairs)
    f = values[60]
    assert f == (front_intercept + front_stride * s, front_stride * s_period)
    assert word[60:] == [1, 2] * pairs + [valuation]
    assert oracle.below(n, f) and f[0] % 16 == 11
    assert (f[0] - 5) % 4 == 2 and f[1] % 4 == 0
    source = ((f[0] - 5) // 2, f[1] // 2)
    path, aux, aux_book = oracle.trace(source, 2 * pairs + 1)
    assert aux == [1, 2] * (pairs - 1) + [1, 5, valuation - 4]
    assert path[-1] == values[-1]
    assert oracle.below(source, n) and oracle.below(f, values[-1])
    assert all(oracle.below(n, point) for point in values[1:])
    return {"s": s, "period": s_period, "k": k, "k_period": k_period,
            "m": pairs, "d": valuation, "original": n, "F": f, "source": source,
            "terminal": values[-1], "all_103_odd_returns_above_N": True,
            "original_book": book, "source_book": aux_book}


def t62_barrier():
    row = verify_recharge(32)
    n = oracle.seed(row["k"], row["period"])
    values, word, book = oracle.trace(n, 62)
    assert word[58:] == [1, 2, 1, 2]
    assert [x % 3 for x, _ in reversed(values[58:63])] == [1, 2, 1, 2, 1]
    assert book == (62, 93, 2281529478911289758877502905017)
    cost = book[2]
    margin = (2**17 * 3**62 - 3**14 * 2**93,
              2**17 * (cost + 2**93) - 6 * 3**14 * 2**93)
    assert min(margin) > 0
    return {"original_book": book, "certified_depths_excluded": 14,
            "required_excess_at_d_ge_5": 3, "scaled_margin": margin}


if __name__ == "__main__":
    print(json.dumps({"status": "PASS", "mahler_front4b": front4b_mahler(),
                      "inverse_barrier": t62_barrier()}, indent=2))
