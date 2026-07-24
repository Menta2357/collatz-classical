# F3 semantic first-hit gate contract v1

Status: `PAPER_GATE_FROZEN — EXECUTION_AND_FORMALIZATION_NOT_YET_OPEN`

Date: 2026-07-24.

This contract fixes the first falsifiable semantic gate before any attempt to
instantiate the existing abstract operator-to-fibre interfaces.

## 1. Source-first fixed finite block and window

The block endpoint is derived before any first-hit data are inspected.  The
frozen core uses depth `d0 = 5`; the next 3-adic digit therefore has depth
`D_FINE = 6`.  Combining its period `3^6 = 729` with the parity/clipped-`nu2`
reticle of period `4` gives the complete fine period

```text
P_FINE = 4 * 3^6 = 2916.
```

The root `a = 2` is the already declared base exception.  Hence the selection
rule is: take the first half-open interval of length exactly `P_FINE` after
that exception, and then retain the admissible congruence class `a % 3 = 2`.
This gives

The pilot block is

```text
Block0 = {a : Nat | 3 <= a and a < 2919 and a % 3 = 2}.
```

It is represented as the filtered finite interval `Finset.Ico 3 2919`.  The
window is root-dependent and fixed at

```text
y0 = 8,
window0(a) = 2^8 * a.
```

The endpoint `10369` in older experiments was a calibration/holdout split.  It
does not delimit an integral number of periods of length `2916` and is rejected
for this semantic gate.  It was not used to choose the replacement endpoint,
and this replacement is made before execution.  In particular:

```text
NO_BLOCK0_DATA_INSPECTION_BEFORE_FREEZE = true
BLOCK0_REPLACED_SOURCE_FIRST_NO_EXECUTION = true
```

No first-hit output, row count, holdout ratio, success rate or counterexample
was inspected in selecting `[3,2919)`.  No alternate interval, shifted
endpoint, larger `y`, or holdout-derived block may replace these values after
the gate is opened.

For each core state `s`, the initial population is the number of roots in
`Block0` whose arithmetic state code decodes to `s`.  The one-step operator is
the transposed formula-generated core transition with the already frozen
weight vector.

## 2. Fixed first-hit fibres

The child alternatives are exactly the formula-generated retarded,
advanced-direct and advanced-parity-lift channels.  A child is retained only
at its first occurrence.  Sterile and boundary cases are recorded at their
first omission; they may not be silently dropped or charged twice.

For every retained fibre the gate must prove:

1. the exact channel arithmetic and multiplicity;
2. membership in the corresponding parent predecessor population;
3. pairwise disjointness after the first differing child;
4. the declared window inequality;
5. a boundary remainder of at most two roots per complete core-state row.

## 3. Acceptance inequality

With

```text
eta = 202/443,
1 - eta = 241/443,
```

the exact pilot target is

```text
(241/443) *
  weightedMass frozenWeight
    (iteratePush formulaCoreTransition initialBlock 1)
<=
  sum_{a in Block0} sum_{i in retainedIndex(a)}
    card(firstHitFiber(a,i)).
```

Equivalently, the discount may be incorporated definitionally into
`initialBlock`, but it must occur exactly once.  A proof of the undiscounted
inequality is not required, and a later denominator substitution is
forbidden.

The aggregate RHS must be obtained from the actual fibres, not from frozen
row counts, a holdout ratio, or an assumed `operator_to_fibres` field.

## 4. Decision rule

PASS requires the inequality and all five member-wise properties in the
fixed block, with a total declaration audit and no placeholder assumption.
It opens, but does not prove, the uniform-in-`y` induction.

Any explicit root, state, channel or pair of paths violating arithmetic,
membership, disjointness, window control, the two-root boundary bound, or the
acceptance inequality is a counterexample to this architecture and yields:

```text
F3_SEMANTIC_FIRST_HIT_FINITE_COUNTEREXAMPLE_STOP
```

The block, window, discount and resource contract may not be changed in
response.  A new mathematical mechanism would require a separately named
architecture and contract.

## 5. Axiom and scope guard

Every declaration introduced by the eventual first-hit module must appear in
its audit inventory.  Every public theorem in the final dependency cone must
exclude `Lean.ofReduceBool` and `sorryAx`; the admissible profile is a subset
of `[propext, Classical.choice, Quot.sound]`.

```text
NO_SEMANTIC_HOOK_PROVED
NO_OPERATOR_TO_FIBRES_INSTANTIATION
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```
