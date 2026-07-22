# F3 PHASE_B return-excursion operator v2 report

Date: 2026-07-21.

Status:

```text
RETURN_EXCURSION_V2_BUILT_DIAGNOSTIC_ONLY
PERRON_DIAGNOSTIC_ABOVE_ONE_AT_PREDECLARED_D0
STOP_V2_MEMBERWISE_HOOKS_MISSING
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. What changed from v1

The v1 return inventory stopped at:

```text
STOP_REBASING_NOT_MEMBERWISE
```

The v2 experiment retires the rebase hook and adds the missing row22-style
parity lift channel:

```text
c == 1 mod 3  ->  2c
```

The channel is cited against the existing k=2 Lean precedent in:

```text
CollatzClassical/KL2003/KL2003ConcretePhiRealization.lean
```

with names including:

```text
row22LiftedChild
row22_parity_lift_route_to_root
row22_parity_piStar_transfer
row22_min3_le_lifted_child
row22_min3_le_direct_advanced
```

This report does not claim those k=2 lemmas already prove the F3 operator.
They are precedent for the required member-wise hook type.

## 2. Predeclared custodial run

```text
d0 = 5
rho_star = 9/5
lambda_11_official = 71689/40000
state space = all residues modulo 3^d0, with nu2 bucket b in {0,1,2}
```

Source:

```text
scripts/f3_phase_b_return_excursion_operator_v2.py
```

Outputs:

```text
results/F3_PHASE_B_RETURN_EXCURSION_OPERATOR_v2/summary.json
results/F3_PHASE_B_RETURN_EXCURSION_OPERATOR_v2/return_excursion_edges.csv
results/F3_PHASE_B_RETURN_EXCURSION_OPERATOR_v2/row_tail_Q.csv
results/F3_PHASE_B_RETURN_EXCURSION_OPERATOR_v2/manifest_sha256.csv
```

## 3. Result

```text
state_count = 729
edge_count = 891
tail_row_count = 81

channel_counts:
  retarded = 729
  advanced_direct_c2 = 81
  advanced_parity_lift_c1 = 81
  advanced_sterile_tail_c0 = 81

retarded_weight = 0.30864197530864196
advanced_base_weight = 1.4103433105205698
direct_source_weight = 1.4103433105205698
parity_lift_source_weight = 0.7835240614003166
sterile_tail_source_weight = 1.4103433105205698

scalar_direct_contribution = 0.47011443684018994
scalar_parity_lift_contribution = 0.2611746871334389
scalar_F_sector_rho_star = 1.0399310992822708
scalar_F_sector_lambda_11 = 1.0418955393868232

power_iteration_estimate = 1.0147870480474077
collatz_wielandt_min_ratio = 1.0147870480473962
collatz_wielandt_max_ratio = 1.0147870480474173
```

The finite operator with the lift channel is diagnostically above one at the
predeclared `d0 = 5`.

The graph margin is about:

```text
1.0147870480474077 - 1 = 0.0147870480474077
```

This is narrower than the scalar shadow margin:

```text
1.0399310992822708 - 1 = 0.0399310992822708
```

That gap is expected: the scalar model counts channel mass, while the finite
operator also sees redistribution among residue/bucket states.

## 4. Sensitivity check, not selection

The following cold diagnostic was run after the predeclared `d0 = 5` result:

```text
d0=3  states=81    perron=0.9950977132092629
d0=4  states=243   perron=0.9721879755828957
d0=5  states=729   perron=1.0147870480474077
d0=6  states=2187  perron=1.0575235943518562
```

This is not a bisection, not a holdout, and not a parameter search for a
certificate. The custodial v2 run remains the predeclared `d0 = 5` run.

## 5. Verdict

The correct local verdict is still a stop:

```text
STOP_V2_MEMBERWISE_HOOKS_MISSING
```

Reason: the operator now has the complete three-channel graph, and the Perron
diagnostic is promising, but the F3 member-wise inequalities for each entry are
not yet written.

The next accepted object is:

```text
RETURN_EXCURSION_MEMBERWISE_HOOKS_v1
```

Required hooks:

```text
1. retarded channel hook;
2. advanced PHASE_B direct hook;
3. parity lift hook modelled on row22;
4. sterile c == 0 mod 3 row-wise tail Q hook;
5. exact finite enumeration lemma for the channel split.
```

Only after those hooks exist may the project freeze `w`, hash it, and consume
holdout.

## 6. Non-claims

```text
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_LEAN_OPERATOR
```

