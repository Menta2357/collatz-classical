# KL2003 M1 Surrogate Final Review and Package v1

## Scope

This note reviews the technical theorem closed in commit `896ace7`:

```lean
kl2003_k2_m1_surrogate_ceil_window_lower_bound :
  M1SurrogateK2CeilWindowStatement
```

At the time of this original review, the theorem was a KL2003 `k=2`
M1-surrogate window theorem.  It was not a full M1 theorem, not yet an
arbitrary-`x` theorem, and not a global Collatz claim.

## Literal Statement Review

The theorem name includes both `k2` and `surrogate`.

The packaged statement is:

```lean
def M1SurrogateK2CeilWindowStatement : Prop :=
  0 < DeltaV2 ∧
    (3 / 7 : Real) < gammaK2 ∧
      forall {m : Nat}, m = 2 ∨ m = 5 ∨ m = 8 ->
        forall (a : ClassRoots m) {y : Real}, 14 <= y ->
          DeltaV2 * (((2 : Real) ^ y) ^ gammaK2) <=
            (piStar a.1 (concreteWindow y a.1) : Real)
```

The domain/admissibility is explicit:

```lean
ClassRoots m = {a : Nat // a % 9 = m ∧ NotInCycle a ∧ 1 <= a}
m in {2,5,8}
14 <= y
```

The window is the current concrete window:

```lean
concreteWindow y a = Nat.ceil ((2 : Real)^y * (a : Real))
```

## Gamma Review

The exponent is:

```lean
gammaK2 : Real := Real.logb 2 lambdaR
lambdaR = 27/20
```

The theorem:

```lean
gammaK2_gt_three_sevenths :
  (3 / 7 : Real) < gammaK2
```

is proved from the norm-num-ready integer witness already in certificate data:

```lean
k2_gamma_gt_three_sevenths_int :
  8 * 20 ^ 7 < 27 ^ 7
```

In the current Lean proof this appears as the equivalent normalized real-power
fact:

```lean
(2 : Real)^3 < lambdaR^7
```

with `norm_num [lambdaR]`, then `Real.lt_logb_iff_rpow_lt`.

The real-power bridge is also explicit:

```lean
two_rpow_gammaK2 :
  (2 : Real) ^ gammaK2 = lambdaR

lambdaR_rpow_eq_two_rpow_rpow_gammaK2 :
  lambdaR ^ y = ((2 : Real) ^ y) ^ gammaK2
```

## Dependency Review

The member-wise lower bound consumes:

```lean
concretePhi_retarded_lower_bound :
  RetardedLowerBoundConclusion concretePhi
```

via:

```lean
DeltaV2_mul_lambdaR_rpow_le_component
m1_surrogate_member_ceil_window_lower_bound
m1_surrogate_member_ceil_window_lower_bound_gamma
```

The concrete dependency chain is:

```text
kl2003_k2_m1_surrogate_ceil_window_lower_bound
-> m1_surrogate_member_ceil_window_lower_bound_gamma
-> m1_surrogate_member_ceil_window_lower_bound
-> DeltaV2_mul_lambdaR_rpow_le_component
-> concretePhi_retarded_lower_bound
-> m0c_retarded_induction_bound_v3
-> concretePhi_k2_retarded_inputs_v3
-> concretePhi_rowsV3
-> concretePhi_row28_seam_v3
-> row28_pointwise_seam_v3_mod8
-> row28_outer_block_v3_le_child_mod8
-> row28 c' split / V3 phi25 arm
```

The abstract side also consumes:

```text
K2 certificate data and verifier
alpha/log endpoint lemmas
B/D endpoint interval proofs
M0C V3 row arithmetic and retarded induction
```

The V3/meta-errata dependency is source-faithful:

```text
M1V3 second arm = phi25, not phi22
```

The row28 repeated-class-8 case is closed by the `c'` split and sibling-fiber
construction, not by the historical L1-L7 literal table.

## Audit

Commands run:

```text
lake build CollatzClassical.KL2003.KL2003M1Surrogate
lake env lean CollatzClassical/KL2003/KL2003M1SurrogateAxiomAudit.lean
```

Build result:

```text
PASS
```

Axiom audit:

```text
gammaK2_eq_logb:
  [propext, Classical.choice, Quot.sound]
gammaK2_gt_three_sevenths:
  [propext, Classical.choice, Quot.sound]
two_rpow_gammaK2:
  [propext, Classical.choice, Quot.sound]
lambdaR_rpow_eq_two_rpow_rpow_gammaK2:
  [propext, Classical.choice, Quot.sound]
DeltaV2_mul_lambdaR_rpow_le_component:
  [propext, Classical.choice, Quot.sound]
m1_surrogate_member_ceil_window_lower_bound:
  [propext, Classical.choice, Quot.sound]
m1_surrogate_member_ceil_window_lower_bound_gamma:
  [propext, Classical.choice, Quot.sound]
kl2003_k2_m1_surrogate_ceil_window_lower_bound:
  [propext, Classical.choice, Quot.sound]
```

Guardrail scan over the M1-surrogate Lean files found none of the prohibited
tokens.

## Ceil Window Note

The theorem is over the image of the current `ceil` window.  A later theorem
for arbitrary `x`, or a theorem over `floor ((2^y)*a)`, must add a separate
window bridge.

The bridge must explicitly account for the one-unit ceiling excess or formulate
the statement over the image of `concreteWindow`.  This review does not treat
`ceil` and `floor` as interchangeable.

## Post-Review Update

The later pass:

```text
docs/KL2003_M1_SURROGATE_ARBITRARY_X_LEAN_v1.md
```

proved the large-window arbitrary-`x` corollary by choosing:

```lean
y := Real.logb 2 ((x : Real) / (a : Real))
```

so that the `ceil` argument is exactly `(x : Real)`.  The no-arbitrary-window
warning above should now be read as the scope of this original review package,
not as the current project frontier.

Current non-claims after that pass:

```text
NO_FULL_M1_THEOREM_CLAIM
NO_HIGH_K_K9_OR_K11_084_CLAIM
NO_SMALL_X_BELOW_THRESHOLD_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```

## Classification

```text
KL2003_K2_M1_SURROGATE_WINDOW_THEOREM_REVIEWED
GAMMA_GT_THREE_SEVENTHS_CONFIRMED
CEIL_WINDOW_SCOPE_DOCUMENTED
DEPENDENCY_CHAIN_V3_CONFIRMED
ROW28_V3_META_ERRATA_CONSUMED
NO_FULL_M1_THEOREM_CLAIM
NO_HIGH_K_K9_OR_K11_084_CLAIM
NO_SMALL_X_BELOW_THRESHOLD_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
