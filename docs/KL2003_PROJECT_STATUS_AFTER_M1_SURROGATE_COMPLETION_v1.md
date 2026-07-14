# KL2003 Project Status After M1-Surrogate Completion v1

## Status

The KL2003 lane reached its calibrated technical target at:

```text
HEAD_FINAL = 71add7c
```

The completed theorem is:

```lean
kl2003_k2_m1_surrogate_ceil_window_lower_bound
```

It lives in:

```text
CollatzClassical/KL2003/KL2003M1Surrogate.lean
```

The final review package is:

```text
docs/KL2003_M1_SURROGATE_FINAL_REVIEW_AND_PACKAGE_v1.md
```

Post-completion update:

```text
docs/KL2003_M1_SURROGATE_ARBITRARY_X_LEAN_v1.md
```

adds the large-window arbitrary-`x` corollary and the public root-8 instance.

## Exact Scope

The theorem is a KL2003 `k=2` M1-surrogate window theorem over the concrete
ceil window:

```lean
concreteWindow y a = Nat.ceil ((2 : Real)^y * (a : Real))
```

The domain is restricted to the tracked residue classes `2`, `5`, `8` and to
admissible roots:

```lean
ClassRoots m = {a : Nat // a % 9 = m ∧ NotInCycle a ∧ 1 <= a}
```

The exponent package includes:

```lean
gammaK2 := Real.logb 2 (27 / 20)
gammaK2_gt_three_sevenths
```

The gamma lower bound is confirmed by the integer witness:

```text
27^7 > 8 * 20^7
```

## Dependency Chain

The final theorem consumes:

```text
concretePhi_retarded_lower_bound
-> m0c_retarded_induction_bound_v3
-> concretePhi_k2_retarded_inputs_v3
-> concretePhi_rowsV3
-> row28 V3 concrete seam with the source-faithful phi25 arm
-> k=2 certificate data/verifier, alpha bounds, and endpoint lemmas
```

The row28 V3 meta-errata is incorporated: the V3 `M1` second arm is `phi25`,
not the historical V2 `phi22` abstraction.

## Registration And Audit Status

KrasikovLagarias2003 is registered as `formalising` in CC Challenge:

```text
FORMALISATION_ID = 10
REPOSITORY = https://github.com/Menta2357/collatz-classical
AI_ASSISTED = true
```

The final review package records:

```text
lake build CollatzClassical.KL2003.KL2003M1Surrogate
lake env lean CollatzClassical/KL2003/KL2003M1SurrogateAxiomAudit.lean
```

with `PASS` results and the expected Lean foundations:

```text
[propext, Classical.choice, Quot.sound]
```

## Non-Claims

This status update does not claim:

```text
NO_FULL_M1_THEOREM_CLAIM
NO_K9_OR_084_CLAIM
NO_SMALL_X_BELOW_THRESHOLD_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```

The arbitrary-`x` corollary is now proved only in the calibrated large-window
form:

```text
((2 : Nat)^14) * a <= x
```

and the citable root-8 form uses:

```text
(2 : Nat)^17 <= x
```

This is still not the full M1 theorem, not the KL2003 `k=9`/`0.84` theorem,
and not a global Collatz claim.

## Classification

```text
KL2003_K2_M1_SURROGATE_WINDOW_THEOREM_COMPLETE
KL2003_K2_M1_SURROGATE_ARBITRARY_X_PROVED
ROOT8_PUBLIC_INSTANCE_PROVED
FINAL_REVIEW_PACKAGE_PUBLISHED
CC_CHALLENGE_REGISTERED_FORMALISING
READY_FOR_INTERNAL_AUDIT_PACKAGE
NO_FULL_M1_THEOREM_CLAIM
NO_K9_OR_084_CLAIM
NO_SMALL_X_BELOW_THRESHOLD_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
