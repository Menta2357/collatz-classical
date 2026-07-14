# KL2003 Audit-Ready Fidelity Package v1

## Scope

This package summarizes the audit-ready KL2003 formalisation state for CC
Challenge formalisation id `10`.

Repository HEAD:

```text
04f61ac
```

Main Lean file:

```text
CollatzClassical/KL2003/KL2003M1Surrogate.lean
```

Audit file:

```text
CollatzClassical/KL2003/KL2003M1SurrogateAxiomAudit.lean
```

The closed results are:

```lean
kl2003_k2_m1_surrogate_ceil_window_lower_bound
kl2003_k2_m1_surrogate_arbitrary_x_lower_bound
kl2003_k2_m1_surrogate_root8_lower_bound
```

## Statement vs Paper Fidelity

| Paper/source role | Lean theorem/object | What is proved | What is not proved | Fidelity note |
|---|---|---|---|---|
| KL2003 general program | This package only treats the `k=2` surrogate lane | A calibrated lower-bound mechanism for tracked classes `{2,5,8}` | Not the full KL2003 `k=9` / exponent `0.84` theorem | The name includes `k2` and `surrogate` to prevent overclaiming. |
| M1-style surrogate exponent | `gammaK2 := Real.logb 2 (27 / 20)` | `gammaK2_gt_three_sevenths` | No claim that this is KL2003's final exponent | This is the k=2 surrogate exponent, with integer witness `27^7 > 8 * 20^7`. |
| Ceil-window theorem | `kl2003_k2_m1_surrogate_ceil_window_lower_bound` | For `14 <= y`, admissible roots in classes `{2,5,8}` satisfy the lower bound at `concreteWindow y a` | Not an arbitrary-`x` theorem by itself | This was the first packaged technical theorem. |
| Arbitrary large `x` corollary | `kl2003_k2_m1_surrogate_arbitrary_x_lower_bound` | If `((2 : Nat)^14) * a.1 <= x`, then `DeltaV2 * (((x : Real)/(a.1 : Real))^gammaK2) <= piStar a.1 x` | No statement for `x` below the threshold | The `ceil` excess is eliminated by choosing `y = Real.logb 2 ((x:Real)/(a:Real))`. |
| Public root-8 instance | `kl2003_k2_m1_surrogate_root8_lower_bound` | If `2^17 <= x`, then `DeltaV2 * ((x/8)^gammaK2) <= piStar 8 x` | Not an all-roots theorem and not a global Collatz claim | `8 : ClassRoots 8` is named by `classRoot_eight`. |
| Row28 paper fidelity | `I2ELAbstractRowsV3`, `concretePhi_rowsV3` | The concrete seam uses the source-faithful V3 `phi25` arm | V2 `phi22` arm is not used as the KL2003 row28 target | V2 remains historical/abstract only after the meta-errata. |

The word `surrogate` is therefore correct: the result is a source-aware,
formalized k=2 surrogate lower-bound theorem, not the full KL2003 theorem and
not the full M1 theorem.

## Theorem Inventory

### Ceil-Window Technical Theorem

```lean
kl2003_k2_m1_surrogate_ceil_window_lower_bound :
  M1SurrogateK2CeilWindowStatement
```

This packages:

```lean
0 < DeltaV2
(3 / 7 : Real) < gammaK2
forall {m : Nat}, m = 2 ∨ m = 5 ∨ m = 8 ->
  forall (a : ClassRoots m) {y : Real}, 14 <= y ->
    DeltaV2 * (((2 : Real)^y)^gammaK2)
      <= (piStar a.1 (concreteWindow y a.1) : Real)
```

### Arbitrary Large `x` Theorem

```lean
kl2003_k2_m1_surrogate_arbitrary_x_lower_bound
```

with statement:

```lean
theorem kl2003_k2_m1_surrogate_arbitrary_x_lower_bound
    {m : Nat} (hm : m = 2 ∨ m = 5 ∨ m = 8)
    (a : ClassRoots m) {x : Nat}
    (hx : ((2 : Nat)^14) * a.1 <= x) :
    DeltaV2 * (((x : Real) / (a.1 : Real)) ^ gammaK2)
      <= (piStar a.1 x : Real)
```

### Public Root-8 Instance

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

## Public Calibrated Statement

For every natural `x >= 2^17`,

```text
DeltaV2 * ((x / 8)^gammaK2) <= piStar 8 x.
```

In KL2003 semantics, `piStar 8 x` counts positive starting values `n <= x`
whose bounded orbit reaches `8`.  Since the forward `T` orbit of `8` reaches
`1`, every counted `n` also reaches `1`.

This sentence must not be converted into a global Collatz claim: the theorem
does not assert that every `n` reaches `8`, nor that every `n` reaches `1`.
It gives a lower bound on the number of bounded preimages reaching the specific
root `8`.

## Reproduction Commands

```text
lake build CollatzClassical.KL2003.KL2003M1Surrogate
lake env lean CollatzClassical/KL2003/KL2003M1SurrogateAxiomAudit.lean
```

Expected result:

```text
BUILD = PASS
AXIOM_AUDIT = PASS
```

## Axiom Audit Profile

The audit reports the usual Lean/Mathlib real-number foundations:

```text
[propext, Classical.choice, Quot.sound]
```

The audit file prints axioms for:

```lean
gammaK2_eq_logb
gammaK2_gt_three_sevenths
two_rpow_gammaK2
lambdaR_rpow_eq_two_rpow_rpow_gammaK2
DeltaV2_mul_lambdaR_rpow_le_component
m1_surrogate_member_ceil_window_lower_bound
m1_surrogate_member_ceil_window_lower_bound_gamma
kl2003_k2_m1_surrogate_ceil_window_lower_bound
x_pos_of_pow14_mul_root_le
two_rpow_logb_ratio_mul_root_eq_x
concreteWindow_logb_eq_self
fourteen_le_logb_ratio_of_pow14_mul_root_le
notInCycle_eight
classRoot_eight
kl2003_k2_m1_surrogate_arbitrary_x_lower_bound_component
kl2003_k2_m1_surrogate_arbitrary_x_lower_bound
kl2003_k2_m1_surrogate_root8_lower_bound
```

Guardrail scan:

```text
no sorry
no admit
no unsafe
no native_decide
```

## Dependency Chain

The final root-8 theorem depends on:

```text
KL2003M1Surrogate
-> kl2003_k2_m1_surrogate_arbitrary_x_lower_bound
-> m1_surrogate_member_ceil_window_lower_bound_gamma
-> concretePhi_retarded_lower_bound
-> m0c_retarded_induction_bound_v3
-> concretePhi_k2_retarded_inputs_v3
-> concretePhi_rowsV3
-> concretePhi_row28_seam_v3
-> row28 V3 c' split / post-deletion branch
-> k=2 rational certificate, endpoint bounds, and alpha/log lemmas
```

The arbitrary-`x` bridge additionally uses:

```text
Real.rpow_logb
Real.le_logb_iff_rpow_le
Nat.ceil_natCast
```

to prove:

```lean
concreteWindow (Real.logb 2 ((x : Real) / (a : Real))) a = x
```

under the large-window hypothesis.

## Meta-Errata Note

The V3 row contract reinstates the source-faithful `phi25` arm in the row28
`M1` block:

```lean
M1V3 Phi y =
  min
    (Phi.phi28 (y + shift2AlphaMinus5Pad2) + M2V3 Phi y)
    (Phi.phi25 (y + shift2AlphaMinus5Pad2))
```

The previous V2 `phi22` abstraction remains in the repository as a historical
abstract theorem target.  It is not the source-faithful KL2003 row28 contract
after the meta-errata and is not used for the current audit-ready theorem
chain.

## No-Claims

Current no-claims:

```text
NO_FULL_M1_THEOREM_CLAIM
NO_K9_OR_084_CLAIM
NO_SMALL_X_CLAIM_BELOW_THRESHOLD
NO_GLOBAL_COLLATZ_CLAIM
```

Additional scope guardrails:

```text
NO_ALL_ROOTS_CLAIM
NO_ALL_ORBITS_REACH_8_CLAIM
NO_COLLATZ_PROVED_CLAIM
```

## Classification

```text
KL2003_AUDIT_READY_PACKAGE_CREATED
STATEMENT_FIDELITY_TABLE_COMPLETE
REPRODUCTION_COMMANDS_LISTED
AXIOM_AUDIT_PROFILE_DOCUMENTED
PUBLIC_ROOT8_STATEMENT_CALIBRATED
NO_GLOBAL_COLLATZ_CLAIM
```
