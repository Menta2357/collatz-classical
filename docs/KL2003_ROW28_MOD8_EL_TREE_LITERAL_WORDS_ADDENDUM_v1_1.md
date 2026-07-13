# KL2003 Row28 Mod8 EL Tree Literal Words Addendum v1.1

## Scope

This addendum addresses the declared gap in:

```text
docs/KL2003_ROW28_MOD8_EL_TREE_MEMBER_INJECTION_SCOPING_v1.md
```

The requested goal was to materialize the seven row28/mod8 EL literals
`L1`--`L7` as:

```text
literal -> inverse word -> Nat root formula -> forward route -> residue ->
window/boundary correction
```

No Lean is created in this pass.  No row28 seam theorem is claimed.

## Classification

```text
ROW28_MOD8_LITERAL_WORDS_ADDENDUM_CREATED
BLOCKED_ON_MISSING_KL2003_LITERAL_WORD_TABLE
BLOCKED_ON_LITERAL_ROOT_FORMULA_L1
BLOCKED_ON_LITERAL_ROOT_FORMULA_L2
BLOCKED_ON_LITERAL_ROOT_FORMULA_L3
BLOCKED_ON_LITERAL_ROOT_FORMULA_L4
BLOCKED_ON_LITERAL_ROOT_FORMULA_L5
BLOCKED_ON_LITERAL_ROOT_FORMULA_L6
BLOCKED_ON_LITERAL_ROOT_FORMULA_L7
BLOCKED_ON_DELETION_RULE_FOR_L1
BLOCKED_ON_DELETION_RULE_FOR_L2
BLOCKED_ON_DELETION_RULE_FOR_L3
BLOCKED_ON_DELETION_RULE_FOR_L4
BLOCKED_ON_DELETION_RULE_FOR_L5
BLOCKED_ON_DELETION_RULE_FOR_L6
BLOCKED_ON_DELETION_RULE_FOR_L7
HOOK_READY_FOR_CLAUDE = no
NO_NEW_LEAN
ROW28_MOD8_M1_TRANSFER_NOT_PROVED
ROW28_SEAM_PROVED = no
K2_INPUTS_V2_NOT_YET_PROVED
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Not assigned:

```text
T2_8_EL_LITERAL_WORDS_TRANSCRIBED
L1_L7_NAT_ROOT_FORMULAS_DEFINED
L1_L7_FORWARD_ROUTES_DEFINED
L1_L7_RESIDUES_VERIFIED_ON_PAPER
DELETION_RULE_BOUNDARY_CORRECTIONS_RECORDED
HOOK_READY_FOR_CLAUDE
```

## Source Audit

Local KL2003 source inspected:

```text
/Users/MoiTam/Documents/Codex/2026-07-05/tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/kl2003_src/30apr02.tex
/Users/MoiTam/Documents/Codex/2026-07-05/tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/kl2003_src/kafg3.pstex_t
/Users/MoiTam/Documents/Codex/2026-07-05/tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/kl2003_src/kafgA1.pstex_t
```

Local reconstruction inspected:

```text
docs/KRASIKOV_M1_FEASIBILITY_RECONSTRUCTION_REPORT_v1.md
docs/KL2003_ROW28_MOD8_EL_TREE_MEMBER_INJECTION_SCOPING_v1.md
```

What was located:

- KL2003 Appendix for `k=2`.
- Figure A1 / `kafgA1.pstex_t`, labelled as tree `T_2^8(EL)`.
- Table 4 / `L_2^EL`.
- The general deletion rule for labelled EL trees.
- The already reconstructed normalized row `I_2^8(EL)`.

What was not located:

- a constructor-level table of inverse words for L1--L7;
- Nat formulas for literal roots as functions of the class-8 child parameter;
- forward routes for each literal to its immediate EL parent;
- literal-specific deletion/boundary corrections sufficient for a member-wise
  empirical hook.

## Located Algebraic Tree

The located Appendix tree gives labels and shifts only.  The normalized
row is:

```text
phi_2^8(y) >=
  phi_2^5(y-2)
  + min[
      phi_2^8(y+alpha-3) + M_1(y),
      phi_2^2(y+alpha-3)
    ],

M_1(y) =
  min[
    phi_2^8(y+2alpha-5) + M_2(y),
    phi_2^5(y+2alpha-5)
  ],

M_2(y) =
  min[
    phi_2^2(y+3alpha-5),
    phi_2^5(y+3alpha-5),
    phi_2^8(y+3alpha-5)
  ].
```

The labels visible in `kafgA1.pstex_t` include the non-final/deleted
intermediate labels:

```text
(2, alpha - 1)
(5, alpha - 1)
(8, alpha - 1)
(2, 2alpha - 3)
(5, 2alpha - 3)
(8, 2alpha - 3)
```

and the final EL leaves:

```text
(5, -2)
(8, alpha - 3)
(2, alpha - 3)
(8, 2alpha - 5)
(2, 2alpha - 5)
(2, 3alpha - 5)
(5, 3alpha - 5)
(8, 3alpha - 5)
```

This is enough for the algebraic EL row and the LP table.  It is not enough
for constructor-only member-wise `piStar` injections.

## L0 Exclusion

`L0` is the retarded side:

```text
L0 = phi_2^5(y-2)
```

It belongs to the side already covered by the row28 retarded branch and is
not part of the blocker:

```lean
row28_outer_block_le_child_mod8
```

The current blocker is only the class-8 advanced child subtree and its
EL block L1--L7.

## Required Literal Table Status

The following table records the exact required columns and why each row is
blocked.  Algebraic labels are transcribed; constructor columns are not
filled because they were not present in the located KL2003/reconstruction
sources.

| literal | algebraic label | class | depth | inverse word | Nat root formula | forward route | residue proof | parameter split | window/shift | deletion/boundary status |
|---:|---|---:|---:|---|---|---|---|---|---|---|
| L1 | `phi_2^8(y+alpha-3)` | 8 | 1 | blocked: not in located table | blocked | blocked | blocked | blocked | `shiftAlphaMinus3Pad` | generic deletion rule located; literal-specific correction missing |
| L2 | `phi_2^2(y+alpha-3)` | 2 | 1 | blocked: not in located table | blocked | blocked | blocked | blocked | `shiftAlphaMinus3Pad` | generic deletion rule located; literal-specific correction missing |
| L3 | `phi_2^8(y+2alpha-5)` | 8 | 2 | blocked: not in located table | blocked | blocked | blocked | blocked | `shift2AlphaMinus5Pad2` | generic deletion rule located; literal-specific correction missing |
| L4 | `phi_2^5(y+2alpha-5)` | 5 | 2 | blocked: not in located table | blocked | blocked | blocked | blocked | `shift2AlphaMinus5Pad2` | generic deletion rule located; literal-specific correction missing |
| L5 | `phi_2^2(y+3alpha-5)` | 2 | 3 | blocked: not in located table | blocked | blocked | blocked | blocked | `shift3AlphaMinus5Pad3` | generic deletion rule located; literal-specific correction missing |
| L6 | `phi_2^5(y+3alpha-5)` | 5 | 3 | blocked: not in located table | blocked | blocked | blocked | blocked | `shift3AlphaMinus5Pad3` | generic deletion rule located; literal-specific correction missing |
| L7 | `phi_2^8(y+3alpha-5)` | 8 | 3 | blocked: not in located table | blocked | blocked | blocked | blocked | `shift3AlphaMinus5Pad3` | generic deletion rule located; literal-specific correction missing |

## Why Labels Are Insufficient

The pair `(residue, shift)` is an EL tree label.  It does not uniquely give:

- the inverse word in `even/preimage` and `odd/preimage` steps;
- the Nat root formula under the current class-8 child parameter;
- the immediate parent tag used by the first-entry fiber argument;
- which intermediate nodes were deleted and what boundary correction is
  charged at that literal.

Those columns are exactly what the future member-wise empirical hook needs.
Filling them from ratios or from the final shifts would be an unaudited
reconstruction, not a transcription.

## No Adivinanza

This addendum deliberately does not derive formulas by guesswork.

The located KL2003 Appendix and the March reconstruction provide the algebraic
EL tree and LP labels.  They do not provide the requested constructor table.
Naive size ratios are not enough here because the proof obligation is
member-wise and depends on:

- the exact inverse word;
- the exact forward parent of each literal;
- the first-entry predecessor tag;
- the deletion rule and boundary correction at that node.

Thus no Nat root formula is recorded for L1--L7 in this pass.

## Hook Readiness

The empirical hook proposed in the scoping page is not yet ready.

Columns available from the current sources:

```text
literal_id
algebraic_label
expected_residue_class
EL_depth
abstract_shift
```

Columns still missing:

```text
inverse_word
root_formula
forward_path
parent_tag
literal_specific_deletion_or_boundary_correction
parameter_split_for_root_formula
```

Claude should not run the member-wise hook as a validation of L1--L7 until
these missing columns are supplied from a reliable constructor source.

## Next Required Source

To unblock the constructor-only pass, we need one of:

1. an Applegate/KL generator output for `T_2^8(EL)` that records literal
   inverse words;
2. a March reconstruction artifact that already contains the missing
   `literal -> word -> Nat formula` table;
3. explicit approval to build a new generator/verifier reconstruction from
   the KL splitting/deletion rules, marked as reconstruction rather than
   transcription.

Until one of these is available, the correct status remains:

```text
BLOCKED_ON_MISSING_KL2003_LITERAL_WORD_TABLE
```
