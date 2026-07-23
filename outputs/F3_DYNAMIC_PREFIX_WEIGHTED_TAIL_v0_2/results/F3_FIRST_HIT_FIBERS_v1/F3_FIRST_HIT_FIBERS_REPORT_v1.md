# F3 first-hit fibres v1

Status: `CYCLE_SAFE_FIRST_HIT_DISJOINTNESS_PASS_RAW_LEAKAGE_OPEN`

Raw inverse-child `piStar` populations need not be disjoint if an orbit has
already visited the parent and later returns.  The new `firstHitSource` filters
each direct or parity-lift source by an explicit witness
`FirstHitsAt a n (k+1)` with predecessor `c`.

Lean proves:

- pairwise disjointness for distinct inverse children, without a
  `NotInCycle a` hypothesis;
- inclusion of each first-hit fibre in the parent `piStar` population;
- the finite-family `PairwiseDisjoint` theorem needed by the aggregate bridge.

This is the correct cycle-safe semantic object.  It does not claim that the
discarded raw members are negligible.  Their contribution is now an explicit
line in the renewal leakage budget, and proving that line uniformly in `y` is
the next F3 obligation.

No claims: `NO_RHO_CERTIFICATE`, `NO_DENSITY_THEOREM`,
`NO_GLOBAL_COLLATZ_CLAIM`.
