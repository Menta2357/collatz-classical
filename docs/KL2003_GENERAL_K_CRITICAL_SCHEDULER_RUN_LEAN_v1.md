# KL2003 general-k critical scheduler finite run in Lean

Date: 2026-07-20

## Scope

This module closes finite iteration of the critical source step at fixed
`sourcePhiK,y`. It introduces no second tree or source-step representation:
every state is the existing `ProvenancedTree`, and every nontrivial transition
is the existing provenanced `sourceStep` applied to the occurrence selected by
`findCriticalExpandableOccurrence`.

The finite run proves:

- preservation of `CriticalNodeBounds` at every index;
- preservation of nonnegative normalized-expression arguments;
- one-step and initial-relative weak descent of normalized value;
- preservation of exact source-genealogy traces;
- exact reduction of every non-stopping successor to its selected
  provenanced `sourceStep`;
- witness-free retained D1/D3 branches at every selected critical target; and
- unbounded selected source-walk depth if the critical run never stops.

The last item reuses the existing quaternary `treeFuel` theorem. It depends
only on each selected transition being a source step, not on the old
left-to-right selector.

The stopping statement remains exact:

```text
finder = none iff every globally critical terminal has negative shift.
```

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKCriticalSchedulerRun
lake env lean CollatzClassical/KL2003/KL2003GeneralKCriticalSchedulerRunAxiomAudit.lean
```

## Remaining work

Unbounded selected depth is not yet the coherent infinite critical branch.
The next module must adapt the existing inverse-system/Konig extraction to the
critical selector, then connect its selected prefixes to the witness-free
advanced-arrival consumer. No termination, final `SatisfiesEL`, k=3 `piStar`,
k=9 authorization, or global Collatz result is claimed here.

Classifications:

```text
GENERAL_K_CRITICAL_FINITE_RUN_PROVED
CRITICAL_RUN_INVARIANTS_PRESERVED
CRITICAL_RUN_NORMAL_VALUE_WEAK_DESCENT_PROVED
CRITICAL_RUN_TRACE_CONSISTENCY_PROVED
CRITICAL_SELECTED_D1_D3_RETENTION_WITNESS_FREE
CRITICAL_SELECTED_GENEALOGY_DEPTH_UNBOUNDED_IF_NEVER_STOPS
CRITICAL_KONIG_EXTRACTION_NOT_YET_PROVED
GENERAL_K_EL_CONCLUSION_NOT_PROVED
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_FORMALISATION_NOT_AUTHORIZED
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
