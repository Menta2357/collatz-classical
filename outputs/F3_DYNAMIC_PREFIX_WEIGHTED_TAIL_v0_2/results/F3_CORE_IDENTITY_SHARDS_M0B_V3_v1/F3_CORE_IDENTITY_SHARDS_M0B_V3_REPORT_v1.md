# F3_CORE_IDENTITY_SHARDS_M0B_V3_REPORT_v1

Status: `STOP_AND_RECORD_PILOT_SHARD_TIMEOUT_NO_LEAN_PASS`

V3 used a literal pair table and a two-stage raw-filter/remap reduction.  The
pair-table module itself compiled in 96.27 s when its `.olean` was installed
explicitly.  The single pilot block then produced no Lean diagnostics before
the predeclared command ceiling and was interrupted.

```text
pair-table compile: PASS, 96.27 s
pilot: F3ReturnExcursionCoreIdentityShardV300.lean
pilot reported wall time: 330.32 s (interrupted)
pilot verdict: TIMEOUT_STOP_AND_RECORD
Lean identity theorem: NOT VERIFIED
remaining V3 shards: NOT_STARTED
```

The first failed pilot invocation (20.70 s) was only a missing `.olean`
installation and is not counted as a mathematical result.  After correcting
that build procedure, the actual pilot still timed out.  The generated V3
sources were removed; the reduction specification and generator remain.  No
heartbeat limit was raised and no silent rerun is permitted.

The offline sequence identity remains `PASS`; the Lean filter/remap theorem
remains open.  The semantic orientation, Lema A interface, and comparison
contract remain compiled interfaces with their substantive hypotheses
visible.  No rho, density, almost-all, or global Collatz claim is made.
