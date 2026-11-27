"""Directed exact reconstruction of repeated cofactor-growth examples."""

from check_realization import ROWS, SEED, step


def require(condition, detail):
    if not condition:
        raise RuntimeError(detail)


def witness(row, b, count):
    residue, modulus, _, j0, jstride = row
    a0, rem = divmod(j0+1, 8)
    slope, rest = divmod(jstride, 8)
    require(rem == rest == 0 and slope % 2 == 1, "Wrong affine row")
    shift, correction = 2**(b+4), 2**(b+1)-1
    cost, power = 0, 1
    for _ in range(count):
        cost = 81*cost+correction*power
        power *= shift
    scale = 81**count
    parameter = ((power-cost-scale*a0)*pow(scale*slope, -1, 2*power)) % (2*power)
    origin = SEED+2**100*(residue+modulus*parameter)
    J = j0+jstride*parameter
    require(J > origin, "Entry is below the original seed")
    initial_reserve = (81-shift)*((J+1)//8)+correction
    require(initial_reserve % power == 0 and initial_reserve >= power, "Fixed-seed reserve")
    for _ in range(count):
        q = (J+1)//8
        require(J == 8*q-1 and q % 2 == 1, "Current run length is not two")
        endpoint = J
        for expected in (1,1,2,b):
            endpoint, valuation = step(endpoint)
            require(valuation == expected and endpoint >= J, "Physical trajectory failed")
        v = (endpoint+1)//8
        require(endpoint == 8*v-1 and v % 2 == 1 and v > q, "Expected cofactor growth")
        require(shift*v == 81*q+correction, "Cofactor book failed")
        J = endpoint


def main():
    for row in ROWS:
        for b in (1,2):
            for count in (1,2,9,51):
                witness(row,b,count)
    print("PASS: 16 directed prefixes, 252 prescribed weak-pair transitions.")


if __name__ == "__main__":
    main()
