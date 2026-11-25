"""Exact affine checks for the Front4b row and its reentry tests."""

import json
from pathlib import Path
import sys

q46 = Path(__file__).resolve().parents[1] / "q46"
sys.path.insert(0, str(q46))
from check_label_switches import base_checker

checker = base_checker()
N = (66972346602545741868196940927, 79228162514264337593543950336)
F = (71667327748009080469224948461, 84782316550432407028588866402)

# (initial word after the alternating pairs, numerator multiplier,
# shifted additive, total valuation, last m below N, last m below F)
THRESHOLDS = (
    ((2,), 3, 14, 2, 1, 2),
    ((3,), 3, 14, 3, 7, 8),
    ((4,), 3, 14, 4, 13, 14),
    ((1, 3), 9, 40, 4, 4, 4),
    ((1, 4), 9, 40, 5, 10, 10),
    ((1, 5), 9, 40, 6, 16, 16),
    ((1, 6), 9, 40, 7, 21, 22),
)


def margin(m, scale, adjust, divisions, limit):
    return (2**divisions * 8**m * limit[0] - scale * 9**m * (F[0] + 5) + adjust * 8**m,
            2**divisions * 8**m * limit[1] - scale * 9**m * F[1])


def lift_front_residue(residue, modulus):
    assert modulus % 2 == 0
    assert (residue - F[0] - 5) % 2 == 0 and F[1] % 4 == 2
    period = modulus // 2
    s = ((residue - F[0] - 5) // 2 * pow(F[1] // 2, -1, period)) % period
    assert s % 8 == 7 and period % 8 == 0
    return s, period


def lift_output(m, scale, adjust, divisions, remainder, bits):
    modulus = 2**(3*m + divisions + bits)
    residue = 8**m * (2**divisions * remainder + adjust) * pow(scale * 9**m, -1, modulus)
    return lift_front_residue(residue % modulus, modulus)


def history(s, period, total):
    k = 428769801 + 2**31 * (108 + 128*s)
    n = checker.seed(k, 2**38 * period)
    values, word, book = checker.trace(n, total)
    assert values[60] == (F[0] + F[1]*s, F[1]*period)
    return n, values, word, book


def check_threshold(row):
    suffix, scale, adjust, divisions, below_n, below_f = row
    for limit, boundary in ((N, below_n), (F, below_f)):
        assert min(margin(boundary, scale, adjust, divisions, limit)) > 0
        assert max(margin(boundary + 1, scale, adjust, divisions, limit)) < 0
    output = {"suffix": suffix, "last_below_N": below_n, "last_below_F": below_f}
    if below_f > below_n:
        reentries = []
        for residue, tail in ((1, [2]), (7, [1, 1, 2])):
            # For residue 1 fix mod 32, so the first valuation is exactly 2.
            s, period = lift_output(below_f, scale, adjust, divisions, residue, 5)
            end = 60 + 2*below_f + len(suffix)
            n, values, word, book = history(s, period, end + len(tail))
            assert word[60:] == [1, 2]*below_f + list(suffix) + tail
            p = values[end]
            assert p[0] % 32 == residue and p[1] % 32 == 0
            assert checker.below(n, p) and checker.below(p, values[60])
            assert all(checker.below(values[60], x) for x in values[61:end])
            if residue == 1:
                assert checker.below(values[end + 1], n)
            else:
                assert all(checker.below(p, v) for v in values[end + 1:])
            reentries.append({"m": below_f, "s": s, "period": period,
                              "residue_Z_mod32": residue, "physical_tail": tail, "book": book})
        output["reentries"] = reentries
    return output


def shadow_quarter():
    m, b = 30, 7
    s, period = lift_output(m, 9, 40, b + 1, 1, 1)
    end = 60 + 2*m + 2
    n, values, word, book = history(s, period, end)
    pivot = values[60]
    source = ((pivot[0] - 15)//4, pivot[1]//4)
    aux, aux_word, aux_book = checker.trace(source, 2*m + 2)
    assert word[60:] == [1, 2]*m + [1, b]
    assert aux_word == [1, 2]*m + [5, b - 6]
    assert aux[-1] == values[-1] and checker.below(source, n)
    assert all(checker.below(n, v) for v in values[1:])
    assert aux_book == (2*m + 2, 3*m + b - 1, 45*9**m - 10*8**m)
    return {"m": m, "b": b, "s": s, "period": period, "source": source,
            "terminal": values[-1], "original_book": book, "source_book": aux_book}


def shadow_d2():
    m, e = 20, 3
    # X=4z+5, with 27z+47 having exact valuation e+3.
    z_modulus = 2**(e + 4)
    z_residue = (2**(e + 3) - 47)*pow(27, -1, z_modulus) % z_modulus
    modulus = 8**m * 4 * z_modulus
    residue = 8**m * (4*z_residue+10) * pow(9**m, -1, modulus) % modulus
    s, period = lift_front_residue(residue, modulus)
    end = 60 + 2*m + 3
    n, values, word, book = history(s, period, end)
    pivot = values[60]
    source = ((pivot[0] - 5)//2, pivot[1]//2)
    aux, aux_word, aux_book = checker.trace(source, 2*m + 3)
    assert word[60:] == [1, 2]*m + [2, 3, e]
    assert aux_word == [1, 2]*(m-1) + [1, 3, 1, 4, e-2]
    assert aux[-1] == values[-1] and checker.below(source, n)
    assert all(checker.below(n, v) for v in values[1:])
    assert aux_book == (2*m + 3, 3*m + 4 + e, 135*9**m - 41*8**m)
    return {"m": m, "e": e, "s": s, "period": period, "source": source,
            "terminal": values[-1], "original_book": book, "source_book": aux_book}


def early_meeting():
    n, values, word, book = history(0, 1, 60)
    pivot = values[-1]
    assert word[-1] == 7
    assert n == N and pivot == F
    assert (2*pivot[0]-1) % 3 == (2*pivot[1]) % 3 == 0
    source = ((2*pivot[0]-1)//3, 2*pivot[1]//3)
    path, aux, aux_book = checker.trace(source, 1)
    assert path[-1] == pivot and aux == [1] and aux_book == (1, 1, 1)
    assert checker.below(source, n) and checker.below(n, pivot)
    assert book == (60, 95, 253163701604367108480427299121)
    # On the larger row, b>=7 if and only if q=44 mod 64.
    base_last = 5642588099487446991065277197
    numerator_base, numerator_step = 3*base_last+1, 2*3**60
    assert numerator_base % 2 == 0 and numerator_step % 4 == 2
    assert (-numerator_base//2)*pow(numerator_step//2, -1, 64) % 64 == 44
    assert (numerator_base+44*numerator_step) % 256 == 0
    assert (numerator_base+108*numerator_step) % 256 == 128
    return {"q_base": 108, "q_period": 128, "last_valuation": 7, "N": n,
            "source": source, "terminal": pivot,
            "source_margin": [x-y for x, y in zip(n, source)],
            "original_book": book, "source_book": aux_book,
            "parent_union_q_mod64": 44}


def main():
    assert min(12*n - 11*f for n, f in zip(N, F)) > 0
    print(json.dumps({"status": "PASS", "early_meeting": early_meeting(),
                      "thresholds": [check_threshold(row) for row in THRESHOLDS],
                      "quarter_capture": shadow_quarter(), "weak_d2_capture": shadow_d2()}, indent=2))


if __name__ == "__main__":
    main()
