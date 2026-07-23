# F3 cumulative first-hit fibres v1

Status: `CUMULATIVE_FIRST_HIT_FIBRES_PASS_COMPOSED_PATH_HYPOTHESIS_OPEN`.

For any finite collection of layers, this module defines the flattened
first-hit fibre over the sigma-index `(level, state)`.  If the terminal
inverse children are distinct across all distinct sigma-indices, Lean proves
pairwise disjointness across levels, not merely within one level.  The
existing first-hit lemma supplies the key cancellation of two different
arrival times.  Under the arithmetic rule `3*child + 1 = 2*parent` and the
window bounds, every fibre is included in the parent `piStar` population.

The final theorem bounds the sum of all finite-level first-hit fibre
cardinalities by the single parent population.  This is the finite global
accounting lemma needed by the renewal conversion.

The theorem deliberately leaves the composed F3 path inventory and its
cross-level child-distinctness hypothesis open.  It proves no uniform renewal
inequality, rho certificate, density theorem, almost-all statement, or global
Collatz claim.
