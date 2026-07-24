# F3 full block decoder static review v1

Status: `CONDITIONAL_STATIC_PASS / LEAN_NOT_EXECUTED`

Date: 2026-07-24.

The v6 pilot PASS does not justify enumerating 729 cases.  The new decoder
factorizes the full domain into nine blocks of the already audited 81-position
pilot.  It proves block/local inverses, source shifts, `rowStart` periodicity,
edge reconstruction and frozen-position reconstruction before defining the
full position decoder.  The terminal inverse is then two rewrites through the
pilot inverse, not a full-domain case split.

The source has 30 explicit declarations.  Source, inventory and audit command
lists agree 30/30/30; all five designated terminal public theorems are listed.
Static forbidden-syntax checks pass.  No literal edge list, full identity,
first-hit module or native-assisted edge-count theorem is used.

Guard v2 preserves checker v1 as historical evidence while closing its
multiline blind spot.  Its regression passes the real v6 log at 640/640 unique
profiles and rejects a fixture whose forbidden axiom appears only on the
second line of a profile.

The remaining risk is elaboration of the symbolic shift lemmas.  Therefore
this is deliberately a separate compile/audit gate.  A PASS opens only a new
contract for the sole 729-edge `rfl` normalization; a STOP may not be converted
into enumeration, table lookup, resource escalation or a same-source retry.

No Lean, Lake, overlay staging or source-object generation has occurred under
this contract.
