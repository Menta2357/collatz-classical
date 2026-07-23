# F3_LEAN_M0B_FULL_BUDGET_v1

Status: `PROPOSED_BEFORE_SECOND_ATTEMPT`

This document fixes the scope, resource envelope, shard layout, and stop
semantics for the full M0-b attempt.  It is a governance artifact, not a
claim that the Real renewal bridge has been formalized.

## Frozen base and evidence

- Branch: `codex/f3-density-capture-gate`.
- Base commit for the attempt: `f919274` (`F3: reconcile filtered core
  operator data`).
- The offline reconciliation is an identity pass, but the corresponding
  finite filter/remap equality is still a Lean obligation.
- The Real pilot measured 9.74 s compilation and 11.94 s audit.
- The exact 243-state matrix measured 220.18 s compilation.
- A monolithic finite identity run exceeded 600 s and was stopped.  This is
  an observed scale ceiling, not a mathematical FAIL.

## Scope

M0-b is Real-only and is deliberately split from the already completed M0-a
certificate checker.  The attempt may contain:

1. finite filter/remap identity shards for the frozen 243-state core;
2. the semantic-first one-step interface, with the matrix orientation
   derived from that interface;
3. the inductive finite expansion/fibre accounting interface (Lema A);
4. the Real renewal/telescoping pilot needed by the bridge.

It may not claim a rho certificate, a density theorem, an almost-all result,
or a global Collatz result.  It may not modify `master` or KL2003/K11
artifacts outside the F3 branch.

## Proposed resource envelope (requires human authorization)

The recommended full budget is **2700 seconds total**, with a **300 second
per-command ceiling**.  The split is predeclared as:

| component | shards | ceiling each | subtotal |
|---|---:|---:|---:|
| frozen edge/filter identity | 9 state blocks | 240 s | 2160 s |
| aggregator and orientation audit | 1 | 240 s | 240 s |
| Real renewal bridge pilot/assembly | 1 | 300 s | 300 s |
| **total** | 11 commands |  | **2700 s** |

The nine blocks use `core_local_id // 27`; this is a deterministic data
partition, not a statistical split.  The 729 internal edges are expected to
be distributed as 27 source states per block, with the three channels kept
visible in every shard report.

The rational M0-a budget is **not reopened** by this document.  The previous
M0-a result remains `PASS_CERTIFICATE_CHECKER_ONLY` and is cited as input.

## Environmental gate

Before the first Lean command, run and record the disk/RAM precheck.  The
previous precheck recorded approximately 33.7 GiB free disk and 8 GiB RAM
with pressure noted.  A failed precheck is `STOP_AND_RECORD`; no shard is
started.  The base commit and the precheck output must be included in the
attempt manifest.

## Acceptance and stop policy

All of the following are required for an M0-b PASS:

1. the precheck passes;
2. every shard and the aggregator finish within its ceiling;
3. the generated edge sequence equals the frozen offline sequence;
4. the semantic one-step statement uses the derived orientation (column
   masses with the transition transpose, hence the left certificate);
5. the finite expansion/fibre invariant is stated without materializing an
   unproved path enumeration;
6. axiom audits contain no `sorryAx` and every remaining hypothesis is
   explicitly named.

Any timeout, missing input, orientation mismatch, failed audit, or unproved
operator-to-fibre implication is `STOP_AND_RECORD`.  A stopped attempt keeps
all outputs and does not silently rerun the same command or burn a new claim.

## What this budget does not buy

The full Real conversion from the frozen operator to a uniform `piStar`
growth theorem is not authorized by this document.  In particular, the
Chernoff/first-hit comparison and the operator-to-fibre mass lower bound remain
formal obligations after the finite bridge.  If the Real pilot or the
semantic bridge passes, the next budget must price those obligations
separately.

## Claims ledger

```text
NO_RHO_CERTIFICATE = true
NO_DENSITY_THEOREM = true
NO_ALMOST_ALL = true
NO_GLOBAL_COLLATZ_CLAIM = true
STOP_POLICY = STOP_AND_RECORD
```
