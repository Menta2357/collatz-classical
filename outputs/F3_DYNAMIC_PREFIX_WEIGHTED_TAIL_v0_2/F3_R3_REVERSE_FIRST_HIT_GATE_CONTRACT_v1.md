# F3 R3 reverse first-hit gate contract v1

Date: 2026-07-25.

Status:

```text
CONTRACT_DESIGN_ONLY
READ_ONLY_API_AUDIT_COMPLETE
H_R2_8AD97A7FF21CD1D17ADCDF895E625E4310AB85CE
R3_SCOPING_V2_CITED_NOT_MODIFIED
TEMPORAL_ORDER_P1_IDENTIFIED
DIRECT_MARGIN_OUTCOME_P1_IDENTIFIED
REVERSE_FIRST_HIT_INTERFACE_PREDECLARED_NOT_PROVED
MASS_ATOM_INTERFACE_PREDECLARED_NOT_PROVED
RATIONAL_UPPER_INTERVALS_PREDECLARED_NOT_PROVED
COST_BOUNDS_CONDITIONAL_NOT_MEASURED
NO_LEAN_EXECUTION_FOR_THIS_CONTRACT
NO_TRAJECTORY_EXECUTION_FOR_THIS_CONTRACT
NO_R3_FINITE_PASS
NO_F3_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## 1. Purpose and provenance

This document predeclares a generator/verifier architecture for the first
semantic `Block0` gate. It resolves two issues found by a read-only audit of
the current R3 scope:

1. the child hit must occur on the path leading to the first entrance into
   the parent, rather than merely somewhere on the same orbit;
2. failure of a sufficient rational upper/lower estimate is not, by itself,
   proof that the real direct margin fails.

The completed R2 carrier is pinned by:

```text
H_R2 = 8ad97a7ff21cd1d17adcdf895e625e4310ab85ce
```

The governing R3 source is:

```text
outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/
  F3_R3_ACTIVE_CARRIER_SEMANTIC_GATE_SCOPING_v2.md

observed sha256 =
  746df5e897b7420ed663cead90e4cc40fefe501c85c453325648f21322805caa
```

This contract does not edit or silently supersede that v2 document. Before a
semantic run, either:

- a reconciled successor scope must adopt the ordered-child interface below;
  or
- the ordered fibre must be used only as a certified subfibre of the v2
  fibre, with the narrower STOP name specified in Section 11.

No first-hit orbit, reverse tree, finite fibre, channel upper interval or
margin was evaluated while preparing this document.

## 2. Frozen carrier and planning coordinates

The following entries distinguish proved R2 facts from R3 planning values.

| item | value | status in this contract |
|---|---:|---|
| complete `Block0Root` count | 972 | `PROVED_R2_AT_H_R2` |
| seen/fresh root split | 41 / 931 | `PROVED_R2_AT_H_R2` |
| complete occurrence count | 2916 | `PROVED_R2_AT_H_R2` |
| active occurrence count | 1620 | `PREDECLARED_R3_NOT_PROVED` |
| active retarded/advanced split | 972 / 648 | `PREDECLARED_R3_NOT_PROVED` |
| root values | `[3,2919)`, congruent to 2 mod 3 | `PREDECLARED_R3_ADAPTER_NOT_PROVED` |
| depth parameter | `y0 = 8` | `PREDECLARED_R3` |
| parent window | `256*a` | `PREDECLARED_R3_NOT_PROVED` |
| maximum parent window | `256*2918 = 747008` | `CONDITIONAL_ARITHMETIC_NOT_PROVED_IN_R3` |
| advanced child window | `384*c` | `PREDECLARED_R3_NOT_PROVED` |
| maximum advanced child window | `384*1945 = 746880` | `CONDITIONAL_ARITHMETIC_NOT_PROVED_IN_R3` |

No observed fibre result may change the root block, the active predicate,
the windows, the ordering, the contribution normalization, the mass-atom
definition or the acceptance threshold.

## 3. Temporal-order P1

The v2 candidate fibre has the shape

```lean
(piStarFinset semanticChildRoot childWindow).filter
  (fun n => decide (FirstHitThrough parent terminalPredecessor n))
```

The imported predicate is

```lean
def FirstHitThrough (a c n : Nat) : Prop :=
  exists k, FirstHitsAt a n (k + 1) /\ T^[k] n = c
```

This fixes the first entrance into `a` and its immediate predecessor `c`.
It does not say that the hit of `semanticChildRoot` certified by
`piStarFinset` occurs before that entrance. The distinction disappears for
the direct channel, where the semantic child is the terminal predecessor.
It is not definitionally absent for the other two channels:

```text
retarded:     4*a -> 2*a -> a
parity lift:  2*c -> c   -> a
```

If an orbit returns from the parent to the semantic child, the two separate
existential facts can refer to different portions of the orbit. A finite
gate intended to realize one formula edge must not admit that ambiguity.

### 3.1 Ordered predicate

Predeclare a channel-dependent suffix length:

```text
retarded       suffixLength = 2
advancedDirect suffixLength = 1
parityLift     suffixLength = 2
```

The intended new predicate is schematically:

```lean
FirstHitViaChild p n :=
  exists h,
    T^[h] n = semanticChildRoot p /\
    (forall j <= h, 1 <= T^[j] n /\ T^[j] n <= childWindow0 p) /\
    (forall j <= h, T^[j] n != parentRoot p) /\
    ChannelSuffix p (T^[h] n) /\
    FirstHitsAt (parentRoot p) n (h + suffixLength p)
```

`ChannelSuffix` must expand to the three exact arithmetic signatures above
and must identify the terminal predecessor. The executable Boolean checker
must have a separately proved Boolean/Proposition equivalence.

Define the ordered fibre on the same fixed child window:

```lean
orderedFirstHitFiber0 p :=
  (Finset.range (childWindow0 p + 1)).filter
    (fun n => decide (1 <= n /\ FirstHitViaChild p n))
```

Before using it, prove member-wise:

```text
orderedFirstHitFiber0 p subset firstHitFiber0 p
orderedFirstHitFiber0 p subset
  piStarFinset (parentRoot p) (parentWindow0 p)
```

The subset direction is enough for a positive capacity certificate. Equality
with the v2 fibre is not assumed. Equality would require an additional
no-return/order argument on the frozen block.

## 4. Reverse graph and exact predecessor API

Forwardly testing every natural number in every root-dependent window is not
the proposed verifier. For a fixed occurrence `p`, set:

```text
a = parentRoot p
d = semanticChildRoot p
x = childWindow0 p
```

Use the finite directed graph with vertices

```text
V(p) = {n : Nat | 1 <= n and n <= x and n != a}
```

and edge `n -> T n`. A vertex belongs to the ordered reverse fibre exactly
when it reaches `d` in this graph, followed by the fixed channel suffix to
`a`. This characterization is `PREDECLARED_NOT_PROVED` until its Lean iff
theorem exists.

For the accelerated map used by the current API, every `v` has at most two
positive predecessors:

```text
even candidate:  2*v
odd candidate:   (2*v - 1)/3, only when integral and odd
```

The new API must not trust those formulas as generated data. It must prove a
local exactness theorem of the form:

```lean
u in preimagesWithin a x v <->
  1 <= u /\ u <= x /\ u != a /\ T u = v
```

The right-to-left and left-to-right directions are both required. This is
the completeness hinge for a deficient reverse fibre.

## 5. Reverse-BFS certificate

The generator is untrusted. It performs a deterministic breadth-first
search from `d`, with natural-number ordering on the at-most-two predecessor
candidates. Its source hash, build inputs, ordering and output hash must be
frozen before a semantic execution.

The proof object for one active occurrence is schematically:

```lean
structure RevNode where
  value       : Nat
  parentIndex : Option Nat

inductive FiberCert where
  | saturated
      (nodes : Array RevNode)
      (claimedDemand : Nat)
  | deficient
      (nodes : Array RevNode)
      (claimedDemand : Nat)
      (closureRows : Array ClosureRow)
```

The concrete representation may use dependent indices, but the generated
payload must contain data rather than proof terms.

For every certificate:

1. node zero is the semantic child `d`;
2. node values are positive, inside `x`, different from `a` and duplicate
   free;
3. each non-root node points to an earlier node;
4. `T node.value` equals the value of that earlier node;
5. the root and fixed suffix satisfy the channel signature;
6. every node therefore gives one member of `orderedFirstHitFiber0 p`.

For `saturated`, the array length is exactly the mass demand `D(p)` from
Section 7. No completeness claim is needed: `D(p)` distinct positive
witnesses suffice.

For `deficient`, the array length is strictly less than `D(p)`. Each
`ClosureRow` must list exactly the indices corresponding to
`preimagesWithin a x node.value`. Comparing the generated row with the
proved exact predecessor formula certifies reverse closure. Parent pointers
give reachability to `d`; reverse closure gives the converse inclusion.
Thus the deficient node array is the complete ordered fibre, not a sample.

This saturated-or-closed design prevents the generator from creating a
boundary merely by withholding witnesses:

- if `D(p)` witnesses exist, it may stop as soon as it has certified them;
- if fewer exist, it must exhibit an exact closed reverse fibre.

## 6. Same-carrier mass atomization

Let `Q(p)` denote the real active contribution from R3 v2. A whole
occurrence may carry more than one unit of contribution, while one distinct
first-hit natural supplies one unit of cardinal capacity. Omitting a whole
occurrence whenever it lacks one final unit would introduce avoidable and
post hoc slack.

Predeclare rational functions `qLo(p)` and `qHi(p)` satisfying

```text
0 < qLo(p) <= Q(p) <= qHi(p)
```

and define

```text
D(p) = ceil(qHi(p)).
```

The ceiling implementation must be checked on nonnegative rationals, and
the verifier must prove `1 <= D(p)` and `qHi(p) <= D(p)`.

The fixed same-carrier population is:

```lean
MassAtom0 := Sigma (fun p : Active0Occurrence => Fin (D p))
```

Every atom owned by `p` has real mass

```text
atomMass(p,j) = Q(p) / D(p).
```

Consequently:

```text
sum_{j < D(p)} atomMass(p,j) = Q(p)
0 <= atomMass(p,j) <= 1
```

Order reverse witnesses by their generated BFS index and atoms by their
`Fin D(p)` index. If the fibre certificate contains `m(p)` nodes, retain the
first `m(p)` atoms and assign one distinct node to each. The remaining
`D(p)-m(p)` atoms are boundary atoms.

The boundary types may be implemented as subtypes, but must expose these
projections:

```text
boundaryTag0            = an omitted MassAtom0
boundaryAtom0           = identity projection to MassAtom0
firstOmissionOwner0     = the occurrence component p
boundaryContribution0 t = atomMass(owner(t), atomIndex(t))
```

Uniqueness is literal subtype uniqueness: every omitted atom has exactly one
tag. Several tags may have the same occurrence owner.

The required exact and monotone statements are:

```text
O0 = sum_p Q(p)
O0 = RetainedContribution0 + B0
RetainedContribution0(p)
  = m(p) * Q(p) / D(p)
RetainedContribution0(p)
  <= m(p)
  <= card(orderedFirstHitFiber0 p)
  <= card(firstHitFiber0 p)
B0 = sum_p (D(p)-m(p)) * Q(p) / D(p)
B0 = sum over unique boundary tags
0 <= B0
```

All divisions remain inside the same occurrence. No numerator from one state
is normalized by a denominator belonging to another state.

## 7. Rational interval contract

The present source proves only:

```text
channel 0 = 25/81
channel 1 >= 469/1000
channel 2 >= 13/50
```

Lower bounds do not upper-bound a boundary. Before any semantic generation,
prove a separate upper-interval module and audit its full public cone.

The preferred frozen intervals for this contract are:

| channel | lower | upper | status |
|---:|---:|---:|---|
| 0 | `25/81` | `25/81` | exact lower source exists; reuse proof still required |
| 1 | `469/1000` | `471/1000` | lower exists; upper `PREDECLARED_NOT_PROVED` |
| 2 | `13/50` | `157/600` | lower exists; upper `PREDECLARED_NOT_PROVED` |

A proposed proof route, not a proved result, is:

```text
alpha < 65/41           from 3^41 < 2^65
(9/5)^(24/41) < 1413/1000
channel1 < 471/1000
channel2 = channel1/(9/5) < 157/600
```

Every inequality in that route is `PREDECLARED_NOT_PROVED`. No decimal
evaluation is admissible in the public theorem.

The easier fallback intervals

```text
channel1 <= 1/2
channel2 <= 5/18
```

are also only `PREDECLARED_NOT_PROVED` here. They may be adopted only in a
new contract before seeing first-hit output. They may not replace the tighter
intervals after a failed margin.

The finite vector visibly used by `forwardRightWeightNat` has planning
extrema 21 and 484. Strict positivity and those extrema are
`PREDECLARED_NOT_PROVED_AS_R3_THEOREMS`; the current public module proves
only nonnegativity of the real weight. The required precondition is:

```text
forall s : Fin 243, 0 < forwardRightWeightNat s
```

For an active occurrence, define rational bounds entirely from checked
finite data:

```text
qLo(p) = factor(p) * channelLo(channel(p))
          * wNat(target(p)) / wNat(source(p))

qHi(p) = factor(p) * channelHi(channel(p))
          * wNat(target(p)) / wNat(source(p))

factor(retarded) = 1
factor(advancedDirect) = 3
factor(parityLift) = 3
```

The factor `3` occurs exactly once. It must not be inserted into both the
channel coefficient and the active contribution.

## 8. Generated data format

The exact serialization may be JSON, CSV plus manifest, or generated Lean
data, but it must encode the following logical records.

```text
GateHeader
  contractVersion
  H_R2
  r3ScopingV2Sha256
  generatorSourceSha256
  generatorBinarySha256
  channelIntervalSourceSha256
  blockLow, blockHigh, rootCongruence
  y0
  declaredRootCount
  declaredActiveCount
  declaredMaxParentWindow
  declaredMaxChildWindow
  shardCount and shard rule

ActiveRow
  occurrenceRank
  rootRank, rootValue, seenFreshTag
  formulaEdgeRank, constructorTag, fineLift
  sourceState, targetState, channel
  semanticChildRoot, terminalPredecessor
  parentWindow, childWindow
  sourceWeightNat, targetWeightNat
  qLoNumerator, qLoDenominator
  qHiNumerator, qHiDenominator
  demand
  FiberCert

ClosureRow
  nodeIndex
  sortedExactPreimageIndices
```

Coverage is not sampling:

```text
root rows                 972/972
active occurrence rows   1620/1620, conditional on the unproved R3 count
one and only one row per active occurrence rank
every reverse node in every row checked
every deficient closure row checked
every retained atom assigned once
every omitted atom tagged once
```

The manifest must print seen and fresh subtotals, channel subtotals,
saturated and deficient row counts, reverse-node count, retained-atom count,
boundary-atom count and every rational aggregate used by the decision.

The proposed deterministic shard rule is 36 consecutive shards of 27 root
indices each. This is `PREDECLARED_NOT_EXECUTED`; a different rule requires a
new frozen contract before generation.

## 9. Verifier obligations

The verifier must establish these layers in order.

### 9.1 Static preconditions

1. exact source hashes and contract version;
2. root enumeration and seen/fresh partition;
3. active predicate and complete active enumeration;
4. strict positivity of every source weight;
5. operator-to-active reindex identity from R3 v2;
6. rational channel lower and upper intervals;
7. exact predecessor API;
8. rational ceiling API.

No reverse data are accepted until all static preconditions compile.

### 9.2 Member-wise structural checks

For every active row:

1. occurrence rank decodes to the stated root and formula occurrence;
2. source-state equality;
3. active fine-lift match;
4. direct/lift congruence and concrete channel arithmetic;
5. formula-target equality;
6. exact child and parent windows and child-window inequality;
7. source and target integer weights;
8. rational `qLo`, `qHi` and `D` recomputed rather than trusted;
9. reverse-root equality and fixed suffix;
10. every reverse node lies in range and avoids the parent;
11. every parent pointer is earlier and is one exact `T` step;
12. duplicate freedom;
13. exact reverse closure for every deficient row;
14. Boolean/Proposition ordered-first-hit equivalence;
15. inclusion in the v2 first-hit fibre and parent `piStarFinset`;
16. retained-atom injection and member-wise capacity;
17. one unique boundary tag for every omitted atom.

For every root, allocations belonging to different active occurrences must
be disjoint. This follows from the first-entry terminal signature only after
the distinct-terminal lemma is proved; the finite checker must also reject a
duplicate natural across occurrence allocations at the same root.

### 9.3 Global identities

The verifier must prove:

```text
weightedMass w (push formulaForwardMatrix initialUnitMass) = O0
O0 = sum of all active contributions
O0 = RetainedContribution0 + B0
RetainedContribution0 <= sum of ordered-fibre cardinalities
sum of ordered-fibre cardinalities
  <= sum of root-dependent parent piStar cardinalities
B0 = sum of unique boundary-tag contributions
0 < O0
```

The current common-window aggregate theorem is insufficient. A
root-dependent aggregate adapter remains a finite R3 obligation.

## 10. Rational decision

From the checked active rows and their verified reverse-fibre sizes, define
four rational aggregates:

```text
O0Lower = sum_p qLo(p)
O0Upper = sum_p qHi(p)

B0Lower = sum_p (D(p)-m(p)) * qLo(p) / D(p)
B0Upper = sum_p (D(p)-m(p)) * qHi(p) / D(p)
```

The interval theorem must prove:

```text
O0Lower <= O0 <= O0Upper
B0Lower <= B0 <= B0Upper
0 <= B0Lower
0 <= B0Upper
```

All final comparisons are exact `Rat` comparisons followed by proved casts
to `Real`. Raw evaluation of `Real.rpow`, floating-point output and
unproved decimals are forbidden.

### 10.1 Positive decision

The sufficient positive certificate is exactly:

```text
55 * B0Upper < O0Lower.
```

It implies the required real line:

```text
55 * B0 < O0.
```

### 10.2 Negative decision

Negating the sufficient positive certificate does not negate the real line.
The conclusive negative certificate is:

```text
O0Upper <= 55 * B0Lower.
```

It implies:

```text
not (55 * B0 < O0).
```

### 10.3 Inconclusive interval

If neither exact rational comparison holds, the interval enclosure does not
decide the direct margin. That state is arithmetic inconclusiveness, not a
mathematical STOP. Any refinement ladder must be written and frozen before
generation. Intervals may not be tightened selectively after inspecting the
margin.

## 11. Outcome ledger

Outcomes are mutually calibrated as follows.

### `R3_BLOCK0_REVERSE_FINITE_PASS`

Emit only if:

1. all static preconditions pass;
2. coverage is complete;
3. every member-wise and global structural obligation passes;
4. all deficient fibres have exact reverse-closure certificates;
5. all boundary atoms have unique tags;
6. `55 * B0Upper < O0Lower` passes in rational arithmetic.

This proves the finite direct margin for the ordered reverse realization. If
a reconciled R3 scope has adopted this fibre as the official semantic fibre,
the result may be promoted there to `R3_BLOCK0_FINITE_PASS`. Otherwise it is
only a positive subfibre certificate, although its capacity inequality into
the v2 fibre remains valid.

### `STOP_R3_BLOCK0_REVERSE_REALIZATION`

Emit only when a fully identified root, occurrence, formula target, channel,
window, reverse node, first-hit signature, closure row, disjointness check or
boundary tag contradicts its frozen statement.

A malformed file, missing shard, timeout or generator crash is instead:

```text
STOP_R3_CERTIFICATE_INVALID_OR_INCOMPLETE
```

and carries no mathematical verdict.

### `STOP_R3_REVERSE_DIRECT_MARGIN`

Emit only after all structural layers pass and the conclusive negative
certificate

```text
O0Upper <= 55 * B0Lower
```

passes. This stops the ordered reverse direct-margin architecture. Without a
proved equality between the ordered fibre and the broader v2 fibre, it must
not be renamed `STOP_R3_DIRECT_MARGIN` for every v2 selection.

### `R3_REVERSE_INTERVAL_INCONCLUSIVE`

Emit when structure passes but neither rational sign certificate holds. It
is not PASS, not STOP and not authority to choose new intervals after seeing
the output.

### `STOP_R3_STATIC_PRECONDITION`

Emit before semantic generation if active enumeration, positivity, operator
reindex, channel intervals, predecessor exactness or the rational ceiling
interface cannot be proved as frozen. This is a failure of the proposed
contract surface, not trajectory evidence.

## 12. Conditional size and cost ledger

Every number in this section is a planning bound derived from unproved R3
preconditions. No runtime was measured.

Under the preferred, still-unproved channel intervals and the visible,
still-unaudited-as-R3 extrema `21 <= wNat <= 484`, the proposed upper demands
are:

| constructor | conditional upper contribution | conditional maximum `D` |
|---|---:|---:|
| retarded | `(25/81)*(484/21)` | 8 |
| direct | `3*(471/1000)*(484/21)` | 33 |
| parity lift | `3*(157/600)*(484/21)` | 19 |

Using only the predeclared 972/648 active split and pessimistically treating
all advanced occurrences as direct gives:

```text
sum D(p) <= 972*8 + 648*33 = 29160
```

This is `CONDITIONAL_PLANNING_BOUND_NOT_PROVED`. If a future theorem proves
an exact 324/324 direct/lift split, the corresponding conditional value would
be:

```text
972*8 + 324*33 + 324*19 = 24624.
```

That split is not claimed by this contract.

Each reverse node exposes at most two predecessor candidates. The pessimistic
preferred-interval planning budget is therefore:

```text
active rows             <= 1620
reverse nodes           <= 29160
predecessor candidates  <= 58320
```

The reverse-node bound holds because a saturated row stops at `D(p)`, while
a deficient exact closure contains fewer than `D(p)` nodes.

For comparison, the naive occurrence-by-window surface would contain up to:

```text
1620 * 747008 = 1,210,152,960
```

candidate membership checks. Checking at most 29160 positive witnesses by
the current worst fuel `747009` would expose up to:

```text
29160 * 747009 = 21,782,782,440
```

recursive steps before sharing. These are conditional arithmetic ceilings,
not observed execution costs. Reverse predecessor closure replaces those
surfaces by tens of thousands of local equations, an estimated reduction of
roughly four to six orders of magnitude in the certificate-checking surface.
That order estimate is `PLANNING_ESTIMATE_NOT_MEASURED`.

With compact integer rows, the expected payload is on the order of a few
megabytes, but byte size, elaboration time and heartbeat requirements remain
`NOT_MEASURED`. They must be measured in a non-semantic pilot and frozen in a
separate execution contract before the one authorized semantic run.

## 13. Trust boundary and audit

The generator may use ordinary executable code and reverse BFS, but its
output is untrusted. The public theorem cone must be checked by Lean from the
local predecessor equations, parent pointers, closure rows, rational
identities and previously audited sources.

The public verifier must not inherit:

```text
Lean.ofReduceBool
Lean.trustCompiler
sorryAx
native_decide certificate axioms
```

The post-build audit must enumerate every public declaration in every new
module and print coverage totals. A sample of declarations is not an audit.
No audit is run after a failed build.

Custody is required after every final outcome, including STOP and
INCONCLUSIVE: source hashes, generator hashes, manifests, all shards, exact
commands, raw logs and the outcome report are preserved without rewriting a
terminal log.

## 14. Finite engineering versus new uniform mathematics

The following work is finite engineering of known, fixed objects:

- active-carrier enumeration and its cardinality;
- strict positivity and finite extrema of the right weight;
- the operator-to-active reindex identity;
- exact channel arithmetic, targets and windows;
- rational upper channel intervals;
- the exact predecessor API;
- reverse-node and deficient-closure verification;
- same-carrier atom partition and boundary tags;
- root-dependent aggregate-cardinality adapter;
- rational PASS/negative/inconclusive decision;
- full dependency and axiom audit.

Even a complete `R3_BLOCK0_REVERSE_FINITE_PASS` leaves the following new
uniform mathematics open:

- composable occurrence-tagged `FormulaPath` and `TaggedSemanticPath` types;
- an exact matrix/path identity at arbitrary depth;
- a depth-growing balanced semantic selection;
- prefix-free first-differing-edge disjointness under reconvergence and
  parallel occurrences;
- a same-carrier boundary estimate uniform in depth and in `y`;
- live-mass extinction;
- a uniform root-dependent source-window bound;
- assembly of those results into the F3 rate, exponent and density theorem.

The finite gate decides whether this one-layer architecture is worth opening
that proof programme. It does not itself prove
`log_2(9/5)`, an exponent near 0.848, a density statement or any version of
the Collatz conjecture.

## 15. Authorized order of future work

No semantic generation begins from this document alone. The next legitimate
sequence is:

1. reconcile the temporal-order interface with R3 scoping;
2. prove and audit the active enumeration, positivity and operator reindex;
3. prove and audit the preferred rational channel upper intervals;
4. prove the exact predecessor and ordered-fibre subset APIs;
5. implement the mass-atom and reverse-certificate verifier;
6. run a non-semantic size/elaboration pilot and freeze resource limits;
7. freeze generator source/binary hashes, manifests, shards and the single
   semantic execution contract;
8. execute once;
9. emit exactly one calibrated PASS, STOP, invalid/incomplete or
   inconclusive outcome;
10. audit the full public cone only after a successful build and preserve
    custody whatever the result.

Until Steps 1--7 close, the operative status remains:

```text
NO_R3_BLOCK0_SEMANTIC_EXECUTION
```
