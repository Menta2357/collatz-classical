# KL2003 general-k source genealogy Lean v1

Date: 2026-07-20

## Scope

This module begins the genealogy-aware lift of the existing deterministic EL
scheduler. It is implemented in:

```text
CollatzClassical/KL2003/KL2003GeneralKSourceGenealogy.lean
```

It proves the provenance and path-replacement foundation only. It does not yet
lift the scheduler's witness-retention choice, define an infinite execution,
extract a surviving branch, or prove full EL termination.

## Provenanced labels

`ProvenancedLabel hp root` stores:

```text
label    : ELLabel (p + 1)
walk     : SourceWalk hp root.mode label.mode
shift_eq : label.shift = root.shift + walk.weight
```

The root uses the empty source walk. Extending a label by any valid
`SourceAction` appends one concrete typed edge. Lean proves exact increment of
walk length and symbolic weight. Thus generated terminal labels carry a
kernel-checked source genealogy rather than an untyped list of modes.

## Provenanced trees and paths

`ProvenancedTree hp root` mirrors all five constructors of `ELTree`. Its
`forget` map removes only provenance. Min-three retention is lifted without
altering any retained label or walk, and forgetting that reduction is exactly
`ELTree.Min3Retention.reduce`.

`sourceSplit` constructs D1, D2, or D3 from the source mode and attaches the
corresponding retarded or advanced `SourceAction` to every child. The central
compatibility theorem is:

```text
sourceSplit_forget :
  (sourceSplit node).forget = ELTree.sourceSplitTree hp node.label
```

The module also mirrors `ELTree.TerminalPath`. Provenanced `splitAt` replaces
the selected terminal with `sourceSplit`, while `forgetPath` recovers the raw
path. Structural induction proves:

```text
forget_splitAt :
  path.splitAt.forget = (path.forgetPath).splitAt hp
```

## Why chronology is insufficient

Successive calls of `findExpandableOccurrence` can select terminals in
different branches. Their labels therefore do not form a typed
`SourceAction` chain. The future extraction must follow provenanced
parent-child genealogy through retained branches. This module provides the
typed data required for that construction without changing the existing raw
scheduler.

## Verification

```text
lake env lean -o \
  .lake/build/lib/lean/CollatzClassical/KL2003/KL2003GeneralKSourceGenealogy.olean \
  -i .lake/build/lib/lean/CollatzClassical/KL2003/KL2003GeneralKSourceGenealogy.ilean \
  CollatzClassical/KL2003/KL2003GeneralKSourceGenealogy.lean

lake env lean \
  CollatzClassical/KL2003/KL2003GeneralKSourceGenealogyAxiomAudit.lean
```

The expected audit profile is:

```text
[propext, Classical.choice, Quot.sound]
```

No `sorry`, `admit`, `axiom`, `unsafe`, or `native_decide` occurs in the new
Lean files.

## Next target

The next layer must lift `ExpandableOccurrence.sourceStep` itself. It will:

1. compute the same raw witness retention as the existing scheduler;
2. apply it to the corresponding annotated advanced min;
3. prove exact simulation after `forget`;
4. preserve a genealogy invariant linking expanded ancestors to source-walk
   prefixes;
5. expose retained children for the later finite-branching extraction.

## Classification

```text
SOURCE_PROVENANCED_LABEL_DEFINED
ROOT_EMPTY_GENEALOGY_PROVED
SOURCE_ACTION_CHILD_GENEALOGY_PROVED
PROVENANCED_EL_TREE_DEFINED
PROVENANCE_FORGET_MAP_DEFINED
PROVENANCED_MIN3_RETENTION_FORGET_PROVED
PROVENANCED_SOURCE_SPLIT_FORGET_PROVED
PROVENANCED_TERMINAL_PATH_DEFINED
PROVENANCED_SPLIT_AT_FORGET_PROVED
FULL_SCHEDULER_SIMULATION_NOT_YET_PROVED
SURVIVING_BRANCH_EXTRACTION_NOT_YET_PROVED
EL_TERMINATION_NOT_YET_PROVED
NO_K3_PISTAR_THEOREM_CLAIM
NO_K9_FORMALISATION_AUTHORIZATION
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
