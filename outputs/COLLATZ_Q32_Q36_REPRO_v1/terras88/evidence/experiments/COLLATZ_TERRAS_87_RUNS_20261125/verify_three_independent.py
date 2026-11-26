#!/usr/bin/env python3
"""Independent global-source check of two/three-rise capacities.

Only H in HEIGHTS is considered.  X=x+1 is the original global source
coordinate throughout: no modular search in the odd cofactor u is used.

If the exact first two odd-run lengths a,c satisfy a+c>H, then
  3**a * X == 2**a * (1-2**b) mod 2**(b+H+1),
where b is the exact intervening even-run length.  Since X<2**H and
the modulus is larger, each (a,b) supplies at most one source.  Every
retained source is then checked by direct exact physical block steps.

For a+c<=H, D3 < H+alpha*(a+c) <= (1+alpha)*H analytically.
The script checks the complementary case and the global D2<=3H/2.
It uses only integers, not floating-point logarithms or search records.
"""

import json

HEIGHTS = (66, 67, 92, 107, 146, 170, 231, 256)


def v2(n):
    assert n > 0
    return (n & -n).bit_length() - 1


def odd_even_block(x):
    """Exact maximal odd run followed by its complete even run."""
    assert x > 0 and x % 2 == 1
    a = v2(x + 1)
    peak = 3**a * ((x + 1) >> a) - 1
    assert peak > 0 and peak % 2 == 0
    b = v2(peak)
    y = peak >> b
    assert y > 0 and y % 2 == 1
    return a, b, y


def verify(H):
    cutoff = 1 << H
    three_H = 3**H
    # 3**H is never a power of two: these are exactly the positive
    # b with 2**b < 3**H, i.e. b < alpha*H, with a strict inequality.
    bmax = three_H.bit_length() - 1
    assert (1 << bmax) < three_H < (1 << (bmax + 1))
    widest_modulus = 1 << (bmax + H + 1)
    candidates = []
    seen = set()
    pair_count = 0
    for a in range(1, H):  # X<2**H makes a<H strict.
        power = 3**a
        inverse = pow(power, -1, widest_modulus)
        assert (power * inverse) % widest_modulus == 1
        for b in range(1, bmax + 1):
            pair_count += 1
            assert (1 << b) < three_H
            modulus = 1 << (b + H + 1)
            # Solve in the original X, independently of cofactor lifts.
            X = (inverse * (1 << a) * (1 - (1 << b))) % modulus
            if not (2 <= X < cutoff):
                continue
            assert X not in seen
            seen.add(X)
            assert v2(X) == a
            assert (power * X - (1 << a) * (1 - (1 << b))) % modulus == 0
            aa, bb, y = odd_even_block(X - 1)
            assert (aa, bb) == (a, b)
            c, d, z = odd_even_block(y)
            assert c >= H + 1 - a
            third = v2(z + 1)
            D2, D3 = a + c, a + c + third
            assert D2 > H
            assert 2 * D2 <= 3 * H, (H, X, a, b, c, D2)
            # D3 <= (1+alpha)*H is equivalent to this exact comparison.
            assert (1 << D3) <= 6**H, (H, X, a, b, c, d, third, D3)
            candidates.append(dict(X=X, a=a, b=b, c=c, d=d,
                                   third=third, D2=D2, D3=D3))
    assert len(candidates) == len(seen)
    return dict(
        H=H, pairs_checked=pair_count, long_sources=len(candidates),
        max_D2=max((s['D2'] for s in candidates), default=H),
        D2_integer_bound=3 * H // 2,
        max_D3=max((s['D3'] for s in candidates), default=H),
        D3_integer_bound=(6**H).bit_length() - 1,
        worst_three=sorted(candidates, key=lambda s: s['D3'], reverse=True)[:3],
    )


if __name__ == '__main__':
    results = [verify(H) for H in HEIGHTS]
    print(json.dumps(dict(status='PASS', arithmetic='exact global X=x+1',
                          source_strict=True, even_run_bound_strict=True,
                          results=results), indent=2))
