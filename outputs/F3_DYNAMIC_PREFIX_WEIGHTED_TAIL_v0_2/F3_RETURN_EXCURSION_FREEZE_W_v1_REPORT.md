# F3 return-excursion freeze-w v1 report

Date: 2026-07-22.

Status:

```text
STOP_FREEZE_W_SUPPORT_REDUCIBLE
HOLDOUT_NOT_OPENED
NO_FROZEN_W
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. Contract executed

This report executes:

```text
F3_RETURN_EXCURSION_FREEZE_W_AND_HOLDOUT_CONTRACT_v1.md
```

Predeclared parameters:

```text
operator = F3_PHASE_B_RETURN_EXCURSION_OPERATOR_v2
d0 = 5
rho_star = 9/5
delta = 1/100
D = 1000000
holdout range if freeze passes = [20737, 41473)
```

No holdout data was opened.

## 2. Freeze rule

The attempted rule was:

```text
w = left Perron eigenvector of the rule-derived v2 matrix
```

with matrix convention:

```text
M[source, target] += edge_weight
w^T M >= (1 + delta) w^T
```

Rationalization:

```text
normalize w to sum 1
integer_weight_s = max(1, floor(D * w_s))
rational_weight_s = integer_weight_s / D
```

The vector must re-verify after rationalization before it can be frozen.

## 3. Result

Source:

```text
scripts/f3_return_excursion_freeze_w_v1.py
```

Outputs:

```text
results/F3_RETURN_EXCURSION_FREEZE_W_v1/summary.json
results/F3_RETURN_EXCURSION_FREEZE_W_v1/candidate_w_not_frozen.csv
results/F3_RETURN_EXCURSION_FREEZE_W_v1/freeze_reverify_failures.csv
results/F3_RETURN_EXCURSION_FREEZE_W_v1/manifest_sha256.csv
```

Summary:

```text
left_perron_eigenvalue_decimal = 1.0147870480474062
left_perron_zero_real_support_count = 594
rational_bad_state_count = 594
rational_min_ratio_lhs_over_rhs = 0.0
rational_reverify_pass = false
```

Graph reducibility diagnostic:

```text
scc_count = 443
largest_scc = 135
sink_scc_count = 11
sink_scc_sizes_desc = [135, 81, 27, 27, 9, 9, 3, 3, 1, 1, 1]
```

The candidate vector is therefore not frozen.

## 4. Verdict

The local verdict is:

```text
STOP_FREEZE_W_SUPPORT_REDUCIBLE
```

Reason: the left Perron vector lives on a proper recurrent support. The
predeclared global floor `w_s >= 1/D` assigns positive mass to states outside
that support, and the rationalized inequality fails on 594 states.

This is a protocol stop before holdout, not a holdout failure.

## 5. Holdout status

The predeclared holdout range:

```text
20737 <= a < 41473
```

remains unopened and unburned.

## 6. Next accepted object

One of the following must be written before any holdout run:

```text
F3_RETURN_EXCURSION_SUPPORT_REPAIR_v1
```

or

```text
F3_RETURN_EXCURSION_FREEZE_RULE_v2
```

Required content:

```text
1. explicit handling of reducible support / multiple sink SCCs;
2. predeclared state inclusion rule;
3. revised floor rule or proof that no floor is needed;
4. re-verification of rational w before freeze;
5. no holdout consumption until the revised freeze passes.
```

## 7. Non-claims

```text
NO_FROZEN_W
NO_HOLDOUT_RESULT
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_LEAN_OPERATOR
```

