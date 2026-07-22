# KL2003 K11 maintainability acceptance record v1

Date: 2026-07-22

## Decision

The k=11 theorem remains kernel-proved and publicly custodied. The
maintainability asterisk is accepted as an explicit project decision:

```text
K11_THEOREM_KERNEL_PROVED = true
K11_RESOURCE_BUDGET_ARCHITECTURE_FAIL = true
K11_MAINTAINABILITY_ASTERISK_ACCEPTED = true
```

The predeclared checker budget remains unchanged:

```text
PASS <= 1320 s
FAIL > 1800 s
```

The previously controlled full recovery measured `5286.696696 s`, hence the
architecture remains a budget failure. The one-line proof-script optimization
was applied globally to all 81 generated checker shards and did not change the
certificate, rows, theorem statements, or audit claims.

## Four governance fields

### Reason

K11 is the terminal theorem of the KL2003 table and is verified once, then
archived as a citable kernel-checked artifact. The recurring cost is paid by
future rebuilds, so it is recorded rather than hidden behind an informal
caveat.

### Numbers

The best valid post-optimization measurement is the previously completed
controlled build of the heavy shard:

```text
target = CollatzClassical.KL2003.KL2003K11CertificateMatchShard77
baseline_elapsed_seconds = 382.333903
optimized_elapsed_seconds = 211.37
single_shard_reduction = 44.7%
```

The complete post-optimization cold total is **not available**. Two clean-up
and rerun attempts were classified as environmental/non-comparable rather than
silently folded into a total:

```text
data-cache reconstruction: 81/81 data shards eventually rebuilt
four-worker MatchShard00..03 rerun: all timed out at approximately 450.2 s
sequential MatchShard77 rerun: TIMEOUT at 450.080 s
free disk at sequential rerun start: 12.141 GiB
```

The previous complete controlled total remains the only complete total:

```text
controlled_recovery_total_seconds = 5286.696696
```

Thus this record does not claim a fabricated post-optimization total or a
maintainability PASS. The full cold rerun is classified
`K11_FULL_COLD_RERUN_NOT_REPRODUCIBLE_IN_CURRENT_ENVIRONMENT`.

### Decision

Accept the `ARCHITECTURE_FAIL` as a declared maintainability asterisk. Keep
the optimized proof script and generated sources as the best measured variant,
while retaining the budget failure in the public ledger and fidelity package.

### Exit condition

Reopen the budget only if a separately scoped engineering project introduces a
verified arithmetic checker, a different rational representation, or a finer
sharding/CI policy with a fresh predeclared budget. No further micro-tuning is
implicitly promised by this record.

## Scope and guardrails

The optimization changed only generated proof closure syntax from generic
simplification to explicit trivial conjunction proofs. It did not change the
K11 certificate data, theorem statements, source rows, endpoints, or axioms.
The direct-branch structural alternative was measured and rejected because its
representative shard did not finish within the timebox (`6:52.59` before
interrupt).

```text
K11_TIMEBOX_OPTIMIZATION_PARTIAL_PASS
K11_SLOWEST_SHARD_IMPROVED
K11_DIRECT_BRANCH_ARCHITECTURE_REJECTED
K11_RESOURCE_BUDGET_ARCHITECTURE_FAIL_ACCEPTED
K11_FULL_COLD_RERUN_NOT_REPRODUCIBLE_IN_CURRENT_ENVIRONMENT
NO_THEOREM_STATEMENT_CHANGED
NO_CERTIFICATE_DATA_CHANGED
NO_GLOBAL_COLLATZ_CLAIM
```
