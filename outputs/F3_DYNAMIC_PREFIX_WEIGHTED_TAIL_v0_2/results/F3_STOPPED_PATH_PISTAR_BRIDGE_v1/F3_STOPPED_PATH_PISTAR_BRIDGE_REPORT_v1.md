# F3 stopped-path to piStar bridge v1

Status: `STOPPED_PATH_RETAINED_MASS_TO_PISTAR_PASS`.

This module closes the finite semantic interface below the operator level.
For every `StoppedPathData` layer, pairwise disjoint fibres contained in the
root population imply

```text
retainedMass <= rootMass.
```

When the root population is itself contained in a concrete
`piStarFinset root window`, the second theorem gives

```text
retainedMass <= card(piStarFinset root window).
```

The proof is pure finite cardinality accounting plus explicit Nat-to-Real
casts.  It uses no holdout data, no matrix inequality, and no asymptotic
claim.  The source is
`CollatzClassical/KL2003/F3ReturnExcursionStoppedPathPiStarBridge.lean`; its
axiom audit reports only `propext`, `Classical.choice`, and `Quot.sound`.

## Remaining F3 obligation

The remaining analytic step is now isolated above this bridge: prove that the
frozen Real operator supplies sufficient retained stopped mass (or explicit
row contributions) at every iteration level.  This module does not infer
that comparison and makes no rho, density, almost-all, or global-Collatz
claim.
