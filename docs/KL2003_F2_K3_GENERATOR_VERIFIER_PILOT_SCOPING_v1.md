# KL2003 F2 k=3 Generator/Verifier Pilot Scoping v1

Date: 2026-07-18

Status: `F2_K3_PILOT_SCOPED`

## Purpose

This note scopes the small high-k pilot that should precede any k=9 or k=11
Lean work.

The completed k=2 lane proves a calibrated M1-surrogate window theorem and an
arbitrary-x corollary for the concrete k=2 `Phi`.  F2 has now corrected the
high-k ladder:

```text
k=9   gamma_9  = 0.8168300, lambda_9  = 1.7615320
k=11  gamma_11 = 0.8417560, lambda_11 = 1.7922310
```

Thus k=9 is the first large-scale high-k feasibility station, while k=11 is
the source-faithful target for the advertised `0.84` line.  The local KL2003
source does not print the complete k=9/k=11 row and certificate data in a form
that can be manually transcribed into Lean.  The next question is therefore not
"can we hand-write k=9?", but:

```text
Can we build an auditable generator -> data -> verifier pipeline where the
generator is not trusted and the checker re-verifies all mathematical data?
```

k=3 is the pilot for that question.  It is a method test, not a high-k theorem
target and not an escalation to the k=9/k=11 formalization.

## Trust Boundary

The pilot must preserve the same separation that made the k=2 line auditable.

### Untrusted generator

The Python generator may search, normalize, solve, or emit candidate data.  It
is not part of the proof base.

Allowed generator outputs:

- candidate row systems;
- inverse words and tree/literal populations;
- deletion marks;
- rational certificate candidates;
- rational row slacks;
- source references and normalization metadata;
- manifests and hashes.

The generator may be wrong.  The point of the pilot is to make wrong output
detectable by the data verifier.

### Versioned data artifacts

The emitted JSON/CSV files must be versioned artifacts, not transient console
output.

Expected artifact properties:

- stable schema;
- explicit run id;
- source hash references;
- generated file SHA256 manifest;
- generator version/hash;
- exact rational values, not floats as final evidence;
- row identifiers and source/normalization provenance;
- summary metrics for row count, literal count, slack count, and bit sizes.

### Trusted Lean verifier

The Lean side is the checker, not the search engine.

The verifier should check:

- row well-formedness;
- residue and class membership;
- inverse-word validity;
- deletion-rule validity;
- coverage/disjointness using existing fiber machinery when possible;
- rational coefficient intervals;
- exact rational slacks;
- positivity of all final obligations;
- base/rounding data that the pilot chooses to include.

The verifier should not trust that the generator found the right rows.  It
should verify that the emitted rows satisfy the stated local obligations.

### Empirical hooks

Empirical scripts remain diagnostic only.

Useful hooks:

- finite-grid checks against `piStar`;
- member-wise row population validation;
- source-vs-normalized row diff;
- generator determinism checks;
- manifest consistency checks.

These hooks can catch bugs before Lean, but they are not part of the logical
base.

## k=3 Pilot Scope

### Class convention

The pilot must make the class convention explicit before any generator output
is accepted.

Two sizes should be recorded in every summary:

```text
natural tracked classes:       3^(3 - 1) = 9
pre-reduction residue classes: 3^3       = 27
```

The default pilot target is the natural tracked class convention, because it
matches the high-k scale formula used in F2:

```text
tracked_classes(k) = 3^(k - 1)
k=2  -> 3
k=3  -> 9
k=9  -> 6561
k=11 -> 59049
```

If the generator internally uses the 27 pre-reduction classes, it must emit the
map from pre-reduction classes to the 9 tracked classes.  That map is a data
artifact and must be checked.

### System choice

The pilot should prefer the smallest k=3 system that exercises the real
generator/verifier risks:

- general-k row construction;
- deletion or no-deletion markers, as dictated by the source algorithm;
- inverse-word materialization;
- exact rational certificate checking;
- class and residue transfer;
- generated manifests;
- Lean data verification.

It does not need to optimize the final exponent or mimic all k=9/k=11
engineering cost.  It does need to test whether the pipeline scales beyond the
hand-written k=2 architecture.

### Comparison to k=2 and high-k

k=3 should be reported against the known scale ladder:

```text
k=2  tracked classes = 3
k=3  tracked classes = 9       factor from k=2 = 3
k=9  tracked classes = 6561    factor from k=2 = 2187
k=11 tracked classes = 59049   factor from k=2 = 19683
```

The pilot is successful only if the method looks generator-shaped.  A k=3 proof
that succeeds by hand transcription is not evidence for k=9.

## Generator Outputs

The pilot generator should emit a directory such as:

```text
outputs/KL2003_F2_K3_GENERATOR_VERIFIER_PILOT_v1/
```

Expected files:

```text
rows.json
rows.csv
inverse_words.csv
deletion_marks.csv
certificate.json
row_slacks.csv
summary.json
manifest_sha256.csv
source_manifest.json
```

Minimum `summary.json` fields:

```text
run_id
k
tracked_class_convention
tracked_classes
pre_reduction_classes
row_count
inverse_word_count
deleted_literal_count
kept_literal_count
certificate_variable_count
slack_count
min_slack
max_denominator_bits
max_numerator_bits
generator_git_head
source_inputs
output_manifest_sha256
guardrails
```

Minimum certificate requirements:

- all coefficients are exact rationals;
- all slacks are exact rationals;
- floats may appear only as diagnostic approximations;
- every row has a stable id;
- every rational interval has lower and upper endpoints;
- every row records the source/normalization rule that produced it.

## Lean Verifier Shape

The first Lean verifier should be data-oriented.

It should not prove a k=3 analogue of the final M1-surrogate theorem unless a
later gate explicitly expands the task.  The pilot verifier should first prove
that the generated data is internally valid.

Expected checker layers:

1. Data schema layer.
   - parse or mirror generated constants;
   - expose row ids, classes, coefficients, words, and slacks.
2. Arithmetic layer.
   - exact rational reductions;
   - positivity of slacks;
   - interval inclusion checks.
3. Combinatorial layer.
   - inverse words map to declared roots;
   - residues/classes are correct;
   - deletion marks obey the declared rule;
   - covered populations are disjoint where summed.
4. Architecture reuse layer.
   - reuse M0A `piStar` semantics when a semantic check is needed;
   - reuse M0B reachability and first-entry/fiber disjointness where possible;
   - reuse M0C only if the pilot includes abstract retarded rows.
5. Audit layer.
   - axiom audit for the generated verifier module;
   - no `sorry`, `admit`, `unsafe`, or `native_decide`;
   - no imported high-k theorem.

The verifier should make the generator replaceable.  If another generator emits
the same schema, Lean should check it without trusting how it was produced.

## Reuse From k=2

Likely reusable without changing the mathematics:

- M0A computable `piStar` semantics;
- Bool/Prop reachability bridge;
- entry-predecessor and fiber disjointness;
- root-count/base lemmas;
- exact rational data/verifier style;
- axiom-audit pattern;
- manifest discipline;
- empirical hook style.

Reusable as patterns, not as direct code:

- k=2 row/core injection lemmas;
- k=2 concrete `Phi`;
- k=2 M0C row contracts;
- row22/row25/row28 seam proofs;
- row28 V3 post-deletion case tree.

Known k=2-cabled components:

- mod 9 class names `{2,5,8}`;
- k=2 certificate constants and slacks;
- k=2 row ids and V3 rows;
- k=2 deletion/tree material;
- k=2 `concretePhi` class envelope;
- k=2 final M1-surrogate theorem statements.

## Gate Criteria

### `GO_TO_K9`

Proceed to the k=9 generator/verifier track only if:

- k=3 generator output is reproducible and fully manifested;
- Lean verifies all k=3 emitted rows/data without trusting the generator;
- rational slacks are positive and not microscopic;
- build/check time is reasonable;
- generated declarations or data tables remain maintainable;
- source normalization is documented and hash-custodied;
- the k=3 architecture clearly extrapolates to k=9/k=11.

### `CONDITIONAL_GO`

Proceed only after engineering fixes if:

- k=3 is mathematically valid but too slow;
- data layout needs batching or compression;
- proof checking works but requires generated helper lemmas;
- slacks are positive but require tighter rational interval policy;
- source manifests are adequate but generator determinism needs hardening.

### `NO_GO`

Do not open k=9 if:

- Lean checking explodes already at k=3;
- slacks are unstable or nearly zero without a reliable ledger;
- the generator cannot emit audit-ready artifacts;
- the verifier relies on trusting generator assertions;
- deletion/tree reconstruction is ambiguous;
- the pilot succeeds only by manual transcription.

## Minimal Next Implementation Plan

Recommended next tasks after this scoping:

1. `KL2003_F2_K3_GENERATOR_SCHEMA_v1`
   - define JSON/CSV schemas and manifests;
   - no math generation yet.
2. `KL2003_F2_K3_GENERATOR_PROTOTYPE_v1`
   - emit a small deterministic k=3 candidate dataset;
   - include exact rational placeholders only where source data is not ready.
3. `KL2003_F2_K3_RATIONAL_VERIFIER_SCRIPT_v1`
   - check schema, residues, words, rationals, and slacks outside Lean.
4. `KL2003_F2_K3_LEAN_DATA_VERIFIER_SCOPING_v1`
   - design Lean checker modules after the artifacts stabilize.

No k=9 Lean file should be opened before this pilot has a gate result.

## Guardrails

- No Lean k=9 module.
- No k=9 theorem claim.
- No k=11 `0.84` theorem claim.
- No full M1 theorem claim.
- No global Collatz claim.
- No trust in the Python generator without an independent verifier.
- No massive manual transcription as a substitute for source manifests.
- No floats as final certificate evidence.

## Verification For This Note

Required for this scoping pass:

```text
git diff --check
```

No Lean build is required because this note does not modify Lean files.

## Classification

```text
F2_K3_PILOT_SCOPED
GENERATOR_VERIFIER_ARCHITECTURE_DEFINED
K3_TRACKED_CLASS_CONVENTION_RECORDED
K3_GENERATOR_OUTPUT_SCHEMA_SCOPED
K3_LEAN_VERIFIER_EXPECTATIONS_SCOPED
GO_CONDITIONAL_GO_NO_GO_CRITERIA_DEFINED
HIGH_K_NOT_STARTED
NO_K9_THEOREM_CLAIM
NO_K11_084_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
