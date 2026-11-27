"""Replay the published separated repeat and three sharp original c=3 witnesses."""
import json


def valuation(n):
    assert n > 0
    return (n & -n).bit_length() - 1


def advance(value, book):
    returns, divisions, additive = book
    numerator = 3 * value + 1
    power = valuation(numerator)
    return numerator >> power, (returns + 1, divisions + power, 3 * additive + (1 << divisions)), power


def replay(t, schedule, start, other, width, expected_valuation, expected_book):
    u = 18 + 32 * t
    seed = 1156359581173680383779426258047 + (1 << 100) * u
    value, book = seed, (0, 0, 0)
    for _ in range(65):
        value, book, _ = advance(value, book)
    assert book[:2] == (65, 102)

    lengths, cofactors, words = [2], [(value + 1) >> 3], []
    assert valuation(value + 1) == 3
    for b, following_length in schedule:
        word = (1,) * lengths[-1] + (2, b)
        words.append(word)
        for valuation_expected in word:
            value, book, power = advance(value, book)
            assert power == valuation_expected
        assert valuation(value + 1) == following_length + 1
        lengths.append(following_length)
        cofactors.append((value + 1) >> (following_length + 1))
    assert all(cofactor % 2 == 1 for cofactor in cofactors)
    assert words[start:start + width] == words[other:other + width]
    assert book == expected_book
    returns, divisions, additive = book
    assert value * (1 << divisions) == pow(3, returns) * seed + additive

    first_ending, other_ending = lengths[start + width], lengths[other + width]
    total = sum(map(sum, words[start:start + width]))
    guaranteed = total + min(first_ending, other_ending) - lengths[start] + (first_ending == other_ending)
    difference = cofactors[other] - cofactors[start]
    actual_valuation = valuation(difference)
    assert actual_valuation == expected_valuation
    assert actual_valuation >= guaranteed
    return {"t": t, "u": u, "N": seed, "book": book,
            "start_positions": (start, other), "repeated_word": words[start:start + width],
            "terminal_run_lengths": (first_ending, other_ending),
            "cofactor_difference": difference, "required_dyadic_exponent": guaranteed,
            "actual_dyadic_exponent": actual_valuation}


def main():
    witnesses = {
        "public": replay(175094053, ((1, 2), (2, 2), (1, 2), (1, 2), (2, 2)), 0, 3, 2, 13,
                         (85, 129, 278494448288432869329185530758089506552883)),
        "same_ending_b1": replay(112933, ((1, 2), (2, 2), (1, 2)), 0, 2, 1, 6,
                                  (77, 118, 42029149192825091688811104198754209107)),
        "same_ending_b2": replay(290201, ((2, 2), (1, 2), (2, 2)), 0, 2, 1, 7,
                                  (77, 119, 42988588296716230306545504973587909971)),
        "different_endings": replay(71429, ((1, 3), (2, 2), (1, 2)), 0, 2, 1, 5,
                                     (78, 119, 125434516248514520492145602682863200249)),
    }
    print(json.dumps({"status": "PASS", "witnesses": witnesses}, indent=2))


if __name__ == "__main__":
    main()
