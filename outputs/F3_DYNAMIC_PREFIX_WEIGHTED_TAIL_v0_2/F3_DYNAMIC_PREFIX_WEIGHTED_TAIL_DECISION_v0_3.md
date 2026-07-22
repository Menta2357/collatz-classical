# F3 dynamic weighted-tail decision v0.3

Date: 2026-07-21.

## Decision

Claude is unavailable, so no coordinated formal verdict is recorded. Local
continuation produced the v0.3 paper page.

The dynamic prefix route remains open, but only with a sharper obstacle:

```text
OPEN_PAPER_ONLY
OBSTACLE = advanced window phase
```

## What improved

The three-lift obstruction is no longer the first blocker. It is handled
formally by allowing the advanced branch to lower 3-adic prefix depth:

```text
advanced: depth d -> depth d-1
retarded: depth d -> depth d
```

## What now blocks computation

The advanced image has:

```text
x_a / c(a) = 3 * 2^y * a / (2a - 1)
```

which is not an integer y-shift and not constant on a fixed prefix. A pilot
that ignores this would recreate the old mistake in a subtler form.

## Next required object

Before any script:

```text
F3_ADVANCED_PHASE_REPLACEMENT_v0_1
```

must choose exactly one:

```text
PHASE_A: lower replace P(c(a), x_a) by P(c(a), 2^y c(a))
PHASE_B: add finite phase bins for x_a / c(a)
PHASE_C: route all phase surplus to Q_K and prove same-denominator bound
```

The default safest option is `PHASE_A`, because it is monotone for lower
bounds. It may be too weak; that is an empirical question only after it is
predeclared.

## PHASE_A calibration outcome

The first full calibration run with `PHASE_A` produced:

```text
unique parent roots = 3455
root rows = 10365
mismatches = 0
visible_capture_fraction = 0.5955870580
q_fraction = 0.4044129420
phase_loss_fraction = 0.2534981643
advanced_tail_phase_a_fraction = 0.1505435636
```

Local verdict:

```text
STOP_PHASE_A_TAIL_TOO_LARGE
```

The holdout run was interrupted after calibration because the calibration
tail already exceeded the ideal `1 - lambda_11 / 2 ~= 10.39%` margin by a
large factor. This is not a theorem, but it is enough to reject `PHASE_A` as
the first dynamic weighted-tail architecture.

## Next phase choice

The next natural monotone replacement is:

```text
PHASE_B: replace P(c(a), x_a) by P(c(a), x_a - 2^(y-1))
```

Equivalently:

```text
x_a - 2^(y-1) = 3 * 2^(y-1) * c(a)
```

This is the E5-style advanced window. It keeps the lower-bound direction and
tests whether the remaining obstruction is the visible/tail routing, not the
phase loss itself.

## Claims

```text
NO_LEAN
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
```
