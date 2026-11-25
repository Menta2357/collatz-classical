"""Affine comparison for the complete u=11 mod 16 first-crossing branch."""

import json

from check import PARENT_BOOK, difference, edge, original_and_prefix, positive, require


def main():
    n, f = original_and_prefix(11, 16)
    v = edge(edge(f, 2), 2)
    w = edge(v, 1)
    p = edge(w, 2)
    q = edge(p, 2)
    require(all(positive(difference(state, 1, v, 1)) for state in (w, p)), "first crossing")
    n_lt_q = difference(q, 1, n, 1)
    q_lt_v = difference(v, 1, q, 1)
    require(positive(n_lt_q) and positive(q_lt_v), "N<Q<V")
    j, divisions, cost = PARENT_BOOK
    for valuation in (2, 2, 1, 2, 2):
        j, divisions, cost = j+1, divisions+valuation, 3*cost+2**divisions
    require((j, divisions, cost) == (65, 103, 72551301119972516370644828770691), "old book")
    print(json.dumps(dict(status="PASS", domain="u=11+16*t, t>=0",
                          first_crossing=[62, 65], local_book=[3,5,23],
                          original_book=[j,divisions,cost], Q_affine=q,
                          Q_minus_N=n_lt_q, V_minus_Q=q_lt_v), indent=2))


if __name__ == "__main__":
    main()
