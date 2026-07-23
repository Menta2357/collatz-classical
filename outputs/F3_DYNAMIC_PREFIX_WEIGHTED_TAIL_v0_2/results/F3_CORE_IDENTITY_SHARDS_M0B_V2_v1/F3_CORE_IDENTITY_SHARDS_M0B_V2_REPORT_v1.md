# F3_CORE_IDENTITY_SHARDS_M0B_V2_REPORT_v1

Status: `STOP_AND_RECORD_REMAP_TABLE_HEARTBEAT_TIMEOUT`

V2 was a predeclared representation change after the V1 shard timeout.  It
replaced the repeated `List.find?` lookup by a 243-case explicit match table
and split the check into raw filtering and remapping.  The common remap module
did not elaborate: Lean reached its deterministic `isDefEq` heartbeat limit
at 123.04 s before any shard theorem was checked.

```text
command: lake env lean CollatzClassical/KL2003/F3ReturnExcursionCoreStateRemapV2.lean
exit_status: 1
diagnostic: deterministic timeout at isDefEq, maxHeartbeats=200000
shards checked: 0
```

This is a representation/elaboration stop, not a mathematical counterexample.
The generated V2 modules were removed and no heartbeat limit was raised.  The
next permitted reduction must avoid both a giant match and repeated search;
the proposed V3 uses a small pair table only after the raw 81-edge block has
already been filtered.
