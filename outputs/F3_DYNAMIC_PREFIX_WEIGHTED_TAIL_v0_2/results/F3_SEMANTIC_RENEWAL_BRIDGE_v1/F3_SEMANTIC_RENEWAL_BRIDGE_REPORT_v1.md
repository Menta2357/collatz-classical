# F3 semantic-renewal bridge v1

Status: `CONDITIONAL_BRIDGE_PASS_SEMANTIC_HOOK_OPEN`.

This module is the missing interface between the Real operator iteration and
actual `piStar` populations.  It deliberately does not instantiate the
semantic lower hook from numerical CSV data.

## Formal content

`PiStarOperatorWitness` packages:

- a finite nonnegative Real matrix, weights, initial mass, and row growth
  inequality;
- a root block, per-root finite index family, and finite fibres;
- exact fibre pairwise-disjointness and inclusion into
  `piStarFinset a (window n)`;
- the still-open semantic inequality from iterated operator mass to the sum
  of fibre cardinalities.

The theorem `operator_mass_le_piStar_mass` combines the explicit semantic
lower hook with the kernel-checked aggregate fibre theorem.  The theorem
`exponential_piStar_mass_lower_bound` then combines it with the Real iterate
bound and yields the conditional implication

`(1 + delta)^n * weightedMass w initial <=
  sum_a card (piStarFinset a (window n))`.

The axioms audit reports only `propext`, `Classical.choice`, and `Quot.sound`.

## What remains open

The missing field `operator_to_fibres` is the genuine F3 obligation: prove a
lower bound from the frozen operator's iterates to first-hit fibre mass, with
the discarded raw-source population and its leakage accounted for.  The
first-hit fibre theorem and finite aggregate upper bound are already separate
kernel-checked components.  This file is conditional and makes no rho,
density, almost-all, or global-Collatz claim.
