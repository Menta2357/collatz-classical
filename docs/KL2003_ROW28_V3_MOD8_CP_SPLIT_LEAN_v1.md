# KL2003 Row28 V3 Mod8 CP Split Lean v1

## Scope

This corrective pass replaces the pre-meta-errata L1-L7 literal-table blocker
with the V3 source-faithful odd-child split under the repeated class-8 child.
The historical table recovery remains custody material, but it is not used as a
Lean hypothesis or operational dependency.

No M1 theorem or global Collatz claim is stated.

## Reclassified Blocker

Old operational blocker:

```text
BLOCKED_ON_MISSING_POST_DELETION_LITERAL_WORDS_FOR_V3_MOD8
```

New V3 blocker, now closed in Lean:

```text
ROW28_V3_MOD8_CP_SPLIT_REQUIRED
```

## CP Split

For a repeated class-8 child `c`, the proof introduces the next odd child:

```lean
row28CPrime a := row28AdvancedChild (row28AdvancedChild a)

row28_cprime_arith :
  a % 9 = 8 ->
  (a / 9) % 3 = 2 ->
  3 * row28CPrime a + 1 = 2 * row28AdvancedChild a
```

The proof then splits `(c / 9) % 3`.

`c'` class `2`:
the exterior `phi22` arm is paid directly by `c'`, then transferred into the
child subtree by `row28_cprime_piStar_le_child`.

`c'` class `5`:
the exterior `phi22` arm is paid through the retarded root `4*c'`, using the
already-proved row25 retarded transfer and then `row28_cprime_piStar_le_child`.

`c'` class `8`:
the first branch of the outer `min` is paid by two disjoint siblings under `c`:
the odd branch `c'` pays `phi28`, and the even branch `4*c` is class `5` and
pays `M1V3` through the `phi25` arm.

The proof never uses the old V2 `phi22` arm inside `M1`; V3 uses `phi25`.

## New Lean Layer

The following theorem family is now compiled in
`CollatzClassical/KL2003/KL2003ConcretePhiRealization.lean`:

```lean
row28CPrime
row28_cprime_arith
row28_cprime_window_le_child
row28_cprime_window_depth1_le_child
row28_retarded_window_shift2_le_child
row28_cprime_piStar_le_child
row28_cprime_retarded_piStar_le_child
row28_outer_block_v3_le_child_mod8_cprime_mod2
row28_outer_block_v3_le_child_mod8_cprime_mod5
row28_outer_block_v3_le_child_mod8_cprime_mod8
row28_outer_block_v3_le_child_mod8
row28_pointwise_seam_v3_mod8
concretePhi_row28_seam_v3
concretePhi_rowsV3
```

The final seam theorem is:

```lean
concretePhi_rowsV3 : I2ELAbstractRowsV3 concretePhi
```

It is assembled from existing row22/row25 seams and the new source-faithful
row28 V3 proof.

## Guardrails Checked

The proof does not use:

```text
concretePhi_row28_seam_v3
concretePhi_rowsV3
```

as hypotheses inside the member-wise mod8 construction.  The DAG remains
anticircular.

The proof does not count deleted nodes, does not use the L1-L7 table as a
hypothesis, and only sums siblings whose disjointness is supplied by the
existing M0B fiber/core machinery.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003ConcretePhiRealization
PASS

lake env lean CollatzClassical/KL2003/KL2003ConcretePhiRealizationAxiomAudit.lean
PASS
```

The audit reports the expected Lean/Mathlib axioms only:

```text
propext
Classical.choice
Quot.sound
```

## Classification

```text
ROW28_V3_MOD8_CP_SPLIT_PROVED
ROW28_V3_MOD8_CP_SPLIT_REQUIRED_CLOSED
ROW28_OUTER_BLOCK_V3_MOD8_PROVED
ROW28_POINTWISE_SEAM_V3_MOD8_PROVED
CONCRETEPHI_ROW28_SEAM_V3_PROVED
CONCRETEPHI_ROWS_V3_PROVED
L1_L7_TABLE_RECLASSIFIED_AS_HISTORICAL_PARTIAL_SOURCE
K2_INPUTS_V3_NOT_YET_PROVED
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```
