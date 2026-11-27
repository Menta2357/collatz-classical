"""Check the exact costs and directed physically realizable phases independently."""

N0 = 1156359581173680383779426258047
V0 = 1392102202856011511751362094175
V_STEP = 4 * 3**62

GUARDS = ((18, 32, (1, 1, 2)), (10, 128, (1, 1, 2, 2)))
TAILS = (
    ((2, 4, 4), (2, 2, 1, 2, 1), 1697, 2048),
    ((2, 5, 2), (2, 2, 1, 1, 1), 481, 1024),
    ((2, 6), (2, 2, 1, 1), 97, 512),
)


def require(condition, detail):
    if not condition:
        raise RuntimeError(detail)


def evolve(x):
    raw = 3*x+1
    valuation = (raw & -raw).bit_length()-1
    return raw >> valuation, valuation


def terminal(x, valuations):
    for expectation in valuations:
        x, actual = evolve(x)
        require(expectation == actual, "Wrong physical valuation")
    return x


def book(word):
    exponent, cost = 0, 0
    for valuation in word:
        cost = 3*cost+2**exponent
        exponent += valuation
    return len(word), exponent, cost


def check_tail(original, source):
    h, s, cost = book(original)
    hf, sf, cf = book(source)
    require(hf == h+2 and sf == s-2 and cf == 8*3**h+cost+2**(s-2),
            "The two heads don't satisfy W=4Z+1")
    for gamma in (1, 3, 9):
        h, s, cost = book((*original, gamma))
        hf, sf, cf = book((*source, gamma+2))
        require(hf == h+2 and s == sf and cf-cost == 8*3**h,
                "The terminal valuations do not preserve both books")


def check_phase(guard, tail, length):
    residue, modulus, entry = guard
    orig, auxiliary, phase, base = tail
    entry0 = terminal(V0+V_STEP*residue, entry)
    entry1 = terminal(V0+V_STEP*(residue+modulus), entry)
    slope = entry1-entry0
    require(slope % 16 == 8, "Entry needs a slope with dyadic valuation three")
    q = ((phase+1)//2)*pow(3, -(length-2), base//2) % (base//2)
    mod = 2**(length+1)*(base//2)
    right = 2**(length+1)*q-1
    require((right-entry0) % 8 == 0, "Inconsistent CRT phase")
    param = ((right-entry0)//8)*pow(slope//8, -1, mod//8) % (mod//8)
    for t in (param, param+mod//8):
        u = residue+modulus*t
        J = entry0+slope*t
        N = N0+2**100*u
        w = (J-3)//4
        require(0 < w < N and w % 2 == 1, "Source is outside the payment window")
        R = terminal(J, (1,)*length)
        U = terminal(w, (1,)*(length-2))
        require(R == 9*U+8, "One-run endpoint shift")
        Z, W = terminal(R, orig), terminal(U, auxiliary)
        end, gamma = evolve(Z)
        other, alpha = evolve(W)
        require(W == 4*Z+1 and end == other and alpha == gamma+2,
                "Physical capture or terminal valuation failed")


def main():
    for original, source, _, _ in TAILS:
        check_tail(original, source)
    for guard in GUARDS:
        for tail in TAILS:
            for length in (2, 3, 11, 80):
                check_phase(guard, tail, length)
    print("PASS: three exact cost matches and 48 directed CRT physical captures.")


if __name__ == "__main__":
    main()
