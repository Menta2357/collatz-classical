# F3 R3 reverse-BFS six-row pilot contract v5

Date: 2026-07-25.

Status:

```text
V5_VERDICT_SCOPE_SUCCESSOR_PREDECLARED_BEFORE_REVERSE_SEARCH
V4_CUSTODY_STATE_MACHINE_RECEIPTS_RESOURCES_UNCHANGED
V3_SIX_ROWS_ORDER_CHECKERS_PREREQUISITES_UNCHANGED
DEFICIENT_MEANS_SIX_ROW_SATURATION_STOP_ONLY
DEFICIENT_MEANS_FULL_CAPACITY_SUBROUTE_STOP_ONLY
DEFICIENT_CERTIFICATE_RETAINED_FOR_BOUNDARY_ACCOUNTING
NO_F3_STOP_FROM_CARDINAL_SHORTFALL
NO_RESIDUAL_D2_452_EXECUTION_AUTHORIZED
NO_LEAN_EXECUTION_FOR_THIS_CONTRACT
NO_REVERSE_BFS_RESULT_OBSERVED
NO_R3_FINITE_PASS
NO_F3_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## 1. Succession and exact amendment scope

This document is a narrow verdict-scope successor to
`F3_R3_REVERSE_BFS_PILOT_CONTRACT_v4.md`, whose immutable SHA-256 is

```text
9c6954e5985559b7a977064f21bf631199e265674ed5dc326175dfb5cfa8109c
```

V5 changes no selected row, row order, prerequisite, theorem statement,
checker, source artifact, resource ceiling, attempt count, memory policy,
receipt, hash rule, custody rule or phase transition.  In particular, the
normal state machine remains exactly

```text
B0 -> R0 -> P0 -> G01 -> G02 -> G03 -> G04 -> G05 -> G06
   -> S0 -> P1 -> V0 -> A0 -> F0
```

and the first INVALID condition still forbids every unstarted normal phase
and permits only the one custody-only `C0` successor specified by v4.

V5 supersedes v4 only where v4 classified a kernel-accepted deficient row as
an unqualified mathematical STOP.  The new evidence shows why that scope was
too broad: a deficient demand-two row with one certified first-hit value
still serves one atom.  It fails saturation for that owner, but contributes a
valid retained atom to the weighted-boundary route.

## 2. Immutable mathematical meaning of a verified row

For a selected owner `p`, let

```text
D(p) = massDemand p
m(p) = card (orderedFirstHitFiber0 p)
Q(p) = activeContribution p
```

A saturated certificate proves `D(p) <= m(p)`.  A deficient certificate,
together with the audited completeness theorem, proves `m(p) < D(p)`.  These
are exact cardinal statements for that selected owner.

The latter statement does **not** prove that the owner contributes no usable
mass.  The owner-preserving atomization retains

```text
m(p) * Q(p) / D(p)
```

and assigns the remaining boundary contribution

```text
(D(p) - m(p)) * Q(p) / D(p).
```

In the newly exposed case `D(p)=2` and `m(p)=1`, one atom is retained and the
boundary contribution is exactly `Q(p)/2`.

## 3. Verdict precedence and mandatory scoped classification

The terminal precedence remains unchanged:

```text
INVALID  >  scoped saturation STOP or six-row PASS
```

The existing machine-facing verdict names remain unchanged so that v5 does
not silently rewrite the future v3+v4 source and receipt surface:

```text
INVALID_R3_REVERSE_BFS_PILOT_V3
STOP_R3_REVERSE_CAPACITY_COUNTEREXAMPLE_V3
PASS_R3_REVERSE_BFS_PILOT_V3_6_OF_6
```

However, every v5 receipt, report, registry and public description that uses
the historical STOP token must attach all three of these mandatory labels:

```text
SIX_ROW_SATURATION_STOP
FULL_CAPACITY_SUBROUTE_STOP
NO_F3_STOP
```

Thus the exact v5 classifications are:

```text
INVALID_R3_REVERSE_BFS_PILOT_V3
  = NON_MATHEMATICAL_INVALID

STOP_R3_REVERSE_CAPACITY_COUNTEREXAMPLE_V3
  = SIX_ROW_SATURATION_STOP
  = FULL_CAPACITY_SUBROUTE_STOP
  != F3_STOP

PASS_R3_REVERSE_BFS_PILOT_V3_6_OF_6
  = SIX_OWNER_SATURATION_PASS
```

The bare labels `MATHEMATICAL_STOP`, `CAPACITY_COUNTEREXAMPLE` or `F3_STOP`
are forbidden as descriptions of a deficient six-row outcome.  The
historical token may occur only with the scoped labels above.

## 4. Exact trigger for the scoped saturation STOP

The scoped STOP is emitted only after the complete valid fourteen-phase
chain, all manifest and receipt revalidations, a checker-accepted deficient
certificate and the audited completeness theorem prove, for one frozen
selected owner,

```text
(orderedFirstHitFiber0 p).card < massDemand p.
```

It refutes exactly the attempted claim that all six frozen owners are
saturated.  It also refutes using that owner as a witness for the stronger
member-wise full-capacity condition `D(p) <= m(p)`.

It does not refute:

- the validity of the certified `m(p)` retained first-hit values;
- the owner-preserving weighted-boundary decomposition;
- a global inequality allowing nonzero boundary mass;
- the reverse-BFS architecture on another owner;
- an F3 operator theorem, `rho = 9/5`, an exponent or a density theorem.

Any INVALID, checker rejection, source drift, timeout, memory event, audit
failure or incomplete certificate remains non-mathematical and cannot trigger
this scoped STOP.

## 5. Custody and boundary-accounting handoff

`F0` remains the final normal phase.  For a valid deficient outcome it must
custody, without rewriting:

- the deficient certificate and audited completeness receipt;
- the exact values `D(p)` and `m(p)`;
- the retained-atom count `m(p)`;
- the omitted-atom count `D(p)-m(p)`; and
- the symbolic boundary term `(D(p)-m(p))*Q(p)/D(p)`.

This custody is an input to a future weighted-boundary accounting contract.
It is not permission to execute that contract inside the current run.

In particular, v5 does **not** authorize generation, verification or
aggregation over the residual 452 demand-two owners.  Such work requires a
new predeclared contract after the valid six-row terminal receipt.  Neither a
six-row PASS nor a scoped saturation STOP may be promoted to a 452-owner or
1620-owner result.

## 6. PASS and no-claim boundary

A six-row PASS still requires six exact checker-accepted saturated
certificates after the complete valid phase and audit chain.  It proves only
the six selected owner inequalities.  It proves no statement for another
owner and does not authorize the residual-D2 run by itself.

No outcome under v5 proves full Block0 capacity, the weighted boundary
margin, `rho = 9/5`, an F3 exponent, density, or Collatz.  The strongest
possible negative outcome is a scoped obstruction to six-row saturation;
the strongest possible positive outcome is six-owner saturation.

## 7. Pre-execution reconciliation requirement

Before any of the seven pilot sources is frozen or `B0` starts, the canonical
execution registry and generated report templates must cite v5 and reproduce
the mandatory scoped classification verbatim.  A registry or script that
still maps the historical STOP token to an unqualified `MATHEMATICAL_STOP` is
stale and makes the pilot `PILOT_PREREQ_NOT_READY`.

This document performs no Lean execution, reverse search or semantic
decision.  It changes only the meaning that future valid evidence is allowed
to support.
