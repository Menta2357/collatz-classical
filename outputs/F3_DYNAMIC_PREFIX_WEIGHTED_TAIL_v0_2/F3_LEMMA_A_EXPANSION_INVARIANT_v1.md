# F3_LEMMA_A_EXPANSION_INVARIANT_v1

Status: `GENERIC_INDUCTIVE_INTERFACE_COMPILES_OPERATOR_INSTANTIATION_OPEN`

The ledger carries finite layers indexed by `(depth, state)` and stores the
accumulated window shift as data.  It never materializes paths.  The Lean
module proves two facts:

1. a base layer plus a one-step preservation hypothesis implies the fibre
   bound at every depth by induction;
2. if all layer fibres are pairwise disjoint and lie in the root population,
   the cumulative layer mass is bounded by the root cardinality.

The preservation hypothesis is intentionally exposed rather than assumed from
the numerical matrix.  Instantiating it for `coreTransition`, the three
channels, and the F3 first-hit fibres is the remaining operator-to-fibre
obligation.  No `piStar` growth, rho certificate, or density theorem follows
from this generic interface alone.

The shift field is part of the ledger even though the generic cardinality
bound does not inspect its arithmetic.  This prevents a later instantiation
from silently dropping the window parameter when composing layers.
