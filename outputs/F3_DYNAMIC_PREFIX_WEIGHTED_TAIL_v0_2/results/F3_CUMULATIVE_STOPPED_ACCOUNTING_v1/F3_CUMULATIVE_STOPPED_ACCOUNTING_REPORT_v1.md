# F3 cumulative stopped-fibre accounting v1

Status: `CUMULATIVE_STOPPED_FIBRE_DISJOINTNESS_PASS_OPERATOR_COMPARISON_OPEN`.

The new theorem flattens finitely many stopped levels into one sigma-indexed
family.  Under a single global pairwise-disjointness hypothesis across levels,
and inclusion of every fibre in one root population, it proves

```text
sum over all levels and fibres of cardinalities <= root cardinality.
```

Its Real corollary is the exact cumulative retained-mass bound needed for a
finite stopped-tree ledger.  This prevents a hidden level-by-level double
count: disjointness must be global, not merely within each level.

## Formal artefact

The source is
`CollatzClassical/KL2003/F3ReturnExcursionCumulativeStoppedAccounting.lean`.
The two theorems are
`cumulative_fibre_card_le_root_card` and
`cumulative_retainedMass_le_rootMass`.  The Lean audit reports only
`propext`, `Classical.choice`, and `Quot.sound`.

## Remaining obligation

This module does not prove global disjointness for the actual F3 composed
paths, nor does it compare the frozen operator with the cumulative stopped
mass.  Those are now explicit path-composition and operator-to-stopped
obligations; no rho, density, almost-all, or global-Collatz claim is made.
