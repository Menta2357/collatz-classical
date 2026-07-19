# KL2003 Theorem 3.1 termination sign scoping v1

Date: 2026-07-19

## Purpose

This note records a source-level sign inconsistency and audits the recurrent
subtree correspondence used in the termination proof of KL2003 Theorem 3.1.
It does not claim that Theorem 3.1 is false and does not claim EL termination.

## Source custody

```text
source: 30apr02.tex
sha256: 04fa4d484fe89256f6771f5651338891219385f6e049ffaf41035541016232cd
relevant lines: 794-858
```

The source states at lines 827-829 that the recurring shifts satisfy

```text
beta_1 > beta_2 > beta_3 > ...
```

It then defines at line 843

```text
delta = beta_2 - beta_1 > 0
```

and uses at lines 846-849

```text
beta_j = beta_1 + (j - 1) * delta
```

to conclude that `beta_j < 0` for sufficiently large `j`.

These three assertions cannot all hold. Under the displayed decreasing
sequence, the compatible normalization is

```text
delta = beta_2 - beta_1 < 0.
```

With this sign, the final arithmetic-progression contradiction has the
intended direction.

## Formalization consequence

The sign normalization is necessary but not sufficient for a Lean proof. The
source also says at lines 834-846 that recurring rooted subtrees are identical
and that their identification forces every consecutive shift difference to
equal `delta`. Two independent features of the source construction prevent
that correspondence from following from mode equality plus translation alone:

1. splittability is the absolute test `0 <= beta`; a negative translation can
   move a terminal label across that threshold;
2. the deletion rule at lines 769-777 inspects all earlier labels on the path
   from the original root, so the same recurrent root label can have different
   deletion witnesses under different outer ancestor contexts.

Both points now have concrete Lean witnesses. They invalidate an unconditional
translation argument, not Theorem 3.1 itself. A successful proof must add the
missing contextual invariant or replace exact subtree identity by another
well-founded descent.

There is also an inequality mismatch inside the source proof. The deletion
rule at lines 769-777 deletes when an earlier same-mode shift is strictly
smaller than the leaf shift. At lines 830-832 the proof says deletion would
occur when the later shift is greater than or equal to the earlier one. The
equality case is not covered by the printed rule. Lean confirms this boundary:
an eligible leaf below an equal-shift same-mode ancestor has no deletion
witness. Strict recurrent descent therefore needs a separate exclusion of
zero-weight recurrent segments.

The termination pass must therefore discharge, separately:

1. finite branching and extraction of an infinite path from nontermination;
2. recurrence of a tracked mode along that path;
3. strict decrease of the shift at every repeated-mode occurrence from the
   deletion rule;
4. a contextual self-similarity theorem that yields a fixed negative shift
   increment, or an alternative well-founded descent argument;
5. eventual negativity and contradiction with continued splittability;
6. order independence or a canonical normalization theorem.

## Lean progress

`KL2003GeneralKTerminationCore.lean` now proves two independent parts of this
list without assuming the missing correspondence:

- every infinite sequence in the finite type `TrackedMode k` has a mode with
  occurrences arbitrarily far out;
- if the recurrent shifts have one fixed increment `delta < 0`, they are
  eventually negative and contradict nonnegativity.

It also proves directly that `beta_2 < beta_1` and
`delta = beta_2 - beta_1` imply `delta < 0`. The self-similar subtree
correspondence needed to obtain a fixed increment remains open. Its local
algebraic component is now proved separately: translating a root label by a
symbolic shift commutes with one complete source D1/D2/D3 split and with both
tree projections. A dependent terminal path now transports through arbitrary
tree contexts, splitting at that transported path commutes with translation,
and the result iterates over every finite trace of explicitly matched raw
source splits.

The structural deletion operation is equivariant as well: a `Min3Path`
transports through translation and `reduceAt` commutes for every fixed
retention pattern. Deletion witnesses and `witnessRetention` also transport
when source and translated branch eligibility agree. D2 `sourceStep` commutes
outright; D1/D3 `sourceStep` commutes under the three explicit branch
eligibility equivalences. At tree level, the exact left-to-right selector and
one deterministic scheduled step commute under the corresponding tree-wide
and local contracts.

The new audit proves why those contracts are substantive. For a terminal at
shift zero, `TerminalEligibilityEquivalent delta` is equivalent to
`0 <= delta.eval`; hence every negative `delta` is a counterexample. A second
theorem constructs the same leaf both without ancestors and below an earlier
same-mode node: only the latter has a deletion witness. Conversely, a
nonpositive translation cannot create an expandable terminal in a tree that
already has only negative terminal shifts. This gives one-way pruning, not
subtree identity.

An additional theorem places a shift-zero leaf below a shift-zero same-mode
ancestor and proves that no deletion witness exists. It formalizes the gap
between the strict printed deletion rule and the proof's later `>=` claim.

The arithmetic core now also proves a weaker sufficient endpoint. If every
later recurrence of one mode decreases the shift by at least one uniform
`epsilon > 0`, then some recurrent shift is negative. The next mathematical
obligation can therefore be phrased as a finite weighted-transition problem:
derive such a uniform drop from admissible simple cycles while respecting the
deletion context. That cycle argument is not yet formalized.

## Current verdict

```text
THEOREM31_SOURCE_SIGN_INCONSISTENCY_RECORDED
THEOREM31_DELTA_NORMALIZATION_PROPOSED_NEGATIVE
THEOREM31_FINITE_MODE_RECURRENCE_PROVED
THEOREM31_FIXED_NEGATIVE_INCREMENT_CONTRADICTION_PROVED
THEOREM31_UNIFORM_RECURRENT_DROP_CONTRADICTION_PROVED
THEOREM31_LOCAL_SOURCE_SPLIT_TRANSLATION_EQUIVARIANCE_PROVED
THEOREM31_FINITE_RAW_SPLIT_TRACE_TRANSLATION_EQUIVARIANCE_PROVED
THEOREM31_FIXED_RETENTION_DELETION_TRANSLATION_EQUIVARIANCE_PROVED
THEOREM31_WITNESS_RETENTION_TRANSLATION_EQUIVARIANCE_PROVED_CONDITIONALLY
THEOREM31_D2_SOURCE_STEP_TRANSLATION_EQUIVARIANCE_PROVED
THEOREM31_D1_D3_SOURCE_STEP_TRANSLATION_EQUIVARIANCE_PROVED_CONDITIONALLY
THEOREM31_SOURCE_SCHEDULER_TRANSLATION_EQUIVARIANCE_PROVED_CONDITIONALLY
THEOREM31_NEGATIVE_TRANSLATION_ONE_WAY_PRUNING_PROVED
THEOREM31_TERMINAL_ELIGIBILITY_COUNTEREXAMPLE_PROVED
THEOREM31_DELETION_OUTER_CONTEXT_COUNTEREXAMPLE_PROVED
THEOREM31_EQUAL_SHIFT_DELETION_GAP_PROVED
THEOREM31_UNCONDITIONAL_RECURRENT_SUBTREE_IDENTITY_NOT_JUSTIFIED
THEOREM31_CONTEXTUAL_CORRESPONDENCE_OR_UNIFORM_CYCLE_DROP_REQUIRED
THEOREM31_UNIFORM_DROP_FROM_ADMISSIBLE_CYCLES_NOT_YET_PROVED
EL_TERMINATION_NOT_YET_PROVED
EL_ORDER_INDEPENDENCE_NOT_YET_PROVED
NO_K3_PISTAR_THEOREM_CLAIM
NO_K9_FORMALISATION_AUTHORIZATION
NO_GLOBAL_COLLATZ_CLAIM
```
