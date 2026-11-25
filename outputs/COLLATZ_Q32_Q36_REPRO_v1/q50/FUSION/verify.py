"""Q50: first-hit excess-seven certificate, target depth exactly fourteen."""

from hashlib import sha256
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
PARENT_PATH = "experiments/COLLATZ_Q49_20261125/FUSION_T60_EXCESS6_PAPER/RECIBO.json"
PARENT_HASH = "31a060c3ac5d9b2c041e2f42bae9b13fa862b40e265fa12431bec707395e30d4"
FROZEN = [
    ((8,), (1, 8, 1), 0, 0),
    ((6, 3), (2, 9, 11), 0, 0),
    ((6, 1, 3), (3, 10, 49), 2, 0),
    ((4, 2, 3, 2), (4, 11, 287), 0, 0),
    ((6, 1, 1, 2, 1, 2), (6, 13, 1391), 1, 1),
]


def reject(token):
    raise ValueError("INEXACT_JSON_NUMBER_REJECTED: " + token)


def main():
    raw = (ROOT / "q49/FUSION_T60_EXCESS6_PAPER/RECIBO.json").read_bytes()
    assert sha256(raw).hexdigest() == PARENT_HASH
    parent = json.loads(raw, parse_float=reject, parse_constant=reject)
    n0, n1 = parent["N_affine_s"]
    f0, f1 = parent["F_affine_s"]
    book = parent["original_book"]
    assert all(type(x) is int for x in (n0, n1, f0, f1, *book))
    assert book == [60, 94, 253163701604367108480427299121]
    assert f1 == 2 * 3 ** 60
    assert 2 ** 94 * f0 == 3 ** 60 * n0 + book[2]
    assert 2 ** 94 * f1 == 3 ** 60 * n1
    rows = {tuple(r["inverse_word"]): r for r in parent["fixed_symbolic_certificate"]}
    assert len(rows) == 12

    # A first hit at seven fixes a uniquely: a=8-e. No inverse-tree search.
    hits = set()
    for word, row in rows.items():
        e = row["excess"]
        r = row["state_residue_mod3"]
        assert 0 <= e <= 6
        a = 8 - e
        if r and pow(2, a, 3) * r % 3 == 1:
            hits.add(word + (a,))
    assert hits == {word for word, *_ in FROZEN}

    result_rows = []
    for word, expected_book, tau, expected_end_mod3 in FROZEN:
        old = rows[word[:-1]]
        p0, s0, c0 = old["book"]
        a = word[-1]
        p, s, c = p0 + 1, s0 + a, 2 ** a * c0 + 3 ** p0
        assert (p, s, c) == expected_book and s - p == 7
        y0, rem0 = divmod(2 ** s * f0 - c, 3 ** p)
        y1, rem1 = divmod(2 ** s * f1, 3 ** p)
        assert rem0 == rem1 == 0
        assert y0 > 0 and y0 % 2 == 1 and y1 % 2 == 0
        assert (y0 + 1) % 3 ** tau == 0
        assert (y0 + 1) % 3 ** (tau + 1) != 0
        assert y1 % 3 ** (tau + 1) == 0
        assert tau < 14 - p

        end0 = 2 ** tau * ((y0 + 1) // 3 ** tau) - 1
        end1 = 2 ** tau * (y1 // 3 ** tau)
        end_c = 2 ** tau * c + 3 ** p * (3 ** tau - 2 ** tau)
        assert end0 > 0 and end0 % 2 == 1 and end1 % 2 == 0
        assert end0 % 3 == expected_end_mod3 and end1 % 3 == 0
        assert 3 ** (p + tau) * end0 + end_c == 2 ** (s + tau) * f0
        assert 3 ** (p + tau) * end1 == 2 ** (s + tau) * f1
        result_rows.append({"first_hit_word": list(word), "book": [p, s, c],
                            "v3_state_plus_one": tau, "ones_required_for_depth14": 14 - p,
                            "forced_tail_book": [p + tau, s + tau, end_c],
                            "terminal_residue_mod3": expected_end_mod3})

    nu = [n0 + 29 * n1, 32 * n1]
    fu = [f0 + 29 * f1, 32 * f1]
    assert 2 ** 94 * fu[0] == 3 ** 60 * nu[0] + book[2]
    assert 2 ** 94 * fu[1] == 3 ** 60 * nu[1]
    print(json.dumps({
        "status": "PASS_D14_E7_REFUTED_BY_FIRST_HIT_CERTIFICATE",
        "proof_status_at_run": "PAPER_PENDING_INDEPENDENT_REVIEW",
        "domain": "all affine q12 s>=0; includes s=29+32*u",
        "N_affine_s": [n0, n1], "F_affine_s": [f0, f1],
        "N_affine_u": nu, "F_affine_u": fu, "original_book": book,
        "target_auxiliary_book": [14, 21, "C arbitrary"],
        "first_hit_entries": result_rows,
        "target_refuted_even_without_price": True,
        "paid_corollary_using_Q49": "p>=15; no analysis of depth15",
        "orbits_replayed": 0, "parent_scripts_rerun": 0, "new_lean_builds": 0,
        "parent_path": PARENT_PATH, "parent_sha256": PARENT_HASH,
    }, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
