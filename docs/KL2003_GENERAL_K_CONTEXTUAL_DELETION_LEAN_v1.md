# KL2003 general-k contextual deletion Lean v1

Date: 2026-07-19

## Scope

This note records the one-hole context semantics used to distinguish local
nonminimality from total noncriticality in the full EL tree. It proves that a
nonempty reduction which can only increase the value of its local minimum
preserves the whole-tree normal value whenever that occurrence is not
globally critical.

It also connects the source `DeletionWitness` to total noncriticality under
the explicit tree invariants used in equations (305)--(307). The source D1
and D3 advanced triples now carry the required additive-companion invariant,
and that invariant is preserved when the split is inserted along an existing
terminal path. A canonical nonempty retention is now selected directly from
the three deletion-witness propositions, and its `reduceAt` step preserves the
normal value exactly. The module does not yet locate and iterate these local
steps throughout an arbitrary tree, preserve all frontier/node-bound data
under contextual deletion, or prove EL termination.

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

## Source advanced configurations and retention assembly

The D1 and D3 source split shapes are identified definitionally with an
expanded root whose advanced child is a three-way minimum. Lean constructs
the three terminal paths and their shared `Min3Path` as one proved bundle:

```lean
ELTree.TerminalPath.sourceD1AdvancedConfiguration
ELTree.TerminalPath.sourceD3AdvancedConfiguration
```

Each advanced path contains an additive node below every expanded ancestor.
`AdvancedMinConfiguration.descendSplit` transports the complete bundle when
the source split is inserted at an arbitrary outer terminal occurrence;
context composition preserves both `ContainsAdd` and
`AddBelowEveryExpanded`.

For a chosen nonempty `Min3Retention`,
`AdvancedMinConfiguration.DeletedBranchesHaveWitness` states exactly the
witness obligations for the removed branches. Those obligations now imply
branch-global noncriticality and exact preservation of the complete normal
evaluation:

```lean
ELTree.TerminalPath.AdvancedMinConfiguration.deletedBranchesTotallyNoncritical_of_witnesses
ELTree.TerminalPath.AdvancedMinConfiguration.reduceAt_normalExpr_eval_eq_of_witnesses
```

This is an assembly theorem for a supplied retention. It does not yet derive
which retention the full deletion algorithm selects or prove that later
iterations preserve every frontier and node-bound invariant.

The module now also constructs that local retention canonically:

```lean
ELTree.TerminalPath.AdvancedMinConfiguration.witnessRetention
ELTree.TerminalPath.AdvancedMinConfiguration.witnessRetention_deletedBranchesHaveWitness
ELTree.TerminalPath.AdvancedMinConfiguration.witnessRetention_retainedCount
ELTree.TerminalPath.AdvancedMinConfiguration.witnessRetention_reduceAt_normalExpr_eval_eq
```

The policy deletes every witnessed branch subject to the source requirement
that a new minimum retain at least one child. Its cardinality theorem is

```text
retainedCount = 3 - min 2 witnessCount
```

and the branch specification proves that every removed child carries its
actual path witness. This closes the local retention decision and its semantic
consumer. It is not yet an iterated normalizer: selecting the next advanced
leaf/minimum, preserving the global iteration invariants, and proving that the
process halts remain separate work.

## Contextual equation-(305) invariant

Universal `NodeBounds` is stronger than the source invariant after deletion:
KL2003 only requires equation (305) at an internal principal node when a
critical path actually passes through that occurrence. The module therefore
defines

```lean
ELTree.Context.CriticalNodeBounds
ELTree.CriticalNodeBounds
```

recursively with the exact one-hole context of every expanded node. At an
expanded node the label bound is conditional on that occurrence being
`HoleCritical`; descendants are checked in their composed global contexts.
Lean proves that the existing universal invariant implies this source-faithful
one and that every initial source split satisfies it:

```lean
ELTree.Context.criticalNodeBounds_of_nodeBounds
ELTree.sourceSplitTree_criticalNodeBounds
```

Finally, `ELTree.Context.criticalAssignment_bound` converts the contextual
node condition into the selected-leaf sum bound for any critical assignment,
which is the formal interface corresponding to equation (305). Preservation
of this weaker invariant by canonical witness deletion is the next required
iteration theorem; it is not claimed here.

The supporting congruence layer is also proved. Equal local normal values
remain equal after plugging into any context, and preserve `HoleCritical`:

```lean
ELTree.Context.plug_normalExpr_eval_eq
ELTree.Context.holeCritical_congr
```

`CriticalityEquivalentBelow` packages equivalence for every deeper
subcontext, and `criticalNodeBounds_congr` transports the complete contextual
invariant across such equivalent zippers. Consequently, the remaining
preservation proof is localized: for each child retained by the canonical
policy, show that its post-deletion branch context cannot create a new
critical route relative to the original three-way minimum.

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
ITERATED_DELETION_NORMALIZER_LOCATES_AND_APPLIES_LOCAL_STEPS
CONTEXTUAL_CRITICAL_NODE_BOUNDS_PRESERVED_BY_DELETION
EL_TERMINATION
EL_ORDER_INDEPENDENCE_OR_CANONICAL_NORMALIZATION
SATISFIES_EL_OF_SATISFIES_IK
```

The first item is now the immediate semantic assembly blocker: each advanced
configuration has a canonical sound local step, but the normalization process
must locate and iterate those steps over the complete tree. The source
termination argument remains separately blocked on its sign normalization and
the self-similar correspondence needed to make the shift decrement precise.

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
GENERAL_K_D1_D3_ADVANCED_CONFIGURATIONS_PROVED
GENERAL_K_SOURCE_SPLIT_ADD_COMPANION_INVARIANT_PROVED
GENERAL_K_ADVANCED_CONFIGURATION_DESCENT_PROVED
GENERAL_K_WITNESS_RETENTION_ASSEMBLY_PROVED
GENERAL_K_WITNESS_BASED_REDUCEAT_VALUE_PRESERVATION_PROVED
GENERAL_K_CANONICAL_WITNESS_RETENTION_DEFINED
GENERAL_K_WITNESS_RETENTION_MAXIMAL_NONEMPTY_PROVED
GENERAL_K_CANONICAL_WITNESS_RETENTION_VALUE_PRESERVATION_PROVED
GENERAL_K_CONTEXTUAL_CRITICAL_NODE_BOUNDS_DEFINED
GENERAL_K_NODE_BOUNDS_IMPLIES_CRITICAL_NODE_BOUNDS
GENERAL_K_SOURCE_SPLIT_CRITICAL_NODE_BOUNDS_PROVED
GENERAL_K_EQUATION_305_CRITICAL_ASSIGNMENT_INTERFACE_PROVED
GENERAL_K_CONTEXT_NORMAL_VALUE_CONGRUENCE_PROVED
GENERAL_K_HOLE_CRITICALITY_CONGRUENCE_PROVED
GENERAL_K_CRITICAL_NODE_BOUNDS_CONTEXT_TRANSPORT_PROVED
GENERAL_K_EL_CONTEXT_AXIOM_AUDIT_PASS
ITERATED_DELETION_NORMALIZER_NOT_YET_PROVED
CRITICAL_NODE_BOUNDS_DELETION_PRESERVATION_NOT_YET_PROVED
EL_TERMINATION_NOT_YET_PROVED
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_FORMALISATION_NOT_AUTHORIZED
NO_GLOBAL_COLLATZ_CLAIM
```
