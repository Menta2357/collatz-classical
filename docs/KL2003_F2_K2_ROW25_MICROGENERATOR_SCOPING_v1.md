# KL2003 F2 k=2 Row25 Microgenerator Scoping v1

Date: 2026-07-18

Status: `K2_ROW25_MICROGENERATOR_SCOPED`

## Purpose

This note scopes the first mathematical microgenerator in the F2 generator
track.

The current `k2_regression` skeleton only reemits the manual baseline as data.
That proves the format pipeline:

```text
manual baseline -> generated JSON -> generated Lean data -> schema validation
-> semantic diff -> manifest
```

The next step is smaller but more mathematical: generate one row from rules.
The chosen target is `row25`.

This pass is documentation only.  It does not implement the generator, does not
open Lean, does not generate k=3 data, and does not claim a new theorem.

## Why Row25

`row25` is the simplest k=2 source-faithful row.

It is the right first rule-derived target because:

- it is the D2 row for roots with `a % 9 = 5`;
- it is single-branch in the EL ledger;
- it uses the retarded source `4 * a`;
- it does not consume an advanced contribution;
- it does not involve row22 parity lift;
- it does not involve row28 nested `M1V3` / `M2V3`;
- it does not involve post-deletion row28 class-8 `c'` splitting;
- it already has a manual Lean theorem:

```lean
concretePhi_row25_seam :
  forall y, 14 <= y ->
    concretePhi.phi22 (y - 2) <= concretePhi.phi25 y
```

The manual proof is recorded in:

```text
docs/KL2003_CONCRETE_PHI_ROW25_SEAM_LEAN_v1.md
CollatzClassical/KL2003/KL2003ConcretePhiRealization.lean
```

The baseline machine-readable row is:

```text
outputs/KL2003_F2_K2_GENERATOR_REGRESSION_BASELINE_v1/expected_rows_v3.csv
```

with:

```text
row_id = row25
source_class = 25
tracked_residue_mod9 = 5
row_family = D2
expected_shape = single-branch retarded row; no advanced contribution
required_feature = row25 single-branch
```

## Minimal Mathematical Inputs

The microgenerator should derive the row25 data from the following rules and
facts, not merely copy the baseline row text.

### Root Class

Input class:

```text
a % 9 = 5
```

The generated row should record:

```text
source_class = row25 / class mod 9 representative 5
row_kind = D2 single-branch retarded
```

### Retarded Child

The retarded source/root is:

```text
4 * a
```

This is the only consumed branch in the row25 EL ledger.

The generator should not emit any consumed advanced child for row25.  It may
record the auxiliary advanced arithmetic needed by the combinatorial core, but
that auxiliary is not a row25 contribution.

### Class Transfer

The generator must derive:

```text
a % 9 = 5 -> (4 * a) % 9 = 2
```

Manual Lean baseline:

```lean
row25_retarded_residue_mod_9 :
  a % 9 = 5 -> (4 * a) % 9 = 2
```

The generated artifact should therefore route the retarded source to the class
tracked by `phi22`.

### NotInCycle Closure

For the manual seam, the transformed root is packaged as:

```lean
row25_retarded_classRoot :
  ClassRoots 5 -> ClassRoots 2
```

which consumes:

```lean
notInCycle_four_mul :
  NotInCycle a -> NotInCycle (4 * a)
```

The microgenerator does not prove this.  It should emit the obligation that a
future Lean verifier must check:

```text
NotInCycle a -> NotInCycle (4*a)
```

or reference the generated data to the existing verifier lemma.

### Exact Window Transfer

The retarded window identity is exact:

```lean
row25_concreteWindow_retarded :
  concreteWindow (y - 2) (4 * a) = concreteWindow y a
```

It comes from:

```text
2^(y-2) * (4a) = 2^y * a
```

Because the equality holds before applying `Nat.ceil`, row25 has no floor/ceil
loss and no epsilon pad.

The generated row should record:

```text
shift = -2
window_policy = exact_retarded_window
window_identity = concreteWindow (y - 2) (4*a) = concreteWindow y a
rounding_loss = 0
epsilon_pad = none
```

### Core Instantiation

The combinatorial source is:

```lean
d2_single_branch_core_instantiation
```

Manual statement shape:

```lean
theorem d2_single_branch_core_instantiation {a c x xRet : Nat}
    (ha_pos : 1 <= a)
    (ha_cycle : NotInCycle a)
    (hc_arith : 3 * c + 1 = 2 * a)
    (hax : a <= x)
    (hxRet : xRet <= x) :
    (piStarFinset (4 * a) xRet).card <= (piStarFinset a x).card
```

For row25, the auxiliary advanced child used only to instantiate the core is:

```lean
row25_advanced_child_arith :
  a % 9 = 5 ->
  3 * (6 * (a / 9) + 3) + 1 = 2 * a
```

Important: this auxiliary child does not become an advanced contribution in
the row25 EL row.  The generator must preserve the distinction:

```text
advanced_child_for_core = present
advanced_contribution_in_EL = absent
```

### Certificate / Slack Baseline

The row25 slack baseline is:

```text
L2NT_D2_slack = 271/729000
```

from:

```text
outputs/KL2003_F2_K2_GENERATOR_REGRESSION_BASELINE_v1/certificate_constants.csv
CollatzClassical/KL2003/KL2003K2CertificateData.lean
```

The microgenerator must not solve the LP.  It should attach the baseline
coefficient/slack references needed to compare against the manual row25 data.

## Expected Microgenerator Output

Future implementation target:

```text
scripts/kl2003_f2_k2_row25_microgenerator_v1.py
outputs/KL2003_F2_K2_ROW25_MICROGENERATOR_v1/
```

Expected artifacts:

```text
kl2003_k2_row25_certificate.generated.json
KL2003K2Row25CertificateDataGenerated.lean
generation_summary.json
row25_manual_vs_generated_diff.csv
manifest_sha256.csv
```

The generated JSON must use:

```text
schema_version = KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2
k = 2
tracked_class_count = 3
pre_reduction_class_count = 9
generation_mode = rule_derived_row25
mathematical_generation = true
scope = k2_row25_only
```

The generated Lean data must remain in `outputs/`, not under
`CollatzClassical/`, with a header like:

```lean
-- generated k2 row25 data; not imported; verifier not yet written
```

It should contain data declarations only.  No theorem should be generated in
this step.

## Required Row25 Record

The generated row should include at least:

```text
row_id = row25
source_class = 25
row_kind = D2
children = [row25_retarded_child]
deletion_policy = none_for_consumed_branch
coefficient_terms = baseline row25 coefficient/slack refs
target_bound = row25 target bound reference
slack_id = L2NT_D2_slack
```

The child/literal record should include:

```text
child_id = row25_retarded_4a
inverse_word = ["even", "even"] or equivalent finite edge notation
target_class = 2
shift = -2
window_policy = exact_retarded_window
fiber_parent = 2*a or core-specific parent tag, if verifier needs it
deleted = false
reason = row25 single-branch retarded source
root_formula = 4*a
forward_route = 4*a -> 2*a -> a
residue_side_conditions = a % 9 = 5
boundary_correction = none
```

The auxiliary core child may be recorded separately, marked clearly as:

```text
consumed_by_EL = false
purpose = d2_single_branch_core_instantiation witness
formula = 6*(a/9)+3
arith = 3*c + 1 = 2*a
```

This prevents a future reviewer from confusing the core witness with an
advanced row contribution.

## Regression Checks

The row25 microgenerator must run the existing pipeline checks, restricted to
row25.

Required checks:

1. Schema validation:

```text
scripts/kl2003_f2_k3_certificate_schema_validator_v1.py
```

using the generated row25 JSON and an output directory dedicated to row25.

2. Semantic diff against baseline row25:

The diff should compare against:

```text
outputs/KL2003_F2_K2_GENERATOR_REGRESSION_BASELINE_v1/expected_rows_v3.csv
outputs/KL2003_F2_K2_GENERATOR_REGRESSION_BASELINE_v1/certificate_constants.csv
```

Required row checks:

```text
row25 exists
row25 source_class = 25
row25 row_family = D2
row25 expected shape = single-branch retarded row; no advanced contribution
row25 required feature = row25 single-branch
row25 target class transfer = 2
row25 shift = -2
row25 has no consumed advanced contribution
```

Required constant/slack checks:

```text
lambda = 27/20
c25 = 1001/1000
L2NT_D2_slack = 271/729000
```

3. Scope checks:

```text
no row22 generated
no row28 generated
no M1V3 generated
no k=3 generated
no LP solved
no Lean build
```

If the microgenerator emits row22 or row28 in this pass, classify that as a
scope failure even if the emitted data is otherwise valid.

## Trust Boundary

The microgenerator is untrusted.

The generated JSON is a candidate data artifact, not proof.

The generated Lean data is also not proof by itself.  It must not be imported
into theorem modules in this phase.

The future trusted boundary is a Lean verifier that checks:

- row well-formedness;
- residue transfer;
- forward route;
- exact window equality;
- single-branch core instantiation;
- absence of advanced EL contribution;
- coefficient/slack references.

Hooks and Python diffs are diagnostics and custody aids only.

## Future Lean Verifier Obligations

A later row25 verifier should prove or consume named Lean facts for:

```text
row25_generated_residue :
  a % 9 = 5 -> (4*a) % 9 = 2

row25_generated_window :
  concreteWindow (y - 2) (4*a) = concreteWindow y a

row25_generated_route :
  T^[2] (4*a) = a

row25_generated_core :
  piStarFinset (4*a) xRet <= piStarFinset a x
  under the D2 single-branch hypotheses

row25_generated_no_advanced_contribution :
  the EL row consumes only the retarded branch

row25_generated_slack :
  L2NT_D2_slack = 271/729000 and 0 < L2NT_D2_slack
```

The verifier may reuse the existing manual lemmas initially, but the generated
data must still expose enough fields to check the route and row shape.

## Anti-Hardcode Rule

The microgenerator must not merely copy the `row25` baseline record and mark it
as rule-derived.

Acceptable:

- derive `(4*a) % 9 = 2` from `a % 9 = 5`;
- emit `root_formula = 4*a`;
- emit the forward route `4*a -> 2*a -> a`;
- emit the exact window identity;
- attach baseline constants/slack by id.

Blocker:

```text
ROW25_MICROGENERATOR_HARDCODED_BASELINE_WITHOUT_RULE_DERIVATION
```

if the implementation cannot show, in its output summary or diagnostics, that
residue and window facts were derived by rule.

Any mathematical difference from the manual row25 baseline is also a blocker:

```text
K2_ROW25_MICROGENERATOR_REGRESSION_FAIL
```

## Acceptance Criteria

The next implementation can be accepted as ready for a future verifier if it
achieves:

```text
ROW25_MICROGENERATOR_READY_FOR_IMPLEMENTATION
```

after producing:

- v2 JSON + generated Lean data twins;
- cross-hash manifest;
- schema validation pass;
- row25 semantic diff pass;
- explicit residue derivation diagnostics;
- explicit exact-window derivation diagnostics;
- no row22/row28 generation;
- no k=3 generation.

## Guardrails

- No implementation in this task.
- No Lean build.
- No generated Lean import.
- No k=3 generation.
- No LP solve.
- No high-k theorem claim.
- No global Collatz claim.
- No change to the already proved manual k=2 theorem line.

## Verification

Required for this scoping pass:

```text
git diff --check
```

No Lean build is required because no Lean files are modified.

## Classification

```text
K2_ROW25_MICROGENERATOR_SCOPED
FIRST_RULE_DERIVED_ROW_TARGET_DEFINED
ROW25_SINGLE_BRANCH_RATIONALE_RECORDED
NO_IMPLEMENTATION
NO_K3_GENERATION
NO_HIGH_K_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
