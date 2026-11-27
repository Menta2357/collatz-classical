# Physical certificates for the weak Front4b tails (2,1) and (2,2)

Both cases start at the certified checkpoint (J) of the original seed (N)
in (uequiv18pmod{32}) or (uequiv10pmod{128}). Write
(J+1=2^{L+1}Q) with (Lge2) and (Q) positive odd. The orbit performs its
(L) ones and the weak pair ((2,b)), (b=1) or (2), and reaches (Z).
The local book has (L+2) odd returns, (L+2+b) shortcut steps and additive
(3^{L+2}-2^{L+1}). The original prefix is composed with this book.

## Certified payment, descent and reentry

- After ((2,1)), five fixed heads and three families with an additional
  one-run of arbitrary length give a physical capture. After ((2,2)),
  the heads ((2,2,10)) and ((2,2,6,6)) give a physical capture. The
  subsequent final valuation is free. The source is (w=(J-3)/4<N),
  with its own clock and exact additive term. See the lists and arithmetic
  in [the (2,1) certificate](paper/tail21.md) and
  [the (2,2) certificate](paper/tail22.md).
- A following exact valuation (a) with (a+bge L+4) gives a descent below
  (N). A continuation of (2L+4) successive twos also suffices. Both
  sufficient criteria use the measured length (L) and keep the exact
  original book.
- If (Z+1=2^{H+1}Q') for the next exact run, with (Hge2), the exact
  cofactor book is
  [
  2^{H+b+2}Q'=3^{L+2}Q+2^{b+1}-1.
  ]
  The Lean reentry lemma gives (Q'<Q) **if and only if**
  (2^{H+b+2}>3^{L+2}). When the next physical point again has a weak
  pair after its exact one-run, the same ranking rule applies with the
  composed history from the same (N). Natural cofactors forbid an infinite
  chain consisting exclusively of these strict decreases.

There is a second ranking rule for repeats of a fixed `b` with exact
one-run length two. Put `D = 2^(4+b)` and `c = 2^(b+1)-1`. After `n`
repeats the actual cofactors satisfy
`D^n ∣ (81-D)Q₀+c`. The resource is positive and each repeat consumes
`4+b` units of two-adic valuation. A fixed seed therefore has only
finitely many consecutive repeats of this fixed block. The Lean
certificate also composes the two original clocks and every correction
from the original seed.

## Residual cases

A next one-run of length exactly (H=2) gives strict cofactor growth for
both weak pairs. The dyadic realization proves that the preceding and
following run lengths can be prescribed in the same physical seed class.
The [repeated weak-pair construction](paper/repeated_weak_pairs.md) gives a
further paper obstruction to a uniform bound on the number of consecutive cofactor increases
before a crossing below the original J. These finite constructions leave open the trajectory
of any one fixed seed beyond the prescribed prefix.

The two weak tails remain open overall. The first unresolved mathematical
condition is a compensating terminal or a decreasing resource that also
handles genuine reentries where the cofactor grows. A paid encounter
supports strong induction on smaller seeds. Direct descent and the rank
comparison are stated independently of that induction.

## Reproduction

Use Lean 4.21.0 with Std. Keep the pinned row and previous guard packages as
siblings, or provide their paths as `--row` and `--guards`.

```sh
python3 scripts/verify.py --jobs 1
python3 -B paper/check_realization.py
python3 -B paper/check_tail22.py
python3 -B paper/check_repeated.py
```

For `check_tail22.py`, set `FRONT4B_ROW_PAPER` to the previous row
package's `paper` directory when it is not in the default location.
