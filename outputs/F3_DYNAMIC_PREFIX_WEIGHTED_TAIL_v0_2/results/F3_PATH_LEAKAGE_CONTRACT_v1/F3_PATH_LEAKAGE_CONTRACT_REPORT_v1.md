# F3 path-leakage contract v1

Status: `ABSTRACT_STOPPED_PATH_CONTRACT_PASS_F3_PATH_INSTANTIATION_OPEN`

This module packages the remaining population-level obligation without
claiming the F3 theorem.  A `StoppedPathData` object contains a finite root
population, complete stopped fibres, and the boundary remainder.  The Lean
theorem proves the exact identity

```text
sum(card fibre) + card(boundary) = card(root).
```

`RouteIIContract` then exposes the three hypotheses that an actual F3 path
construction must provide:

1. the row-wise boundary budget;
2. the normalized root lower bound with `qStar = 24100/24543`;
3. the first-hit retained-mass bound by the stopped increment.

From these hypotheses, Lean derives the audited leakage recurrence and the
finite renewal lower bound.  No hypothesis is inferred from the holdout, and
no operator-to-`piStar` growth theorem is asserted.

## Current gap

The public F3 artifacts still do not provide a `StoppedPathData` instance for
all scales and states, nor the `retained_le_stopped_increment` proof.  Those
are the next mathematical obligations.  Until they are supplied, the status
remains contract/open rather than theorem.

## Audit

The companion axiom audit must contain no `sorryAx`.  The remaining admitted
assumptions are fields of the explicit contract, not hidden axioms.

No claims: `NO_RHO_CERTIFICATE`, `NO_DENSITY_THEOREM`,
`NO_GLOBAL_COLLATZ_CLAIM`.
