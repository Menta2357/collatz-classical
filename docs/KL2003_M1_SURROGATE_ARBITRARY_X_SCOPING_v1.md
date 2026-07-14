# KL2003 M1 Surrogate Arbitrary X Scoping v1

## Scope

This note scopes the next corollary from the closed technical window theorem:

```lean
kl2003_k2_m1_surrogate_ceil_window_lower_bound
m1_surrogate_member_ceil_window_lower_bound_gamma
gammaK2_gt_three_sevenths
two_rpow_gammaK2
lambdaR_rpow_eq_two_rpow_rpow_gammaK2
```

The goal is to convert the current `ceil`-window statement into a statement
for an arbitrary natural window `x`, while keeping the theorem calibrated:

```text
k=2 M1-surrogate only
not full M1
not global Collatz
```

No Lean proof is opened in this pass.

## Main Idea

For `x : Nat` and an admissible root `a`, choose

```lean
y := Real.logb 2 ((x : Real) / (a : Real))
```

If

```lean
((2 : Nat)^14) * a <= x
```

and `0 < a`, then:

```lean
14 <= y
(2 : Real)^y * (a : Real) = (x : Real)
concreteWindow y a = x
((2 : Real)^y)^gammaK2 = (((x : Real) / (a : Real))^gammaK2)
```

Thus the `ceil` excess is eliminated by parameter choice.  The argument of
`Nat.ceil` is exactly the natural number `x` cast to `Real`, so no one-unit
loss is paid.

## Target Statements

### Component Form

Recommended theorem name:

```lean
kl2003_k2_m1_surrogate_arbitrary_x_lower_bound_component
```

Proposed statement:

```lean
theorem kl2003_k2_m1_surrogate_arbitrary_x_lower_bound_component
    {m : Nat} (hm : m = 2 ∨ m = 5 ∨ m = 8)
    (a : ClassRoots m) {x : Nat}
    (hx : ((2 : Nat)^14) * a.1 <= x) :
    DeltaV2 * (((x : Real) / (a.1 : Real)) ^ gammaK2)
      <= (piStar a.1 x : Real)
```

The coefficient `c_m` has already been absorbed in the existing theorem
`DeltaV2_mul_lambdaR_rpow_le_component` by proving `1 <= c22R`, `1 <= c25R`,
and `1 <= c28R`.  Therefore this component statement does not need a visible
class coefficient.

### Public Alias

Recommended theorem name:

```lean
kl2003_k2_m1_surrogate_arbitrary_x_lower_bound
```

This can initially be an alias/wrapper around the component form, with the same
statement and the same calibrated scope.  Avoid a broader public statement
until there is a separate decision about presentation.

### Root 8 Instance

Recommended theorem name:

```lean
kl2003_k2_m1_surrogate_root8_lower_bound
```

Proposed statement:

```lean
theorem kl2003_k2_m1_surrogate_root8_lower_bound
    {x : Nat} (hx : ((2 : Nat)^17) <= x) :
    DeltaV2 * (((x : Real) / 8) ^ gammaK2)
      <= (piStar 8 x : Real)
```

Reason for the threshold:

```text
2^17 = 2^14 * 8
```

The proof should instantiate the component theorem with a named witness:

```lean
classRoot_eight : ClassRoots 8
```

The current code has an inline proof that `8 : ClassRoots 8` is nonempty in
`KL2003ConcretePhiRealization.lean`.  For this corollary, extract named helpers:

```lean
notInCycle_eight : NotInCycle 8
classRoot_eight : ClassRoots 8
```

## Required Lemmas

### Positivity From The Size Hypothesis

From `a : ClassRoots m`, we have `1 <= a.1`, hence `0 < a.1`.

If `((2 : Nat)^14) * a.1 <= x`, then:

```lean
0 < x
0 < ((x : Real) / (a.1 : Real))
```

Candidate helper:

```lean
x_pos_of_pow14_mul_root_le :
  0 < a -> ((2 : Nat)^14) * a <= x -> 0 < x
```

### Log Parameter Gives The Window

Candidate helper:

```lean
two_rpow_logb_ratio_mul_root_eq_x
    {a x : Nat} (ha : 0 < a) (hx : 0 < x) :
    (2 : Real) ^ (Real.logb 2 ((x : Real) / (a : Real))) * (a : Real)
      = (x : Real)
```

Expected ingredients:

```lean
Real.rpow_logb
div_mul_cancel₀
```

with side conditions:

```lean
0 < (2 : Real)
(2 : Real) ≠ 1
0 < ((x : Real) / (a : Real))
(a : Real) ≠ 0
```

Candidate `concreteWindow` helper:

```lean
concreteWindow_logb_eq_self
    {a x : Nat} (ha : 0 < a) (hx : 0 < x) :
    concreteWindow (Real.logb 2 ((x : Real) / (a : Real))) a = x
```

Expected final step:

```lean
Nat.ceil_natCast
```

after rewriting the ceiling argument to `(x : Real)`.

### Size Hypothesis Gives `14 <= y`

Candidate helper:

```lean
fourteen_le_logb_ratio_of_pow14_mul_root_le
    {a x : Nat} (ha : 0 < a)
    (hx : ((2 : Nat)^14) * a <= x) :
    (14 : Real) <= Real.logb 2 ((x : Real) / (a : Real))
```

Expected route:

```lean
Real.le_logb_iff_rpow_le
```

for base `2`, reducing the goal to:

```lean
(2 : Real)^14 <= (x : Real) / (a : Real)
```

which follows from the cast of:

```lean
((2 : Nat)^14) * a <= x
```

and division by the positive real `(a : Real)`.

The companion theorem found in Mathlib is:

```lean
Real.logb_le_iff_le_rpow
```

but the direction needed here is `Real.le_logb_iff_rpow_le`.

### Gamma Rewrite

The cleanest proof consumes the gamma-form theorem:

```lean
m1_surrogate_member_ceil_window_lower_bound_gamma
```

and rewrites:

```lean
(2 : Real)^y = (x : Real) / (a : Real)
```

where:

```lean
y = Real.logb 2 ((x : Real) / (a : Real))
```

using `Real.rpow_logb`.

The already proved theorem

```lean
lambdaR_rpow_eq_two_rpow_rpow_gammaK2
```

is still part of the dependency chain, but the arbitrary-`x` statement can
avoid an extra `lambdaR^y` rewrite by starting from the gamma form.

## Proof Skeleton

For the component theorem:

```lean
let y := Real.logb 2 ((x : Real) / (a.1 : Real))
have ha_pos : 0 < a.1 := by exact Nat.succ_le_iff.mp a.2.2
have hx_pos : 0 < x := x_pos_of_pow14_mul_root_le ha_pos hx
have hy14 : 14 <= y :=
  fourteen_le_logb_ratio_of_pow14_mul_root_le ha_pos hx
have hwin : concreteWindow y a.1 = x :=
  concreteWindow_logb_eq_self ha_pos hx_pos
have hmain :=
  m1_surrogate_member_ceil_window_lower_bound_gamma
    hm a (y := y) hy14
-- rewrite hwin and Real.rpow_logb in hmain
```

Expected end shape:

```lean
simpa [y, hwin, Real.rpow_logb, ...] using hmain
```

If `simpa` is too optimistic, use a short `calc`:

```lean
DeltaV2 * (((x : Real) / (a.1 : Real)) ^ gammaK2)
    = DeltaV2 * (((2 : Real)^y) ^ gammaK2) := by ...
_ <= (piStar a.1 (concreteWindow y a.1) : Real) := hmain
_ = (piStar a.1 x : Real) := by rw [hwin]
```

## Root 8 Proof Skeleton

Define:

```lean
theorem notInCycle_eight : NotInCycle 8 := ...

def classRoot_eight : ClassRoots 8 :=
  ⟨8, by norm_num, notInCycle_eight, by norm_num⟩
```

Then:

```lean
have hx_component : ((2 : Nat)^14) * classRoot_eight.1 <= x := by
  norm_num [classRoot_eight] at hx ⊢
exact
  kl2003_k2_m1_surrogate_arbitrary_x_lower_bound_component
    (m := 8) (by exact Or.inr (Or.inr rfl)) classRoot_eight hx_component
```

The exact `norm_num` line may need adjustment, but the arithmetic is just:

```text
2^14 * 8 = 2^17
```

## Paper/Source vs Lean Theorem Table

| Source/paper role | Lean object | Status |
|---|---|---|
| KL2003 k=2 surrogate exponent base | `lambdaR = 27/20` | closed |
| gamma exponent | `gammaK2 := Real.logb 2 (27/20)` | closed |
| gamma exceeds `3/7` | `gammaK2_gt_three_sevenths` | closed |
| ceil-window lower bound | `kl2003_k2_m1_surrogate_ceil_window_lower_bound` | closed |
| concrete semantic target | `piStar a.1 (concreteWindow y a.1)` | closed |
| arbitrary-`x` parameter | `y := Real.logb 2 ((x:Real)/(a:Real))` | scoped here |
| no ceil excess | `concreteWindow_logb_eq_self` | future lemma |
| large-window condition | `((2:Nat)^14) * a.1 <= x` | scoped here |
| public root example | `a = 8`, threshold `2^17 <= x` | scoped here |

## Reproduction And Audit Package

Future Lean pass should add a new module or a final section in
`KL2003M1Surrogate.lean`.  A separate module keeps the audit cleaner:

```text
CollatzClassical/KL2003/KL2003M1SurrogateArbitraryX.lean
CollatzClassical/KL2003/KL2003M1SurrogateArbitraryXAxiomAudit.lean
```

Expected checks:

```text
lake build CollatzClassical.KL2003.KL2003M1SurrogateArbitraryX
lake env lean CollatzClassical/KL2003/KL2003M1SurrogateArbitraryXAxiomAudit.lean
git diff --check
```

Audit should print at least:

```lean
#print axioms concreteWindow_logb_eq_self
#print axioms fourteen_le_logb_ratio_of_pow14_mul_root_le
#print axioms kl2003_k2_m1_surrogate_arbitrary_x_lower_bound_component
#print axioms kl2003_k2_m1_surrogate_arbitrary_x_lower_bound
#print axioms kl2003_k2_m1_surrogate_root8_lower_bound
```

Guardrail scan:

```text
no sorry
no admit
no unsafe
no native_decide
```

## Non-Claims

The arbitrary-`x` corollary remains:

```text
k=2 only
M1-surrogate only
restricted to tracked classes 2, 5, 8 and admissible roots
not full M1
not a KL2003 x^0.84 theorem
not a global Collatz theorem
```

The root-8 theorem is a citable instance of the surrogate theorem, not an
all-roots statement and not a claim about all Collatz orbits.

## Classification

```text
ARBITRARY_X_COROLLARY_SCOPED
CEIL_EXCESS_ELIMINATED_BY_LOGB_PARAMETER
ROOT8_PUBLIC_INSTANCE_TARGET_DEFINED
STATEMENT_FIDELITY_PACKAGE_REQUIRED
NO_FULL_M1_THEOREM_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
