# KL2003 Concrete Phi Row28 Nested Seam Lean v1

## Scope

This pass opened the concrete row28/D3 seam in Lean and closed the reusable
traffic and two non-recursive child cases.  It did not prove the full row28EL
seam theorem.

No `I2ELAbstractRowsV2 concretePhi`, no `K2RetardedInductionInputsV2
concretePhi`, no M1 theorem, and no global Collatz claim are introduced.

## Lean Additions

File:

- `CollatzClassical/KL2003/KL2003ConcretePhiRealization.lean`

Closed arithmetic and class infrastructure:

- `row28AdvancedChild`
- `row28_root_decomp`
- `row28_advanced_child_arith`
- `row28_advanced_child_maps_to_root`
- `row28_advanced_child_notInCycle`
- `row28_advanced_child_residue_mod_9_of_root_t_mod_0`
- `row28_advanced_child_residue_mod_9_of_root_t_mod_1`
- `row28_advanced_child_residue_mod_9_of_root_t_mod_2`
- `row28_advanced_child_classRoot_mod5`
- `row28_advanced_child_classRoot_mod2`
- `row28_advanced_child_classRoot_mod8`
- `row28_retarded_classRoot`

Closed window/core traffic:

- `row28_pad_power_mul_child_le_root`
- `row28_advanced_window_le_target`
- `row28_piStar_sum_le_target`
- `row28_retarded_le_piStar_source`

Closed nested-block child cases:

- `row28_outer_block_le_child_mod2`
- `row28_outer_block_le_child_mod5`
- `row28_pointwise_seam_mod2`
- `row28_pointwise_seam_mod5`

These two pointwise seam lemmas prove the row28EL target inequality for roots
`a : ClassRoots 8` when the advanced child falls into class `2` or `5`.

## Remaining Blocker

The unclosed case is:

```lean
ht : (a.1 / 9) % 3 = 2
```

so:

```lean
row28AdvancedChild a.1 % 9 = 8
```

The missing consumer is a nested transfer for the class-8 advanced child:

```lean
min
  (concretePhi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 concretePhi y)
  (concretePhi.phi22 (y + shiftAlphaMinus3Pad))
<=
(piStar (row28AdvancedChild a.1)
  (concreteWindow (y + shiftAlphaMinus1Pad)
    (row28AdvancedChild a.1)) : Real)
```

under:

```lean
14 <= y
a : ClassRoots 8
(a.1 / 9) % 3 = 2
```

The naive second-arm route does not close: `phi22(y + shiftAlphaMinus3Pad)`
does not directly provide a related class-2 source inside the class-8 child
subtree for all roots.  The naive first-arm route also does not close, because
`phi28(...) + M1V2 ...` is a sum and therefore cannot be bounded by the direct
`phi28` wrapper alone.  A genuine nested `M1V2/M2V2` semantic transfer is still
needed.

## Verification

Commands:

```bash
lake build CollatzClassical.KL2003.KL2003ConcretePhiRealization
```

Status:

- `lake build`: PASS for the partial row28 layer
- axiom audit: PASS; printed only standard dependencies already present in this
  layer, namely `propext`, `Classical.choice`, and `Quot.sound`
- `git diff --check`: PASS
- textual guardrail scan over touched Lean files: PASS

## Classifications

- `ROW28_ADVANCED_CHILD_ARITH_PROVED`
- `ROW28_CHILD_RESIDUE_SPLIT_PROVED`
- `ROW28_CHILD_NOTINCYCLE_PROVED`
- `ROW28_PADDED_WINDOW_TRANSFER_PROVED`
- `ROW28_CHILD_MOD2_POINTWISE_SEAM_PROVED`
- `ROW28_CHILD_MOD5_POINTWISE_SEAM_PROVED`
- `BLOCKED_ON_ROW28_NESTED_M1_TRANSFER`
- `ROW28_SEAM_PROVED = no`
- `ROWS_V2_FULL_SEAM_NOT_YET_PROVED`
- `K2_INPUTS_V2_NOT_YET_PROVED`
- `NO_M1_THEOREM`
- `NO_GLOBAL_COLLATZ_CLAIM`
