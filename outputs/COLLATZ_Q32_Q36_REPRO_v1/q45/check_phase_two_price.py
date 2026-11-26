"""Exact threshold and physical-lift checks for the second-bank (1,7) guard."""

import json


N0 = 150278508408401808511
B53 = 113817632854000981000472755
SCALE = 2**80
B = 3384512724039106948104
G = 3**47

# Each state satisfies divisor * state = multiplier * A - subtract.
FORMS = {
    "terminal": (27, 32, 5, 4),
    "source_one": (9, 16, 7, 8),
    "source_two": (3, 8, 5, 11),
    "source_three": (1, 4, 3, 15),
}


def price_polynomial(m, multiplier, divisor, subtract):
    scale = 24 * 8**m * SCALE
    base = multiplier * 9**m
    return (
        base * (B53 + 5 * SCALE) - scale * subtract,
        base * 3**53 - scale * divisor,
    )


def verify_threshold(name, form):
    mult, div, sub, last_below = form
    result = {}
    for m, sign in [(last_below, -1), (last_below + 1, 1)]:
        constant, slope = price_polynomial(m, mult, div, sub)
        at_origin = slope * N0 + constant
        assert sign * slope > 0 and sign * at_origin > 0
        result[str(m)] = {"slope": slope, "value_at_min_origin": at_origin}
    return name, result


def trace_affine(initial, count):
    base, slope = initial
    word = []
    for _ in range(count):
        numerator = 3 * base + 1
        exponent = (numerator & -numerator).bit_length() - 1
        assert exponent > 0 and (3 * slope) % 2 ** (exponent + 1) == 0
        base = numerator >> exponent
        slope = (3 * slope) >> exponent
        word.append(exponent)
    return (base, slope), word


def directed_lift(m):
    reserve = 3 * m + 2
    modulus = 2 ** (reserve + 17)
    residue = 63 * pow(3 * 9**m, -1, 64) % 64
    t = (256 + 2 ** (reserve + 11) * residue - 81 * B) * pow(81 * G, -1, modulus) % modulus
    k, period = 521 + 4096 * t, 4096 * modulus
    seed = (110482433359989887 + 288230376151711744 * k,
            288230376151711744 * period)
    v, prefix = trace_affine(seed, 53)
    assert prefix[42:] == [1] * 5 + [2, 1, 2, 1, 1, 2]
    assert 2**sum(prefix) * v[0] == 3**53 * seed[0] + B53 and sum(prefix) == 80
    at_exit, macros = trace_affine(v, 2 * m)
    terminal, exit_word = trace_affine(at_exit, 2)
    assert macros == [1, 2] * m and exit_word == [1, 7]
    assert (at_exit[0] + 5) % 24 == 0 and at_exit[1] % 24 == 0
    a = ((at_exit[0] + 5) // 24, at_exit[1] // 24)
    assert a[0] % 64 == 63 and a[1] % 64 == 0
    w = ((a[0] - 3) // 4, a[1] // 4)
    reaches, tail = trace_affine(w, 3)
    assert reaches == terminal and tail == [1, 1, 1]
    return {"m": m, "reserve": reserve, "k": k, "period": period}


if __name__ == "__main__":
    print(json.dumps({"status": "PASS", "price": dict(verify_threshold(*item) for item in FORMS.items()),
                      "realization_checks": [directed_lift(m) for m in [4,5,8,9,11,12,15,16]]}, indent=2))
