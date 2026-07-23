# F3 three-lift stopped-path instance v1

Status: `THREE_CHANNEL_STOPPED_PATH_INSTANCE_PASS_OPERATOR_COMPARISON_OPEN`.

This artifact instantiates one stopped-path layer over the actual `piStar`
finite set.  The index type has three declared channels:

- `retarded`, using the first-hit predecessor `2a` in the retarded source;
- `advancedDirect`, active when `c % 3 = 2`;
- `parityLift`, active when `c % 3 = 1`.

The remaining residue case has an empty fibre at this layer.  Each active
advanced fibre is defined by the existing first-hit source, while the
retarded fibre is filtered by `FirstHitThrough`.  Lean verifies the generic
first-hit predecessor disjointness, the three channel fibres are pairwise
disjoint, every fibre is included in the root `piStarFinset a x`, and the
boundary is definitionally the exact set remainder.  Consequently the
retained mass plus boundary mass equals the root mass for the instantiated
layer.

The compile and axiom-audit logs are stored beside this report.  The audit
uses only the repository's accepted classical foundations (`propext`,
`Classical.choice`, `Quot.sound`).

Scope boundary: this is a concrete one-layer semantic instance.  It does not
prove global composed-path disjointness across all depths, the
operator-to-retained-mass comparison, a uniform renewal inequality, a rho
certificate, a density theorem, an almost-all statement, or a global Collatz
claim.  Those remain the open mathematical gate.
