# F3 PHASE_B all-residues dynamic-prefix pilot report v1

Date: 2026-07-21.

Status:

```text
LOCAL_EMPIRICAL_GATE_PASS_HOOKS
CLAUDE_UNAVAILABLE
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN
```

## 1. Route correction

The first v0.3 state space made only residues `2 mod 3` visible. That was too
narrow. It confused:

```text
parent roots with an advanced branch
```

with:

```text
roots allowed to appear as state types
```

The corrected dynamic state makes all residues visible and records
`r == 2 mod 3` only as a branch-existence flag.

## 2. Phase replacement

`PHASE_A` used:

```text
P(c(a), 2^y c(a))
```

and failed in full calibration:

```text
unique parent roots = 3455
rows = 10365
mismatches = 0
q_fraction = 0.40441294196566785
phase_loss_fraction = 0.25349816431689476
verdict = STOP_PHASE_A_TAIL_TOO_LARGE
```

`PHASE_B` uses the E5-style monotone replacement:

```text
P(c(a), x_a - 2^(y-1))
```

Since:

```text
x_a = 2^y a
c(a) = (2a - 1) / 3
x_a - 2^(y-1) = 3 * 2^(y-1) * c(a)
```

this is still below `x_a` and keeps the lower-bound direction.

## 3. Frozen local pilot contract

```text
K = 5
visible residues = all residues modulo 3^d
visible depths = 1..5
parent roots = a == 2 mod 3
finite base exception = a = 2
y = {8,9,10}
calibration = 1 <= a < 10369
holdout = 10369 <= a < 20737
weights = option A, all visible weights 1 and tau 1
```

This is still empirical. No spectral matrix or `rho` certificate is claimed.

## 4. Calibration result

```text
unique parent roots = 3455
root rows = 10365
mismatches = 0
target = 55843789
retarded_visible = 13216674
advanced_visible_phase_B = 42599078
advanced_tail_phase_B = 0
phase_loss_tail = 7307
atom_tail = 20730
q_total = 28037
visible_total = 55815752
visible_capture_fraction = 0.9994979387949482
q_fraction = 0.0005020612050518277
phase_loss_fraction = 0.00013084713861374986
status = PASS_HOOKS_ONLY
```

## 5. Holdout result

```text
unique parent roots = 3456
root rows = 10368
mismatches = 0
target = 50143293
retarded_visible = 12810039
advanced_visible_phase_B = 37312518
advanced_tail_phase_B = 0
phase_loss_tail = 0
atom_tail = 20736
q_total = 20736
visible_total = 50122557
visible_capture_fraction = 0.9995864651330338
q_fraction = 0.0004135348669661564
phase_loss_fraction = 0.0
status = PASS_HOOKS_ONLY
```

Both mismatch files contain only a header row.

## 6. Interpretation

This is the first F3 dynamic-prefix result that survives the known structural
obstructions:

```text
fixed-modulus advanced fragmentation: avoided by dynamic depth
artificial non-2mod3 tail: removed by all-residue visibility
advanced phase loss: controlled empirically by PHASE_B
holdout integrity: parent-root intervals disjoint
member-wise hooks: pass
```

The local empirical gate advances from:

```text
OPEN_PAPER_ONLY
```

to:

```text
PRE_SPECTRAL_CANDIDATE
```

## 7. What is still missing

This report does not prove a growth rate. The missing object is:

```text
F3_PHASE_B_DYNAMIC_OPERATOR_v1
```

It must build the actual finite transition operator on all visible states and
check whether rational weights satisfy:

```text
w^T M >= rho/(1-epsilon) w^T
rho > 1.7922
same-denominator error absorption
```

The empirical tail is far below the informal `10.39%` design margin, but that
number is not a proof until the operator and denominator are identical.

## 8. Non-claims

```text
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_LEAN
```

