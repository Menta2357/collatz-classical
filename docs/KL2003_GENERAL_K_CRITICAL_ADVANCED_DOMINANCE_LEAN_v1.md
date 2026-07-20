# KL2003 general-k critical advanced dominance in Lean

Date: 2026-07-20

## Scope

This module closes the scheduler-specific advanced-arrival realization that
remained after extraction of the coherent critical infinite branch. It proves
that the extracted branch satisfies the exact
`AdvancedArrivalsNonincreasing` contract consumed by the existing advanced
recurrence module.

The main theorem is:

```lean
extractedCriticalBranch_advancedArrivalsNonincreasing
  (roots : GeneralKClassRootsNonempty (p + 1))
  (hy : 2 <= y)
  (hbounds : CriticalNodeBounds ...)
  (hargs : ArgumentsNonnegative ...)
  (hne : NeverStops ...)
  : AdvancedArrivalsNonincreasing
      (extractedInfiniteSourceWalk hne) root.shift.eval
```

The invariant is intrinsic to the source genealogy stored by the existing
critical scheduler. For a retained D1 or D3 child, the final advanced arrival
uses the child action's own target mode. The deletion comparison is required
only when that target shift is nonnegative, exactly matching the semantics of
`HasDeletionWitness`. Earlier advanced arrivals are inherited from the parent
genealogy.

D1 and D3 preservation consume the already proved
`RetainedBranchesWitnessFree` facts for the exact raw
`AdvancedMinConfiguration` paths. D2 creates only a retarded child. No
historical realization hypothesis, second scheduler, or speculative wrapper
is introduced.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKCriticalAdvancedDominance
lake env lean CollatzClassical/KL2003/KL2003GeneralKCriticalAdvancedDominanceAxiomAudit.lean
```

## Remaining work

The advanced-recurrence module now yields an infinite recurrent subsequence
with strictly decreasing shifts. Strict decrease alone does not contradict a
nonnegative real sequence. The next termination module must derive a fixed or
uniform negative decrement for the recurrent advanced-return segments, or an
equivalent locally finite admissible family. Global all-segment contextual
admissibility remains refuted and is not reintroduced.

After that contradiction, the remaining semantic-chain work is the critical
stop-to-`SatisfiesEL` implication and normal-form uniqueness. No k=3
`piStar` theorem, k=9 authorization, k=11 result, or global Collatz theorem is
claimed here.

Classifications:

```text
CRITICAL_ADVANCED_DOMINANCE_INVARIANT_PROVED
CRITICAL_SELECTED_PREFIX_ADVANCED_DOMINANCE_PROVED
CRITICAL_EXTRACTED_BRANCH_ADVANCED_ARRIVALS_NONINCREASING_PROVED
HISTORICAL_REALIZATION_ASSUMPTION_NOT_USED
FIXED_RECURRENT_DECREMENT_NOT_YET_PROVED
GENERAL_K_EL_CONCLUSION_NOT_PROVED
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_FORMALISATION_NOT_AUTHORIZED
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
