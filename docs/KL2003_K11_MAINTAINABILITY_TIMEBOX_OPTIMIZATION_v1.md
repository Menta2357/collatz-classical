# KL2003 K11 maintainability timebox optimization v1

Date: 2026-07-21

## Scope

This note records the first short, bounded optimization pass after the k=11
`piStar` theorem was kernel-proved and custodied with:

```text
K11_RESOURCE_BUDGET_ARCHITECTURE_FAIL
K11_MAINTAINABILITY_OPTIMIZATION_STILL_OPEN
```

The pass does not change the k=11 certificate, rows, auxiliary data, endpoint
bounds, `ClassRoots`, or theorem statements. It only changes the generated
checker proof script for row/auxiliary facts.

## Baseline

The predeclared real-checker budget was:

```text
PASS <= 1320 s
FAIL > 1800 s
```

The custodied controlled recovery measurement was:

```text
controlled_recovery_total_seconds = 5286.696696
checker_recovery_elapsed_seconds = 5241.331924
slowest_attempted_checker_seconds = 382.333903
slowest_attempted_checker = KL2003K11CertificateMatchShard77
```

Therefore the baseline remains:

```text
K11_RESOURCE_BUDGET_ARCHITECTURE_FAIL
```

## Optimization attempted

The original generated row and auxiliary facts closed residual goals by:

```lean
norm_num1
simp
```

After `norm_num1`, the remaining goals are conjunctions of `True`, e.g.
`True /\ True /\ True`. The timebox replaced the generic simplifier with an
explicit proof of the residual conjunction:

```lean
norm_num1
exact <trivial-conjunction>
```

For row facts:

```lean
exact <; row conjunction of three trivial components>
```

For auxiliary facts:

```lean
exact <; auxiliary conjunction of four trivial components>
```

The generated Lean uses the concrete syntax:

```lean
exact ⟨trivial, trivial, trivial⟩
exact ⟨trivial, trivial, trivial, trivial⟩
```

## Measurement

Representative heavy shard:

```text
target = CollatzClassical.KL2003.KL2003K11CertificateMatchShard77
baseline_elapsed_seconds = 382.333903
optimized_elapsed_seconds = 211.37
status = PASS
```

This is a real local improvement on the worst previously measured shard:

```text
single_shard_ratio = 0.5528413733
single_shard_wall_time_reduction ~= 44.7%
```

The optimization is not enough by itself to discharge the maintainability gate.
Even if the same ratio held across the previous per-shard measurements, the
rough projected serial shard total would remain far above the predeclared
`1800 s` failure threshold.

## Negative micro-test

A more aggressive direct decision-procedure attempt was tested:

```lean
theorem test_row_56133 : K11RowValid 56133 := by
  decide
```

Lean did not synthesize a `Decidable` instance for the `Rat` proposition in the
current formulation, so this route is not a short-pass optimization.

## Structural pass attempted

The second short pass tested a structural simplification: remove all generated
per-row and per-auxiliary theorem declarations inside each shard, and instead
prove each `interval_cases` branch directly inside the shard dispatcher theorem.

This reduced generated checker source size:

```text
individual-theorem optimized source bytes = 49,421,928
direct-branch source bytes = 37,964,556
```

However, the representative heavy shard did not finish within the timebox:

```text
target = CollatzClassical.KL2003.KL2003K11CertificateMatchShard77
direct-branch elapsed before interrupt = 6:52.59
baseline elapsed = 382.333903 s
individual-theorem optimized elapsed = 211.37 s
status = INTERRUPTED / REJECTED
```

Thus the direct-branch architecture is worse for the Lean elaborator despite
having smaller source. The likely reason is that one enormous theorem body is
less manageable than many small theorem declarations plus a thin dispatcher.

## Verdict

```text
K11_TIMEBOX_OPTIMIZATION_PARTIAL_PASS
K11_SLOWEST_SHARD_IMPROVED
K11_DIRECT_BRANCH_ARCHITECTURE_REJECTED
K11_RESOURCE_BUDGET_ARCHITECTURE_FAIL_STILL_OPEN
K11_FULL_COLD_RERUN_NOT_EXECUTED
NO_THEOREM_STATEMENT_CHANGED
NO_CERTIFICATE_DATA_CHANGED
NO_GLOBAL_COLLATZ_CLAIM
```

## Recommendation

Keep the proof-script simplification as a candidate optimization, but do not
claim maintainability closure from it. The direct-branch structural variant
should not be pursued further.

At this point, a third pass would no longer be a small tweak. It should be
scoped as a new engineering project with a fresh predeclared budget: either a
smaller verified arithmetic checker, a different representation of rational
facts, or finer sharding with an explicit CI policy. If the project does not
want that engineering project now, the honest decision is to accept and
document the k=11 maintainability asterisk.
