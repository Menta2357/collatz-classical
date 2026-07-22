# F3 next experiment preregistration v0.1

Date: 2026-07-21.

Status:

```text
NOT_AUTHORIZED_YET
WAITING_FOR_DYNAMIC_PREFIX_WEIGHTED_TAIL_PAGE_v0_3
WAITING_FOR_CLAUDE_FORMAL_VERDICT
```

## Experiment name

```text
F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_PILOT_v1
```

## Prerequisites

The pilot cannot run until all items below are fixed in writing:

```text
K
visible prefix family F_K
tail definition Q_K
route map for retarded branch
route map for advanced branch
potential denominator W_K
rational or interval-rational weights
calibration interval of parent roots
holdout interval of parent roots
y-range
acceptance threshold rho > 1.7922
error absorption threshold epsilon
member-wise hook schema
```

## Calibration/holdout discipline

```text
unit = parent root a
split = global disjoint intervals
forbidden = per-modulus split
forbidden = changing K, weights, tail, or denominator after calibration
forbidden = deleting thin types after seeing holdout
```

## Minimal outputs

```text
FROZEN_CONTRACT.json
calibration/root_rows.csv
calibration/route_rows.csv
calibration/error_ledger.csv
calibration/summary.json
holdout/root_rows.csv
holdout/route_rows.csv
holdout/error_ledger.csv
holdout/summary.json
mismatches.csv for every hook family
manifest_sha256.csv for every phase
```

## Verdict vocabulary

```text
PASS_RHO_CERTIFICATE
PASS_EMPIRICAL_ONLY
STOP_BAD_HOOKS
STOP_TAIL_TOO_LARGE
STOP_RHO_BELOW_LAMBDA_11
STOP_HOLDOUT_INTEGRITY
REDESIGN_PAPER_GATE
```

## Claims allowed from this preregistration

```text
none
```

This file only defines the next experimental gate. It does not authorize the
experiment and does not improve the mathematical status of F3.

