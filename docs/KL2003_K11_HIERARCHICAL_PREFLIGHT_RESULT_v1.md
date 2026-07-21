# KL2003 k=11 Hierarchical Preflight Result v1

## Verdict

```text
K11_HIERARCHICAL_PREFLIGHT_PASS
```

The acceptance thresholds were fixed before this successful run in
`KL2003_K11_HIERARCHICAL_PREFLIGHT_BUDGET_v1.md`.  The runner recorded the
budget SHA256:

```text
2e648e902f08af7c00018919b55640e6aa4597f5c40279cc97db4dbf5a6907e6
```

This is an architecture and elaboration result.  It authorizes the real k=11
certificate metrics gate; it is not a k=11 certificate or theorem.

## Measurements

| Component | Wall time | Budget | Result |
|---|---:|---:|---|
| base module | `3.512030 s` | component setup | `PASS` |
| 81 data shards, 3 workers | `264.319616 s` | `<= 600 s` | `PASS` |
| slowest data shard | `16.916204 s` | `<= 120 s` | `PASS` |
| global data router | `13.075903 s` | `<= 180 s` | `PASS` |
| router-import consumer | `5.567320 s` | `<= 180 s` | `PASS` |
| 81 checker interfaces, 3 workers | `29.587200 s` | `<= 300 s` | `PASS` |
| nine group dispatchers, 3 workers | `3.138484 s` | `<= 180 s` | `PASS` |
| top nine-group dispatcher | `2.064142 s` | `<= 180 s` | `PASS` |
| complete preflight | `321.777645 s` | `<= 1200 s` | `PASS` |

The synthetic package represented the full k=11 dimensions:

```text
principal values = 59049
auxiliary values = 19683
row slacks = 59049
data shards = 81
principal values per shard = 729
auxiliary values per shard = 243
row slacks per shard = 729
local chunk size = 27
```

## Size measurements

```text
temporary Lean source = 7916201 bytes
temporary .olean total = 476573072 bytes
81 data-shard .olean total = 469762032 bytes
global router .olean = 1219056 bytes
top aggregate .olean = 48352 bytes
free disk at start = 29.807 GiB
```

The measured `.olean` footprint is below the future maintained-artifact
budget of `2.5 GiB`.  The temporary sources and object files were deleted at
the end of the run; the script deterministically regenerates them and the
summary records their SHA256 values.

## Architecture decision

The experiment separates two failures that a single extrapolation would have
conflated:

1. one 7.8 MB data source with all k=11 values did not elaborate within the
   fixed `450 s` limit;
2. splitting the identical synthetic value family into 81 data compilation
   units completed in `264.32 s`;
3. one linear chain of 80 dispatcher decisions was not retained;
4. a hierarchical `9 x 9` range dispatcher completed its group and top
   stages in `5.20 s` combined.

The accepted candidate for real k=11 work is therefore:

```text
81 data shards -> thin global router
81 arithmetic shards -> 9 group dispatchers -> 1 top dispatcher
```

No monolithic 59049-case match is part of the design.

## Residual risks

The host sandbox did not expose RSS through `ps`, so peak memory is recorded
as unavailable rather than estimated.  A real-certificate run outside that
restriction must still enforce the `4096/6144 MiB` per-process memory gates.

The synthetic values exercise exact-rational parsing, chunking, imports, and
routing, but they do not predict the digit distribution of the real k=11
certificate.  The next gate must measure:

- absolute and normalized minimum row slack;
- maximum numerator and denominator digits;
- real JSON, Lean source, and `.olean` sizes;
- generator, shard, aggregate, incremental, and cold-build times.

Endpoint and alpha-convergent work remains downstream of those measurements.

## Reproduction

```text
python3 -m py_compile scripts/kl2003_k11_preflight_architecture_gate_v1.py
python3 -m py_compile scripts/kl2003_k11_sharded_data_preflight_v1.py
python3 scripts/kl2003_k11_sharded_data_preflight_v1.py
```

## Classifications

`K11_HIERARCHICAL_PREFLIGHT_PASS`

`K11_81_DATA_SHARDS_PASS`

`K11_GLOBAL_DATA_ROUTER_PASS`

`K11_HIERARCHICAL_9X9_DISPATCH_PASS`

`K11_SYNTHETIC_OLEAN_FOOTPRINT_WITHIN_BUDGET`

`K11_RSS_MEASUREMENT_UNAVAILABLE`

`K11_REAL_CERTIFICATE_METRICS_GATE_AUTHORIZED`

`K11_REAL_CERTIFICATE_NOT_GENERATED`

`NO_K11_THEOREM_CLAIM`

`NO_GLOBAL_COLLATZ_CLAIM`
