# KL2003 general-k critical-stop semantics in Lean

Date: 2026-07-20

## Scope

This module closes the pointwise semantic exit from the terminating critical
general-k scheduler. It consumes the finite state supplied by
`exists_criticalTerminalShiftsNegative`; it does not assume a prebuilt EL
normal form.

For fixed `Phi,y`, `ELExpr.CriticalAssignment.exists_isCritical` chooses one
value-preserving branch at every minimum. `SourceELRetardedWitness` retains the
exact scheduler step, generated tree, critical assignment, and criticality
proof; it is not an existential over arbitrary retarded expressions. The theorem
`provenanced_selectedExpr_allLeafShiftsNegative` transports the scheduler stop
predicate through the full provenanced tree and proves that every leaf of the
selected expression has strictly negative symbolic shift. The resulting
witness satisfies

```lean
row.eval Phi y <= Phi root.mode (y + root.shift.eval).
```

The public source theorem is:

```lean
sourcePhiK_satisfiesEL
    (roots : GeneralKClassRootsNonempty (p + 1)) :
    SatisfiesEL hp
```

Here `SatisfiesEL` is intentionally pointwise in the mode and argument. Its
witness may depend on `Phi,y`, exactly as the critical-assignment argument in
KL2003 equations (304)-(305) does, but every witness must come from an actual
finite run of the source scheduler. No order-independent or canonical finite
tree is introduced as an extra hypothesis.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKCriticalStopSemantics
lake env lean CollatzClassical/KL2003/KL2003GeneralKCriticalStopSemanticsAxiomAudit.lean
```

## Remaining work

The scheduler termination and the source pointwise EL semantics are now
closed. The next mathematical bridge must transfer a general-k LNT
certificate to a lower bound for every pointwise all-retarded witness. The
existing k=3 generated certificate is the first intended consumer. Canonical
normal-form uniqueness remains a separate syntactic question, not an input to
this pointwise semantic theorem.

Classifications:

```text
CRITICAL_SELECTED_EXPRESSION_NEGATIVE_SHIFTS_PROVED
CRITICAL_STOP_TO_SATISFIES_EL_AT_PROVED
SOURCE_PHI_K_SATISFIES_EL_PROVED
POINTWISE_CRITICAL_ASSIGNMENT_SEMANTICS_USED
CANONICAL_NORMAL_FORM_NOT_ASSUMED
GENERAL_K_LNT_TO_POINTWISE_EL_TRANSFER_NOT_YET_PROVED
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_FORMALISATION_NOT_AUTHORIZED
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
