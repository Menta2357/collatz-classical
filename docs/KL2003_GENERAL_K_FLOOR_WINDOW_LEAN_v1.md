# KL2003 general-k floor-window Lean pilot v1

Date: 2026-07-19

## Scope

This note records the first proved infrastructure module of the general-k
semantic chain. It validates the source-faithful Nat realization

```lean
sourceWindow y a = Nat.floor ((2 : Real) ^ y * a)
```

without modifying the existing k=2 `concreteWindow`, which remains based on
`Nat.ceil`.

## Lean files

```text
CollatzClassical/KL2003/KL2003GeneralKFloorWindow.lean
CollatzClassical/KL2003/KL2003GeneralKFloorWindowAxiomAudit.lean
```

## Proved traffic lemmas

Basic behavior:

```lean
sourceWindow_mono_y
root_le_sourceWindow
```

Exact retarded and parity transports:

```lean
sourceWindow_retarded_four
sourceWindow_parity_two
```

For a two-branch child satisfying `3*c + 1 = 2*a`:

```lean
source_advanced_power_mul_child_le_root
sourceWindow_advanced_child_le_target
sourceWindow_lifted_advanced_child_le_target
```

The first advanced theorem is the D3 window at shift `alpha - 1`. The lifted
theorem composes it with the exact parity transport and gives the D1 tracked
child window at shift `alpha - 2`. Neither theorem uses `epsilon0` or a padded
shift.

The public arbitrary-window identity is also available:

```lean
sourceWindow_logb_eq_self
```

For positive natural `a` and `x`, choosing
`y = Real.logb 2 ((x : Real) / (a : Real))` makes the source window exactly
`x`.

## Interpretation

The result confirms the window-policy decision in the general-k scoping:

- `Nat.floor` is the direct Nat model of the paper's real cutoff;
- retarded multiplication by four and the parity lift are exact;
- the advanced unit loss is already favorable at the real-window level; and
- the epsilon padding in the existing k=2 seam belongs to its independent
  `Nat.ceil` implementation, not to the source difference inequalities.

This pilot does not prove P3, concrete general-k D1/D2/D3 rows, EL
termination, feasibility transfer, a k=3 `piStar` theorem, or any high-k
bound.

## Verification

Commands:

```text
lake build CollatzClassical.KL2003.KL2003GeneralKFloorWindow
lake env lean CollatzClassical/KL2003/KL2003GeneralKFloorWindowAxiomAudit.lean
git diff --check
```

Build and audit pass. Every audited theorem reports exactly:

```text
[propext, Classical.choice, Quot.sound]
```

No `sorry`, `admit`, `unsafe`, or `native_decide` is used.

## Next consumer

The next general-k semantics module may cite this file for all Real-to-Nat
window traffic. Its remaining semantic obligations are indexed residue
normalization, class-root non-emptiness, the concrete P3 equality, and the
member-wise D1/D2/D3 fiber transfers.

## Classification

```text
GENERAL_K_SOURCE_FLOOR_WINDOW_DEFINED
GENERAL_K_FLOOR_WINDOW_MONOTONICITY_PROVED
GENERAL_K_FLOOR_WINDOW_ROOT_BASE_PROVED
GENERAL_K_RETARDED_FOUR_WINDOW_EXACT
GENERAL_K_PARITY_TWO_WINDOW_EXACT
GENERAL_K_D3_ADVANCED_WINDOW_TRANSFER_PROVED
GENERAL_K_D1_LIFTED_WINDOW_TRANSFER_PROVED
GENERAL_K_FLOOR_WINDOW_LOGB_SELF_PROVED
GENERAL_K_FLOOR_WINDOW_AXIOM_AUDIT_PASS
K2_CEIL_WINDOW_RETAINED_UNCHANGED
GENERAL_K_ROWS_NOT_YET_PROVED
K3_PISTAR_THEOREM_NOT_YET_PROVED
NO_HIGH_K_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
