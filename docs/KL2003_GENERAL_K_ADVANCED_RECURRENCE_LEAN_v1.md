# KL2003 general-k advanced recurrence Lean v1

## Result

`KL2003GeneralKAdvancedRecurrence.lean` formalizes the scheduler-independent
combinatorial core of the corrected Theorem 3.1 route.

It defines `IsAdvancedAction` directly from the typed source branch and proves:

- a non-advanced source action has evaluated weight exactly `-2`;
- a finite segment containing no advanced action has weight `-2 * length`;
- an infinite branch whose accumulated shifts remain nonnegative has an
  advanced action at or after every index;
- the set of advanced-action indices is infinite; and
- some tracked mode receives an infinite strictly ordered subsequence of
  advanced arrivals.
- under `AdvancedArrivalsNonincreasing`, the accumulated shifts on that
  recurrent subsequence decrease strictly at every step.

The last theorem is
`exists_recurrent_advanced_target_subsequence`.  Its positions are action
indices, and each recorded mode is the target after the corresponding advanced
action.  This is the recurrence shape to which the deletion rule applies.

## Boundary

`AdvancedArrivalsNonincreasing` is the exact branch-level contract supplied by
witness-free retained advanced leaves: a later advanced arrival to an already
seen target mode cannot lie above the earlier shift.  The existing
irrationality theorem excludes equality on every nonempty intervening segment,
so Lean upgrades this to strict decrease.

The module does not yet prove that these decreases have one fixed negative
increment.  That step is scheduler-specific: it must connect the recurrent
provenanced subtrees through the existing translation-equivariance API and
show that their eligibility pattern is preserved.  Nor does this module
discharge the separate triple-witness exclusion needed to obtain
`AdvancedArrivalsNonincreasing` from the concrete scheduler.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKAdvancedRecurrence
lake env lean CollatzClassical/KL2003/KL2003GeneralKAdvancedRecurrenceAxiomAudit.lean
```

## Classification

```text
ADVANCED_ACTIONS_UNBOUNDED_ON_NONNEGATIVE_BRANCH
ADVANCED_INDEX_SET_INFINITE
RECURRENT_ADVANCED_TARGET_SUBSEQUENCE_PROVED
RECURRENT_ADVANCED_TARGET_SHIFTS_STRICTLY_DECREASE_UNDER_WITNESS_FREE_CONTRACT
FIXED_RECURRENT_INCREMENT_NOT_YET_PROVED
TRIPLE_WITNESS_EXCLUSION_STILL_OPEN
NO_K3_PISTAR_THEOREM_YET
NO_K9_FORMALIZATION
NO_GLOBAL_COLLATZ_CLAIM
```
