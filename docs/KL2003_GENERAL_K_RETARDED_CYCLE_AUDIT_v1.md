# KL2003 general-k positive retarded-cycle audit v1

## Scope

This audit checks whether the termination consumer may require every closed
factor of an extracted general-`k` source branch to have negative evaluated
weight.  The answer is no.

The Lean module
`CollatzClassical/KL2003/KL2003GeneralKRetardedCycleAudit.lean` constructs the
typed `k = 5` source cycle

```text
242 --D3--> 161 --D3--> 107 --D3--> 152 --D3--> 182 --retarded--> 242.
```

All five target equalities are kernel-checked.  Its symbolic weight is

```text
4 * alpha - 6,
```

which is positive by the existing rational lower bound for `alpha`.
Consequently Lean proves that this cycle is not `ContextAdmissible`.

## Consequence

`AllSegmentsContextAdmissible` is a valid conditional API, but it is not a
source-faithful invariant of the general-`k` scheduler and cannot be used as
the missing bridge in Theorem 3.1.

This does not contradict the deletion argument.  A second traversal would
arrive at mode `161` through an advanced edge with a larger shift, so that
leaf has the first occurrence as a deletion witness.  The replacement
termination argument must therefore reason about recurrent advanced arrivals
and deletion, rather than demand negativity of every first traversal.

## Empirical orientation

The generated saturated trees for `k = 2`, `k = 3`, and `k = 4` contain no
advanced minimum with three simultaneous deletion witnesses.  Their observed
deletion-count histograms are respectively:

```text
k=2: {0: 1, 1: 2}
k=3: {0: 33, 1: 6, 2: 2}
k=4: {0: 5399, 1: 299, 2: 149}
```

This evidence is not a general theorem.  The triple-witness exclusion remains
an explicit proof obligation for the advanced-arrival termination route.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKRetardedCycleAudit
lake env lean CollatzClassical/KL2003/KL2003GeneralKRetardedCycleAuditAxiomAudit.lean
```

No theorem in this audit claims k=3, k=9, k=11, full M1, or global Collatz.

## Classification

```text
GENERAL_K_POSITIVE_RETARDED_CYCLE_PROVED
ALL_SEGMENTS_CONTEXT_ADMISSIBLE_NOT_A_SCHEDULER_INVARIANT
ADVANCED_ARRIVAL_TERMINATION_ROUTE_REQUIRED
TRIPLE_WITNESS_EXCLUSION_STILL_OPEN
NO_K3_PISTAR_THEOREM_YET
NO_K9_FORMALIZATION
NO_GLOBAL_COLLATZ_CLAIM
```
