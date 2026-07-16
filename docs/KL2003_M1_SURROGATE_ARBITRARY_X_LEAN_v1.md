# KL2003 M1 Surrogate Arbitrary X Lean v1

## Scope

This pass implements the arbitrary-`x` corollary from the closed technical
ceil-window theorem in:

```text
CollatzClassical/KL2003/KL2003M1Surrogate.lean
```

The result remains calibrated:

```text
k=2 M1-surrogate
tracked classes 2, 5, 8
large-window threshold
not full M1
not high-k (`k=9` / `gamma_9 = 0.8168300`, nor `k=11` / `0.84`)
not global Collatz
```

## New Helpers

The pass adds the log-parameter bridge:

```lean
x_pos_of_pow14_mul_root_le
two_rpow_logb_ratio_mul_root_eq_x
concreteWindow_logb_eq_self
fourteen_le_logb_ratio_of_pow14_mul_root_le
```

The parameter choice is:

```lean
y := Real.logb 2 ((x : Real) / (a : Real))
```

Under `((2 : Nat)^14) * a <= x` and `0 < a`, this gives:

```lean
14 <= y
(2 : Real)^y * (a : Real) = (x : Real)
concreteWindow y a = x
```

So the old `ceil` excess is not paid: the ceiling argument is exactly the cast
of the natural number `x`.

The pass also names the root-8 witness:

```lean
notInCycle_eight
classRoot_eight : ClassRoots 8
```

## New Theorems

The component arbitrary-`x` theorem is:

```lean
kl2003_k2_m1_surrogate_arbitrary_x_lower_bound_component
```

with statement:

```lean
theorem kl2003_k2_m1_surrogate_arbitrary_x_lower_bound_component
    {m : Nat} (hm : m = 2 ∨ m = 5 ∨ m = 8)
    (a : ClassRoots m) {x : Nat}
    (hx : ((2 : Nat)^14) * a.1 <= x) :
    DeltaV2 * (((x : Real) / (a.1 : Real)) ^ gammaK2)
      <= (piStar a.1 x : Real)
```

The public alias is:

```lean
kl2003_k2_m1_surrogate_arbitrary_x_lower_bound
```

The root-8 citable instance is:

```lean
kl2003_k2_m1_surrogate_root8_lower_bound
```

with statement:

```lean
theorem kl2003_k2_m1_surrogate_root8_lower_bound
    {x : Nat} (hx : ((2 : Nat)^17) <= x) :
    DeltaV2 * (((x : Real) / 8) ^ gammaK2)
      <= (piStar 8 x : Real)
```

The threshold is exactly:

```text
2^17 = 2^14 * 8
```

## Dependency Chain

The arbitrary-`x` theorem consumes:

```text
m1_surrogate_member_ceil_window_lower_bound_gamma
Real.rpow_logb
Real.le_logb_iff_rpow_le
Nat.ceil_natCast
```

It does not reopen the concrete seam, M0C induction, or row28 V3 machinery.

## Updated Non-Claims

The earlier final review correctly warned that arbitrary-window corollaries
were not yet proved.  This pass proves the large-window arbitrary-`x` corollary
for the calibrated `k=2` surrogate.  The remaining non-claims are:

```text
NO_FULL_M1_THEOREM_CLAIM
NO_HIGH_K_K9_OR_K11_084_CLAIM
NO_SMALL_X_BELOW_THRESHOLD_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```

The theorem is not a high-k KL2003 result: it proves neither the k=9
`gamma_9 = 0.8168300` line nor the k=11 / `0.84` line, and it does not make a
global Collatz claim.

## Verification

Required commands:

```text
lake build CollatzClassical.KL2003.KL2003M1Surrogate
lake env lean CollatzClassical/KL2003/KL2003M1SurrogateAxiomAudit.lean
git diff --check
```

Guardrail scan:

```text
no sorry
no admit
no unsafe
no native_decide
```

## Classification

```text
KL2003_K2_M1_SURROGATE_ARBITRARY_X_PROVED
ROOT8_PUBLIC_INSTANCE_PROVED
CEIL_EXCESS_ELIMINATED_BY_LOGB_PARAMETER
NO_FULL_M1_THEOREM_CLAIM
NO_HIGH_K_K9_OR_K11_084_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
