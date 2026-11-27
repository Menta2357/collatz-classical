"""Exclude smaller odd sources at depth at most ten for four fixed terminal rows."""

from itertools import count

from verificar import FIRST, ORIGIN, PIVOT, RESIDUAL, follow, require


MAX_RETURNS = 10


def valuation_cap(seed, terminal, depth):
    three = 3**depth
    two = 2**depth
    scaled_lower = two * (terminal.base + 1) - three
    require(scaled_lower > 0 and terminal.step > 0, "positive lower bound")
    for total in count(depth):
        scale = 2**total
        if scale * scaled_lower >= three * two * seed.base and scale * terminal.step >= three * seed.step:
            return total - 1


def bounded_inverse_count(terminal, depth, valuation_cap):
    stack = [(terminal.base, terminal.step, 0, 0)]
    complete = 0
    while stack:
        base, step, used, spent = stack.pop()
        if used == depth:
            complete += 1
            continue
        largest = valuation_cap - spent - (depth - used - 1)
        for valuation in range(1, largest + 1):
            lifted_base = 2**valuation * base - 1
            lifted_step = 2**valuation * step
            if lifted_base % 3 == 0 and lifted_step % 3 == 0:
                stack.append((lifted_base // 3, lifted_step // 3, used + 1, spent + valuation))
    return complete


def main():
    for c, e, residue, modulus in RESIDUAL:
        if c == 7:
            continue
        seed = ORIGIN.restrict(residue, modulus)
        pivot = PIVOT.restrict(residue, modulus)
        word = FIRST + (2,) * ((c - 3) // 2) + (1, e)
        terminal = follow(pivot, word)
        require(terminal.step % 3**MAX_RETURNS == 0, "fixed ternary residues")
        caps = []
        for depth in range(1, MAX_RETURNS + 1):
            cap = valuation_cap(seed, terminal, depth)
            closed = bounded_inverse_count(terminal, depth, cap)
            require(closed == 0, (c, e, depth, cap, closed))
            caps.append(cap)
        print(f"c={c} e={e} u={residue} mod {modulus}, caps {caps}, all inverse counts zero")
    print("PASS: no w<N at the four first residual terminals in 1..10 odd returns")


if __name__ == "__main__":
    main()
