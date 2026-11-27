"""Independent exact arithmetic for physical switch and reserve examples."""

ROWS = (
    (18,32,48703904041268437968961386239215,82408411687020299631788378142744),
    (10,128,21076350839635022295760718777647,247225235061060898895365134428232),
)
N_BASE = 1156359581173680383779426258047


def require(condition, detail):
    if not condition:
        raise RuntimeError(detail)


def valuation(x):
    require(x > 0, "Positive valuation argument")
    return (x & -x).bit_length()-1


def reserve(j, length, tail):
    return ((3**(length+2)-2**(length+tail+2))*(j+1)
            +2**(length+1)*(2**(tail+1)-1))


def physical(j, word):
    for expected in word:
        raw = 3*j+1
        a = valuation(raw)
        require(a == expected, "Exact valuation")
        j = raw >> a
    return j


def make_seed(row, schedule, following):
    u0, stride, j0, jd = row
    ell, cost, returns = 0, 0, 0
    for length, tail in schedule:
        for v in (*((1,)*length),2,tail):
            cost = 3*cost+2**ell
            ell += v
            returns += 1
    mod = 2**(ell+following+2)
    odds = 3**returns
    target = 2**ell*(2**(following+1)-1)
    residue = ((target-cost)*pow(odds,-1,mod)) % mod
    require((residue-j0) % 8 == 0 and jd % 16 == 8, "E1 affine congruence")
    t = ((residue-j0)//8)*pow(jd//8,-1,mod//8) % (mod//8)
    return N_BASE+2**100*(u0+stride*t), j0+jd*t


def replay(row, modes, final_length):
    n, j = make_seed(row,modes,final_length)
    require(j > n, "Wrong original seed")
    checkpoints = [j]
    for i,(length,tail) in enumerate(modes):
        require(valuation(j+1)==length+1, "Wrong exact entry length")
        h = modes[i+1][0] if i+1 < len(modes) else final_length
        z = physical(j,(*((1,)*length),2,tail))
        require(valuation(z+1)==h+1 and z>j, "Wrong next run")
        q, v = (j+1)//2**(length+1), (z+1)//2**(h+1)
        require(2**(h+tail+2)*v == 3**(length+2)*q+(2**(tail+1)-1), "Cofactor book")
        require(v>q and 64*(z+1)>=81*(j+1), "Expected growth")
        if i+1<len(modes):
            length2, tail2 = modes[i+1]
            if (length,tail)!=(length2,tail2):
                old = reserve(z,length,tail)
                expected = length+3 if length==length2 else min(length,length2)+1
                require(valuation(old)==expected, "Abandoned reserve")
        j=z
        checkpoints.append(j)
    return checkpoints


def main():
    checks=0
    for row in ROWS:
        for n in (1,2,5,17,51):
            for length in (2,3):
                modes=[(2,1)]+[(length,2)]*n
                points=replay(row,modes,length)
                require(valuation(reserve(points[1],length,2)) >= (length+4)*n,
                        "New reserve after the switch")
                checks+=1
        replay(row,[(2,1),(3,2)]*23,2)
        checks+=1
    print(f"PASS: {checks} physical schedules, abandoned reserve and recharge verified.")


if __name__ == "__main__":
    main()
