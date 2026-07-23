# Mazur ND31 / F3 Reuse Gap Audit v1

Status: `F3_COMPONENTS_REUSABLE_NOT_ASSEMBLED`

## Scope

This is a read-only inventory of the F3 branch
`codex/f3-density-capture-gate` at commit
`310c1e9f2c2afaa7f28e38b98b59c156e2499962`. It does not merge that branch,
change `master`, or claim that its components prove natural density.

## Reusable components

| Component | What is proved | Reuse status |
| --- | --- | --- |
| `F3ReturnExcursionSemanticBridge` | Member-wise retarded, advanced-direct, and parity-lift injections; subset/cardinality bridges | Reusable local bridge |
| `F3ReturnExcursionFirstHitFibers` | First-hit filtering, disjointness, and containment in a parent `piStarFinset` | Reusable finite accounting |
| `F3ReturnExcursionFiberAccounting` | Pairwise-disjoint fibre sums are bounded by a root population | Reusable finite accounting |
| `F3ReturnExcursionSemanticRenewalBridge` | Conditional operator-mass-to-`piStar` conversion and exponential mass lower bound | Reusable only with witness fields |
| `F3ReturnExcursionRenewalInterface` | Conditional leakage recurrence and `qStar` renewal lower bound | Reusable only with leakage certificate |
| `F3ReturnExcursionM0ACertificate` | Finite rational checker for the frozen M0-a certificate | Reusable certificate checker |
| `F3ReturnExcursionLemmaAExpansionInvariant` | Conditional layer induction and cumulative fibre accounting | Reusable induction brick |

## Open obligations for the density-fusion goal

1. **Finite base:** construct the actual `baseBelow` proof for a concrete
   threshold, covering every positive `n < N0`, not merely root membership.
2. **F3 coverage:** supply witnesses for every frozen row and prove the
   operator-to-contribution inequality; the existing interfaces keep these
   obligations explicit.
3. **Leakage:** construct a real `LeakageCertificate` from the stopped-path
   data rather than choosing `qStar` by declaration.
4. **Dynamics:** prove the bounded Syracuse hit to reaches-one bridge using
   the finite base theorem.
5. **Counting:** instantiate the source ND31 ratio and prove the natural
   endpoint bridge with the source's inclusive/semi-open convention.
6. **Public density:** prove the odd-supported and odd-to-all counting
   theorems needed to move from eventual ratio bounds to the selected public
   density statement.
7. **Positivity:** discharge the concrete inequality
   `0 < rho - C * (log N0)^(-d)` with an explicit, source-backed `C` and
   threshold.

## Current conclusion

The F3 branch supplies substantial finite semantic machinery, but it is not
yet the `baseBelow` theorem or the density theorem required by the named
Mazur contract. The correct next implementation target is the smallest
concrete base certificate; until then the status remains:

```text
CONDITIONAL_CONTRACT_COMPILED
F3_COMPONENTS_REUSABLE_NOT_ASSEMBLED
NO_NATURAL_DENSITY_THEOREM
NO_POSITIVE_DENSITY_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```

## Reproduction

The F3 inventory was read from the cited branch without modifying it. The
Mazur custody branch verifies its own contract with:

```text
lake build CollatzClassical.DensityFusionNamedContract
lake env lean CollatzClassical/DensityFusionNamedContractAxiomAudit.lean
```
