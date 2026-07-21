# KL2003 k=11 Sharded-Data Preflight Budget v1

## Purpose

The first k=11 preflight rejected one monolithic chunked-data module after the
predeclared `450 s` timeout.  This addendum fixes the budget for a distinct
candidate before it is run: shard the data compilation unit into the same
`81` ranges used by the arithmetic checker.

This experiment does not alter or supersede the failed result.  It tests the
specific optimization implied by that result.

## Candidate layout

- `81` exact-data shard modules;
- per shard: `729` principal values, `243` auxiliary values, and `729` row
  slacks;
- local chunk size `27`;
- one thin data router importing all `81` data shards;
- one consumer stub importing the router;
- `81` lightweight checker interfaces and one range-dispatch aggregate.

The synthetic rational literals use the same deterministic family as the
failed probe.  The data are split, not weakened.

## Acceptance budget

| Component | PASS | OPTIMIZATION_REQUIRED | ARCHITECTURE_FAIL |
|---|---:|---:|---:|
| 81 data shards, 3 workers, total wall | `<= 600 s` | `(600, 900] s` | `> 900 s` or failure |
| Slowest data shard | `<= 120 s` | `(120, 180] s` | `> 180 s` or failure |
| Global data router | `<= 180 s` | `(180, 300] s` | `> 300 s` or failure |
| One router-import consumer | `<= 180 s` | `(180, 300] s` | `> 300 s` or failure |
| 81-interface aggregate | `<= 180 s` | `(180, 300] s` | `> 300 s` or failure |
| Whole optimized preflight | `<= 1200 s` | `(1200, 1500] s` | `> 1500 s` or failure |

The memory and disk thresholds remain those of the original gate: `4096 MiB`
per Lean process for PASS, `6144 MiB` as the failure limit when measurable,
and at least `12 GiB` free disk before execution.

## Interpretation

`PASS` permits generation of real k=11 data for the next certificate metrics
gate.  It does not authorize the theorem or prove that exact k=11 rational
digits will fit the same cost envelope.

`OPTIMIZATION_REQUIRED` permits another architecture pass but not real
certificate generation.

`ARCHITECTURE_FAIL` rejects this sharded-data design.  It must not be hidden by
increasing the timeout after execution.

## Guardrails

- No real k=11 certificate or LP is generated.
- No endpoint or `gammaK11` theorem is attempted.
- Generated Lean probes live in `/tmp` and are removed after execution.
- Existing untracked k=9 experiments remain untouched.

## Classifications

`K11_SHARDED_DATA_PREFLIGHT_BUDGET_FIXED_BEFORE_EXECUTION`

`K11_81_DATA_SHARD_LAYOUT_DEFINED`

`K11_REAL_CERTIFICATE_NOT_GENERATED`

`NO_K11_THEOREM_CLAIM`

`NO_GLOBAL_COLLATZ_CLAIM`
