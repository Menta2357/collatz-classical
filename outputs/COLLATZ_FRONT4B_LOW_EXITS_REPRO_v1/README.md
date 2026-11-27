# Front4b low exits and net rank across switches

This package continues the exact two-block word
$(1,1,1,2,2,1,1,1,2,1)$ in the two Front4b E1 rows.
The original seed is $N$. We write $a$ for the next physical valuation
and use “row 3” and “row 5” for the two E1 rows.
Physical books record odd returns, the sum of valuations and the additive
term. A paid encounter carries a separate exact book from its source $w<N$.

## Certified coverage

| Physical condition | Outcome |
| --- | --- |
| Any $a\ge6$ after the two blocks | Strict descent under the original $N$ in both rows. |
| $a=5$ in either row | A paid one-return source $w=(2Y-1)/3$ reaches the same terminal $Y$. |
| $a=4$ | Compress the full run of twos. At least 4 twos in row 3, or 3 in row 5, force descent. If it ends with a valuation at least 3, a quarter source pays. The rest is a short run followed by a real 1. |
| $a=3$ or a later return of valuation 3 | In the certified height window an auxiliary valuation-one predecessor lets a subsequent run of ones and a real rupture at least 3 pay by a smaller source. The proof uses both physical books. |
| $a=1$ or 2 | The appropriate readmission cut has smaller cofactor exactly when its new run length is at least 6. A real weak pair is required to readmit. A further real valuation $e$ gives descent if $a+e\ge8$ in row 3 or $a+e\ge7$ in row 5. |

The package also certifies three physical first-crossing families.
In row 3 one uses consecutive valuations $(3,4)$ and another uses
valuation 4 followed by three twos. In row 5 it uses valuation 4 followed
by two twos. A2 converts each first crossing to payment or a lower
ambient pivot, carrying the same $N$. [Lean proof](lean/Front4bLowExit.lean)

The table gives the exact proved implications. Remaining low phases
which do not activate a certified implication still need coverage.
The cofactor drop alone supplies a local rank step. Iterating it requires
an admitted continuation and a new decrease or payment at a later cut.
The cofactor and the A2 height above $N$ are different ranks. Across a
nonempty weak word, the checkpoint can grow even when its cofactor drops.

## Rank across multiple episodes

For an arbitrary physical weak word with book $(r,d,B)$, write the
endpoints as $J+1=2^{L+1}q$ and $Z+1=2^{H+1}v$.
The exact sign criterion in Lean is
$$v<q\quad\Longleftrightarrow\quad
3^r2^{L+1}q+B+2^d<2^d2^{H+1}q+3^r.$$
There is also a sufficient clock budget using the established sharp
height envelope. Neither rule assumes that the intermediate cofactors
decrease. In particular, if two episodes start with lengths $2,2$,
their tails switch between $1,2$, and the final run length is at least 4,
the net cofactor is strictly smaller. Four exact E1 witnesses show an
intermediate increase followed by this net decrease.
[Lean proof](lean/Front4bNetCofactor.lean)

[Scope, remaining obligations, and the counterexample to the CRT trigger](paper/outcomes.md)

## Reproduction

Use Lean 4.21.0 and keep all five earlier row, guard, weak exit,
switching, and aperiodic packages and the residual package beside this
directory. The verifier also accepts explicit directory arguments.

    python3 scripts/verify.py --jobs 2
    python3 -B paper/check_five_six.py
    python3 -B paper/check_reentry.py
    python3 -B paper/check_net_cofactor.py
    python3 -B paper/check_low_exit.py

[Clean reproduction receipt](provenance/reproduction.json).
