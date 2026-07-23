# F3 tilted live comparison v1

Status: `TILTED_PATH_COMPARISON_PASS_OPERATOR_TILTED_MASS_BOUND_OPEN`.

For a finite live path family, Lean verifies the exact Chernoff comparison:
if `star = tilt * exp(-theta*shift)` and every live path has
`shift >= -H`, then `star ≤ exp(theta*H)*tilt`.  A weighted version transports
this through a nonnegative vector comparison `weight ≤ K*v` and any supplied
tilted path-mass bound.

This is the path-level algebra behind the paper's `(B.4)`.  The module does
not construct the path family or prove its tilted mass bound; those remain the
F3-specific operator/composition obligation.  No rho, density, almost-all,
or global Collatz claim is made.
