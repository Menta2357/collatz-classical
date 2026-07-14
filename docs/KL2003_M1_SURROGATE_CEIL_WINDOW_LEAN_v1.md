# KL2003 M1 Surrogate Ceil Window Lean v1

## Scope

This pass packages the concrete M0D bound into the calibrated KL2003 `k=2`
M1-surrogate statement for the current concrete window:

```lean
concreteWindow y a = Nat.ceil ((2 : Real)^y * (a : Real))
```

It does not replace this with a floor window and does not state a global
Collatz theorem.

## Lean Results

The exponent is defined as:

```lean
gammaK2 : Real := Real.logb 2 lambdaR
```

The arithmetic lower bound is compiled:

```lean
gammaK2_gt_three_sevenths :
  (3 / 7 : Real) < gammaK2
```

It uses the already-closed integer witness:

```lean
k2_gamma_gt_three_sevenths_int :
  8 * 20 ^ 7 < 27 ^ 7
```

The real-power bridge is compiled:

```lean
two_rpow_gammaK2 :
  (2 : Real) ^ gammaK2 = lambdaR

lambdaR_rpow_eq_two_rpow_rpow_gammaK2 :
  lambdaR ^ y = ((2 : Real) ^ y) ^ gammaK2
```

The member-wise window theorem is compiled:

```lean
m1_surrogate_member_ceil_window_lower_bound_gamma :
  m = 2 \/ m = 5 \/ m = 8 ->
  (a : ClassRoots m) ->
  14 <= y ->
  DeltaV2 * (((2 : Real) ^ y) ^ gammaK2) <=
    (piStar a.1 (concreteWindow y a.1) : Real)
```

The packaged statement is:

```lean
kl2003_k2_m1_surrogate_ceil_window_lower_bound :
  M1SurrogateK2CeilWindowStatement
```

## Window Note

The theorem is intentionally stated for `concreteWindow`, which is currently a
`Nat.ceil` window.  A separate arbitrary-window or floor-window theorem would
need its own window equivalence or monotonicity bridge.  This pass does not
silently identify `ceil` with `floor`.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003M1Surrogate
lake env lean CollatzClassical/KL2003/KL2003M1SurrogateAxiomAudit.lean
```

Both passed.  The audit reports the expected Lean/Mathlib axioms only:

```text
propext
Classical.choice
Quot.sound
```

## Classification

```text
M1_SURROGATE_CEIL_WINDOW_STATEMENT_PROVED
GAMMA_K2_DEFINED
GAMMA_K2_GT_THREE_SEVENTHS_PROVED
LAMBDA_POWER_GAMMA_BRIDGE_PROVED
CONCRETE_WINDOW_CEIL_POLICY_EXPLICIT
NO_FLOOR_WINDOW_CLAIM
NO_ARBITRARY_WINDOW_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
