# F3 return-excursion member-wise hooks v1 report

Date: 2026-07-21.

Status:

```text
EMPIRICAL_CANDIDATE_HOOKS_PASS
NO_HOLDOUT_CONSUMPTION
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. Inputs

This hook pass consumes the predeclared budget:

```text
F3_RETURN_EXCURSION_MEMBERWISE_HOOKS_v1_BUDGET.md
```

and audits the already-built v2 operator:

```text
F3_PHASE_B_RETURN_EXCURSION_OPERATOR_v2
```

Fixed parameters:

```text
d0 = 5
rho_star = 9/5
lambda_11_official = 71689/40000
y_values = [8, 9, 10]
```

No holdout data is consumed in this pass.

## 2. Hook results

Source:

```text
scripts/f3_return_excursion_memberwise_hooks_v1.py
```

Outputs:

```text
results/F3_RETURN_EXCURSION_MEMBERWISE_HOOKS_v1/summary.json
results/F3_RETURN_EXCURSION_MEMBERWISE_HOOKS_v1/hook_checks.csv
results/F3_RETURN_EXCURSION_MEMBERWISE_HOOKS_v1/hook_failures.csv
results/F3_RETURN_EXCURSION_MEMBERWISE_HOOKS_v1/manifest_sha256.csv
```

Summary:

```text
hook_row_count = 4378
hook_failure_count = 0

channel_counts:
  retarded = 729
  advanced_direct_c2 = 81
  advanced_parity_lift_c1 = 81
  advanced_sterile_tail_c0 = 81
```

The five required hooks pass:

```text
H1 retarded window/target hook: PASS
H2 advanced direct hook: PASS
H3 parity lift hook: PASS
H4 sterile Q exact-count hook: PASS
H5 exact channel enumeration hook: PASS
```

## 3. Budget result

The predeclared diagnostic margin from v2 is:

```text
v2_power_iteration_estimate = 1.0147870480474077
v2_margin = 0.014787048047407714
```

The predeclared PHASE_B calibration loss line is:

```text
q_fraction = 0.0005020612050518277
phase_loss_fraction = 0.00013084713861374986
atom_tail_fraction = 0.00037121406643807783
```

Budget after this predeclared loss:

```text
budget_remaining_after_q_fraction = 0.014284986842355886
```

The budget check passes.

## 4. Verdict

The local verdict is:

```text
EMPIRICAL_CANDIDATE_HOOKS_PASS
```

This is not a rho certificate. It means the v2 diagnostic operator has passed
the current arithmetic/member-wise hook audit and the predeclared calibration
loss ledger still fits inside the diagnostic Perron margin.

## 5. Next accepted object

The next object is:

```text
F3_RETURN_EXCURSION_FREEZE_W_AND_HOLDOUT_CONTRACT_v1
```

It must predeclare:

```text
1. exact matrix used for the LP/eigenvector stage;
2. whether w is Perron-derived or LP-derived;
3. rationalization rule for w;
4. hash of frozen w before holdout;
5. holdout acceptance inequality;
6. every loss line included in the same row-wise inequality.
```

Only after that contract may holdout be consumed.

## 6. Non-claims

```text
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_LEAN_OPERATOR
```

