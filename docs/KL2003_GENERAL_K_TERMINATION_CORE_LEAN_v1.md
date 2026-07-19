# KL2003 general-k termination core in Lean v1

## Scope

This checkpoint formalizes three components of the termination
argument in KL2003 Theorem 3.1:

1. an infinite sequence in the finite type `TrackedMode k` has a mode whose
   fiber is infinite, hence occurrences arbitrarily far out and a strictly
   increasing subsequence of positions carrying that mode;
2. a real sequence with a fixed negative increment is eventually negative and
   therefore cannot remain nonnegative;
3. more generally, if every later occurrence of the same mode loses at least
   one fixed `epsilon > 0`, then some shift is negative.

It also proves the corrected sign implication
`delta = betaTwo - betaOne < 0` from `betaTwo < betaOne`.

## Source calibration

The source at `30apr02.tex:827-849` prints a decreasing sequence of recurring
shifts but then writes `delta = beta_2 - beta_1 > 0`. The compatible sign is
`delta < 0`. The Lean theorem `theorem31_arithmetic_contradiction` checks the
final contradiction using that corrected sign.

This does not silently repair the entire source proof. The module does not
derive that successive recurrent subtrees have one fixed increment. That is
the separate self-similar correspondence obligation identified in the source
scoping note. The uniform-drop theorem weakens what must be derived: exact
self-similarity is unnecessary if a finite transition/cycle argument supplies
one uniform positive loss at repeated modes. That graph-theoretic premise is
not yet proved. The module also does not claim EL termination, order
independence, a canonical normal form, or `SatisfiesEL`.

## Main theorems

- `exists_mode_with_infinite_fiber`
- `exists_recurrent_mode_unbounded`
- `exists_recurrent_mode_subsequence`
- `hasFixedIncrement_closedForm`
- `corrected_delta_negative`
- `exists_negative_of_hasFixedIncrement_of_delta_neg`
- `theorem31_arithmetic_contradiction`
- `exists_negative_of_hasUniformRecurrentDrop`
- `not_forall_nonnegative_of_hasUniformRecurrentDrop`

## Verification

```text
lake env lean CollatzClassical/KL2003/KL2003GeneralKTerminationCore.lean
lake env lean CollatzClassical/KL2003/KL2003GeneralKTerminationCoreAxiomAudit.lean
```

The audited theorems report only `[propext, Classical.choice, Quot.sound]`.

## Classification

```text
GENERAL_K_FINITE_MODE_RECURRENCE_PROVED
THEOREM31_CORRECTED_DELTA_NEGATIVE_PROVED
THEOREM31_FIXED_NEGATIVE_INCREMENT_CONTRADICTION_PROVED
THEOREM31_UNIFORM_RECURRENT_DROP_CONTRADICTION_PROVED
GENERAL_K_TERMINATION_CORE_AXIOM_AUDIT_PASS
THEOREM31_SELF_SIMILARITY_CORRESPONDENCE_NOT_YET_PROVED
THEOREM31_UNIFORM_DROP_FROM_ADMISSIBLE_CYCLES_NOT_YET_PROVED
GENERAL_K_FULL_EXPANSION_DELETION_TERMINATION_NOT_YET_PROVED
GENERAL_K_EL_ORDER_INDEPENDENCE_NOT_YET_PROVED
SATISFIES_EL_NOT_YET_PROVED
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_FORMALISATION_NOT_AUTHORIZED
NO_GLOBAL_COLLATZ_CLAIM
```
