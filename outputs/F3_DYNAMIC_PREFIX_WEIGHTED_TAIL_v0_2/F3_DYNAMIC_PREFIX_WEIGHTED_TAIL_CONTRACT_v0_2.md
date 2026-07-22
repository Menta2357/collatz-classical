# F3 dynamic 3-adic prefix + weighted tail contract v0.2

Date: 2026-07-21.

Status:

```text
PAPER_GATE_OPEN
NO_COMPUTATIONAL_SWEEP_AUTHORIZED
NO_LEAN
NO_RHO_CERTIFICATE
```

## 1. Purpose

The fixed-modulus route failed because the advanced branch fragments into
three affine lifts. The uniform per-lift lower balance route failed its utility
floor on a clean holdout. The remaining possible object is a dynamic prefix
system that can tolerate thin components by carrying them in a certified tail
instead of demanding a uniform lower bound type by type.

## 2. State vector

A candidate state must define a finite visible prefix set `F_K` and a tail
state `Q_K`.

Each visible type `u in F_K` must specify, before measurement:

```text
3-adic prefix condition on the parent root
2-adic/parity condition needed by the retarded branch
window rule x_a = 2^y a or an explicitly shifted equivalent
membership hook for every counted row
```

The state vector is:

\[
V_K(y)=(V_u(y))_{u\in F_K},\qquad Q_K(y).
\]

The weighted potential is:

\[
W_K(y)=\sum_{u\in F_K} w_u V_u(y)+\tau Q_K(y),
\qquad w_u>0,\quad \tau>0.
\]

All weights must be rational in the final certificate.

## 3. Allowed transitions

For every visible type `u`, the two audited branches must be expanded as:

```text
retarded: a -> 4a
advanced: a -> (2a - 1) / 3, when integral
```

Each image must be routed into exactly one of:

```text
visible type v in F_K
tail Q_K
explicit atom/loss ledger
```

No image may be silently replaced by a full residue-class sum. Every row must
retain the member-wise hook inherited from E5.

## 4. Required inequality form

The desired paper object is a vector inequality:

\[
V_K(y+1)\ge M_K V_K(y)-E_K(y),
\]

together with a tail recurrence:

\[
Q_K(y+1)\le A_K Q_K(y)+B_K V_K(y)+L_K(y).
\]

The signs may be reorganized if the final ledger proves an equivalent
one-step lower bound for `W_K`; the non-negotiable condition is that all
discarded, delayed, or collapsed mass appears in the same denominator as the
spectral certificate.

## 5. Error ledger

The ledger must separate:

```text
deterministic omitted atoms
advanced window loss
tail routing loss
thin visible recovery
finite base exceptions
```

The following operation is forbidden:

```text
declare total error = 0.1% + 5%
```

Those were empirical labels from incompatible denominators. The next page must
define a single denominator, normally `W_K` or its forward image, and express
every error against it.

## 6. Spectral acceptance condition

There must exist rational weights and rational constants satisfying:

\[
w^T M_K \ge \frac{\rho}{1-\varepsilon} w^T,
\qquad
w^T E_K(y)+\tau L_K(y)\le \varepsilon\, w^T M_KV_K(y),
\]

with:

```text
rho > lambda_11 = 1.7922
0 <= epsilon < 1
uniform from an explicit finite base y >= y0
all constants rational or interval-rational
```

If the normalized ideal rate is 2, the informal target remains:

```text
epsilon < 1 - lambda_11 / 2 ~= 10.39%
```

This number is only a design threshold, not evidence.

## 7. Hooks required before computation

Before any new pilot is run, the following hooks must be written and reviewed:

```text
H1 member-wise partition hook for every parent root
H2 route hook: visible/visible, visible/tail, atom, or loss
H3 denominator hook: every error row points to the same W_K ledger
H4 holdout unit hook: parent roots disjoint globally, not per modulus
H5 freeze hook: weights, K, y-range, and thresholds frozen before holdout
H6 no-claim hook: no density, no almost-all, no Collatz theorem
```

## 8. Stop conditions

The dynamic route stops if any of the following occurs:

```text
no finite K gives a closed visible+tail ledger
tail recurrence grows too fast to absorb with rho > lambda_11
weights require a posteriori type deletion
holdout denominator changes after calibration
member-wise hooks fail
```

## 9. Next authorized action

The next authorized action is paper-only:

```text
write F3 dynamic prefix weighted-tail page v0.3
define F_K, Q_K, route map, W_K denominator, and hook schema
obtain Claude formal verdict on this contract
```

Only after that may a new script be written.

