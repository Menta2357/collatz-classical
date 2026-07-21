# F3 PHASE_B scale identities Lean minimal v1

Date: 2026-07-21.

## Purpose

This adds the first Lean module for the F3 PHASE_B scale-aware route:

```text
CollatzClassical/KL2003/F3PhaseBScaleIdentities.lean
```

The module intentionally proves only arithmetic identities:

```text
rho target 9/5 exceeds lambda_11 = 8961/5000, cross-multiplied
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

