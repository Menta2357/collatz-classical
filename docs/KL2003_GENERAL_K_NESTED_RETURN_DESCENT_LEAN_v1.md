# KL2003 general-k nested-return descent Lean v1

Date: 2026-07-20

## Scope

This note records the completed finite-support layer replacing the invalid
raw-simple-cycle descent. The implementation is in:

```text
CollatzClassical/KL2003/KL2003GeneralKNestedReturnDescent.lean
```

It proves local finiteness and a uniform negative gap for all context-
admissible closed returns. It does not yet extract such a walk from scheduler
nontermination, prove full EL termination, order independence, or
`SatisfiesEL`.

## Proved definitions and lemmas

```text
PackedSourceAction
sourceWalkActionList
sourceWalkActionList_injective
sourceWalkActionList_length
finite_sourceWalk_length_le
BoundedPackedSourceWalk
sourceWalkVertexTrace
Supported
SourceSupported
exists_first_sourceWalk_factorization_at_of_mem_vertexTrace
exists_sourceWalk_factorization_at_of_mem_dropLast_vertexTrace
HasInternalVisit
EndsAtFirstVisit
IsFirstReturn
firstStepTailCode
firstStepTailCode_injective
exists_firstReturn_split_of_length_pos
appendClosedWalks
exists_firstReturnList_decomposition
exists_firstReturnList_terminal_decomposition
appendClosedWalks_weight_eval
sourceWalk_append_nil
sourceWalk_append_assoc
ContextAdmissible
ContextAdmissible.closed_weight_neg
ContextAdmissible.factor
admissibleClosedWeights
admissibleClosedWeights_neg
exists_uniform_negative_gap_of_finite_near_zero
exists_uniform_admissible_return_drop_of_local_finiteness
LocallyFiniteAdmissibleSourceWalks
finite_firstReturns_above_of_localFiniteness_on_erased_support
finite_terminalRemainders_above_of_localFiniteness_on_erased_support
exists_uniform_firstReturn_drop_of_localFiniteness_on_erased_support
finite_admissible_sourceWalks_above
finite_admissible_walks_above
finite_admissibleClosedWeights_near_zero
exists_uniform_admissible_return_drop
```

`ContextAdmissible` is factor-based: every exact nonempty closed factor of the
original typed source walk has negative evaluated weight. It therefore keeps
the nested package that loop erasure destroyed in the audited k=2 example.
Admissibility is proved to descend to every exact factor.

Every action is also serialized together with its source mode. The action-list
serialization is injective for fixed typed endpoints and preserves length.
Since the packed action alphabet is finite, Lean proves that source walks of
bounded length form a finite set and that all bounded walks with packed
endpoints form a finite type. This closes the finite-enumeration prerequisite
for the later first-return induction.

The context-preserving decomposition is also now proved. A pivot occurring in
the vertex trace yields a typed prefix/suffix factorization, and a strengthened
version chooses its first occurrence. Every nonempty closed walk splits into a
first return and a shorter closed remainder. Strong induction on length then
reconstructs the original walk exactly as an appended list of first returns.
No nested interior is erased. Length and evaluated weight of the reconstructed
list are additive, and contextual admissibility descends to every listed
member.

The finite-gap theorem considers the finite set of weights in `(-1, 0)`. If
that set is empty it chooses epsilon `1`; otherwise it minimizes `-weight` over
the finite set. Weights outside the interval are already at most `-1`.

The local-finiteness theorem uses the source-only support invariant required
by dependent endpoints. A first-return tail ends at the pivot, but all of its
edge sources lie in `support.erase pivot`. An injective optional encoding by
first action and tail transfers the induction hypothesis to first returns.
Every open walk then decomposes exactly into a list of first returns at its
source and one terminal remainder which never returns to that source.

Strong induction on the finite source support proves that context-admissible
walks above any real lower weight bound have bounded length. The induction
extracts a finite terminal-weight upper bound, a finite first-return length
bound, and a uniform return drop `epsilon`; these bound both the number and
total length of return packages. Bounded typed source walks are already known
finite, so the desired set is finite. Projecting to closed-walk weights proves
finiteness in `(-1, 0)` and removes the final hypothesis from the uniform-gap
consumer.

## Verification

```text
lake env lean -o \
  .lake/build/lib/lean/CollatzClassical/KL2003/KL2003GeneralKNestedReturnDescent.olean \
  -i .lake/build/lib/lean/CollatzClassical/KL2003/KL2003GeneralKNestedReturnDescent.ilean \
  CollatzClassical/KL2003/KL2003GeneralKNestedReturnDescent.lean

lake env lean \
  CollatzClassical/KL2003/KL2003GeneralKNestedReturnDescentAxiomAudit.lean
```

Both commands pass. The audited declarations depend only on:

```text
[propext, Classical.choice, Quot.sound]
```

No `sorry`, `admit`, `axiom`, `unsafe`, or `native_decide` occurs in the new
Lean files.

## Remaining mathematical target

The finite-support theorem and uniform return gap are closed. The next module
must turn a hypothetical nonterminating EL scheduler execution into an
infinite typed source walk and prove that every repeated-mode factor of that
walk is context-admissible. Combining the resulting recurrent closed factors
with `exists_uniform_admissible_return_drop` supplies the already-audited
`HasUniformRecurrentDrop` arithmetic contradiction.

## Classification

```text
CONTEXT_ADMISSIBLE_SOURCE_WALK_DEFINED
CONTEXT_ADMISSIBILITY_FACTOR_INHERITANCE_PROVED
SOURCE_WALK_ACTION_LIST_INJECTIVE
BOUNDED_SOURCE_WALKS_FINITE
SOURCE_WALK_VERTEX_TRACE_AND_SUPPORT_DEFINED
FIRST_PIVOT_FACTORIZATION_PROVED
FIRST_RETURN_SPLIT_PROVED
FIRST_RETURN_LIST_DECOMPOSITION_PROVED
NESTED_RETURN_PACKAGES_PRESERVED
ADMISSIBLE_CLOSED_WEIGHTS_DEFINED
FINITE_NEAR_ZERO_TO_UNIFORM_GAP_PROVED
UNIFORM_ADMISSIBLE_RETURN_DROP_CONSUMER_PROVED
SOURCE_ONLY_SUPPORT_INDUCTION_INVARIANT_PROVED
FIRST_RETURN_TAIL_SMALLER_SUPPORT_PROVED
OPEN_WALK_TERMINAL_DECOMPOSITION_PROVED
FIRST_RETURN_AND_TERMINAL_FINITE_ABOVE_PROVED
FINITE_ADMISSIBLE_WALKS_ABOVE_PROVED
FINITE_ADMISSIBLE_CLOSED_WEIGHTS_NEAR_ZERO_PROVED
UNIFORM_ADMISSIBLE_RETURN_DROP_PROVED_UNCONDITIONALLY
HAS_UNIFORM_RECURRENT_DROP_NOT_YET_CONSTRUCTED
SURVIVING_BRANCH_EXTRACTION_NOT_YET_PROVED
EL_TERMINATION_NOT_YET_PROVED
EL_ORDER_INDEPENDENCE_NOT_YET_PROVED
NO_K3_PISTAR_THEOREM_CLAIM
NO_K9_FORMALISATION_AUTHORIZATION
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
