# F3 native-decide provenance — ledger note v1

Status: `PROVENANCE_RESOLVED_WITH_SEMANTIC_INVENTORY_NOTE_REQUIRED`

This note distinguishes module import/exposure from dependence on a theorem's
proof term.  Importing a module that contains `native_decide` declarations is
not, by itself, an axiom dependency on those declarations.

## A. Exact frozen core matrix — custodied, disclosed

Commit: `2f0981d7a8d5084c1873637e12d4cc045f500c22`.

File: `CollatzClassical/KL2003/F3ReturnExcursionExactCoreMatrix.lean`.

Six-line declaration block:

- `core_edge_count`, lines 1023–1024: certifies
  `coreEdges.length = 729`;
- `frozen_weight_count`, lines 1026–1027: certifies
  `integerWeights.toList.length = 243`;
- `core_edges_have_valid_channels`, lines 1029–1031: certifies that every
  frozen edge channel is below three.

All three use `native_decide`.  The custodied axiom audit prints
`Lean.ofReduceBool` for each, and
`F3_EXACT_CORE_MATRIX_REPORT_v1.md` explicitly declares the native checker.
This is part of the custodied package, not unsigned exploration.

## B. Frozen semantic inventory — custodied, audit coverage incomplete

Commit: `c306215f6d1b30118d0056a0b173bd4e97245b12`.

File:
`CollatzClassical/KL2003/F3ReturnExcursionFrozenSemanticInventory.lean`.

- `semantic_edge_count`, lines 1277–1278: certifies length 1215;
- `semantic_edges_valid`, lines 1280–1282;
- `semantic_edges_are_frozen`, lines 1284–1286.

All three use `native_decide`.  The signed report discloses that fact, but
`F3ReturnExcursionFrozenSemanticInventoryAxiomAudit.lean` prints axioms only
for `semantic_rule_piStar`.  Consequently, the three-axiom profile logged for
that theorem did not audit the three native inventory checks.

Ledger classification:

```text
F3_SEMANTIC_INVENTORY_v1_REPORT_DISCLOSURE = CORRECT
F3_SEMANTIC_INVENTORY_v1_NATIVE_FACT_AXIOM_COVERAGE = INCOMPLETE
F3_SEMANTIC_INVENTORY_v1_RETRACTION = NOT_REQUIRED
F3_SEMANTIC_INVENTORY_v1_FOLLOWUP = PRINT_AXIOMS_FOR_THREE_NATIVE_FACTS
```

The report's finite-inventory PASS remains calibrated because it already
states `native_decide`; the new note closes ambiguity about what its original
axiom-audit file did and did not print.

## C. Dependency cone of signed F3 artifacts

- Original M0-a and rational M0-b at commit `515221d...` predate and neither
  import nor reference the six declarations above.
- M0-b Real imports Mathlib and does not depend on them.
- `F3ReturnExcursionSemanticBridge` imports M0-a.  The semantic inventory
  imports the bridge, not conversely.
- `F3ReturnExcursionExactCoreMatrixOrientation` imports the exact-matrix
  module nominally, but its audited theorems do not consume any of the three
  native facts.  Its audit shows only `propext`, `Classical.choice`, and
  `Quot.sound`.
- Repository reference inspection finds the exact-matrix native facts only
  in their definitions and their own audit.

Therefore M0-a, M0-b, and the signed bridges are not retracted.  Their proof
terms do not inherit `Lean.ofReduceBool` from these declarations.

Historical V1/V2/V3 core-identity shard attempts generated native length
checks (`block_edge_count` or `remapped_block_count`), but none produced a
signed theorem: they are `STOP_AND_RECORD` exploration and are not part of a
proved dependency cone.

## D. Corrected pilot route

The pilot imports `F3ReturnExcursionExactCoreMatrix` to expose `CoreEdge`,
`coreEdges`, and `channelWeight`; it does not reference
`core_edge_count`, `frozen_weight_count`, or
`core_edges_have_valid_channels`.

`pilotFrozen_length` now follows from the private arithmetic positional
normalization by `rfl`, then `rw`/`simp` on `List.ofFn`.  No historical native
length theorem occurs in that proof route.  This is a static elimination of
the proof dependency, not yet a Lean PASS.  The future axiom audit explicitly
prints `pilotFrozen_length` and all public downstream results; absence of
`Lean.ofReduceBool` there is a mandatory acceptance condition.

