# KL2003 general-k elimination tree invariant Lean v1

Date: 2026-07-19

## Scope

This note records the internal principal-node tree and the verified node-bound
invariant used in the critical-assignment proof of KL2003 Theorem 3.2. It does
not claim deletion preservation, EL termination, or order independence.

## Lean files

```text
CollatzClassical/KL2003/KL2003GeneralKEliminationTree.lean
CollatzClassical/KL2003/KL2003GeneralKEliminationTreeAxiomAudit.lean
```

## Two expression projections

`ELTree k` has explicit terminal and expanded principal nodes, plus additive
and three-way minimum nodes. The two projections have different jobs:

```lean
ELTree.frontierExpr
ELTree.normalExpr
```

- `frontierExpr` forgets an expansion and retains the principal-node label;
- `normalExpr` recursively substitutes the body of every expanded node.

Using separate `terminal` and `expanded` constructors keeps the inductive type
non-nested and gives Lean a standard structural eliminator.

## Node bounds

`ELTree.NodeBounds Phi y` requires every expanded node body to satisfy its
local source-row inequality and recursively requires the same property below
it. Lean proves the global substitution inequality:

```lean
ELTree.normalExpr_eval_le_frontierExpr_eval
ELTree.expandedNode_normalExpr_eval_le_label
```

Consequently, every critical assignment below an expanded node is bounded by
that node's principal value:

```lean
ELTree.expandedNode_criticalAssignment_bound
```

This is the expression-level form of the source invariant (305).

## Source split instance

`ELTree.ofExpr` embeds an `ELExpr` as terminal principal nodes. Its frontier
and normal projections are both proved equal to the original expression, and
its recursive node bounds are immediate.

`ELTree.sourceSplitTree` attaches the already-proved parametric D1/D2/D3 split
to a principal node. The following theorems discharge its local and critical
assignment bounds from the source rows:

```lean
ELTree.sourceSplitTree_nodeBounds
ELTree.sourceSplitTree_criticalAssignment_bound
```

No prebuilt k=2 tree or Figure A1 data is an input.

## Expansion inside an existing tree

`ELTree.TerminalPath` locates a terminal principal node without identifying it
by a potentially non-unique label. `TerminalPath.splitAt` replaces exactly
that node by its parametric source split. Lean proves:

```lean
ELTree.TerminalPath.frontierExpr_splitAt
ELTree.TerminalPath.splitAt_nodeBounds
```

The first theorem says that expansion leaves the whole-tree frontier
unchanged. The second uses that fact to preserve every ancestor node bound
while introducing the new local source-row bound. Thus repeated splitting,
prior to deletion, preserves the equation-(305) invariant.

## Nonempty deletion semantics

The tree language now distinguishes `min2` from `min3`. A deletion result is
represented by `ELTree.Min3Retention`, whose seven constructors retain every
nonempty subset of three ordered branches. There is no constructor for an
empty minimum, and Lean proves `retainedCount_pos`.

At a fixed `Phi` and `y`, a branch is critical when its value is no larger
than both alternatives. Lean proves:

```lean
ELTree.Min3Retention.one_branch_critical
ELTree.Min3Retention.not_all_branches_noncritical
```

Thus the three branches cannot all be noncritical. The predicate
`DeletedBranchesNoncritical` requires every removed branch to be noncritical.
Under that condition, reducing the minimum preserves its exact value and
recursive node bounds:

```lean
ELTree.Min3Retention.reducedValue_eq_full
ELTree.Min3Retention.reduce_normalExpr_eval_eq
ELTree.Min3Retention.reduce_frontierExpr_eval_eq
ELTree.Min3Retention.reduce_nodeBounds
```

`ELTree.Min3Path` lifts the same operation through an arbitrarily nested tree.
Its reduction preserves the normal evaluation, frontier evaluation, and all
ancestor node bounds whenever the corresponding local noncriticality facts
hold.

This local condition is sufficient but stronger than the source deletion
criterion. KL2003 removes a vertex that is *totally* noncritical in the full
tree; such a vertex can still be a local minimizer inside a branch that no
global critical assignment selects.

The contextual value-preservation part is now proved in the separate module
recorded by `KL2003_GENERAL_K_CONTEXTUAL_DELETION_LEAN_v1.md`: a typed one-hole
context tracks criticality through every ancestor minimum, and replacing a
totally noncritical occurrence by a larger local value leaves the whole normal
evaluation unchanged. What remains source-specific is deriving that contextual
noncriticality from the existing deletion witness and preserving any frontier
or node-bound data needed by later iterations.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKEliminationTree
lake env lean CollatzClassical/KL2003/KL2003GeneralKEliminationTreeAxiomAudit.lean
git diff --check
```

The audit reports only the expected profile `[propext, Classical.choice,
Quot.sound]` (some structural projection equalities need only `propext`). No
`sorry`, `admit`, `unsafe`, or `native_decide` is used.

## Remaining Module 2 work

```text
DELETION_WITNESS_IMPLIES_TOTAL_NONCRITICALITY
CONTEXTUAL_DELETION_FRONTIER_OR_NODE_BOUNDS_PRESERVATION
EL_TERMINATION
EL_ORDER_INDEPENDENCE_OR_CANONICAL_NORMALIZATION
SATISFIES_EL_OF_SATISFIES_IK
```

## Classification

```text
GENERAL_K_EL_INTERNAL_TREE_DEFINED
GENERAL_K_EL_FRONTIER_NORMAL_PROJECTIONS_DEFINED
GENERAL_K_EL_NODE_BOUNDS_DEFINED
GENERAL_K_EL_NORMAL_LE_FRONTIER_PROVED
GENERAL_K_EL_EQUATION_305_CRITICAL_BOUND_PROVED
GENERAL_K_SOURCE_SPLIT_TREE_NODE_BOUNDS_PROVED
GENERAL_K_TREE_TERMINAL_PATH_DEFINED
GENERAL_K_TREE_SPLIT_PRESERVES_FRONTIER_PROVED
GENERAL_K_TREE_SPLIT_PRESERVES_NODE_BOUNDS_PROVED
GENERAL_K_MIN2_TREE_NODE_DEFINED
GENERAL_K_NONEMPTY_MIN3_RETENTION_DEFINED
GENERAL_K_MIN3_RETENTION_COUNT_POSITIVE_PROVED
GENERAL_K_NOT_ALL_MIN_BRANCHES_NONCRITICAL_PROVED
GENERAL_K_LOCAL_NONCRITICAL_DELETION_VALUE_PRESERVATION_PROVED
GENERAL_K_LOCAL_NONCRITICAL_DELETION_NODE_BOUNDS_PRESERVED
GENERAL_K_NESTED_MIN3_REDUCTION_DEFINED
GENERAL_K_EL_TREE_AXIOM_AUDIT_PASS
GENERAL_K_TOTAL_NONCRITICAL_CONTEXT_PRESERVATION_PROVED_IN_SEPARATE_MODULE
EL_DELETION_PRESERVATION_NOT_YET_PROVED
EL_TERMINATION_NOT_YET_PROVED
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_FORMALISATION_NOT_AUTHORIZED
NO_GLOBAL_COLLATZ_CLAIM
```
