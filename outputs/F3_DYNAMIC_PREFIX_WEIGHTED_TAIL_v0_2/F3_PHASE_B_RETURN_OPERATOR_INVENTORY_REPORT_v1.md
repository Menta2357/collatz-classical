# F3 PHASE_B return-operator inventory report v1

Date: 2026-07-21.

Status:

```text
RETURN_INVENTORY_BUILT
STOP_REBASING_NOT_MEMBERWISE
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. Purpose

This report records the first finite inventory for the scale-aware recurrence
orientation v0.2.

It implements the post-triangularity correction:

```text
F(rho) = rho^(-2) + (1/2) * rho^(log_2(3)-1)
```

The old `14.5%` margin is withdrawn. With the multiplicity normalization
included, the relevant scalar budget is narrow.

## 2. Predeclared parameters

```text
d0 = 5
rho_star = 9/5
lambda_11_official = 71689/40000
state space = all residues modulo 3^d0, with nu2 bucket b in {0,1,2}
```

No weights `w` are fitted in this step. No holdout is consumed.

## 3. Inventory result

Source:

```text
scripts/f3_phase_b_return_operator_inventory_v1.py
```

Output:

```text
results/F3_PHASE_B_RETURN_OPERATOR_INVENTORY_v1/summary.json
results/F3_PHASE_B_RETURN_OPERATOR_INVENTORY_v1/return_edges.csv
results/F3_PHASE_B_RETURN_OPERATOR_INVENTORY_v1/manifest_sha256.csv
```

Summary:

```text
state_count = 729
edge_count = 1458
advanced_source_states = 243

retarded_weight = 25/81
retarded_weight_decimal = 0.30864197530864196

advanced_return_weight = 0.5*rho_star^(log_2(3)-1)
advanced_return_weight_decimal = 0.7051716552602849

scalar_F_rho_star = 1.013813630568927
scalar_F_lambda_11 = 1.014713963108077

min_outgoing_weight = 0.30864197530864196
max_outgoing_weight = 1.013813630568927

power_iteration_estimate = 0.543699193728737
collatz_wielandt_min_ratio = 0.5436991937287369
collatz_wielandt_max_ratio = 0.543699193728737
```

## 4. Interpretation

The scalar renewal shadow remains above critical at the target:

```text
F(9/5) - 1 = 0.013813630568927...
```

This is the honest margin after multiplicity normalization. It is not the old
convention-dependent `14.5%`.

The finite rebased kernel does not certify growth. Its diagnostic Perron
estimate is:

```text
0.543699193728737
```

This means the first rebasing kernel is not yet a certificate object. It is
only an inventory of the proposed return mechanism.

## 5. Why the local verdict is STOP

The v0.2 page explicitly required the rebased return entries to be justified
member-wise. This inventory uses the candidate operation:

```text
advanced source at d0
  -> child prefix at d0-1
  -> all d0 lifts of that child prefix
```

That rebase is rule-derived, but it is not yet backed by a member-wise
inequality against the real `piStar` objects.

Therefore the correct local verdict is:

```text
STOP_REBASING_NOT_MEMBERWISE
```

The stop is not a failure of PHASE_B. It says the next object must be the
member-wise rebase hook or a replacement return construction.

## 6. Next accepted object

One of the following must be produced before any LP, frozen `w`, holdout
certificate, or Lean operator:

```text
REBASE_MEMBERWISE_HOOK_v1
```

or

```text
RETURN_EXCURSION_OPERATOR_v2
```

where the return entries are finite sums of explicitly listed path
inequalities, and any unlisted mass is charged to the same row-wise tail `Q`.

## 7. Non-claims

```text
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_LEAN_OPERATOR
```

