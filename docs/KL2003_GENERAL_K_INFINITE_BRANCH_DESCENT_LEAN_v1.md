# KL2003 general-k infinite-branch descent Lean v1

Date: 2026-07-20

## Scope

This note records the scheduler-independent arithmetic consumer for a future
surviving-branch extraction. The implementation is in:

```text
CollatzClassical/KL2003/KL2003GeneralKInfiniteBranchDescent.lean
```

It does not construct an infinite branch from scheduler nontermination. It
proves that once such a coherent typed branch is available and every finite
segment is context-admissible, its accumulated shifts cannot remain
nonnegative forever.

## Structural object

`InfiniteSourceWalk hp` contains only the data of a coherent infinite path in
the finite source-transition graph:

```text
modes       : Nat -> TrackedMode (p + 1)
actions     : forall n, SourceAction (modes n)
target_next : (actions n).target hp = modes (n + 1)
```

Context admissibility and shift nonnegativity are separate predicates. They
are not fields or assumed hooks in the structural object.

Finite typed segments are constructed with an explicit endpoint transport.
The transport preserves length, weight, and `ContextAdmissible`. A separate
nondependent recursion `segmentWeightEval` records the evaluated prefix
weight and avoids dependent endpoint casts in the additive arithmetic.

## Proved consumer

For every coherent infinite source branch:

1. Segment length is exactly the requested natural length.
2. Segment evaluated weight equals `segmentWeightEval`.
3. Prefix accumulation is additive.
4. Every repeated-mode interval closes to a nonempty context-admissible walk.
5. `exists_uniform_admissible_return_drop` supplies one positive epsilon for
   all such repeated-mode intervals.
6. The resulting sequence satisfies `HasUniformRecurrentDrop`.
7. The existing finite-mode recurrence contradiction proves that all shifts
   cannot remain nonnegative.

The final theorem is:

```text
not_shiftsNonnegative_of_allSegmentsContextAdmissible
```

No scheduler semantics occur in this proof.

## Verification

```text
lake env lean -o \
  .lake/build/lib/lean/CollatzClassical/KL2003/KL2003GeneralKInfiniteBranchDescent.olean \
  -i .lake/build/lib/lean/CollatzClassical/KL2003/KL2003GeneralKInfiniteBranchDescent.ilean \
  CollatzClassical/KL2003/KL2003GeneralKInfiniteBranchDescent.lean

lake env lean \
  CollatzClassical/KL2003/KL2003GeneralKInfiniteBranchDescentAxiomAudit.lean
```

The audited declarations depend only on the expected foundational profile:

```text
[propext, Classical.choice, Quot.sound]
```

No `sorry`, `admit`, `axiom`, `unsafe`, or `native_decide` occurs in the new
Lean files.

## Remaining scheduler target

The remaining termination task is now isolated to a genealogy extraction:

1. From hypothetical nontermination of `sourceScheduledStep`, construct an
   infinite surviving branch rather than the chronological list of globally
   selected terminals.
2. Read the coherent `SourceAction` chain along that branch.
3. Prove every finite branch segment context-admissible from contextual
   deletion and survival.
4. Prove the branch shifts nonnegative from terminal eligibility.
5. Apply the final contradiction in this module.

The chronological scheduler selections are not themselves a typed path:
successive selected terminals can lie in different branches. Any valid
extraction must therefore use genealogy and finite branching, not temporal
adjacency.

## Classification

```text
INFINITE_SOURCE_WALK_DEFINED
FINITE_TYPED_BRANCH_SEGMENTS_PROVED
DEPENDENT_ENDPOINT_TRANSPORT_ISOLATED
SEGMENT_WEIGHT_ADDITIVITY_PROVED
REPEATED_MODE_SEGMENT_CLOSURE_PROVED
UNIFORM_RECURRENT_DROP_FROM_CONTEXT_ADMISSIBILITY_PROVED
INFINITE_NONNEGATIVE_CONTEXT_ADMISSIBLE_BRANCH_EXCLUDED
SCHEDULER_CHRONOLOGICAL_SELECTION_NOT_ASSUMED_TO_BE_A_PATH
SURVIVING_BRANCH_GENEALOGY_EXTRACTION_NOT_YET_PROVED
EL_TERMINATION_NOT_YET_PROVED
EL_ORDER_INDEPENDENCE_NOT_YET_PROVED
NO_K3_PISTAR_THEOREM_CLAIM
NO_K9_FORMALISATION_AUTHORIZATION
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
