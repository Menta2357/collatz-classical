# KL2003 Row28 V3 Literal Word Table Recovery v1

## Scope

This pass attempted to recover the missing constructor-only table needed for
the row28 V3 repeated-class-8 blocker:

```text
L1-L7 -> inverse word -> Nat root formula -> residue/class ->
fiber/deletion boundary -> row28 V3 consumer
```

No Lean proof was added.  No `row28_outer_block_v3_le_child_mod8`,
`concretePhi_row28_seam_v3`, M1 theorem, or global Collatz claim is made.

## Output

Created:

```text
outputs/KL2003_ROW28_V3_LITERAL_WORD_TABLE_RECOVERY_v1/literal_word_table.csv
```

The CSV has one row for each of L1-L7 and includes:

```text
literal_id
parent_depth
normalized_literal
target_class
normalized_shift
figure_node_id
figure_label
figure_path_node_ids
source_status
inverse_word
inverse_word_status
nat_root_formula
nat_root_formula_status
required_side_conditions
counted_or_deleted
deletion_boundary_status
consumer_lemma_expected
row28_v3_consumer
notes
```

The CSV parses successfully:

```text
csv_ok 7 19
```

## Sources Reviewed

Local sources and extracted artifacts reviewed:

```text
docs/KL2003_ROW28_MOD8_EL_TREE_MEMBER_INJECTION_SCOPING_v1.md
docs/KL2003_ROW28_MOD8_EL_TREE_LITERAL_WORDS_ADDENDUM_v1_1.md
docs/KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_AUDIT_v1.md
docs/KL2003_DELETION_RULE_SOURCE_AUDIT_v1.md
docs/KL2003_ROW28_POST_DELETION_PATTERN_LEDGER_v1.md
outputs/KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1/nodes.csv
outputs/KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1/edges.csv
outputs/KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1/root_paths.csv
/Users/MoiTam/Documents/Codex/2026-07-05/tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/kl2003_src/30apr02.tex
/Users/MoiTam/Documents/Codex/2026-07-05/tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/kl2003_src/kafgA1.pstex
/Users/MoiTam/Documents/Codex/2026-07-05/tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/kl2003_src/kafgA1.pstex_t
```

## What Was Recovered

The following data is source-backed:

- Figure A1 directed graph geometry from `kafgA1.pstex`.
- Figure A1 labels from `kafgA1.pstex_t`.
- Cross/deletion marks on nodes `N04` and `N05`.
- Root-to-node graph paths from the existing Figure A1 CSVs.
- The final normalized row28 V3 algebraic formula from `30apr02.tex`.
- The deletion-rule source location and meaning.

These are recorded in the CSV with source statuses such as:

```text
SOURCE_TRANSCRIBED_LABEL_AND_GRAPH_PATH
SOURCE_TRANSCRIBED_NORMALIZED_TEXT_TABLE
SOURCE_TRANSCRIBED_TEXT_M1_PHI5
GRAPH_LABEL_SHIFT_MISMATCH_RECORDED
```

## What Was Not Recovered

The constructor-only columns remain blocked:

```text
inverse_word
Nat root formula
literal-specific first-entry boundary
literal-specific deletion/boundary correction
member-wise Finset population
```

The local source files do not contain edge labels in `{e,o}`, inverse Collatz
words, or Nat root formulas.  The PSTeX graph stores geometry and arrows; the
TeX overlay stores algebraic labels.  Neither source records the finite
constructor table needed for a member-wise `piStarFinset` proof.

## Important Normalization Caution

The CSV separates:

```text
normalized_literal
figure_node_id / figure_label
```

because the final row formula and the visible Figure A1 node labels are not
identical in all shifts.  For example:

- L2 is normalized as `phi_2^2(y+alpha-3)`, while the visible graph path uses
  an intermediate node labelled `(2, alpha-1)`.
- L4 is normalized as the V3 source-faithful `phi_2^5(y+2alpha-5)`, while
  Figure A1 has a visible node `N11` labelled `(5, 2alpha-3)`.

These are not resolved by guessing.  They are recorded as ledger/normalization
issues that the constructor recovery must handle explicitly.

## Hook Status

No member-wise empirical hook was run.

Reason: the hook requires at least:

```text
literal id
inverse word
Nat root formula
forward path / parent tag
window shift
expected residue
deletion or boundary rule
```

The recovered CSV still lacks inverse words and Nat formulas.  Running the hook
without those fields would validate only algebraic labels, not the constructor
data needed by Lean.

## Lean Consequence

The blocker remains:

```text
BLOCKED_ON_MISSING_POST_DELETION_LITERAL_WORDS_FOR_V3_MOD8
BLOCKED_ON_MEMBERWISE_FINSET_POPULATIONS_L1_L7
BLOCKED_ON_DELETION_RULE_LITERAL_BOUNDARIES_L1_L7
```

The theorem that should not yet be proved is:

```lean
row28_outer_block_v3_le_child_mod8
```

The next legitimate route is one of:

1. locate an Applegate/KL generator artifact that records the finite edge
   words for Figure A1;
2. locate an older March reconstruction artifact containing the literal root
   formulas;
3. explicitly open a new reconstruction task from the KL splitting/deletion
   rules, marked as reconstruction rather than transcription.

## Verification

Commands run:

```text
python3 -c "import csv, pathlib; ..."
git diff --check
```

No new script was added, so `python3 -m py_compile` is not applicable in this
pass.

## Classification

```text
ROW28_V3_LITERAL_WORD_TABLE_RECOVERY_ATTEMPTED
FIGURE_A1_LABELS_AND_PATHS_CUSTODIED
POST_DELETION_CONSTRUCTOR_DATA_NOT_READY
BLOCKED_ON_MISSING_POST_DELETION_LITERAL_WORDS_FOR_V3_MOD8
BLOCKED_ON_MEMBERWISE_FINSET_POPULATIONS_L1_L7
BLOCKED_ON_DELETION_RULE_LITERAL_BOUNDARIES_L1_L7
MEMBERWISE_HOOK_NOT_RUN
ROW28_V3_MOD8_LEAN_NOT_READY
NO_NEW_LEAN_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```
