"""Check the new Q44 capture and readmission on whole affine progressions."""

import json


def trace(source, count):
    offset, slope = source
    values, word = [source], []
    total, cost = 0, 0
    for _ in range(count):
        assert offset > 0 and offset % 2 == 1 and slope % 2 == 0
        dividend = 3 * offset + 1
        exponent = (dividend & -dividend).bit_length() - 1
        assert exponent > 0 and (3 * slope) % 2 ** (exponent + 1) == 0
        offset = dividend >> exponent
        slope = (3 * slope) >> exponent
        cost = 3 * cost + 2**total
        total += exponent
        values.append((offset, slope))
        word.append(exponent)
    assert 2**total * offset == 3**count * source[0] + cost
    assert 2**total * slope == 3**count * source[1]
    return values, word, (count, total, cost)


def seed(k, period):
    return (110482433359989887 + 288230376151711744 * k,
            288230376151711744 * period)


def below(x, y):
    return x[0] < y[0] and x[1] <= y[1]


def check_renewals(values, word, reserve):
    assert word[42:53] == [1] * 5 + [2, 1, 2, 1, 1, 2]
    for pivot, run, expected in [(42, 5, 4), (50, 2, reserve)]:
        a, b = values[pivot]
        aux, letters, _ = trace(((a - 1) // 2, b // 2), run)
        assert letters == [1] * (run - 1) + [3]
        w, dw = aux[-1]
        assert (w + 1) % 2 ** (expected + 1) == 2**expected
        assert dw % 2 ** (expected + 1) == 0


def verify_readmission():
    k, period = 3805769794057, 17592186044416
    n = seed(k, period)
    values, word, book = trace(n, 63)
    check_renewals(values, word, 7)
    assert word[53:] == [1, 2, 1, 2, 1, 1, 7, 1, 1, 2]
    p, f, terminal = values[42], values[60], values[-1]
    assert below(n, f) and below(f, p)
    assert f[0] % 128 == 103 and f[1] % 128 == 0
    w = ((f[0] - 1) // 2, f[1] // 2)
    aux, letters, aux_book = trace(w, 2)
    assert below(w, n) and letters == [1, 3]
    g = aux[-1]
    assert (g[0] + 1) % 4 == 2 and g[1] % 4 == 0
    assert terminal[0] + 5 == 6 * (g[0] + 1) and terminal[1] == 6 * g[1]
    return {"k": k, "period": period, "reserves": [7, 1], "T60": f,
            "original_book": book, "source": w, "source_book": aux_book}


def verify_capture():
    k, period = 365634215903753, 288230376151711744
    n = seed(k, period)
    values, word, book = trace(n, 73)
    check_renewals(values, word, 29)
    assert word[53:] == [1, 2] * 9 + [1, 7]
    x = values[71]
    assert (x[0] + 5) % 24 == x[1] % 24 == 0
    a = ((x[0] + 5) // 24, x[1] // 24)
    w = ((a[0] - 3) // 4, a[1] // 4)
    assert a[0] % 64 == 63 and a[1] % 64 == 0
    aux, letters, aux_book = trace(w, 3)
    assert below(w, n) and below(n, aux[-1])
    assert letters == [1, 1, 1] and values[-1] == aux[-1]
    assert book == (73, 115, 411443494169899340644307646523772515)
    return {"k": k, "period": period, "reserve": 29, "source": w,
            "terminal": values[-1], "original_book": book, "source_book": aux_book}


if __name__ == "__main__":
    print(json.dumps({"status": "PASS", "readmission": verify_readmission(),
                      "capture": verify_capture()}, indent=2))
