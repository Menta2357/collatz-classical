# KL2003 F2 k=2 Row22 Microgenerator Scoping v1

Date: 2026-07-18

Status: `K2_ROW22_MICROGENERATOR_SCOPED`

## Purpose

This note scopes the second k=2 regression microgenerator in the F2 track:
`row22`.

The first rule-derived microgenerator, `row25`, exercised the simplest row:
single-branch, retarded, no advanced contribution.  `row22` is the next
intentional step because it is still small enough for a focused regression
target, but it introduces the first genuinely nontrivial generator feature:
the advanced child is not tracked directly and must be routed through a parity
lift.

This pass is documentation only.  It does not implement the row22 generator,
does not open Lean, does not generate k=3 data, does not solve an LP, and does
not claim any high-k theorem.

## Why Row22

`row22` is the right second microgenerator target because it adds exactly one
new structural feature beyond `row25`.

Required new features:

- two-branch D1 shape;
- retarded branch from `4 * a`;
- advanced child `c` with `3*c + 1 = 2*a`;
- detection that the direct advanced child is `1 mod 3`, hence not tracked;
- parity lift from `c` to `2*c`;
- route `2*c -> c -> a`;
- split of `(2*c) % 9` into tracked classes `{2,5,8}`;
- min3 target for the lifted advanced branch;
- D1 slack reference `L2NT_D1_slack = 29/9720`.

Features intentionally still absent:

- no row28 nested `M1V3` / `M2V3`;
- no post-deletion `c'` split;
- no Figure A1 tree-wide diff;
- no LP solving;
- no k=3 generation.

Manual Lean baseline:

```lean
concretePhi_row22_seam :
  forall y, 14 <= y ->
    concretePhi.phi28 (y - 2)
      + min3
          (concretePhi.phi22 (y + shiftAlphaMinus2Pad))
          (concretePhi.phi25 (y + shiftAlphaMinus2Pad))
          (concretePhi.phi28 (y + shiftAlphaMinus2Pad))
      <= concretePhi.phi22 y
```

Baseline references:

```text
docs/KL2003_CONCRETE_PHI_ROW22_PARITY_LIFT_LEAN_v1.md
docs/KL2003_CONCRETE_PHI_ROW22_SEAM_LEAN_v1.md
CollatzClassical/KL2003/KL2003ConcretePhiRealization.lean
outputs/KL2003_F2_K2_GENERATOR_REGRESSION_BASELINE_v1/expected_rows_v3.csv
outputs/KL2003_F2_K2_GENERATOR_REGRESSION_BASELINE_v1/certificate_constants.csv
```

## Source Of Derivation

The microgenerator must derive `row22` from parametric rules, not from the
manual row22 baseline.

Allowed sources:

- KL2003 TeX / splitting rules once parsed into the generator rule language;
- the project deletion/splitting rule custody notes;
- explicitly encoded arithmetic rules for root class, child construction,
  parity lift, residue split, and window policy.

Regression-only sources:

- `concretePhi_row22_seam`;
- `row22_*` manual Lean theorem names;
- `expected_rows_v3.csv`;
- certificate constants CSV.

The baseline is a test oracle.  It is not the generator source.

If the implementation merely copies the row text from the baseline and labels
it `rule_derived`, classify it as:

```text
ROW22_MICROGENERATOR_FAIL_BASELINE_USED_AS_SOURCE
```

## Mathematical Inputs

### Root Class

Input class:

```text
a % 9 = 2
```

The generated row should record:

```text
row_id = row22
source_class = 22
tracked_residue_mod9 = 2
row_family = D1
generation_mode = rule_derived_row22
mathematical_generation = true
proof_status = data_candidate_only
```

### Retarded Branch

Retarded source:

```text
4 * a
```

For `a % 9 = 2`, the retarded class transfer is:

```text
(4 * a) % 9 = 8
```

The generated row should route the retarded branch to `phi28` with exact
retarded shift:

```text
shift = -2
window_policy = exact_retarded_window
window_identity = concreteWindow (y - 2) (4*a) = concreteWindow y a
rounding_loss = 0
```

### Advanced Child

For roots in row22, write:

```text
a = 9*t + 2
c = 6*t + 1
```

Then:

```text
3*c + 1 = 2*a
T c = a
c % 3 = 1
```

The direct advanced child `c` is therefore not in the tracked classes
`{2,5,8} mod 9`.  The generator must not emit `c` as a tracked advanced child.

Blocker if missing:

```text
ROW22_DIRECT_ADVANCED_CHILD_TRACKED_WITHOUT_PARITY_LIFT
```

### Parity Lift

The tracked advanced source is the parity lift:

```text
2*c
```

with route:

```text
2*c -> c -> a
```

The generator should record:

```text
parity_lift = true
direct_advanced_child = c
lifted_child = 2*c
forward_route = [2*c, c, a]
shift_explanation = (alpha - 1) - 1 = alpha - 2
```

The exact parity-window identity is:

```text
concreteWindow (z - 1) (2*c) = concreteWindow z c
```

In the row22 V3/V2-compatible abstract row, the consumed lifted contribution
uses:

```text
shiftAlphaMinus2Pad = alpha - 2 - epsilon0
```

The pad belongs to the seam/window absorption layer.  The parity lift itself
has no floor/ceil loss.

### Lifted Residue Split

For `a = 9*t + 2` and `c = 6*t + 1`:

```text
2*c = 12*t + 2
```

The generator must split by `t % 3`:

```text
t % 3 = 0 -> (2*c) % 9 = 2
t % 3 = 1 -> (2*c) % 9 = 5
t % 3 = 2 -> (2*c) % 9 = 8
```

This split is the input to the `min3(phi22, phi25, phi28)` branch.

## Expected Row Shape

Generated `row22` should have two consumed branches:

```text
row22:
  source = phi22(y)
  retarded contribution = phi28(y - 2)
  advanced lifted contribution =
    min3(phi22, phi25, phi28)(y + shiftAlphaMinus2Pad)
```

Conceptual row:

```text
phi28(y - 2)
+ min3(
    phi22(y + shiftAlphaMinus2Pad),
    phi25(y + shiftAlphaMinus2Pad),
    phi28(y + shiftAlphaMinus2Pad))
<= phi22(y)
```

The microgenerator should also preserve the distinction:

```text
advanced_child_direct = c
advanced_child_direct_tracked = false
advanced_child_lifted = 2*c
advanced_child_lifted_tracked = true
```

No `M1V3`, `M2V3`, deletion tree, row25, or row28 data should appear in this
artifact.

## Core And Seam References

Manual combinatorial source:

```lean
d1_core_instantiation
```

Manual row22 seam source:

```lean
concretePhi_row22_seam
```

Manual support lemmas already proved:

```lean
row22AdvancedChild
row22LiftedChild
row22_advanced_child_arith
row22_advanced_child_mod_three
row22_parity_lift_route_to_root
row22_lifted_child_notInCycle
row22_lifted_child_residue_mod_9_of_root_t_mod_0
row22_lifted_child_residue_mod_9_of_root_t_mod_1
row22_lifted_child_residue_mod_9_of_root_t_mod_2
row22_parity_concreteWindow
row22_parity_piStar_transfer
row22_piStar_sum_le_target
```

These Lean lemmas are verifier targets/baseline evidence.  The future
generator should emit data obligations that a verifier can check against
general rules, not cite these theorem names as proof.

## Certificate And Slack

The row22/D1 slack baseline is:

```text
L2NT_D1_slack = 29/9720
```

Required coefficient references:

```text
lambda = 27/20
DeltaV2 = (20/27)^14/2
c22 = 73/40
c28 = 69/40
B_lo = 119/135
L2NT_D1_slack = 29/9720
```

The microgenerator must not solve or adjust the LP.  It should attach the
baseline rational constants for regression comparison and emit a data
candidate only.

## Expected Microgenerator Output

Future implementation target:

```text
scripts/kl2003_f2_k2_row22_microgenerator_v1.py
outputs/KL2003_F2_K2_ROW22_MICROGENERATOR_v1/
```

Expected artifacts:

```text
row22.generated.json
KL2003K2Row22GeneratedData.lean
row22_derivation_trace.csv
row22_vs_baseline_diff.csv
generation_summary.json
manifest_sha256.csv
```

Required metadata:

```text
schema_version = KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2
k = 2
tracked_class_count = 3
pre_reduction_class_count = 9
generator_mode = rule_derived_row22
mathematical_generation = true
proof_status = data_candidate_only
scope = k2_row22_only
```

The generated Lean data artifact must stay under `outputs/`, not under
`CollatzClassical/`, and must not be imported by theorem modules.

## Derivation Trace Requirements

The trace should include one named step per mathematical ingredient:

```text
source_class
retarded_child
retarded_class_transfer_mod9
retarded_window_transfer
advanced_child_definition
advanced_child_arithmetic
advanced_child_mod_three
parity_lift_definition
parity_lift_forward_route
parity_window_transfer
lifted_residue_split_mod2
lifted_residue_split_mod5
lifted_residue_split_mod8
row_shape
slack_reference
guardrails
```

Each step should include:

```text
step_id
claim
derivation_rule
symbolic_formula
expected_value
source_kind
notes
```

`source_kind` should distinguish:

```text
PARAMETRIC_RULE
ARITHMETIC_DERIVATION
BASELINE_REGRESSION_TARGET
```

The first two are generation sources.  The last is a diff target only.

## Regression Checks

The row22 validation layer should check:

- JSON schema v2;
- generated JSON + Lean twin links and hashes;
- no floats;
- canonical rational strings;
- row22 present;
- no row25 generated;
- no row28 generated;
- no `M1V3` generated;
- source class is `a % 9 = 2`;
- retarded branch is `4*a`;
- retarded class transfer is `(4*a) % 9 = 8`;
- advanced child satisfies `3*c + 1 = 2*a`;
- direct advanced child has `c % 3 = 1`;
- parity lift `2*c` is present;
- forward route `2*c -> c -> a` is present;
- lifted residue split into `{2,5,8}` is present;
- row shape matches the baseline row22 D1 shape;
- `L2NT_D1_slack = 29/9720`;
- no deletion rule or nested EL block appears.

Verdicts:

```text
ROW22_MICROGENERATOR_DIFF_PASS
ROW22_MICROGENERATOR_FORMAT_DIFF_ONLY
ROW22_MICROGENERATOR_FAIL
```

## Trust Boundary

The future Python generator is not trusted.

The generated JSON and generated Lean data are data candidates, not proofs.

The manual baseline is not a generation source.  It is a regression oracle.

The future Lean verifier must recheck:

- residue arithmetic;
- forward route;
- parity lift route;
- NotInCycle closure obligation;
- window identity;
- piStar transfer;
- D1 core discharge;
- rational slack positivity and coefficient arithmetic;
- row shape translation into the abstract EL contract.

No theorem may take the generated certificate as an axiom.

## Acceptance Criteria

`ROW22_MICROGENERATOR_READY_FOR_IMPLEMENTATION` means the implementation task
may begin once this note is reviewed.

The implementation should later pass:

```text
ROW22_RULE_DERIVATION_EMITTED
ROW22_PARITY_LIFT_EMITTED
ROW22_MICROGENERATOR_DIFF_PASS
DATA_CANDIDATE_ONLY
```

Blockers:

```text
BLOCKED_ON_ROW22_PARAMETRIC_RULE_SOURCE
BLOCKED_ON_ROW22_ADVANCED_CHILD_ARITHMETIC
BLOCKED_ON_ROW22_PARITY_LIFT_DERIVATION
BLOCKED_ON_ROW22_LIFTED_RESIDUE_SPLIT
BLOCKED_ON_ROW22_WINDOW_POLICY
BLOCKED_ON_ROW22_BASELINE_DIFF
```

## Guardrails

- No implementation in this task.
- No Lean build.
- No k=3 generation.
- No LP solving.
- No high-k theorem claim.
- No 0.84 claim.
- No global Collatz claim.
- No claim that generated row22 is verified by Lean.
- No use of the manual baseline as generator source.

## Classifications

- `K2_ROW22_MICROGENERATOR_SCOPED`
- `PARITY_LIFT_GENERATOR_TARGET_DEFINED`
- `TWO_BRANCH_ROW_TARGET_DEFINED`
- `BASELINE_AS_TEST_NOT_SOURCE`
- `NO_IMPLEMENTATION`
- `NO_K3_GENERATION`
- `NO_HIGH_K_CLAIM`
- `NO_GLOBAL_COLLATZ_CLAIM`
