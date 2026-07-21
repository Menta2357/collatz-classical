# F3 PHASE_B scale-aware operator report v1

Date: 2026-07-21.

Status:

```text
SCALE_AWARE_PARENT_TO_CHILD_AUDITED
PARENT_TO_CHILD_ORIENTATION_STOP
RECURRENCE_ORIENTATION_REQUIRED
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. What was tested

The rule-derived PHASE_B edges were equipped with the scale coefficients
requested by the scale-aware page:

```text
rho_star = 9/5
lambda_11 official = 71689/40000
retarded weight = rho_star^(-2) = 25/81
advanced weight = rho_star^(log_2(3)-2)
```

The script used only arithmetic rules, not pi-star data, to define edges.

## 2. Numerical diagnostics

```text
K = 5
states = 1089
edges = 1452
tail edges = 3
visible advanced source states = 360
retarded weight = 25/81 = 0.30864197530864196
advanced weight ~= 0.7835240614003165
branch sum on states with advanced ~= 1.0921660367089585
lambda_11 branch sum ~= 1.0962586919443154
```

The branch-sum diagnostic is favorable, but it is not a spectral certificate.

## 3. Orientation failure

With edges oriented as:

```text
parent state -> retarded child state
parent state -> advanced child state
```

the advanced edge strictly lowers 3-adic depth, while the retarded edge keeps
the same depth. Therefore the finite visible matrix is block triangular by
depth. The only diagonal-block coefficient is the retarded weight:

```text
spectral radius = 25/81
```

So:

```text
25/81 < 1 < lambda_11
```

and this orientation cannot certify growth.

## 4. Verdict

```text
STOP_PARENT_TO_CHILD_ORIENTATION_REFORMULATE_RECURRENCE
```

This does not stop PHASE_B. It stops the parent-to-child Perron formulation.

## 5. Next required object

The next page must be:

```text
F3_PHASE_B_SCALE_AWARE_RECURRENCE_ORIENTATION_v0_2
```

It must specify whether the lower-bound recurrence is written:

```text
child-to-parent
renewal/return operator
depth-collapsed operator with certified tail
or another explicitly member-wise equivalent orientation
```

Before any LP search for weights `w`, the page must prove that its matrix
orientation is the same orientation as the desired inequality:

```text
w^T M >= (1 + delta) w^T
```

## 6. Non-claims

```text
NO_F3_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_K11_THEOREM_CLAIM
NO_LEAN_OPERATOR
```

