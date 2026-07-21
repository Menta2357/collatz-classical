# F3 return-excursion split-edge v1 contract

Date: 2026-07-22.

Status before execution:

```text
SPLIT_EDGE_CONTRACT_PREDECLARED
HOLDOUT_NOT_OPENED
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. Reason

`F3_RETURN_EXCURSION_CORE_HOLDOUT_v1` failed because a fixed `d0 = 5`
state does not determine the individual advanced/lift target. The map

```text
c = (2a - 1) / 3
```

loses one 3-adic digit. Any fixed-depth refinement would move the missing
digit one level deeper.

The repair is therefore not depth-only refinement. The repair is to certify a
sum functional by split edges with exact finite multiplicity.

## 2. Split-edge rule

For each source state at `d0 = 5`, enumerate the three 3-adic lifts of that
state to depth `d0 + 1`.

The advanced/lift branch is represented as:

```text
source -> fine target_0 with multiplicity 1/3
source -> fine target_1 with multiplicity 1/3
source -> fine target_2 with multiplicity 1/3
```

The source state determines the coarse channel label:

```text
advanced_direct_c2
advanced_parity_lift_c1
advanced_sterile_tail_c0
```

Within that channel, the missing 3-adic digit is represented by the three fine
targets. The split is a finite residue enumeration, not a fitted probability.
The three coarse channels are balanced globally over the finite state space,
not necessarily inside each individual source state.

## 3. Member-wise meaning

For a sum functional, the hook is not:

```text
this individual root followed the frozen target
```

because the missing digit theorem forbids that at fixed depth.

The hook is:

```text
the population of the state splits according to the exact finite enumeration
```

Complete 3-adic blocks give equality. Boundary fragments are charged to row-wise
`Q_boundary`.

## 4. Freeze rule

Build the split-edge matrix and restrict to its dominant SCC exactly as in
support repair:

```text
D = 1000000
delta = 1/100
w_core = left Perron vector of M_split_core
```

Rationalize and re-verify:

```text
w_core^T M_split_core >= (1 + delta) w_core^T
```

before any holdout.

## 5. Holdout status

The burned range:

```text
[20737, 41473)
```

must not be reused.

The next possible holdout range, if split-edge freeze passes, is:

```text
[41473, 82945)
```

This contract does not open it.

## 6. Allowed outcomes

```text
SPLIT_EDGE_FREEZE_PASS_HOLDOUT_READY
STOP_SPLIT_EDGE_REVERIFY_FAILED
STOP_SPLIT_EDGE_CORE_CHECK_FAILED
```

Forbidden:

```text
HOLDOUT_PASS
RHO_CERTIFIED
DENSITY_THEOREM
ALMOST_ALL
GLOBAL_COLLATZ
LEAN_READY
```
