# KL2003 general-k provenanced scheduler Lean v1

Date: 2026-07-20

## Scope

This module lifts the existing deterministic source scheduler to
`ProvenancedTree` while proving exact simulation after genealogy is forgotten:

```text
CollatzClassical/KL2003/KL2003GeneralKProvenancedScheduler.lean
```

It does not yet prove scheduler termination or extract an infinite surviving
branch from hypothetical nontermination.

## Contextual retention

For D1 and D3, the raw scheduler chooses `witnessRetention` from the full
outer-tree context. The provenanced scheduler reuses that exact decision and
applies it only to the newly introduced advanced `min3`. Retained branches
keep their existing typed source walks unchanged.

The dependent transport used by `sourceD1AdvancedConfigurationData` and
`sourceD3AdvancedConfigurationData` is isolated by:

```text
advancedConfiguration_reduceAt_transport
```

Transporting an `AdvancedMinConfiguration` across equal trees does not change
the nondependent tree returned by `minPath.reduceAt`. This yields exact D1/D3
equalities between the existing source configurations and canonical locally
reduced split trees.

## Outer path replacement

The module defines raw and provenanced terminal replacement. It proves:

1. replacing a raw terminal by `sourceSplitTree` is `splitAt`;
2. reducing a `min3` after `descendSplitMin3` equals replacing the selected
   terminal by the locally reduced split;
3. forgetting provenanced replacement equals raw replacement.

These lemmas separate the global retention decision from its local structural
effect without changing scheduler semantics.

## Exact scheduler simulation

`ProvenancedTree.ExpandableOccurrence` stores the selected provenanced label,
its annotated path, and shift nonnegativity. Its `sourceStep` handles:

```text
D1 -> global witnessRetention + local annotated D1 reduction
D2 -> annotated splitAt
D3 -> global witnessRetention + local annotated D3 reduction
```

Lean proves:

```text
ExpandableOccurrence.sourceStep_forget
```

The provenanced finder then mirrors the raw left-to-right traversal through
all five tree constructors. `findExpandableOccurrence_forget` relates every
`none` or `some` result to `ELTree.findExpandableOccurrence`. Consequently:

```text
sourceScheduledStep_forget :
  (sourceScheduledStep tree).forget =
    ELTree.sourceScheduledStep hp tree.forget
```

The raw scheduler is unchanged; genealogy is a conservative instrumented
lift.

## Verification

```text
lake env lean -o \
  .lake/build/lib/lean/CollatzClassical/KL2003/KL2003GeneralKProvenancedScheduler.olean \
  -i .lake/build/lib/lean/CollatzClassical/KL2003/KL2003GeneralKProvenancedScheduler.ilean \
  CollatzClassical/KL2003/KL2003GeneralKProvenancedScheduler.lean

lake env lean \
  CollatzClassical/KL2003/KL2003GeneralKProvenancedSchedulerAxiomAudit.lean
```

The audited declarations have the expected foundational profile:

```text
[propext, Classical.choice, Quot.sound]
```

No `sorry`, `admit`, `axiom`, `unsafe`, or `native_decide` occurs in the new
Lean files.

## Remaining extraction target

The scheduler can now be iterated on the annotated initial tree with exact raw
simulation. The remaining genealogy argument must:

1. define finite and infinite annotated executions;
2. show hypothetical nontermination creates terminals of unbounded source-walk
   length;
3. use finite action branching to extract one infinite prefix-compatible
   source path;
4. prove every finite factor on that path is context-admissible from deletion
   survival;
5. prove its selected terminal shifts nonnegative;
6. invoke `not_shiftsNonnegative_of_allSegmentsContextAdmissible`.

## Classification

```text
PROVENANCED_CONTEXTUAL_RETENTION_DEFINED
ADVANCED_CONFIGURATION_TRANSPORT_ISOLATED
D1_D3_LOCAL_REDUCTION_FORGET_PROVED
RAW_AND_PROVENANCED_TERMINAL_REPLACEMENT_PROVED
DESCENDED_MIN3_REDUCTION_REPLACEMENT_EQUIVALENCE_PROVED
PROVENANCED_EXPANDABLE_OCCURRENCE_DEFINED
PROVENANCED_SOURCE_STEP_FORGET_PROVED
PROVENANCED_LEFT_TO_RIGHT_FINDER_DEFINED
PROVENANCED_FINDER_FORGET_PROVED
PROVENANCED_SOURCE_SCHEDULER_STEP_FORGET_PROVED
RAW_SOURCE_SCHEDULER_UNCHANGED
INFINITE_EXECUTION_NOT_YET_DEFINED
SURVIVING_BRANCH_EXTRACTION_NOT_YET_PROVED
EL_TERMINATION_NOT_YET_PROVED
NO_K3_PISTAR_THEOREM_CLAIM
NO_K9_FORMALISATION_AUTHORIZATION
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
