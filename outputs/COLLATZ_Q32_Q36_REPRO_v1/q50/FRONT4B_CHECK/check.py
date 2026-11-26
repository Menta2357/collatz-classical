"""Verify Q50 arithmetic on affine progressions, with the physical Q49 prefix as input."""

import json


PARENT_BOOK = (60, 94, 253163701604367108480427299121)
CASES = (
    (1, 4, (2, 2, 1), 3, False, "LEAN"),
    (6, 8, (2, 2, 1, 1), 3, True, "LEAN"),
    (3, 16, (2, 2, 1, 2), 3, False, "PAPER"),
    (12, 32, (2, 2, 1, 1, 1), 4, False, "PAPER"),
)
Q49_S_MOD64 = (
    2, 3, 5, 6, 7, 8, 11, 13, 14, 15, 17, 19, 21, 22, 23,
    25, 26, 27, 30, 31, 32, 34, 35, 37, 38, 39, 40, 43, 45, 46,
    47, 51, 53, 54, 55, 57, 59, 62, 63,
)


PARENT_BOOK = (60, 94, 253163701604367108480427299121)
CASES = (
    (1, 4, (2, 2, 1), 3, False, "LEAN"),
    (6, 8, (2, 2, 1, 1), 3, True, "LEAN"),
    (3, 16, (2, 2, 1, 2), 3, False, "PAPER"),
    (12, 32, (2, 2, 1, 1, 1), 4, False, "PAPER"),
)
Q49_S_MOD64 = (
    2, 3, 6, 7, 8, 11, 13, 14, 15, 17, 18, 19, 21, 22, 23, 25, 26,
    27, 30, 31, 32, 34, 35, 38, 39, 40, 43, 45, 46, 47, 50, 51, 53,
    54, 55, 57, 59, 62, 63,
)


def require(condition, what):
    if not condition:
        raise ArithmeticError(what)


def original_and_prefix(u, stride):
    s = 29 + 32*u
    k = 428769801 + 2**31*(12+64*s)
    n = (110482433359989887 + 2**58*k, 2**100*stride)
    f = (16161180670369550395566597319 + 84782316550432407028588866402*s,
         84782316550432407028588866402*32*stride)
    j, divisions, cost = PARENT_BOOK
    require(2**divisions*f[0] == 3**j*n[0]+cost and
            2**divisions*f[1] == 3**j*n[1], "Q49 affine book")
    return n, f


def edge(state, valuation):
    offset, slope = 3*state[0]+1, 3*state[1]
    divisor = 2**valuation
    require(offset % (2*divisor) == divisor and slope % (2*divisor) == 0,
            ("physical valuation", state, valuation))
    return offset//divisor, slope//divisor


def positive(margin):
    return margin[0] > 0 and margin[1] >= 0


def difference(x, left, y, right, constant=0):
    return (left*x[0] - right*y[0] + constant, left*x[1] - right*y[1])


def case(residue, modulus, word, floor, capture, evidence):
    original, terminal = original_and_prefix(residue, modulus)
    book = PARENT_BOOK
    for a in word:
        terminal = edge(terminal, a)
        j, divisions, cost = book
        book = j+1, divisions+a, 3*cost+2**divisions
    j, divisions, cost = book
    numerator = 3*terminal[0]+1, 3*terminal[1]
    require(all(coefficient % 2**floor == 0 for coefficient in numerator), "terminal floor")
    descent_at = 4 if capture else floor
    margin = difference(original, 2**descent_at, numerator, 1)
    require(positive(margin), "descent against N")
    row = dict(u=[residue, modulus], s=[29+32*residue, 32*modulus], evidence=evidence,
               tail_prefix=word, last_valuation_at_least=floor,
               original_book=[j+1, f"{divisions}+d", 3*cost+2**divisions],
               descent_if_d_at_least=descent_at, descent_margin_affine=margin)
    if capture:
        y = tuple(value//8 for value in numerator)
        w = ((2*y[0]-1)//3, 2*y[1]//3)
        require(w[0] > 0 and w[0]%2 == 1 and w[1]%2 == 0 and
                (3*w[0]+1, 3*w[1]) == (2*y[0], 2*y[1]), "physical source at d=3")
        require(positive(difference(original, 1, w, 1)), "source cheaper than N")
        row.update(capture_if_d_equals=3, source_book=[1, 1, 1])
    return row


def main():
    old = {s for s in range(1024) if s%64 in Q49_S_MOD64}
    added = {"LEAN": set(), "PAPER": set()}
    rows = []
    for args in CASES:
        row = case(*args)
        s, stride = row["s"]
        residues = set(range(s, 1024, stride))
        require(not residues.intersection(old) and
                not residues.intersection(added["LEAN"] | added["PAPER"]), "disjoint cylinders")
        added[row["evidence"]].update(residues)
        rows.append(row)
    require((len(old), len(added["LEAN"]), len(added["PAPER"])) == (624, 12, 3), "residue counts")
    n, f = original_and_prefix(0, 1)
    v = edge(edge(f, 2), 2)
    require(all(positive(m) for m in (difference(v, 1, n, 1), difference(n, 5, v, 4),
                                      difference(f, 1, v, 1), difference(v, 5, n, 6))),
            "wide landing and half-source price")
    print(json.dumps(dict(status="PASS", modulus=1024, q49=len(old),
                          q50_lean=len(old|added["LEAN"]),
                          q50_including_paper=len(old|added["LEAN"]|added["PAPER"]),
                          wide_landing_affine=v, rows=rows), indent=2))


if __name__ == "__main__":
    main()
