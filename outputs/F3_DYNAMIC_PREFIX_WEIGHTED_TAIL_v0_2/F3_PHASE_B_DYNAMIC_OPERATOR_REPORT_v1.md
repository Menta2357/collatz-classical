# F3 PHASE_B dynamic operator report v1

Date: 2026-07-21.

Status:

```text
RULE_DERIVED_OPERATOR_BUILT
NAIVE_OPERATOR_TOO_WEAK
SCALE_AWARE_OPERATOR_REQUIRED
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN
```

## 1. Claude obligations incorporated

Claude accepted `PRE_SPECTRAL_CANDIDATE` and imposed five obligations:

```text
O1 M derived from rules, not data.
O2 weights frozen before holdout.
O3 tail in the same member-wise inequality.
O4 y-uniformity explicit.
O5 each M entry tied to a demonstrable member-wise inequality.
```

The v1 operator addresses O1 only. O2 is not applicable because no weights
were solved. O3 is partial because tail edges are listed. O4 and O5 remain
open.

## 2. Operator built

The v1 operator is the rule-derived naive incidence matrix:

```text
K = 5
valid states = 1089
rule edges = 1452
tail edges = 3
visible advanced source states = 360
```

States are:

```text
(d, r, p, b)
d = 1..5
r mod 3^d = all residues
b in {0,1,2}
p derived from b
```

Retarded rule:

```text
(d,r,p,b) -> (d, 4r mod 3^d, even, 2)
```

Advanced rule:

```text
exists iff r == 2 mod 3
d -> d-1
r -> (2r - 1)/3 mod 3^(d-1)
d=1 routes to Q_K:DEPTH_ZERO
```

Parity and `nu2` after the advanced branch are derived by the three arithmetic
lifts, not by empirical data.

## 3. Spectral result

The naive visible operator has:

```text
spectral_radius = 1
lambda_11 = 1.7922
rho > lambda_11 = false
```

Local verdict:

```text
STOP_NAIVE_OPERATOR_TOO_WEAK_SCALE_AWARE_OPERATOR_REQUIRED
```

## 4. Interpretation

This does not stop PHASE_B. It stops only the branch-incidence operator.

The reason is structural: retarded edges preserve depth and form permutation
blocks, while advanced edges lower depth or go to tail. Therefore the naive
matrix is block triangular with spectral radius 1. It cannot encode the
observed mass growth because it ignores the scale and window effects that
made E3 and PHASE_B large.

## 5. Next object

The next object must be:

```text
F3_PHASE_B_SCALE_AWARE_OPERATOR_v1
```

It must add to each rule edge the window-scale relation:

```text
retarded: x_a / (4a) = 2^(y-2)
advanced PHASE_B: (x_a - 2^(y-1)) / c(a) = 3 * 2^(y-1)
```

and express the resulting inequality in a single denominator `W_K`.

Until that object exists:

```text
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN
```

