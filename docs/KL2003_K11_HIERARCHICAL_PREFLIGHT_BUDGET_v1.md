# KL2003 k=11 Hierarchical Preflight Budget v1

## Purpose

This budget is fixed after the monolithic data module failed and after the
sharded-data component probes passed.  It tests the complete candidate with a
hierarchical `9 x 9` finite dispatcher instead of one linear 81-way chain.

The exact synthetic rational family, the `81` data shards, the local chunk
size `27`, and the `729/243` arithmetic grain are unchanged.

## Candidate layout

1. `81` data shards, compiled with at most three workers.
2. One global data router importing the `81` data shards.
3. One consumer linking values in the last data shard through that router.
4. `81` lightweight checker interfaces.
5. Nine group dispatchers, each routing nine consecutive interfaces.
6. One top dispatcher routing the nine groups and importing the global data
   router.

Every dispatcher proves lower bounds from the preceding failed comparison;
it does not invoke `omega` or another arithmetic tactic.

## Acceptance budget

| Component | PASS | OPTIMIZATION_REQUIRED | ARCHITECTURE_FAIL |
|---|---:|---:|---:|
| 81 data shards, total with 3 workers | `<= 600 s` | `(600, 900] s` | `> 900 s` or failure |
| Slowest data shard | `<= 120 s` | `(120, 180] s` | `> 180 s` or failure |
| Global data router | `<= 180 s` | `(180, 300] s` | `> 300 s` or failure |
| Router-import consumer | `<= 180 s` | `(180, 300] s` | `> 300 s` or failure |
| 81 checker interfaces, 3 workers | `<= 300 s` | `(300, 450] s` | `> 450 s` or failure |
| Nine group dispatchers, 3 workers | `<= 180 s` | `(180, 300] s` | `> 300 s` or failure |
| Top nine-group dispatcher | `<= 180 s` | `(180, 300] s` | `> 300 s` or failure |
| Complete preflight | `<= 1200 s` | `(1200, 1500] s` | `> 1500 s` or failure |

Memory and disk thresholds remain `4096 MiB` per Lean process for PASS,
`6144 MiB` for architecture failure when measurable, and `12 GiB` free disk
before execution.

## Interpretation

A PASS authorizes the real k=11 certificate metrics gate, not the theorem.
The real certificate must still measure absolute and normalized slacks,
rational digits, exact-data size, shard time, aggregate time, and full build
time against the maintained-artifact budget.

## Guardrails

- No real k=11 rows or LP certificate are generated.
- No endpoint theorem is attempted.
- No `gammaK11` or global Collatz claim is made.
- Temporary Lean sources and `.olean` files are deleted after the run.

## Classifications

`K11_HIERARCHICAL_9X9_PREFLIGHT_BUDGET_FIXED_BEFORE_EXECUTION`

`K11_DATA_AND_DISPATCH_COMPILATION_UNITS_SEPARATED`

`K11_REAL_CERTIFICATE_NOT_GENERATED`

`NO_K11_THEOREM_CLAIM`

`NO_GLOBAL_COLLATZ_CLAIM`
