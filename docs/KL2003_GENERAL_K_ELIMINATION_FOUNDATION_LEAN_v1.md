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

The original rows are also compiled into top-level expressions:

```lean
d1TopExpr
d2TopExpr
d3TopExpr
```

For D1 and D3, P3 replaces the level-`k-1` term by a three-way minimum at
level `k`. Lean proves both the exact expression evaluations and the source
row inequalities:

```lean
sourcePhiK_D1_topExpr
sourcePhiK_D2_topExpr
sourcePhiK_D3_topExpr
```

This is the expression substituted by a future EL split step; it is generated
from the parametric row operators and does not import a prebuilt tree.

The semantic split substep is also isolated and proved:

```lean
ELExpr.shiftBy
ELExpr.shiftBy_eval
splitTopExpr
splitTopExpr_eval_le_sourceLeaf
ELExpr.replaceLeaves
ELExpr.replaceLeaves_eval_le
```

`splitTopExpr` selects D1, D2, or D3 from the residue of the tracked mode,
then shifts the entire row by the leaf's symbolic argument. The theorem
`splitTopExpr_eval_le_sourceLeaf` proves the local substitution inequality.
The generic replacement theorem lifts such leaf inequalities through any
nested combination of sums and minima. Therefore the split substep of
Theorem 3.2 is closed independently of deletion.

## Deletion witness vocabulary

`ELLeafState` records a leaf, its principal ancestors, and its status.
`HasDeletionWitness` is the source rule in logical form:

- the candidate leaf is advanced;
- an earlier ancestor has the same tracked mode; and
- the ancestor shift is strictly smaller.

For a monotone function family,
`deletionWitness_ancestor_le_leaf` proves the corresponding value comparison.
The strictly positive companion contribution is now isolated as well:

```lean
ELExpr.ArgumentsNonnegative
ELExpr.eval_pos
deletionWitness_critical_sum_contradiction
deletionWitness_excludes_critical_sum
```

For an expression whose shifted arguments stay in the nonnegative region,
`ELExpr.eval_pos` derives strict positivity from `PositivePhi`. If a deleted
leaf has a same-mode ancestor at a strictly smaller shift, monotonicity makes
the ancestor value no larger than the leaf value. It is therefore impossible
for the leaf plus a positive companion subtree to be bounded above by that
ancestor. This proves the algebraic contradiction at the heart of the source
critical-assignment argument.

This is still not the complete semantic deletion theorem. The remaining lift
must define the source critical assignment and prove that every deletion
context supplies the companion subtree, its nonnegative arguments, and the
critical sum inequality without assuming the desired preservation theorem.

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
EL_WELL_FORMEDNESS_PRESERVATION
DELETION_NEVER_REMOVES_ALL_MIN_CHILDREN
EL_TERMINATION
EL_ORDER_INDEPENDENCE_OR_CANONICAL_NORMALIZATION
CRITICAL_ASSIGNMENT_CONTEXT_CONSTRUCTION
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
GENERAL_K_TOP_LEVEL_ROW_EXPRESSIONS_DEFINED
GENERAL_K_TOP_LEVEL_ROW_EXPRESSION_SEMANTICS_PROVED
GENERAL_K_EL_SPLIT_EXPRESSION_DEFINED
GENERAL_K_EL_SPLIT_SEMANTIC_PRESERVATION_PROVED
EL_DELETION_WITNESS_DEFINED
EL_DELETION_MONOTONICITY_COMPONENT_PROVED
EL_EXPRESSION_POSITIVITY_PROVED
EL_DELETION_CRITICAL_SUM_CONTRADICTION_PROVED
GENERAL_K_ELIMINATION_FOUNDATION_AXIOM_AUDIT_PASS
EL_TERMINATION_NOT_YET_PROVED
EL_SEMANTIC_PRESERVATION_NOT_YET_PROVED
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_FORMALISATION_NOT_AUTHORIZED
NO_GLOBAL_COLLATZ_CLAIM
```
