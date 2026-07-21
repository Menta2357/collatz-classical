# KL2003 k=11 Preflight Budget and Architecture Gate v1

## Purpose

This gate fixes the resource budget before any real k=11 certificate is
generated.  It measures the architecture that would actually be maintained:

- `59049` principal rows and `19683` auxiliary groups;
- `81` arithmetic shards, each with `729` principal rows and `243` auxiliary
  groups;
- chunked exact data with chunk size `27`;
- one finite range dispatcher importing the `81` shards.

A monolithic `match` with `59049` branches is deliberately excluded.  It is
not the architecture used at k=9 and a failure of that artificial object
would not be evidence against the proposed k=11 design.

This document is the pre-execution budget.  The measurement runner records
its SHA256 so that later results cannot silently redefine the acceptance
thresholds.

## Three preflight probes

1. `K11_CHUNKED_DATA_PROBE`: elaborate synthetic exact-rational tables at the
   k=11 dimensions, using the k=9 chunk and shard geometry.
2. `K11_REPRESENTATIVE_SHARD_PROBE`: recheck one real k=9 match-dispatch shard
   containing `729` row facts and `243` auxiliary facts.  This is the existing
   exact-arithmetic control for the fixed shard grain; it is not a k=11
   arithmetic certificate.
3. `K11_81_SHARD_AGGREGATE_PROBE`: compile `81` generated shard interfaces and
   a range dispatcher importing all of them.  The interfaces depend on the
   k=11-scale data module, so the probe measures import pressure and the
   finite `by_cases` chain without inventing a monolithic row match.

The generator and the synthetic modules are not trusted.  A passing preflight
is an engineering result only and proves no k=11 inequality.

## Preflight acceptance budget

| Probe | PASS | OPTIMIZATION_REQUIRED | ARCHITECTURE_FAIL |
|---|---:|---:|---:|
| Chunked data elaboration | `<= 300 s` | `(300, 450] s` | `> 450 s` or failure |
| Representative exact shard | `<= 450 s` | `(450, 600] s` | `> 600 s` or failure |
| 81-shard aggregate | `<= 180 s` | `(180, 300] s` | `> 300 s` or failure |
| Entire synthetic preflight | `<= 900 s` | `(900, 1200] s` | `> 1200 s` or failure |

Peak resident memory is measured when the host permits `ps` sampling:

- `PASS`: at most `4096 MiB` for any one Lean process;
- `OPTIMIZATION_REQUIRED`: above `4096 MiB` and at most `6144 MiB`;
- `ARCHITECTURE_FAIL`: above `6144 MiB` or process termination from memory
  pressure.

The probe must start with at least `12 GiB` free disk.  Its temporary Lean
sources and `.olean` files are generated below `/tmp` and removed after the
run.

## Future real-certificate budget

These thresholds govern the later k=11 checker, not the synthetic preflight:

| Maintained operation | Acceptance target |
|---|---:|
| Cold source-tree build, at most three Lean workers | `<= 4200 s` |
| Slowest arithmetic shard | `<= 450 s` |
| Chunked exact-data elaboration | `<= 300 s` |
| Aggregate rebuild after shards exist | `<= 180 s` |
| Incremental rebuild of one touched shard | `<= 450 s` |
| Parallel CI wall time with warm dependencies | `<= 1800 s` |
| Generated source plus `.olean` footprint | `<= 2.5 GiB` |

Interpretation for the cold build:

- `PASS`: at most `4200 s`;
- `OPTIMIZATION_REQUIRED`: above `4200 s` and at most `5400 s`;
- `ARCHITECTURE_FAIL`: above `5400 s`, any shard timeout, or any checker that
  relies on trusted generated execution.

A roughly one-hour cold rebuild is accepted only as the upper edge of a
maintained artifact.  Routine CI must use shard-level caching or parallelism
and stay within the separate `1800 s` target.  A one-off successful build that
cannot meet the incremental and CI budgets does not authorize k=11.

## Later certificate metrics

No two-point "slack curve" is extrapolated from k=3 and k=9.  The real k=11
generator must report, before endpoint work begins:

- minimum absolute row slack;
- minimum normalized row slack, with the normalization stated;
- maximum numerator and denominator digits;
- generated JSON, Lean source, and `.olean` sizes;
- generator time and exact-checker time.

The k=3 and k=9 measurements are comparison points, not a predictive model.

## Trust and claim guardrails

- No real k=11 rows or LP certificate are generated in this gate.
- No `LNTCertificate` is declared.
- No `gammaK11` theorem is claimed.
- No global Collatz claim is made.
- The existing untracked k=9 experimental verifier shards are outside this
  gate and must not be imported, modified, staged, or deleted.

## Classifications

`K11_PREFLIGHT_BUDGET_FIXED_BEFORE_EXECUTION`

`K11_REAL_ARCHITECTURE_THREE_PROBE_GATE_DEFINED`

`K11_MONOLITHIC_59049_MATCH_REJECTED_AS_NONREPRESENTATIVE`

`K11_MAINTAINED_BUILD_BUDGET_DEFINED`

`K11_REAL_CERTIFICATE_NOT_GENERATED`

`NO_K11_THEOREM_CLAIM`

`NO_GLOBAL_COLLATZ_CLAIM`
