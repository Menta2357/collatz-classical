# KL2003 k=11 Real Lean Checker Budget v1

## Purpose

This budget is fixed after:

- `K11_HIERARCHICAL_PREFLIGHT_PASS` established the 81-shard data and 9x9
  dispatch architecture with synthetic exact rationals;
- `K11_REAL_CERTIFICATE_METRICS_PASS` produced 59049 exact positive rows,
  19683 auxiliary values, at most 35 rational digits, and a 26.9 MB canonical
  JSON artifact.

The gate promotes that candidate to generated Lean data and asks the kernel to
recheck every row and lift inequality.  It does not yet assemble an
`LNTCertificate`, endpoint theorem, or piStar theorem.

## Fixed architecture

```text
81 data shards
  each: 729 principal + 243 auxiliary + 729 row slacks
  local match chunk: 27

1 thin data router

81 arithmetic checker shards
  each: 729 row facts + 243 auxiliary facts

9 group dispatchers
  each: 9 checker shards

1 top dispatcher
```

There is no monolithic 59049-case match and no linear 81-level dispatcher.

## Two-stage execution

### Stage A: real pilot shard

Build `KL2003K11CertificateMatchShard00`.  This necessarily compiles all 81
data shards and the global router, then checks 729 real rows and 243 real lift
bundles.

If Stage A fails or exceeds the failure budget, Stage B is not authorized.

### Stage B: complete checker

Build `KL2003K11CertificateMatchAggregate` and its axiom audit.  Cached Stage A
work counts toward the complete measured run; the summary records the pilot,
incremental completion, audit, and their total.

## Acceptance budget

| Metric | PASS | OPTIMIZATION_REQUIRED | FAIL |
|---|---:|---:|---:|
| Stage A real pilot | `<= 600 s` | `(600, 900] s` | `> 900 s` or failure |
| Stage B incremental completion | `<= 900 s` | `(900, 1200] s` | `> 1200 s` or failure |
| Full pilot + completion + audit | `<= 1320 s` | `(1320, 1800] s` | `> 1800 s` or failure |
| Generated Lean source | `<= 100 MB` | `(100, 180] MB` | `> 180 MB` |
| Generated `.olean` footprint | `<= 2.5 GiB` | `(2.5, 4] GiB` | `> 4 GiB` |
| Peak RSS per Lean process, when measurable | `<= 4096 MiB` | `(4096, 6144] MiB` | `> 6144 MiB` |
| Free disk before build | `>= 12 GiB` | n/a | `< 12 GiB` |

The wall-time budget is for this host and is an engineering acceptance test,
not part of the theorem.  If RSS remains unavailable in the sandbox, it is
reported as an explicit residual risk rather than estimated.

## Proof form

The untrusted generator emits literal rational propositions.  Each individual
row theorem has the form:

```text
1 <= c_m /\ slack_m = rhs_m - c_m /\ 0 < slack_m
```

and each auxiliary theorem checks its lower box and all three lift bounds.
Lean discharges the literal arithmetic with `norm_num`.  Finite range theorems
dispatch only to already proved literals.  The generator is not in the trusted
base.

## Acceptance

`K11_REAL_LEAN_CHECKER_PASS` requires all of the following:

1. all 81 data shards and the router compile;
2. all 81 arithmetic shards compile;
3. all nine group dispatchers and the top dispatcher compile;
4. the aggregate proves all 59049 row and 19683 auxiliary propositions;
5. the axiom audit reports only the expected kernel profile;
6. all fixed resource failure thresholds are respected.

Only after this gate passes may a separate module construct the k=11
`LNTCertificate` from the checked data.

## Guardrails

- No generated theorem assumes a row or certificate as a hypothesis.
- No `LNTCertificate` is declared in this gate.
- No endpoint or arbitrary-x theorem is claimed.
- No k=11 `0.84` theorem or global Collatz claim is made.
- Existing k=9 files and unrelated untracked artifacts are not modified.

## Classifications

`K11_REAL_LEAN_CHECKER_BUDGET_FIXED_BEFORE_GENERATION`

`K11_81_DATA_SHARDS_REQUIRED`

`K11_81_ARITHMETIC_SHARDS_REQUIRED`

`K11_HIERARCHICAL_9X9_DISPATCH_REQUIRED`

`K11_LNTCERTIFICATE_NOT_YET_AUTHORIZED`

`NO_K11_THEOREM_CLAIM`

`NO_GLOBAL_COLLATZ_CLAIM`
