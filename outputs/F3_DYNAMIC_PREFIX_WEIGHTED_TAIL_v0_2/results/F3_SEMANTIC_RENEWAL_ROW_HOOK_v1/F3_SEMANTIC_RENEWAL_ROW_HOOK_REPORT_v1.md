# F3 semantic renewal row hook v1

Status: `CONDITIONAL_RENEWAL_TO_PISTAR_PASS_F3_CONTRIBUTION_HOOK_OPEN`.

This is the end-to-end conditional bridge.  From the frozen Real row
inequality and nonnegativity, Lean obtains the iterated weighted-mass lower
bound.  For every level, the new row-wise contribution hook then bounds that
operator mass by finite stopped fibres; pairwise-disjoint fibres and inclusion
in `piStar` convert the result to an actual sum of `piStar` cardinalities.

The resulting statement is uniform in the level parameter `n`, but it remains
conditional on the genuine F3 obligations: the operator-to-contribution
inequality, the member-wise fibre bounds, and the disjointness/inclusion
invariants for the composed paths.  No empirical holdout is used as a
hypothesis, and no rho, density, almost-all, or global Collatz claim is made.

This closes the formal conversion interface.  The remaining mathematical
work is to instantiate these premises for the frozen three-channel rules and
then prove the Real renewal hypotheses needed for the desired exponent.
