# F3 return-excursion split-edge holdout v1 report

Date: 2026-07-22.

Status:

```text
CANDIDATE_CERTIFICATE_EMPIRICAL
SPLIT_EDGE_HOLDOUT_PASS
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. Frozen inputs

```text
frozen_w_split_core_sha256 = 580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40
d0 = 5
D_fine = 6
fine_period = 2916
delta = 1/100
y_values = [8, 9, 10]
```

## 2. Ranges

Previously burned:

```text
[20737, 41473)
```

Holdout consumed by this report:

```text
[41473, 82945)
```

## 3. Acceptance criteria

PASS required all three:

```text
split_mismatch_count = 0
q_boundary_core_row_fraction <= 0.029582817727073607
weighted_ratio_lhs_over_rhs >= 1
```

The weighted ratio definition is:

```text
ratio = lhs_total / rhs_total
lhs_total = sum_i complete_core_row_count_i * (w_core^T M_split_core)_i
rhs_total = sum_i complete_core_row_count_i * (1 + delta) * w_core_i
```

## 4. Holdout result

Source:

```text
scripts/f3_return_excursion_split_edge_holdout_v1.py --phase holdout
```

Outputs:

```text
results/F3_RETURN_EXCURSION_SPLIT_EDGE_HOLDOUT_v1/holdout/summary.json
results/F3_RETURN_EXCURSION_SPLIT_EDGE_HOLDOUT_v1/holdout/split_state_counts.csv
results/F3_RETURN_EXCURSION_SPLIT_EDGE_HOLDOUT_v1/holdout/split_mismatches.csv
results/F3_RETURN_EXCURSION_SPLIT_EDGE_HOLDOUT_v1/holdout/manifest_sha256.csv
```

Summary:

```text
unique_parent_roots = 13824
core_roots = 13824
excluded_roots = 0

complete_core_rows = 40824
boundary_core_rows = 648
q_boundary_core_row_fraction = 0.015625
q_boundary_acceptance_budget = 0.029582817727073607
q_boundary_pass = true

split_mismatch_count = 0

lhs_total = 190.25527293586472
rhs_total = 184.78228356
weighted_ratio_lhs_over_rhs = 1.0296185828555777
weighted_pass_ratio_ge_1 = true

min_frozen_row_ratio_lhs_over_rhs = 1.0295828177270736
```

Channel counts over core roots:

```text
advanced_direct_c2 = 4608
advanced_parity_lift_c1 = 4608
advanced_sterile_tail_c0 = 4608
```

## 5. Verdict

The local verdict is:

```text
CANDIDATE_CERTIFICATE_EMPIRICAL
```

This is the first empirical candidate certificate produced by the F3 gate.

It is not a formal certificate and not a theorem. It says the frozen split-edge
operator, with exact multiplicity semantics and predeclared boundary budget,
passed the one-use holdout range.

## 6. Next accepted object

The next object is paper, not Lean:

```text
F3_SPLIT_EDGE_CERTIFICATE_PAPER_PAGE_v1
```

It must state the split-edge entries as inequalities:

```text
1. retarded channel;
2. advanced PHASE_B direct channel;
3. row22-style parity lift channel;
4. sterile / boundary Q lines;
5. exact finite one-third enumeration lemma over complete blocks;
6. support restriction to the 243-state split core;
7. weighted renewal inequality using the frozen rational vector.
```

Only after that page passes audit should any Lean planning begin.

## 7. Non-claims

```text
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_LEAN_OPERATOR
```

