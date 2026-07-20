# KL2003 Theorem 3.1 nested-return local-finiteness scoping v1

Date: 2026-07-20

## Objective

Replace the invalid raw-simple-cycle argument by a context-preserving theorem
for source walks. The target is a uniform negative drop for every nonempty
closed factor that can occur on a surviving nonnegative EL branch.

This page scopes one combinatorial module. It does not claim full EL
termination, order independence, or `SatisfiesEL`.

## Why the previous route is unavailable

`KL2003GeneralKFiniteCycleDescentAudit.lean` proves at `k = 2` that the route

```text
8 --D3--> 2 --D1--> 2 --D1--> 8
```

has negative total weight, and that its inner class-2 return is negative, but
erasing that inner return exposes the positive simple cycle `8 -> 2 -> 8`.
Therefore loop erasure does not preserve the contextual nonpositivity supplied
by deletion. No proof may minimize over raw simple cycles.

The replacement must retain nested return packages exactly where they occur
in the original walk.

## Implemented boundary

`KL2003GeneralKNestedReturnDescent.lean` now defines:

```lean
ContextAdmissible walk
admissibleClosedWeights hp
```

`ContextAdmissible walk` says that every factorization

```text
walk = initial ++ loop ++ suffix
```

with `loop` nonempty and closed has strictly negative evaluated weight. This
is the path-level property that a surviving nonnegative branch must inherit
from deletion plus `alpha_irrational`.

The same module proves:

```lean
exists_uniform_negative_gap_of_finite_near_zero
exists_uniform_admissible_return_drop_of_local_finiteness
```

Thus the order-theoretic end of the argument is closed: if admissible closed
weights in `(-1, 0)` form a finite set, a single `epsilon > 0` bounds every
admissible closed weight by `-epsilon`. Weights at most `-1` are handled by the
same epsilon. Local finiteness itself is not assumed in a bundle and remains
the mathematical target below.

## Exact combinatorial target

The robust theorem is stronger than finiteness of weights. For a finite
support of modes and every real lower bound, prove finiteness of the actual
admissible walks above that bound.

The intended Lean statement is equivalent to:

```text
finite_admissible_walks_above
  (support : Finset Mode) (lower : Real) :
  { packed source walks whose vertex trace lies in support,
    whose every nonempty closed factor has negative weight,
    and whose evaluated weight is at least lower }.Finite
```

Finiteness of walks, rather than only of weights, gives all required
corollaries without quotienting by equal weights:

1. admissible closed weights in `(-1, 0)` are finite;
2. admissible open walks have a uniform upper bound;
3. first-return packages above any lower bound are finite;
4. the finite near-zero set supplies a uniform negative return gap.

The theorem is graph-generic over a finite vertex type, finite edge fibers,
and an additive real edge weight. It must then be instantiated with
`SourceAction` and `SourceWalk`; the source graph remains the only KL-specific
input.

## Representation choice

`Quiver.Path` provides dependent composition and length, but its standard API
does not provide the first/last-visit decomposition needed here. The existing
`SourceWalk` already has typed endpoints, append, additive length, and additive
symbolic weight.

The nested-return module should add a nondependent packed view only as a
proved encoding of `SourceWalk`, not as a second assumed interface:

```text
PackedSourceWalk hp:
  source mode
  target mode
  typed SourceWalk source target

vertexTrace:
  source followed by every successive target

Supported support walk:
  every vertex in vertexTrace belongs to support
```

The packed view exists solely so finite sets and first-return lists can be
formed. Every constructor must contain a concrete typed `SourceWalk`; no edge,
endpoint, or weight may be supplied as an unchecked field.

## First-return decomposition

Fix a pivot mode `v` in a nonempty finite support `S`.

Every supported walk has one of two forms:

```text
avoid:
  the walk never visits v and is supported in S \ {v}

hit:
  prefix ++ return_1 ++ ... ++ return_n ++ suffix
```

For the hit form:

- `prefix` reaches `v` for the first time;
- every `return_i` is a nonempty first return from `v` to `v`;
- `suffix` leaves the last occurrence of `v` and never returns;
- the interiors of `prefix`, `suffix`, and every `return_i` avoid `v` and are
  supported in `S \ {v}`;
- append reconstructs the original typed walk exactly;
- lengths and evaluated weights are additive;
- `ContextAdmissible` descends to every factor.

The decomposition must use first and last occurrences in `vertexTrace`; it
must not erase a nested return or replace a package by a residual raw cycle.

## Induction on finite support

Prove `finite_admissible_walks_above` by induction on `support`.

### Base support

With empty support there is no packed walk whose source belongs to the
support. The relevant subtype is empty and therefore finite.

### Inductive step

Choose `v in S` and use the theorem for `S \ {v}`.

1. Walks avoiding `v` are finite above every lower bound by induction.
2. A first return at `v` consists of finitely many endpoint edges plus an
   admissible interior supported in `S \ {v}`.
3. Hence first returns with weight in `(-1, 0)` are finite.
4. Since every first return is a nonempty closed factor, contextual
   admissibility makes its weight strictly negative.
5. The already proved finite-gap consumer yields `epsilon_v > 0` for all
   first returns at `v`.
6. The induction hypothesis gives a uniform upper bound for admissible
   avoiding walks: the finite set above zero has a maximum, while every other
   walk is nonpositive.
7. If a complete walk has weight at least `lower`, the number of first-return
   packages is bounded using `epsilon_v` and the upper bounds for the prefix
   and suffix.
8. Because all other return weights are negative, the same global lower bound
   gives a lower bound for each individual return. The first-return choices
   are therefore finite by step 2 and the induction hypothesis.
9. Bounded list length over a finite set of return packages gives finitely many
   middle lists. Combining the finite prefix, middle, and suffix choices proves
   the inductive case.

This is a well-founded induction on `support.card`; no real-number descent is
used.

## Source-walk instantiation

For `TrackedMode (p + 1)`:

- the vertex type is finite;
- each `SourceAction mode` is finite;
- target and weight are the source-faithful definitions already audited;
- a nonempty closed factor with nonpositive weight is strictly negative by
  `KL2003AlphaIrrational.lean`;
- a surviving nonnegative scheduler branch must supply nonpositivity for every
  repeated-mode factor from the absence of a deletion witness.

The last bullet is not part of the generic graph theorem. It belongs to the
subsequent extraction module connecting scheduler nontermination to an
infinite context-admissible `SourceWalk`.

## Consumer chain

Once the local-finiteness theorem is proved, the source-specific chain is:

```text
surviving branch
  -> every repeated-mode factor has weight <= 0
  -> alpha irrationality makes every nonempty factor weight < 0
  -> ContextAdmissible
  -> finite_admissible_walks_above
  -> finite admissible closed weights in (-1, 0)
  -> exists_uniform_admissible_return_drop_of_local_finiteness
  -> HasUniformRecurrentDrop
  -> an allegedly nonnegative recurrent shift becomes negative
```

The final arithmetic contradiction already exists in
`KL2003GeneralKTerminationCore.lean`.

## Lean implementation order

1. Packed source walks, action serialization, and finite bounded-length
   enumeration. The action serialization and bounded enumeration are proved;
   vertex traces and support are also defined.
2. Factor admissibility and inheritance under exact append factorizations.
   Proved.
3. First-pivot and closed-walk first-return-list decomposition with exact
   reconstruction. Proved; no last-pivot theorem is needed for closed walks.
4. First-return encoding and finiteness from the smaller support.
5. Induction theorem `finite_admissible_walks_above`.
6. Local-finiteness and uniform-gap corollaries.
7. Scheduler extraction and construction of `HasUniformRecurrentDrop` in the
   separate termination module.

## Acceptance criteria

- No raw-simple-cycle negativity hypothesis.
- No local-finiteness field in an assumed structure.
- No fixed `k`, fixed depth, or generated epsilon in the generic theorem.
- Every packed walk contains a concrete typed path and recomputes its weight.
- Exact append reconstruction for every decomposition.
- Axiom audit limited to the existing classical profile.
- Validation at `k = 2` and `k = 3` before the k=3 `piStar` consumer.

## Current blockers

```text
BLOCKED_ON_FIRST_RETURN_FINITE_ABOVE_FROM_SMALLER_SUPPORT
BLOCKED_ON_FINITE_ADMISSIBLE_WALKS_ABOVE_INDUCTION
BLOCKED_ON_SURVIVING_TREE_PATH_TO_SOURCE_WALK_EXTRACTION
EL_TERMINATION_NOT_YET_PROVED
EL_ORDER_INDEPENDENCE_NOT_YET_PROVED
```

The previous blocker `BLOCKED_ON_UNIFORM_EPSILON_CONSTRUCTION` is closed: the
finite-near-zero consumer is now proved in Lean.

## Classification

```text
NESTED_RETURN_LOCAL_FINITENESS_SCOPED
CONTEXT_ADMISSIBLE_SOURCE_WALK_DEFINED
CONTEXT_ADMISSIBILITY_FACTOR_INHERITANCE_PROVED
BOUNDED_SOURCE_WALKS_FINITE
SOURCE_WALK_VERTEX_TRACE_AND_SUPPORT_DEFINED
FIRST_PIVOT_FACTORIZATION_PROVED
FIRST_RETURN_LIST_DECOMPOSITION_PROVED
FINITE_NEAR_ZERO_TO_UNIFORM_GAP_PROVED
UNIFORM_EPSILON_CONSTRUCTION_CLOSED_CONDITIONALLY_ON_LOCAL_FINITENESS
NAIVE_SIMPLE_CYCLE_DESCENT_REJECTED
LOCAL_FINITENESS_NOT_YET_PROVED
SURVIVING_BRANCH_EXTRACTION_NOT_YET_PROVED
EL_TERMINATION_NOT_YET_PROVED
NO_K3_PISTAR_THEOREM_CLAIM
NO_K9_FORMALISATION_AUTHORIZATION
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
