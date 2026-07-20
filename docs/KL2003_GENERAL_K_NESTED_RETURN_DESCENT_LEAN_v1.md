# KL2003 general-k nested-return descent Lean v1

Date: 2026-07-20

## Scope

This note records the first proved layer of the replacement for the invalid
raw-simple-cycle descent. The implementation is in:

```text
CollatzClassical/KL2003/KL2003GeneralKNestedReturnDescent.lean
```

It does not prove local finiteness, full EL termination, order independence,
or `SatisfiesEL`.

## Proved definitions and lemmas

```text
sourceWalk_append_nil
ContextAdmissible
ContextAdmissible.closed_weight_neg
admissibleClosedWeights
admissibleClosedWeights_neg
exists_uniform_negative_gap_of_finite_near_zero
exists_uniform_admissible_return_drop_of_local_finiteness
```

`ContextAdmissible` is factor-based: every exact nonempty closed factor of the
original typed source walk has negative evaluated weight. It therefore keeps
the nested package that loop erasure destroyed in the audited k=2 example.

The finite-gap theorem considers the finite set of weights in `(-1, 0)`. If
that set is empty it chooses epsilon `1`; otherwise it minimizes `-weight` over
the finite set. Weights outside the interval are already at most `-1`.

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

The hard theorem is now isolated:

```text
for every finite support and lower real bound,
the set of supported ContextAdmissible source walks
whose evaluated weight is at least that bound is finite.
```

The planned proof is induction on the finite support, using exact first-return
decomposition at a pivot mode. The full contract is in
`KL2003_THEOREM31_NESTED_RETURN_LOCAL_FINITENESS_SCOPING_v1.md`.

## Classification

```text
CONTEXT_ADMISSIBLE_SOURCE_WALK_DEFINED
ADMISSIBLE_CLOSED_WEIGHTS_DEFINED
FINITE_NEAR_ZERO_TO_UNIFORM_GAP_PROVED
UNIFORM_ADMISSIBLE_RETURN_DROP_CONSUMER_PROVED
LOCAL_FINITENESS_NOT_YET_PROVED
HAS_UNIFORM_RECURRENT_DROP_NOT_YET_CONSTRUCTED
EL_TERMINATION_NOT_YET_PROVED
EL_ORDER_INDEPENDENCE_NOT_YET_PROVED
NO_K3_PISTAR_THEOREM_CLAIM
NO_K9_FORMALISATION_AUTHORIZATION
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
