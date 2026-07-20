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
3, contradicting parity or unique factorization. Until this lemma is proved,
`NO_ZERO_SOURCE_WALK_WEIGHT` remains a named blocker.

A generated finite simple-cycle gap certificate is an acceptable fallback for
a fixed `k`, but it must be checked by Lean and must not become an assumed
hook. The irrationality route is preferable because it scales to all `k`.

## From strict cycles to a uniform drop

Once zero weight is excluded, every repeated-mode segment of a surviving
branch is strictly negative: deletion gives nonpositivity and the no-zero
lemma makes it strict.

Strictness alone is not yet a uniform margin because repeated segments can be
arbitrarily long. The proof must decompose each closed finite walk into simple
cycles. For fixed `k`:

- the mode type is finite;
- every simple cycle has bounded length;
- there are finitely many simple cycles;
- every simple cycle appearing in a surviving branch has negative evaluated
  weight;
- the minimum absolute negative weight over that finite set supplies
  `epsilon > 0`;
- a closed walk is a nonempty sum of simple cycles, so its total is at most
  `-epsilon`.

This yields `HasUniformRecurrentDrop` and the existing arithmetic theorem then
forces a negative shift.

## Proposed Lean modules

1. `KL2003GeneralKSourceTransitionGraph.lean`
   Source actions, endpoints, weights, walks, and agreement with child labels.
2. `KL2003AlphaIrrational.lean`
   Irrationality of `logb 2 3` and nonzero evaluation of nonempty source-walk
   symbolic weights.
3. `KL2003GeneralKFiniteCycleDescent.lean`
   Simple-cycle decomposition, finite negative gap, and construction of
   `HasUniformRecurrentDrop` for surviving walks.
4. `KL2003GeneralKEliminationTermination.lean`
   Extraction of an infinite surviving walk from scheduler nontermination and
   the final contradiction.

Order independence and canonical normal-form uniqueness remain a separate
module after termination. They must not be bundled into the cycle descent.

## Implementation status

Module 1 is now implemented as
`KL2003GeneralKSourceTransitionGraph.lean`. Its finite action type, typed
endpoints, source-faithful weights, dependent walks, concatenation laws, and
accumulated-shift theorem compile and pass axiom audit. Module 2 is the next
active target; modules 3 and 4 remain unopened.

## Validation order

1. Reproduce the k=2 D1/D2/D3 transition table and the deletion of the positive
   class-8 D3 self-loop.
2. Validate the walk and cycle checker at k=3 against the generated EL data.
3. Prove the general finite-cycle theorem.
4. Close the k=3 `piStar` consumer before measuring k=9.

## Blockers

```text
BLOCKED_ON_ALPHA_IRRATIONALITY_OR_CHECKED_SIMPLE_CYCLE_GAP
BLOCKED_ON_SURVIVING_TREE_PATH_TO_SOURCE_WALK_EXTRACTION
BLOCKED_ON_SIMPLE_CYCLE_DECOMPOSITION_IN_LEAN
BLOCKED_ON_UNIFORM_EPSILON_CONSTRUCTION
EL_TERMINATION_NOT_YET_PROVED
EL_ORDER_INDEPENDENCE_NOT_YET_PROVED
```

## Classification

```text
THEOREM31_FINITE_CYCLE_DESCENT_SCOPED
GENERAL_K_SOURCE_TRANSITION_GRAPH_PROVED
RAW_SOURCE_GRAPH_POSITIVE_CYCLES_ACKNOWLEDGED
DELETION_SUPPLIES_NONINCREASE_NOT_STRICT_DROP
ZERO_WEIGHT_RECURRENCE_EXCLUSION_REQUIRED
UNIFORM_RECURRENT_DROP_CONSUMER_ALREADY_PROVED
NO_K3_PISTAR_THEOREM_CLAIM
NO_K9_FORMALISATION_AUTHORIZATION
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
