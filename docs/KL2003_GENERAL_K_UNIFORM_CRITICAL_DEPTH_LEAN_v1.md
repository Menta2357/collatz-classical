# KL2003 general-k uniform critical depth in Lean

Date: 2026-07-20

## Scope

This module strengthens pointwise critical-scheduler termination to one
source-genealogy depth bound that is uniform over every tracked root mode and
every real argument `y >= 2`. It does so without constructing or assuming a
canonical EL normal form.

`UniformSelectedCodeWitness` records a packed source-action prefix together
with the exact root mode, real argument, finite run index, selected critical
occurrence, finder equality, and prefix proof from which it came. The union of
these prefixes remains finite at each exact depth. If selected depths were
unbounded, the inverse-system form of Konig's lemma would choose one coherent
prefix at every depth.

The extracted infinite source walk has two inherited properties:

- every accumulated shift is nonnegative, because every coherent prefix is a
  prefix of a genuinely selected nonnegative terminal in a finite run; and
- advanced arrivals are nonincreasing, because the intrinsic
  `AllLabelsAdvancedDominance` invariant is now proved for arbitrary finite
  critical runs, not only under a fixed `NeverStops` hypothesis.

`nonnegative_branch_impossible_of_advancedArrivalsNonincreasing` contradicts
this branch. The public theorem is therefore:

```lean
exists_uniform_criticalSelectedDepthBound
    (roots : GeneralKClassRootsNonempty (p + 1)) :
    exists bound : Nat, CriticalSelectedDepthBound hp bound
```

## Boundary

The theorem bounds the source-walk length of every terminal selected for
expansion by the critical finder. It does not yet state `ShiftsWithin mu nu`
for the leaves of a stopped critical assignment. The next bridge must prove
that all terminal leaves in a finite run lie at depth at most `bound + 1`, then
take the positive minimum of the finitely many negative symbolic shifts at
those bounded depths. This is a finite extraction problem, not a remaining
normal-form or scheduler-termination problem.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKUniformCriticalDepth
lake env lean CollatzClassical/KL2003/KL2003GeneralKUniformCriticalDepthAxiomAudit.lean
```

Classifications:

```text
FINITE_RUN_ADVANCED_DOMINANCE_PROVED
UNIFORM_SELECTED_PREFIX_INVERSE_SYSTEM_CONSTRUCTED
UNBOUNDED_SELECTED_DEPTH_INFINITE_BRANCH_EXTRACTED
UNIFORM_CRITICAL_SELECTED_DEPTH_BOUND_PROVED
CANONICAL_EL_NORMAL_FORM_NOT_ASSUMED
UNIFORM_RETARDED_SHIFT_WINDOW_NOT_YET_PROVED
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_FORMALISATION_NOT_AUTHORIZED
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
