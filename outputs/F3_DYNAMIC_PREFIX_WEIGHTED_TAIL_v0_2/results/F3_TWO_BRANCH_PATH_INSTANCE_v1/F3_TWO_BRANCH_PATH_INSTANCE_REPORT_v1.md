# F3 two-branch stopped-path instance v1

Status: `PISTAR_STOPPED_PATH_INSTANCE_PASS_F3_THREE_LIFT_INSTANCE_OPEN`

`twoBranchStoppedPathData` is an actual `StoppedPathData Bool Nat` object.
Its root is `piStarFinset a x`, its two fibres are
`piStarFinset (4*a) xRet` and `piStarFinset c xAdv`, and its boundary is the
exact finite-set remainder.  Under the existing positivity, no-cycle,
window, and inverse-child hypotheses, Lean proves fibre disjointness,
fibre inclusion, and the exact cardinal identity through the renewal
contract.

This is a semantic integration test, not the F3 theorem.  The three-lift
instance still needs aggregate 3-adic block assembly and the uniform
first-hit leakage inequality.  No empirical holdout is used as a Lean
hypothesis.

No claims: `NO_RHO_CERTIFICATE`, `NO_DENSITY_THEOREM`,
`NO_GLOBAL_COLLATZ_CLAIM`.
