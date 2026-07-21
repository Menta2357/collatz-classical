# F3 return-excursion core holdout v1 contract

Date: 2026-07-22.

Status before execution:

```text
CORE_HOLDOUT_PREDECLARED
FROZEN_W_CORE_REQUIRED
ONE_USE_HOLDOUT_RANGE
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. Frozen inputs

```text
d0 = 5
rho_star = 9/5
delta = 1/100
y_values = [8, 9, 10]
frozen_w_core_sha256 = ad4c4627f575f60911f3b943c92cd3937686f9924592dbf33f6e988d7a9dbb53
holdout_range = [20737, 41473)
```

The holdout script must verify the frozen vector hash before doing any
holdout computation.

## 2. Ratio definition

The reported weighted ratio is explicitly:

```text
ratio = lhs_total / rhs_total
lhs_total = sum_i holdout_core_count_i * (w_core^T M_core)_i
rhs_total = sum_i holdout_core_count_i * (1 + delta) * w_core_i
```

Thus `ratio >= 1` is PASS for the weighted inequality. This is the same
normalization used by the core freeze re-verification, where
`core_min_ratio_lhs_over_rhs = 1.001669...` means margin above the
`1 + delta` threshold.

## 3. Hook scope

The weighted functional is core-supported. Rows whose source state is outside
the frozen 135-state core are counted as excluded from the functional, not as
weighted failures.

Every holdout parent root still undergoes the PHASE_B partition hook:

```text
target = {a, 2a} disjoint-union retarded(4a) advanced(c)
advanced_phase_B <= advanced_full
visible_total + Q = target_count
```

Every core-supported row additionally undergoes channel hooks:

```text
retarded target in core;
advanced direct target in core;
parity lift target in core;
sterile c == 0 mod 3 charged to Q.
```

## 4. Failure semantics

```text
any PHASE_B partition mismatch = FAIL
any core channel mismatch = FAIL
weighted ratio < 1 = FAIL
```

Any FAIL burns the range `[20737, 41473)` and requires a cause report before
any new range is proposed.

Allowed outcomes:

```text
CANDIDATE_CERTIFICATE_EMPIRICAL
HOLDOUT_FAIL_HOOK_MISMATCH
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

