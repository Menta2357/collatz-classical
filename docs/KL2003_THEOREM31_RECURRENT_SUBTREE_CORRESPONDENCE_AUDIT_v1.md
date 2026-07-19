# KL2003 Theorem 3.1 recurrent subtree correspondence audit v1

Date: 2026-07-20

## Scope

This note audits the recurrent-subtree step in the proof of KL2003 Theorem
3.1. It separates the source claim from the translation facts currently proved
in Lean and records a weaker sufficient descent criterion. It does not claim
that Theorem 3.1 is false, prove EL termination, or prove order independence.

## Primary source

```text
source: 30apr02.tex
sha256: 04fa4d484fe89256f6771f5651338891219385f6e049ffaf41035541016232cd
deletion rule: lines 769-777
termination statement and proof: lines 794-858
recurrent-subtree identity claim: lines 834-846
```

The source proof extracts a repeated mode along an infinite path, observes
strictly decreasing shifts from the deletion rule, and then states that the
fully grown subtrees at successive occurrences are identical after shifting
the argument. That identity is used to make the shift difference constant.

## Formal audit findings

### Absolute eligibility threshold

The source scheduler expands a terminal only when its evaluated shift is
nonnegative. Translation adds `delta.eval` to every shift, so a negative
translation need not preserve that test.

Lean proves the exact terminal boundary:

```lean
terminalEligibilityEquivalent_terminal_zero_iff
```

For a terminal at shift zero, eligibility equivalence under `delta` holds if
and only if `0 <= delta.eval`. Consequently every negative translation gives
an explicit counterexample to unconditional scheduler equivariance.

### Outer deletion context

The deletion rule searches the path from the original root for an earlier
same-mode node with smaller shift. A recurrent subtree rooted lower on that
path therefore inherits ancestors that a bare copy does not contain.

Lean proves an explicit witness:

```lean
deletionWitness_depends_on_outer_context
```

The same leaf has no deletion witness as a bare terminal and does have one
when placed below an earlier same-mode expanded node. Thus root mode and shift
translation alone do not determine deletion behavior.

### One-way pruning

Negative translation still has a useful monotone direction. Lean proves that
if a tree already has only negative terminal shifts, translating it by a
nonpositive shift preserves that property. Equivalently, such a translation
cannot create a new expandable terminal:

```lean
terminalShiftsNegative_translate_of_delta_nonpos
findExpandableOccurrence_translate_eq_none_of_delta_nonpos
```

This is one-way pruning, not equality of the two scheduled expansions.

## Alternative sufficient endpoint

The source proof asks for one exact shift increment between consecutive
recurrent copies. Exact equality is stronger than the final contradiction
needs. `KL2003GeneralKTerminationCore.lean` now defines
`HasUniformRecurrentDrop` and proves:

```lean
exists_negative_of_hasUniformRecurrentDrop
not_forall_nonnegative_of_hasUniformRecurrentDrop
```

It is enough that every later occurrence of the same tracked mode loses at
least one fixed `epsilon > 0`.

A prospective proof can model admissible source branches as a finite weighted
transition graph. If deletion admissibility implies that every repeated-mode
simple cycle has negative total shift, finiteness would provide a uniform
negative margin; loop erasure would then force shifts to negative values. This
graph/cycle premise is a proposed route only and is not yet formalized.

## Verification

```text
lake env lean CollatzClassical/KL2003/KL2003GeneralKTerminationCore.lean
lake env lean CollatzClassical/KL2003/KL2003GeneralKTerminationCoreAxiomAudit.lean
lake env lean CollatzClassical/KL2003/KL2003GeneralKSelfSimilarity.lean
lake env lean CollatzClassical/KL2003/KL2003GeneralKSelfSimilarityAxiomAudit.lean
```

## Classification

```text
THEOREM31_PRIMARY_SOURCE_RECHECKED
THEOREM31_TERMINAL_ELIGIBILITY_COUNTEREXAMPLE_PROVED
THEOREM31_DELETION_OUTER_CONTEXT_COUNTEREXAMPLE_PROVED
THEOREM31_NEGATIVE_TRANSLATION_ONE_WAY_PRUNING_PROVED
THEOREM31_UNIFORM_RECURRENT_DROP_CONTRADICTION_PROVED
THEOREM31_UNCONDITIONAL_RECURRENT_SUBTREE_IDENTITY_NOT_JUSTIFIED
THEOREM31_UNIFORM_DROP_FROM_ADMISSIBLE_CYCLES_NOT_YET_PROVED
EL_TERMINATION_NOT_YET_PROVED
EL_ORDER_INDEPENDENCE_NOT_YET_PROVED
NO_K3_PISTAR_THEOREM_CLAIM
NO_K9_FORMALISATION_AUTHORIZATION
NO_GLOBAL_COLLATZ_CLAIM
```
