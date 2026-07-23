# F3 semantic lower-hook conversion v1

Status: `CONTRIBUTION_TO_PISTAR_CONVERSION_PASS_OPERATOR_COMPARISON_OPEN`.

This module makes the remaining semantic obligation explicit rather than
bundling it into an opaque `hsemantic` field.  It proves the following
pipeline for every finite layer `n`:

```text
operator mass
  ≤ sum of explicit Real row contributions
  ≤ sum of fibre cardinalities
  ≤ sum of the corresponding piStar populations.
```

The first inequality is supplied as
`operator_to_contribution`; it is the genuinely F3-specific analytic hook.
The second is now a member-wise theorem using
`F3LayerNormalization.sum_contribution_le_sum_fibre_card`.  The third uses
the existing disjointness and subset bridge
`aggregate_piStar_card_bound`.

## Formal artefact

The theorem is
`F3SemanticLowerHook.operator_mass_le_piStar_mass_of_contribution_hook` in
`CollatzClassical/KL2003/F3ReturnExcursionSemanticLowerHook.lean`.
Its axiom audit reports only `propext`, `Classical.choice`, and `Quot.sound`.
The manifest records the source, audit companion, report, and both logs.

## What remains open

This is not a rho or density theorem.  It does not manufacture
`operator_to_contribution` from the empirical holdout.  The next mathematical
task is to define the concrete frozen-rule contributions and prove that first
inequality uniformly in the window parameter, with the boundary and
first-hit accounting included.  Until that is done, the F3 growth statement
remains conditional and all NO-CLAIMS remain active.
