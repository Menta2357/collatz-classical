# Mazur ND31 Density-Fusion Named Contract v1

Status: `TYPED_CONDITIONAL_CONTRACT_COMPILED_COUNTING_BRIDGES_PENDING`

## Purpose

This contract makes the missing application obligations typed and explicit:

1. `BaseThrough N0 reachesOne`: every positive `n <= N0` reaches one;
2. `SyracuseHitsAtMostSemantics`: an actual Syracuse iterate is `<= N0`;
3. `SyracusePositive`: the attained iterate remains positive;
4. `SyracuseToReachesOneThrough N0`: the typed dynamic bridge back to the
   original input;
5. `coverage_to_odd_ratio`: the finite-counting bridge from pointwise odd
   coverage to the odd-supported ratio inequality;
6. `odd_to_all`: the separate odd-supported to all-natural ratio bridge.

The contract derives pointwise odd-source coverage inside Lean from the first
four obligations. It then consumes the two named counting bridges to produce
the complement estimate. The previous arbitrary `Prop` fields and the global
`cover_of_bridges` callback have been removed.

## Kernel result

`NamedDensityFusionContract.eventual_lower_bound` returns:

```text
0 < rho - q
and
eventually (rho - q <= goodRatio X).
```

`NamedDensityFusionContract.positive_eventual_ratio_lower_bound` packages the
same result as `HasPositiveEventuallyRatioLowerBound`. Neither theorem claims
the existence of a natural-density limit or imports the external Syracuse or
Collatz definitions.

## Current status

The typed revision compiles and passes its separate axiom audit. Its concrete
fields remain uninstantiated. In particular, the following remain open:

- a literal source-facing ND31 ratio adapter with its endpoint theorem;
- a concrete finite `BaseThrough` theorem;
- the source-specific Syracuse positivity and Syracuse-to-reaches-one proofs;
- the pointwise-coverage-to-counting theorem;
- the odd-to-all counting theorem;
- positivity of the instantiated `rho - C * (log N0)^(-d)`;
- a bridge from eventual ratio bounds to `Terras.HasNatDensity`, if that is
  the intended public conclusion.

## Residual circularity audit

The old contract allowed one global `cover_of_bridges` callback over arbitrary
`Prop` fields; that callback has been removed. Lean now derives
`OddSourceCoverage` from the inclusive base and an actual iterate witness.

One interface-level risk remains: `coverage_to_odd_ratio` is still an abstract
counting theorem and an invalid future instance could ignore its
`OddSourceCoverage` argument. This is now isolated to one named obligation.
It is discharged only when instantiated with concrete source counting
definitions and a proof from set inclusion/cardinality monotonicity.

## Non-claims

- no positive-density theorem is asserted;
- no natural-density limit is asserted;
- no external Mazur/ProofAtlas theorem is imported or claimed;
- no global Collatz theorem is asserted.

## Reproduction

```text
lake build CollatzClassical.DensityFusionNamedContract
lake env lean CollatzClassical/DensityFusionNamedContractAxiomAudit.lean
```

The two pointwise semantic lemmas use no axioms. The four contract/filter
theorems use `[propext, Quot.sound]`.
