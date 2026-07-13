# KL2003 Concrete Phi Row28 Mod8 M1 Transfer Lean v1

## Scope

This pass targeted only the remaining row28 case:

```lean
ht : (a.1 / 9) % 3 = 2
```

so the direct advanced child of a class-8 root is again class `8`.

No full row28 seam theorem, no full rowsV2 seam, no K2 inputs construction, no
M1 theorem, and no global Collatz claim are introduced.

## Reused Closed Layer

The following Lean layer is already compiled and remains the active base:

- `row28AdvancedChild`
- `row28_advanced_child_arith`
- `row28_advanced_child_residue_mod_9_of_root_t_mod_2`
- `row28_advanced_child_classRoot_mod8`
- `row28_advanced_child_notInCycle`
- `row28_advanced_window_le_target`
- `row28_piStar_sum_le_target`
- `row28_pointwise_seam_mod2`
- `row28_pointwise_seam_mod5`

## Exact Missing Lemma

The target needed for the mod8 case is:

```lean
row28_outer_block_le_child_mod8 :
  14 <= y ->
  (a : ClassRoots 8) ->
  (a.1 / 9) % 3 = 2 ->
  min
    (concretePhi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 concretePhi y)
    (concretePhi.phi22 (y + shiftAlphaMinus3Pad))
  <=
  (piStar (row28AdvancedChild a.1)
    (concreteWindow (y + shiftAlphaMinus1Pad)
      (row28AdvancedChild a.1)) : Real)
```

If this lemma closes, `row28_pointwise_seam_mod8` follows by the same D3 core
assembly already used for the mod2 and mod5 cases.

## Blocker

The direct class-root wrapper for the mod8 child gives:

```lean
concretePhi.phi28 (y + shiftAlphaMinus1Pad)
  <= piStar child (concreteWindow (y + shiftAlphaMinus1Pad) child)
```

and monotonicity gives:

```lean
concretePhi.phi28 (y + shiftAlphaMinus3Pad)
  <= concretePhi.phi28 (y + shiftAlphaMinus1Pad)
```

but the first outer row28EL arm is:

```lean
concretePhi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 concretePhi y
```

The extra `M1V2` summand is not discharged by the existing traffic wrappers.
Using `concretePhi_row28_seam` recursively on the class-8 child would be
circular.  A new finite EL-tree member-wise injection is required inside the
class-8 child subtree.

## Classification

- `BLOCKED_ON_ROW28_M1V2_MEMBER_TRANSFER`
- `BLOCKED_ON_ROW28_CIRCULARITY_GUARD`
- `ROW28_MOD8_M1_TRANSFER_PROVED = no`
- `ROW28_POINTWISE_MOD8_PROVED = no`
- `ROW28_SEAM_PROVED = no`
- `ROWS_V2_FULL_SEAM_NOT_YET_PROVED`
- `K2_INPUTS_V2_NOT_YET_PROVED`
- `NO_M1_THEOREM`
- `NO_GLOBAL_COLLATZ_CLAIM`

## Verification

The Lean file still compiles with the documented blocker section.  Full
commands and results are recorded in the task closeout.
