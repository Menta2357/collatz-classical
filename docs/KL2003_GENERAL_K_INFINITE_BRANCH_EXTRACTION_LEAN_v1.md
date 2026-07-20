# KL2003 general-k infinite branch extraction (Lean v1)

## Scope

This module converts unbounded selected scheduler genealogies into one coherent
typed infinite source branch. It is the compactness layer between the
quaternary fuel proof and the arithmetic descent consumer.

## Construction

For every depth `n`, `SelectedCodeAtDepth hne n` consists of packed source
action lists of exact length `n` which prefix some actual selected scheduler
provenance. Unbounded genealogy depth makes every such level nonempty, while
the finite packed action alphabet makes every level finite.

The inverse-system form of Konig's lemma supplies a coherent family whose
projection from level `j` to `i` is exactly `List.take i`. The new action
between levels `n` and `n+1` defines an infinite packed stream.

`PackedChainCoherent` records that every packed action targets the source mode
of its successor. It holds for every typed `SourceWalk`, descends to prefixes,
and therefore converts the stream into:

```lean
extractedInfiniteSourceWalk (hne : NeverStops initial) :
  InfiniteSourceWalk hp
```

## Acceptance theorems

```lean
coherentPackedStream_take
coherentPackedStream_adjacent
extractedInfiniteSourceWalk_segment_code
extractedInfiniteSourceWalk_prefix_isSelected
```

Thus every initial branch segment serializes exactly to a real selected code
prefix. The next layer must use scheduler invariants to prove contextual
admissibility of all segments and nonnegativity of all accumulated shifts.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKInfiniteBranchExtraction
lake env lean CollatzClassical/KL2003/KL2003GeneralKInfiniteBranchExtractionAxiomAudit.lean
```

Expected audit profile: `[propext, Classical.choice, Quot.sound]`.

## Classification

```text
KONIG_INVERSE_SYSTEM_APPLIED
COHERENT_SELECTED_PREFIX_FAMILY_PROVED
INFINITE_TYPED_SOURCE_BRANCH_EXTRACTED
FINITE_SEGMENT_CODE_EXACT
SELECTED_PREFIX_REALIZATION_PROVED
SEGMENT_ADMISSIBILITY_NOT_YET_CONNECTED
BRANCH_SHIFT_NONNEGATIVITY_NOT_YET_CONNECTED
NO_K3_PISTAR_THEOREM
NO_K9_FORMALISATION
NO_GLOBAL_COLLATZ_CLAIM
```
