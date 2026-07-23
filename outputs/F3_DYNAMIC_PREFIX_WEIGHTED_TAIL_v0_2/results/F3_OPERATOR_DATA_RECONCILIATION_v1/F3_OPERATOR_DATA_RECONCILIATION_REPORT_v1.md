# F3 operator data reconciliation — report v1

Status: `OFFLINE_DATA_IDENTITY_PASS_LEAN_FORMALIZATION_OPEN`; no rho, density,
almost-all, or global Collatz claim.

## Finding

The M0-a checker and the first Real matrix instance refer to related but
different finite lists:

| object | states | total edges | retarded | advanced-direct | parity-lift |
|---|---:|---:|---:|---:|---:|
| M0-a `splitEdges` | fine IDs `<729` | 1215 | 729 | 243 | 243 |
| frozen core restriction | 243 selected IDs | 729 | 243 | 243 | 243 |
| Lean `F3ExactCoreMatrix.coreEdges` | `Fin 243` local IDs | 729 | 243 | 243 | 243 |

The second row is the intended restriction of the first: the generator reads
the 243 rows of `frozen_w_split_core.csv`, keeps split edges whose source and
target both occur in that selected-state map, and remaps those IDs to
`Fin 243`.  The generated matrix therefore has the expected 729 internal
edges.  An independent reconciliation script compared the generated Lean
sequence entry-by-entry with the filtered/remapped CSV sequence:

```text
selected states       = 243
filtered internal     = 729
generated Lean edges  = 729
sequence_match        = true
channel counts        = 243 / 243 / 243
state_ids_sha256      = 60a3241e428ef05cedb531692467a024603fe9219e1020c90c359b721e9700d0
edge_identity_sha256  = 45a4297196e3f1ea767b0f4cfef8ebbbcf70f31547469fe22768cda9d971e35a
```

This is an offline data pass, not yet a Lean theorem: the current Lean
development still does not prove the construction identity from `splitEdges`
and the frozen-state table.

## Why this is a gate

The semantic inventory proves all 1215 rule rows individually.  The Real
operator bridge, however, uses the 729-edge restricted matrix.  Before the
operator-to-first-hit-fibre inequality can be stated for the actual operator,
one must provide a finite identity with these components:

1. a decidable map from each selected fine state ID to its local `Fin 243`
   index;
2. exact equality between `coreEdges` and the split-edge filter under that
   map, including channel and multiplicity;
3. the orientation convention: the CSV certificate is the left action
   `wᵀ M`, while the Real push-forward uses the transposed
   `coreTransition s t = coreMatrix t s`;
4. a proof that omitted fine states/edges are the declared undercount or
   boundary channel, rather than silently discarded mass.

The existing orientation audit already records the numerical consequence:
the left convention passes, while the untransposed right convention fails.
This report does not repair that issue; it prevents the semantic bridge from
using an unproved identification.

## Next action

The frozen `core_state_ids.csv` and `core_edge_identity.csv` are now
custodied beside this report.  Formalize their filter/remap identity in Lean.
Only after that identity and the orientation theorem pass
should the row-contribution hook be instantiated with `coreMatrix`.

Evidence sources:

- `F3ReturnExcursionM0ACertificate.lean`
  (`split_edge_count`, channel counts);
- `F3ReturnExcursionFrozenSemanticInventory.lean`
  (1215 semantic rows, finite validation);
- `F3ReturnExcursionExactCoreMatrix.lean`
  (729 restricted edges, 243 entries per channel);
- `F3_ORIENTATION_AUDIT_REPORT_v1.md` (left/right action audit).
- `f3_reconcile_core_operator_v1.py` and `summary_v1.json` (independent
  sequence comparison).

This is a data-identity obligation, not a new empirical result.
