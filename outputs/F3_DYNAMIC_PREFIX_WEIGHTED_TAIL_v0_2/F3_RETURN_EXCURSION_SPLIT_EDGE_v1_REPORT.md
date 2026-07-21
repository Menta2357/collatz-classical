# F3 return-excursion split-edge v1 report

Date: 2026-07-22.

Status:

```text
SPLIT_EDGE_FREEZE_PASS_HOLDOUT_READY
FROZEN_W_SPLIT_CORE_PUBLISHED
HOLDOUT_NOT_OPENED
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. Motivation

`F3_RETURN_EXCURSION_CORE_HOLDOUT_v1` failed because the fixed `d0 = 5` core
state does not determine the individual advanced/lift target in holdout.

The cause is structural: `c = (2a - 1)/3` loses one 3-adic digit. A fixed-depth
refinement alone would move the missing digit deeper.

This object replaces individual deterministic advanced/lift targets with
split edges carrying exact finite multiplicity.

## 2. Split-edge construction

Source:

```text
scripts/f3_return_excursion_split_edge_v1.py
```

For every advanced source state, the script enumerates the three depth-`d0+1`
lifts and emits three fine target rows with multiplicity `1/3`.

Result:

```text
state_count = 729
edge_count = 1215
tail_row_count = 243

channel_counts:
  retarded = 729
  advanced_direct_c2 = 243
  advanced_parity_lift_c1 = 243
  advanced_sterile_tail_c0 = 243
```

Per source, the coarse channel is fixed by the finite state; the split is over
the three fine targets inside that channel. Globally the three coarse channels
are balanced.

The observed source split types are:

```text
advanced_direct_c2:3 -> 81 source states
advanced_parity_lift_c1:3 -> 81 source states
advanced_sterile_tail_c0:3 -> 81 source states
```

## 3. Core and freeze

Dominant core:

```text
global_scc_count = 335
core_component_id = 328
core_state_count = 243
excluded_state_count = 486

global_spectral_radius = 1.0399310992822737
core_spectral_radius = 1.0399310992822715
core_left_eigenvalue = 1.0399310992822712
```

Core description:

```text
core_residue_mod_9_counts:
  2 -> 81
  5 -> 81
  8 -> 81

core_bucket_counts:
  0 -> 81
  1 -> 81
  2 -> 81
```

Rationalized freeze:

```text
D = 1000000
delta = 1/100
core_bad_state_count = 0
core_min_ratio_lhs_over_rhs = 1.0295828177270736
core_reverify_pass = true
```

Frozen vector:

```text
results/F3_RETURN_EXCURSION_SPLIT_EDGE_v1/frozen_w_split_core.csv
sha256 = 580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40
```

## 4. Holdout status

No holdout was opened by this object.

Burned range retained:

```text
[20737, 41473)
```

Next eligible one-use range, if accepted by review:

```text
[41473, 82945)
```

## 5. Next accepted object

```text
F3_RETURN_EXCURSION_SPLIT_EDGE_HOLDOUT_CONTRACT_v1
```

It must use exactly the frozen vector hash above and define the population-split
hook:

```text
complete 3-adic blocks split exactly across the three fine targets;
boundary fragments are charged to Q_boundary before the holdout run.
```

Only after that contract may the new holdout range be opened.

## 6. Non-claims

```text
NO_HOLDOUT_RESULT
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_LEAN_OPERATOR
```

