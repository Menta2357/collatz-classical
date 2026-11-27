# Front4b residual aperiodic trajectories

This package continues the E1 analysis at commit
[2a9c442](https://github.com/Menta2357/collatz-classical/commit/2a9c442a0ab60eb74e7af0bf760b096d3ec00f2d).
The two original E1 bands are $u\equiv18\pmod{32}$ and $u\equiv10\pmod{128}$.
A weak episode is a physical sequence $1^L,2,b$ with $L\ge2$ and $b=1$ or $2$.
Every original-clock result composes the exact valuation and return clocks and
additive cost from the same $N$. A paid source has its own book from $w<N$.

## Lean certificates

- [Separated repeated words](lean/Front4bSeparatedRepeat.lean).
  If the same word with division count $d$ occurs at two checkpoints
  of the same trajectory, both with starting run length $L$, and its
  terminal run lengths are $H,K$, the valuation of the difference
  between the starting odd cofactors is exactly $d+\min(H,K)-L$
  for $H
e K$. For $H=K$, it is at least $d+H-L+1$.
- [A budget for the intervening path](lean/Front4bSeparatedEnvelope.lean).
  At constant length two, the actual intervening division clock $e$
  bounds the allowed repeat. For occurrences at $s<t$ and starting
  cofactor $Q_s$, the inequality is
  $2^e(17\cdot2^{d+1}+17Q_s+7)\le81^{t-s}(17Q_s+7)$.
- [A price for the number of source breaks](lean/Front4bSourceBudget.lean).
  At a terminal after $k$ weak episodes from $J\ge N$, a paid source
  with $h$ valuations of at least 2 must satisfy
  $(81/64)^k\le N^{2^{h+1}-1}$. The positions and magnitudes of the
  breaks may vary. For fixed $N$ and $h$, this gives a finite horizon.
- [Ternary terminal reconstruction](lean/Front4bTernaryHeight.lean).
  For a physical word with book $(r,d,C)$ from $J$ to $X$, once
  $17J+73\le17\cdot2^d$ the terminal lies in $[0,3^r)$ and
  satisfies $2^d X\equiv C\pmod{3^r}$. Thus the exact word determines
  the entire terminal in that range. The original book is part of the result.

- [Descents after a short weak exit](lean/Front4bShortExit.lean).
  After the two $(L,b)=(3,2),(3,1)$ blocks, a real next valuation
  of at least 6 in the c=5 row or 7 in the c=3 row gives descent.
  Every c=5 parameter $t=42784+2^{18}h$ gives a physical loss of the
  half-source window with growing cofactor, then a valuation-seven
  exit and descent at the original return 77. The same seed and
  both original books are verified independently of the guard.

[Paper proofs and physical witnesses](paper/residual.md) include a
counterexample to a candidate rank based on dyadic reserve and historical
debt and a necessary lower bound on the reduced denominator of the\naccumulated centre. A further [paper result](paper/multisource.md) rules out all sources with
only valuations at most 4 and at most two valuations of at least 3 in
the constant-length-two subchannel, at any physical checkpoint. Pointwise activation of a paid source, descent, or smaller rank on all
remaining trajectories is open.

## Reproduction

Lean 4.21.0 with Std. Keep the frozen row, guards, weak exits, switched
weak episodes, and aperiodic packages beside this directory. The verifier
accepts overrides via --row, --guards, --weak, --switched and --aperiodic.

    python3 scripts/verify.py --jobs 2
    python3 -B paper/check_witnesses.py
    python3 -B paper/check_separation.py
    python3 -B paper/check_multisource.py

The manifest pins every source used in the build. Local object hashes are
provided as receipts of the audited runs. A clean rebuild regenerates the
objects from source and audits all statements again.

[Clean reproduction receipt](provenance/reproduction.json).
