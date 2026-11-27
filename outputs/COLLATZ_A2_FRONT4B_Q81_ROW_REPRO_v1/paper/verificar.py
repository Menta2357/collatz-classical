"""Exact affine and residue certificates for the Front4b row u = 2 (mod 8)."""

from dataclasses import dataclass


@dataclass(frozen=True)
class Affine:
    base: int
    step: int

    def restrict(self, residue, modulus):
        return Affine(self.base + self.step * residue, self.step * modulus)

    def next_numerator(self):
        return Affine(3 * self.base + 1, 3 * self.step)

    def evaluate(self, parameter):
        return self.base + self.step * parameter


ORIGIN = Affine(1156359581173680383779426258047, 2**100)
PIVOT = Affine(1392102202856011511751362094175, 4 * 3**62)
PIVOT_BOOK = (62, 98, 2417122598839266567112547605177)
HEADER = (
    1, 1, 1, 1, 1, 1, 2, 2, 1, 1, 2, 3, 3, 1, 2, 1, 1, 1, 1, 2,
    1, 2, 1, 1, 5, 1, 2, 2, 1, 1, 1, 2, 2, 1, 1, 4, 1, 2, 1, 1,
    2, 2, 1, 1, 1, 1, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 1, 1, 6, 2, 2,
)
FIRST = (1, 1, 2)
RESIDUES = {
    3: (2, 16), 4: (26, 32), 5: (10, 64), 6: (106, 128),
    7: (170, 256), 8: (298, 512), 9: (42, 512),
}
RESIDUAL = (
    (3, 1, 18, 32), (3, 2, 34, 64),
    (5, 1, 10, 128), (5, 2, 202, 256),
    (7, 1, 170, 512), (7, 2, 938, 1024),
)
DESCENTS = (
    (26, 32, FIRST, 3),
    (106, 128, FIRST + (2,), 3),
    (298, 512, FIRST + (2, 2), 3),
    (42, 512, FIRST + (2, 2, 2), None),
    (2, 128, FIRST + (1,), 4),
    (74, 256, FIRST + (2, 1), 3),
    (426, 1024, FIRST + (2, 2, 1), 3),
)
CAPTURE = (66, 128)


def require(condition, label):
    if not condition:
        raise ArithmeticError(label)


def valuations_book(word):
    return len(word), sum(word), sum(
        3 ** (len(word) - index - 1) * 2 ** sum(word[:index])
        for index in range(len(word))
    )


def exact_edge(state, valuation):
    numerator = state.next_numerator()
    divisor = 2**valuation
    require(numerator.base % (2 * divisor) == divisor, (state, valuation))
    require(numerator.step % (2 * divisor) == 0, (state, valuation, "slope"))
    return Affine(numerator.base // divisor, numerator.step // divisor)


def follow(state, word):
    for valuation in word:
        state = exact_edge(state, valuation)
    return state


def check_book(start, end, parameters):
    returns, divisions, additive = parameters
    require(2**divisions * end.base == 3**returns * start.base + additive, "book base")
    require(2**divisions * end.step == 3**returns * start.step, "book slope")


def check_ranges():
    period = 1024
    difference_step = 9 * PIVOT.step * period // 4
    require(difference_step % period == 0, "period of c and e")
    covered = 0
    for u in range(2, 1024, 8):  # One period of residues, with no search over orbits.
        v = PIVOT.evaluate(u)
        difference = (9 * v + 1) // 4
        c = min(9, (difference & -difference).bit_length() - 1)
        matching = [key for key, (r, m) in RESIDUES.items() if u % m == r]
        require(matching == [c], (u, c, matching))
        if c in (3, 5, 7):
            scaled = (3 ** ((c - 1) // 2) * difference) >> c
            require(scaled % 2 == 1, (u, c, scaled))
            numerator = 9 * scaled + 7
            e = min(3, (numerator & -numerator).bit_length() - 1)
            active = [(rc, re) for rc, re, r, m in RESIDUAL if u % m == r]
            require(active == ([(c, e)] if e <= 2 else []), (u, c, e, active))
        paid = sum(u % m == r for r, m, _, _ in DESCENTS) + (u % CAPTURE[1] == CAPTURE[0])
        pending = sum(u % m == r for _, _, r, m in RESIDUAL)
        require(paid + pending == 1, (u, paid, pending))
        covered += paid
    require(covered == 65, "covered residue count")


def check_descent(residue, modulus, word, last_minimum=None):
    seed = ORIGIN.restrict(residue, modulus)
    pivot = PIVOT.restrict(residue, modulus)
    state = follow(pivot, word)
    check_book(pivot, state, valuations_book(word))
    if last_minimum is None:
        numerator, scale = state, 1
    else:
        numerator, scale = state.next_numerator(), 2**last_minimum
        require(numerator.base % scale == 0 and numerator.step % scale == 0, "last valuation")
    require(numerator.base < scale * seed.base, (residue, word, "descent base"))
    require(numerator.step <= scale * seed.step, (residue, word, "descent slope"))
    lower_word = word if last_minimum is None else word + (last_minimum,)
    print(f"descent u={residue} mod {modulus}, local book at lower valuation={valuations_book(lower_word)}")


def check_capture():
    seed = ORIGIN.restrict(*CAPTURE)
    pivot = PIVOT.restrict(*CAPTURE)
    word = FIRST + (1, 3)
    terminal = follow(pivot, word)
    check_book(pivot, terminal, (5, 8, 251))
    require((2 * terminal.base - 1) % 3 == 0 and terminal.step % 3 == 0, "integer source")
    source = Affine((2 * terminal.base - 1) // 3, (2 * terminal.step) // 3)
    require(source.base > 0 and source.base < seed.base and 0 < source.step <= seed.step, "strict source")
    require(source.base % 2 == 1 and source.step % 2 == 0, "odd source")
    require(exact_edge(source, 1) == terminal, "physical meeting")
    check_book(source, terminal, (1, 1, 1))
    historical_book = valuations_book(HEADER + word)
    check_book(seed, terminal, historical_book)
    require(terminal.base > seed.base and terminal.step >= seed.step, "meeting above origin")
    print(f"capture u=66 mod 128, original={historical_book}, auxiliary=(1, 1, 1)")


def check_c7_crossing():
    seed = ORIGIN.restrict(170, 256)
    pivot = PIVOT.restrict(170, 256)
    word = FIRST + (2, 2)
    state = pivot
    for valuation in word[:-1]:
        state = exact_edge(state, valuation)
        require(state.base > pivot.base and state.step >= pivot.step, "earlier state above V")
    terminal = exact_edge(state, word[-1])
    require(seed.base < terminal.base < pivot.base, "strict initial crossing")
    require(seed.step <= terminal.step <= pivot.step, "strict crossing slope")
    local_book = valuations_book(word)
    historical_book = valuations_book(HEADER + word)
    check_book(pivot, terminal, local_book)
    check_book(seed, terminal, historical_book)
    print(f"c7 first strict crossing u=170 mod 256, original={historical_book}, local={local_book}")


def check_weak_compressed_rupture():
    for c in (3, 5):
        residue, modulus = RESIDUES[c]
        pivot = PIVOT.restrict(residue, modulus)
        g = follow(pivot, (1, 1))
        a = Affine((g.base - 1) // 2**c, g.step // 2**c)
        p = (c + 1) // 2
        h = follow(pivot, FIRST + (2,) * ((c - 3) // 2) + (1,))
        require(h == Affine(3**p * a.base + 2, 3**p * a.step), (c, "compression entry"))
        require(a.step == 2 * 3**64, (c, "compression cofactor slope"))
        for m in (2, 5, 80):
            q = 3 * pow(3, -(m + 1), 4) % 4
            b = ((2**m * q - 3 ** (p - 1) * a.base - 1) // 2)
            mmod = 2 ** (m + 1)
            t = b * pow(3 ** (p - 1) * a.step // 2, -1, mmod) % mmod
            entry = h.restrict(t, mmod)
            word = (1,) * (m - 1) + (2,)
            terminal = follow(entry, word)
            require(terminal.base > entry.base and terminal.step >= entry.step, (c, m, "weak rupture"))
            check_book(entry, terminal, (m, m + 1, 3**m - 2**m))
    print("PASS: six directed symbolic weak-rupture classes at m=2,5,80")


def main():
    states = [ORIGIN]
    for valuation in HEADER:
        states.append(exact_edge(states[-1], valuation))
    require(states[-1] == PIVOT and valuations_book(HEADER) == PIVOT_BOOK, "pivot")
    require(all(x.base > ORIGIN.base and x.step >= ORIGIN.step for x in states[1:]), "header above N")
    require(4 * PIVOT.base < 5 * ORIGIN.base and 4 * PIVOT.step <= 5 * ORIGIN.step, "pivot window")
    follow(PIVOT.restrict(2, 8), FIRST)
    check_ranges()
    for case in DESCENTS:
        check_descent(*case)
    check_capture()
    check_c7_crossing()
    check_weak_compressed_rupture()
    c3_seed, c3_pivot = ORIGIN.restrict(2, 16), PIVOT.restrict(2, 16)
    c3_terminal = follow(c3_pivot, FIRST)
    require(c3_terminal.base > c3_seed.base and c3_terminal.step >= c3_seed.step, "long ones start")
    require((c3_terminal.base + 1) % 4 == 0 and c3_terminal.step % 8 == 4, "long ones CRT")
    print("PASS: six exact complementary parameter classes and no uniform descent horizon")


if __name__ == "__main__":
    main()
