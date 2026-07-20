# KL2003 general-k dynamic retarded lower bound in Lean

Date: 2026-07-20

## Scope

This module generalizes the existing generic retarded induction from one
static row per index to a row selected at the current real argument `y`.
`DynamicRetardedInputs` requires its shift-window, semantic-row, and
coefficient-feasibility fields only in the inductive region `nu < y`; the base
region remains unchanged. The strong induction on `genericRetardedRank` is the
same as in the static theorem.

The source-faithful bridge chooses, for each mode and each `y > nu`, the exact
`SourceELRetardedWitness` produced by the terminated critical scheduler. One
choice supplies all three obligations:

- `sourceDynamicRow_shiftsWithin` uses the uniform window theorem;
- `sourceDynamicRow_evalAt_le` uses the witness's semantic inequality; and
- `sourceDynamicRow_coefficient_feasible` uses the LNT transfer theorem.

No synthetic row is assumed. The selected expression may vary with `y`, which
is precisely why the dynamic consumer is needed.

The finite tracked-mode type also supplies a positive base constant. If
`lambda >= 1`, the sum of all positive principal coefficients times
`lambda^nu` dominates every base-region term. Its reciprocal is
`sourceDynamicDelta > 0`, while `sourcePhiK >= 1` discharges the semantic base.

The public general-k result is:

```lean
exists_sourcePhiK_retarded_lower_bound
    (roots : GeneralKClassRootsNonempty (p + 1))
    (certificate : LNTCertificate hp) (hlambda : 1 <= certificate.lambda) :
    exists Delta : Real, 0 < Delta /\
      forall mode y, 0 <= y ->
        Delta * certificate.principal mode * certificate.lambda ^ y <=
          sourcePhiK mode y
```

## Boundary

The theorem is conditional only on a constructed `LNTCertificate`, generic
class-root nonemptiness, and `lambda >= 1`. The verified k=3 generated data has
not yet been converted into that certificate in this module. No k=3 piStar
theorem, k=9 theorem, or global Collatz claim is made here.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKDynamicRetardedLowerBound
lake env lean CollatzClassical/KL2003/KL2003GeneralKDynamicRetardedLowerBoundAxiomAudit.lean
```

Classifications:

```text
DYNAMIC_RETARDED_INPUTS_DEFINED
DYNAMIC_RETARDED_STRONG_INDUCTION_PROVED
STATIC_CONSUMER_RECOVERED_AS_SPECIAL_CASE
SOURCE_FAITHFUL_Y_DEPENDENT_ROWS_CONSUMED
POSITIVE_GENERAL_K_BASE_CONSTANT_CONSTRUCTED
GENERAL_K_SOURCEPHIK_RETARDED_LOWER_BOUND_PROVED_FROM_LNT_CERTIFICATE
K3_LNT_CERTIFICATE_INSTANTIATION_NOT_YET_PROVED
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_FORMALISATION_NOT_AUTHORIZED
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
