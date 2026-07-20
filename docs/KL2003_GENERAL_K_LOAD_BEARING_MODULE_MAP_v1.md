# KL2003 general-k load-bearing module map v1

Date: 2026-07-20

Status: `IMPLEMENTED_AUDITED_REVIEWED_WITH_PROOF_REARCHITECTURE`

This note maps the implemented general-k chain and records the completed
adversarial review of its load-bearing spine. The review found no semantic
blocker for the k=3 consumer or a future k=9 consumer, but it records one
important fidelity distinction: the implementation does not formalize the
canonical, order-independent EL normal form asserted by KL2003 Theorem 3.1.
Instead it proves the needed bound through a pointwise critical scheduler,
uniform finite depth/window bounds, and dynamic retarded induction.

## 1. Inventory boundary

The source tree contains:

- 38 production modules matching `KL2003GeneralK*.lean`;
- 38 corresponding `KL2003GeneralK*AxiomAudit.lean` files;
- one integral k=3 consumer, `KL2003K3LNTCertificate.lean`, with its own audit.

The six load-bearing stages below are the shortest theorem-level spine from
the source semantics to the abstract lower bound. The remaining 32 modules
discharge the scheduler, provenance, termination, elimination, and finite
invariant obligations used by that spine.

## 2. Direct load-bearing spine

| Order | Module | Load-bearing statement | Explicit inputs | Output consumed above |
|---:|---|---|---|---|
| 1 | `KL2003GeneralKSemantics` | `sourcePhiK`, `sourcePhiK_le_piStar`, `sourcePhiK_mono_y`, `sourcePhiK_P3` | tracked mode, source roots, real window parameter | concrete indexed source envelope and member traffic |
| 2 | `KL2003GeneralKCriticalStopSemantics` | `sourcePhiK_satisfiesEL` | `GeneralKClassRootsNonempty (p + 1)` | finite all-retarded witness selected by the critical scheduler for every `y >= 2` |
| 3 | `KL2003GeneralKLNTFeasibilityTransfer` | `sourcePhiK_pointwise_coefficient_feasible` | roots plus `LNTCertificate hp` | coefficient feasibility for the selected all-retarded witness |
| 4 | `KL2003GeneralKUniformCriticalDepth` | `exists_uniform_criticalSelectedDepthBound` | roots | one scheduler-selected depth bound uniform in mode and `y >= 2` |
| 5 | `KL2003GeneralKUniformRetardedWindow` | `exists_uniform_sourceELRetardedWindow` | roots | `mu, nu` with `0 < mu <= nu` bounding every selected retarded shift |
| 6 | `KL2003GeneralKDynamicRetardedLowerBound` | `exists_sourcePhiK_retarded_lower_bound` | roots, `LNTCertificate hp`, and `1 <= certificate.lambda` | positive `Delta` and the lower bound for every mode and every `y >= 0` |

The final abstract statement is:

```lean
exists Delta : Real, 0 < Delta /\
  forall mode y, 0 <= y ->
    Delta * certificate.principal mode * certificate.lambda ^ y <=
      sourcePhiK mode y
```

The dependency direction is:

```text
Semantics
  -> CriticalStopSemantics
  -> LNTFeasibilityTransfer
  -> UniformCriticalDepth
  -> UniformRetardedWindow
  -> DynamicRetardedLowerBound
```

The import graph is linear at this surface, but each stage below
`CriticalStopSemantics` imports a nontrivial auxiliary subtree. Therefore this
table is a review map, not a claim that the chain consists of only six files.

## 3. Hypothesis ledger

| Hypothesis | First material use | Discharger in k=3 | Future k=9 obligation |
|---|---|---|---|
| `1 <= p` | LNT row and scheduler indexing | `p = 2`, discharged by arithmetic | `p = 8`, discharged by arithmetic |
| `GeneralKClassRootsNonempty (p + 1)` | source `iInf`, row semantics, termination | `k3_classRoots_nonempty` | `KL2003K9ClassRoots.generalKClassRootsNonempty_nine` |
| `LNTCertificate hp` | coefficient-feasibility transfer | `k3LNTCertificate` | not yet constructed; shard experiments are not a certificate |
| `1 <= certificate.lambda` | dynamic base normalization and rpow monotonicity | `k3LNTCertificate_lambda_gt_one.le` | must follow from the checked k=9 certificate |
| `0 <= y` | final retarded induction and source member transfer | theorem argument | theorem argument |

No theorem in the spine takes an EL tree, deletion schedule, termination bound,
or semantic row as an external hypothesis. Those objects are constructed by
the auxiliary modules. Review must verify that those constructions match the
KL2003 source semantics rather than merely that the resulting Lean statements
are internally consistent.

## 4. Auxiliary layers

### 4.1 Source windows and row semantics

- `KL2003GeneralKFloorWindow`
- `KL2003GeneralKOriginalRows`
- `KL2003GeneralKRetardedLowerBound`

These modules define the floor window and the source-faithful row inequalities
that feed elimination. Their main review question is whether the Nat/Real
window conversions and all three source row cases preserve the paper's exact
indexing and shifts.

### 4.2 Elimination syntax and normalization

- `KL2003GeneralKElimination`
- `KL2003GeneralKEliminationTree`
- `KL2003GeneralKEliminationContext`
- `KL2003GeneralKEliminationNormalizer`
- `KL2003GeneralKEliminationScheduler`

These modules encode splitting, deletion, contexts, normal forms, and the
basic scheduler. Their main review question is whether normalization and
retention preserve the intended EL inequality without assuming confluence or
uniqueness that the paper does not require.

### 4.3 Transition graph and provenance

- `KL2003GeneralKSourceTransitionGraph`
- `KL2003GeneralKSourceGenealogy`
- `KL2003GeneralKProvenancedScheduler`
- `KL2003GeneralKProvenancedSchedulerDepth`
- `KL2003GeneralKProvenanceTrace`

These modules attach exact source walks to generated leaves. Their main review
question is whether every selected expression leaf retains a valid route back
to the source row after normalization and deletion.

### 4.4 Termination and infinite-branch exclusion

- `KL2003GeneralKTerminationCore`
- `KL2003GeneralKNestedReturnDescent`
- `KL2003GeneralKInfiniteBranchDescent`
- `KL2003GeneralKInfiniteBranchExtraction`
- `KL2003GeneralKExtractedBranchNonnegative`
- `KL2003GeneralKAdvancedRecurrence`
- `KL2003GeneralKAdvancedPrefixRealization`

These modules turn a hypothetical nonterminating scheduler path into an
infinite source walk and exclude it by recurrent descent. Their main review
question is the fidelity of the compactness/recurrence argument to the
paper's high-k feasibility-to-bound justification.

### 4.5 Critical scheduler and stop semantics

- `KL2003GeneralKCriticalTerminalFinder`
- `KL2003GeneralKCriticalSourceStep`
- `KL2003GeneralKCriticalSchedulerRun`
- `KL2003GeneralKCriticalInfiniteBranchExtraction`
- `KL2003GeneralKCriticalAdvancedDominance`
- `KL2003GeneralKAdvancedArrivalBoundedness`

These modules select branches of minima at the current `Phi,y`, propagate
criticality, and obtain the finite negative-shift stop consumed by
`sourcePhiK_satisfiesEL`.

### 4.6 Finite invariants and adversarial audits

- `KL2003GeneralKSelfSimilarity`
- `KL2003GeneralKRetardedCycleAudit`
- `KL2003GeneralKFiniteCycleDescentAudit`
- `KL2003GeneralKRetentionAdmissibilityAudit`
- `KL2003GeneralKTripleWitnessAudit`
- `KL2003GeneralKCriticalTripleWitnessExclusion`

These modules exclude bad finite patterns and certify retention choices. Their
main review question is whether each exclusion is necessary, exhaustive, and
consumed in the termination path rather than existing only as an isolated
true theorem.

## 5. Integral k=3 consumer

`KL2003K3LNTCertificate.lean` provides the current end-to-end instantiation:

- `k3LNTCertificate` builds the abstract `LNTCertificate` from checked k=3
  data;
- `exists_k3_sourcePhiK_lower_bound` applies
  `exists_sourcePhiK_retarded_lower_bound`;
- `exists_k3_piStar_sourceWindow_lower_bound` transfers the `iInf` bound to a
  concrete class root;
- `exists_k3_piStar_arbitrary_x_lower_bound` chooses the exact logarithmic
  source window and proves the bound for arbitrary `x >= a`;
- `gammaK3_gt_three_fifths` proves the public exponent is greater than `3/5`.

The public-shaped terminal statement is:

```lean
exists Delta : Real, 0 < Delta /\
  forall (mode : TrackedMode 3) (a : ClassRootsK 3 mode) (x : Nat),
    a.1 <= x ->
      Delta * (((x : Real) / (a.1 : Real)) ^ gammaK3) <=
        (piStar a.1 x : Real)
```

This is the integral acceptance test for the reviewed chain: a checked finite
certificate is consumed through source semantics to `piStar`, including the
arbitrary-`x` translation and the exponent comparison. The stage reviews are
recorded separately so this successful integration test is not used as a
substitute for statement-fidelity analysis.

## 6. Review order and acceptance criteria

The proposed adversarial review order is:

1. `KL2003GeneralKSemantics`: index set, roots, floor window, `iInf` traffic,
   monotonicity, and P3.
2. `KL2003GeneralKCriticalStopSemantics`: exact content of `SatisfiesEL`, the
   critical branch semantics, and the negative-shift stop.
3. `KL2003GeneralKLNTFeasibilityTransfer`: source LNT inequalities,
   coefficient monotonicity through splitting/deletion, and selected-branch
   transfer.
4. `KL2003GeneralKUniformCriticalDepth`: compactness, Konig extraction, and
   exclusion of a coherent infinite critical walk.
5. `KL2003GeneralKUniformRetardedWindow`: provenance depth to a uniform finite
   negative shift window.
6. `KL2003GeneralKDynamicRetardedLowerBound`: strong induction, base
   normalization, and composition of rows, feasibility, and shift bounds.
7. `KL2003K3LNTCertificate`: end-to-end instantiation, source-window transfer,
   arbitrary-`x` translation, and exponent statement.

Each review pass must record:

- the exact source statement or argument being formalized;
- all hypotheses in the reviewed theorem and their concrete dischargers;
- the auxiliary modules whose content is logically portante for that pass;
- any executable member-wise or finite hook available;
- the `#print axioms` result for the reviewed theorem;
- findings, blockers, and statement-fidelity differences.

All seven passes and the k=3 integral consumer review are now complete. Their
detailed findings are recorded in:

- `KL2003_GENERAL_K_SEMANTICS_ADVERSARIAL_REVIEW_v1.md`;
- `KL2003_GENERAL_K_CRITICAL_STOP_SEMANTICS_ADVERSARIAL_REVIEW_v1.md`;
- `KL2003_GENERAL_K_TRANSFER_UNIFORMITY_AND_K3_ADVERSARIAL_REVIEW_v1.md`.

The resulting classification is:

```text
GENERAL_K_CHAIN_IMPLEMENTED
GENERAL_K_CHAIN_AXIOM_AUDITS_PRESENT
K3_INTEGRAL_CONSUMER_PROVED
GENERAL_K_LOAD_BEARING_MAP_CREATED
GENERAL_K_LOAD_BEARING_REVIEW_COMPLETE
GENERAL_K_REVIEW_PASS_WITH_SCOPE_NOTES
CANONICAL_THEOREM_3_1_NOT_FORMALIZED
POINTWISE_CRITICAL_SCHEDULER_ROUTE_REVIEWED
K3_END_TO_END_CONSUMER_REVIEW_PASS
NO_K9_LNT_CERTIFICATE
NO_K9_SEMANTIC_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## 7. Immediate sequencing

Carril A is intentionally on hold by user direction; this review neither
publishes a Forum post nor creates an audit link. The next technical gate is
the k=9 certificate/checker integration, but it remains unauthorized until its
separate certificate and kernel-budget criteria are satisfied. The untracked
k=9 shard experiments are outside this review and are not promoted here.
