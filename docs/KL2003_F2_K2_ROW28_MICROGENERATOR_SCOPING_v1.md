# KL2003 F2 k=2 Row28 Microgenerator Scoping v1

Date: 2026-07-19

Status: `K2_ROW28_MICROGENERATOR_SCOPED`

## Purpose

This note scopes the third k=2 regression microgenerator in the F2 track:
`row28`.

The row25 microgenerator tested one rule-derived single-branch row.  The row22
microgenerator added the parity-lift mechanism.  `row28` is the strong k=2
regression test because it is the first row whose generated data must represent
the source-faithful V3 nested EL behavior, deletion/post-deletion behavior, and
the class-8 `cPrime` split.

This scoping intentionally fuses the earlier "row28 microgenerator" step with
the Figure A1 tree-diff step.  For row28, deletion behavior is not a side audit;
it is part of the generated row contract.

This pass is documentation only.  It does not implement the row28 generator,
does not open Lean, does not generate k=3 data, does not solve an LP, and does
not claim any high-k theorem.

## Why Row28

`row28` is the final k=2 row and the main guardrail before any k=3 generation.

It is the right third microgenerator target because it introduces:

- the D3/two-branch combinatorial shape;
- deletion rule and post-deletion behavior;
- nested `M1V3` / `M2V3` structure;
- the direct advanced child split `c % 9 in {5,2,8}`;
- the repeated class-8 `cPrime` split;
- sibling-only sums under distinct entry fibers;
- the source-faithful meta-errata requirement that `M1V3` uses `phi25`, not
  the historical V2 `phi22` arm.

Manual Lean baseline:

```lean
concretePhi_row28_seam_v3 :
  forall y, 14 <= y ->
    concretePhi.phi25 (y - 2)
      + min
          (concretePhi.phi28 (y + shiftAlphaMinus3Pad) + M1V3 concretePhi y)
          (concretePhi.phi22 (y + shiftAlphaMinus3Pad))
      <= concretePhi.phi28 y

concretePhi_rowsV3 : I2ELAbstractRowsV3 concretePhi
```

The manual proof is a regression oracle only.  The generator must not copy its
terms from the theorem statement or proof script.

Baseline references:

```text
docs/KL2003_ROW28_V3_MOD8_CP_SPLIT_AND_ROWSV3_FINAL_LEAN_v1.md
docs/KL2003_CONCRETE_PHI_ROW28_SEAM_V3_LEAN_v1.md
docs/KL2003_META_ERRATA_M1_PHI5_REINSTATEMENT_v1.md
docs/KL2003_DELETION_RULE_SOURCE_AUDIT_v1.md
docs/KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_AUDIT_v1.md
CollatzClassical/KL2003/KL2003ConcretePhiRealization.lean
outputs/KL2003_F2_K2_GENERATOR_REGRESSION_BASELINE_v1/expected_rows_v3.csv
outputs/KL2003_F2_K2_GENERATOR_REGRESSION_BASELINE_v1/certificate_constants.csv
```

## Source Of Derivation

The row28 microgenerator must derive its data from parametric rules:

- KL2003 TeX splitting/deletion rules;
- post-deletion tree rules;
- residue arithmetic;
- inverse-route construction;
- window and pad policies;
- rational certificate constants already custodied as baseline values.

The deletion rule must be implemented from the source-parametric form, not from
the final crossed-node list.  The current source custody note records:

```text
30apr02.tex lines 763-779: deletion rule definition
30apr02.tex lines 896-907: deletion-step proof setup
30apr02.tex lines 967-1006: totally-non-critical justification
```

The operative rule is:

```text
same mode earlier on path + smaller shift => delete current leaf
```

The implementation pass should confirm the exact line range and source hash
again before coding the rule.  If the TeX-derived deletion rule cannot be
located or parameterized, classify:

```text
BLOCKED_ON_DELETION_RULE_SOURCE
```

Figure A1 and `root_paths.csv` are allowed as k=2 regression custody:

```text
outputs/KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1/root_paths.csv
```

They are not the sole source of generation.  The generator should use them to
confirm that the rule-derived row28 artifact matches the source transcription,
not to hardcode the final row shape.

Regression-only sources:

- `concretePhi_row28_seam_v3`;
- `row28_*` manual Lean theorem names;
- `concretePhi_rowsV3`;
- `expected_rows_v3.csv`;
- certificate constants CSV.

The baseline is a test oracle.  It is not the generator source.

If the implementation emits row28 by copying the manual V3 theorem or baseline
row and labels it rule-derived, classify it as:

```text
ROW28_MICROGENERATOR_FAIL_BASELINE_USED_AS_SOURCE
```

## Figure A1 Regression Oracle

The generated deletion decisions must match the Figure A1 oracle exactly for
k=2 row28.

Expected crossed/deleted nodes from current custody:

```text
N04: (8, alpha - 1)
N05: (8, 2*alpha - 3)
```

Both appear as crossed class-8 nodes in:

```text
outputs/KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1/root_paths.csv
docs/KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_AUDIT_v1.md
docs/KL2003_DELETION_RULE_SOURCE_AUDIT_v1.md
```

The row28 validation layer must include a tree diff:

```text
generated_deleted_nodes vs FigureA1/root_paths.csv deleted nodes
```

Required verdict:

```text
FIGURE_A1_DELETION_DIFF_PASS
```

Blocker:

```text
ROW28_DELETION_RULE_FAIL
```

if the generator deletes more nodes, fewer nodes, or different nodes than the
Figure A1 oracle in k=2 regression mode.

This oracle is a regression check only.  The generator must still derive
deletion from the parametric rule.

## EL Termination Rule

The row28 generator must not hardcode "depth 3" as a k=2 accident.

Before implementation, the generator pass must extract the rule that determines
where the EL tree expansion stops.  The scoping candidates are:

- depth fixed by the LP/system definition;
- exhaustion by deletion;
- explicit `T_k^m(EL)` construction limit;
- another paper rule in the KL2003 TeX source.

The row28 artifact should record:

```text
termination_rule_source
termination_rule_kind
termination_rule_line_range
termination_rule_sha256
```

If the source rule is not clear, do not implement row28.  Classify:

```text
BLOCKED_ON_EL_TERMINATION_RULE_SOURCE
```

### Deletion Saturation Experiment Update

The k=2 row28 deletion-saturation experiment now executes the source-parametric
expansion rule and deletion rule to a fixed point, then compares the generated
tree against Figure A1/root_paths as an oracle:

```text
scripts/kl2003_f2_k2_row28_deletion_saturation_experiment_v1.py
outputs/KL2003_F2_K2_ROW28_DELETION_SATURATION_EXPERIMENT_v1/
```

Result:

```text
verdict = ROW28_DELETION_SATURATION_FIGURE_A1_PASS
generated_node_count = 16
generated_edge_count = 15
deleted_node_count = 2
figure_a1_mismatch_count = 0
rounds = 3
```

This removes the k=2 row28 operational uncertainty:

```text
K2_DELETION_SATURATION_ORACLE_VALIDATED
```

It does not prove a general-k saturation theorem:

```text
GENERAL_K_DELETION_SATURATION_UNPROVED
```

## Schema v2 Nested EL Check

The current high-k certificate format v2 must be checked against row28 before
implementation.  Row28 requires nested blocks:

```text
M1V3
M2V3
min
min3
post-deletion replacement branches
deleted structural nodes
counted sibling groups
```

If schema v2 can represent this with existing `rows`, `children`,
`deletion_marks`, `coefficient_terms`, and nested auxiliary row/block metadata,
the row28 generator should document the mapping in its summary.

If schema v2 cannot represent nested EL blocks without ad hoc fields, introduce
a documented schema amendment first:

```text
KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2_1
```

Required pre-implementation classification:

```text
NESTED_EL_SCHEMA_CHECK_PASS
```

or blocker:

```text
BLOCKED_ON_NESTED_EL_SCHEMA_REPRESENTATION
```

The generator must not emit JSON outside the active contract.

## Mathematical Inputs

### Root Class

Input class:

```text
a % 9 = 8
```

The generated row should record:

```text
row_id = row28
source_class = 28
tracked_residue_mod9 = 8
row_family = D3 / EL
generation_mode = rule_derived_row28
mathematical_generation = true
proof_status = data_candidate_only
```

### Retarded Branch

Retarded source:

```text
4 * a
```

For `a % 9 = 8`, the class transfer is:

```text
(4 * a) % 9 = 5
```

The generated row should route the retarded branch to `phi25` with exact
retarded shift:

```text
shift = -2
window_policy = exact_retarded_window
window_identity = concreteWindow (y - 2) (4*a) = concreteWindow y a
rounding_loss = 0
```

This is the first arm of the V3 row28 row.

### Advanced Child

For roots in row28, write:

```text
a = 9*t + 8
c = 6*t + 5
```

Then:

```text
3*c + 1 = 2*a
T c = a
```

The direct advanced child splits by `t % 3`:

```text
t % 3 = 0 -> c % 9 = 5
t % 3 = 1 -> c % 9 = 2
t % 3 = 2 -> c % 9 = 8
```

The `c % 9 = 5` and `c % 9 = 2` cases are structurally simpler: they transfer
to already tracked classes without the repeated class-8 nested repair.

The `c % 9 = 8` case is the strong row28 test.  It requires the post-deletion
`cPrime` split.

### cPrime Split

For the repeated class-8 child `c`, introduce the odd child `cPrime` using the
robust arithmetic shape:

```text
3*cPrime + 1 = 2*c
T cPrime = c
```

The generator should avoid fragile division-heavy statements in the primary
artifact.  It may include derived closed forms in the trace, but the core rule
should be the equation above.

The `cPrime` split must cover:

```text
cPrime % 9 in {2,5,8}
```

The V3 post-deletion consumers are:

```text
cPrime % 9 = 2:
  pay the exterior phi22 branch directly with cPrime.

cPrime % 9 = 5:
  pay the exterior phi22 branch via 4*cPrime, which lands in class 2.

cPrime % 9 = 8:
  pay phi28 + M1V3 using sibling fibers below c:
    - odd branch cPrime pays phi28;
    - even branch 4*c lands in class 5 and pays M1V3 through the phi25 arm.
```

The last case is the source-faithful V3 guardrail:

```text
M1V3 second arm = phi25
M1V3 second arm != phi22
```

### M1V3 / M2V3 Shape

The generated row must encode the V3 nested EL shape:

```text
M2V3 Phi y =
  min3
    (Phi.phi22 (y + shift3AlphaMinus5Pad3))
    (Phi.phi25 (y + shift3AlphaMinus5Pad3))
    (Phi.phi28 (y + shift3AlphaMinus5Pad3))

M1V3 Phi y =
  min
    (Phi.phi28 (y + shift2AlphaMinus5Pad2) + M2V3 Phi y)
    (Phi.phi25 (y + shift2AlphaMinus5Pad2))
```

The historical V2 form with `phi22` as the second arm remains an abstract
theorem only.  It is not source-faithful for the KL2003 row28 seam after the
meta-errata.

## Deletion And Post-Deletion Behavior

The row28 microgenerator must explicitly represent deletion/post-deletion
decisions.

Required rules:

- a node marked deleted is not counted;
- post-deletion children and sibling branches are counted according to the
  deletion rule;
- sums are allowed only between sibling populations known to be disjoint by
  entry fibers;
- no parent and descendant may be counted together;
- the generator must reject the old bad candidate pattern where a proposed
  population `B` is already contained in a proposed population `A`.

Operationally, the artifact should separate:

```text
node_status = counted | deleted | structural_only
deletion_reason = source_deletion_rule | post_deletion_replacement | none
fiber_parent = entry predecessor/root used for disjointness
sum_group = sibling group id, if counted in a sum
```

The row28 class-8 branch should never be represented as:

```text
count deleted parent + count descendant repair
```

It should be represented as a post-deletion constructor with counted sibling
fibers only.

## Expected Output

Future implementation target:

```text
scripts/kl2003_f2_k2_row28_microgenerator_v1.py
```

Output directory:

```text
outputs/KL2003_F2_K2_ROW28_MICROGENERATOR_v1/
```

Expected files:

```text
row28.generated.json
KL2003K2Row28GeneratedData.lean
row28_derivation_trace.csv
row28_vs_baseline_diff.csv
row28_tree_diff_against_figure_a1.csv
row28_decision_checks.csv
generation_summary.json
manifest_sha256.csv
```

The generated JSON must use the high-k v2 artifact policy, or v2.1 only if the
nested EL schema check explicitly requires and documents the amendment:

```text
schema_version = KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2
k = 2
tracked_class_count = 3
pre_reduction_class_count = 9
generator_mode = rule_derived_row28
mathematical_generation = true
scope = k2_row28_only
proof_status = data_candidate_only
```

The generated Lean data file must stay in `outputs/`, not in
`CollatzClassical/`.  It should contain deterministic literals/comments only,
with a header like:

```lean
-- generated k2 row28 data; not imported; verifier not yet written
```

It must not contain mathematical theorems.

## Required Checks

Schema and isolation checks:

- `row28` is present;
- `row22` is absent;
- `row25` is absent;
- `M1V3` is present only as the row28 nested auxiliary shape;
- JSON/Lean twin artifact links and hashes are present;
- no floats;
- rational strings are canonical;
- generated Lean data is not imported.

V3/meta-errata checks:

- `M1V3` mentions `phi25`;
- `M1V3` does not use `phi22` as the second arm;
- V2/`phi22` is not emitted as the source-faithful row28 target.

Deletion checks:

- deletion marks are present where required;
- deletion marks exactly match Figure A1 for row28 k=2;
- deleted nodes are not counted;
- post-deletion replacement nodes are named;
- sums are only between sibling populations;
- parent-plus-descendant double counting is rejected;
- the old bad `B subset A` candidate is rejected.

Residue and split checks:

- root class is `a % 9 = 8`;
- retarded branch `4*a` maps to class `5`;
- direct advanced child satisfies `3*c + 1 = 2*a`;
- direct advanced split covers `{5,2,8}`;
- repeated class-8 case introduces `cPrime`;
- `cPrime` satisfies `3*cPrime + 1 = 2*c`;
- `cPrime` split covers `{2,5,8}`.

Certificate/slack checks:

- `L2NT_D3_slack = 2077/145800`;
- `c25 = 1001/1000`;
- `c28 = 69/40`;
- lambda and `DeltaV2` references match the k=2 baseline.

Expected verdict:

```text
ROW28_MICROGENERATOR_DIFF_PASS
FIGURE_A1_DELETION_DIFF_PASS
```

if the generated row28 artifact matches the manual source-faithful V3 baseline
and the Figure A1 deletion oracle up to documented format-only differences.

## Member-Wise Diagnostic Hook

The row28 validation layer should include a diagnostic member-wise hook.  It is
not proof, but it is required before trusting the generator architecture enough
to move toward k=3.

The hook should sample roots:

```text
a = 9*t + 8
```

with enough `t` values to cover all direct `c` cases and all repeated class-8
`cPrime` cases.

For each sample, record:

- `a`;
- `c`;
- `c % 9`;
- whether the case is mod2, mod5, or repeated mod8;
- `cPrime`, when used;
- `cPrime % 9`, when used;
- forward route checks;
- deletion status;
- counted sibling populations;
- whether any parent-plus-descendant double count was detected;
- pass/fail.

The hook must be described as:

```text
diagnostic_only = true
not_part_of_logical_base = true
```

## Future Lean Verifier Obligations

The future row28 verifier must not trust the generated artifact as proof.  It
must check the following obligations as named theorems or generated-data
verifier lemmas:

- row well-formedness;
- source class and child residue checks;
- inverse route checks;
- retarded window transfer;
- advanced padded window transfer;
- deletion rule soundness;
- deleted-node exclusion;
- sibling disjointness / entry-fiber partition;
- no parent-plus-descendant double counting;
- `M1V3` / `M2V3` shape;
- `phi25` second arm in `M1V3`;
- no V2/`phi22` replacement in source-faithful row28;
- rational constants and D3 slack match;
- positive slack for the row28 certificate contribution.

Reusable Lean baseline, as verifier references only:

```text
d3_core_instantiation
inverse_children_disjoint_descendants
concretePhi_row22_seam
concretePhi_row25_seam
row28_outer_block_v3_le_child_mod8
row28_pointwise_seam_v3_mod8
concretePhi_row28_seam_v3
```

The verifier may reuse theorem patterns from the manual proof, but the
generator artifact must be derived independently from rules.

## Criteria

Ready-for-implementation criterion:

```text
ROW28_MICROGENERATOR_READY_FOR_IMPLEMENTATION
```

requires this scoping contract to be implemented by a future generator that:

- derives row28 from rules;
- emits v2 JSON + Lean data twins;
- passes the nested EL schema check, or first upgrades to v2.1;
- names deletion/post-deletion decisions;
- emits the `c` split and `cPrime` split;
- emits V3 `M1V3` with `phi25`;
- derives deletion from the parametric TeX rule;
- matches the k=2 deletion-saturation experiment;
- reproduces the Figure A1 crossed-node oracle;
- records the EL termination rule source;
- passes schema validation;
- passes row28 semantic diff against the manual baseline;
- passes the Figure A1 tree diff;
- passes the member-wise diagnostic hook.

Blockers:

```text
ROW28_MICROGENERATOR_BLOCKED_ON_V2_PHI22_OUTPUT
ROW28_MICROGENERATOR_BLOCKED_ON_DELETION_ABSENT
ROW28_MICROGENERATOR_BLOCKED_ON_PARENT_DESCENDANT_DOUBLE_COUNT
ROW28_MICROGENERATOR_BLOCKED_ON_CPRIME_SPLIT_ABSENT
ROW28_MICROGENERATOR_BLOCKED_ON_BASELINE_USED_AS_SOURCE
ROW28_MICROGENERATOR_BLOCKED_ON_D3_SLACK_MISMATCH
ROW28_DELETION_RULE_FAIL
BLOCKED_ON_EL_TERMINATION_RULE_SOURCE
BLOCKED_ON_NESTED_EL_SCHEMA_REPRESENTATION
```

Any mathematical diff against the source-faithful V3 baseline is a generator
blocker.  It must not be used to revise the already proved k=2 theorem.

## Guardrails

This task does not:

```text
implement the row28 generator
open Lean
generate k=3 data
solve an LP
claim a k=3 theorem
claim a k=9 theorem
claim a k=11 / 0.84 theorem
claim full M1
claim global Collatz
```

## Classification

```text
K2_ROW28_MICROGENERATOR_SCOPED
DELETION_RULE_GENERATOR_TARGET_DEFINED
FIGURE_A1_ORACLE_DIFF_REQUIRED
EL_TERMINATION_RULE_REQUIRED
NESTED_EL_SCHEMA_CHECK_REQUIRED
K2_DELETION_SATURATION_ORACLE_VALIDATED
GENERAL_K_DELETION_SATURATION_UNPROVED
ROW28_CPRIME_SPLIT_TARGET_DEFINED
M1V3_PHI25_GUARDRAIL_RECORDED
BASELINE_AS_TEST_NOT_SOURCE
NO_IMPLEMENTATION
NO_K3_GENERATION
NO_HIGH_K_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
