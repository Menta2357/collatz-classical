# F3 PHASE_B scale identities Lean minimal v1

Date: 2026-07-21.

## Purpose

This adds the first Lean module for the F3 PHASE_B scale-aware route:

```text
CollatzClassical/KL2003/F3PhaseBScaleIdentities.lean
```

The module intentionally proves only arithmetic identities:

```text
rho target 9/5 exceeds official Lean lambda_11 = 71689/40000, cross-multiplied
older decimal lambda 8961/5000 is <= official Lean lambda_11, cross-multiplied
retarded multiplicative scale identity
PHASE_B multiplicative scale identity
critical split at rho = 2, cross-multiplied
```

## Validation

Validated with direct Lean:

```text
lean CollatzClassical/KL2003/F3PhaseBScaleIdentities.lean
status = PASS
```

`lake env lean` was not used as final validation in this run because Lake began
preparing/downloading the package environment after the local mathlib cache had
filled the disk. The module has no external imports and compiles directly with
the Lean executable.

## Non-claims

```text
NO_F3_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_K11_THEOREM_CLAIM
```

## Protocol note

This module is only a Lean brick for exact arithmetic identities. The F3
operator itself must not move to Lean until its paper page has fixed:

```text
M derived from rules
w frozen before holdout
tail in the same W_K denominator
explicit y-uniformity
member-wise inequality for each matrix entry
```
