# F3 return-excursion split-edge holdout v1 calibration report

Date: 2026-07-22.

Status:

```text
Q_BOUNDARY_CALIBRATION_PUBLISHED
HOLDOUT_NOT_OPENED
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

## 2. Calibration range

```text
[1, 10369)
```

This is the already-used calibration side. No holdout range is opened by this
report.

## 3. Boundary measurement

Source:

```text
scripts/f3_return_excursion_split_edge_holdout_v1.py --phase calibration
```

Output:

```text
results/F3_RETURN_EXCURSION_SPLIT_EDGE_HOLDOUT_v1/calibration/summary.json
results/F3_RETURN_EXCURSION_SPLIT_EDGE_HOLDOUT_v1/calibration/split_state_counts.csv
results/F3_RETURN_EXCURSION_SPLIT_EDGE_HOLDOUT_v1/calibration/split_mismatches.csv
results/F3_RETURN_EXCURSION_SPLIT_EDGE_HOLDOUT_v1/calibration/manifest_sha256.csv
```

Summary:

```text
unique_parent_roots = 3455
core_roots = 3455
excluded_roots = 0

complete_core_rows = 9477
boundary_core_rows = 888
q_boundary_core_row_fraction = 0.08567293777134588
split_mismatch_count = 0
```

The calibration interval is short relative to `fine_period = 2916`, so the raw
boundary fraction is not used alone as the holdout budget.

## 4. Acceptance budget

The predeclared holdout boundary budget is:

```text
min(calibration_q_boundary_core_row_fraction,
    min_frozen_row_ratio_lhs_over_rhs - 1)
```

Numerically:

```text
min_frozen_row_ratio_lhs_over_rhs = 1.0295828177270736
q_boundary_acceptance_budget = 0.029582817727073607
```

Thus holdout must satisfy:

```text
holdout_q_boundary_core_row_fraction <= 0.029582817727073607
```

## 5. Next step

The next and only next holdout range for this object is:

```text
[41473, 82945)
```

It is still unopened at this point.

## 6. Non-claims

```text
NO_HOLDOUT_RESULT
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_LEAN_OPERATOR
```

