# F3_LEAN_M0B_REDUCTION_V2

Status: `PREDECLARED_AFTER_V1_TIMEOUT`

This is a materially different finite reduction, written before another Lean
command.  The first attempt spent its ceiling repeatedly evaluating a
`List.find?` remap over the full 243-row table.  V2 replaces that operation by
an explicit finite match table and separates the proof into two smaller
equalities:

1. the M0-a `splitEdges` filter for the 27 source states of a block;
2. the remap of that already-filtered 81-edge list to `Fin 243`.

The expected lists are generated from the frozen CSVs, but the Lean theorem
still evaluates the original M0-a `splitEdges` definition.  No holdout data or
numeric certificate is used as a proof premise.

The first V1 shard timeout remains recorded and is not rerun.  V2 uses the
remaining M0-b envelope only after this reduction is committed and audited:
300 seconds per command, `STOP_AND_RECORD` on any timeout, and no more than
one pilot block before deciding whether the reduction scales.
