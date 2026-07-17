# KL2003 F2 k=2 Generator Regression Scoping v1

Date: 2026-07-18

Status: `K2_GENERATOR_REGRESSION_SCOPED`

## Purpose

This note defines the k=2 regression contract for the future KL2003 generator.

Before the generator may emit real k=3 mathematical data, it must run in k=2
mode and reproduce the already proved manual k=2 formalization as data.  The
regression is a generator test, not a new proof target and not a reason to
change any theorem that has already been proved.

The generator must use the current high-k-parametric artifact format:

```text
KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2
```

with JSON + generated Lean data twins, canonical rational strings, and
manifest cross-hashes.

## Regression Principle

The manual k=2 lane is the source of truth for regression.

```text
If generated k=2 data differs mathematically from the proved k=2 manual
system, the generator is wrong.
```

Acceptable differences are limited to format/layout differences that preserve
all mathematical content and are explicitly documented.

Unacceptable differences are blockers of the generator.

## Artifacts To Reproduce

The generator in k=2 mode must reproduce the source-faithful V3 system, not the
historical V2 abstraction.

Required k=2 artifacts:

- row system V3, source-faithful;
- row22 shape;
- row25 shape;
- row28 shape;
- meta-errata resolved: `M1V3` uses the `phi25` arm;
- row28 V3 class-8 `c'` split behavior;
- certificate variables/endpoints/constants;
- rational row slacks;
- deletion behavior and Figure A1 material where applicable;
- post-deletion marks;
- generated JSON artifact in format v2;
- generated Lean data artifact in format v2;
- manifest with `json_sha256`, `lean_data_sha256`, and
  `json_to_lean_generator_sha256`.

The generator should not attempt to reproduce k=2 as a prose summary.  It must
emit data that a verifier can check.

## Manual Lean Baseline

The following modules define the k=2 truth baseline.

Core certificate and endpoint baseline:

```text
CollatzClassical/KL2003/KL2003K2CertificateData.lean
CollatzClassical/KL2003/KL2003K2CertificateVerifier.lean
CollatzClassical/KL2003/KL2003K2AlphaBounds.lean
CollatzClassical/KL2003/KL2003K2TranscendentalEndpoints.lean
```

Semantic and combinatorial baseline:

```text
CollatzClassical/KL2003/KL2003M0APiStarSemantics.lean
CollatzClassical/KL2003/KL2003M0BReachabilityAPI.lean
CollatzClassical/KL2003/KL2003M0BEntryPredecessorDisjointness.lean
CollatzClassical/KL2003/KL2003M0BTwoBranchCore.lean
CollatzClassical/KL2003/KL2003M0BD123CoreInstantiations.lean
```

Abstract induction and concrete seam baseline:

```text
CollatzClassical/KL2003/KL2003M0CRetardedInduction.lean
CollatzClassical/KL2003/KL2003ConcretePhiRealization.lean
CollatzClassical/KL2003/KL2003RootCountUnitBase.lean
```

Final k=2 surrogate packaging:

```text
CollatzClassical/KL2003/KL2003M1Surrogate.lean
```

Axiom-audit files attached to these modules are also part of the regression
custody baseline.

## Source-Custody Baseline

The generator should compare against the k=2 notes and outputs that explain
why the current manual Lean statements are source-faithful.

Required documentation baseline:

```text
docs/KL2003_META_ERRATA_M1_PHI5_REINSTATEMENT_v1.md
docs/KL2003_M0C_ROWS_V3_PHI5_CONTRACT_AND_RECHECK_SCOPING_v1.md
docs/KL2003_M0C_ROWS_V3_PHI5_LEAN_MIGRATION_v1.md
docs/KL2003_CONCRETE_PHI_ROW22_SEAM_LEAN_v1.md
docs/KL2003_CONCRETE_PHI_ROW25_SEAM_LEAN_v1.md
docs/KL2003_CONCRETE_PHI_ROW28_SEAM_V3_LEAN_v1.md
docs/KL2003_ROW28_V3_MOD8_CP_SPLIT_AND_ROWSV3_FINAL_LEAN_v1.md
docs/KL2003_ROW28_V3_MOD8_CP_SPLIT_LEAN_v1.md
docs/KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_AUDIT_v1.md
docs/KL2003_DELETION_RULE_SOURCE_AUDIT_v1.md
docs/KL2003_ROW28_POST_DELETION_PATTERN_LEDGER_v1.md
docs/KL2003_K2_CERTIFICATE_ENDPOINT_UNIFICATION_BLO_UPGRADE_v1.md
docs/KL2003_K2_CERTIFICATE_VERIFIER_LEAN_v1.md
docs/KL2003_M1_SURROGATE_FINAL_REVIEW_AND_PACKAGE_v1.md
```

Required output baseline:

```text
outputs/KL2003_K2_INTERIOR_RATIONAL_CERTIFICATE_v1/
outputs/KL2003_K2_LAMBDA_POWER_INTERVAL_CERTIFICATION_v1/
outputs/KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1/
outputs/KL2003_ROW28_V3_LITERAL_WORD_TABLE_RECOVERY_v1/
```

These are not new trusted axioms.  They are custody material for deciding
whether generated k=2 data matches the already checked manual line.

## Comparison Rules

The regression comparison should produce a machine-readable diff report.

Expected report location:

```text
outputs/KL2003_F2_K2_GENERATOR_REGRESSION_v1/
```

Expected report files:

```text
summary.json
manual_vs_generated_rows.csv
manual_vs_generated_certificate.csv
manual_vs_generated_deletion.csv
manual_vs_generated_manifest.csv
mismatch.csv
manifest_sha256.csv
```

### Format-Only Differences

Allowed format-only differences:

- stable generated ids differ from manual theorem names, if a map is emitted;
- JSON row ordering differs, if row ids are stable and sorted output is
  reproducible;
- generated Lean declaration names differ, if theorem/data mapping is explicit;
- coefficients are expressed with different but canonical rational labels, if
  exact rational values match;
- the generated schema includes extra diagnostic fields ignored by the verifier.

Every format-only difference must be listed with:

```text
diff_id
manual_ref
generated_ref
why_format_only
review_status
```

### Mathematical Blockers

Blocker differences:

- V2 shape appears instead of V3;
- `M1V3` second arm is `phi22` rather than `phi25`;
- row22/row25/row28 shapes differ in mathematical content;
- row28 class-8 `c'` split is absent or replaced by a circular argument;
- certificate endpoints/constants differ without a source-approved reason;
- rational slack values differ;
- deletion marks differ;
- Figure A1/post-deletion behavior differs;
- generated data requires trusting a wrapper rather than checking named
  obligations;
- generated Lean data is not reproducible from JSON;
- manifest cross-hashes are missing or inconsistent.

Any blocker yields:

```text
K2_REGRESSION_FAIL
```

## Metrics

The k=2 regression summary must report:

```text
row_count
literal_count
child_count
deletion_count
kept_literal_count
certificate_constant_count
certificate_variable_count
slack_count
min_slack
min_slack_row_id
rational_numerator_max_digits
rational_denominator_max_digits
generated_json_size_bytes
generated_lean_data_size_bytes
generated_lean_data_line_count
generator_runtime_seconds
json_sha256
lean_data_sha256
json_to_lean_generator_sha256
format_only_diff_count
mathematical_diff_count
```

These metrics are used to decide whether k=3 generation is likely to be
manageable and whether k=9/k=11 projection is credible.

## Regression Criteria

### `K2_REGRESSION_PASS`

The generator may proceed to k=3 only if:

- V3 source-faithful rows are reproduced;
- row22/row25/row28 shapes match;
- `M1V3` uses `phi25`;
- certificate/endpoints/constants match the manual k=2 baseline;
- deletion behavior matches;
- slacks match exactly or by a documented canonical rational representation;
- generated JSON and Lean data use format v2;
- manifest cross-hashes are present and consistent;
- no mathematical diff remains.

### `K2_REGRESSION_FORMAT_DIFF_ONLY`

The generator may proceed only after human review if:

- mathematical content matches;
- all differences are format/layout/name/order differences;
- every difference is documented and mapped to the manual baseline.

### `K2_REGRESSION_FAIL`

The generator must not proceed to k=3 if:

- any mathematical diff is detected;
- V3/meta-errata is not reproduced;
- row/deletion/certificate/slack content differs;
- generated data is not reproducible;
- the verifier would have to trust generator assertions.

## Guardrails

- Do not use k=2 regression to modify already proved k=2 theorems.
- If there is a diff, fix the generator or document it as format-only.
- Do not generate k=3 in this regression task.
- Do not open new Lean unless explicitly requested.
- Do not claim a high-k theorem.
- Do not claim the k=11 `0.84` theorem.
- Do not make a global Collatz claim.

## Verification For This Note

Required:

```text
git diff --check
```

No Lean build is required because this note does not modify Lean files.

## Classification

```text
K2_GENERATOR_REGRESSION_SCOPED
MANUAL_K2_BASELINE_DEFINED
META_ERRATA_V3_REQUIRED
K2_REGRESSION_PASS_CRITERIA_DEFINED
K2_REGRESSION_FORMAT_DIFF_ONLY_DEFINED
K2_REGRESSION_FAIL_CRITERIA_DEFINED
NO_K3_GENERATION
NO_HIGH_K_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
