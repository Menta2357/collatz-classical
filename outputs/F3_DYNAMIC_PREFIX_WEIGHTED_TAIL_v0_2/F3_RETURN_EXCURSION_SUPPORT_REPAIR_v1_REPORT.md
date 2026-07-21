# F3 return-excursion support repair v1 report

Date: 2026-07-22.

Status:

```text
CORE_RESTRICTION_FREEZE_PASS_HOLDOUT_READY
FROZEN_W_CORE_PUBLISHED
HOLDOUT_NOT_OPENED
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. Purpose

`F3_RETURN_EXCURSION_FREEZE_W_v1` stopped because the global v2 matrix is
reducible. The global left Perron vector has zero support on 594 states, so a
global floor cannot satisfy the supercritical inequality.

This repair replaces the failed floor with the standard Perron-Frobenius move:
restrict to the dominant recurrent component.

## 2. Core restriction

Source:

```text
scripts/f3_return_excursion_support_repair_v1.py
```

The script builds SCCs of the v2 directed support graph and selects the SCC
with maximal restricted spectral radius.

Result:

```text
global_state_count = 729
global_scc_count = 443
core_component_id = 436
core_state_count = 135
excluded_state_count = 594

global_spectral_radius = 1.0147870480474108
core_spectral_radius = 1.0147870480474128
core_left_eigenvalue = 1.0147870480474157
```

The core check passes:

```text
core_size = 135
rho(M_core) = rho(M_global) within tolerance
w_core strictly positive
```

Core finite description:

```text
core_residue_mod_9_counts:
  2 -> 45
  5 -> 45
  8 -> 45

core_bucket_counts:
  0 -> 27
  1 -> 27
  2 -> 81

core_parity_counts:
  even -> 108
  odd -> 27
```

The exact decidable domain is recorded in:

```text
results/F3_RETURN_EXCURSION_SUPPORT_REPAIR_v1/core_states.csv
```

## 3. Frozen core vector

Predeclared parameters:

```text
D = 1000000
delta = 1/100
```

Rationalization:

```text
integer_weight_s = max(1, floor(D * w_s))
rational_weight_s = integer_weight_s / D
```

Re-verification:

```text
w_core^T M_core >= (1 + delta) w_core^T
```

after rationalization.

Result:

```text
core_integer_weight_sum = 999935
core_bad_state_count = 0
core_min_ratio_lhs_over_rhs = 1.0016695723565237
core_reverify_pass = true
```

Frozen vector:

```text
results/F3_RETURN_EXCURSION_SUPPORT_REPAIR_v1/frozen_w_core.csv
sha256 = ad4c4627f575f60911f3b943c92cd3937686f9924592dbf33f6e988d7a9dbb53
```

## 4. Excluded states

The functional is now defined only over the 135-state core. This is a support
restriction of the claimed weighted lower-bound functional, not an enlargement.

The 594 excluded states receive weight zero in this candidate object. They are
not asserted absent from the real tree. They are outside the dominant recurrent
support of this finite return operator.

## 5. Holdout status

The predeclared holdout range remains unopened:

```text
20737 <= a < 41473
```

This report freezes `w_core` and makes the next holdout step eligible. It does
not run holdout.

## 6. Next accepted object

The next object is:

```text
F3_RETURN_EXCURSION_CORE_HOLDOUT_v1
```

It must use exactly:

```text
M_core from this support repair
frozen_w_core.csv with sha256 ad4c4627f575f60911f3b943c92cd3937686f9924592dbf33f6e988d7a9dbb53
d0 = 5
rho_star = 9/5
delta = 1/100
y_values = [8, 9, 10]
holdout range = [20737, 41473)
```

Any hook mismatch or weighted inequality failure is a holdout FAIL and burns
that range.

## 7. Non-claims

```text
NO_HOLDOUT_RESULT
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_LEAN_OPERATOR
```

