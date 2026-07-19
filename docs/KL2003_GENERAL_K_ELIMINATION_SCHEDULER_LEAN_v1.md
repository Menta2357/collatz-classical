# KL2003 general-k EL source scheduler in Lean v1

## Scope

This checkpoint formalizes one deterministic source-faithful EL scheduling
step. It locates the first terminal leaf whose symbolic shift is nonnegative,
expands it by the source D1/D2/D3 row, and immediately applies the syntactic
deletion rule to the new advanced minimum in the D1 and D3 cases.

The step is independent of `Phi`. It does not claim semantic preservation of
unconditional deletion, termination of the alternating expansion/deletion
process, order independence, an EL normal form, or `SatisfiesEL`.

## Implemented objects

- `ELTree.ExpandableOccurrence`: a terminal path paired with a proof that the
  target shift is nonnegative.
- `ELTree.findExpandableOccurrence`: deterministic left-to-right scheduling.
- `ELTree.TerminalShiftsNegative`: the exact syntactic stopping condition.
- `ExpandableOccurrence.split`: contextual source expansion via `splitAt`.
- `ExpandableOccurrence.d1Configuration` and `d3Configuration`: the newly
  introduced advanced minimum descended through the outer terminal path.
- `ExpandableOccurrence.sourceStep`: D1/D3 split plus maximal nonempty
  witness deletion, and exact D2 split without an advanced minimum.
- `ELTree.sourceScheduledStep`: identity at normal form, otherwise one source
  step at the first expandable occurrence.

## Proved guarantees

1. The tracked-mode residue is always one of `2`, `5`, or `8` modulo `9`.
2. Contextual source splitting preserves the complete frontier expression.
3. Under source class-root nonemptiness and `y >= 2`, splitting preserves
   `NodeBounds`; nonnegative target shift supplies the local row domain.
4. The D1, D2, and D3 branches of `sourceStep` are exposed by exact equations.
5. Every branch deleted in D1/D3 has a syntactic deletion witness.
6. `findExpandableOccurrence tree = none` exactly when every terminal shift
   in `tree` is negative.
7. The scheduled step is therefore the identity under that stopping
   condition.

## Remaining blocker

The source deletes witnessed leaves unconditionally, while the current
semantic theorem preserves `CriticalNodeBounds` for either a globally
critical target or the `Phi`-dependent actionable policy. The next theorem
must show that source witness deletion preserves equation (305) even when the
new minimum is not globally critical. This obligation must be proved; it must
not be introduced as an assumption or wrapper.

After that theorem, the full source process still needs termination and order
independence corresponding to KL2003 Theorem 3.1. The source sign
inconsistency recorded in the termination scoping note remains active.

## Verification

Direct source compilation is used because the volume has insufficient free
space for a full `lake build` that regenerates native mathlib artifacts:

```text
lake env lean CollatzClassical/KL2003/KL2003GeneralKEliminationScheduler.lean
lake env lean CollatzClassical/KL2003/KL2003GeneralKEliminationSchedulerAxiomAudit.lean
```

## Classification

```text
GENERAL_K_SOURCE_EXPANDABLE_OCCURRENCE_DEFINED
GENERAL_K_SOURCE_SCHEDULER_COMPLETE
GENERAL_K_TRACKED_MODE_MOD9_CASES_PROVED
GENERAL_K_CONTEXTUAL_SOURCE_SPLIT_FRONTIER_PRESERVED
GENERAL_K_CONTEXTUAL_SOURCE_SPLIT_NODE_BOUNDS_PRESERVED
GENERAL_K_D1_D3_SYNTACTIC_WITNESS_DELETION_CONSTRUCTED
GENERAL_K_SOURCE_STOPPING_CONDITION_CHARACTERIZED
SOURCE_UNCONDITIONAL_DELETION_CRITICAL_BOUNDS_PRESERVATION_NOT_YET_PROVED
GENERAL_K_FULL_EXPANSION_DELETION_TERMINATION_NOT_YET_PROVED
GENERAL_K_EL_NORMAL_FORM_UNIQUENESS_NOT_YET_PROVED
SATISFIES_EL_NOT_YET_PROVED
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_FORMALISATION_NOT_AUTHORIZED
NO_GLOBAL_COLLATZ_CLAIM
```
