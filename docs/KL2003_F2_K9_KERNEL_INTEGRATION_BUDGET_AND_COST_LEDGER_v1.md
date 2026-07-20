# KL2003 F2 k=9 Kernel Integration Budget and Cost Ledger v1

## Scope

This ledger fixes the acceptance budget before the source-tree k=9
certificate checker is completed.  It covers the 6561 principal row facts,
the 2187 auxiliary box groups, and the finite dispatcher needed by the
`LNTCertificate` API.  It does not claim a k=9 lower-bound theorem.

## Acceptance budget

The reference execution uses at most three concurrent Lean workers.

| Component | Acceptance target |
|---|---:|
| Nine arithmetic shards, total wall time | at most 1200 seconds |
| Slowest arithmetic shard | at most 450 seconds |
| Finite dispatcher / aggregator | at most 120 seconds |
| Data elaboration | at most 60 seconds |
| Total source-tree certificate recheck | at most 1320 seconds |

Interpretation:

- `PASS`: total source-tree recheck is at most 1320 seconds and every theorem
  is kernel checked.
- `OPTIMIZATION_REQUIRED`: total is greater than 1320 seconds but at most 1800
  seconds, or one shard exceeds 450 seconds.
- `ARCHITECTURE_FAIL`: total exceeds 1800 seconds, a shard times out, or the
  dispatcher cannot be checked without trusting generated code.

These thresholds are deliberately looser than the measurement-only checker,
because the source-tree checker must also connect every literal fact to the
canonical imported certificate data and expose a dependent `forall` theorem.

## Measurements before the final architecture

| Stage | Result | Interpretation |
|---|---:|---|
| Literal rational checker, nine shards, three workers | 437.152929 s wall | Arithmetic candidate is feasible for kernel checking. |
| Literal checker slowest shard | 153.850506 s | Baseline for direct `norm_num` facts. |
| Generic shard with all 189 chunks unfolded per case | greater than 480 s, interrupted | Rejected: repeated whole-table expansion. |
| Single table-linked row through the original outer array | greater than 76 s, interrupted | Rejected: definitional reduction traverses the outer array. |
| Single table-linked row through a generated chunk router | 86.88 s | Correct but not scalable per row; retained only as a diagnostic. |

The naive projection of the last measurement over 6561 rows is about 158
hours.  It is not an implementation plan.  The accepted architecture must
instead separate direct literal arithmetic facts from a finite dispatcher and
must avoid recomputing the data-to-literal link independently for every row.

## Trust boundary

- The Python generator and generated manifest are untrusted search and
  transport machinery.
- Lean rechecks every rational inequality and every dispatcher branch.
- No `native_decide`, `unsafe`, `axiom`, `sorry`, or assumed certificate
  structure is permitted.
- No definition or theorem is named `LNTCertificate` until all nine shards and
  the dispatcher compile.
- `KL2003K9ClassRootsAxiomAudit.lean` must pass before the class-root theorem is
  consumed by semantic k=9 assembly.

## Current classification

`K9_KERNEL_INTEGRATION_BUDGET_FIXED`

`K9_COST_CURVE_RECORDED`

`K9_LITERAL_ARITHMETIC_KERNEL_RECHECK_PROVED`

`K9_SOURCE_TREE_DISPATCHER_NOT_YET_PROVED`

`NO_K9_LOWER_BOUND_THEOREM_CLAIM`

`K11_DEFERRED`

`NO_GLOBAL_COLLATZ_CLAIM`
