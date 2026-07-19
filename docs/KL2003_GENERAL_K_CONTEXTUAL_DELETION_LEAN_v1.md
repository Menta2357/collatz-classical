# KL2003 general-k contextual deletion Lean v1

Date: 2026-07-19

## Scope

This note records the one-hole context semantics used to distinguish local
nonminimality from total noncriticality in the full EL tree. It proves that a
nonempty reduction which can only increase the value of its local minimum
preserves the whole-tree normal value whenever that occurrence is not
globally critical.

It does not yet prove that a source `DeletionWitness` implies total
noncriticality, preserve all frontier/node-bound data under that weaker
condition, or prove EL termination.

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

This is the source-strength value-preservation theorem: local minimum
preservation is not required when the target minimum occurrence is not
selected by any global critical route.

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
DELETION_WITNESS_IMPLIES_TOTAL_NONCRITICALITY
CONTEXTUAL_DELETION_FRONTIER_OR_NODE_BOUNDS_PRESERVATION
EL_TERMINATION
EL_ORDER_INDEPENDENCE_OR_CANONICAL_NORMALIZATION
SATISFIES_EL_OF_SATISFIES_IK
```

The first item is now the immediate semantic blocker. The source termination
argument remains separately blocked on its sign normalization and the
self-similar correspondence needed to make the shift decrement precise.

## Classification

```text
GENERAL_K_EL_CONTEXT_DEFINED
GENERAL_K_HOLE_CRITICALITY_DEFINED
GENERAL_K_CONTEXT_MONOTONICITY_PROVED
GENERAL_K_TOTAL_NONCRITICAL_CONTEXT_PRESERVATION_PROVED
GENERAL_K_MIN3_PATH_CONTEXT_EXTRACTION_PROVED
GENERAL_K_TOTAL_NONCRITICAL_REDUCEAT_VALUE_PRESERVATION_PROVED
GENERAL_K_EL_CONTEXT_AXIOM_AUDIT_PASS
DELETION_WITNESS_IMPLIES_TOTAL_NONCRITICALITY_NOT_YET_PROVED
EL_TERMINATION_NOT_YET_PROVED
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_FORMALISATION_NOT_AUTHORIZED
NO_GLOBAL_COLLATZ_CLAIM
```
