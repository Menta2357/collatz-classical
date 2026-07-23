# F3_LEAN_M0B_REDUCTION_V3

Status: `PREDECLARED_AFTER_V2_HEARTBEAT_STOP`

V3 changes only the representation again.  It uses a literal list of 243
`(state_id, core_local_id)` pairs and a generic `find?` over that small pair
table.  The expensive equality is split as in V2: first the raw 81-edge
source filter, then the remap of that filtered list.  The pair table avoids
both V1's search through large records and V2's 243-case match elaboration.

The first V3 pilot is one block only.  It has a 300-second command ceiling and
the remaining M0-b STOP policy.  A pass permits generating the other eight
shards; a timeout or elaboration failure closes this reduction without a
silent retry.
