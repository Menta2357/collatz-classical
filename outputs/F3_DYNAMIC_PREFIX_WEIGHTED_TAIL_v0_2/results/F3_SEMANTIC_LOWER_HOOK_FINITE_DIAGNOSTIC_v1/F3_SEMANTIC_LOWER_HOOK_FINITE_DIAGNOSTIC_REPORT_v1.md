# F3 finite semantic lower-hook diagnostic v1

Status: `FINITE_DIAGNOSTIC_ONLY`.

This run performs one finite-layer sanity check for the still-open
`hsemantic` field.  It uses only already frozen artifacts and does not open a
new holdout or assert a uniform bound.

## Parameters

- roots: `3 <= a < 128`, with `a > 2` and `(2a-1) % 3 = 0`;
- scale: `y = 8`, `x = 2^y a`;
- retarded source: `piStar(4a, x)`, first parent predecessor `2a`;
- direct source: `piStar(c, x_phase_b)`, first predecessor `c` when `c=2 mod 3`;
- parity-lift source: `piStar(2c, x_phase_b)`, first predecessor `c` when
  `c=1 mod 3`;
- row mass: `lhs_wM_decimal` from the frozen core vector artifact.

The first-hit filter retains precisely those members whose first entrance
into `a` has the declared predecessor.  The channel fibres are checked for
pairwise disjointness before their cardinalities are summed.

## Result

There are 41 core rows.  All fibre sets are disjoint.  The minimum observed
ratio

```text
sum(first-hit fibre cardinalities) / frozen row mass
  = 4217.992651058822
```

is positive on this finite calibration.

## Interpretation and limitation

This is evidence that the finite first-hit construction is not empty on the
chosen block.  It is not yet the formal `hsemantic` theorem: the latter must
be stated for the full state mass and every iteration level, with the exact
normalization and boundary leakage carried through.  The large ratio also
shows why its denominator must remain explicit; it must not be silently
identified with the holdout's root-count denominator.

Machine-readable outputs are `finite_hook_rows.csv` and `summary.json`; the
script is `scripts/f3_semantic_lower_hook_finite_diagnostic_v1.py`.

NO claims of a uniform `hsemantic`, operator-to-`piStar` growth theorem, rho
certificate, density, almost-all statement, or global Collatz theorem are
made.
