"""Verify three claimed feedback guards on entire affine families."""

import json
from check_label_switches import base_checker

checker = base_checker()


def b68():
    n = checker.seed(214912002327049, 2**48)
    values, word, book = checker.trace(n, 67)
    assert word[-2:] == [2, 2] and book == (67, 105, 660904333371807647179556239957403)
    m, slope = values[-1]
    dividend, step = 3 * m + 1, 3 * slope
    assert (dividend // 2) % 4 == 0 and (step // 2) % 4 == 1
    assert dividend % 2 == step % 2 == 0
    margin = 8 * n[0] - dividend, 8 * n[1] - step
    assert min(margin) > 0 and 3**68 > 2**107
    assert m % 8 == 5
    source = (m - 1) // 4, slope
    assert checker.below(source, (n[0], 4 * n[1]))
    assert 3 * source[0] + 1 == dividend // 4 and 3 * source[1] == step
    return {"q_mod4": 0, "original_book": [68, "105+c", 3 * book[2] + 2**105],
            "source_book": [1, "c-2", 1], "terminal_margin": margin}


def c88(m, k, bits):
    n = checker.seed(k, 2**bits)
    values, word, book = checker.trace(n, 56 + 2 * m)
    checker.check_renewals(values, word, 3 * m + 2)
    assert word[53:] == [1, 2] * m + [1, 7, 3]
    e = values[-2]
    assert (e[0] - 1) % 4 == e[1] % 4 == 0
    source = (e[0] - 1) // 4, e[1] // 4
    aux, aux_word, aux_book = checker.trace(source, 1)
    assert aux_word == [1] and aux[-1] == values[-1]
    assert checker.below(n, values[-1])
    assert (checker.below(source, n) if m == 16 else checker.below(n, source))
    return {"m": m, "k": k, "period": 2**bits, "source_paid": m == 16,
            "original_book": book, "source_book": aux_book}


if __name__ == "__main__":
    print(json.dumps({"status": "PASS", "B_T68": b68(),
                      "C_T88": c88(16, 4591099348823970830778889, 82),
                      "C_T90_price_failure": c88(17, 14045277047529000548598281, 85)}, indent=2))
