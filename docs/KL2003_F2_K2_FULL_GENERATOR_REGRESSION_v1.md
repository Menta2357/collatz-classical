# KL2003 F2 k=2 Full Generator Regression v1

Date: 2026-07-19

Status: `K2_REGRESSION_PASS`

## Scope

This pass closes the k=2 generator regression required before any real k=3
generation.  It does not prove a new theorem and does not replace the existing
manual Lean formalization.  The manual k=2 V3 line remains the source of truth.

The regression consists of:

- rule-derived row25;
- rule-derived row22 with parity lift;
- rule-derived row28 with nested EL, parametric deletion, and `cPrime` split;
- exact rational rechecking of the known k=2 certificate candidate;
- machine-readable diffs against the manual V3, certificate, and Figure A1
  baselines.

## Row28 Result

The Row28 generator is:

```text
scripts/kl2003_f2_k2_row28_microgenerator_v1.py
```

It emits the high-k schema v2.1 JSON/Lean twins under:

```text
outputs/KL2003_F2_K2_ROW28_MICROGENERATOR_v1/
```

The generator derives the EL tree before reading Figure A1.  The Figure
transcription is used only as a regression oracle.

Results:

```text
ROW28_MICROGENERATOR_DIFF_PASS
FIGURE_A1_DELETION_DIFF_PASS
generated_tree_node_count = 16
generated_tree_edge_count = 15
deleted_node_count = 2
deleted Figure nodes = {N04, N05}
diff_failure_count = 0
```

The nested artifact records:

```text
M2V3 = min3(phi22, phi25, phi28)
M1V3 = min(phi28 + M2V3, phi25)
row28 outer = min(phi28 + M1V3, phi22)
```

The source-faithful guardrail is explicit: the second arm of `M1V3` is
`phi25`; the historical `phi22` arm is not emitted.

## Row28 Validation

The independent validator is:

```text
scripts/kl2003_f2_k2_row28_microgenerator_validation_v1.py
```

It checks the shared v2.1 schema, trace, semantic diff, Figure A1 diff,
decision points, and a finite member-wise diagnostic hook.

Result:

```text
ROW28_MICROGENERATOR_VALIDATION_PASS
schema_ok = true
trace_ok = true
semantic_ok = true
figure_a1_ok = true
decision_ok = true
memberwise_ok = true
memberwise_sample_count = 30
direct c classes seen = {2,5,8}
cPrime classes seen = {2,5,8}
```

The hook is diagnostic only and is not part of the logical base.

## Full k=2 Regression

The full assembler and exact rational checker is:

```text
scripts/kl2003_f2_k2_full_generator_regression_v1.py
```

Outputs:

```text
outputs/KL2003_F2_K2_GENERATOR_REGRESSION_v1/
```

The three rows are taken from their rule-derived microgenerator artifacts.
`M1V3` is compared as the nested auxiliary block, giving four regression
items in total.

The certificate candidate variables and certified endpoint intervals are read
from the existing k=2 custody artifacts.  The row slacks are then recomputed
with exact `Fraction` arithmetic before comparison with the manual baseline:

```text
D1 = A*c28 + B_lo*c12 - c22 = 29/9720
D2 = A*c22 - c25            = 271/729000
D3 = A*c25 + D_lo*c12 - c28 = 2077/145800
```

Result:

```text
K2_REGRESSION_PASS
row_count = 3
regression_item_count = 4
literal_count = 15
kept_literal_count = 13
deletion_count = 2
certificate_constant_count = 9
certificate_variable_count = 5
slack_count = 3
min_slack = 271/729000
mathematical_diff_count = 0
format_only_diff_count = 0
```

`mismatch.csv` contains only its header.

## Reproducibility

The generated canonical JSON and Lean twins were regenerated twice on the
same source commit.  Their hashes remained byte-identical:

```text
row28 JSON  = 2f93f459883529fa290f40548f4a1b9d9d075e93b4e4196fa3b9d23b0361f0f4
row28 Lean  = 821e584f8c7e74282aa33a30f2831484b628671f49883ab3a6949821937af28c
full JSON   = cea076e7c6f5604586c949bc9ce9526d53f55b25c4ebd08b1d146338b95979ee
full Lean   = ba8409dbd10f721ff5b8b99f7c1e9dd1bfbc2d2ec8abc95c2a9e89e2763d29f9
```

Run timestamps remain in summaries/manifests, not in the canonical generated
data twins.

## Trust Boundary

The generated Lean files remain under `outputs/` and are not imported.  This
pass verifies generator regression and exact rational arithmetic, not a new
kernel theorem.

The next F2 phase is the real k=3 pilot:

```text
generator -> v2.1 JSON/Lean data -> LP/certificate -> Lean verifier
```

The k=3 pilot must not treat this successful regression as a proof of general-k
correctness.  It must emit independently checkable data and a verifier must
recheck it.

## Guardrails

```text
NO_GENERATED_LEAN_IMPORT
NO_NEW_LEAN_THEOREM
NO_K3_GENERATION_THIS_PASS
NO_LP_SOLVE_THIS_PASS
NO_K9_THEOREM_CLAIM
NO_K11_084_CLAIM
NO_FULL_M1_THEOREM_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```

## Classification

```text
K2_ROW28_MICROGENERATOR_CREATED
ROW28_MICROGENERATOR_VALIDATION_PASS
ROW28_SCHEMA_V21_PASS
FIGURE_A1_TREE_DIFF_PASS
ROW28_MEMBERWISE_HOOK_PASS
K2_REGRESSION_PASS
K2_RULE_DERIVED_ROWS_REPRODUCED
K2_CERTIFICATE_SLACKS_RECOMPUTED_EXACTLY
META_ERRATA_V3_PHI25_REPRODUCED
FIGURE_A1_DELETION_REPRODUCED
FULL_K2_GENERATOR_REGRESSION_COMPLETE
K3_PILOT_NOT_STARTED
NO_HIGH_K_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
