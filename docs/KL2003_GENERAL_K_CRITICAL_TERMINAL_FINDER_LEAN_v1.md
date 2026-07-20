# KL2003 general-k critical terminal finder Lean v1

Date: 2026-07-20

## Result

`KL2003GeneralKCriticalTerminalFinder.lean` closes Layer A of the
critical-guided scheduler plan.

It defines `CriticalExpandableOccurrence`, consisting of an actual
provenanced terminal occurrence together with:

- nonnegative evaluated shift; and
- a proof that the terminal lies on a global critical path at fixed `Phi,y`.

The choice-based `findCriticalExpandableOccurrence` is appropriate because
KL2003 permits arbitrary splitting order. Its exact stopping theorem is:

```lean
findCriticalExpandableOccurrence_eq_none_iff
```

The finder returns `none` exactly when every globally critical terminal has
negative shift. Advanced terminals in globally noncritical subtrees are
intentionally outside this condition.

This module does not perform a split, iterate a scheduler, or prove
termination. It separates semantic critical selection from the existing
Phi-independent left-to-right finder without changing that proven API.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKCriticalTerminalFinder
lake env lean CollatzClassical/KL2003/KL2003GeneralKCriticalTerminalFinderAxiomAudit.lean
git diff --check
```

## Classification

```text
CRITICAL_EXPANDABLE_OCCURRENCE_DEFINED
CRITICAL_TERMINAL_FINDER_DEFINED
CRITICAL_STOPPING_CONDITION_CHARACTERIZED
CRITICAL_GUIDED_SCHEDULER_LAYER_A_PROVED
CRITICAL_SOURCE_STEP_NOT_YET_PROVED
EL_TERMINATION_NOT_YET_PROVED
NO_K3_PISTAR_THEOREM_CLAIM
NO_K9_FORMALISATION_AUTHORIZATION
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
