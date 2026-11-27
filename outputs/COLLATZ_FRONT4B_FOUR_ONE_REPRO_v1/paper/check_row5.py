"""Independent integer and affine replay for the two short valuation-four cylinders."""
import json


MACRO = (1, 1, 1, 2, 2, 1, 1, 1, 2, 1, 4)
FROM_PIVOT = (1, 1, 2, 2)
ENTRY = (21076350839635022295760718777647, 247225235061060898895365134428232)
CLASSES = ((59168, 65536), (223008, 262144))


def trailing_twos(n):
    assert n > 0
    return (n & -n).bit_length() - 1


def search_residue(word):
    clock, cost = 0, 0
    for a in word:
        cost = 3 * cost + (1 << clock)
        clock += a
    modulus = 1 << (clock + 1)
    state_residue = ((1 << clock) - cost) * pow(3 ** len(word), -1, modulus) % modulus
    first, slope = ENTRY
    assert trailing_twos(slope) == 3 and (state_residue - first) % 8 == 0
    modulus //= 8
    return (((state_residue - first) // 8) * pow(slope // 8, -1, modulus)) % modulus, modulus


def less(left, right):
    return left[0] < right[0] and left[1] <= right[1]


def replay(t, modulus, expected_word):
    n_const = 1156359581173680383779426258047
    n_mul = 1 << 100
    seed = (n_const + n_mul * (10 + 128 * t), n_mul * 128 * modulus)
    states, books = [seed], [(0, 0, 0)]
    for moment in range(62 + len(expected_word)):
        x, dx = states[-1]
        returns, divisions, additive = books[-1]
        numerator = 3 * x + 1
        valuation = trailing_twos(numerator)
        if moment >= 62:
            assert expected_word[moment - 62] == valuation
        power = 1 << valuation
        assert (3 * dx) % (2 * power) == 0
        endpoint = (numerator // power, 3 * dx // power)
        assert endpoint[0] % 2 == 1 and endpoint[1] % 2 == 0
        states.append(endpoint)
        books.append((returns + 1, divisions + valuation, 3 * additive + (1 << divisions)))
    returns, divisions, additive = books[-1]
    assert states[-1][0] * (1 << divisions) == (3 ** returns) * seed[0] + additive
    assert states[-1][1] * (1 << divisions) == (3 ** returns) * seed[1]
    assert states[66] == (ENTRY[0] + ENTRY[1] * t, ENTRY[1] * modulus)
    return states, books


def check_rank(r, h, b):
    word = MACRO + (2,) * r + (1,) * h + (2, b)
    t, modulus = search_residue(word)
    residue, parent_modulus = CLASSES[r]
    assert t % parent_modulus == residue and modulus % parent_modulus == 0
    states, books = replay(t, modulus, FROM_PIVOT + word)
    old, new = states[66], states[77 + r]
    assert old[0] % 32 == 15 and old[1] % 32 == 0
    q_power = 1 << (h + 1)
    assert (new[0] + 1) % (2 * q_power) == q_power and new[1] % (2 * q_power) == 0
    q0 = ((old[0] + 1) // 16, old[1] // 16)
    q1 = ((new[0] + 1) // q_power, new[1] // q_power)
    if h >= 4:
        assert less(q1, q0)
    else:
        assert less(q0, q1)
    return {"r": r, "H": h, "b": b, "t": t, "modulus": modulus,
            "decreases": h >= 4, "initial_cofactor": q0, "reentry_cofactor": q1,
            "reentry_book": books[77 + r], "checked_book": books[-1]}


def check_strong(r, expected_residue, expected_modulus, expected_book):
    word = MACRO + (2,) * r + (1, 3)
    t, modulus = search_residue(word)
    assert (t, modulus) == (expected_residue, expected_modulus)
    residue, parent_modulus = CLASSES[r]
    assert t % parent_modulus == residue and modulus % parent_modulus == 0
    states, books = replay(t, modulus, FROM_PIVOT + word)
    assert books[-1] == expected_book
    seed, pivot, final = states[0], states[62], states[-1]
    assert all(less(pivot, state) for state in states[63:-1])
    assert less(final, pivot)
    if r == 0:
        assert less(seed, final)
    else:
        assert less(final, seed)
    return {"r": r, "t": t, "modulus": modulus, "seed": seed, "pivot": pivot, "terminal": final,
            "local_first_crossing_return": len(states) - 63, "descends": r == 1, "book": books[-1]}


def main():
    strong = [check_strong(0, 452384, 524288, (79, 125, 409938669746458470781450280772615731179)),
              check_strong(1, 2058016, 2097152, (80, 127, 1267034393121353056785657440005696841665))]
    weak = [check_rank(r, h, b) for r in (0, 1) for h in (3, 4) for b in (1, 2)]
    print(json.dumps({"status": "PASS", "strong": strong, "rank": weak}, indent=2))


if __name__ == "__main__":
    main()
