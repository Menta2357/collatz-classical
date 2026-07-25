# F3 R3 active operator reindex — execution report v1

Date: 2026-07-25.

Base commit: `d952058` (`Reconcile F3 R3 semantic gate after carrier proof`).

Branch: `codex/hilo2-f3-r3-active-carrier-v1`.

```text
R3_ACTIVE_CARRIER_BUILD_PASS
R3_OPERATOR_TO_ACTIVE_REINDEX_BUILD_PASS
STATIC_SOURCE_AUDIT_PASS_WITH_SCOPE_NOTES
PUBLIC_DECLARATION_AUDIT_75_OF_75_PASS
NAMESPACE_DECLARATION_AUDIT_316_OF_316_PASS
HISTORICAL_FORBIDDEN_CONES_75_OF_75_PASS
NO_FIRST_HIT_THEOREM
NO_RHO_9_OVER_5_THEOREM
NO_DENSITY_THEOREM
```

## 1. Exact result

The central theorem is
`F3Block0ActiveOperatorReindex.block0_operator_active_reindex`:

```lean
weightedMass forwardRightWeight
    (push formulaForwardMatrix initialUnitMass) =
  ∑ p in active0Carrier, activeContribution p
```

This is an exact finite, one-layer reindexing of the formula-defined F3
operator. The active multiplicity is `1` on a retarded edge and `3` on an
advanced edge. The balance theorem

```lean
Fintype.card (ActiveRootFibre e) * activeMultiplicity e =
  (stateFiber (formulaSource e)).card
```

shows that this factor restores the three fine lifts exactly once.

The compiled cardinality statements are:

- `active0Carrier.card = 1620`;
- `Fintype.card SeenActive0Occurrence = 68`;
- `Fintype.card FreshActive0Occurrence = 1552`.

The latter two count typed subtypes. This report does not claim the still
unwritten bridge statements `active0SeenCarrier.card = 68` or
`active0FreshCarrier.card = 1552`, nor the unformalized split
`1620 = 972 + 648`.

## 2. Build receipts

The root sequential build

```text
lake build \
  CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveOperatorReindex
```

completed `6936/6936` with exit code `0`. The resulting hashes were:

```text
ActiveOperatorReindex source  64ac2e723e5bca3fc73d7cec94aac6aa9b57486ff13c8a7844bc3ce55a18ce94
ActiveOperatorReindex olean   56887a3cc1767f67e9dc847ae5352adf042d8c6eb7e295989ca50f72e9e11871
```

The separate audit build

```text
lake build \
  CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveR3AxiomAudit
```

completed `6943/6943` with exit code `0`:

```text
ActiveR3AxiomAudit source     5fa41208ebaada31a7443a0932456d129899494b711d1ad4c1a4a5c9473fdda2
ActiveR3AxiomAudit olean      11cc8e64cc5c1e3c389e9383bd92f19bb6ab97ae67f25f6376b9984125dcb131
```

## 3. Audit coverage

The audit enumerates all `75/75` public source declarations and sweeps all
`316/316` generated declarations below the five new namespaces:

| namespace layer | declarations audited |
|---|---:|
| active carrier | 51 |
| active carrier cards | 135 |
| active weights | 25 |
| formula row | 1 |
| operator reindex | 104 |

Public roots use only subsets of `propext`, `Classical.choice`, and
`Quot.sound`. The audit finds no `Lean.ofReduceBool`, `Lean.trustCompiler`,
or `sorryAx`, and the static source scan finds no `native_decide`, `sorry`,
`admit`, explicit `axiom`, `find?`, `HashMap`, or lookup table.

All `75/75` public roots also pass explicit transitive-cone rejection for
the three historical frozen-table declarations:

```text
core_edge_count
frozen_weight_count
core_edges_have_valid_channels
```

The only explicit ordinary `decide` in the construction proves positivity
of the frozen 81-entry forward-weight vector over the finite type `Fin 81`.

## 4. Scope and next gate

This result closes the finite operator-to-active-carrier identity only. It
does not define an ordered first-hit fibre, prove member-wise capacity,
bound omitted mass, iterate the construction, or establish
`rho >= 9/5`.

Tao's Proposition 5.2 supplies the external methodological template for the
next layer: step back from a first-entry event, preserve the affine itinerary
and sum only after uniqueness removes double counting. The next authorized
object is therefore the frozen reverse-first-hit generator/verifier with
soundness, completeness and temporal-order theorems. The finite gate after
that object must return exactly one of: semantic PASS, mathematical STOP, or
certified interval inconclusive.
