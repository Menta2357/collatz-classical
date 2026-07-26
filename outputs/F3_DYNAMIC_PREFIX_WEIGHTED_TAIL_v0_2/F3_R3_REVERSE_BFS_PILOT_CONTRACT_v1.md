# F3 R3 reverse-BFS six-row pilot contract v1

Date: 2026-07-25.

Status:

```text
CONTRACT_PREDECLARED_BEFORE_REVERSE_SEARCH
EXACT_PILOT_ROWS_FIXED_6_OF_6
MASS_PROFILE_1168_D1_452_D2_USED
SOURCE_HASH_FREEZE_PENDING
NO_ORBIT_EXECUTION_FOR_THIS_CONTRACT
NO_LEAN_EXECUTION_FOR_THIS_CONTRACT
NO_REVERSE_BFS_RESULT_OBSERVED
NO_R3_FINITE_PASS
NO_F3_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## 1. Objective and scope

This contract fixes a six-row pilot for the typed Block0 reverse-BFS
generator/verifier architecture.  It is a pre-execution document: preparing
it evaluated only the frozen natural-number formulae used to identify the
rows and did not execute a Collatz orbit, a reverse search, Lean, or `lake`.

The pilot asks one narrow question: can the untrusted reverse generator emit
a certificate for each predeclared owner that the kernel checker accepts?
It does not establish the universal 1620-owner capacity statement.  A PASS
authorizes a separately contracted expansion; it is not an R3 or F3 theorem.

The frozen mass profile to which the sample belongs is:

```text
active owners             = 1620
demand-one owners (D1)    = 1168
demand-two owners (D2)    = 452
total atom demand          = 2072
```

These are the statements `active0Carrier_card`, `demandOneCarrier_card`,
`demandTwoCarrier_card`, and `sum_massDemand_active0Carrier`.  Their source
and trust-audit hashes must be frozen before this pilot is run.

## 2. Row-selection rule fixed before search

An `Active0Occurrence` is identified by the following reproducible semantic
key:

```text
(rootIndex, rootValue, FormulaEdge constructor, formulaSource.val, ell.val?)
```

`rootIndex` is zero-based and reconstructs the root as `i : Fin 972`, with
`rootValue i = 5 + 3*i`.  The constructor, source value, and optional
fine-lift value reconstruct the `FormulaEdge`; the source equality and
`Active0` proof reconstruct the two subtype layers.  The future pilot module
must prove each reconstruction and may not accept a row only by an external
string or table lookup.

For each of the three constructors, the selected D2 row is the active row
with maximum exact rational `qHi`.  The D1 control is the active D1 row with
maximum exact rational `qHi` subject to `qHi <= 1`, so it tests the nearest
certified side of the demand boundary.  Rational comparison is by exact
cross multiplication.  Ties are broken by the lexicographically least

```text
(rootIndex, formulaSource.val, ellKey)
```

where `ellKey = 0,1,2` for an advanced edge and `ellKey = -1` for a retarded
edge.  This selection rule, the six results below, and their order may not be
changed after any reverse-search result is observed.

As a non-semantic consistency check, the same formula-only enumeration gave
the channel split below and reproduced the already formalized total
`1168/452` exactly:

| constructor | D1 | D2 | total |
|---|---:|---:|---:|
| `retarded` | 648 | 324 | 972 |
| `advancedDirect` | 224 | 100 | 324 |
| `advancedParityLift` | 296 | 28 | 324 |
| **total** | **1168** | **452** | **1620** |

The per-channel split and the maximizer identities are pilot coordinates,
not new kernel theorems.  The pilot row module must recheck every displayed
identity with ordinary kernel reduction before it can produce a verdict.

## 3. The six exact rows and execution order

The order is immutable and execution is sequential.

| order | row id | constructor | demand | root index | parent `a` | source | `ell` | formula target | exact `qHi` | semantic child | child window |
|---:|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | `RET_D2_MAX` | `retarded` | 2 | 24 | 77 | 75 | - | 65 | `875/837` | 308 | 19712 |
| 2 | `RET_D1_CONTROL` | `retarded` | 1 | 11 | 38 | 37 | - | 152 | `10300/11907` | 152 | 9728 |
| 3 | `DIRECT_D2_MAX` | `advancedDirect` | 2 | 52 | 161 | 159 | 0 | 105 | `580743/404000` | 107 | 41088 |
| 4 | `DIRECT_D1_CONTROL` | `advancedDirect` | 1 | 76 | 233 | 231 | 0 | 153 | `2983/3000` | 155 | 59520 |
| 5 | `LIFT_D2_MAX` | `advancedParityLift` | 2 | 44 | 137 | 135 | 0 | 181 | `8007/6100` | 182 | 34944 |
| 6 | `LIFT_D1_CONTROL` | `advancedParityLift` | 1 | 224 | 677 | 189 | 2 | 172 | `157/162` | 902 | 173184 |

For advanced rows, `c = 3 + 2*rootIndex`; the direct semantic child is `c`,
the parity-lift child is `2*c`, and both use window `384*c`.  Retarded rows
use child `4*a` and window `256*a`.  The future row module must prove these
coordinates from `parentRoot`, `semanticChildRoot`, `childWindow0`,
`qHiNumerator`, `qHiDenominator`, and `massDemandShadow`; duplicating them as
trusted definitions is forbidden.

## 4. Sources whose hashes must be frozen

No semantic execution is authorized while any entry in this table is
`PENDING_FREEZE`.  Exact SHA-256 values must be written, before execution, to

```text
outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/
  F3_R3_REVERSE_BFS_PILOT_v1/frozen_sources.sha256
```

The manifest itself and this contract must then be hashed in the run report.
This v1 contract is not edited in place to insert later hashes.

| role | source | SHA-256 before execution |
|---|---|---|
| active owner type | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ActiveCarrier.lean` | `PENDING_FREEZE` |
| active owner cardinality | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ActiveCarrierTotalCards.lean` | `PENDING_FREEZE` |
| exact ordered semantics | `CollatzClassical/KL2003/F3ReturnExcursionBlock0OrderedFirstHit.lean` | `PENDING_FREEZE` |
| Boolean/Prop semantic bridge | `CollatzClassical/KL2003/F3ReturnExcursionBlock0OrderedFirstHitBool.lean` | `PENDING_FREEZE` |
| exact bounded predecessors | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReversePredecessor.lean` | `PENDING_FREEZE` |
| owner-preserving mass atoms | `CollatzClassical/KL2003/F3ReturnExcursionBlock0MassAtoms.lean` | `PENDING_FREEZE` |
| exact demand profile | `CollatzClassical/KL2003/F3ReturnExcursionBlock0MassDemandProfile.lean` | `PENDING_FREEZE` |
| demand-profile audit | `CollatzClassical/KL2003/F3ReturnExcursionBlock0MassDemandProfileAxiomAudit.lean` | `PENDING_FREEZE` |
| untrusted generator/data | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSData.lean` | `PENDING_FREEZE` |
| kernel checker/soundness | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSVerifier.lean` | `PENDING_FREEZE` |
| typed demand adapter | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSMassIntegration.lean` | `PENDING_FREEZE` |
| deficient completeness | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSCompleteness.lean` | `PENDING_FREEZE` |
| reverse-BFS trust audit | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSAxiomAudit.lean` | `PENDING_FREEZE` |
| completeness trust audit | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSCompletenessAxiomAudit.lean` | `PENDING_FREEZE` |
| six typed row constants | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotRows.lean` | `PENDING_CREATION_AND_FREEZE` |
| six literal payload checks | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilot.lean` | `PENDING_CREATION_AND_FREEZE` |
| pilot theorem audit | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotAxiomAudit.lean` | `PENDING_CREATION_AND_FREEZE` |

A checksum mismatch is `INVALID_SOURCE_DRIFT`.  It is never repaired during
the run by silently updating the manifest.

## 5. Generator/checker separation

The generator output is untrusted data.  It may be produced by compiled
evaluation and serialized as six literal `ReverseBFSCertificate` values.
No generated proof term, Boolean result, expected edge, trajectory table, or
precomputed acceptance bit may enter a public theorem.

Each literal payload is accepted only through

```lean
verifyTypedReverseBFSCertificate selectedOccurrence literalCertificate = true
```

using ordinary kernel-reduced `decide`.  `native_decide`, `ofReduceBool`,
`trustCompiler`, `sorryAx`, `axiom`, `admit`, and `sorry` are forbidden in the
pilot's public theorem dependency cone.  The generator need not be trusted
and is not a proof oracle.

## 6. Required checker coverage

For each of the six rows, the run report must show that the typed checker
covers all of the following fields.  Sampling is not coverage.

1. The typed occurrence fixes the expected demand through
   `massDemandShadow`, and `massDemand_eq_shadow` transfers it to
   `massDemand = ceil(qHi)`.
2. `claimedDemand` equals that expected demand and is positive.
3. The node list is nonempty and `nodeValues` is duplicate-free.
4. Every enumerated node satisfies the complete structural Boolean checker:
   positive value, value at most the frozen window, value different from the
   forbidden parent, exact node-zero target/depth/parent index, and for later
   nodes an earlier parent index, depth increment, and exact `T` edge.
5. Every retained node passes `firstHitViaChildAtBool` at its supplied depth;
   the proved Boolean/Proposition equivalence is used to recover the ordered
   semantic predicate.
6. A `saturated` payload has exactly `demand` nodes and no closure rows.
7. A `deficient` payload has fewer than `demand` nodes; its closure rows align
   exactly with node values, are duplicate-free, equal the complete
   `preimagesWithin` set member-wise, and contain only retained values.
8. Saturated soundness derives
   `massDemand p <= (orderedFirstHitFiber0 p).card`.
9. Deficient completeness derives
   `(orderedFirstHitFiber0 p).card < massDemand p`.

The axiom audit must enumerate every public declaration in the three new
pilot modules, sweep their namespaces, state its declaration counts, and
fail hard outside the exact whitelist

```text
propext, Classical.choice, Quot.sound
```

The audit covers the trust profile of the checker and its conclusions.  It
does not turn the six-row pilot into a proof about the other 1614 owners.

## 7. Fixed resources and attempt discipline

All phases are serial.  Cold dependency preparation is separated from the
single semantic attempt so that an import miss is not misreported as a
mathematical outcome.

| phase | ceiling | Lean options / rule | attempts |
|---|---:|---|---:|
| source/hash/static preflight | 600 s | no orbit or reverse generation | 1 |
| cold dependency build | 3600 s | no pilot payload generated | 1 |
| untrusted generation | 300 s per row, 1800 s total | rows 1 through 6, sequential | 1 per row |
| six-row kernel verification | 3600 s total | `maxHeartbeats 20000000`, `maxRecDepth 100000` | 1 |
| exhaustive axiom audit | 3600 s total | same heartbeat/depth ceilings | 1 |

Peak-memory use and wall times must be recorded.  There is no parallel row
execution, retry, cache-dependent substitution, or change of row order.

After the first generated node or certificate is observed, it is forbidden
to increase time, heartbeats, recursion depth, memory, fuel, demand, window,
or sample size; to replace a row; to change the selector; or to introduce a
native/trusted shortcut.  A timeout or resource exhaustion is an INVALID
pilot, not permission to expand the budget.  Any later architecture study
must have a new contract and cannot rewrite this v1 verdict.

## 8. Mandatory execution order

1. Verify a clean declared base and freeze all source hashes.
2. Compile and audit the prerequisite semantic, demand, verifier, and
   completeness modules without generating a pilot payload.
3. Compile the six row constants and prove all row coordinates and demands.
4. Generate the six untrusted payloads in the exact order of Section 3 and
   preserve raw output even if a later check fails.
5. Freeze the literal payload source before compiling any acceptance theorem.
6. Run the six typed kernel checks once, in the same order.
7. If all six checks elaborate, run the exhaustive pilot axiom audit once.
8. Emit exactly one verdict from Section 9 and preserve hashes, raw logs,
   timings, memory measurements, certificate kinds, node counts, and closure
   row counts.  Custody is required for PASS, STOP, and INVALID alike.

## 9. Predeclared verdicts

### `PASS_R3_REVERSE_BFS_PILOT_6_OF_6`

PASS requires all of the following:

- hashes and six row identities match the frozen manifest;
- all six typed checks return/prove `true`;
- all six accepted certificates have kind `saturated`;
- the complete audit passes with the declared whitelist and coverage;
- all resource and ordering rules were respected.

This proves capacity only for the six selected owners.  It authorizes a new
contract for wider Block0 coverage and makes no exponent or density claim.

### `STOP_R3_REVERSE_CAPACITY_COUNTEREXAMPLE`

STOP requires a kernel-accepted `deficient` certificate for at least one of
the six frozen rows and successful application of the deficient completeness
theorem yielding

```text
(orderedFirstHitFiber0 p).card < massDemand p.
```

That row is a certified counterexample to the universal capacity premise for
this ordered-fibre route.  The exact certificate, row, and audit remain part
of the public custody record.  No row or window may be replaced to avoid it.

### `INVALID_R3_REVERSE_BFS_PILOT`

INVALID is mandatory for source drift, a failed row-coordinate proof, a
generated payload rejected by the checker, missing checker coverage, build
or audit failure, timeout/resource exhaustion, missing raw logs, execution
out of order, retry, or any forbidden mechanism.  INVALID is not evidence
for or against the mathematical capacity statement and does not authorize a
same-contract rerun.

## 10. No-claim boundary

Even a six-row PASS does not establish the 1620-owner member-wise inequality,
the Block0 boundary estimate, a depth-uniform first-hit lemma, `rho = 9/5`, a
positive-density theorem, or Collatz.  The only mathematical negative result
available from this pilot is the explicitly audited deficient STOP in
Section 9.
