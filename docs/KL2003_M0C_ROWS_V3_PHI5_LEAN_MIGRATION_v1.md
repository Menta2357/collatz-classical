# KL2003 M0C Rows V3 Phi5 Lean Migration v1

Date: 2026-07-13

Repository: `https://github.com/Menta2357/collatz-classical`

## Scope

This pass migrates the abstract M0C layer to a source-faithful V3 row contract
after the meta-errata:

```text
M1 phi5 reinstated
```

The concrete row28 seam is not touched.  No `K2RetardedInductionInputsV3
concretePhi` is built.  No M1 theorem or global Collatz claim is made.

## Classification

```text
M0C_ROWS_V3_DEFINED
M1V3_PHI25_ARM_IMPLEMENTED
V2_RETAINED_AS_ABSTRACT_ONLY
V3_ARITH_RECHECK_PROVED
ROW28_ASSEMBLY_V3_PROVED
M0C_MAIN_INDUCTION_V3_PROVED
AXIOM_AUDIT_V3_PASS
CONCRETE_SEAM_NOT_TOUCHED
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Lean Changes

Updated:

```text
CollatzClassical/KL2003/KL2003M0CRetardedInduction.lean
CollatzClassical/KL2003/KL2003M0CRetardedInductionAxiomAudit.lean
```

V2 was retained.  Its comment now records that it remains an abstract theorem
target but is no longer the source-faithful KL2003 row28 contract after the
meta-errata.

## V3 Contract

Added:

```lean
M2V3
M1V3
I2ELAbstractRowsV3
K2RetardedInductionInputsV3
k2_retarded_inputs_v3_from_closed_certificate
```

The source-faithful change is:

```lean
M1V3 Phi y =
  min
    (Phi.phi28 (y + shift2AlphaMinus5Pad2) + M2V3 Phi y)
    (Phi.phi25 (y + shift2AlphaMinus5Pad2))
```

The conclusion was not duplicated:

```lean
RetardedLowerBoundConclusion Phi
```

## Arithmetic Recheck

Added V3 analogues:

```lean
m2v3_c12_shift3_lower
m2v3_nonneg
M2V3_lower
m1v3_c12_shift2_lower
M1V3_lower
row28_m1_v3_block_lower
row28_first_branch_lower_v3
row28_padded_block_lower_v3
row28_assembly_v3
```

The new `M1V3` second branch uses `c12R_le_c25R`, matching the reinstated
`phi25` arm.  The existing `EL_A` remains available for the outer row28
`phi22(y + alpha - 3 - pad)` branch, but is no longer the `M1` second-arm
margin.

Reused unchanged:

```lean
EL_C
c12R_le_c25R
padded_row28_arithmetic
row28_target_le_coeff_sum
lambda_neg_three_epsilon_ge
row22_assembly
row25_assembly
retardedRank_drop_* lemmas
```

## Main Induction

Added:

```lean
m0c_retarded_induction_bound_v3_nonneg
m0c_retarded_induction_bound_v3
```

The V3 proof reuses the same `M0CInductionQ` and `retardedRank` strong
induction structure as V2.  The only substantive consumer change is:

```lean
row28_assembly_v3
```

with the `shift2AlphaMinus5Pad2` induction hypothesis supplied through
`Phi25LowerBoundAt` for the new `phi25` branch.

## Verification

Executed:

```text
lake build CollatzClassical.KL2003.KL2003M0CRetardedInduction
lake env lean CollatzClassical/KL2003/KL2003M0CRetardedInductionAxiomAudit.lean
```

Result:

```text
LEAN_BUILD_PASS = yes
AXIOM_AUDIT_V3_PASS = yes
```

The audit reports only the usual Mathlib/Real dependencies:

```text
propext
Classical.choice
Quot.sound
```

Guardrail scan:

```text
NO_SORRY = yes
NO_ADMIT = yes
NO_UNSAFE = yes
NO_NATIVE_DECIDE = yes
```

## Non-Goals

This pass does not:

- touch `KL2003ConcretePhiRealization.lean`;
- prove row28 concrete seam;
- construct `K2RetardedInductionInputsV3 concretePhi`;
- remove V2;
- declare M1;
- make any global Collatz claim.

