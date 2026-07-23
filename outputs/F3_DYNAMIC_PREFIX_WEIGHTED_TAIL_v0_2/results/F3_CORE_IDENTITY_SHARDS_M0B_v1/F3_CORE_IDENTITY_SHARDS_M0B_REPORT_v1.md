# F3_CORE_IDENTITY_SHARDS_M0B_REPORT_v1

Status: `STOP_AND_RECORD_FIRST_SHARD_TIMEOUT_NO_LEAN_PASS`

The authorized M0-b shard attempt was stopped before any mathematical claim
was made.  The environmental precheck was run first; the machine had about
12 GiB available disk, meeting the recorded 12 GiB minimum but with the
previous pressure note still applicable.  The local Lean cache was restored
after the command.

Attempt record:

```text
shard: 00
command: lake env lean CollatzClassical/KL2003/F3ReturnExcursionCoreIdentityShard00.lean
intended_ceiling_seconds: 300
observed wall time reported by time(1): 336.04
diagnostics: no Lean output before interruption
verdict: TIMEOUT_STOP_AND_RECORD
shards 01..08: NOT_STARTED
aggregator: NOT_STARTED
```

This is an operational scale result, not a proof failure and not evidence
against the finite identity.  The nine generated Lean sources were removed
after the stop so that no uncompiled artifact is presented as custody.  The
deterministic CSV shards and their generator remain.  A future attempt must
change the reduction (for example, precompute a finite local remap table or
use smaller source blocks) before consuming another Lean command; silently
rerunning the same shard is forbidden by the budget contract.

The semantic orientation, Lema A interface, and operator-to-fibre contract
remain compiled results.  The concrete finite filter/remap theorem remains
open.  All no-claim flags remain active.
