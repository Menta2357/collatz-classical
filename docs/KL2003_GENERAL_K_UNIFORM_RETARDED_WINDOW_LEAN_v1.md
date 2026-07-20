# KL2003 general-k uniform retarded window in Lean

Date: 2026-07-20

## Scope

This module converts the uniform selected-depth theorem into the uniform
retarded-shift window required by a general-k lower-bound induction.

For a fixed critical-depth bound, `AllTerminalWalkLengthLe` proves that every
terminal leaf in every finite scheduler run has source-walk length at most
`bound + 1`. Exact source genealogy is then transported through
`ProvenancedTree.normalExpr` and through an arbitrary
`ELExpr.CriticalAssignment.selectedExpr`.

The module serializes every bounded source walk as a `PackedSourceAction` list.
The set of negative evaluated weights at length at most `bound + 1` is finite
and nonempty; the one-step retarded action contributes the value `2`. Its exact
minimum and maximum define `uniformMu` and `uniformNu`. Every selected negative
leaf therefore satisfies

```text
-uniformNu <= shift <= -uniformMu,
```

with `0 < uniformMu <= uniformNu`.

The public theorem is:

```lean
exists_uniform_sourceELRetardedWindow
    (roots : GeneralKClassRootsNonempty (p + 1)) :
    exists (mu nu : Real),
      0 < mu /\ mu <= nu /\
        forall (mode : TrackedMode (p + 1)) (y : Real), 2 <= y ->
          forall witness : SourceELRetardedWitness hp (zeroRootLabel mode) y,
            witness.assignment.selectedExpr.toRetardedExpr.ShiftsWithin mu nu
```

## Boundary

This theorem closes the uniform shift-window extraction. It does not yet feed
the pointwise, y-dependent selected expression into the existing generic
retarded induction, whose `GenericRetardedInputs.row` is currently static in
`y`. The next module must provide the source-faithful dynamic-row consumer (or
an equivalent pointwise-row induction), then instantiate the checked k=3 LNT
certificate.

No canonical EL normal form is assumed. No k=3 piStar theorem, k=9 theorem, or
global Collatz claim is made here.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKUniformRetardedWindow
lake env lean CollatzClassical/KL2003/KL2003GeneralKUniformRetardedWindowAxiomAudit.lean
```

Classifications:

```text
ALL_TERMINAL_DEPTH_BOUND_PROVED
SELECTED_LEAF_BOUNDED_PROVENANCE_PROVED
FINITE_NEGATIVE_SHIFT_SET_CONSTRUCTED
UNIFORM_MU_POSITIVE_PROVED
UNIFORM_RETARDED_SHIFT_WINDOW_PROVED
CANONICAL_EL_NORMAL_FORM_NOT_ASSUMED
DYNAMIC_RETARDED_CONSUMER_NOT_YET_PROVED
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_FORMALISATION_NOT_AUTHORIZED
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
