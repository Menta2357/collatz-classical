# F3 return-excursion support repair v1 contract

Date: 2026-07-22.

Status before execution:

```text
SUPPORT_REPAIR_CORE_RESTRICTION_PREDECLARED
HOLDOUT_NOT_OPENED
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. Reason for repair

`F3_RETURN_EXCURSION_FREEZE_W_v1` stopped because the global left Perron vector
of the reducible v2 matrix has zero support on 594 states. The predeclared
floor `w_s >= 1/D` therefore asked transient/subdominant states to satisfy a
supercritical inequality they cannot satisfy.

The repair is not a smarter floor. The repair is support restriction.

## 2. Core rule

Build SCCs of the v2 directed support graph and choose the unique SCC whose
restricted spectral radius is maximal.

Required checks:

```text
core_size = 135
M_core is irreducible
rho(M_core) = rho(M_global) up to numeric tolerance
```

If any check fails:

```text
STOP_SUPPORT_REPAIR_CORE_CHECK_FAILED
```

## 3. Freeze rule on the core

On the selected core:

```text
w_core = left Perron vector of M_core
D = 1000000
delta = 1/100
```

Rationalization:

```text
normalize w_core to sum 1
integer_weight_s = max(1, floor(D * w_s))
rational_weight_s = integer_weight_s / D
```

Acceptance before freeze:

```text
w_core^T M_core >= (1 + delta) w_core^T
```

after rationalization.

## 4. Discard lemma for excluded states

The future functional is defined only over the core. This restricts the
claimed lower-bound functional; it does not enlarge it.

The 594 excluded states are not assigned positive weight in this object. Their
mass is either feeder mass into recurrent classes or mass already treated as
row-wise sterile `Q` / subdominant sink behavior.

This contract does not claim that excluded states are absent from the real
tree. It claims only that the candidate weighted functional is core-supported.

## 5. Holdout status

The holdout range remains predeclared and unopened in this step:

```text
20737 <= a < 41473
```

Only if the rationalized `w_core` re-verifies may a later object publish the
frozen hash and then open holdout.

## 6. Allowed outcomes

```text
CORE_RESTRICTION_FREEZE_PASS_HOLDOUT_READY
STOP_SUPPORT_REPAIR_CORE_CHECK_FAILED
STOP_CORE_RATIONAL_REVERIFY_FAILED
```

Forbidden:

```text
HOLDOUT_PASS
RHO_CERTIFIED
DENSITY_THEOREM
ALMOST_ALL
GLOBAL_COLLATZ
LEAN_READY
```

