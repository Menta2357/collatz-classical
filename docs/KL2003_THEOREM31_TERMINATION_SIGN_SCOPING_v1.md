# KL2003 Theorem 3.1 termination sign scoping v1

Date: 2026-07-19

## Purpose

This note records a source-level sign inconsistency in the termination proof
of KL2003 Theorem 3.1 before that argument is translated to Lean. It does not
claim that Theorem 3.1 is false and does not claim EL termination.

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
source also says that recurring rooted subtrees are identical and that their
identification forces every consecutive shift difference to equal `delta`.
That correspondence must be represented and proved; it cannot be inherited
from the corrected sign.

The termination pass must therefore discharge, separately:

1. finite branching and extraction of an infinite path from nontermination;
2. recurrence of a tracked mode along that path;
3. strict decrease of the shift at every repeated-mode occurrence from the
   deletion rule;
4. the self-similarity/correspondence lemma that yields a fixed negative shift
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
tree projections. Iterating this equivariance over the full recurrent subtree
is the remaining correspondence step.

## Current verdict

```text
THEOREM31_SOURCE_SIGN_INCONSISTENCY_RECORDED
THEOREM31_DELTA_NORMALIZATION_PROPOSED_NEGATIVE
THEOREM31_FINITE_MODE_RECURRENCE_PROVED
THEOREM31_FIXED_NEGATIVE_INCREMENT_CONTRADICTION_PROVED
THEOREM31_LOCAL_SOURCE_SPLIT_TRANSLATION_EQUIVARIANCE_PROVED
THEOREM31_SELF_SIMILARITY_LEMMA_REQUIRED
EL_TERMINATION_NOT_YET_PROVED
EL_ORDER_INDEPENDENCE_NOT_YET_PROVED
NO_K3_PISTAR_THEOREM_CLAIM
NO_K9_FORMALISATION_AUTHORIZATION
NO_GLOBAL_COLLATZ_CLAIM
```
