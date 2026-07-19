# KL2003 general-k self-similarity translation in Lean v1

## Scope

This checkpoint proves translation equivariance for one source-faithful
general-`k` EL expansion. A symbolic translation `delta`:

- preserves every mode and adds `delta` to each label shift;
- commutes with `frontierExpr` and `normalExpr`;
- translates evaluation from `y` to `y + delta.eval`;
- commutes with `ofExpr`, `splitTopExpr`, and `sourceSplitTree`.

The main source-facing theorem is `ELTree.sourceSplitTree_translate`.

## Role in Theorem 3.1

KL2003 states that fully split subtrees rooted at recurrent copies of one mode
are identical after translating their arguments. This module proves the local
one-step equivariance needed for that claim. It does not yet iterate the
equivariance over an infinite/full expansion, identify recurrent subtrees,
derive a fixed increment between successive recurrent shifts, or prove
termination/order independence.

## Verification

```text
lake env lean CollatzClassical/KL2003/KL2003GeneralKSelfSimilarity.lean
lake env lean CollatzClassical/KL2003/KL2003GeneralKSelfSimilarityAxiomAudit.lean
```

The algebraic translation theorems use only `propext`; the source-expression
theorems additionally report the existing `Classical.choice` and `Quot.sound`.

## Classification

```text
GENERAL_K_TREE_TRANSLATION_DEFINED
GENERAL_K_FRONTIER_TRANSLATION_EQUIVARIANCE_PROVED
GENERAL_K_NORMAL_TRANSLATION_EQUIVARIANCE_PROVED
GENERAL_K_SOURCE_SPLIT_TRANSLATION_EQUIVARIANCE_PROVED
THEOREM31_LOCAL_SELF_SIMILARITY_STEP_PROVED
GENERAL_K_SELF_SIMILARITY_TRANSLATION_AXIOM_AUDIT_PASS
THEOREM31_FULL_RECURRENT_SUBTREE_CORRESPONDENCE_NOT_YET_PROVED
GENERAL_K_FULL_EXPANSION_DELETION_TERMINATION_NOT_YET_PROVED
GENERAL_K_EL_ORDER_INDEPENDENCE_NOT_YET_PROVED
SATISFIES_EL_NOT_YET_PROVED
NO_GLOBAL_COLLATZ_CLAIM
```
