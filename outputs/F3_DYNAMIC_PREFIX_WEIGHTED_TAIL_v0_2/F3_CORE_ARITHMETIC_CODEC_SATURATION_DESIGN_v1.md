# F3_CORE_ARITHMETIC_CODEC_SATURATION_DESIGN_v1

Status: `SUPERSEDED_FOR_EXECUTION — HISTORICAL_DESIGN_ONLY`

Successor notice (2026-07-24): this document preserves the original
architecture and its original 120-second pilot budget as historical design
evidence.  It is not an execution authorization at the successor HEAD.  The
sole controlling execution contract is
`F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_CONTRACT_v1.md`, with 200000
heartbeats, a 300-second total wall ceiling including import, one compile,
and one conditional audit.  Sections 7 and 8 below are retained verbatim in
substance so the superseded decision can be reconstructed; they cannot be
combined with or override the successor contract.

This document specifies a materially new proof architecture for the finite F3
core identity.  It replaces filtering/remapping of large literal lists by an
arithmetic codec, formula-generated edges, and a saturation argument.  This
phase is design-only: no Lean compilation is authorized by this document.

## 0. Scope and non-claims

The target is the finite identity between the 243-state frozen core operator
and a formula-generated operator.  It is not the Real renewal conversion and
does not discharge the operator-to-fibre hypotheses.

```text
NO_LEAN_PASS_IN_THIS_PHASE = true
NO_RHO_CERTIFICATE = true
NO_DENSITY_THEOREM = true
NO_ALMOST_ALL = true
NO_GLOBAL_COLLATZ_CLAIM = true
```

Forbidden in the pilot and in its generator:

- `find?` or any linear lookup;
- a 243-case match or a table of 243 pairs;
- `HashMap`, arrays used as lookup tables, or imported CSV lookup data;
- a literal expected right-hand edge list;
- cosmetic shards of the same list reduction;
- increasing wall time or `maxHeartbeats` after a failure.

## 1. `F3CoreArithmeticCodec`

Let `i : Fin 243`, write `q = i / 3` and `b = i % 3`, and define

```text
encode(i) = 9*q + 6 + b.
```

The result is `< 729`, because `q ≤ 80` and `b ≤ 2`.  Its residue modulo 9
is exactly `6+b`, hence lies in `{6,7,8}`.  Define the subtype

```text
CoreCode = {n : Fin 729 // n % 9 = 6 ∨ n % 9 = 7 ∨ n % 9 = 8}
```

and, for `n : CoreCode`,

```text
decode(n) = 3*(n/9) + (n%9 - 6).
```

The subtraction is legal because the subtype proof gives `6 ≤ n%9`; the
result is `<243` because `n/9 ≤80` and `n%9-6 ≤2`.

Required codec lemmas:

```text
encode_lt_729
encode_mod9 : encode(i) % 9 = 6 + i%3
encode_mem_coreCode
decode_lt_243
decode_encode : decode(encode(i)) = i
encode_decode : encode(decode(n)) = n
encode_injective
decode_injective
coreCode_card : Fintype.card CoreCode = 243
```

All proofs are arithmetic (`Nat.div_add_mod`, bounds, and congruences).  No
finite table or computation over 243 rows is permitted.

## 2. State arithmetic and `FormulaEdge`

The code `encode(i)` is the existing depth-five state index

```text
r(i)      = 3*(i/3) + 2                  -- residue modulo 3^5
bucket(i) = i % 3                        -- odd / v₂=1 / v₂≥2
encode(i) = 3*r(i) + bucket(i).
```

Define an arithmetic bucket code for positive `x`:

```text
bucketCode(x) = 0, if x%2=1
                1, if x%4=2
                2, if x%4=0.

stateCode(x) = 3*(x % 243) + bucketCode(x).
```

For a deep lift `ell : Fin 3`, let

```text
n0(i,ell) = r(i) + 243*ell.

adjust(0,n) = (1 + 2 - n%2) % 2
adjust(1,n) = (2 + 4 - n%4) % 4
adjust(2,n) = (0 + 4 - n%4) % 4

a(i,ell) = n0(i,ell) + 729*adjust(bucket(i), n0(i,ell)).
c(i,ell) = (2*a(i,ell)-1)/3.
```

The adjustment is the least residue forcing the parity/`v₂` bucket.  Since
`a(i,ell) ≡ r(i) ≡ 2 (mod 3)`, division in `c` is exact.  Since additions by
243 and 729 do not change the residue modulo 9,

```text
(i/3)%3 = 0  ==> c(i,ell)%3 = 1  -- parity-lift channel
(i/3)%3 = 1  ==> c(i,ell)%3 = 0  -- sterile tail, no core edge
(i/3)%3 = 2  ==> c(i,ell)%3 = 2  -- direct channel.
```

Encode eligibility in the type rather than in a Boolean or a proof field:

```text
DirectSource = {i : Fin 243 // (i/3)%3 = 2}
LiftSource   = {i : Fin 243 // (i/3)%3 = 0}

inductive FormulaEdge
  | retarded (source : Fin 243)
  | advancedDirect (source : DirectSource) (ell : Fin 3)
  | advancedParityLift (source : LiftSource) (ell : Fin 3)
```

Define `formulaSource`, `formulaTarget`, and `formulaChannelNat` by cases.  The
last map uses exactly the frozen matrix convention:

```text
retarded           -> 0
advancedDirect     -> 1
advancedParityLift -> 2.
```

The typed bridge to the historical matrix edge is

```text
realize : FormulaEdge -> F3ExactCoreMatrix.CoreEdge
realize(e) = {
  source  := formulaSource(e),
  target  := formulaTarget(e),
  channel := formulaChannelNat(e)
}.
```

Consequently, all saturation and permutation statements below compare
`CoreEdge` with `CoreEdge`; they never compare `FormulaEdge` directly with
the frozen list.

Channel targets are formulae, not data:

```text
retardedTarget(i) =
  3*((4*(i/3)+2) % 81) + 2.

directTarget(i,ell) = decode(stateCode(c(i,ell))).

liftTarget(i,ell) = decode(stateCode(2*c(i,ell))).
```

The direct/lift eligibility lemmas must prove that the corresponding
`stateCode` lies in `CoreCode` before `decode` is used.  The sterile case is
represented only in the Q-tail ledger and creates no `FormulaEdge`.

The projection `realize` must not erase the deep-lift distinction.  Put
`q=i/3`.  After reducing the search-free representative formula, the target
values have the following closed forms:

```text
q%3 = 2, d=(2*q-1)/3:
  directTarget(i,ell) = 3*((d + 54*ell) % 81).

q%3 = 0:
  liftTarget(i,ell) = 3*((4*(q/3) + 27*ell) % 81) + 1.
```

Thus direct targets have bucket `0`, lift targets have bucket `1`, and the
three values for `ell=0,1,2` are pairwise distinct in each eligible row.
Required bridge lemmas are:

```text
directTarget_closed_form
liftTarget_closed_form
directTarget_ell_injective
liftTarget_ell_injective
realize_injective
```

Weights remain the already frozen channel expressions:

```text
retarded          : rhoStar^(-2)
advancedDirect    : rhoStar^(alpha-1) / 3
advancedParityLift: rhoStar^(alpha-2) / 3.
```

## 3. `formulaRank`, injectivity, and cardinality 729

Use three disjoint rank intervals.

```text
rank(retarded i) = i.                              -- [0,243)

directSourceRank(i) = 3*(i/9) + (i%9-6),
  valid when i%9∈{6,7,8}.
rank(direct i ell) = 243 + 3*directSourceRank(i) + ell.
                                                    -- [243,486)

liftSourceRank(i) = 3*(i/9) + i%9,
  valid when i%9∈{0,1,2}.
rank(lift i ell) = 486 + 3*liftSourceRank(i) + ell.
                                                    -- [486,729)
```

Surjectivity is constructive, not inferred from a bound.  For `k : Fin 81`,
define

```text
directSourceUnrank(k) = 9*(k/3) + 6 + k%3
liftSourceUnrank(k)   = 9*(k/3)     + k%3.
```

These give `DirectSource ≃ Fin 81` and `LiftSource ≃ Fin 81`.  Splitting
`j : Fin 729` among the three rank intervals and using quotient/remainder by
3 gives `formulaUnrank : Fin 729 -> FormulaEdge`.

Required lemmas:

```text
formulaRank_lt_729
formulaRank_channel_intervals_disjoint
directSourceRank_injective
liftSourceRank_injective
formulaRank_injective
directSource_rank_unrank
directSource_unrank_rank
liftSource_rank_unrank
liftSource_unrank_rank
formulaRank_unrank
formulaUnrank_rank
formulaEdge_equiv_fin729 : FormulaEdge ≃ Fin 729
formulaEdge_card : Fintype.card FormulaEdge = 729
formulaCoreList_nodup       -- uses formulaUnrank and realize_injective
```

The cardinality decomposition must appear explicitly:

```text
243 retarded
+ 81 direct-eligible sources * 3 deep lifts
+ 81 lift-eligible sources   * 3 deep lifts
= 729.
```

`formulaEdge_card` may not obtain `729` by evaluating the existing edge list;
it must use the constructive rank/unrank equivalence.  The separate legacy
fact `coreEdges.length = 729` is only the audited length on the frozen side of
the later saturation argument and cannot justify formula cardinality.

## 4. Generic saturation lemma

The proof architecture compares sets first, not ordered lists.  Define the
canonical generated list without a literal RHS:

```text
formulaCoreList =
  List.ofFn (fun j : Fin 729 => realize (formulaUnrank j)).
```

Its `Nodup` proof is structural: `formulaUnrank` and `realize` are injective.
For lists `generated frozen : List alpha`, prove a reusable saturation lemma
of the following shape:

```text
saturation_of_subset_nodup_card
  (hgenNodup : generated.Nodup)
  (hsub : generated.toFinset ⊆ frozen.toFinset)
  (hlen : generated.length = frozen.length) :
  frozen.Nodup ∧ frozen.toFinset = generated.toFinset.
```

Indeed, `hgenNodup` gives
`generated.toFinset.card = generated.length`; inclusion gives the lower
bound on `frozen.toFinset.card`, while
`frozen.toFinset.card ≤ frozen.length` gives the matching upper bound.
Equality of cardinalities yields equality of finsets and also proves
`frozen.Nodup`.  The generic lemma contains no F3 arithmetic and obtains
Nodup of the historical list rather than assuming or computing it.

### 4.1 Non-search bridge to the historical frozen list

The frozen list remains only the audited object being related to the new
formula.  It is never used to define a codec, target, rank, or formula edge.
Write `q=i/3`, `b=i%3`, and `k=q/3`.  Its documented generator order gives
the arithmetic source-row position

```text
rowStart(i) =
  27*k + 4*b       if q%3=0,
  27*k + 12+b      if q%3=1,
  27*k + 15+4*b    if q%3=2.

frozenPos(retarded i) = rowStart(i)
frozenPos(direct i ell) = rowStart(i) + 1 + ell
frozenPos(lift i ell)   = rowStart(i) + 1 + ell.
```

The bridge is positional, not a search:

```text
frozenPos_lt_729
frozenPos_injective
frozen_at_formula : coreEdges.get(frozenPos(e)) = realize(e)
realize_mem_frozen : realize(e) ∈ coreEdges   -- by List.get_mem
formulaEdges_subset_frozen
formulaCoreList_length = 729
coreEdges_length = 729
```

`frozen_at_formula` is the only obligation allowed to touch the legacy
literal.  It must use the explicit index witness and the arithmetic channel
formulae.  A membership scan, `find?`, a generated match over sources, a
pair table, or a literal expected list is forbidden.  If the positional law
cannot be established inside the pilot budget without one of those devices,
the result is STOP rather than a representation escalation.

## 5. `List.Perm` and equality of matrices

Use the canonical `formulaCoreList` enumerated through `formulaUnrank`.  From

```text
coreEdges.toFinset = formulaCoreList.toFinset
coreEdges.Nodup
formulaCoreList.Nodup
coreEdges.length = formulaCoreList.length
```

derive

```text
coreEdges.Perm formulaCoreList.
```

Matrix equality does not require list equality.  For every source/target pair,
`List.Perm.filter` preserves the filtered edge multiset, and the matrix entry
is a sum of `channelWeight`.  Commutativity/associativity of addition gives

```text
coreMatrix s t = formulaMatrix s t.
```

Required named results:

```text
coreEdges_perm_formulaEdges
filtered_edges_perm
channelWeight_sum_perm
coreMatrix_eq_formulaMatrix
```

This step is the reason saturation is sufficient: generator order is no
longer part of the theorem statement.

## 6. Pilot: 27 sources

The pilot domain is

```text
PilotSource = {i : Fin 243 // i < 27}.
```

It generates edges exclusively from `FormulaEdge`:

```text
27 retarded
+ 9 direct-eligible sources * 3 lifts
+ 9 lift-eligible sources   * 3 lifts
= 81 pilot edges.
```

Define `PilotFormulaEdge` by restricting `formulaSource < 27`, give it the
same constructive rank/unrank treatment, and enumerate it with `List.ofFn`.
This generated list is permitted because it is computed from formulae; the
prohibition is against a literal expected list.  The frozen comparison side
is the existing prefix

```text
pilotFrozen = coreEdges.take 81.
```

The positional layout proves that this prefix contains exactly the edges
whose source is `<27`; it does not scan or filter all 729 entries.  There is
no literal expected RHS, lookup, pair table, CSV import, or generated case
split.  The pilot must prove:

```text
pilot_formulaRank_injective
pilot_formulaRank_unrank
pilot_formulaUnrank_rank
pilot_formulaEdges_card = 81
pilot_formulaCoreList_nodup
pilot_frozenPos_lt_81
pilot_frozen_at_formula
pilot_formulaEdges_subset_frozen
pilot_frozen_scope : all sources in pilotFrozen are < 27
pilot_frozen_length = 81
pilot_frozen_perm_formula
pilot_matrix_eq_formulaMatrix
```

If the inclusion cannot be proved arithmetically without unfolding the whole
729-edge list into a giant decision problem, the pilot is STOP: the design has
not yet replaced the old representation.

## 7. Historical pilot budget — `SUPERSEDED`

The following was the original pre-environment budget.  It is preserved for
custody only and is not live at this successor HEAD.

```text
maxHeartbeats = 200000       -- unchanged default
wall_clock_ceiling = 120 s
execution = sequential
commands = 1 compile + 1 axiom audit, audit only after compile PASS
parallelism = forbidden
retry_same_source = forbidden
```

The 120 s ceiling includes elaboration of codec, formula edges, pilot
saturation, and pilot matrix equality.  It does not authorize the 243-state
extension.

## 8. Historical acceptance contract — `SUPERSEDED_FOR_EXECUTION`

The mathematical acceptance criteria remain useful design provenance.  The
120-second execution clause and the authority to run are superseded by the
successor repair contract named at the top of this file.

### GO

The pilot advances to a separately budgeted full-core design only if all are
true:

1. the source contains no `find?`, table, `HashMap`, array lookup, or literal
   expected edge list;
2. codec inverse and residue lemmas are theorem-proved;
3. `FormulaEdge` carries eligibility by construction, all targets are computed
   by the formulae above, and `realize_injective` proves that projection does
   not collapse the three lifts;
4. rank and unrank are two-sided inverses, and the pilot cardinality is proved
   as 81 without inspecting the frozen list;
5. the legacy inclusion uses `frozenPos` plus `List.get_mem`, with no search,
   source-case table, or literal RHS;
6. saturation yields `List.Perm`, not ordered-list equality;
7. pilot matrix equality follows from permutation and additive
   commutativity;
8. compilation finishes within 120 s at `maxHeartbeats=200000`;
9. the axiom audit contains no `sorryAx` and no new opaque assumption carrying
   an F3 data identity;
10. all non-claims remain explicit.

GO label:

```text
ARITHMETIC_CODEC_PILOT_PASS_READY_FOR_FULL_CORE_BUDGET
```

### STOP

Any one of the following closes the pilot:

- timeout or heartbeat exhaustion;
- need for lookup/table/literal RHS;
- cardinality obtained from the frozen list rather than formulaRank;
- failure of rank/unrank surjectivity or of `realize_injective`;
- failure of the positional `frozen_at_formula` bridge without source cases;
- failure of channel eligibility or target bounds;
- only pointwise empirical equality, without saturation/`List.Perm`;
- any axiom or placeholder that asserts the missing identity.

STOP label:

```text
ARITHMETIC_CODEC_PILOT_STOP_ARCHITECTURE_NOT_YET_CLOSED
```

## 9. Review gate

This document is ready for adversarial review.  Lean remains closed until a
reviewer accepts:

```text
CODEC_FORMULAS = ACCEPT
FORMULA_EDGE_CHANNELS = ACCEPT
FORMULA_RANK_CARDINALITY = ACCEPT
REALIZE_POSITIONAL_BRIDGE = ACCEPT
SATURATION_PERM_MATRIX_ROUTE = ACCEPT
PILOT_SCOPE_AND_BUDGET = ACCEPT
NO_LOOKUP_NO_LITERAL_RHS = ACCEPT
```

Only that review authorizes creation of the pilot module.
