# F3 Block0 carrier — execution report v1

## Custody coordinates

- Repository: `coordinated/hilo2-f3`
- Local branch: `codex/hilo2-f3-block0-carrier-v1`
- Base and pre-work HEAD: `238baaef91378f880b1d34434a2218036c229e2f`
- Verified public-v5 reconciliation: local HEAD and fetched public branch both
  resolved to that commit before edits.
- Final SHA-256 source hashes for the ten construction modules and the
  audit-only module are recorded below.  The report itself is deliberately
  excluded from this non-self-referential source manifest.
- Custody coordinate: deliberately non-self-referential.  The Git commit that
  contains this report is the authoritative R2 source coordinate; the
  subsequent R3 scoping commit and public draft PR record that commit hash.

| Lean source | SHA-256 |
|---|---|
| `F3ReturnExcursionBlock0Carrier.lean` | `ddafe8c0d48e25b7077e3c1f0abbb8ed4550970e2ee1b483eb53738f3c27fb18` |
| `F3ReturnExcursionBlock0CarrierFibers.lean` | `4789e20b4f000782653b0577336e60f5f839691b943a6f24228cfc9e316f869b` |
| `F3ReturnExcursionBlock0CarrierFiberCards.lean` | `a242f7983247678e0fc42f4ac4ef475cb68010f0975dfb81230097e106e08f33` |
| `F3ReturnExcursionBlock0CarrierStateCards.lean` | `146e7323c2b3f2947e54bf25cb1087b2f625568de4a2311dcea59c54a34eedac` |
| `F3ReturnExcursionBlock0OccurrenceCards.lean` | `792c34dc33df8c333fa4234f75436694ec491593719b574d032ff937c1ca2b36` |
| `F3ReturnExcursionBlock0FormulaFiberCards.lean` | `7eb99a70df81ba96b02db94caf2ab3b49259b6fc03eabf204c0c8453ac0f6112` |
| `F3ReturnExcursionBlock0OccurrenceSigmaCards.lean` | `a2de45b09372d429d283e60c7fcc35e2c74e9d71527d82a7f7cb1bfecac3b51e` |
| `F3ReturnExcursionBlock0OccurrenceTripleWeights.lean` | `999c50d3a914937847e63fa5119fb6e280da1dd4431bc10d1349279b9a7b6da3` |
| `F3ReturnExcursionBlock0OccurrenceNumericTotal.lean` | `bda302176b3143975925041259cc2e71e2966d331c022d93726445116397702f` |
| `F3ReturnExcursionBlock0OccurrenceTotal.lean` | `464cd17e1c3667af072ee469bf2a29e94ddf8e90514f644294183d521d2adf14` |
| `F3ReturnExcursionBlock0R2AxiomAudit.lean` | `32cbed3fa75017bfe43384d277dbedfa2f6f01a7cf093ae99320616c828a21cd` |

## Scope and final result

This is a definition-first finite-carrier layer.  It does not execute Block0
paths, define a first-hit event, or state a boundary fraction, exponent, or
density conclusion.

The final compiled statements establish:

- the literal root carrier `{a | 3 ≤ a ∧ a < 2919 ∧ a % 3 = 2}` has exactly
  972 roots, canonically partitioned as 41 previously inspected and 931 fresh;
- every state/fine-lift fibre has size 2 when the state bucket is zero and 1
  otherwise;
- every state fibre has size 6 when the bucket is zero and 3 otherwise;
- every root has 4, 1, or 4 formula occurrences according to the relevant
  quotient residue;
- `Fintype.card Block0Occurrence = 2916`; and
- `block0OccurrenceCarrier.card = 2916`.

The occurrence-to-row map retains the root tag and is injective, so equal
matrix rows belonging to different roots are not collapsed.

All construction modules set `maxHeartbeats 200000`; that limit was never
increased.

## Final ten-module surface

| Module | Principal gate | Directed compile | Object build |
|---|---|---:|---:|
| `F3ReturnExcursionBlock0Carrier` | exact carrier and 41/931 partition | PASS, about 8.3 s | PASS |
| `F3ReturnExcursionBlock0CarrierFibers` | state/fine definitions, occurrence subtype, tagged row injection | PASS, about 111 s | PASS; cold dependency rebuild included |
| `F3ReturnExcursionBlock0CarrierFiberCards` | `Fin 972 ≃ Fin 81 × Fin 12`, period reduction, fine-fibre cards | PASS, about 145 s | PASS |
| `F3ReturnExcursionBlock0CarrierStateCards` | structural sum of the three fine fibres | PASS, about 80 s | PASS |
| `F3ReturnExcursionBlock0OccurrenceCards` | constructor/source equivalences | PASS, about 104 s | PASS |
| `F3ReturnExcursionBlock0FormulaFiberCards` | structural 4/1/4 formula-fibre theorem | PASS, about 184 s | PASS |
| `F3ReturnExcursionBlock0OccurrenceSigmaCards` | occurrence sigma equivalence and typed double count | PASS, about 124 s | PASS |
| `F3ReturnExcursionBlock0OccurrenceTripleWeights` | `Fin 972 ≃ Fin 324 × Fin 3`, local `1+4+4=9` | PASS, about 113 s | PASS |
| `F3ReturnExcursionBlock0OccurrenceNumericTotal` | typed occurrence cardinality 2916 | PASS, about 114 s | PASS |
| `F3ReturnExcursionBlock0OccurrenceTotal` | Finset/subtype bridge and carrier cardinality 2916 | PASS, about 108 s | PASS `[6913/6913]` |

The recurring object-producing command was:

```text
lake build CollatzClassical.KL2003.<module-name>
```

The directed source check was:

```text
lake env lean CollatzClassical/KL2003/<module-name>.lean
```

The final object build reported:

```text
✔ [6913/6913] Built CollatzClassical.KL2003.F3ReturnExcursionBlock0OccurrenceTotal
Build completed successfully.
```

## Audit-only surface

`F3ReturnExcursionBlock0R2AxiomAudit` is an eleventh, audit-only module.  It
is not imported by the ten-module construction and adds no public
construction theorem.  Its object build command was:

```text
lake build CollatzClassical.KL2003.F3ReturnExcursionBlock0R2AxiomAudit
```

The build exited successfully and reported:

```text
✔ [6914/6914] Built CollatzClassical.KL2003.F3ReturnExcursionBlock0R2AxiomAudit
Build completed successfully.
```

Its terminal audit markers were:

```text
EXPLICIT_DECLARATION_COVERAGE=87/87
NAMESPACE_PREFIX_COVERAGE=10/10
NAMESPACE_DECLARATION_TOTAL=306
R2_BLOCK0_AUDIT_PASS
```

## Environment recovery

- After disk cleanup, the H2 Mathlib cache and
  `F3ReturnExcursionExactCoreMatrix.olean` were absent.
- Mathlib cache recovery downloaded 6890/6890 objects.  The cache helper's
  trailing missing-`curl.cfg` status occurred after the objects were present.
- `F3ReturnExcursionExactCoreMatrix` then rebuilt successfully in about 127 s.
- This recovery is an environmental event, not a mathematical retry.

## Exploratory finite-certificate STOP narratives

The raw terminal receipts below were observed in-session but were not written
to immutable log files.  Their custody label is therefore:

`EXPLORATORY_STOP_NARRATIVE_ONLY / RAW_RECEIPT_NOT_PRESERVED`.

1. One closed kernel certificate over 243 states, 3 fine lifts, and the
   original 972-root filters reached the fixed 200000-heartbeat limit after
   about 120.5 s.
2. Splitting the same global computation by the three fine-lift values did
   not cure the cost: each declaration reached the same fixed limit (about
   154.7 s total wall time).

There was no identical retry and no budget increase.  The global enumeration
route was closed.  The successful replacement first proves the 81-by-12
coordinate equivalence and exact fibre bijection; its sole kernel `decide`
checks the explicit length-12 period (8748 period-level predicates rather
than 708588 root/fine tests).

## Static-complexity aborts

These are not theorem failures, timeouts, or mathematical STOPs.  Each run was
manually interrupted with exit code 130 after inspection showed that the
proof presentation obscured where normalization cost lived.

1. `ABORTED_BY_STATIC_COMPLEXITY_AUDIT`: a `simp` proof of the double count
   risked materializing the 972-by-729 product; observed at roughly 11 min.
   It was replaced by the typed sigma equivalence.
2. `ABORTED_BY_SECOND_STATIC_COMPLEXITY_AUDIT`: sigma, arithmetic total, and
   Finset bridge still lived in one module; it was split at the sigma gate.
3. `ABORTED_BY_THIRD_STATIC_COMPLEXITY_AUDIT`: arithmetic total and Finset
   bridge remained combined; observed at roughly 8 min and split again.
4. `ABORTED_BY_FOURTH_STATIC_COMPLEXITY_AUDIT`: local triple lemmas and the
   global sum remained combined; observed at roughly 9 min.  They were split,
   and `simp_rw` was replaced by an explicit `Finset.sum_congr` step.

After the final split, the three isolated layers compiled independently:
triple weights PASS, typed numeric total PASS, and Finset bridge PASS.

## Trust and dependency boundary

The ten new construction modules themselves contain no use of
`native_decide`, `ofReduceBool`, a literal root/edge catalogue, or transition
path execution.  The successful period certificate uses ordinary kernel
`decide` after a proved 81-fold structural reduction.

This local-source statement is not a claim that every imported file has the
same profile.  The historical imported module `F3ReturnExcursionExactCoreMatrix`
contains the frozen `coreEdges` data and the named certificates
`core_edge_count`, `frozen_weight_count`, and
`core_edges_have_valid_channels`.  The final audit separately establishes
whether any new public declaration's transitive named dependency cone reaches
those declarations.

- Explicit source inventory: **PASS, 87/87** named declarations.
- Namespace breadth: **PASS, 10/10** namespace prefixes and 306 declarations,
  including constructors, recursors, and other generated declarations.
- Explicit-root axiom profiles: **PASS**; the only reported axioms were the
  standard `propext`, `Classical.choice`, and `Quot.sound` (or an empty
  profile).  Across both explicit roots and the wider namespace sweep, the
  audit found no `Lean.ofReduceBool`, `Lean.trustCompiler`, or `sorryAx`.
- Forbidden named-dependency traversal: **PASS for all 87 explicit roots**;
  none of their transitive named kernel-dependency cones reached
  `core_edge_count`, `frozen_weight_count`, or
  `core_edges_have_valid_channels`.
- Final static token/whitespace audit: **PASS** for the construction-source
  prohibitions and whitespace checks recorded for this worktree.

Calibrated execution-time status before the custody commit:
`R2_BLOCK0_CARRIER_COMPILED_AND_AUDITED_LOCALLY / UNCOMMITTED_UNPUBLISHED`.
This status applies to the eleven SHA-256-pinned sources above.  It does not
declare the historical imported route globally kernel-clean or
dependency-clean, and it makes no F3 exponent, first-hit, or density claim.
Later Git custody changes only the publication status, not this recorded
execution-time verdict.
