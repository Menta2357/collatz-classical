# F3 Claude formal verdict request v3

Date: 2026-07-21.

This request supersedes the v2 review packet only by adding public custody and
the next paper gate. It does not alter any sealed result.

## Public custody

```text
repo   = https://github.com/Menta2357/collatz-classical
branch = codex/f3-density-capture-gate
commit = f1af240a02785e916710d6f33019ca1a3a583f70
PR     = https://github.com/Menta2357/collatz-classical/pull/1
package manifest sha256 = 0704580adcb4d0019dae55dd81169f65e830747e8cf8d108dc1a676e0a335efa
```

## Items for verdict

1. Accept, revise, or reject the V1 holdout invalidation.
2. Accept, revise, or reject V2 holdout integrity under global parent-root
   intervals.
3. Decide whether the uniform useful lower balance route is stopped, merely
   parametrically failed, or still worth pursuing.
4. Decide whether the only live F3 route is dynamic 3-adic prefix with
   certified weighted tail.
5. Specify the minimal obligations of that weighted-tail potential before any
   new experiment is allowed.

## Facts to keep fixed

```text
E5 advanced loss at y=9 = 0.0871584527%
0.1% uniform claim = withdrawn
multiscale max y=7..12 advanced loss = 0.113881902%
fixed modulus deterministic closure = STOP
V1 holdout parent-root overlap = 192
V2 parent-root overlap = 0
V2 holdout hooks mismatches = 0
V2 utility floor 0.200 = FAIL
local verdict = STOP_OR_REDESIGN
```

## Required response format

```text
V1_INVALIDATION = ACCEPT | REVISE | REJECT
V2_HOLDOUT_INTEGRITY = ACCEPT | REVISE | REJECT
UNIFORM_LIFT_BALANCE_ROUTE = STOP | REVISE | CONTINUE
DYNAMIC_PREFIX_WEIGHTED_TAIL = CONTINUE | STOP
MINIMAL_POTENTIAL_OBLIGATIONS = <lista cerrada>
CLAIMS_TO_DOWNGRADE = <lista cerrada>
FORMAL_VERDICT = <veredicto>
```

## Non-claims

```text
NO_LEAN
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
K11_DOUBLET_ELIAHOU_PRIORITY_UNCHANGED
```

