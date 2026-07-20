# KL2003 Theorem 3.1 finite-cycle descent scoping v1

Date: 2026-07-20

## Objective

Replace the unproved unconditional identity of recurrent full subtrees in the
source proof of KL2003 Theorem 3.1 by a finite weighted-walk argument. The
target is to derive `HasUniformRecurrentDrop` for every infinite surviving EL
branch and then consume the arithmetic contradiction already proved in
`KL2003GeneralKTerminationCore.lean`.

This is a design contract. It does not prove EL termination or order
independence.

## Source and formal baseline

```text
primary source: 30apr02.tex
sha256: 04fa4d484fe89256f6771f5651338891219385f6e049ffaf41035541016232cd
deletion rule: lines 769-777
termination proof: lines 794-858
```

The current Lean development already provides:

- finite `TrackedMode k`;
- exact source D1/D2/D3 child modes;
- symbolic edge shifts `retardedTwo`, `d1Advanced`, and `d3Advanced`;
- a scheduler whose terminal paths contain the full outer ancestor context;
- conditional translation laws and explicit counterexamples to unconditional
  recurrent-subtree translation;
- the final contradiction from `HasUniformRecurrentDrop`.

## Weighted transition layer

The first module should define a finite source action type, indexed only where
the corresponding source row exists:

```text
retarded
d1Advanced (j : Fin 3)
d3Advanced (j : Fin 3)
```

For each admissible action it must expose:

```text
source mode
target mode
symbolic weight
proof that the target equals the existing source child-label definition
```

The weights are not duplicated data. They must reduce definitionally or by
short theorems to:

```text
retardedTwo = (0, -2)
d1Advanced = (1, -2)
d3Advanced = (1, -1)
```

A finite action walk carries the list of modes and the sum of symbolic weights.
Its evaluated weight must equal the difference between final and initial label
shifts along the corresponding terminal path.

## What deletion supplies

For two occurrences of the same mode on one surviving branch, with the later
endpoint still eligible, the printed strict deletion rule implies only:

```text
later shift <= earlier shift
```

It does not imply strict inequality because equality is retained. The theorem
`equal_shift_same_mode_not_deletionWitness` fixes that boundary in Lean.

The raw transition graph can contain positive cycles. At `k = 2`, the D3
advanced class-8 self-loop has weight `alpha - 1 > 0`; it is excluded from a
surviving branch by deletion. Therefore a certificate asserting that every raw
cycle is negative would be false and must not be used.

## Excluding zero weight

Every nonempty source walk has a symbolic total

```text
A * alpha + B
```

where `A >= 0`, every advanced edge contributes one to `A`, and every edge has
strictly negative constant coefficient. If `A = 0`, the total is strictly
negative. If `A > 0`, equality to zero would make `alpha = logb 2 3` rational.

The preferred source-independent lemma is therefore:

```text
alpha_irrational : Irrational alpha
```

with an elementary proof route: a rational identity `logb 2 3 = p / q`
would imply an equality between a positive power of 2 and a positive power of
3, contradicting parity or unique factorization. This route is now proved in
`KL2003AlphaIrrational.lean`; every nonempty source walk has nonzero evaluated
weight, and a nonpositive such walk is strictly negative.

A generated finite gap certificate over context-admissible nested returns is
an acceptable fallback for a fixed `k`, but it must be checked by Lean and
must not become an assumed hook. A certificate over raw simple cycles is not
sufficient.

## Why naive loop erasure is insufficient

Once zero weight is excluded, every nonempty repeated-mode segment for which
contextual deletion supplies nonpositivity is strictly negative. Strictness
alone is not a uniform margin because such segments can be arbitrarily long.

The initially proposed next step was to erase nested loops, decompose a closed
walk into simple cycles, and minimize over the finite set of simple cycles.
`KL2003GeneralKFiniteCycleDescentAudit.lean` refutes that inference in the
actual `k = 2` source graph. It proves the route

```text
8 --D3--> 2 --D1--> 2 --D1--> 8
```

has negative total `3 * alpha - 5`, and its contiguous inner class-2 loop has
negative weight `alpha - 2`. Removing that inner loop exposes the simple cycle
`8 -> 2 -> 8` with positive weight `2 * alpha - 3`.

Thus contextual nonpositivity of the original repeated-mode packages does not
transfer to every residual simple cycle produced by loop erasure. A finite gap
over negative raw simple cycles is not a valid proof of uniform recurrent
drop.

## Revised descent target

The replacement must preserve nested return packages. A prospective route is
a first-return/local-finiteness theorem proved by induction on the finite set
of modes:

- a first return to one mode has an interior walk avoiding that mode;
- repeated interior modes form strictly negative nested return packages;
- after removing those packages, the residual interior path is simple and has
  bounded length;
- one must prove that only finitely many admissible first-return weights occur
  in every bounded interval near zero;
- the resulting finite local set supplies a uniform negative gap.

This local-finiteness claim is a new blocker, not a proved theorem. An
alternative well-founded measure that works directly on contextual scheduler
states is also acceptable. Either route must retain the ancestor context used
by deletion.

## Proposed Lean modules

1. `KL2003GeneralKSourceTransitionGraph.lean`
   Source actions, endpoints, weights, walks, and agreement with child labels.
2. `KL2003AlphaIrrational.lean`
   Irrationality of `logb 2 3` and nonzero evaluation of nonempty source-walk
   symbolic weights.
3. `KL2003GeneralKNestedReturnDescent.lean`
   Context-admissible factors, context-preserving first-return decomposition,
   local finiteness near zero, and construction of a uniform return gap.
4. `KL2003GeneralKEliminationTermination.lean`
   Extraction of an infinite surviving walk from scheduler nontermination and
   the final contradiction.

Order independence and canonical normal-form uniqueness remain a separate
module after termination. They must not be bundled into the cycle descent.

## Implementation status

Module 1 is now implemented as
`KL2003GeneralKSourceTransitionGraph.lean`. Its finite action type, typed
endpoints, source-faithful weights, dependent walks, concatenation laws, and
accumulated-shift theorem compile and pass axiom audit. Module 2 is now
implemented as `KL2003AlphaIrrational.lean`: it proves `alpha_irrational`,
excludes zero weight for nonempty source walks, and strengthens contextual
nonpositivity to strict negativity. The audit module
`KL2003GeneralKFiniteCycleDescentAudit.lean` has also shown that the naive
simple-cycle decomposition proposed for module 3 is invalid even at `k = 2`.
The revised nested-return module is now open. It defines exact-factor
`ContextAdmissible` source walks and proves that finiteness of admissible
closed weights in `(-1, 0)` yields a uniform negative gap. The new scoping
`KL2003_THEOREM31_NESTED_RETURN_LOCAL_FINITENESS_SCOPING_v1.md` fixes the
remaining combinatorial target as finiteness of admissible supported walks
above every lower bound, proved by induction on finite mode support. That
local-finiteness theorem and module 4 remain open.

## Validation order

1. Formalize the context-preserving first-return package and its relation to
   scheduler paths.
2. Prove or refute local finiteness of admissible return weights near zero.
3. Validate the resulting descent theorem at k=2 and k=3 against generated EL
   data.
4. Close the k=3 `piStar` consumer before measuring k=9.

## Blockers

```text
BLOCKED_ON_SURVIVING_TREE_PATH_TO_SOURCE_WALK_EXTRACTION
BLOCKED_ON_CONTEXT_PRESERVING_FIRST_RETURN_DECOMPOSITION
BLOCKED_ON_FINITE_ADMISSIBLE_WALKS_ABOVE_INDUCTION
EL_TERMINATION_NOT_YET_PROVED
EL_ORDER_INDEPENDENCE_NOT_YET_PROVED
```

## Classification

```text
THEOREM31_FINITE_CYCLE_DESCENT_SCOPED
NAIVE_SIMPLE_CYCLE_DESCENT_REFUTED_AT_K2
NESTED_RETURN_DESCENT_RESCOPED
GENERAL_K_SOURCE_TRANSITION_GRAPH_PROVED
RAW_SOURCE_GRAPH_POSITIVE_CYCLES_ACKNOWLEDGED
DELETION_SUPPLIES_NONINCREASE_NOT_STRICT_DROP
ZERO_WEIGHT_RECURRENCE_EXCLUSION_PROVED
ALPHA_IRRATIONALITY_PROVED
NONEMPTY_SOURCE_WALK_ZERO_WEIGHT_EXCLUDED
CONTEXT_ADMISSIBLE_SOURCE_WALK_DEFINED
FINITE_NEAR_ZERO_TO_UNIFORM_GAP_PROVED
NESTED_RETURN_LOCAL_FINITENESS_SCOPED
UNIFORM_RECURRENT_DROP_CONSUMER_ALREADY_PROVED
NO_K3_PISTAR_THEOREM_CLAIM
NO_K9_FORMALISATION_AUTHORIZATION
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
