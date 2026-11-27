"""Verify the contracted pair and the unresolved double-single frontier in all five classes."""

import os
from pathlib import Path
import sys


siblings = Path(__file__).resolve().parents[2]
row = Path(os.environ.get('FRONT4B_ROW_PAPER', siblings /
           'COLLATZ_A2_FRONT4B_Q81_ROW_REPRO_v1/paper'))
sys.path.insert(0,str(row))
from verificar import HEADER, ORIGIN, check_book, follow, require, valuations_book


TWO_BLOCKS = (1,1,1,2,2,1,1,1,2,1)
CYLINDERS = (
    (3,0,18360,65536), (3,1,247736,262144), (3,2,116664,1048576),
    (5,0,59168,65536), (5,1,223008,262144),
)


def phase(entry, word):
    h,s,b = valuations_book(word)
    modulus = 2**(s+1)
    target = (2**s-b)*pow(3**h,-1,modulus)%modulus
    require((target-entry.base)%4 == 0 and entry.step%8 == 4, 'Exact common binary phase')
    return ((target-entry.base)//4)*pow(entry.step//4,-1,modulus//4)%(modulus//4)


def check_all():
    for band,r,t0,period in CYLINDERS:
        u0,stride,tail = (18,32,(1,1,2)) if band==3 else (10,128,(1,1,2,2))
        header = HEADER+tail+TWO_BLOCKS+(4,)+(2,)*r
        n = ORIGIN.restrict(u0+stride*t0,stride*period)
        start = follow(n,header)
        require(start.base%4 == 3 and start.step%8 == 4,'Advertised short-exit class')
        for renewal, contracts in (((1,2,1,2,2),True),((1,2,1,2),False)):
            k = phase(start,renewal+(1,))
            seed = n.restrict(k,0)
            initial = follow(seed,header)
            midway = follow(initial,(1,2))
            last = follow(initial,renewal)
            follow(last,(1,))
            require(seed.base<=last.base and initial.base<3*seed.base and initial.base<midway.base,'Same seed and actual initial expansion')
            if contracts:
                require(256*last.base==243*initial.base+319 and last.base<initial.base,'Strict drop for the contracted pair')
            else:
                require(64*last.base==81*initial.base+85 and initial.base<last.base,'Unpaid double-single height frontier')
            book = valuations_book(header+renewal)
            check_book(seed,last,book)
            print(f'PASS row={band}, r={r}, t={t0+period*k}, {renewal}, clocks={book[:2]}.')



def check_weak_barrier():
    cases = (
        (3,2,6720440248,34053727500513038689085936886325932487003),
        (5,1,2021353248,35188240419174230615669952876520148332891),
    )
    for band,r,t,cost in cases:
        u0,stride,tail = (18,32,(1,1,2)) if band==3 else (10,128,(1,1,2,2))
        seed = ORIGIN.restrict(u0+stride*t,0)
        word = HEADER+tail+TWO_BLOCKS+(4,)+(2,)*r+(1,)
        initial = follow(seed,word)
        after = follow(initial,(1,1,2,2))
        final = follow(after,(1,1,1,1,2,1))
        n,j,z = seed.base,initial.base,after.base
        require(2*n+1<j<z<final.base,'Both weak blocks stay above the A2 window')
        require((j+1)%16==8 and (z+1)%64==32,'Exact reserve lengths')
        q,v = (j+1)//8,(z+1)//32
        require(v<q and q%512==41 and v%81==13 and 256*v==81*q+7,'Lower cofactor at larger height')
        first = valuations_book(word+(1,1,2,2))
        second = valuations_book(word+(1,1,2,2,1,1,1,1,2,1))
        require(first==(83,130,cost) and second==(89,137,729*cost+2**130*697),'Original books')
        check_book(seed,after,first)
        check_book(seed,final,second)
        print(f'PASS row={band}, two further weak blocks stay outside the A2 height window despite a cofactor drop.')


if __name__ == '__main__':
    check_all()
    check_weak_barrier()
