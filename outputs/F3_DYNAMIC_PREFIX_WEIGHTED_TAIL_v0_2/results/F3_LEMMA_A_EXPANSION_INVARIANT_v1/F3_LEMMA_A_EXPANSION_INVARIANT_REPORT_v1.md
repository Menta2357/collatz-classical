# F3_LEMMA_A_EXPANSION_INVARIANT_REPORT_v1

Status: `GENERIC_INDUCTIVE_INTERFACE_PASS_OPERATOR_INSTANTIATION_OPEN`

The module `F3ReturnExcursionLemmaAExpansionInvariant.lean` compiled and its
axiom audit completed without diagnostics.  It defines an
`ExpansionLedger` carrying the layer index, accumulated shift, mass, and
fibre.  The induction is over the layer number and does not enumerate paths.

Verified results:

- `layerBound_all_of_base_step`: base plus one-step preservation gives the
  layer bound at every depth;
- `cumulative_layer_mass_le_root_card`: global fibre disjointness and root
  inclusion bound the cumulative layer mass;
- `operator_mass_le_root_of_layer_identification`: an explicit identification
  of operator mass with the layer mass transfers the bound to the operator.

The one-step preservation and mass-identification hypotheses are intentionally
not discharged here.  They are the concrete F3 operator-to-fibre obligation.
Consequently this is not a rho certificate, density theorem, almost-all claim,
or global Collatz claim.

Commands run:

```text
lake env lean CollatzClassical/KL2003/F3ReturnExcursionLemmaAExpansionInvariant.lean
lake env lean CollatzClassical/KL2003/F3ReturnExcursionLemmaAExpansionInvariantAxiomAudit.lean
```

Both exited with status 0 and emitted no error diagnostics.
