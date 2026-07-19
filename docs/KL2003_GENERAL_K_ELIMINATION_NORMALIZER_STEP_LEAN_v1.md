# KL2003 general-k EL normalizer step in Lean v1

## Scope

This checkpoint formalizes deterministic localization and one canonical
context-sensitive deletion step for the general-k EL tree. It does not claim
iteration, termination, uniqueness, the EL semantic bridge, a k=3 piStar
theorem, or any k=9 result.

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

## Proved guarantees

For positive and monotone `Phi`, source `NodeBounds`, and nonnegative normal
arguments:

1. `normalizeOne` preserves the exact value of `normalExpr`.
2. Its result satisfies source-faithful equation-(305)
   `CriticalNodeBounds` at the root context.
3. A failed search is definitionally an identity step.

The result is not yet directly iterable. The current one-step theorem assumes
`NodeBounds`, while the result intentionally preserves the weaker and
source-faithful `CriticalNodeBounds`. The next proof obligation is therefore a
critical-bounds-input version of the contextual deletion theorem, not a new
search interface.

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
ITERATED_NORMALIZER_NOT_YET_PROVED
TERMINATION_NOT_YET_PROVED
SATISFIES_EL_NOT_YET_PROVED
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_FORMALISATION_NOT_AUTHORIZED
NO_GLOBAL_COLLATZ_CLAIM
```
