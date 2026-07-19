# KL2003 general-k EL normalizer step in Lean v1

## Scope

This checkpoint formalizes deterministic localization, one canonical
context-sensitive deletion step, and a terminating deletion normalizer for a
finite, already-expanded general-k EL tree. It does not claim termination of
the alternating source expansion/deletion process, uniqueness of the full EL
normal form, the EL semantic bridge, a k=3 piStar theorem, or any k=9 result.

## Implemented objects

- `ELTree.AdvancedOccurrence`: a typed zipper locating an exact advanced
  split anywhere in an `ELTree`.
- `ELTree.findAdvancedOccurrence`: deterministic left-to-right localization.
- Generic lifting of `Min3Path`, `TerminalPath`, and
  `AdvancedMinConfiguration` through an arbitrary one-hole context.
- `AdvancedOccurrence.configuration`: construction of the semantic
  configuration consumed by the previously audited contextual-retention
  policy.
- `ELTree.normalizeOne`: one canonical normalization step, or identity when
  no advanced occurrence exists.
- `AdvancedOccurrence.Actionable`: the target minimum is globally critical
  and has at least one deletion witness.
- `ELTree.normalizeActionable`: recursively deletes actionable occurrences
  until none remain.

## Proved guarantees

For positive and monotone `Phi`, source `NodeBounds`, and nonnegative normal
arguments:

1. `normalizeOne` preserves the exact value of `normalExpr`.
2. Its result satisfies source-faithful equation-(305)
   `CriticalNodeBounds` at the root context.
3. A failed search is definitionally an identity step.
4. The source-faithful `CriticalNodeBounds` invariant can itself be consumed
   by the next step; `NodeBounds` is required only to initialize it.
5. Deletion preserves argument nonnegativity.
6. Every actionable step strictly decreases `ELTree.nodeCount`.
7. The finite-tree normalizer terminates, preserves exact value and critical
   bounds, and returns a tree with no actionable occurrence.

This is a deletion normalizer, not yet the full source EL normalizer. It does
not expand remaining terminal leaves. The next proof obligation is an
expansion scheduler coupled to deletion normalization, followed by the
general-k termination/normal-form theorem corresponding to KL2003 Theorem
3.1. The source sign inconsistency recorded separately remains relevant to
that larger termination claim.

## Verification

The module and axiom audit are checked by direct source compilation because a
full `lake build` would regenerate large native mathlib artifacts while the
volume has limited free space:

```text
lake env lean CollatzClassical/KL2003/KL2003GeneralKEliminationNormalizer.lean
lake env lean CollatzClassical/KL2003/KL2003GeneralKEliminationNormalizerAxiomAudit.lean
```

Expected audit profile: `[propext, Classical.choice, Quot.sound]`.

## Classification

```text
GENERAL_K_ADVANCED_OCCURRENCE_LOCATOR_PROVED
GENERAL_K_CONTEXT_PATH_LIFTING_PROVED
GENERAL_K_OCCURRENCE_CONFIGURATION_CONSTRUCTED
GENERAL_K_NORMALIZE_ONE_VALUE_PRESERVATION_PROVED
GENERAL_K_NORMALIZE_ONE_CRITICAL_BOUNDS_PROVED
GENERAL_K_CRITICAL_BOUNDS_INPUT_STEP_PROVED
GENERAL_K_ACTIONABLE_DELETION_NORMALIZER_TERMINATES
GENERAL_K_FINITE_TREE_NORMALIZER_VALUE_PRESERVATION_PROVED
GENERAL_K_FINITE_TREE_NORMALIZER_CRITICAL_BOUNDS_PROVED
GENERAL_K_FULL_EXPANSION_DELETION_TERMINATION_NOT_YET_PROVED
GENERAL_K_EL_NORMAL_FORM_UNIQUENESS_NOT_YET_PROVED
SATISFIES_EL_NOT_YET_PROVED
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_FORMALISATION_NOT_AUTHORIZED
NO_GLOBAL_COLLATZ_CLAIM
```
