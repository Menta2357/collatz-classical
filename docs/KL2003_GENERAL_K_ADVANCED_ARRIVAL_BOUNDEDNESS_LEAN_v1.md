# KL2003 general-k advanced-arrival boundedness in Lean

Date: 2026-07-20

## Scope

This module closes termination of the existing critical general-k scheduler.
It does not assume the exact recurrent-subtree self-similarity asserted in the
informal proof of KL2003 Theorem 3.1. That assertion is not available for the
formal scheduler because eligibility uses absolute shifts and deletion depends
on the full outer history.

The replacement argument has four finite steps:

1. `AdvancedArrivalsNonincreasing` bounds every advanced arrival by the first
   arrival to its finite target mode.
2. Global shift nonnegativity then forces a uniform bounded gap between
   advanced actions.
3. Every block of `card(TrackedMode (p + 1)) + 1` advanced arrivals contains a
   bounded same-target pair. The segment between the pair has strictly
   negative weight.
4. Bounded typed source walks form a finite set, so all such negative segment
   weights are bounded above by one `-epsilon`. A recurrent pair mode across
   disjoint blocks accumulates this epsilon and contradicts nonnegativity.

The central scheduler-independent theorem is:

```lean
nonnegative_branch_impossible_of_advancedArrivalsNonincreasing
  (branch : InfiniteSourceWalk hp)
  (initial : Real)
  (hnonnegative : branch.ShiftsNonnegative initial)
  (hretained : AdvancedArrivalsNonincreasing branch initial) : False
```

Its critical-scheduler specialization proves:

```lean
criticalScheduler_not_neverStops ... :
  Not (NeverStops (ProvenancedTree.initial hp root) y)

exists_criticalTerminalShiftsNegative ... :
  exists n,
    CriticalTerminalShiftsNegative
      (run (ProvenancedTree.initial hp root) y n)
      (fun mode z => sourcePhiK mode z) y
```

No global all-segment context-admissibility hypothesis is reintroduced. The
previous k=5 counterexample remains valid and irrelevant to this route.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKAdvancedArrivalBoundedness
lake env lean CollatzClassical/KL2003/KL2003GeneralKAdvancedArrivalBoundednessAxiomAudit.lean
```

## Remaining work

Termination now returns a finite state whose critical terminal shifts are all
negative. The next semantic module must prove that this stopping condition,
together with the preserved critical node bounds and normalized-value
invariants, yields the source `SatisfiesEL` conclusion. Normal-form uniqueness
then remains before the k=3 `piStar` consumer can be assembled.

Classifications:

```text
ADVANCED_ARRIVAL_GLOBAL_BOUND_PROVED
UNIFORM_ADVANCED_GAP_PROVED
BOUNDED_SAME_TARGET_ADVANCED_PAIR_PROVED
UNIFORM_BOUNDED_RETURN_DROP_PROVED
NONNEGATIVE_ADVANCED_DOMINANT_BRANCH_EXCLUDED
CRITICAL_SCHEDULER_TERMINATION_PROVED
CRITICAL_TERMINAL_NEGATIVE_STATE_EXISTS
RECURRENT_SUBTREE_SELF_SIMILARITY_NOT_ASSUMED
GLOBAL_CONTEXT_ADMISSIBILITY_NOT_ASSUMED
CRITICAL_STOP_TO_SATISFIES_EL_NOT_YET_PROVED
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_FORMALISATION_NOT_AUTHORIZED
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
