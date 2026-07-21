# F3 return-excursion core holdout v1 report

Date: 2026-07-22.

Status:

```text
HOLDOUT_FAIL_HOOK_MISMATCH
HOLDOUT_RANGE_BURNED
WEIGHTED_INEQUALITY_PASS_BUT_NOT_ACCEPTED
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. Frozen inputs

The holdout used the predeclared frozen core vector:

```text
results/F3_RETURN_EXCURSION_SUPPORT_REPAIR_v1/frozen_w_core.csv
sha256 = ad4c4627f575f60911f3b943c92cd3937686f9924592dbf33f6e988d7a9dbb53
```

Fixed parameters:

```text
d0 = 5
rho_star = 9/5
delta = 1/100
y_values = [8, 9, 10]
holdout_range = [20737, 41473)
```

The range is now consumed.

## 2. Ratio definition

The reported weighted ratio is:

```text
ratio = lhs_total / rhs_total
lhs_total = sum_i holdout_core_count_i * (w_core^T M_core)_i
rhs_total = sum_i holdout_core_count_i * (1 + delta) * w_core_i
```

Thus `ratio >= 1` is the weighted-inequality PASS condition.

## 3. Holdout result

Source:

```text
scripts/f3_return_excursion_core_holdout_v1.py
```

Outputs:

```text
results/F3_RETURN_EXCURSION_CORE_HOLDOUT_v1/summary.json
results/F3_RETURN_EXCURSION_CORE_HOLDOUT_v1/core_holdout_rows.csv
results/F3_RETURN_EXCURSION_CORE_HOLDOUT_v1/partition_mismatches.csv
results/F3_RETURN_EXCURSION_CORE_HOLDOUT_v1/core_mismatches.csv
results/F3_RETURN_EXCURSION_CORE_HOLDOUT_v1/weighted_state_summary.csv
results/F3_RETURN_EXCURSION_CORE_HOLDOUT_v1/manifest_sha256.csv
```

Summary:

```text
unique_parent_roots = 6912
root_rows = 20736
core_source_rows = 10368
excluded_source_rows = 10368
core_state_support_touched = 135

partition_mismatch_count = 0
core_mismatch_count = 4644

weighted_ratio_lhs_over_rhs = 1.0047285335805172
lhs_total = 92.19388298720824
rhs_total = 91.75999278
weighted_pass_ratio_ge_1 = true
```

PHASE_B partition hooks passed:

```text
target = {a, 2a} disjoint-union retarded(4a) advanced(c)
advanced_phase_B <= advanced_full
visible_total + Q = target_count
```

but the core channel hooks failed.

## 4. Cause

The failures are all core channel mismatches:

```text
advanced_direct_c2 = 2322 failing rows
advanced_parity_lift_c1 = 2322 failing rows
advanced_sterile_tail_c0 = 0 failing rows
```

Every failing row has the same shape:

```text
source_in_core = yes
partition hooks = pass
core_channel_pass = no
q_exact_pass = yes
```

The cause is that `d0 = 5` core state is not a member-wise determinant of the
advanced/lift target across the holdout population. The v2 matrix used a
representative transition for each finite state; holdout roots with the same
`d0` state can have deeper 3-adic digits that send the advanced or lifted child
to a target outside the frozen core edge.

Thus the weighted inequality passes for the frozen core counts, but the
member-wise channel contract fails. The weighted pass is not accepted.

## 5. Verdict

The local verdict is:

```text
HOLDOUT_FAIL_HOOK_MISMATCH
```

The holdout range:

```text
20737 <= a < 41473
```

is burned and must not be reused.

## 6. Next accepted object

The next object must address the missing determinant digit before any new
holdout:

```text
F3_RETURN_EXCURSION_DEPTH_REFINEMENT_v1
```

Required content:

```text
1. refine the state so advanced/lift targets are member-wise determined;
2. rebuild SCC/core/frozen w under the refined state rule;
3. re-run calibration hooks before proposing a new holdout range;
4. predeclare the next holdout range only after freeze re-verifies;
5. never reuse [20737, 41473).
```

## 7. Non-claims

```text
NO_CANDIDATE_CERTIFICATE_EMPIRICAL
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_LEAN_OPERATOR
```

