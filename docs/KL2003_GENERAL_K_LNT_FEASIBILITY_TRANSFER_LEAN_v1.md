# KL2003 general-k LNT feasibility transfer in Lean

Date: 2026-07-20

## Scope

This module transfers a source-faithful general-k LNT certificate through the
actual critical scheduler derivation. It introduces `LNTCertificate`, whose
fields are the L1--L4 coefficient inequalities: positive principal and
auxiliary coefficients, the three D1/D2/D3 rows, and the auxiliary-to-lift box
constraints.

The proof has four layers:

1. `d1TopExpr_coefficient_feasible`, `d2TopExpr_coefficient_feasible`, and
   `d3TopExpr_coefficient_feasible` realize the three source rows.
2. `sourceStep_coefficient_mono` proves that a source split followed by the
   prescribed deletion weakly increases the normalized coefficient value.
3. `run_coefficient_mono` transports this inequality through every finite
   critical scheduler run.
4. `sourceELRetardedWitness_coefficient_feasible` and
   `sourcePhiK_pointwise_coefficient_feasible` combine the generated run with
   its exact critical assignment. The selected all-retarded expression
   dominates the principal coefficient of its root.

The witness is not an arbitrary existential row. It retains the scheduler
step count, generated provenanced tree, critical assignment, criticality,
strictly negative leaf shifts, and semantic row inequality established by
`SourceELRetardedWitness`.

## Public contract

```lean
sourcePhiK_pointwise_coefficient_feasible
    (roots : GeneralKClassRootsNonempty (p + 1))
    (certificate : LNTCertificate hp) :
    PointwiseELCoefficientFeasible hp certificate
```

This is a pointwise coefficient-feasibility theorem. It does not provide one
uniform negative interval containing all leaf shifts of witnesses chosen at
different real arguments. Strict negativity alone is insufficient for that
step because symbolic shifts can, in principle, approach zero. A finite normal
system or an equivalent uniform shift bound remains the next bridge required
by the generic retarded induction and the k=3 `piStar` consumer.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKLNTFeasibilityTransfer
lake env lean CollatzClassical/KL2003/KL2003GeneralKLNTFeasibilityTransferAxiomAudit.lean
```

Classifications:

```text
GENERAL_K_LNT_CERTIFICATE_DEFINED
SOURCE_D1_D2_D3_COEFFICIENT_FEASIBILITY_PROVED
SOURCE_SPLIT_AND_DELETION_COEFFICIENT_MONOTONICITY_PROVED
CRITICAL_SCHEDULER_RUN_COEFFICIENT_MONOTONICITY_PROVED
POINTWISE_RETARDED_WITNESS_COEFFICIENT_FEASIBILITY_PROVED
SOURCE_PHI_K_POINTWISE_LNT_TRANSFER_PROVED
UNIFORM_RETARDED_SHIFT_WINDOW_NOT_YET_PROVED
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_FORMALISATION_NOT_AUTHORIZED
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
