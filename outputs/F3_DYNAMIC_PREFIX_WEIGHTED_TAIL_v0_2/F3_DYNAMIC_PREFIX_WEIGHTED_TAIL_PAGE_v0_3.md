# F3 dynamic prefix weighted-tail page v0.3

Date: 2026-07-21.

Status:

```text
LOCAL_PAPER_GATE
CLAUDE_UNAVAILABLE
NO_FORMAL_COORDINATED_VERDICT
NO_COMPUTATIONAL_SWEEP_AUTHORIZED_BY_THIS_PAGE
NO_LEAN
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
```

## 1. Problem being isolated

The fixed modulus route failed because the advanced image

```text
c(a) = (2a - 1) / 3
```

does not close inside a fixed residue class modulo `2^ell 3^k`. A dynamic
3-adic prefix avoids that specific obstruction: division by 3 should lower
prefix depth by one instead of pretending the image stays in the same modulus.

This does not yet prove a sum inequality. It only gives the first finite
state candidate that is not killed immediately by the three-lift obstruction.

## 2. Candidate visible family F_K

Fix an integer `K >= 2`. For the first concrete pilot, use:

```text
K = 5
visible depths d = 1,2,3,4,5
visible residues r mod 3^d, all residues allowed
parity bit p in {odd, even}
retarded-depth bit b in {0,1,2}
```

A visible type is:

```text
u = (d, r, p, b)
```

with membership condition:

```text
a == r mod 3^d
a parity == p
nu_2(a) clipped to b, where b=2 means nu_2(a) >= 2
```

Residues `r == 2 mod 3` are exactly the states with an integral advanced
branch. They are not the only visible states. Advanced images landing in
residues `0` or `1 mod 3` remain visible; they simply do not spawn an advanced
branch on the next transition.

The visible functional is:

```text
V_u(y; A) = sum pi*(a, 2^y a)
```

over parent roots `a` in the chosen finite interval satisfying type `u`.

## 3. Tail Q_K

The tail is not "bad mass". It is the union of roots whose exact route is
known but whose current prefix information is intentionally not carried as a
visible coordinate.

For the first pilot:

```text
Q_K(y) = mass from roots routed to any of:
  T0: a not == 2 mod 3
  T1: advanced image has depth 0 after one or more prefix drops
  T2: window phase is outside the visible phase ledger
  T3: finite atoms or explicitly delayed rows
```

Every tail row must retain:

```text
source parent root
source type
branch = retarded | advanced | atom | loss
reason = T0 | T1 | T2 | T3
mass denominator W_K row id
```

## 4. Dynamic route maps

Let `u=(d,r,p,b)`.

### Retarded branch

The retarded image is:

```text
a -> 4a
```

Modulo `3^d`, this maps:

```text
r -> 4r mod 3^d
```

Parity becomes even and the clipped 2-adic bit becomes `2`. Thus:

```text
R(d,r,p,b) = (d, 4r mod 3^d, even, 2)
```

provided `4r == 2 mod 3`. If not, the row is routed to `Q_K:T0`.

For residues `r == 2 mod 3`, `4r == 2 mod 3`, so the retarded branch remains
visible at the same 3-adic depth.

### Advanced branch

For `r == 2 mod 3`, define:

```text
c_r = (2r - 1) / 3 mod 3^(d-1)
```

The advanced branch maps:

```text
A(d,r,p,b) = (d-1, c_r, parity(c(a)), clipped_nu_2(c(a)))
```

when `d > 1` and `c_r == 2 mod 3`. If `d = 1`, or if the image residue is not
`2 mod 3`, the row is routed to `Q_K:T1` or `Q_K:T0`.

This is the point of the dynamic prefix: advanced transitions lose one 3-adic
digit instead of fragmenting a fixed modulus into three lifts.

## 5. Window phase ledger

The branch identity gives, member-wise:

```text
P(a, x_a) = {a, 2a} disjoint_union P(4a, x_a) disjoint_union P(c(a), x_a)
```

with `x_a = 2^y a`.

For the retarded branch:

```text
x_a / (4a) = 2^(y-2)
```

so the retarded image has an integer y-shift.

For the advanced branch:

```text
x_a / c(a) = 2^y a / ((2a - 1)/3)
           = 3 * 2^y * a / (2a - 1)
```

This is not exactly `2^y c(a)` or a fixed integer y-shift. Therefore the
first dynamic pilot must carry a window phase coordinate or route the mismatch
to `Q_K:T2`.

Minimal phase ledger for v1:

```text
phase retarded: exact integer shift y -> y-2
phase advanced: interval phase I_adv(y,a) = [2^y c(a), x_a]
visible only if a predeclared interval-rational lower replacement is used
otherwise route phase surplus/deficit to Q_K:T2
```

This page does not yet choose the replacement. That is the remaining paper
obligation before computation.

## 6. Potential denominator W_K

The common denominator is:

```text
W_K(y) = sum_u w_u V_u(y) + tau Q_K(y)
```

For the first pilot, weights are not fit from holdout. They must be selected
by one of the following predeclared mechanisms:

```text
option A: all visible weights w_u = 1 and tau = 1
option B: calibration-only rational LP, frozen before holdout
option C: symbolic interval weights, accepted only if every interval endpoint passes
```

The preferred first attempt is `option A`. If it fails badly, that is useful:
it tells us whether the obstruction is structural or merely weighting.

## 7. Hook schema

Every row in the next script must emit:

```text
root_a
y
x_a
source_type
source_pi_star
atom_count
retarded_root
retarded_x
retarded_route
retarded_type_or_tail
retarded_pi_star
advanced_root
advanced_x
advanced_route
advanced_type_or_tail
advanced_pi_star
advanced_window_phase
error_bucket
W_denominator_row
partition_pass
route_pass
denominator_pass
```

The hook verdicts are:

```text
H1 partition_pass: E5 member-wise identity holds
H2 route_pass: every branch is visible, tail, atom, or loss
H3 denominator_pass: every non-visible row is charged to W_K
H4 holdout_pass: parent roots disjoint globally
H5 freeze_pass: K, weights, phase rule, y-range fixed before holdout
H6 no_claim_pass: no theorem-language emitted
```

The finite base exception is:

```text
a = 2
```

because `c(2)=1` lies in the `1 <-> 2` cycle and breaks the pairwise
disjointness hook. This exception must be excluded before calibration, not
after looking at holdout.

## 8. Acceptance and stop vocabulary

Allowed empirical verdicts:

```text
PASS_HOOKS_ONLY
PASS_EMPIRICAL_WEIGHTED_TAIL
STOP_WINDOW_PHASE_NOT_CLOSED
STOP_TAIL_TOO_LARGE
STOP_BAD_PARTITION
STOP_BAD_DENOMINATOR
REDESIGN_REQUIRED
```

Forbidden verdicts:

```text
PROVED_DENSITY
PROVED_ALMOST_ALL
PROVED_COLLATZ
LEAN_READY
RHO_CERTIFIED
```

## 9. Current mathematical verdict

This page advances F3 from an unnamed surviving route to a named finite
candidate:

```text
F_K = dynamic 3-adic prefix states with K=5 pilot depth
Q_K = explicit visible-complement and phase tail
route = retarded same-depth, advanced depth-minus-one
W_K = visible weighted sum plus tau tail
```

But it also identifies a new hard obstruction:

```text
advanced window phase is affine in a and not an integer y-shift
```

Therefore the next paper step is not a numeric sweep. It is to choose one
predeclared advanced phase replacement or prove that the phase tail is small
in the same W_K denominator.
