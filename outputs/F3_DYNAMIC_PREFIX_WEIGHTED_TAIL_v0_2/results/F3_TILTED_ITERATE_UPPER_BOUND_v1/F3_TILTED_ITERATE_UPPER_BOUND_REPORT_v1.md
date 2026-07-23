# F3 tilted iterate upper bound v1

Status: `TILTED_ITERATE_UPPER_BOUND_PASS_PATH_MASS_INSTANTIATION_OPEN`.

The module proves the finite algebraic propagation needed by the Chernoff
route.  From nonnegative matrix entries and a row-wise supersolution
`sum_t M(s,t)*v(t) ≤ lambda*v(s)`, it derives
`weightedMass v (iteratePush M initial n) ≤ lambda^n * weightedMass v initial`.

It also composes this iterate bound with the finite tilted-path comparison,
yielding the exact live-mass estimate once a F3 path family supplies
`tilt_path_mass ≤ weightedMass v (iteratePush M initial n)`.

This is not yet the F3 operator theorem: the concrete tilted matrix, its
path family, and the comparison from composed live paths to this iterate
functional remain to be supplied.  No rho, density, almost-all, or global
Collatz claim is made.
