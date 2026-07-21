# F3 return-excursion split-edge holdout v1 contract

Date: 2026-07-22.

Status before holdout:

```text
SPLIT_EDGE_HOLDOUT_CONTRACT_PREDECLARED
Q_BOUNDARY_CALIBRATION_REQUIRED_BEFORE_HOLDOUT
NO_HOLDOUT_OPENED_BY_CONTRACT
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. Frozen inputs

```text
d0 = 5
D_fine = d0 + 1 = 6
fine_period = 4 * 3^D_fine
rho_star = 9/5
delta = 1/100
y_values = [8, 9, 10]
frozen_w_split_core_sha256 = 580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40
```

The script must verify this hash before either calibration or holdout.

## 2. Population split hook

Rows are indexed by `(core_state, y)`.

For each core source state, roots are classified by the missing fine digit:

```text
fine_lift in {0, 1, 2}
```

Complete blocks are the largest equal triples across the three fine lifts:

```text
complete_roots(state) = 3 * min(count_lift_0, count_lift_1, count_lift_2)
```

Boundary roots are:

```text
boundary_roots(state)
  = count_lift_0 + count_lift_1 + count_lift_2 - complete_roots(state)
```

Complete roots split exactly in thirds. Boundary roots are charged to
`Q_boundary`.

## 3. Calibration budget

Before holdout, run the script on the calibration range:

```text
[1, 10369)
```

and publish:

```text
q_boundary_core_row_fraction
```

The holdout acceptance line is:

```text
holdout_q_boundary_core_row_fraction
  <= min(calibration_q_boundary_core_row_fraction, min_frozen_row_ratio_lhs_over_rhs - 1)
```

This prevents a short calibration range from authorizing a boundary budget
larger than the post-freeze supercritical margin.

## 4. Holdout range

Burned range:

```text
[20737, 41473)
```

Fresh one-use holdout range:

```text
[41473, 82945)
```

## 5. Acceptance

Holdout PASS requires all three:

```text
split_mismatch_count = 0
q_boundary_core_row_fraction <= calibration budget
weighted_ratio_lhs_over_rhs >= 1
```

The weighted ratio is:

```text
ratio = lhs_total / rhs_total
lhs_total = sum_i complete_core_row_count_i * (w_core^T M_split_core)_i
rhs_total = sum_i complete_core_row_count_i * (1 + delta) * w_core_i
```

The script must also print:

```text
min_frozen_row_ratio_lhs_over_rhs
```

from the frozen vector.

Allowed holdout outcomes:

```text
CANDIDATE_CERTIFICATE_EMPIRICAL
HOLDOUT_FAIL_SPLIT_MISMATCH
HOLDOUT_FAIL_Q_BOUNDARY_BUDGET
HOLDOUT_FAIL_WEIGHTED_INEQUALITY
```

Forbidden:

```text
RHO_CERTIFIED
DENSITY_THEOREM
ALMOST_ALL
GLOBAL_COLLATZ
LEAN_READY
```
