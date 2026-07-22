# F3 PHASE_B scale-aware operator page v0.1

Date: 2026-07-21.

Status:

```text
PAPER_PAGE_BEFORE_OPERATOR_LEAN
PRE_SPECTRAL_CANDIDATE
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR_YET
```

## 1. Protocol

The minimal Lean module `F3PhaseBScaleIdentities.lean` is accepted only as an
arithmetic brick. The operator itself does not move to Lean until this page,
or a successor, satisfies the five obligations:

```text
O1 M derived from rules, not data
O2 weights frozen before holdout
O3 tail in the same member-wise inequality
O4 y-uniformity explicit
O5 each M entry tied to a demonstrable member-wise inequality
```

## 2. Constants

The first target is fixed as:

```text
rho_star = 9/5 = 1.8
```

The official Lean k=11 comparison constant is:

```text
lambda_11 = 71689/40000 = 1.792225
```

The older decimal approximation is retained only as subordinate:

```text
8961/5000 <= 71689/40000 < 9/5
```

No operator may cite `8961/5000` as the controlling threshold.

## 3. Scale identity

For a parent root `a`, window `x_a = 2^y a`, and advanced child
`c = (2a - 1)/3`, equivalently `3c + 1 = 2a`:

```text
retarded root 4a sees scale 2^(y-2)
advanced PHASE_B root c sees scale 3 * 2^(y-1)
```

At a hypothetical growth rate `rho`, the scale-aware branch weights are:

```text
retarded = rho^(-2)
advanced = rho^(alpha - 2)
```

where `alpha = log_2 3`.

At `rho = 2`:

```text
2^(-2) + 2^(alpha-2) = 1/4 + 3/4 = 1
```

This explains why the naive incidence operator had spectral radius 1: it
measured connectivity, not scale.

## 4. Rule-derived operator sketch

The state space remains:

```text
K = 5
state = (d, r, p, b)
d = 1..5
r mod 3^d, all residues
b in {0,1,2}
p derived from b
```

The rule edges are:

```text
retarded: (d,r,p,b) -> (d, 4r mod 3^d, even, 2)
advanced: if r == 2 mod 3, depth d -> d-1; if d=1, route to Q_K
```

The scale-aware matrix at `rho_star` must attach:

```text
retarded weight = (9/5)^(-2) = 25/81
advanced weight = (9/5)^(alpha-2), bounded by certified rational intervals
```

The advanced coefficient is not to be guessed from data. It must be bounded
from the identity `2^alpha = 3`, using rational intervals on `alpha` or an
equivalent certified power comparison.

## 5. Holdout contract

Calibration may search rational weights `w > 0` for:

```text
w^T M_rho_star >= (1 + delta) w^T
```

but must freeze:

```text
K
rho_star
alpha interval
M construction rules
w
delta
epsilon/error denominator
y-range or y-uniform proof obligation
```

Holdout may only check the frozen inequality member-wise with the measured
tail and phase losses charged to the same `W_K` denominator.

## 6. Stop conditions

```text
STOP_NO_RATIONAL_W_AT_9_OVER_5
STOP_ERROR_NOT_ABSORBABLE_IN_WK
STOP_Y_UNIFORMITY_NOT_FORMULATED
STOP_MEMBERWISE_ENTRY_MISSING
SCALE_AWARE_OPERATOR_CANDIDATE_ONLY
```

If `rho_star = 9/5` fails, any bisection must be predeclared before the next
holdout range is opened.

## 7. Non-claims

```text
NO_F3_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_K11_THEOREM_CLAIM
```
