# F3 split-edge certificate — paper page v1.1

Date: 2026-07-22.

Status:

```text
PAPER_OBLIGATION_OPEN
PAPER_PAGE_v1_1_REVIEWED
LEMMA_B_DRIFT_SIGN_PASS_QUANTITATIVE_BOUND_PENDING
CANDIDATE_CERTIFICATE_EMPIRICAL_INPUT
NO_FORMAL_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

This page supersedes only the proof route in §4 and the uniformity discussion
in §5 of `F3_SPLIT_EDGE_CERTIFICATE_PAPER_PAGE_v1.md`.  The frozen data,
member-wise channel entries, holdout numbers, and non-claims remain unchanged.

## 1. Frozen object and empirical anchors

The rule-derived split object has `d0 = 5`, fine resolution `D_fine = 6`,
fine period `4*3^6 = 2916`, and a 243-state dominant core.  Its rationalized
left weight vector is frozen by

```text
sha256(w_core) = 580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40
D = 1000000
rho_star = 9/5
delta = 1/100
```

The rule-derived diagnostic Perron value is
`1.0399310992822737`.  This is not a theorem about any asymptotic functional.

The one-use holdout `[41473,82945)` passed:

```text
complete_core_rows = 40824
boundary_core_rows = 648
q_boundary_core_row_fraction = 0.015625
q_boundary_acceptance_budget = 0.029582817727073607
split_mismatch_count = 0
weighted_ratio_lhs_over_rhs = 1.0296185828555777
min_frozen_row_ratio_lhs_over_rhs = 1.0295828177270736
```

The displayed weighted ratio is
`lhs_total / ((1+delta)*rhs_without_delta)`; the holdout is empirical only.

## 2. Definitions and the two scale coordinates

Let `B_s(y)` be the complete fine-block population in core state `s` at
exponent-window coordinate `y`.  Let `Q_s(y)` and `Q_boundary,s(y)` be the
nonnegative row-wise populations removed from the lower-bound functional.  Set

```text
V_y = sum_{s in Core} w_s * B_s(y).
```

The three scale shifts are

```text
h_R = -2                         (retarded)
h_A = alpha - 1 > 0              (advanced direct)
h_L = alpha - 2 < 0              (advanced parity lift),
alpha = log_2(3).
```

The direct advanced edge points to the larger coordinate `y+h_A`; the parity
lift is advanced plus one duplication and therefore has its own descending
shift `y+h_L`.  This third letter is part of the renewal alphabet, not a
notation change.  An induction that only knows lower `y` is still invalid for
the direct edge, so the proof below is a first-passage renewal argument.

For a path `p = (s_0,...,s_m)` with channel shifts `h_1,...,h_m`, write

```text
H(p) = h_1 + ... + h_m,
W(p) = product of the corresponding split-edge weights.
```

The matrix inequality is understood with the scale weight already attached:

```text
sum_t w_t * M_split(s,t; rho_star)
    >= (1+delta) * w_s.                 (2.1)
```

Every deduction of `Q` is made before (2.1) is applied to a row.

## 3. Member-wise entries retained from v1

The six entries are unchanged and must be proved with the same directions:

1. Retarded: `2^(y-2)*4a = 2^y*a`.
2. Advanced direct: `3c+1=2a` and
   `3*2^(y-1)c = 2^y*a - 2^(y-1) <= 2^y*a`.
3. Parity lift: the even lift `2c` has the exact one-duplication factor
   `rho_star^(-1)`, with the row-22 transfer lemmas as precedent.
4. Sterile `c=0 (mod 3)`: the duplication ray is counted exactly and charged
   to `Q_s`.
5. Boundary fragments: incomplete fine blocks are charged row-wise to
   `Q_boundary,s`.
6. Complete fine blocks: the lost 3-adic digit gives one member in each fine
   target, hence multiplicity `1/3` to each target.  This is finite enumeration,
   not a statistical assumption.

The support restriction to the 243-state core is a lower-bound restriction: it
does not assert that the 486 excluded states are empty.

## 4. Corrected renewal route

### Lemma A — composition of paths with disjoint fibres

**Statement.**  Compose the member-wise injections along a finite split-edge
path.  If two paths first diverge at a split edge, their descendants lie in
disjoint fine sibling fibres.  Consequently the weighted lower bounds add:

```text
mass(P_1 union ... union P_r)
    >= sum_j W(P_j) * mass_at_endpoint(P_j) - Q(P_1,...,P_r).       (A)
```

Here `Q` is the sum of the row-wise sterile and boundary charges, with a fibre
charged at its first omission only.

**Paper proof.** The complete-block enumeration gives disjoint sibling
classes.  Induct on path length.  At a common prefix, apply the member-wise
inequality once; after the first divergence, the target fine residues are
disjoint, so the induction hypotheses add without multiplicity collision.
The sterile and boundary rows are removed before the next composition and are
therefore charged at most once.  This is exactly the finite-fibre version of
the M0b composition rule.

### Lemma B — first passage through a base interval

**Statement.** Let `I = [y_base, y_base+L]` with `L > 2`.  Assume the three
shifts are `h_R=-2`, `h_A=alpha-1`, and `h_L=alpha-2`, the core split graph is
irreducible, and the row-wise inequality (2.1) holds at every complete-block
row.  Let `P_I` be the family of paths whose partial sums start outside `I`
and enter `I` for the first time at their final vertex.  Then, for every
starting coordinate `y`,

```text
sum_{p in P_I(y)} W(p) * (1+delta)^|p| * rho_star^(H(p))
    >= C_I * rho_star^(y-y_base) ,                               (B.1)
```

after summing over the finitely many first-entry states, where `C_I>0` is a
base mass independent of `y`, `|p|` is the number of certified live-row
compositions on that stopped path, and all omitted terms are the explicitly
accumulated `Q` and `Q_boundary` charges.  Equivalently, if one has a
predeclared lower bound `|p| >= m_y` on the selected stopped family, its
contribution is at least `C_I*(1+delta)^m_y*rho_star^(y-y_base)`.  If the
normalized remainder is at most `eta<1`, then

```text
V_y >= (1-eta) * C_I * rho_star^(y-y_base).                       (B.2)
```

**Proof attempt.**

1. Work on the tree of population paths, not on a power of `M_split`.  For a
   path `P` of length `j`, define its ledger atom

   ```text
   A(P) = (1+delta)^j * m_P * rho_star^(H(P)) * w_(endpoint(P)),
   ```

   where `m_P` is its exact split multiplicity.  At depth `n`, partition the
   atoms into `Alive_n` (no first entry into `I` yet) and `Stopped_{<=n}` (the
   first-entry time is at most `n`).  A stopped atom is frozen and is never
   expanded again.

2. The induction invariant is the tree statement

   ```text
   sum_{P in Alive_n union Stopped_{<=n}} A(P)
       >= the initial core atom.                                  (B.3)
   ```

   To pass from `n` to `n+1`, apply (2.1) separately to each *alive* endpoint
   state and expand only that atom.  The factor `(1+delta)` is paid by the
   live row; stopped atoms are carried unchanged.  This proves (B.3) by
   induction without ever asserting that a future value of `B_s(y+h_A)` is
   already known.

3. For a path with partial sums `u_j = y+h_1+...+h_j`, stop at the first `j`
   for which `u_j in I`.  Since the largest upward jump is `h_A<1`, the
   largest downward magnitude is `|h_R|=2`, and `L>2`, a crossing cannot jump
   over the whole base interval.  The lift jump `h_L` is already descending.
   Hence every first-entry endpoint is genuinely in `I`.

4. Apply Lemma A to the stopped tree, indexed by complete paths from the root.
   Two paths with the same prefix share the population only up to their first
   differing edge; after that edge their fine sibling fibres are disjoint.
   Thus the sum over stopped paths is a sum of disjoint population fibres, not
   a sum over matrix powers with hidden collisions.  The path scale is exactly
   `rho_star^(H(P))`.

5. The certified factor is now attached only to live rows.  A stopped path
   with `j` live compositions has the explicit factor `(1+delta)^j`; there is
   no claim that all paths have the same `j`.  Grouping by first-entry state
   and by `(r,a,l)`, where
   `H(P)=-2r+(alpha-1)a+(alpha-2)l`, gives the renewal classes.  Equal net
   shifts, if produced by different triples, are grouped and their
   multiplicities add; no injectivity of the triple-to-shift map is assumed.

6. The base interval has finite width and the core graph is irreducible.  A
   finite connecting path from every core state to a positive base state gives
   a strictly positive minimum base mass `C_I`; this is Lemma C.  Summing the
   first-entry classes and factoring the common scale `rho_star^(y-y_base)`
   gives (B.1).

7. The only terms not covered by the product are first omissions.  Charge each
   to `Q_s` or `Q_boundary,s` at the row where it is first omitted.  Positivity
   and the no-double-charge convention yield the remainder `E_y`.  If
   `E_y <= eta*C_I*rho_star^(y-y_base)`, subtracting it gives (B.2).

### Quantitative live-mass lemma — the extracted `p0`

For a core source `s`, let `L_s=(w^T M_split)_s` and let `R_s` be the
retarded-edge contribution to `L_s`.  The frozen matrix gives the exact finite
diagnostic

```text
p0 = min_s R_s/L_s
   = 0.19485689248944574,
argmin source_id = 6, target_id = 26.
```

The computation is reproduced by
`scripts/f3_retarded_channel_p0_audit.py` and its output
`results/F3_RETURN_EXCURSION_SPLIT_EDGE_v1/retarded_channel_p0_audit.json`,
both tied to the frozen vector hash above.  Therefore every live row sends at
least a `p0` share of its *weighted one-step expansion* through a descending
retarded edge.  This is the required finite matrix input to a quantitative
stopping estimate.

The implication `p0>0 => all live mass is geometrically exhausted` is **not**
asserted here: positive advanced shifts can keep a path above the base.  The
remaining paper obligation is the bounded-lag first-passage estimate that
combines this `p0` share with the retarded downward jump of magnitude two, the
lift downward jump `h_L`, the `0<h_A<1` upward jump, and the frozen row weights
to produce an explicit `n=O(y-y_base)`
cutoff and a remainder `E_y`.  Any proof of that estimate must cite (B.3), the
   finite `p0` audit, or a stated rational drift/renewal inequality; “the live
   paths die out” by itself is not accepted.

### Perron-normalized drift audit

Define the Doob–Perron row kernel from the frozen objects by

```text
q(s,t) = M_split(s,t) * w_t / sum_u M_split(s,u) * w_u.
```

The sterile `c=0` rows are excluded from `q` because they are `Q` rows.  Let
`pi` be the stationary distribution of this finite core kernel and attach the
three shifts to their channel edges.  The audit
`scripts/f3_perron_drift_audit.py` reports

```text
mu = sum_s pi(s) sum_t q(s,t) h(s,t)
   = -0.7831050099641175

stationary channel shares:
  retarded                 = 0.4153515469191942
  advanced_direct_c2       = 0.29024911579817286
  advanced_parity_lift_c1  = 0.2943993372826331
stationary residual        = 1.734723475976807e-17
```

The published audit therefore passes the predeclared sign test
`mu < 0` (`PASS_DRIFT_ROUTE`).  This value differs from the earlier scalar
estimate `-0.4334`; that estimate is not substituted for the matrix audit.
The discrepancy is recorded, not rounded away.  The reproducible matrix value
is the one eligible for Lemma B.

With the three bounded increments and this negative stationary drift, the
remaining paper step is the standard finite-state Markov-additive first-
passage estimate: construct the centered martingale, apply a bounded-
increment Azuma/Freedman bound at `n = O(y-y_base)`, and convert the small
survivor probability into an explicit weighted remainder `E_y`.  The theorem
must state its constants and its dependence on the finite mixing/initial
segment; `mu<0` alone is not a license to write “the live mass vanishes”.

The proof therefore closes the tree bookkeeping and first-entry geometry, but
Lemma B remains open precisely at this quantitative first-passage estimate,
plus the finite base-segment verification in Lemma C and the explicit all-`y`
bounds in §5.  It does not assume a future value is known and does not replace
the advanced shift by `-2`.

### Lemma C — positive base mass

**Statement.** For the chosen base interval `I`, there is a finite list of core
states and complete fine blocks with positive initial mass; every core state
reaches that list by a finite split path.  Therefore the constant `C_I` in
Lemma B is strictly positive.

**Verification obligation.** Enumerate the 243 core states, record one finite
connecting path per state, and check the corresponding complete-block count.
This is a finite base-segment computation and must be published before any
Lean claim.  It is not supplied by the current holdout script.

## 5. Uniformity reclassified

The earlier finite-window warning is refined as follows.

```text
Hypothesis 1 (six channel identities): uniform in y by exact arithmetic,
monotonicity, and finite enumeration.

Hypothesis 3 (split rule and matrix): uniform in y once the same complete-block
semantics is stated; the rational matrix is not refit at another y.

Hypothesis 4 (frozen weighted inequality): a finite rational inequality,
independent of y, verified once for the frozen object.

Hypotheses 2 and 5 (Q and boundary): empirical magnitudes were measured only
at y={8,9,10}; the uniform theorem requires two arithmetic counting lemmas.
```

The first required counting lemma computes the sterile duplication ray exactly
for every `y` (a logarithmic count).  The second bounds the fraction of blocks
cut by an interval boundary from the fine block modulus, with no statistical
equidistribution assumption.  Until these two lemmas are written, the page
licenses only the three-window empirical statement.

## 6. Acceptance gate before Lean

The next paper checks are predeclared:

```text
1. publish the 243-state base-segment table and verify Lemma C;
2. write the exact first-passage partition and no-double-charge invariant;
3. prove the all-y sterile-ray and boundary counting bounds;
4. prove the bounded-lag first-passage estimate using the audited negative
   `mu` (and an explicit finite-state concentration/mixing bound), then
   instantiate Lemma B with an explicit eta<1;
5. only then budget an M0 Lean renewal kernel.
```

If step 4 fails, the candidate remains empirical and no asymptotic exponent is
claimed.  If it closes, the prospective rate is `rho_star=9/5`, with
`log_2(9/5) ~= 0.8480`; this remains a conditional consequence until the
renewal conversion is proved.

## 7. Verdict and non-claims

```text
PAGE_STATUS = PAPER_OBLIGATION_OPEN
LEMMA_A = PAPER_ROUTE_ACCEPTED
LEMMA_B = PROOF_ATTEMPT_OPEN_PENDING_BASE_AND_Q_CHECKS
LEMMA_C = FINITE_VERIFICATION_PENDING
NEXT_GATE = COMPLETE_LEMMA_B_ON_PAPER
NO_FORMAL_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_LEAN_OPERATOR
```
