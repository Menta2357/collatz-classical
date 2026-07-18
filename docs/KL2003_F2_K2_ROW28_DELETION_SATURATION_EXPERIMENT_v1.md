# KL2003 F2 k=2 Row28 Deletion Saturation Experiment v1

Date: 2026-07-19

Status: `ROW28_DELETION_SATURATION_FIGURE_A1_PASS`

## Purpose

This experiment tests the k=2 row28 deletion-saturation policy before the
row28 microgenerator is implemented.

It derives the row28 expansion tree from the KL2003 TeX rules, applies the
deletion rule to newly created min leaves, and expands until a fixed point or a
safety limit.  Figure A1/root_paths is read only after generation, as a
regression oracle.

This is not a Lean proof, not a row28 generator, not k=3 generation, and not a
high-k theorem.

## Source And Oracle

Source:

```text
/Users/MoiTam/Documents/Codex/2026-07-05/tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/kl2003_src/30apr02.tex
sha256 = 04fa4d484fe89256f6771f5651338891219385f6e049ffaf41035541016232cd
```

Source ranges used:

```text
D1_D2_D3 = 433-445
phi_kminus1_min = 450-451
back_substitution_setup = 680-703
splitting_tree_step = 752-761
deletion_rule = 763-779
termination_theorem = 794-801
```

Oracle, not generator source:

```text
outputs/KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1/root_paths.csv
outputs/KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1/nodes.csv
outputs/KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1/edges.csv
```

## Outputs

```text
scripts/kl2003_f2_k2_row28_deletion_saturation_experiment_v1.py
outputs/KL2003_F2_K2_ROW28_DELETION_SATURATION_EXPERIMENT_v1/generation_summary.json
outputs/KL2003_F2_K2_ROW28_DELETION_SATURATION_EXPERIMENT_v1/generated_nodes.csv
outputs/KL2003_F2_K2_ROW28_DELETION_SATURATION_EXPERIMENT_v1/generated_edges.csv
outputs/KL2003_F2_K2_ROW28_DELETION_SATURATION_EXPERIMENT_v1/deletion_trace.csv
outputs/KL2003_F2_K2_ROW28_DELETION_SATURATION_EXPERIMENT_v1/saturation_trace.csv
outputs/KL2003_F2_K2_ROW28_DELETION_SATURATION_EXPERIMENT_v1/figure_a1_oracle_diff.csv
outputs/KL2003_F2_K2_ROW28_DELETION_SATURATION_EXPERIMENT_v1/mismatch.csv
outputs/KL2003_F2_K2_ROW28_DELETION_SATURATION_EXPERIMENT_v1/manifest_sha256.csv
```

## Verdict

```text
verdict = ROW28_DELETION_SATURATION_FIGURE_A1_PASS
generated_node_count = 16
generated_edge_count = 15
generated_max_depth = 3
generated_graph_max_path_length = 6
deleted_node_count = 2
figure_a1_oracle_deleted_nodes = N04, N05
figure_a1_mismatch_count = 0
rounds = 3
saturation_reached = true
safety_limit_hit = false
```

The deletion trace deletes the two class-8 repeats required by the oracle:

```text
G04: mode 8, shift alpha-1, deleted against ancestor G00 at shift 0
G10: mode 8, shift 2*alpha-3, deleted against ancestor G00 at shift 0
```

The mismatch file contains only its header.

## Determinism Check

The script was run twice after compilation.  The deterministic CSV artifacts
kept stable SHA256 hashes:

```text
generated_nodes.csv = b28c275ee5d3c0e289f492df03e58d4236f7f03b17fadd9a1a345360d18afd58
generated_edges.csv = b881cc8083a22840950fa9a581de1321969f9bd09270f8a9fcc9425ab1852e61
deletion_trace.csv = 4dc57fd35efd8ad81fe4b071c0910cbd02cf766f0206e179d972c1c8db471dbe
saturation_trace.csv = b0c6eb6084a1a087c3880b6cf949eb3989e55bfe41814c5d8697e0a473a33cd1
figure_a1_oracle_diff.csv = c0b41effaf0fff50e06aa43a2c765f255e7150b4ef27b87035554d35976cb896
mismatch.csv = 988f0a9a6f04df34a35b1a81a36704d0bb0f5261b6078a8acb3e3a1ce9c5df20
```

The JSON summary and manifest include run timestamps and are not intended to be
byte-identical across runs.

## Scope

This validates the k=2 row28 deletion-saturation policy against the source
custody and Figure A1 oracle:

```text
K2_DELETION_SATURATION_ORACLE_VALIDATED
```

It does not prove the general high-k termination principle:

```text
GENERAL_K_DELETION_SATURATION_UNPROVED
```

The row28 microgenerator remains unimplemented.

## Classification

```text
ROW28_DELETION_SATURATION_EXPERIMENT_CREATED
PARAMETRIC_DELETION_RULE_EXECUTED
FIGURE_A1_USED_AS_REGRESSION_ORACLE_ONLY
ROW28_DELETION_SATURATION_FIGURE_A1_PASS
K2_DELETION_SATURATION_ORACLE_VALIDATED
GENERAL_K_DELETION_SATURATION_UNPROVED
ROW28_GENERATOR_NOT_STARTED
NO_K3_GENERATION
NO_HIGH_K_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
