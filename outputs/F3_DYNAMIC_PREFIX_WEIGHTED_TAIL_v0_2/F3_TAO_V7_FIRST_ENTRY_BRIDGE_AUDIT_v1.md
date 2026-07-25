# F3 / Tao v7 first-entry bridge audit v1

Date: 2026-07-25.

Status:

```text
PRIMARY_SOURCE_CHECKED
TAO_V7_16_JUL_2026_VERIFIED
LEMMA_7_9_V7_STATEMENT_VERIFIED
PROPOSITION_5_2_SCOPE_AND_HYPOTHESES_AUDITED
GO_CONDICIONADO_AS_F3_METHOD_REFERENCE
NO_GO_AS_DIRECT_PROOF_OF_RHO_9_OVER_5
F3_5_2_0_CONDITIONAL_INTERFACE_ONLY
ACTIVE_OPERATOR_REINDEX_LOCAL_BUILD_PASS
ACTIVE_R3_AXIOM_AUDIT_75_OF_75_PASS
NO_UNJUSTIFIED_DEPTH_L_EXTENSION
NO_F3_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## 1. Sources and version control

Primary sources:

- Terence Tao, *Almost all orbits of the Collatz map attain almost bounded
  values*, [arXiv:1909.03562v7](https://arxiv.org/abs/1909.03562v7),
  [v7 PDF](https://arxiv.org/pdf/1909.03562v7).
- Published version, *Forum of Mathematics, Pi* 10 (2022), e12,
  [Cambridge/DOI](https://doi.org/10.1017/fmp.2022.8).

The arXiv record identifies v7 as revised on **16 July 2026**. Its revision
note says that two minor typographical errors and one medium error affecting
the statement of Lemma 7.9 were corrected. Therefore v7, rather than the
2022 editorial text or an earlier arXiv version, is the technical source for
the statements audited here.

The change in Lemma 7.9 is material. In v6, (7.57) was stated with the
exponential weight containing `epsilon * min(r,R)` and no event indicator.
In v7 it is instead

\[
 \mathbb E\,1_{\{R\le r\}}
 \exp\!\left(
   -\sum_{p=1}^{t_{\min(r,R)}}1_W((j',l')+v_{[1,p]})
   +\varepsilon R
 \right)
 \le e^\varepsilon .
\]

Here the hypotheses remain: the `v_i` are iid copies of `Hold`,
`(j',l')` is in `(N+1) x Z`, `R` is a positive integer, and the section's
sufficiently small absolute `0 < epsilon < 1/100` is in force. Nothing in
this renewal estimate supplies an F3 operator identity or a deterministic
first-hit capacity inequality.

## 2. Exact scope of Tao's Proposition 5.2

Proposition 5.2 is an **approximate probabilistic formula**, not a
member-wise decomposition. Its ambient data include:

- `alpha = 1.001` and sufficiently large `x`;
- `y` equal to either `x^alpha` or `x^(alpha^2)`;
- `N_y` logarithmically uniform on the odd integers in `[y,y^alpha]`;
- an arbitrary `E` contained in the odd integers in `[1,x]`;
- `n0 = floor(log x / (10 log 2))` and
  `m0 = floor((alpha-1) log x / 100)`;
- the interval `I_y` from (5.9);
- the good valuation paths `A^(n')`, on which every prefix satisfies
  `|a_[1,n] - 2n| < (log x)^0.6`;
- the set `E'` of odd `M` for which `T_x(M)=m0`, `Pass_x(M)` lies in `E`,
  and `M` lies in the scale band (5.10).

Under those definitions, (5.8) states

\[
 \mathbb P(\operatorname{Pass}_x(\mathbf N_y)\in E)
 =\sum_{n\in I_y}\sum_{\vec a\in\mathcal A^{(n-m_0)}}
   \sum_{M\in E'}
   \mathbb P(\operatorname{Aff}_{\vec a}(\mathbf N_y)=M)
   +O((\log x)^{-c}).
\]

The mechanism used in its proof is the useful part for F3:

1. the exact affine cocycle
   `Aff_a(x) = 3^n 2^(-|a|) x + F_n(a)`;
2. localization to a high-probability family of valuation prefixes;
3. localization of the first-passage time to `I_y`;
4. stepping back exactly `m0` iterates;
5. an equality of events showing that, on the good family, the stepped-back
   point lies in `E'` for the unique relevant first-passage time;
6. replacement of an orbit event by a sum over affine fibres, with the
   exceptional probability retained explicitly.

The projective viewpoint is also relevant but must not be overstated.
Remark 1.13 realizes the finite Syracuse-offset laws modulo `3^n` as
projections of one `Z_3`-valued random variable, and Lemma 1.12 supplies a
recursive finite-level law. Lemma 6.2 proves injectivity of the real offset
map `F_n`. These are precedents for typed compatible prefixes; they do not
identify the F3 frozen state, edge multiplicities, or weights.

## 3. What transfers to F3, and what does not

| Tao mechanism | Candidate F3 analogue | Required extra proof |
|---|---|---|
| affine cocycle and offset | `FormulaPath` plus concrete arithmetic realization | exact matrix/path identity retaining occurrence tags |
| compatible `3`-adic projections | `Block0Root`, fine lift and dynamic residue state | projective compatibility for the actual F3 codec |
| fixed step-back before first entry | ordered `FirstHitViaChild` / stopped path | child hit occurs before the first parent hit on the same orbit segment |
| unique first-passage time | prefix-free stopped paths and first-omission tags | same-carrier partition; no zero or double charge |
| affine fibre sum | root-tagged first-hit fibres | deterministic member-wise capacity with the frozen weights |
| good/bad probabilistic split | retained/boundary population | explicit boundary mass on the same tagged population |
| fine/coarse scale separation | root-dependent parent/child windows | proved window inclusion and verifier completeness |

This yields `GO_CONDICIONADO` for using Proposition 5.2 as a design pattern.
It yields `NO_GO` as a direct proof of the F3 target. Tao's theorem concerns
logarithmic-density almost-everywhere descent below every diverging bound.
It does not prove arrival at `1`, a fixed bound, natural density one, the F3
operator, the frozen split-edge weights, `rho >= 9/5`, or the deterministic
capacity bridge needed here.

The Fourier/triangle machinery in Sections 6--7 should not be ported at this
stage. It proves fine-scale mixing for Tao's random offset law; it does not
repair the missing F3 identity between operator mass and first-hit fibres.

## 4. Corrected finite target `F3-5.2_0`

The justified target is one frozen `Block0` layer only. Define

\[
 W_0:=\operatorname{weightedMass}
       (w,\operatorname{push}(M_{F3},\mu_0)),
 \qquad
 F_p:=\operatorname{orderedFirstHitFiber0}(p).
\]

Here `w = forwardRightWeight`, `mu0 = initialUnitMass`, and `p` ranges over
typed active occurrences. Let `R0` be the total retained contribution and
`B0` the boundary mass. The proposed theorem is:

> **`F3-5.2_0` (conditional finite first-entry bridge).** Assume all of
> (P1)--(P10) below. Then
> \[
>   W_0-B_0\ \le\ R_0\ \le\
>   \sum_{p\in\operatorname{retained0}}\#F_p\ \le\
>   \sum_{a\in\operatorname{Block0Root}}
>     \#\operatorname{piStarFinset}(a,\operatorname{parentWindow0}(a)).
> \]
> Consequently, if a separately proved estimate gives
> `B0 <= eta0 * W0` with `0 <= eta0 <= 1`, then
> \[
>   (1-\eta_0)W_0\le
>   \sum_a\#\operatorname{piStarFinset}
>     (a,\operatorname{parentWindow0}(a)).
> \]

The conditions are deliberately adversarial:

- **(P1) exact operator/path identity:** the frozen matrix mass is equal to
  the sum over typed formula paths or, at depth one, to the active
  occurrence sum. Parallel/reconvergent occurrences retain distinct tags.
- **(P2) exact active reindex:** the advanced multiplicity `3` appears
  exactly once and restores the three fine lifts; it is neither erased nor
  multiplied a second time.
- **(P3) positive normalization:** every denominator `w(s)` is strictly
  positive, and `mu0` is the declared normalization rather than a fitted
  weight.
- **(P4) ordered path semantics:** membership in `F_p` certifies the child
  hit, the fixed channel suffix, and the first parent hit in that temporal
  order on one orbit segment. Two unrelated existential orbit witnesses do
  not suffice.
- **(P5) Boolean/Proposition fidelity:** any executable predicate has a
  proved iff theorem, and the reverse generator/verifier has soundness and
  completeness, including exact predecessor enumeration.
- **(P6) same-population partition:** retained atoms and omitted atoms form
  one typed population. Every omitted atom has exactly one first-omission
  tag; boundary mass is its exact nonnegative sum.
- **(P7) member-wise capacity:** for every retained occurrence,
  `retainedContribution0 p <= #(F_p)`. An aggregate numerical fit is not a
  substitute.
- **(P8) no double counting:** stopped paths are prefix-free; fibres for
  distinct occurrence tags of one parent are pairwise disjoint, including
  parallel or reconvergent formula edges.
- **(P9) correct target and window:** each `F_p` is a subset of the parent
  `piStarFinset` at the proved root-dependent window; child and parent roots
  may not be interchanged.
- **(P10) frozen gate:** carrier, windows, retained rule, boundary rule,
  contribution normalization and acceptance criterion are fixed before
  observing fibre results. Finite-sum casts and all public dependency cones
  are audited after a build.

The first inequality follows only from the path identity and the exact
retained/boundary partition; the second is the member-wise capacity sum; the
third uses disjointness and parent-window inclusion. Thus this statement
does not hide the missing mathematics in the word "routine".

No theorem for an arbitrary depth `L` is asserted. A one-layer proof does
not iterate automatically: deeper layers require a separately typed path
identity, prefix-free stopped partition, accumulated-weight normalization,
window composition and uniform capacity theorem. Until those objects are
proved, `F3-5.2_L` is absent rather than conjecturally inherited from
`F3-5.2_0`.

## 5. Current local Lean boundary

The present worktree supports only the following scoped statements:

| layer | status | meaning |
|---|---|---|
| active carrier and card modules | `LOCAL_BUILD_AND_AUDIT_PASS` | carrier `Finset` card `1620`; seen/fresh subtype cards `68/1552`; no semantic fibre theorem |
| `F3ReturnExcursionBlock0ActiveWeight.lean` | `LOCAL_BUILD_PASS` | positivity and the one-layer contribution definition |
| `F3ReturnExcursionBlock0ActiveFormulaRow.lean` | `LOCAL_BUILD_PASS` | matrix row reindexed by all source `FormulaEdge`s only |
| operator-to-active reindex | `LOCAL_BUILD_AND_AUDIT_PASS` | `block0_operator_active_reindex` proves `W0` equals the active occurrence sum; this is a one-layer operator identity only |
| ordered first-hit partition/capacity | `PENDING` | the substantive `F3-5.2_0` hypotheses remain open |

The Active R3 audit covers all `75/75` public declarations and all `316/316`
generated declarations in the five audited namespaces. Public roots use
only subsets of `propext`, `Classical.choice`, and `Quot.sound`; the audit
finds no `Lean.ofReduceBool`, `Lean.trustCompiler`, `sorryAx`, or dependency
on the three historical frozen-table certificates named in the audit.

`LOCAL_BUILD_AND_AUDIT_PASS` is not yet a committed theorem status, an F3
exponent, or a density result. The compiled operator identity closes P1 and
P2 only at depth one. It does not construct an ordered first-hit fibre,
prove member-wise capacity, control boundary leakage, or justify iteration
to arbitrary depth. Also, the numbers `68/1552` currently count the typed
seen/fresh occurrence subtypes; separate `Finset.card` bridge theorems have
not yet been added.

## 6. Decision and next use

```text
REFERENCE_DECISION = GO_CONDICIONADO
DIRECT_RHO_DECISION = NO_GO
NEXT_PAPER_OBJECT = F3-5.2_0_WITH_P1_TO_P10_EXPLICIT
OPERATOR_TO_ACTIVE_REINDEX = LOCAL_BUILD_AND_AUDIT_PASS
NEXT_LEAN_GATE = ORDERED_REVERSE_FIRST_HIT_GENERATOR_VERIFIER
SEMANTIC_GATE = ORDERED_PATH_PARTITION_PLUS_MEMBERWISE_CAPACITY
FOURIER_PORT = DEFER
DEPTH_L_EXTENSION = NOT_AUTHORIZED_BY_THIS_AUDIT
```

Tao v7 sharpens the architecture of the open bridge: step back from a
first-entry event, preserve the exact affine itinerary, and sum fibres only
after uniqueness has removed double counting. It does not discharge any of
the F3-specific identities. Its immediate value is therefore a stricter and
better factored target, not a shortcut to `rho = 9/5`.
