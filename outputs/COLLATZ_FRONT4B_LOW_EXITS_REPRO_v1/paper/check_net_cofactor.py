"""Replay two-block net drops after an initial cofactor increase."""

import os
from pathlib import Path
import sys


siblings = Path(__file__).resolve().parents[2]
row_dir = Path(os.environ.get('FRONT4B_ROW_PAPER',
    siblings/'COLLATZ_A2_FRONT4B_Q81_ROW_REPRO_v1/paper'))
switch_dir = Path(os.environ.get('FRONT4B_SWITCHED_PAPER',
    siblings/'COLLATZ_FRONT4B_SWITCHED_REPRO_v1/paper'))
sys.path[0:0] = [str(row_dir),str(switch_dir)]
from verificar import HEADER, ORIGIN, check_book, follow, require, valuations_book
from check_switch import ROWS, make_seed, physical, valuation


def check():
    for row, extra in zip(ROWS, ((1,1,2),(1,1,2,2)), strict=True):
        for first, second, expected_cost in ((1,2,8249),(2,1,10585)):
            modes = ((2,first),(2,second))
            n,j = make_seed(row,modes,4)
            residue,stride,*_ = row
            original_parameter = (n-ORIGIN.base)//ORIGIN.step
            require((original_parameter-residue)%stride == 0,'Original E1 row')
            source = ORIGIN.restrict(original_parameter,0)
            header = HEADER+extra
            initial = follow(source,header)
            require(initial.base == j,'Physical entry from same N')
            local = (1,1,2,first,1,1,2,second)
            x = physical(j,local[:4])
            z = physical(x,local[4:])
            require(tuple(valuation(state+1) for state in (j,x,z)) == (3,3,5),'Exact run lengths')
            q,p,v = (j+1)//8, (x+1)//8, (z+1)//32
            require(j<x<z and n<j and v<q<p,'Net decrease after growth')
            local_book = valuations_book(local)
            require(local_book==(8,11,expected_cost),'Exact local book')
            absolute = valuations_book(header+local)
            check_book(source,follow(source,header+local),absolute)
            A,D = 3**8,2**11
            L,H = 2,4
            require(A*2**(L+1)*q+expected_cost+D == D*2**(H+1)*v+A,'Cofactor identity')
            require(A*2**(L+1)*q+expected_cost+D < D*2**(H+1)*q+A,'Net price')
            print(f'PASS: band={residue}, tails={first,second}, t={(original_parameter-residue)//stride}, original clocks={absolute[:2]}.')



def check_joint_crt():
    n = 41507452190016111395906657801144401694299642121343
    u,remainder = divmod(n-ORIGIN.base,ORIGIN.step)
    require(remainder == 0 and u%32 == 18,'Original c3 class')
    seed = ORIGIN.restrict(u,0)
    header = HEADER+(1,1,2)
    j = follow(seed,header).base
    first,second = (1,1,2,1),(1,1,1,2,2)
    x,z = physical(j,first),physical(physical(j,first),second)
    require(tuple(valuation(k+1) for k in (j,x,z))==(3,4,3),'Real changing lengths')
    q,p,v = (j+1)//8,(x+1)//16,(z+1)//8
    require(q<p<v and n<j<x<z,'Strict growth throughout checkpoints')
    require(64*p == 81*q+3 and 64*v == 243*p+7,'Both cofactor books')
    require(p%10368==6051 and p%81==57 and p%128==35,'Combined past and next congruence')
    ceiling = (81*(17*j+73)-56*32)//(17*512)
    require(ceiling == p and ceiling >= 6051,'Joint cap is tight but permits growth')
    absolute = valuations_book(header+first+second)
    require(absolute == (74,114,1529856365010152479316230836478159657),'Exact absolute ledger')
    check_book(seed,follow(seed,header+first+second),absolute)
    print('PASS: joint CRT and a tight upper envelope permit two real growing weak episodes.')


if __name__ == '__main__':
    check()
    check_joint_crt()
