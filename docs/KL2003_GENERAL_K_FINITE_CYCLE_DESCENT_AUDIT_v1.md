# KL2003 general-k finite-cycle descent audit v1

Date: 2026-07-20

## Question audited

The first finite-cycle scoping proposed decomposing a nonpositive closed walk
on a surviving EL branch into simple cycles and taking a finite negative gap.
This requires the simple cycles produced by loop erasure to remain
nonpositive.

`KL2003GeneralKFiniteCycleDescentAudit.lean` tests that implication against the
actual source graph at `k = 2`.

## Kernel-checked counterexample

The module defines the tracked modes 2 and 8 and proves the exact source
targets:

```text
8 --D3 index 0--> 2
2 --D1 index 0--> 2
2 --D1 index 2--> 8
```

The corresponding weights are:

```text
inner class-2 loop       = alpha - 2       < 0
loop-erased simple cycle = 2 * alpha - 3   > 0
complete nested route    = 3 * alpha - 5   < 0
```

Lean also proves the exact symbolic and evaluated decompositions:

```text
complete nested route = loop-erased simple cycle + inner loop
```

Thus the complete repeated-mode segment and its contiguous inner return are
negative, but deleting the nested return exposes a positive simple cycle.

## Consequence

This does not refute KL2003 Theorem 3.1 and does not produce a nonterminating
EL branch. It refutes only the proposed inference:

```text
contextual nonpositivity of original repeated-mode segments
  -> negativity of every simple cycle after loop erasure
```

The finite-cycle module must preserve nested return packages or prove a
stronger local-finiteness/first-return theorem by induction on the finite mode
set. A raw simple-cycle gap is insufficient because the raw graph genuinely
contains positive cycles.

## Verification

```text
lake env lean CollatzClassical/KL2003/KL2003GeneralKFiniteCycleDescentAudit.lean
lake env lean CollatzClassical/KL2003/KL2003GeneralKFiniteCycleDescentAuditAxiomAudit.lean
```

The audited theorems report only:

```text
[propext, Classical.choice, Quot.sound]
```

## Classification

```text
K2_NESTED_NEGATIVE_RETURN_ROUTE_PROVED
K2_INNER_D1_LOOP_NEGATIVE_PROVED
K2_LOOP_ERASED_RESIDUAL_SIMPLE_CYCLE_POSITIVE_PROVED
NAIVE_SIMPLE_CYCLE_NEGATIVITY_INFERENCE_REFUTED
FINITE_CYCLE_DESCENT_SCOPING_REQUIRES_REVISION
THEOREM31_NOT_REFUTED
EL_TERMINATION_NOT_YET_PROVED
EL_ORDER_INDEPENDENCE_NOT_YET_PROVED
NO_K3_PISTAR_THEOREM_CLAIM
NO_K9_FORMALISATION_AUTHORIZATION
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
