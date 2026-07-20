# KL2003 general-k provenanced scheduler depth (Lean v1)

## Scope

This module proves that a provenanced source scheduler which never stops must
select source genealogies of arbitrarily large finite length. It does not yet
extract one coherent infinite branch from those finite walks.

## Fuel argument

For a fixed depth bound `B`, a terminal at genealogy depth `d <= B` receives
the capacity of a full quaternary tree of remaining height `B - d`:

```text
C(0) = 1
C(n + 1) = 1 + 4 * C(n)
```

Every D1/D3 expansion retains at most four children in total (one retarded
child plus at most three advanced children), while D2 retains one child. Every
child has genealogy depth exactly one greater than its parent. Consequently,
expanding a selected terminal of depth at most `B` strictly decreases the sum
of terminal capacities. Terminal replacement transports this strict decrease
through every surrounding `expanded`, `add`, `min2`, and `min3` context.

## Main theorem

```lean
exists_selectedOccurrence_walk_length_gt
    (hne : NeverStops initial) (bound : Nat) :
    exists n, bound < (selectedOccurrence hne n).target.walk.length
```

The proof avoids a prefix-free invariant: an infinite strictly descending
sequence of natural-valued fuels is impossible. This is sufficient for
unbounded finite genealogy depth and leaves compactness/Konig extraction as a
separate consumer.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKProvenancedSchedulerDepth
lake env lean CollatzClassical/KL2003/KL2003GeneralKProvenancedSchedulerDepthAxiomAudit.lean
```

Expected audit profile: `[propext, Classical.choice, Quot.sound]`.

## Classification

```text
PROVENANCED_SCHEDULER_BOUNDED_DEPTH_FUEL_DEFINED
SOURCE_STEP_STRICTLY_DECREASES_BOUNDED_DEPTH_FUEL
NEVER_STOPS_IMPLIES_UNBOUNDED_SELECTED_GENEALOGY_DEPTH
INFINITE_BRANCH_NOT_YET_EXTRACTED
SEGMENT_ADMISSIBILITY_NOT_YET_CONNECTED
NO_K3_PISTAR_THEOREM
NO_K9_FORMALISATION
NO_GLOBAL_COLLATZ_CLAIM
```
