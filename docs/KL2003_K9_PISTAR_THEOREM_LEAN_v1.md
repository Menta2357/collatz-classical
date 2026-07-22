# KL2003 k=9 piStar theorem in Lean v1

## Result

The k=9 LNT certificate and its semantic consumer are proved in Lean.
The public theorem is:

```lean
exists_k9_piStar_arbitrary_x_lower_bound :
  exists Delta : Real, 0 < Delta /\
    forall (mode : TrackedMode 9) (a : ClassRootsK 9 mode) (x : Nat),
      a.1 <= x ->
      Delta * (((x : Real) / (a.1 : Real)) ^ gammaK9) <=
        (piStar a.1 x : Real)
```

Here

```lean
gammaK9 = Real.logb 2 (70461 / 40000)
```

and Lean proves both

```lean
gammaK9_gt_four_fifths
gammaK9_gt_forty_nine_sixtieths
gammaK9_gt_eighty_one_hundredths
```

The decimal `0.816824950064...` is explanatory only. The theorem uses the
exact rational base and exact real logarithm.

## Benchmark calibration

The named theorem `gammaK9_gt_eighty_one_hundredths` proves an exact
comparison with the exponent `0.81` published by Applegate--Lagarias in 1995.
This is currently a comparison of exponents, not a Lean theorem identifying
the two counting statements.  The public k=9 theorem uses `ClassRootsK`, its
`NotInCycle` condition, positive natural inputs, and the repository's bounded
path counter `piStar`.  The 1995 statement uses its published `pi_a` counting
function and a different root quantifier.

Accordingly, public wording is restricted to:

```text
The formalized k=9 exponent exceeds the Applegate--Lagarias 1995 benchmark
0.81.
```

The package does not claim that a literal statement-to-statement corollary has
already been formalized, that this is the current mathematical record (the
KL2003 k=11 row is larger), or that this is the first such formalization in the
world.  The bridge and any priority audit are scoped separately in
`docs/KL2003_K9_AL1995_COMPARISON_BRIDGE_SCOPING_v1.md`.

## Certificate checking

The exact candidate contains:

- 6561 principal coefficients and row inequalities;
- 2187 auxiliary coefficients with three lift inequalities each;
- exact rational row slacks, all checked in Lean;
- exact lower endpoints for the advanced coefficients.

The generated checker is split into nine shards. Each shard proves 729 row
facts and 243 auxiliary facts. `KL2003K9CertificateMatchAggregate.lean`
dispatches the finite universal statements without repeating rational
normalization.

Measured on the final stable modules:

- nine-shard build plus dependencies: 343.02 seconds wall clock;
- isolated aggregate after shard build: 1.61 seconds;
- project budget: 1320 seconds total, 450 seconds maximum per shard.

The discarded array-expansion design reached deterministic timeout at 732.35
seconds for one shard. The accepted match-dispatch design checks the same
linked data inside budget.

## Real endpoints

`KL2003K9EndpointBounds.lean` proves:

```lean
((bLower : Rat) : Real) <= lambdaR9 ^ (alpha - 2)
((dLower : Rat) : Real) <= lambdaR9 ^ (alpha - 1)
((aCoeff : Rat) : Real) = lambdaR9 ^ (-2 : Real)
```

The advanced endpoint uses the exact witness `569/359 < alpha`. The weaker
historical bound `19/12 < alpha` is insufficient for this k=9 endpoint.

## Semantic chain

The final theorem consumes:

1. `k9_all_rows_valid` and `k9_all_auxiliary_valid`;
2. `k9LNTCertificate : LNTCertificate (p := 8)`;
3. `k9_classRoots_nonempty`;
4. the reviewed general-k feasibility and dynamic-retarded chain;
5. the `sourcePhiK` to `piStar` member bound;
6. `y = logb 2 (x/a)` to obtain arbitrary natural windows `x >= a`.

No generated Python result is trusted as a proof. Python emits exact data and
Lean source; Lean rechecks all rational inequalities and the semantic
composition.

## Reproduction

```text
python3 -m py_compile scripts/kl2003_f2_k9_match_dispatch_pilot_v1.py
python3 scripts/kl2003_f2_k9_match_dispatch_pilot_v1.py --all-shards
lake build CollatzClassical.KL2003.KL2003K9PiStarTheorem
lake env lean CollatzClassical/KL2003/KL2003K9EndpointBoundsAxiomAudit.lean
lake env lean CollatzClassical/KL2003/KL2003K9LNTCertificateAxiomAudit.lean
lake env lean CollatzClassical/KL2003/KL2003K9PiStarTheoremAxiomAudit.lean
```

The `#print axioms` profile of the audited theorems is exactly:

```text
[propext, Classical.choice, Quot.sound]
```

This is an axiom profile, not the whole trusted computing base.  Lean's kernel
remains trusted.  The reported `343.02` seconds are total Lean build/checking
wall time, not kernel-only execution time.

## Classification

```text
K9_MATCH_DISPATCH_CERTIFICATE_CHECKED
K9_LNT_CERTIFICATE_PROVED
K9_REAL_ENDPOINTS_PROVED
K9_SOURCEPHIK_LOWER_BOUND_PROVED
K9_PISTAR_SOURCE_WINDOW_LOWER_BOUND_PROVED
K9_PISTAR_ARBITRARY_X_LOWER_BOUND_PROVED
GAMMA_K9_GT_FORTY_NINE_SIXTIETHS_PROVED
GAMMA_K9_GT_EIGHTY_ONE_HUNDREDTHS_PROVED
AL1995_EXPONENT_BENCHMARK_EXCEEDED
AL1995_LITERAL_STATEMENT_BRIDGE_NOT_YET_PROVED
WORLD_FIRST_PRIORITY_NOT_CLAIMED
NO_K11_THEOREM_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```

This is a k=9 counting lower bound. It is not a k=11 theorem, not a proof of
the `0.8418` endpoint in the KL2003 table, and not a proof of the global
Collatz conjecture.

## Integration artifact custody pointer

The emitted nine-shard integration experiment is preserved separately under
`docs/KL2003_F2_K9_LEAN_INTEGRATION_CUSTODY_v1.md`. Its exact path/hash
manifest is `outputs/KL2003_F2_K9_LEAN_INTEGRATION_v1/manifest_sha256.csv`;
the manifest was rechecked before custody and is not evidence replacing the
accepted match-dispatch theorem.
