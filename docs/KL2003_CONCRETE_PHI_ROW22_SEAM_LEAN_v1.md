# KL2003 Concrete Phi Row22 Seam Lean v1

## Scope

This note records the Lean closure of the row22/D1 seam for the concrete
`Phi` realization.  It uses the previously proved traffic lemmas, the row22
parity lift layer, the D1 combinatorial core, and the V2 padded shift
`shiftAlphaMinus2Pad`.

It does not prove row28, the full `I2ELAbstractRowsV2 concretePhi`, any
`K2RetardedInductionInputsV2 concretePhi`, an M1 theorem, or a global Collatz
claim.

## Lean Additions

File:

- `CollatzClassical/KL2003/KL2003ConcretePhiRealization.lean`

Main theorem:

```lean
theorem concretePhi_row22_seam :
    forall y, 14 <= y ->
      concretePhi.phi28 (y - 2)
        + min3
            (concretePhi.phi22 (y + shiftAlphaMinus2Pad))
            (concretePhi.phi25 (y + shiftAlphaMinus2Pad))
            (concretePhi.phi28 (y + shiftAlphaMinus2Pad))
        <= concretePhi.phi22 y
```

Supporting lemmas added:

- `two_rpow_alpha`
- `two_rpow_alpha_sub_one`
- `row22_pad_power_mul_child_le_root`
- `row22_advanced_window_le_target`
- `row22_shiftAlphaMinus2Pad_nonneg`
- `notInCycle_eleven`
- `classRoots_two_nonempty`
- `row22_retarded_classRoot`
- `row22_min3_le_lifted_child`
- `row22_min3_le_direct_advanced`
- `row22_piStar_sum_le_target`

## Proof Structure

The retarded branch transfers from root `4*a`, whose residue is `8 mod 9`,
using the exact window identity already proved for the retarded branch.

The advanced branch uses the direct D1 child `c = row22AdvancedChild a`, then
the parity lift `2*c -> c`.  The exact parity window identity
`concreteWindow (z - 1) (2*c) = concreteWindow z c` supplies the extra `-1`
shift.  The padded window comparison is discharged by
`row22_advanced_window_le_target`, using `2^alpha = 3` and the positive
`epsilon0` slack.

The lifted child residue split into `{2,5,8}` feeds the `min3` term through the
existing `concretePhiComponent` upper wrappers.

## Verification

Commands:

```bash
lake build CollatzClassical.KL2003.KL2003ConcretePhiRealization
lake env lean CollatzClassical/KL2003/KL2003ConcretePhiRealizationAxiomAudit.lean
git diff --check
textual guardrail scan over the touched Lean files
```

Status:

- `lake build`: PASS
- axiom audit: PASS; printed only standard dependencies already present in this
  layer, namely `propext`, `Classical.choice`, and `Quot.sound`
- `git diff --check`: PASS
- textual guardrail scan: PASS, no occurrences found

## Classifications

- `ROW22_RETARDED_BRANCH_TRANSFER_PROVED`
- `ROW22_ADVANCED_PARITY_LIFT_CONSUMED`
- `ROW22_PADDED_WINDOW_TRANSFER_PROVED`
- `ROW22_MIN3_TRANSFER_PROVED`
- `ROW22_SEAM_PROVED`
- `ROW28_NESTED_CASE_ANALYSIS_NOT_STARTED`
- `ROWS_V2_FULL_SEAM_NOT_YET_PROVED`
- `K2_INPUTS_V2_NOT_YET_PROVED`
- `NO_M1_THEOREM`
- `NO_GLOBAL_COLLATZ_CLAIM`
