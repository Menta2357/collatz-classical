# Mazur ND31 Density-Fusion Named Contract v1

Status: `CONDITIONAL_CONTRACT_COMPILED_BRIDGES_UNINSTANTIATED`

## Purpose

This contract makes the three missing application obligations explicit:

1. `baseBelow`: a finite theorem covering the chosen threshold `N0`;
2. `syracuseToReachesOne`: the dynamic bridge from a bounded Syracuse hit to
   a witness that reaches `1`, using the finite base theorem;
3. `oddToAll`: the bridge from the odd-supported count to the public
   all-natural count.

The contract requires these obligations to produce the complement estimate
`rho - badRatio X <= goodRatio X`. It then reuses the already compiled,
generic subtraction theorem. This is a conditional interface, not a proof
that any of the three obligations is available.

## Kernel result

`NamedDensityFusionContract.eventual_lower_bound` returns:

```text
0 < rho - q
and
eventually (rho - q <= goodRatio X).
```

`NamedDensityFusionContract.positive_eventual_ratio_lower_bound` packages the
same result as `HasPositiveEventuallyRatioLowerBound`. Neither theorem claims
the existence of a natural-density limit, nor does either theorem mention
Syracuse or Collatz definitions.

## Current status

The module compiles in the isolated custody worktree and is audited
separately. The fields remain abstract and uninstantiated. In particular,
the following are still open:

- a literal source-facing ND31 ratio adapter with its endpoint theorem;
- a concrete finite `baseBelow` theorem;
- the Syracuse-to-reaches-one proof;
- the odd-to-all counting theorem;
- positivity of the instantiated `rho - C * (log N0)^(-d)`;
- a bridge from eventual ratio bounds to `Terras.HasNatDensity`, if that is
  the intended public conclusion.

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
