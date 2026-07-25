# F3 R3 active-carrier semantic gate — scoping v1

Date: 2026-07-24.

Status:

```text
R3_SCOPING_ONLY
READ_ONLY_SOURCE_AUDIT_COMPLETE
NO_BLOCK0_EXECUTION_BY_THIS_AUDIT
NO_LEAN_EDIT_BY_THIS_AUDIT
NO_LEAN_COMPILE_BY_THIS_AUDIT
NO_SEMANTIC_HOOK_PROVED
NO_F3_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## 1. Purpose and frozen provenance

This document scopes the first legitimate successor to the withdrawn
historical first-hit gate. It specifies:

1. the active occurrence carrier that preserves the formula-edge
   multiplicity;
2. the one-layer semantic statements that must be proved before any finite
   execution;
3. the tagged-path statements needed for uniform depth;
4. a predeclared finite PASS/STOP rule on the fixed `Block0`;
5. the boundary between finite engineering and new mathematics.

The source audit was performed at:

```text
repository: coordinated/hilo2-f3
branch: codex/hilo2-f3-block0-carrier-v1
tracked HEAD: 238baaef91378f880b1d34434a2218036c229e2f
```

The tracked mathematical sources used are:

```text
CollatzClassical/KL2003/
  F3ReturnExcursionCoreArithmeticCodecPilotRepair.lean
  F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity.lean
  F3ReturnExcursionForwardFormulaRightCertificate.lean
  F3ReturnExcursionRealOperatorBridge.lean
  F3ReturnExcursionRealIterateBridge.lean
  F3ReturnExcursionFirstHitFibers.lean
  F3ReturnExcursionCumulativeFirstHitFibers.lean
  F3ReturnExcursionPiStarAggregateBridge.lean
  F3ReturnExcursionSemanticLowerHook.lean
  F3ReturnExcursionPathLeakageContract.lean
  F3ReturnExcursionTiltedLiveComparison.lean
  F3ReturnExcursionTiltedIterateUpperBound.lean
  F3ReturnExcursionChernoffFirstPassage.lean
```

The paper and audit sources used are:

```text
outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/
  F3_PAPER_CONSOLIDATED_v3_0.md
  F3_PAPER_CONSOLIDATED_v3_1.md
  F3_SPLIT_EDGE_CERTIFICATE_PAPER_PAGE_v1_1.md
  F3_LEMMA_A_EXPANSION_INVARIANT_v1.md
  F3_SEMANTIC_LOWER_HOOK_GAP_v1.md
  F3_SEMANTIC_FIRST_HIT_GATE_V1_RECONCILIATION.md
  F3_UNIFORM_SEMANTIC_HOOK_AUDIT_v2.md
```

During the audit, the worktree also contained definition-first R2 files that
were untracked relative to the declared HEAD, including:

```text
CollatzClassical/KL2003/F3ReturnExcursionBlock0Carrier.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0CarrierFibers.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0CarrierStateCards.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0CarrierFiberCards.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0OccurrenceCards.lean
```

Their names and definitions are used below only as the proposed R2 interface.
This document does not certify their compilation, audit, commit status or
public custody.

## 2. Audit verdict on the paper A+V route

The material called Lemma A and Lemma V in paper v3.0 is a proof skeleton,
not yet an operator-to-fibre proof on the actual F3 carrier.

The reusable content is real:

- the intended first-differing-edge disjointness mechanism;
- the requirement that a loss be charged at its first omission;
- the finite operator algebra and exact forward matrix;
- the generic tilted comparison, iterate upper bound, first-passage and
  leakage lemmas.

The missing content is load-bearing:

- no composable `FormulaEdge` path type with occurrence tags;
- no matrix/path mass identity for those paths;
- no root-dependent window theorem;
- no full-path first-hit predicate;
- no multiplicity-preserving realization of formula contributions by fibre
  cardinalities;
- no prefix-free global disjointness theorem;
- no first-omission partition on the same carrier as the operator mass;
- no valid uniform boundary denominator;
- no identification of the concrete live family with the tilted operator.

The paper atom

```text
A(P) = (1 + delta)^|P| * M_star(P) * w(endpoint(P))
```

must not be copied into R3 as an already justified semantic mass. The exact
matrix-path expansion already contains the product of the `M_star` edge
entries. The factor `55/54` is supplied by the forward row theorem and must
be charged exactly once. Any additional pathwise factor requires a separate
proved normalization identity.

The existing cumulative first-hit theorem is also insufficient for R3. Its
global disjointness hypothesis asks distinct indices to have distinct
terminal children, while the arithmetic equation fixes the same unique
predecessor for a fixed parent. A nontrivial stopped path family therefore
needs itinerary tags and first-differing-edge disjointness, not a
terminal-child-only filter.

## 3. Historical constants are forbidden inputs

The following values remain valid as abstract Real arithmetic only:

```text
epsilon = 2/243
q = 24100/24543
eta = 202/443
1 - eta = 241/443
```

They are not established F3 carrier bounds. In particular:

- `2/243` divided a per-state boundary numerator by a cross-state
  denominator;
- `202/443` was derived from that unsupported local fraction;
- `241/443` is the output of the historical telescoping calculation and
  cannot be inserted as a local retention factor used to justify the same
  calculation;
- the historical phrase “retains at most `1-epsilon`” has the wrong
  direction for a loss bounded above by `epsilon`.

Therefore R3 must not use `2/243`, `202/443` or `241/443` in a definition,
hypothesis, acceptance inequality or theorem statement unless a later module
rederives the value on one explicitly shared carrier. No name change or
definitional rescaling counts as a rederivation.

## 4. Fixed one-layer root and occurrence carriers

The fixed diagnostic root block remains:

```text
Block0 = {a : Nat | 3 <= a and a < 2919 and a % 3 = 2}
Block0Root = Fin 972
rootValue(i) = 5 + 3*i
y0 = 8
window0(a) = 2^8 * a = 256*a
```

The previously inspected and fresh pieces remain visible:

```text
Block0Seen  = Block0 intersect [3,128)     -- 41 roots
Block0Fresh = Block0 intersect [128,2919)  -- 931 roots
```

The final finite decision is made on all 972 roots. Seen and fresh results
must be reported separately, but neither piece gets a different acceptance
threshold.

The R2 occurrence carrier is:

```lean
abbrev Block0Occurrence :=
  {p : Block0Root × FormulaEdge //
    formulaSource p.2 = rootState p.1}
```

This complete carrier is suitable for a formula-row identity. It is not yet
the semantic family: every advanced formula row contains all three fine-lift
edges, while one concrete root carries one fixed missing fine digit.

## 5. `Active0` and the advanced factor `3`

Define the active semantic predicate without inspecting first-hit data:

```lean
def Active0 (p : Block0Occurrence) : Prop :=
  match occurrenceFormulaEdge p with
  | .retarded _ => True
  | .advancedDirect _ ell =>
      rootFineLift (occurrenceRoot p) = ell
  | .advancedParityLift _ ell =>
      rootFineLift (occurrenceRoot p) = ell
```

The eventual structure must additionally prove that the concrete
`c=(2*a-1)/3` has the direct or parity-lift congruence declared by the formula
constructor. The predicate may be strengthened to include those equations,
but it may not be chosen from observed first-hit success.

Let `w = forwardRightWeight`. Normalize one root to one unit of initial
weighted mass:

```lean
def initialUnitMass (s : Fin 243) : Real :=
  (stateFiber s).card / w s
```

Positivity of every entry of `w` must be proved before using the division.
The active contribution is:

```lean
def activeContribution (p : Active0Occurrence) : Real :=
  match occurrenceFormulaEdge p.1 with
  | .retarded _ =>
      channelWeight 0 * w (formulaTarget p.1.occurrenceFormulaEdge) /
        w (formulaSource p.1.occurrenceFormulaEdge)
  | .advancedDirect _ _ =>
      3 * channelWeight 1 * w (formulaTarget p.1.occurrenceFormulaEdge) /
        w (formulaSource p.1.occurrenceFormulaEdge)
  | .advancedParityLift _ _ =>
      3 * channelWeight 2 * w (formulaTarget p.1.occurrenceFormulaEdge) /
        w (formulaSource p.1.occurrenceFormulaEdge)
```

The advanced factor `3` is mandatory and occurs exactly once. The matrix
entries already contain:

```text
channel 1 = rhoStar^(alpha-1) / 3
channel 2 = rhoStar^(alpha-2) / 3
```

Within a complete state fibre, each fine lift supplies one third of the
roots. Reindexing the three matrix terms through the matching concrete roots
therefore multiplies each active advanced occurrence by `3`. This restores
the original matrix contribution; it does not add a new branch
multiplicity.

The first R3 adapter theorem must be:

```lean
theorem block0_operator_active_reindex :
  weightedMass w
      (push formulaForwardMatrix initialUnitMass) =
    ∑ p in active0Carrier, activeContribution p
```

Required inputs include exact state/fine balance for every eligible advanced
source. No semantic fibre is defined before this identity is proved.

## 6. One-layer arithmetic and first-hit signatures

For a root `a`, define:

```text
c(a) = (2*a - 1)/3
parentWindow0(a) = 256*a
```

The channel data are fixed as follows:

| channel | semantic source root | terminal predecessor of `a` | child window |
|---|---:|---:|---:|
| retarded | `4*a` | `2*a` | `256*a` |
| advanced direct | `c(a)` | `c(a)` | `384*c(a)` |
| advanced parity lift | `2*c(a)` | `c(a)` | `384*c(a)` |

The advanced window is exact because

```text
3 * 2^(8-1) * c = 384*c <= 256*a.
```

The first-hit fibre must cover retarded and advanced channels uniformly:

```lean
def firstHitFiber0 (p : Active0Occurrence) : Finset Nat :=
  (piStarFinset (semanticChildRoot p) (childWindow0 p)).filter
    (fun n => decide
      (FirstHitThrough
        (rootValue (occurrenceRoot p.1))
        (terminalPredecessor p) n))
```

Before any finite run, the following target signatures must be frozen:

```lean
theorem active_channel_arithmetic (p : Active0Occurrence) :
  ChannelArithmetic p

theorem active_formula_target (p : Active0Occurrence) :
  rootStateOfNat (semanticChildRoot p) =
    formulaTarget (occurrenceFormulaEdge p.1)

theorem active_window_le (p : Active0Occurrence) :
  childWindow0 p <=
    256 * rootValue (occurrenceRoot p.1)

theorem mem_firstHitFiber0_iff (p : Active0Occurrence) (n : Nat) :
  n ∈ firstHitFiber0 p ↔
    n ∈ piStarFinset (semanticChildRoot p) (childWindow0 p) ∧
    FirstHitThrough
      (rootValue (occurrenceRoot p.1))
      (terminalPredecessor p) n

theorem firstHitFiber0_subset_parent (p : Active0Occurrence) :
  firstHitFiber0 p ⊆
    piStarFinset
      (rootValue (occurrenceRoot p.1))
      (256 * rootValue (occurrenceRoot p.1))

theorem firstHitFiber0_pairwise_disjoint (r : Block0Root) :
  ((activeIndex0 r : Set Active0Occurrence).PairwiseDisjoint
    firstHitFiber0)
```

The executable Boolean predicate, if used, must have a separately proved
iff theorem with the Prop-level predicate. A classical existential filter is
not an executable certificate by itself.

The current aggregate bridge has one common window. R3 also needs the
root-dependent version:

```lean
theorem aggregate_piStar_card_bound_rootDependent
    (A : Finset Block0Root)
    (window : Block0Root -> Nat)
    (index : Block0Root -> Finset ι)
    (fiber : Block0Root -> ι -> Finset Nat)
    (hdisj : forall r,
      (index r : Set ι).PairwiseDisjoint (fiber r))
    (hsub : forall r i, i ∈ index r ->
      fiber r i ⊆ piStarFinset (rootValue r) (window r)) :
  (∑ r in A, ∑ i in index r, (fiber r i).card) <=
    ∑ r in A, (piStarFinset (rootValue r) (window r)).card
```

## 7. Boundary on the same carrier

The semantic selection and boundary must be frozen before inspecting the
finite fibres. The boundary is not an arbitrary numerical slack chosen after
the run.

At minimum the one-layer data must expose:

```lean
retained0 : Finset Active0Occurrence
omittedAtom0 : Type
omittedPopulation0 : Finset omittedAtom0
boundaryTag0 : Type
boundary0 : Finset boundaryTag0
boundaryAtom0 : boundaryTag0 -> omittedAtom0
boundaryContribution0 : boundaryTag0 -> Real
firstOmissionOwner0 : boundaryTag0 -> Active0Occurrence
```

and prove:

```lean
theorem retained_boundary_partition0 :
  OperatorOutputMass0 <= RetainedContribution0 + BoundaryMass0

theorem boundary0_nonneg :
  0 <= BoundaryMass0

theorem retained0_memberwise_capacity
    (p : Active0Occurrence) (hp : p ∈ retained0) :
  retainedContribution0 p <= (firstHitFiber0 p).card

theorem omittedAtom0_has_unique_firstOmissionTag
    (a : omittedAtom0) :
  a ∈ omittedPopulation0 ↔
    ∃! t : boundaryTag0, t ∈ boundary0 ∧ boundaryAtom0 t = a

theorem boundaryMass0_eq_sum_firstOmissionTags :
  BoundaryMass0 =
    ∑ t in boundary0, boundaryContribution0 t
```

The exact representation may use a weighted boundary measure rather than a
cardinality. In either case, roots, formula occurrences, fine lifts,
retained objects and boundary objects must all be projections or measures of
the same tagged population. A per-state numerator may not be divided by a
cross-state denominator. `firstOmissionOwner0` is only an ownership
projection: it is not required to be injective, because several distinct
omitted atoms may have the same owning occurrence. Uniqueness belongs to the
tag assigned to each omitted atom, and the sum identity above prevents an
atom from being charged zero times or more than once.

## 8. Tagged paths and matrix/path identity

The uniform theorem requires a path type that does not erase parallel or
reconvergent occurrences:

```lean
structure FormulaPath (n : Nat) where
  state : Fin (n + 1) -> Fin 243
  edge : Fin n -> FormulaEdge
  source_eq : forall k,
    formulaSource (edge k) = state k.castSucc
  target_eq : forall k,
    formulaTarget (edge k) = state k.succ
```

The exact matrix/path theorem comes before semantic fibres:

```lean
def pathMass
    (mu w : Fin 243 -> Real) (p : FormulaPath n) : Real :=
  mu (p.state 0) *
    (∏ k, channelWeight (formulaChannelNat (p.edge k))) *
    w (p.state last)

theorem iteratePush_weightedMass_eq_pathMass :
  weightedMass w (iteratePush formulaForwardMatrix mu n) =
    ∑ p : FormulaPath n, pathMass mu w p
```

A semantic path then retains the occurrence and concrete-root history:

```lean
structure TaggedSemanticPath (n : Nat) extends FormulaPath n where
  initialRoot : Block0Root
  concreteRoot : Fin (n + 1) -> Nat
  occurrenceTag : Fin n -> OccurrenceTag
  initial_state : state 0 = rootState initialRoot
  arithmetic_realization : forall k, SemanticEdgeRealizes ...
  accumulatedShift : Real
  childWindow : Fin (n + 1) -> Nat
```

Stopped paths must form a prefix-free family. Their fibres must encode the
whole itinerary before the first hit, rather than only the last terminal
child:

```lean
def realizesBeforeFirstHit
    (p : TaggedSemanticPath n) (m : Nat) : Prop := ...

def stoppedFirstHitFiber (p : StoppedSemanticPath) : Finset Nat := ...

theorem stopped_fibres_disjoint_of_first_difference
    (hprefix : PrefixFree stoppedPaths) :
  (stoppedPaths : Set StoppedSemanticPath).PairwiseDisjoint
    stoppedFirstHitFiber

theorem stopped_fibre_subset_root_window
    (p : StoppedSemanticPath) :
  stoppedFirstHitFiber p ⊆
    piStarFinset
      (rootValue p.initialRoot)
      (rootDependentWindow p)
```

At each depth, different paths remain different keys even if they project to
the same state, matrix edge or natural value. A `Finset` keyed only by one of
those projections is forbidden.

## 9. Sufficient live/stopped/omitted interface

Let `liveMass`, `stoppedMass` and `firstOmissionMass` be sums of the exact
path contributions. The forward row certificate supplies the target step:

```lean
theorem live_stopped_firstOmission_step :
  stoppedMass y n + (55/54) * liveMass y n <=
    stoppedMass y (n+1) + liveMass y (n+1) +
      firstOmissionMass y n
```

The omission is cumulative only through its unique first-omission tag. The
uniform assembly additionally requires:

```lean
theorem cumulative_firstOmission_budget :
  cumulativeFirstOmissionMass y n <= eta * baseMass y

theorem eta_range : 0 <= eta ∧ eta < 1

theorem live_mass_tends_to_zero :
  Tendsto (liveMass y) atTop (nhds 0)

theorem stopped_mass_le_firstHit_card :
  stoppedMass y n <=
    ∑ p in stoppedPaths y n, ((stoppedFirstHitFiber p).card : Real)
```

The generic tilted and first-passage modules can consume these statements.
They do not prove them for F3.

The prospective endpoint is a theorem of the form:

```lean
theorem exists_f3_block_sourceWindow_lower_bound :
  exists Delta : Real, 0 < Delta ∧
    forall y : Real, 8 <= y ->
      Delta * (9/5)^(y-8) <=
        ∑ r : Block0Root,
          forwardRightWeight (rootState r) *
            (piStar (rootValue r)
              (sourceWindow y (rootValue r)) : Real)
```

Only after this statement exists may the standard `sourceWindow/logb`
wrapper convert the rate to

```text
gammaF3 = log(9/5) / log(2) ~= 0.8480.
```

That wrapper must include the explicit weighted-to-unweighted comparison.
In particular, an upper bound `forwardRightWeight s <= wMax` with
`0 < wMax` converts a lower bound for the displayed weighted sum into a
lower bound for the corresponding unweighted count after division by
`wMax`; any lower bound used in the initial normalization must be stated
separately. This comparison is not automatic from the rate statement.

Neither theorem is proved by this document.

## 10. Predeclared finite gate

The future finite gate is fixed as follows:

```text
block = [3,2919), roots congruent to 2 modulo 3
root count = 972
seen segment = [3,128), 41 roots
fresh segment = [128,2919), 931 roots
y0 = 8
window0(a) = 256*a
```

Before any semantic evaluation, the implementation must prove these carrier
sanity counts from the frozen definitions:

```text
complete occurrences = 2916
active occurrences = 1620 = 972 retarded + 648 advanced
seen complete/active = 122/68
fresh complete/active = 2794/1552
maximum parent window = 256*2918 = 747008
maximum advanced window = 384*1945 = 746880
```

Re-running a separate
`piStarFinset child childWindow0` filter for every occurrence would duplicate
the same bounded trajectories and is not an authorized implementation. A
future executable contract must predeclare a generator/verifier split:

1. one global member-wise sweep up to the maximum frozen window that emits
   itinerary and first-hit tags;
2. a compressed, hashed certificate format with exact source/window/tag
   coverage;
3. a kernel verifier proving the Boolean/Prop equivalence, membership and
   coverage statements from that certificate;
4. a measured cost budget and STOP rule fixed before generation.

No finite execution is authorized until that format, coverage manifest and
budget have been frozen and reviewed.

For every active occurrence, the checker must report member-wise:

1. source-state equality;
2. fine-lift match;
3. direct/lift congruence;
4. concrete channel arithmetic;
5. formula-target equality;
6. child-window inequality;
7. Boolean/Prop first-hit equivalence;
8. first-hit fibre inclusion;
9. first-differing-edge disjointness;
10. member-wise retained contribution capacity;
11. unique first-omission tag for every omitted atom.

It must also certify the global identities:

```text
OperatorOutputMass0 = sum of active contributions
OperatorOutputMass0 <= RetainedContribution0 + BoundaryMass0
RetainedContribution0 <= sum of first-hit fibre cardinalities
BoundaryMass0 = sum of the uniquely tagged first-omission contributions
0 < OperatorOutputMass0
```

Define:

```text
O0 = OperatorOutputMass0
B0 = BoundaryMass0
```

The channel-1 and channel-2 weights contain `Real.rpow` with
`alpha = log(3)/log(2)`, so the finite checker may not pretend that raw
evaluation of `O0` and `B0` is a kernel decision. Before execution it must
prove a certificate interface of the following form:

```text
O0Lower <= O0
B0 <= B0Upper
0 <= B0Upper
55 * B0Upper < O0Lower
```

with rational `O0Lower` and `B0Upper`, or equivalent rational interval
certificates for every transcendental channel weight. The present lower
bounds on advanced channel weights do not by themselves upper-bound `B0`; a
checker based only on those lower bounds is forbidden. A direct retained-mass
criterion would be a different gate with a separately named outcome; it may
not be substituted for `55*B0<O0` under `R3_BLOCK0_FINITE_PASS`.

The direct-margin acceptance line is predeclared as:

```text
55 * B0 < O0.
```

Together with the separately certified `0 < O0`, this is equivalent to the
same-carrier ratio `B0/O0 < 1/55`. Since the kernel theorem gives

```text
O0 >= (55/54) * InitialMass0,
```

the acceptance line implies retained mass strictly greater than
`InitialMass0`. It is a direct one-step survival criterion, not a historical
substitute for `eta`.

No first-hit output may change the block, window, active predicate, boundary
definition, contribution normalization or threshold.

## 11. PASS and STOP meanings

The gate outcomes are:

```text
R3_BLOCK0_FINITE_PASS
```

if all member-wise obligations, global identities and `55*B0<O0` pass on the
fixed block. This outcome opens the uniform tagged-path proof. It does not
prove preservation at every depth, an all-`y` boundary estimate, live-mass
extinction, the F3 exponent or density.

```text
STOP_R3_BLOCK0_REALIZATION
```

if any explicit root, occurrence, channel, target, window, first-hit member,
pair of fibres or first-omission tag violates its frozen statement. This is a
counterexample to this concrete active-carrier realization.

```text
STOP_R3_DIRECT_MARGIN
```

if the structural realization passes but `55*B0<O0` fails. This stops the
direct-margin architecture. It does not prove that every possible renewal or
different-carrier F3 architecture is impossible; any successor must be
separately named and predeclared.

The seen/fresh split is diagnostic only. A failure in either segment is a
failure of the full fixed gate.

## 12. Engineering versus new mathematics

Finite or generic engineering, conditional on the stated definitions:

- `Block0Root`, seen/fresh partition and unique enumeration;
- root-state and fine-lift maps;
- exact state/fine cardinalities;
- complete occurrence cardinality;
- positivity of the forward weight;
- active occurrence definitions;
- `/3` to active-factor-`3` reindexing for one complete block;
- root-dependent aggregate `piStar` lemma;
- generic `FormulaPath` and matrix/path expansion;
- finite-sum casts, partitions and axiom audits;
- the final `sourceWindow/logb` exponent wrapper once the source-window
  theorem exists.

New or high-risk mathematics:

- preservation of a balanced semantic selection through arbitrarily many
  fine digits;
- a member-wise realization of every weighted formula-path contribution by
  actual predecessor fibres;
- prefix-free first-differing-edge disjointness for the full retarded/direct/
  parity path alphabet;
- a uniform first-omission boundary bound on the exact tagged carrier;
- identification of the same live paths with the tilted operator;
- a concrete tilted certificate and live extinction for that same path
  ledger;
- the uniform-in-`y` stopped lower bound.

The fixed `Block0` exposes only one additional fine digit. A successful
one-layer test does not automatically supply the `3^n` fine-cylinder
information required at arbitrary path depth. The uniform proof must either
construct carriers of increasing depth or introduce an equivalent certified
cylinder/measure mechanism. This is the central mathematical gap after R1
and R2.

## 13. Final scope

```text
FORWARD_OPERATOR_R1_AVAILABLE_AT_TRACKED_HEAD
R2_DEFINITION_FIRST_WORK_OBSERVED_UNTRACKED
R3_STATEMENTS_SCOPED
FINITE_GATE_NOT_EXECUTED
UNIFORM_TAGGED_PATH_REALIZATION_OPEN
UNIFORM_BOUNDARY_OPEN
LIVE_EXTINCTION_INSTANCE_OPEN

NO_SEMANTIC_HOOK_PROVED
NO_F3_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_ALMOST_ALL_RESULT
NO_GLOBAL_COLLATZ_CLAIM
```
