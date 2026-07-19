# KL2003 general-k elimination foundation Lean v1

Date: 2026-07-19

## Scope

This note records the verified language in which Theorems 3.1 and 3.2 of
KL2003 will be formalized. It is a foundation milestone, not a claim that EL
termination or deletion preservation has been proved.

## Lean files

```text
CollatzClassical/KL2003/KL2003GeneralKElimination.lean
CollatzClassical/KL2003/KL2003GeneralKEliminationAxiomAudit.lean
```

## Symbolic shifts

`SymbolicShift` stores an exact pair of integer coefficients for
`a * alpha + b`. Its semantics and additive operations are proved, rather
than trusted through a generated Boolean comparison:

```lean
SymbolicShift.eval
SymbolicShift.eval_add
SymbolicShift.eval_neg
SymbolicShift.eval_sub
```

The three shifts introduced by the original rows are named explicitly. Lean
proves that `alpha - 2` is retarded and `alpha - 1` is advanced using the
audited rational bounds for `alpha`.

## Nested expression syntax

`ELExpr k` represents principal leaves, sums, and three-way minima. Its
evaluation is connected exactly to the already-proved k-independent
`RetardedExpr` language:

```lean
ELExpr.toRetardedExpr
ELExpr.toRetardedExpr_evalAt
```

This bridge ensures that a future EL normal form can be consumed by the
generic retarded induction without a second evaluator or an unproved
translation layer.

## Deletion witness vocabulary

`ELLeafState` records a leaf, its principal ancestors, and its status.
`HasDeletionWitness` is the source rule in logical form:

- the candidate leaf is advanced;
- an earlier ancestor has the same tracked mode; and
- the ancestor shift is strictly smaller.

For a monotone function family,
`deletionWitness_ancestor_le_leaf` proves the corresponding value comparison.
This is one ingredient of the critical-assignment proof; it is not by itself
the semantic deletion theorem because the latter also needs the strictly
positive sibling contribution from the split node.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKElimination
lake env lean CollatzClassical/KL2003/KL2003GeneralKEliminationAxiomAudit.lean
git diff --check
```

Build and audit pass with the expected axiom profile. No `sorry`, `admit`,
`unsafe`, or `native_decide` is used.

## Remaining Module 2 work

```text
EL_SPLIT_STEP
EL_WELL_FORMEDNESS_PRESERVATION
DELETION_NEVER_REMOVES_ALL_MIN_CHILDREN
EL_TERMINATION
EL_ORDER_INDEPENDENCE_OR_CANONICAL_NORMALIZATION
CRITICAL_ASSIGNMENT_DELETION_PRESERVATION
SATISFIES_EL_OF_SATISFIES_IK
K2_FIGURE_A1_REGRESSION
K3_TABLE1_METRIC_REGRESSION
```

## Classification

```text
GENERAL_K_SYMBOLIC_SHIFT_DEFINED
GENERAL_K_NESTED_EL_EXPR_DEFINED
EL_TO_RETARDED_EXPR_SEMANTICS_PROVED
EL_DELETION_WITNESS_DEFINED
EL_DELETION_MONOTONICITY_COMPONENT_PROVED
GENERAL_K_ELIMINATION_FOUNDATION_AXIOM_AUDIT_PASS
EL_TERMINATION_NOT_YET_PROVED
EL_SEMANTIC_PRESERVATION_NOT_YET_PROVED
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_FORMALISATION_NOT_AUTHORIZED
NO_GLOBAL_COLLATZ_CLAIM
```
