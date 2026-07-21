# KL2003 K11 Real Lean Checker Result v1

Date: 2026-07-21

## Scope

This note records the real Lean checker run for the k=11 LNT candidate emitted in:

- `outputs/KL2003_F2_K11_LNT_MEASUREMENT_v1/kl2003_k11_lnt_certificate.candidate.json`
- `scripts/kl2003_k11_real_lean_checker_v1.py`
- `scripts/kl2003_k11_real_lean_checker_build_v1.py`

The checker validates the row and auxiliary rational facts used by the k=11 candidate data. At the time of this gate it did not declare `LNTCertificate`, did not prove a k=11 `piStar` theorem, and did not make a global Collatz claim.

Postscript: the later theorem assembly closes `k11LNTCertificate` and
`exists_k11_piStar_arbitrary_x_lower_bound`. The resource-budget conclusion of
this note remains valid: the k=11 checker is kernel-correct but exceeds the
original maintainability budget.

## Result

Verdict:

```text
K11_REAL_LEAN_CHECKER_KERNEL_PASS_RESOURCE_COLD_RERUN_REQUIRED
```

Kernel status:

```text
all_rows_kernel_checked = true
all_auxiliary_kernel_checked = true
checker_shard_pass_count = 81
failed_shard_count = 0
post_failure_count = 0
```

The generated checker compiled all 81 checker shards, all 9 group dispatchers, the aggregate dispatcher, and the aggregate axiom audit.

## Build Metrics

Command:

```text
python3 scripts/kl2003_k11_real_lean_checker_build_v1.py --workers 4 --attempt-all --shard-timeout 600
```

Summary:

```text
controlled_recovery_total_seconds = 5286.696696
checker_recovery_elapsed_seconds = 5241.331924
group_elapsed_seconds = 30.109483
aggregate_elapsed_seconds = 5.016909
audit_elapsed_seconds = 10.2245
slowest_attempted_checker_seconds = 382.333903
generated_olean_count = 174
generated_olean_bytes = 1184357912
free_disk_gib_at_start = 26.136
```

Important caveat: this was a controlled recovery run, not a clean cold run. Several shards had already been rebuilt during pilot measurements after source regeneration. The kernel result is valid, but the resource budget still requires a clean controlled rerun if the project needs a fully cold resource number.

## Optimization Applied

The first generated checker used `norm_num` for each row and auxiliary fact. Pilot measurements showed that this was too slow for the k=11 budget.

The generator was changed to emit:

```lean
norm_num1
simp
```

This reduced the observed clean pilot for `Shard07` from `377.24 s` to `93.119 s`, and `Shard08` from `111.47 s` to `97.670 s` in the controlled runner.

The optimization was sufficient for a full kernel PASS, but not sufficient for the original maintenance budget.

## Axiom Audit

Command:

```text
lake env lean CollatzClassical/KL2003/KL2003K11CertificateMatchAggregateAxiomAudit.lean
```

Output:

```text
'CollatzClassical.KL2003.K11CertificateMatch.k11_all_rows_valid' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
'CollatzClassical.KL2003.K11CertificateMatch.k11_all_auxiliary_valid' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```

This is the expected mathlib/Lean axiom profile for the generated checker.

## Budget Classification

The predeclared budget was:

```text
PASS <= 1320 s
FAIL > 1800 s
```

The measured controlled recovery run took `5286.696696 s`. Therefore:

```text
KERNEL_VERIFICATION_PASS
RESOURCE_BUDGET_ARCHITECTURE_FAIL
COLD_RESOURCE_RERUN_REQUIRED_IF_CLAIMING_MAINTAINABLE_BUILD_TIME
```

The k=11 data is checkable by Lean in the current architecture, but the architecture is not yet acceptable as a maintained high-k theorem pipeline under the original budget.

## Next Engineering Target

The next target is not mathematical. It is a checker architecture target:

1. Keep the generated data and rational certificate unchanged.
2. Replace per-row tactical rational proofs with a smaller verified arithmetic checker, or otherwise reduce elaboration cost.
3. Re-run the k=11 checker under the predeclared budget.
4. Only after a resource PASS, proceed to declaring the k=11 certificate object and theorem-level consumer.

## Guardrails

```text
LNT_CERTIFICATE_DECLARED_AT_THIS_GATE = false
K11_THEOREM_CLAIMED_AT_THIS_GATE = false
LNT_CERTIFICATE_DECLARED_LATER = true
K11_THEOREM_PROVED_LATER = true
GLOBAL_COLLATZ_CLAIMED = false
```

Classifications:

```text
K11_REAL_LEAN_CHECKER_KERNEL_PASS
K11_REAL_LEAN_CHECKER_RESOURCE_BUDGET_ARCHITECTURE_FAIL
K11_REAL_LEAN_CHECKER_COLD_RERUN_REQUIRED
K11_ROW_AND_AUXILIARY_FACTS_KERNEL_CHECKED
K11_AGGREGATE_AXIOM_AUDIT_PASS
LNT_CERTIFICATE_NOT_DECLARED
K11_THEOREM_NOT_CLAIMED
NO_GLOBAL_COLLATZ_CLAIM
```
