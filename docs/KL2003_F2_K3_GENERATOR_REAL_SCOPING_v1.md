# KL2003 F2 k=3 Real Generator Scoping v1

Date: 2026-07-18

Status: `K3_REAL_GENERATOR_SCOPED`

## Purpose

This note scopes the first KL2003 generator pass that may emit mathematical
content for the k=3 pilot.

The generator must target the existing high-k-parametric data format:

```text
KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2
```

That format already requires:

- canonical JSON for external audit;
- deterministic generated Lean data;
- canonical rational strings;
- cross-hashes for JSON, generated Lean data, and JSON-to-Lean generation;
- schema validation before any verifier consumes the data.

This task does not generate k=3 data, does not solve an LP, and does not open
Lean.  It fixes the contract that a future real generator must satisfy.

## Scope

The first real generator target is k=3 only.

Required class counts:

```text
k = 3
tracked classes mod 27 = 3^(3 - 1) = 9
pre-reduction classes  = 3^3       = 27
```

Out of scope:

- k=9 generation;
- k=11 generation;
- the k=11 `0.84` theorem;
- any high-k Lean theorem;
- any global Collatz claim.

k=3 is a method pilot.  It measures whether the generator/data/verifier
architecture is viable before any high-k escalation.  It is not the main
high-k result.

## Primary Source Check

Primary local source:

```text
/Users/MoiTam/Documents/Codex/2026-07-05/tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/kl2003_src/30apr02.tex
sha256 = 04fa4d484fe89256f6771f5651338891219385f6e049ffaf41035541016232cd
```

Relevant source range:

```text
30apr02.tex:1543-1578
```

Table header:

```text
30apr02.tex:1549-1556
```

The table columns are:

```text
k
gamma_k
lambda_k
C_k^max
bar c_{k,k}
bar c_{k-1,k}
bar c_{k,k} - bar c_{k-1,k}
```

The k=3 row is printed:

```text
30apr02.tex:1559
3 & 0.6112620 & 1.5275960 & 3.4881908 & 2.1014900 & 1.6994294 & 0.4020606
```

Thus the source prints:

```text
gamma_3  = 0.6112620
lambda_3 = 1.5275960
C_3^max  = 3.4881908
```

Generator fidelity requirement:

If the k=3 generator computes or records high-level NLP/NT summary constants,
its emitted metadata must compare against the source row above.  Any mismatch
between generated `lambda_3`/`gamma_3` diagnostics and this table is a generator
blocker, not an invitation to modify the source table or the k=2 theorem.

The table values are decimal source diagnostics.  They are not final rational
certificate evidence.  Exact verifier inputs must still use canonical rational
strings and rational intervals.

## k=2 Regression Requirement

The real generator must support a k=2 regression mode before k=3 output is
trusted.

In k=2 mode, it must reproduce the already proved manual system as data:

- V3 source-faithful row contract;
- row22 seam;
- row25 seam;
- row28 seam with the V3 `phi25` arm;
- row28 class-8 `c'` split behavior;
- certificate/endpoints used by the k=2 verifier;
- deletion behavior and post-deletion policy;
- JSON + generated Lean data using the v2 format;
- manifest with JSON/data/generator cross-hashes.

Regression rule:

```text
Any diff against the proved k=2 manual architecture is a blocker of the
generator, not an adjustment of the theorem already proved.
```

Expected regression outputs:

```text
outputs/KL2003_F2_K3_GENERATOR_REAL_v1/k2_regression/
```

Expected comparison targets:

- `concretePhi_rowsV3`;
- `m0c_retarded_induction_bound_v3`;
- `kl2003_k2_m1_surrogate_ceil_window_lower_bound`;
- `kl2003_k2_m1_surrogate_arbitrary_x_lower_bound`;
- k=2 certificate data and verifier constants;
- row22/row25/row28 source-faithful seam notes.

The generator is not accepted for k=3 if k=2 regression fails.

## k=3 Generation Contract

The k=3 generator should emit the first mathematical-content artifacts in:

```text
outputs/KL2003_F2_K3_GENERATOR_REAL_v1/
```

Required generated content:

- tracked classes and pre-reduction classes;
- post-deletion trees;
- inverse words;
- row system;
- row children/literals;
- deletion marks;
- window policies;
- LP/certificate candidate;
- exact rational certificate intervals;
- exact positive row slacks;
- generated Lean data file;
- manifest with cross-hashes.

The canonical JSON artifact should be named:

```text
kl2003_k3_certificate.json
```

The generated Lean data artifact should be named:

```text
KL2003K3CertificateData.lean
```

Both must follow:

```text
KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2
```

Manifest requirements:

```text
json_sha256
lean_data_sha256
json_to_lean_generator_sha256
```

Every mathematical number must be a canonical rational string:

- reduced;
- denominator positive;
- sign only on numerator;
- integers written as `"n"`, not `"n/1"`;
- no leading zeros except `"0"`;
- no floats.

## Trust Boundary

The trust boundary is unchanged from the schema-v2 decision.

Untrusted:

- Python generator;
- LP solver output;
- JSON artifact by itself;
- generated Lean data by itself;
- empirical hooks;
- float diagnostics.

Trusted only after checking:

- Lean verifier theorems over generated Lean data;
- exact rational arithmetic checks;
- residue/route/deletion/disjointness checks;
- named verifier obligations.

Policy:

```text
JSON is provenance.
Generated .lean is data.
Verifier theorems are the proof boundary.
```

No theorem may take the generator output or certificate as an axiom.

## Required F2 Metrics

Every real generator run must emit a summary with at least:

```text
run_id
k
schema_version
source_commit
source_inputs
row_count
child_literal_count
deletion_count
kept_literal_count
rational_numerator_max_digits
rational_denominator_max_digits
min_slack
min_slack_row_id
generator_runtime_seconds
json_sha256
lean_data_sha256
json_to_lean_generator_sha256
estimated_lean_data_declaration_count
estimated_lean_verifier_theorem_count
estimated_lean_verifier_size_lines
projected_k9_row_count
projected_k11_row_count
projected_k9_child_literal_count
projected_k11_child_literal_count
guardrails
```

Scale references:

```text
k=2  tracked classes = 3
k=3  tracked classes = 9
k=9  tracked classes = 6561
k=11 tracked classes = 59049
```

The projected k=9/k=11 metrics are estimates only.  They are gate inputs, not
theorem claims.

## Empirical Hook

The generator must include a member-wise empirical hook before Lean verifier
work begins.

Required hook:

```text
member-wise sampling against the validated piStar semantics
```

The hook should check sampled generated populations by actual finite
membership, not just cardinalities.

Required outputs:

```text
summary.json
sample_grid.csv
mismatch.csv
manifest_sha256.csv
```

The row28 lesson is binding:

```text
member-wise or nothing
```

Do not use infinite-truncation tests, large-cardinality spot checks, or
aggregate counts as proof.  They may be diagnostics, but the Lean verifier must
still discharge the mathematical obligations.

## Gate Criteria

### `GO_TO_K9`

Open the k=9 generator/verifier lane only if:

- k=2 regression is exact;
- k=3 generator emits v2 JSON + Lean data deterministically;
- k=3 schema validation passes;
- k=3 member-wise hook has no unexplained mismatches;
- verifier plan is stable;
- exact rational slacks are positive and not fragile;
- generated data size is manageable;
- projected k=9/k=11 scale is plausible;
- source-vs-generated `lambda_3`/`gamma_3` diagnostics match the TeX table.

### `CONDITIONAL_GO`

Proceed only after engineering fixes if:

- k=2 regression is exact;
- k=3 generation works;
- schema and hooks pass;
- but Lean/data layout requires batching, compression, or optimized checker
  generation.

### `NO_GO`

Do not open k=9 if:

- k=2 regression fails;
- k=3 generator cannot emit audit-stable artifacts;
- schema-v2 validation fails;
- member-wise hook finds unexplained mismatches;
- exact rational slacks are zero, negative, or unstable;
- generated data is enormous without a verifier strategy;
- the generator relies on manual transcription or trusted wrappers.

## Guardrails

- No real k=3 data generated in this task.
- No LP solved in this task.
- No Lean opened in this task.
- No k=9 generation.
- No k=11 generation.
- No high-k theorem claim.
- No k=11 `0.84` theorem claim.
- No global Collatz claim.

## Verification For This Note

Required:

```text
git diff --check
```

No Lean build is required because no Lean files are modified.

## Classification

```text
K3_REAL_GENERATOR_SCOPED
K2_REGRESSION_REQUIRED
LAMBDA3_SOURCE_CHECK_REQUIRED
GENERATOR_OUTPUT_FORMAT_V2_REQUIRED
LEAN_VERIFIER_TRUST_BOUNDARY_RESTATED
MEMBERWISE_HOOK_REQUIRED
NO_K3_DATA_GENERATED
NO_HIGH_K_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
