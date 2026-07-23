# F3_LEAN_M0B_EXTENDED_BUDGET_v1

Status: `AUTHORIZED_STAGED_PILOT`

This is a new, explicitly authorized campaign after the three prior
`STOP_AND_RECORD` outcomes.  It raises wall-clock allowance but does not
remove mathematical or environmental safeguards.

## Limits

- Total campaign envelope: **9000 s**.
- Maximum single Lean command: **900 s**.
- Execution: strictly sequential; no parallel shards.
- `maxHeartbeats`: unchanged at 200000; no heartbeat override.
- No monolithic reduction and no silent rerun of V1/V2/V3.
- First stage: one V3-style pilot only.  Remaining stages open only if the
  pilot exits successfully and its manifest is updated.
- Any timeout, diagnostic, memory pressure escalation, or disk threshold
  breach is `STOP_AND_RECORD`.

## Environmental gate

The precheck immediately before this campaign recorded approximately 13.4 GiB
free disk and 8 GiB physical RAM, with active-memory pressure.  The campaign
may run only while free disk remains at least 12 GiB; it is sequential to avoid
peak amplification.  The low-margin condition is recorded as a risk, not
hidden.  If the precheck is not repeated successfully, the pilot does not
start.

## Scope

The pilot is only the finite V3 raw-filter/remap identity.  It cannot produce
a rho certificate, density theorem, almost-all statement, or global Collatz
claim.  The Real renewal conversion and the operator-to-fibre hypotheses
remain separate gates.

## Staged release of budget

```text
stage_0_precheck              0 s   mandatory
stage_1_v3_pilot            900 s   open now
stage_2_remaining_shards   7200 s   locked until pilot PASS
stage_3_aggregator          900 s   locked until all shards PASS
```

This staged release is the safety mechanism: lifting the wall timeout does not
commit the remaining 8100 s after a pilot failure.

Claims ledger remains unchanged:

```text
NO_LEAN_RHO_CERTIFICATE = true
NO_DENSITY_THEOREM = true
NO_ALMOST_ALL = true
NO_GLOBAL_COLLATZ_CLAIM = true
STOP_POLICY = STOP_AND_RECORD
```
