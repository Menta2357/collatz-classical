# KL2003 general-k critical source step in Lean

Date: 2026-07-20

## Scope

This module closes the one-step layer of the Phi-sensitive critical scheduler.
It operates on the existing provenanced source step rather than introducing a
second scheduler interface.

For a globally critical nonnegative terminal, the module proves that one
source-faithful D1/D2/D3 expansion:

- preserves `CriticalNodeBounds`;
- preserves nonnegative normalized-expression arguments;
- weakly decreases the normalized expression value;
- retains exact provenance through the existing `sourceStep_forget` theorem;
- leaves the retained D1/D3 advanced branches witness-free.

The central contextual replacement theorem is
`Context.plug_criticalNodeBounds_of_le_of_targetCritical`. It is deliberately
stated for `CriticalNodeBounds`, not the stronger global `NodeBounds`: a lower
replacement at a selected critical occurrence cannot make an unaffected
sibling newly critical.

The final constructed bundle is
`GeneralKCriticalSourceStep.CriticalSourceStepFacts`, produced by
`criticalSourceStepFacts`. No theorem takes this bundle as an external
hypothesis.

## Exact calibration

The source split is not claimed to preserve the normalized value exactly. The
proved relation is the source-faithful inequality

```text
new normalExpr value <= old normalExpr value.
```

Exactness applies to the provenance erasure: the existing provenanced source
step forgets exactly to the raw source step.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKCriticalSourceStep
lake env lean CollatzClassical/KL2003/KL2003GeneralKCriticalSourceStepAxiomAudit.lean
```

## Remaining work

This module does not prove scheduler iteration, termination, critical
genealogy compactness, a fixed recurrent decrement, a final `SatisfiesEL`
theorem, the k=3 `piStar` consumer, or any k=9 result.

Classifications:

```text
GENERAL_K_CRITICAL_SOURCE_STEP_PROVED
CRITICAL_NODE_BOUNDS_PRESERVED_ONE_STEP
ARGUMENT_NONNEGATIVITY_PRESERVED_ONE_STEP
NORMAL_VALUE_WEAK_DESCENT_PROVED
D1_D3_RETAINED_BRANCHES_WITNESS_FREE_AT_CRITICAL_TARGETS
PROVENANCE_REUSES_EXISTING_EXACT_FORGET_THEOREM
CRITICAL_SOURCE_STEP_ITERATION_NOT_PROVED
GENERAL_K_EL_CONCLUSION_NOT_PROVED
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_FORMALISATION_NOT_AUTHORIZED
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
