# KL2003 k=11 Sharded-Data Preflight Partial Result v1

## Scope

This records the incomplete run against
`KL2003_K11_SHARDED_DATA_PREFLIGHT_BUDGET_v1.md`.  The data stages completed,
but the final linear 81-interface dispatcher was manually interrupted after
it became the dominant harness cost.  No PASS or FAIL verdict is assigned to
the whole candidate.

## Completed evidence

Across repeated runs the following stages passed their fixed component
budgets:

- `81` data shards with three workers: `178.731 s`, `217.471 s`, and
  `236.040 s` observed total wall times;
- slowest data shard: between `9.164 s` and `24.737 s`, below the `120 s`
  PASS threshold;
- global router: `7.660980 s`, `8.271031 s`, and `13.646089 s` observed;
- last-entry consumer: `4.967518 s`, `6.006635 s`, and `4.356948 s`
  observed.

The variation is environmental and no selected minimum is presented as the
gate result.  The evidence is sufficient to show that splitting the failed
7.8 MB monolithic data source into 81 compilation units removes that specific
timeout.

## Harness corrections

The first partial run reached the interface stage but used a non-cached
`Mathlib.Tactic.Omega` import.  The second confirmed the same data/router
measurements and named that import failure.  The third used the available
umbrella tactic module; all interfaces completed, after which the single
linear chain of 80 range decisions remained elaborating long enough to
dominate the run and was interrupted.

The linear chain is not retained as the proposed architecture.  The next
preflight uses a hierarchical `9 x 9` dispatcher:

- nine group modules, each routing nine fixed-grain shards;
- one top module routing the nine groups;
- no arithmetic tactic is needed for lower bounds, because each failed upper
  comparison yields the next lower bound by `Nat.le_of_not_gt`.

This is a new candidate with a new pre-execution budget.  The interrupted run
is not relabeled retroactively.

## Classifications

`K11_SHARDED_DATA_COMPILATION_UNITS_COMPONENT_PASS`

`K11_GLOBAL_DATA_ROUTER_COMPONENT_PASS`

`K11_LINEAR_81_RANGE_DISPATCH_NOT_ACCEPTED`

`K11_HIERARCHICAL_9X9_DISPATCH_REQUIRED`

`K11_SHARDED_DATA_FULL_GATE_NO_VERDICT`

`K11_REAL_CERTIFICATE_NOT_GENERATED`

`NO_K11_THEOREM_CLAIM`

`NO_GLOBAL_COLLATZ_CLAIM`
