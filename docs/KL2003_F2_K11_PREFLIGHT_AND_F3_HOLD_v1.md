# KL2003 F2 k=11 preflight and F3 hold v1

Date: 2026-07-21.

## Decision

F3 reached:

```text
PRE_SPECTRAL_CANDIDATE
SCALE_AWARE_OPERATOR_REQUIRED
```

but the k=11 priority remains ahead of the next F3 experiment.

Therefore:

```text
F3_SCALE_AWARE_OPERATOR_HOLD
K11_PREFLIGHT_FIRST
```

## k=11 current status

The source target is recorded:

```text
k=11
gamma_11 = 0.8417560
lambda_11 = 1.7922310
tracked classes = 59049
```

But k=11 is not yet custodied as a certificate:

```text
printed_k11_084_data = MISSING_PRINTED_STRUCTURAL
k11 generator = missing
k11 cold rerun = not available
k11 theorem claim = no
0.84 exponent claim = no
```

## k=9 baseline used for budget

The current custodied k=9 benchmark is:

```text
tracked classes = 6561
kernel wall = 437.152929 seconds
sum shard seconds = 1244.451968
maximum shard seconds = 153.850506
```

Linear projection to k=11, before architecture improvements:

```text
scale factor from k=9 = 9
k11 tracked classes = 59049
projected kernel wall = 3934.376361 seconds
projected sum shard seconds = 11200.067712
projected maximum shard seconds = 1384.654554
```

These are projections, not measurements.

## Gate

Before the next F3 experiment, produce or explicitly block:

```text
KL2003_F2_K11_PREFLIGHT_v1
source-faithful generator plan
budget ledger
cold rerun command, or explicit reason it cannot exist yet
```

## Non-claims

```text
NO_K11_THEOREM_CLAIM
NO_084_EXPONENT_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
NO_F3_RHO_CERTIFICATE
```

