"""Independent exact check of the ancestor barrier and the ternary witness."""

import os
from pathlib import Path
import sys


SIBLINGS = Path(__file__).resolve().parents[2]
ROW = Path(os.environ.get("FRONT4B_ROW_PAPER", SIBLINGS /
                         "COLLATZ_A2_FRONT4B_Q81_ROW_REPRO_v1/paper"))
SWITCHED = Path(os.environ.get("FRONT4B_SWITCHED_PAPER", SIBLINGS /
                              "COLLATZ_FRONT4B_SWITCHED_REPRO_v1/paper"))
sys.path[0:0] = [str(ROW), str(SWITCHED)]
from verificar import HEADER, ORIGIN, PIVOT_BOOK, check_book, follow, valuations_book
from check_switch import ROWS, physical, replay, require, valuation


def verify_small_sources():
    words = ((2, 1, 1, 2, 2, 2), (2, 2, 1, 1, 2, 2, 2))
    for row, reverse in zip(ROWS, words, strict=True):
        r, stride, j, dj = row
        n, dn = ORIGIN.evaluate(r), ORIGIN.step*stride
        for a in reverse:
            require(j>n and dj>dn and (2**a*j-1)%3 == (2**a*dj)%3 == 0,
                    "Invalid affine predecessor")
            candidates = [e for e in (1,2) if (2**e*j-1)%3 == 0]
            require(candidates == [a], "Wrong restricted inverse")
            j,dj = (2**a*j-1)//3, (2**a*dj)//3
        require(j>n and dj>dn and j%3==dj%3==0, "Wrong terminal obstruction")
    print("PASS: restricted inverse chains of lengths 6 and 7 are exhausted.")


def verify_chatgpt_example():
    u = 1599250
    n = ORIGIN.restrict(u, 0)
    j = follow(n, HEADER)
    check_book(n,j,PIVOT_BOOK)
    modes = ((2,1),(2,2),(2,1),(2,2))
    word = tuple(a for length,b in modes for a in (1,)*length+(2,b))
    final = follow(j,word)
    global_book = (78,120,126554957119839446069705296738405296121)
    require(valuations_book(HEADER+word)==global_book, "Reported absolute book")
    check_book(n,final,global_book)
    x=j.base
    cofactors=[(x+1)//8]
    for length,b in modes:
        x=physical(x,(1,)*length+(2,b))
        cofactors.append((x+1)//2**valuation(x+1))
    require(cofactors[1]%9 in (3,6) and cofactors[2]%3!=0 and
            cofactors[2]>cofactors[1] and cofactors[4]<cofactors[3],
            "Expected early growth and last drop")
    print("PASS: reported example drops the ternary label while growing at the second switch.")
    print("The fourth cofactor decreases because the final run length is three.")


def verify_all_growth():
    modes=((2,1),(2,2),(2,1),(2,2))
    for row in ROWS:
        points=replay(row,modes,2)
        q=[(x+1)//8 for x in points]
        require(all(a<b for a,b in zip(q,q[1:])), "Cofactor not strictly growing")
        for i,b in enumerate((1,2,1,2)):
            if b == 1:
                require(q[i+1]%9 in (3,6) and (32*(q[i+1]//3))%27==1, "b=1 label")
            else:
                require(q[i+1]%3!=0 and (64*q[i+1])%81==7, "b=2 label")
    print("PASS: all four transitions grow in both original E1 bands with alternating labels.")



def verify_separated_repeat():
    t = 175094053
    u = 18 + 32*t
    n = ORIGIN.restrict(u, 0)
    header = HEADER + (1, 1, 2)
    j = follow(n, header)
    check_book(n, j, valuations_book(header))
    tails = (1, 2, 1, 1, 2)
    points = [j.base]
    word = ()
    for b in tails:
        episode = (1, 1, 2, b)
        word += episode
        points.append(physical(points[-1], episode))
    require(all(valuation(x+1) == 3 for x in points), "Run length changed")
    q = [(x+1)//8 for x in points]
    require(all(a < b for a, b in zip(q, q[1:])), "Cofactor did not increase")
    require(tails[:2] == tails[3:], "Separated repeated word")
    require(valuation(q[3]-q[0]) == 13 and 13 >= 5+6+1, "Repeat separation")
    absolute = (85, 129, 278494448288432869329185530758089506552883)
    require(valuations_book(header+word) == absolute, "Collision witness book")
    check_book(n, follow(j, word), absolute)
    require(81**7 < 2**10 * 32**7, "Complexity exponent")
    print("PASS: separated repeat and absolute history for the constant-length subchannel.")


if __name__=="__main__":
    verify_small_sources()
    verify_chatgpt_example()
    verify_all_growth()
    verify_separated_repeat()
