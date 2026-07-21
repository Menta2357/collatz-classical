# KL2003 k=11 Preflight Architecture Gate Result v1

## Verdict

```text
K11_PREFLIGHT_ARCHITECTURE_FAIL
```

The budget was fixed before execution in
`KL2003_K11_PREFLIGHT_BUDGET_AND_ARCHITECTURE_GATE_v1.md`.  Its SHA256 at run
time was:

```text
40e68f199dd9b21395b5ddef88c25d5fe32facc039c0228d7339e8daaf9901b5
```

The failure applies to a single monolithic Lean data module containing
chunked tables at k=11 scale.  It does not reject the fixed `729/243`
arithmetic shard grain and it does not claim that every sharded-data design
fails.

## Measurements

| Probe | Result | Wall time | Output |
|---|---|---:|---:|
| k=11 chunked data in one module | `ARCHITECTURE_FAIL` | `450.339782 s` | timeout, no `.olean` |
| real k=9 `729/243` arithmetic shard | `PASS` | `31.590608 s` | `9438224` bytes |
| synthetic 81-shard aggregate | `BLOCKED_BY_DEPENDENCY` | `0 s` | data `.olean` unavailable |

The generated data source was `7808575` bytes.  It represented `59049`
principal values, `19683` auxiliary values, and `59049` row slacks as exact
rational literals in chunks of `27`.

The host did not expose usable RSS samples to the runner, so no memory number
is inferred from the empty measurement.  The process was terminated by the
runner at the predeclared `450 s` architecture limit with exit code `124`.

## Diagnosis

The exact-arithmetic shard grain remains viable: the real shard passed far
inside its `450 s` budget.  The failed unit is the monolithic compilation of
all k=11 data, even though lookup inside that module was chunked.

The next candidate architecture must shard the data compilation unit itself:

- `81` data modules;
- each module owns `729` principal values, `243` auxiliary values, and `729`
  row slacks;
- every local table remains chunked by `27`;
- a thin router imports the `81` compiled data shards;
- the aggregator remains a range dispatcher, never a `59049`-case match.

That candidate is a new experiment with a separately fixed budget.  It does
not overwrite this result.

## Reproduction

```text
python3 -m py_compile scripts/kl2003_k11_preflight_architecture_gate_v1.py
python3 scripts/kl2003_k11_preflight_architecture_gate_v1.py
```

## Classifications

`K11_MONOLITHIC_CHUNKED_DATA_ARCHITECTURE_FAIL`

`K11_FIXED_729_243_SHARD_GRAIN_CONTROL_PASS`

`K11_81_SHARD_AGGREGATE_BLOCKED_BY_DATA_DEPENDENCY`

`K11_DATA_COMPILATION_UNIT_MUST_BE_SHARDED`

`K11_REAL_CERTIFICATE_NOT_GENERATED`

`NO_K11_THEOREM_CLAIM`

`NO_GLOBAL_COLLATZ_CLAIM`
