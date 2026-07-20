# KL2003 general-k critical-guided scheduler scoping v1

Date: 2026-07-20

## Purpose

Define the source-faithful route from the semantic equation-(305) invariant to
EL termination after the local k=5 triple-witness audit showed that source
typing and nonnegative prefix shifts alone are insufficient.

This is a four-layer implementation plan, not a proposal to add one abstract
termination hook.

## Closed inputs

The repository already provides:

1. source-typed D1/D2/D3 transitions and provenanced source genealogies;
2. deterministic nonnegative-terminal scheduling and coherent infinite-branch
   extraction for a nonterminating run;
3. exact equality between raw deletion contexts and strict source prefixes;
4. `CriticalNodeBounds`, the contextual equation-(305) invariant;
5. deletion-witness exclusion of a globally critical leaf;
6. `criticalWitnessRetention`, which keeps all branches below a noncritical
   target and uses canonical witness retention below a critical target;
7. critical-target exclusion of three simultaneous witnesses; and
8. the conditional advanced-arrival recurrence and strict-descent consumer.

The k=5 audit also establishes the negative boundary: the Phi-independent
`witnessRetention` scheduler cannot obtain witness-free retained branches from
local trace data alone.

## Layer A: critical expandable occurrences

Create a structure carrying:

```lean
structure CriticalExpandableOccurrence ... extends ExpandableOccurrence tree where
  targetCritical : path.context.HoleCritical (.terminal target) Phi y
```

Define a left-to-right finder over terminal paths that requires both
nonnegative shift and `HoleCritical`. Its two acceptance theorems are:

```text
some -> selected terminal is nonnegative and globally critical
none -> every globally critical terminal has negative shift
```

The second theorem is the semantic stopping condition. It deliberately says
nothing about advanced leaves in globally noncritical subtrees.

## Layer B: Phi-sensitive critical source step

For a critical occurrence:

- D1/D3 split as in the existing provenanced scheduler;
- prove the newly created advanced `min3` target is globally critical, because
  expansion and addition preserve criticality along the selected path;
- apply `criticalWitnessRetention Phi y`;
- cite `criticalWitnessRetention_retainedBranchesWitnessFree_of_targetCritical`;
- preserve `CriticalNodeBounds`, arguments nonnegative, trace consistency and
  exact normal-value evaluation; and
- D2 uses the exact source split without an advanced minimum.

The step must consume actual proofs of positivity and monotonicity. It must not
store those properties as unproved fields in a wrapper.

## Layer C: finite iteration and critical genealogy

Iterate the critical finder/step at fixed `Phi,y`. Prove:

```text
every selected genealogy prefix has nonnegative shift
every selected advanced child is witness-free
every finite run preserves CriticalNodeBounds and exact root value
```

If the iteration never stops, reuse the quaternary-capacity and Konig
infrastructure to extract one coherent infinite typed source walk. Unlike the
Phi-independent extraction, every chosen terminal now lies on a global
critical path, so the critical-target no-triple theorem supplies the concrete
`WitnessFreeAdvancedPrefixRealization` objects required by the existing
advanced-recurrence consumer.

## Layer D: termination and semantic EL conclusion

Combine:

1. nonnegative extracted shifts;
2. infinitely many advanced arrivals;
3. finite-mode recurrence;
4. witness-free arrival monotonicity;
5. alpha irrationality; and
6. source self-similarity for a fixed recurrent decrement.

The contradiction proves that the critical-guided iteration stops. At the
stopping tree, every globally critical terminal has negative shift. Use a
critical assignment to express the root value as a sum of those retarded
leaves and derive the semantic EL inequality required by `SatisfiesEL`.

This route proves satisfaction pointwise in `Phi,y`; it does not need every
globally noncritical advanced subtree to be syntactically normalized.

## Source fidelity

Primary source: `30apr02.tex`, SHA256
`04fa4d484fe89256f6771f5651338891219385f6e049ffaf41035541016232cd`.

- lines 763-784: splitting, deletion, and the no-all-three requirement;
- lines 794-843: termination through a recurrent infinite path;
- lines 913-1010: critical assignments, equation (305), and total
  noncriticality of witnessed leaves.

The implementation must preserve this separation: syntax provides the tree
and witnesses; semantics identifies the critical part whose survival matters.

## Named blockers

```text
BLOCKED_ON_CRITICAL_TERMINAL_FINDER
BLOCKED_ON_SPLIT_MIN_TARGET_CRITICALITY
BLOCKED_ON_CRITICALNODEBOUNDS_ITERATION_FROM_CRITICAL_INPUT
BLOCKED_ON_CRITICAL_GENEALOGY_COMPACTNESS
BLOCKED_ON_FIXED_RECURRENT_DECREMENT
BLOCKED_ON_CRITICAL_STOP_TO_SATISFIESEL
```

## Guardrails

- Do not alter the proved k=2 V3 theorem chain.
- Do not introduce an empty minimum.
- Do not assume all retained branches are witness-free globally.
- Do not use the k=5 candidate as a scheduler-reachability theorem.
- Do not declare EL termination before Layer D closes.
- No k=3 piStar theorem claim yet.
- No k=9 formalisation authorization.
- k=11 remains deferred.
- No global Collatz claim.

## Classification

```text
CRITICAL_GUIDED_SCHEDULER_CHAIN_SCOPED
FOUR_LAYER_IMPLEMENTATION_PLAN_DEFINED
LOCAL_TRIPLE_WITNESS_COUNTEREXAMPLE_CONSUMED
CRITICAL_TARGET_TRIPLE_EXCLUSION_CONSUMED
PHI_INDEPENDENT_SCHEDULER_NOT_OVERCLAIMED
EL_TERMINATION_NOT_YET_PROVED
NO_K3_PISTAR_THEOREM_CLAIM
NO_K9_FORMALISATION_AUTHORIZATION
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
