# KL2003 M0C Rows V3 Phi5 Contract And Recheck Scoping v1

Date: 2026-07-13

Repository: `https://github.com/Menta2357/collatz-classical`

## Purpose

This note scopes the migration from the current M0C row contract V2 to a
source-faithful V3 contract after the meta-errata:

```text
M1 phi5 reinstated
```

No Lean is modified in this pass.  No row28 seam theorem, M1 theorem, or
global Collatz claim is made.

## Classification

```text
M1_PHI5_META_ERRATA_CONSUMED
ROWS_V3_CONTRACT_SCOPED
V2_MARKED_ABSTRACT_NOT_SOURCE_FAITHFUL
ROW28_V3_ARITH_RECHECK_REQUIRED
LEAN_MIGRATION_NOT_STARTED
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Source Inputs

Primary project-side inputs:

```text
docs/KL2003_META_ERRATA_M1_PHI5_REINSTATEMENT_v1.md
docs/KL2003_ROW28_POST_DELETION_PATTERN_LEDGER_v1.md
docs/KL2003_DELETION_RULE_SOURCE_AUDIT_v1.md
docs/KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_AUDIT_v1.md
CollatzClassical/KL2003/KL2003M0CRetardedInduction.lean
```

The meta-errata revokes the earlier project normalization:

```text
old project-normalized M1 second arm: phi_2^2(y + 2*alpha - 5)
source-faithful arm:                 phi_2^5(y + 2*alpha - 5)
```

Thus the existing V2 Lean theorem remains a valid theorem about its stated
abstract row system, but V2 is no longer the KL2003 source-faithful row28
target.

## Proposed V3 Contract

The conclusion should not be duplicated:

```lean
RetardedLowerBoundConclusion Phi
```

V3 should introduce a new row/input contract beside V1/V2.

Suggested definitions:

```lean
noncomputable def M2V3 (Phi : K2PhiSystem) (y : Real) : Real :=
  min3
    (Phi.phi22 (y + shift3AlphaMinus5Pad3))
    (Phi.phi25 (y + shift3AlphaMinus5Pad3))
    (Phi.phi28 (y + shift3AlphaMinus5Pad3))

noncomputable def M1V3 (Phi : K2PhiSystem) (y : Real) : Real :=
  min
    (Phi.phi28 (y + shift2AlphaMinus5Pad2) + M2V3 Phi y)
    (Phi.phi25 (y + shift2AlphaMinus5Pad2))
```

`M2V3` is definitionally the same shape as `M2V2`; a separate name is useful
only to make source-faithful V3 audit trails explicit.

Suggested row contract:

```lean
structure I2ELAbstractRowsV3 (Phi : K2PhiSystem) : Prop where
  row22 :
    forall y, 14 <= y ->
      Phi.phi28 (y - 2)
        + min3
            (Phi.phi22 (y + shiftAlphaMinus2Pad))
            (Phi.phi25 (y + shiftAlphaMinus2Pad))
            (Phi.phi28 (y + shiftAlphaMinus2Pad))
        <= Phi.phi22 y
  row25 :
    forall y, 14 <= y ->
      Phi.phi22 (y - 2) <= Phi.phi25 y
  row28EL :
    forall y, 14 <= y ->
      Phi.phi25 (y - 2)
        + min
            (Phi.phi28 (y + shiftAlphaMinus3Pad) + M1V3 Phi y)
            (Phi.phi22 (y + shiftAlphaMinus3Pad))
        <= Phi.phi28 y
```

Suggested input contract:

```lean
structure K2RetardedInductionInputsV3 (Phi : K2PhiSystem) : Prop where
  certificate :
    K2InteriorCertificateData.ValidData k2CertificateData
  endpointsB :
    (119 / 135 : Real) <= BReal /\ BReal <= (8 / 9 : Real)
  endpointsD :
    (119 / 100 : Real) <= DReal /\ DReal <= (6 / 5 : Real)
  zeroExtension :
    K2PhiZeroExtension Phi
  weightedBase :
    BaseSegmentWeightedLowerBound Phi
  rowsV3 :
    I2ELAbstractRowsV3 Phi
```

Suggested constructor from the closed certificate:

```lean
k2_retarded_inputs_v3_from_closed_certificate
```

## What Survives From V2

These pieces are independent of the `M1` second-arm class and should survive
without mathematical change:

- M0A semantics and `piStar` root-count lemmas.
- M0B reachability/fiber machinery.
- M0B two-branch core and D1/D2/D3 Nat combinatorial rows.
- Concrete Phi traffic lemmas.
- row25 seam, because D2 is single-branch and has no advanced pad.
- row22 seam and row22 parity lift.
- root-count/base bridge and `base_weighted_of_unit`.
- `DeltaV2`, `epsilon0`, and padded shift definitions.
- `deltaM0C_pos`.
- all retarded-rank descent lemmas, including padded shifts:
  `retardedRank_drop_minus_two`,
  `retardedRank_drop_shiftAlphaMinus2Pad`,
  `retardedRank_drop_shiftAlphaMinus3Pad`,
  `retardedRank_drop_shift2AlphaMinus5Pad2`,
  `retardedRank_drop_shift3AlphaMinus5Pad3`.
- `row22_assembly`.
- `row25_assembly`.
- the generic strong-recursion skeleton of
  `m0c_retarded_induction_bound_v2_nonneg`, modulo replacing the row/input
  contract and the row28 assembly consumer.

## What Requires Recheck Or Replacement

The following V2 pieces depend on the old row28 nested arm or on arithmetic
tailored to it:

```text
M1V2
I2ELAbstractRowsV2.row28EL
K2RetardedInductionInputsV2 as KL2003 source target
M1V2_lower
row28_m1_block_lower
row28_first_branch_lower
row28_padded_block_lower
row28_assembly
m0c_retarded_induction_bound_v2_nonneg consumer of row28_assembly
m0c_retarded_induction_bound_v2 consumer of V2 inputs
```

Arithmetic lemmas to review:

```text
EL_A : c12R * lambdaR^2 <= c22R
row28_second_branch_lower
row28_dq_split_arithmetic
row28_dq_split_scaled
padded_row28_arithmetic
```

`EL_A` is not the right source-faithful justification for the V3 `M1` second
arm, because that arm is `phi25`, not `phi22`.  It may remain useful for the
outer row28 second branch, which is still `phi22(y + alpha - 3 - pad)`, but it
should not be cited as the `M1V3` second-arm margin.

## V3 Arithmetic Recheck On Paper

The coefficient data must be read from the normalized Table 4 ledger after the
meta-errata.  Do not introduce new auxiliary values by guesswork.

Principal values in the current certificate layer:

```text
c22 = 73/40
c25 = 1001/1000
c28 = 69/40
c12 = 1
lambda = 27/20
```

Auxiliary interpretation:

```text
a1, a2, a3 are the post-deletion row28 auxiliary groups.
The existing abstract arithmetic uses c12R = 1 as the uniform auxiliary lower
box for the min branches, via c12R <= min3 c22R c25R c28R.
```

V3 keeps the same `a1/a2/a3` tree structure.  The only intended contract
change is the second branch of `M1`:

```text
M1V2 second branch: Phi.phi22(y + shift2AlphaMinus5Pad2)
M1V3 second branch: Phi.phi25(y + shift2AlphaMinus5Pad2)
```

Local V3 replacement for `M1V2_lower` should be:

```lean
M1V3_lower :
  Phi28LowerBoundAt Phi (y + shift2AlphaMinus5Pad2) ->
  Phi25LowerBoundAt Phi (y + shift2AlphaMinus5Pad2) ->
  Phi22LowerBoundAt Phi (y + shift3AlphaMinus5Pad3) ->
  Phi25LowerBoundAt Phi (y + shift3AlphaMinus5Pad3) ->
  Phi28LowerBoundAt Phi (y + shift3AlphaMinus5Pad3) ->
  DeltaV2 * c12R * lambdaR ^ (y + shift2AlphaMinus5Pad2)
    <= M1V3 Phi y
```

The first branch uses `phi28 + M2V3`; this is the same structure as V2.
The second branch should use:

```text
c12R <= c25R
```

which is already true:

```text
1 <= 1001/1000
```

Therefore the local lower-bound check for the `M1` second branch appears
easier than V2, not harder.  However this is only a paper scoping statement;
the Lean recheck must still be done.

The row28 main padded arithmetic should initially be kept unchanged:

```text
c28 <= (400/729) * c25
       + (119/100) * (9997/10000) * c12
```

This is the existing `padded_row28_arithmetic`.  The V3 migration should
verify that the same `c12` auxiliary still represents the post-deletion block
under the Table 4 ledger with `phi25` reinstated.  If the ledger forces a
different auxiliary lower box for `a2`, then the row28 arithmetic must be
recomputed rather than patched syntactically.

Expected V3 recheck lemmas:

```text
M2V3_lower
M1V3_lower
row28_m1_v3_block_lower
row28_first_branch_lower_v3
row28_padded_block_lower_v3
row28_assembly_v3
```

Expected unchanged/reused arithmetic:

```text
EL_C : c12R <= min3 c22R c25R c28R
c12R_le_c25R
padded_row28_arithmetic
row28_target_le_coeff_sum
lambda_neg_three_epsilon_ge
```

Expected replacement for the old M1 second-arm dependency:

```text
old: same-shift lower through c22 / EL_A context
new: same-shift lower through c25 using c12R_le_c25R
```

## V2 Status

V2 should remain in the repository as an abstract theorem unless later cleanup
removes it deliberately:

```text
V2 = ABSTRACT_THEOREM_ONLY
V2 != KL2003_SOURCE_FAITHFUL_ROW28_TARGET
```

Specifically:

```lean
m0c_retarded_induction_bound_v2 :
  K2RetardedInductionInputsV2 Phi ->
  RetardedLowerBoundConclusion Phi
```

is still a valid Lean theorem about `I2ELAbstractRowsV2`.  It should not be
used as the final KL2003 row28/M0C source-faithful bridge after the meta-errata.

## Suggested Migration Order

1. Add `M2V3`, `M1V3`, `I2ELAbstractRowsV3`, and
   `K2RetardedInductionInputsV3` beside V2.
2. Add V3 arithmetic lemmas, starting with `M1V3_lower`.
3. Prove `row28_padded_block_lower_v3`.
4. Prove `row28_assembly_v3`.
5. Add a V3 induction theorem:

```lean
m0c_retarded_induction_bound_v3 :
  K2RetardedInductionInputsV3 Phi ->
  RetardedLowerBoundConclusion Phi
```

6. Only after V3 abstract M0C compiles, return to the concrete row28 seam and
   post-deletion member-wise construction.

## Non-Goals

This scoping pass does not:

- modify Lean;
- alter the certificate data;
- prove V3 arithmetic;
- prove row28 seam;
- instantiate concrete `Phi`;
- build `K2RetardedInductionInputsV3 concretePhi`;
- declare M1;
- make any global Collatz claim.

