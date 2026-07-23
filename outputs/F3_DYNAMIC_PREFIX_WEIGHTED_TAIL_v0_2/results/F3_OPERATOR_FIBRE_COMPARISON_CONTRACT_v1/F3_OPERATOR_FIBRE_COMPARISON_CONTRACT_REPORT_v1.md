# F3_OPERATOR_FIBRE_COMPARISON_CONTRACT_REPORT_v1

Status: `CONTRACT_COMPILES_COMPARISON_HYPOTHESES_OPEN`

The contract module and its axiom audit completed with exit status 0.  The
contract packages `M`, the frozen weight, the initial mass, and the
shift-aware `ExpansionLedger`.  Its sole exported result transfers cumulative
`weightedMass (iteratePush M initial n)` to the root fibre cardinality, using
Lema A's finite layer accounting.

The two substantive fields remain hypotheses of the contract:

- `mass_identification`, identifying operator iterate mass with a ledger
  layer;
- `preserve`, proving the layer fibre bound after one expansion.

No F3 instance discharges them yet.  Therefore this result is an explicit
comparison boundary, not a rho certificate, density theorem, almost-all
claim, or global Collatz claim.

Commands run:

```text
lake env lean CollatzClassical/KL2003/F3ReturnExcursionOperatorFibreComparisonContract.lean
lake env lean CollatzClassical/KL2003/F3ReturnExcursionOperatorFibreComparisonContractAxiomAudit.lean
```

Both exited with status 0 and emitted no error diagnostics.
