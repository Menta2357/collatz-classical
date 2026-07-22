# F3 return-excursion freeze-w and holdout contract v1

Date: 2026-07-22.

Status before running freeze:

```text
FREEZE_W_CONTRACT_PREDECLARED
HOLDOUT_RANGE_PREDECLARED_BUT_NOT_OPENED
NO_HOLDOUT_CONSUMPTION_BEFORE_FREEZE_PASS
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. Fixed operator and parameters

```text
operator = F3_PHASE_B_RETURN_EXCURSION_OPERATOR_v2
d0 = 5
rho_star = 9/5
lambda_11_official = 71689/40000
y_values = [8, 9, 10]
delta = 1/100
rational_denominator_D = 1000000
```

The operator and hooks are already custodied:

```text
v2 commit = 7c75107
hooks commit = 9cbd622
```

## 2. Rule for `w`

The weight vector rule is:

```text
w = left Perron eigenvector of the rule-derived v2 matrix
```

where edges are interpreted as:

```text
M[source, target] += edge_weight
```

and the certificate inequality is:

```text
w^T M >= (1 + delta) w^T
```

If some entries are numerically zero, the predeclared floor is:

```text
w_s >= 1/D
```

## 3. Rationalization

Rationalization rule:

```text
1. normalize real Perron vector to sum 1;
2. replace every entry by max(1, floor(D * w_s)) / D;
3. re-verify w^T M >= (1 + delta) w^T before freezing.
```

If the re-verification fails, the vector is not frozen and holdout remains
unopened.

## 4. Holdout range, only if freeze passes

The previously inspected PHASE_B holdout range is burned:

```text
10369 <= a < 20737
```

The next holdout range is predeclared but must not be opened unless freeze
passes:

```text
20737 <= a < 41473
```

Failure semantics:

```text
any hook mismatch = FAIL
aggregate weighted inequality < 1 + delta = FAIL
one FAIL burns the range and requires a new range plus a cause report
```

## 5. Allowed outcomes of this step

```text
FREEZE_W_PASS_READY_FOR_HOLDOUT
STOP_FREEZE_W_REVERIFY_FAILED
STOP_FREEZE_W_SUPPORT_REDUCIBLE
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

