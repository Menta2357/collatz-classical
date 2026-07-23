# F3 advanced/parity-lift disjointness v1

Status: `ADVANCED_SOURCE_PAIRWISE_DISJOINTNESS_PASS_F3_AGGREGATE_INSTANTIATION_OPEN`

The module proves the missing member-wise fact for two advanced source kinds:

- direct source: `piStarFinset c xChild`;
- parity-lift source: `piStarFinset (2*c) xChild`.

If both satisfy `3*c+1 = 2*a`, the windows lie below `x`, the parent is not in
a cycle, and the inverse children differ, then their source populations are
disjoint.  The proof uses the first entrance into `a` and the existing
inverse-child predecessor lemma.  It also proves a finite-family
`PairwiseDisjoint` theorem.

This closes a genuine semantic gap in the rule → `piStar` bridge, but it is
not yet the split-edge aggregate theorem: the three fine lifts vary the parent
root across a complete 3-adic block.  The remaining work is to assemble these
per-parent facts with the frozen root-block enumeration and prove the uniform
first-hit retained-mass inequality.

No claims: `NO_RHO_CERTIFICATE`, `NO_DENSITY_THEOREM`,
`NO_GLOBAL_COLLATZ_CLAIM`.
