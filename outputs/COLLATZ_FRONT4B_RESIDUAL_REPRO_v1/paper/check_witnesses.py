"""Replay two same-seed witnesses and their exact Collatz histories."""

from fractions import Fraction
import os
from pathlib import Path
import sys

siblings = Path(__file__).resolve().parents[2]
row = Path(os.environ.get('FRONT4B_ROW_PAPER', siblings /
           'COLLATZ_A2_FRONT4B_Q81_ROW_REPRO_v1/paper'))
sys.path.insert(0, str(row))
from verificar import HEADER, ORIGIN, check_book, follow, require, valuations_book


def episode(length, tail):
    return (1,)*length+(2, tail)


def physical_book(seed, prefix, suffix):
    word = prefix+suffix
    endpoint = follow(seed, word)
    result = valuations_book(word)
    check_book(seed, endpoint, result)
    return endpoint.base, result


def valuation(n):
    require(n > 0, 'Positive valuation input')
    return (n & -n).bit_length()-1


def rank_witness():
    seed = ORIGIN.restrict(74930, 0)
    n = seed.base
    before = HEADER+(1, 1, 2)
    after = before+episode(2, 1)
    j, (j0, s0, b0) = physical_book(seed, before, ())
    z, (j1, s1, b1) = physical_book(seed, after, ())
    terminal, _ = physical_book(seed, after, episode(2, 2))
    require(all(valuation(x+1) == 3 for x in (j,z,terminal)), 'Weak readmissions')
    require((j+1)//8 < (z+1)//8, 'Cofactor growth')
    delta0 = Fraction(2**s0*(j-n), 3**j0)
    delta1 = Fraction(2**s1*(z-n), 3**j1)
    require(Fraction(n,2) < delta0 < delta1 < n, 'Historical debt bucket')
    require((valuation(17*j+73), valuation(17*z+73)) == (5,10), 'Sharp reserve witness')
    require((j0,s0,j1,s1) == (65,102,69,107), 'Original clocks')
    require(b1 == 81*b0+73*2**s0, 'Original additive exact')
    print('PASS: cofactor and historical debt grow while the proposed reserve-minus-debt rank rises by five.')


def offset_witness():
    t = 1023237697126061829
    seed = ORIGIN.restrict(18+32*t,0)
    entry = HEADER+(1, 1, 2)
    first = episode(2,1)+episode(3,2)
    second = episode(2,2)+episode(3,1)
    common = episode(2,2)+episode(4,1)+episode(3,1)
    j, _ = physical_book(seed, entry, ())
    u, _ = physical_book(seed, entry, first+common)
    v, _ = physical_book(seed, entry+first+common, second+common)
    require((valuations_book(first), valuations_book(second)) == ((9,12,25003),(9,12,32267)), 'Equal clocks with distinct addends')
    require(valuations_book(common)[1] == 19, 'Shared division clock')
    gap = u-j
    scaled = 3**9*gap+7264
    require(1 < j < u < v and (gap%2**32, valuation(scaled)) == (3414720480,36), 'Offset divisibility and minimum')
    require(3**valuations_book(common)[0]*scaled == 2**31*(v-u), 'Offset difference')
    print('PASS: separated unequal prefixes with a common suffix preserve both exact books and the required nonzero offset.')



def denominator_witness():
    t = 213485686413061
    seed = ORIGIN.restrict(18+32*t,0)
    header = HEADER+(1,1,2)
    j, _ = physical_book(seed,header,())
    q = (j+1)//2**valuation(j+1)
    word = ()
    modes = []
    x = j
    for _ in range(8):
        length = valuation(x+1)-1
        require(length in (2,3), 'Permitted source mode length')
        for _ in range(length):
            raw = 3*x+1
            require(valuation(raw) == 1, 'Exact one')
            x = raw//2
        raw = 3*x+1
        require(valuation(raw) == 2, 'Exact first two')
        x = raw//4
        raw = 3*x+1
        b = valuation(raw)
        require(b in (1,2), 'Exact weak tail')
        x = raw//2**b
        qnew = (x+1)//2**valuation(x+1)
        require(q < qnew, 'Cofactor increases')
        q = qnew
        word += episode(length,b)
        modes.append((length,b))
    require(valuation(x+1) == 3, 'Exact following length two')
    require(valuations_book(word) == (36,48,254278758973463785), 'Denominator witness local book')
    require(physical_book(seed,header,word) == (x,(101,150,11988640013151763152434226899016445278060996320755)),
            'Denominator witness absolute book')
    centre = Fraction(254278758973463785,3**36-2**48)
    require(centre == Fraction(4623250163153887,2723875642187063), 'Reduced centre')
    require(centre.denominator > 17147305, 'Exceeds local least common multiple')
    at_entry = centre.denominator*j+centre.numerator
    at_exit = centre.denominator*x+centre.numerator
    require(2**48*at_exit == 3**36*at_entry, 'Homogeneous centre book')
    require((valuation(at_entry),valuation(at_exit)) == (53,5), 'Exact centre reserves')
    print(f'PASS: reduced-centre denominator exceeds the local least common multiple at {modes}.')


if __name__ == '__main__':
    rank_witness()
    offset_witness()
    denominator_witness()
