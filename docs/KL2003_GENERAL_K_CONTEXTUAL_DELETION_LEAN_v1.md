# KL2003 general-k contextual deletion Lean v1

Date: 2026-07-19

## Scope

This note records the one-hole context semantics used to distinguish local
nonminimality from total noncriticality in the full EL tree. It proves that a
nonempty reduction which can only increase the value of its local minimum
preserves the whole-tree normal value whenever that occurrence is not
globally critical.

It also connects the source `DeletionWitness` to total noncriticality under
the explicit tree invariants used in equations (305)--(307). It does not yet
prove that the additive-companion invariant is preserved by every generated
tree, preserve all frontier/node-bound data under contextual deletion, or
prove EL termination.

## Lean files

```text
CollatzClassical/KL2003/KL2003GeneralKEliminationContext.lean
CollatzClassical/KL2003/KL2003GeneralKEliminationContextAxiomAudit.lean
```

## One-hole contexts

`ELTree.Context k` is a typed zipper for every tree constructor. The function
`Context.plug` reconstructs a complete tree from a context and a replacement
subtree.

`Context.HoleCritical tree Phi y` requires the hole occurrence to survive
every minimum between the hole and the root. Additive and expanded nodes do
not add a criticality condition; `min2` and `min3` nodes require the selected
subtree value to be no larger than every sibling.

Thus `not (context.HoleCritical tree Phi y)` expresses total noncriticality at
that occurrence. It does not assert that `tree` is locally nonminimal at its
nearest minimum.

## Context preservation

Lean proves monotonicity of plugging:

```lean
ELTree.Context.plug_normalExpr_eval_mono
```

If the replacement raises the local normal value, it cannot lower the normal
value of the complete tree. More importantly, if the original occurrence is
not globally critical, the complete value is unchanged:

```lean
ELTree.Context.plug_normalExpr_eval_eq_of_not_holeCritical
```

The proof is structural. At a minimum where the hole ceases to be critical,
the retained sibling value remains the minimum after the hole value rises.
The proof reuses the audited `Min3Retention.reducedValue_eq_full` API rather
than duplicating ad hoc minimum arithmetic.

## Integration with Min3Path

Every existing `ELTree.Min3Path` now determines:

```lean
ELTree.Min3Path.target
ELTree.Min3Path.context
```

Lean proves that plugging the target reconstructs the original tree and that
plugging a retained nonempty reduction reconstructs `reduceAt`. Every such
local reduction weakly raises the local normal value. Combining these facts
with contextual preservation gives:

```lean
ELTree.Min3Path.reduceAt_normalExpr_eval_eq_of_totallyNoncritical
```

This is a useful sufficient value-preservation theorem. The source deletion
step is branch-level rather than parent-minimum-level, so the module also
defines three composed branch contexts and proves the exact theorem:

```lean
ELTree.Min3Path.reduceAt_normalExpr_eval_eq_of_deletedBranchesTotallyNoncritical
```

It requires every removed branch, not the parent minimum, to be globally
noncritical. If the parent itself is noncritical, any nonempty retention is
safe; otherwise branch-global noncriticality reduces to the existing local
`DeletedBranchesNoncritical` condition.

## Critical paths and deletion witnesses

`Context.lift_criticalPath` constructs a genuine global critical assignment
and path from a critical hole occurrence. Its companion-strengthened variant
also proves that an additive node encountered by the context contributes a
nonempty companion list.

`TerminalPath.context` ties a concrete terminal occurrence to its one-hole
context. The expanded labels on this context are exactly the principal
ancestors used to form `TerminalPath.leafState` and its source
`HasDeletionWitness`.

The structural predicate `TerminalPath.AddBelowEveryExpanded` records the
strict-positive sibling required by the source proof: below every expanded
ancestor on the candidate route, an additive node remains. Under this
predicate, recursive node bounds, nonnegative arguments, positivity, and
monotonicity, Lean proves:

```lean
ELTree.TerminalPath.deletionWitness_implies_not_holeCritical
```

The proof selects the witness ancestor, constructs the critical assignment
below that expanded node, obtains a nonempty additive companion, applies the
equation-(305) node bound, and invokes the already-audited strict
monotonicity contradiction. This is the formal equation-(305)--(307) bridge.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKEliminationContext
lake env lean CollatzClassical/KL2003/KL2003GeneralKEliminationContextAxiomAudit.lean
git diff --check
```

The audit reports only `[propext, Classical.choice, Quot.sound]`. No `sorry`,
`admit`, `unsafe`, or `native_decide` is used.

## Remaining Module 2 work

```text
SOURCE_SPLITTING_PRESERVES_ADD_BELOW_EVERY_EXPANDED
TERMINAL_BRANCH_WITNESSES_ASSEMBLED_INTO_MIN3_RETENTION
CONTEXTUAL_DELETION_FRONTIER_OR_NODE_BOUNDS_PRESERVATION
EL_TERMINATION
EL_ORDER_INDEPENDENCE_OR_CANONICAL_NORMALIZATION
SATISFIES_EL_OF_SATISFIES_IK
```

The first two items are now the immediate semantic assembly blockers. The
source termination argument remains separately blocked on its sign
normalization and the self-similar correspondence needed to make the shift
decrement precise.

## Classification

```text
GENERAL_K_EL_CONTEXT_DEFINED
GENERAL_K_HOLE_CRITICALITY_DEFINED
GENERAL_K_CONTEXT_MONOTONICITY_PROVED
GENERAL_K_TOTAL_NONCRITICAL_CONTEXT_PRESERVATION_PROVED
GENERAL_K_MIN3_PATH_CONTEXT_EXTRACTION_PROVED
GENERAL_K_TOTAL_NONCRITICAL_REDUCEAT_VALUE_PRESERVATION_PROVED
GENERAL_K_BRANCH_CONTEXTS_DEFINED
GENERAL_K_DELETED_BRANCHES_TOTAL_NONCRITICAL_PRESERVATION_PROVED
GENERAL_K_CONTEXT_CRITICAL_PATH_LIFT_PROVED
GENERAL_K_TERMINAL_PATH_CONTEXT_DEFINED
DELETION_WITNESS_IMPLIES_TOTAL_NONCRITICALITY_UNDER_TREE_INVARIANTS_PROVED
GENERAL_K_EL_CONTEXT_AXIOM_AUDIT_PASS
SOURCE_SPLITTING_ADD_COMPANION_INVARIANT_NOT_YET_PROVED
EL_TERMINATION_NOT_YET_PROVED
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_FORMALISATION_NOT_AUTHORIZED
NO_GLOBAL_COLLATZ_CLAIM
```
