"""Realize one whole late exit and verify its two affine margins."""

import json

from verify_frontier import CASES, FOURTH_STEP, checker


def guarded_fold(s, period, r):
    original = checker.seed(428769801+2**31*(12+64*s), 2**37*period)
    states, word, book = checker.trace(original, 60+r)
    assert word[59:] == [6]+[1]*r
    q, q_step = states[-1]
    assert (3*q+1) % 32 == (3*q_step) % 32 == 0
    assert (q-5) % 32 == 16 and q_step % 32 == 0
    source = ((q-5)//16, q_step//16)
    assert source[0] > 0 and checker.below(source, original)
    assert (3*source[0]+1)*16 == 3*q+1 and (3*source[1])*16 == 3*q_step
    in_lean_cut = any(s % mod == offset for offset, mod, *_ in CASES+FOURTH_STEP)
    return {"s_offset":s,"s_period":period,"r":r,"valuation_floor":5,
            "already_in_lean_cut":in_lean_cut,"source":source,
            "source_book":[1,"b-4",1],"original_book":[61+r,f"{book[1]}+b",3*book[2]+2**book[1]]}


def main():
    r, b = 5, 7
    f0 = 16161180670369550395566597319
    f1 = 84782316550432407028588866402
    residue = (1+2**(b-1))*pow(3**(r+1), -1, 2**b) % 2**b
    period = 2**(r+b)
    target = 2**(r+1)*residue-f0-1
    assert target % 2 == 0 and f1 % 4 == 2
    s = (target//2*pow(f1//2, -1, period)) % period
    assert s % 4 == 0 and all(s%m!=a for a,m,*_ in CASES+FOURTH_STEP)
    seed = checker.seed(428769801+2**31*(12+64*s), 2**37*period)
    history, word, book = checker.trace(seed, 61+r)
    assert word[59:] == [6]+[1]*r+[b]
    assert all(checker.below(seed,y) for y in history[1:-1])
    assert checker.below(history[-1], seed)
    expected = (61+r, 94+r+b,
                3**(r+1)*253163701604367108480427299121 +
                2**94*(3**(r+1)-2**(r+1)))
    assert expected == book
    assert b >= (2*r+2)//3+3
    print(json.dumps({"status":"PASS","s_offset":s,"s_period":period,
                      "r":r,"b":b,"original_book":book,
                      "original_seed":seed,"terminal":history[-1],
                      "guarded_fold":[guarded_fold(a,m,k) for a,m,k in ((40,64,2),(100,128,3),(12,256,4))]}, indent=2))


if __name__ == "__main__":
    main()
