# F3 return-excursion member-wise hooks v1 budget

Date: 2026-07-21.

Status before running hooks:

```text
HOOK_BUDGET_PREDECLARED
NO_HOLDOUT_CONSUMPTION
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. Fixed inputs

```text
d0 = 5
rho_star = 9/5
operator = F3_PHASE_B_RETURN_EXCURSION_OPERATOR_v2
operator_perron_diagnostic = 1.0147870480474077
operator_margin = 0.0147870480474077
```

The v2 operator was already built before this budget. No parameter may be
changed in this hooks pass.

## 2. Budget lines

The budget ledger is predeclared before running the v1 hook script:

```text
margin_source:
  power_iteration_estimate(v2, d0=5) - 1

loss_line_1:
  PHASE_B calibration q_fraction

loss_line_2:
  sterile c == 0 mod 3 channel Q
  accounting mode: exact row-wise tail, not an estimated discount

loss_line_3:
  boundary / rounding correction
  accounting mode: not consumed in this pass

loss_line_4:
  holdout delta
  accounting mode: not consumed in this pass
```

The only numeric loss compared against the v2 diagnostic margin in this hooks
pass is the already-custodied PHASE_B calibration `q_fraction`.

From:

```text
results/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_PHASE_B_ALL_RESIDUES_PILOT_v1/calibration/summary.json
```

the predeclared value is:

```text
q_fraction = 0.0005020612050518277
phase_loss_fraction = 0.00013084713861374986
atom_tail_fraction = 0.00037121406643807783
```

Thus the diagnostic budget inequality to check is:

```text
0.0005020612050518277 < 0.0147870480474077
```

## 3. Five required hooks

The hook script must check:

```text
H1 retarded:
  target residue equals 4r modulo 3^d0;
  window identity 2^(y-2) * 4a = 2^y * a.

H2 advanced direct:
  c = (2a - 1)/3;
  c == 2 mod 3;
  3c + 1 = 2a;
  target state is the c state.

H3 parity lift:
  c = (2a - 1)/3;
  c == 1 mod 3;
  lifted = 2c;
  T(lifted) = c;
  target state is the lifted state;
  dyadic parity window is exact.

H4 sterile Q:
  c = (2a - 1)/3;
  c == 0 mod 3;
  Q is counted exactly as the pure-duplication tail under
  W = 3 * 2^(y-1) * c.

H5 enumeration:
  advanced_direct_c2 = advanced_parity_lift_c1 = advanced_sterile_tail_c0 = 81.
```

The selected hook window values are:

```text
y_values = [8, 9, 10]
```

matching the PHASE_B calibration range.

## 4. Allowed outcomes

```text
EMPIRICAL_CANDIDATE_HOOKS_PASS
STOP_HOOK_FAILURE
STOP_BUDGET_MARGIN_EXHAUSTED
```

Forbidden:

```text
RHO_CERTIFIED
DENSITY_THEOREM
ALMOST_ALL
GLOBAL_COLLATZ
LEAN_READY
```

