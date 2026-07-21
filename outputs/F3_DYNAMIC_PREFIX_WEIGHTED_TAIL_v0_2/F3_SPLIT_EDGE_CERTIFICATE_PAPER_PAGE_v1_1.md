# F3 split-edge certificate — paper page v1.1

Date: 2026-07-22.

Status:

```text
PAPER_OBLIGATION_OPEN
PAPER_PAGE_v1_1_REVIEWED
LEMMA_B_PROOF_ATTEMPT_OPEN
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

The two scale shifts are

```text
h_R = -2                         (retarded)
h_A = alpha - 1 > 0              (advanced),
alpha = log_2(3).
```

Thus an advanced edge points to the larger coordinate `y+h_A`.  This is why an
induction that only knows lower `y` is invalid.  The proof below is a first-
passage renewal argument and never replaces `h_A` by a negative shift.

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

**Statement.** Let `I = [y_base, y_base+L]` with `L > 2`.  Assume the two shifts
are `h_R=-2` and `h_A=alpha-1`, the core split graph is irreducible, and the
row-wise inequality (2.1) holds at every complete-block row.  Let `P_I` be the
family of paths whose partial sums start outside `I` and enter `I` for the
first time at their final vertex.  Then, for every starting coordinate `y`,

```text
sum_{p in P_I(y)} W(p) * rho_star^(H(p))
    >= C_I * (1+delta)^m_y * rho_star^(y-y_base) ,                (B.1)
```

after summing over the finitely many first-entry states, where `C_I>0` is a
base mass independent of `y`, `m_y` is the number of certified row
compositions on the path, and all omitted terms are the explicitly accumulated
`Q` and `Q_boundary` charges.  In particular, if their normalized total is at
most `eta<1`, then

```text
V_y >= (1-eta) * C_I * rho_star^(y-y_base).                       (B.2)
```

**Proof attempt.**

1. For a path with partial sums `u_j = y + h_1+...+h_j`, stop at the first
   `j` for which `u_j in I`.  Since `|h_R|=2`, `0<h_A<1`, and `L>2`, a path
   crossing into `I` cannot jump over the whole interval: if it comes from
   below, the positive overshoot is less than one; if it comes from above, the
   downward overshoot is at most two.  Hence the stopped endpoint is in `I`.

2. Apply Lemma A to all stopped paths with the same first-entry state.  The
   sibling-fibre disjointness makes the sum legitimate even though the paths
   have different lengths and different numbers of advanced steps.  The
   product of scale factors along a path is `rho_star^(H(p))`.

3. Apply (2.1) at each non-stopped row before stopping.  A composition of `m`
   certified rows contributes at least `(1+delta)^m` in the weighted endpoint
   functional.  This factor is never obtained by an upward induction in `y`;
   it comes from the product along the stopped path.

4. Partition the stopped paths by their first-entry state and by the integer
   number of retarded steps.  The net displacement is
   `H(p) = -2 r + (alpha-1) a`.  The irrationality of `alpha` prevents two
   distinct `(r,a)` pairs from producing the same displacement, so this is a
   disjoint renewal decomposition rather than a cancellation identity.

5. The base interval has finite width and the core graph is irreducible.  A
   finite connecting path from every core state to a positive base state gives
   a strictly positive minimum base mass `C_I`; this is Lemma C.  Summing the
   first-entry classes and factoring the common scale `rho_star^(y-y_base)`
   gives (B.1).

6. The only terms not covered by the product are first omissions.  Charge each
   to `Q_s` or `Q_boundary,s` at the row where it is first omitted.  Positivity
   and the no-double-charge convention yield the remainder `E_y`.  If
   `E_y <= eta*C_I*rho_star^(y-y_base)`, subtracting it gives (B.2).

The proof is complete modulo the finite base-segment verification in Lemma C
and the explicit all-`y` bounds in §5.  In particular, it does not assume a
future value is known and does not replace the advanced shift by `-2`.

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
4. instantiate Lemma B with an explicit eta<1;
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

