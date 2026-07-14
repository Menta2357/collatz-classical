# KL2003 Concrete Phi Row28 Seam V3 Lean v1

## Scope

This pass migrated the already safe row28 concrete seam subcases from the
historical V2 contract to the source-faithful V3 contract.

No M1 theorem, no concrete `K2RetardedInductionInputsV3 concretePhi`, and no
global Collatz claim are introduced.

## Lean Changes

Updated:

```text
CollatzClassical/KL2003/KL2003ConcretePhiRealization.lean
CollatzClassical/KL2003/KL2003ConcretePhiRealizationAxiomAudit.lean
```

Added V3 row28 partial traffic:

```lean
row28_outer_block_v3_le_second
row28_outer_block_v3_le_child_mod2
row28_outer_block_v3_le_child_mod5
row28_pointwise_seam_v3_mod2
row28_pointwise_seam_v3_mod5
concretePhiRowsV3SeamObligation
```

The V3 mod2 and mod5 pointwise seams close because they use the outer second
branch:

```lean
concretePhi.phi22 (y + shiftAlphaMinus3Pad)
```

and do not inspect the internal `M1V3` arm.

## What Did Not Close

The full theorem:

```lean
concretePhi_row28_seam_v3
```

is not proved in this pass.

The full rows object:

```lean
concretePhi_rowsV3 : I2ELAbstractRowsV3 concretePhi
```

is also not proved.

The remaining blocker is the repeated class-8 advanced child case:

```lean
ht : (a.1 / 9) % 3 = 2
```

The required missing member-wise constructor is the V3 analogue of:

```lean
row28_outer_block_le_child_mod8
```

with `M1V3 concretePhi y`:

```lean
min
  (concretePhi.phi28 (y + shiftAlphaMinus3Pad) + M1V3 concretePhi y)
  (concretePhi.phi22 (y + shiftAlphaMinus3Pad))
<=
(piStar (row28AdvancedChild a.1)
  (concreteWindow (y + shiftAlphaMinus1Pad)
    (row28AdvancedChild a.1)) : Real)
```

This cannot be discharged by the direct `ciInf` traffic wrapper.  That wrapper
only gives the `phi28` component at the child window; it does not provide the
additional `M1V3` summand.  Reusing a future `concretePhi_row28_seam_v3` on the
same repeated class-8 child would be circular.

## Source-Faithful Status

V3 correctly uses:

```lean
M1V3 Phi y =
  min
    (Phi.phi28 (y + shift2AlphaMinus5Pad2) + M2V3 Phi y)
    (Phi.phi25 (y + shift2AlphaMinus5Pad2))
```

The concrete seam still needs the post-deletion Figure A1 member-wise
constructor for the repeated class-8 branch.  The local literal-word addendum
currently records that the constructor table is missing, so the correct
closure is partial.

## Verification

Commands run:

```text
lake build CollatzClassical.KL2003.KL2003ConcretePhiRealization
lake env lean CollatzClassical/KL2003/KL2003ConcretePhiRealizationAxiomAudit.lean
git diff --check
textual scan for forbidden Lean escape hatches in the touched Lean files
```

The build, audit, and diff check passed.  The textual scan returned no
matches in the touched Lean files.

## Classification

```text
ROW28_V3_CHILD_MOD2_POINTWISE_SEAM_PROVED
ROW28_V3_CHILD_MOD5_POINTWISE_SEAM_PROVED
ROW28_SEAM_V3_PARTIAL_LEAN_COMPILED
ROWS_V3_FULL_SEAM_NOT_YET_PROVED
BLOCKED_ON_POST_DELETION_ROW28_CLASS8_BRANCH_REALIZATION
BLOCKED_ON_ROW28_V3_MOD8_MEMBERWISE_CONSTRUCTOR
CONCRETEPHI_ROWS_V3_NOT_PROVED
K2_INPUTS_V3_NOT_YET_PROVED
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```
