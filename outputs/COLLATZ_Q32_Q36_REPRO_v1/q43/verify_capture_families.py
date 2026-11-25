"""Verify the five new A2 progressions by exact affine arithmetic."""

import json


def trajectory(source, returns):
    base, slope = source
    values, word = [source], []
    divisions, additive = 0, 0
    for _ in range(returns):
        assert base > 0 and base % 2 == 1 and slope >= 0 and slope % 2 == 0
        dividend = 3 * base + 1
        valuation = (dividend & -dividend).bit_length() - 1
        assert valuation > 0 and (3 * slope) % 2 ** (valuation + 1) == 0
        base = dividend >> valuation
        slope = (3 * slope) >> valuation
        additive = 3 * additive + 2**divisions
        divisions += valuation
        word.append(valuation)
        values.append((base, slope))
    assert 2**divisions * base == 3**returns * source[0] + additive
    assert 2**divisions * slope == 3**returns * source[1]
    return values, word, (returns, divisions, additive)


CASES = [
    (109103897609, 274877906944, 43, 14, 0, 1, [1, 1, 8, 1], [2, 1, 3, 1, 3]),
    (223188966409, 2199023255552, 43, 14, 1, 1, [1, 1, 8, 1], [1, 1, 1, 3, 3, 1, 3]),
    (988371977, 1073741824, 43, 9, 0, 2, [1, 7], [1, 1, 1]),
    (7177 + 8192 * 1952084323634960330, 8192 * 2**63, 43, 10, 14, 0, [2, 9], [1]),
    (125120985, 134217728, 40, 5, 3, 0, [5], [1]),
]


def check(case):
    residue, stride, pivot_clock, run, macros, phase, exit_word, companion = case
    assert residue % 131072 in {78297, 89097} and stride % 131072 == 0
    seed = (110482433359989887 + 288230376151711744 * residue,
            288230376151711744 * stride)
    suffix = [1] * run + [2] + [1, 2] * macros + exit_word
    values, word, ledger = trajectory(seed, pivot_clock + len(suffix))
    assert word[pivot_clock - 1] == 2 and word[pivot_clock:] == suffix
    pivot = values[pivot_clock]
    rupture = values[pivot_clock + run + 1]
    if phase == 1:
        source = ((pivot[0] - 1) // 2, pivot[1] // 2)
        source_word = [1] * (run - 1) + [3] + companion
    elif phase == 2:
        assert (rupture[0] + 5) % 24 == 0 and rupture[1] % 24 == 0
        cofactor = ((rupture[0] + 5) // 24, rupture[1] // 24)
        assert cofactor[0] % 64 == 63 and cofactor[1] % 64 == 0
        source = ((cofactor[0] + 1) // 4 - 1, cofactor[1] // 4)
        source_word = companion
    else:
        before_final = values[-2]
        factor = 2 ** (exit_word[-1] - 1)
        shift = (factor - 1) // 3
        assert (before_final[0] - shift) % factor == 0 and before_final[1] % factor == 0
        source = ((before_final[0] - shift) // factor, before_final[1] // factor)
        source_word = companion
    aux, actual, aux_ledger = trajectory(source, len(source_word))
    assert actual == source_word and aux[-1] == values[-1]
    assert 0 < source[0] < seed[0] and 0 <= source[1] < seed[1]
    assert all(value[0] > seed[0] and value[1] >= seed[1] for value in values[1:])
    return {"k_residue": residue, "k_stride": stride, "phase": phase, "macros": macros,
            "N": seed, "source": source, "terminal": values[-1],
            "original_book": ledger, "source_book": aux_ledger}


def check_reserve_regeneration():
    residue, stride = 428769801, 2147483648
    seed = (110482433359989887 + 288230376151711744 * residue,
            288230376151711744 * stride)
    values, word, ledger = trajectory(seed, 57)
    assert word[42:50] == [1] * 5 + [2, 1, 2]
    assert word[50:] == [1, 1, 2, 1, 2, 1, 2]
    for pivot_clock, run, reserve in [(42, 5, 4), (50, 2, 7)]:
        base, slope = values[pivot_clock]
        companion = ((base - 1) // 2, slope // 2)
        ends, valuation_word, _ = trajectory(companion, run)
        assert valuation_word == [1] * (run - 1) + [3]
        end, lift = ends[-1]
        assert (end + 1) % 2 ** (reserve + 1) == 2**reserve
        assert lift % 2 ** (reserve + 1) == 0
        if pivot_clock == 50:
            assert companion[0] > seed[0] and companion[1] >= seed[1]
    assert all(value[0] > seed[0] and value[1] >= seed[1] for value in values[1:])
    return {"k_residue": residue, "k_stride": stride, "reserves": [4, 7],
            "first_new_pivot": values[50], "original_book": ledger}


if __name__ == "__main__":
    print(json.dumps({"status": "PASS", "families": [check(case) for case in CASES],
                      "reserve_regeneration": check_reserve_regeneration()}, indent=2))
