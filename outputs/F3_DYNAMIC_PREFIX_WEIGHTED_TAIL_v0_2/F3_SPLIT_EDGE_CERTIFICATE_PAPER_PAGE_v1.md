# F3 split-edge certificate — paper page v1

Date: 2026-07-22.

Status:

```text
PAPER_PAGE_DRAFT
CANDIDATE_CERTIFICATE_EMPIRICAL_INPUT
NO_FORMAL_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

This page records the mathematical object that must be proved before any Lean
operator is designed.  The numerical experiments are evidence for the stated
inequalities; they are not their proof.

## 1. Frozen object and empirical anchors

The state space is the split-edge finite state space at `d0 = 5`, with fine
3-adic resolution `D_fine = 6` and fine period `4*3^6 = 2916`.  The dominant
split core has 243 states.  Its rationalized left weight vector is frozen with

```text
sha256(w_core) = 580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40
D = 1000000
rho_star = 9/5
delta = 1/100
y in {8,9,10}
```

The frozen matrix has diagnostic Perron value
`1.0399310992822737`; the core value agrees through the reported precision.
This is a diagnostic of the rule-derived matrix, not a theorem about the
Collatz functional.

The one-use holdout `[41473,82945)` passed all declared empirical hooks:

```text
complete_core_rows = 40824
boundary_core_rows = 648
q_boundary_core_row_fraction = 0.015625
q_boundary_acceptance_budget = 0.029582817727073607
split_mismatch_count = 0
lhs_total = 190.25527293586472
rhs_total = 184.78228356
weighted_ratio_lhs_over_rhs = 1.0296185828555777
min_frozen_row_ratio_lhs_over_rhs = 1.0295828177270736
```

Here `rhs_total` already contains the factor `(1+delta)`.  Thus the displayed
ratio is `lhs_total / ((1+delta)*rhs_without_delta)`.  The holdout establishes
an empirical candidate only.

## 2. Definitions required by the eventual theorem

Let `B_s(y)` denote the population of complete fine 3-adic blocks represented
by core state `s` at scale `y`; let `Q_s(y)` denote the explicitly counted
sterile and boundary population removed from the lower-bound functional.  Let
`M_split(rho_star)` be the rule-derived 243-by-243 split-edge matrix, with the
scale factor attached to each channel.  The candidate functional is

```text
V_y = sum_{s in Core} w_s * B_s(y).
```

The support restriction is definitional: `V_y` claims only the core mass.  It
does not claim that excluded feeders or sterile sinks are absent.  Discarding
them can only decrease a lower-bound functional, provided their contribution is
charged to `Q` or counted as an incoming feeder before the restriction.

## 3. Six member-wise entries

Each row below must become a lemma with its hypotheses and its exact direction.

### 3.1 Retarded channel

For a retarded parent, the window identity is

```text
2^(y-2) * 4a = 2^y * a.
```

The corresponding row contributes its exact retarded multiplicity and scale
factor to `M_split`.  The proof obligation is an injection of parent members
into the displayed child window, with no unrecorded endpoint loss.

### 3.2 Advanced direct channel

For `c = (2a-1)/3`,

```text
3c + 1 = 2a
3*2^(y-1)*c = 2^y*a - 2^(y-1) <= 2^y*a.
```

This is the PHASE_B lower-bound direction.  The inequality must be applied to
the complete-block population, not to an asserted deterministic fine target.

### 3.3 Parity lift channel

When `c` is odd in the advanced branch, the even lift `2c` returns to the
active residue sector.  The transfer has the exact one-duplication scale
factor `rho_star^(-1)`.  Its arithmetic window identity is the same identity
used in the row-22 parity-lift route: the members represented by the lift are
injected into the corresponding `2c` window.  The paper must cite the existing
row-22 precedence lemmas (`row22_parity_lift_route_to_root` and
`row22_parity_piStar_transfer`) rather than silently re-prove a weaker claim.

### 3.4 Sterile channel and `Q`

The `c = 0 (mod 3)` channel is a pure duplication ray.  Its contribution is
not guessed or bounded by an aggregate constant: for a window `W` it is counted
exactly by

```text
floor(log_2(W/c)) + 1
```

when the ray is nonempty.  The resulting row contribution is placed in `Q_s`.

### 3.5 Boundary channel and `Q_boundary`

The exact one-third split applies only to complete fine blocks.  A block cut by
an endpoint of the root interval is removed row-wise and placed in
`Q_boundary,s`.  The theorem must use this same row quantity inside the
inequality; the empirical boundary fraction is not a substitute for a proof.

### 3.6 Exact three-way enumeration

On every complete block of the declared fine period, the missing 3-adic digit
produces exactly one member in each of the three fine targets.  Thus the split
edge has multiplicity `1/3` to each fine target.  This is a finite enumeration
lemma, not a probabilistic equidistribution assumption.  The statement must
specify the block modulus, the source residue, and the target residues, so it
is decidable and independently checkable.

## 4. The new mathematical bottleneck: renewal conversion

The required proposition is the following.  It is the part not supplied by the
current scripts.

**Proposition (split-edge renewal conversion, to be proved).** Assume:

1. every complete-block row satisfies the six member-wise inequalities above;
2. every omitted member is charged to a nonnegative row quantity `Q_s(y)` or
   `Q_boundary,s(y)` with an explicit finite count;
3. complete-block populations evolve by the same rule-derived split matrix for
   every `y >= y0` (or else the theorem is explicitly restricted to a finite
   declared range of `y`);
4. the frozen positive rational vector satisfies, entry by entry,

```text
sum_t w_t * M_split(s,t; rho_star)
    >= (1+delta) * w_s
```

   after the row-wise `Q` deductions have been included; and
5. the boundary/initial remainder is finite and has a declared nonnegative
   bound.

Then the weighted complete-block functional obeys a renewal lower bound of the
form

```text
V_y >= C * rho_star^y - E_y,
```

where `C > 0` depends only on the nonzero initial core mass and `E_y` is the
explicit accumulated `Q` and boundary remainder.  If the normalized remainder
satisfies `E_y <= eta*C*rho_star^y` with some fixed `eta < 1`, then

```text
V_y >= (1-eta) * C * rho_star^y.
```

The intended proof is a positive renewal/subadditivity induction: expand one
scale step, apply the row inequalities, use positivity of `w`, and telescope
the charged remainders.  The proof cannot simply quote a Perron eigenvalue,
because the split edges encode windows and returns rather than a one-step
causal transition.  It must also prove that the same normalization is used at
each scale and that no boundary term is counted twice.

This proposition is currently a paper obligation, not an established result.
Until it is proved, `rho_star` is only a parameter of an empirical operator.

## 5. Uniformity in `y`

The evidence covers only `y in {8,9,10}`.  The current page therefore has two
legal forms:

```text
FINITE-WINDOW FORM: claim only the declared three-scale empirical statement;
UNIFORM FORM: prove the renewal hypotheses for every y >= y0.
```

The program does not silently promote the first form to the second.  The
uniform form requires extending the block, phase, and boundary hooks in `y`
under a predeclared rule and proving that the `Q` budget is stable.  Until that
extension is done, no asymptotic exponent claim is licensed.

## 6. Lean gate and acceptance decision

Only after this page passes review may a Lean project be budgeted.  The planned
object is an M0 renewal kernel, not a formalization of the numerical Perron
calculation.  Its budget must name the definitions, the finite enumeration
lemma, the three arithmetic channel lemmas, the boundary accounting lemma, and
the renewal-conversion induction, with separate gates if the cache requires
shards.

If the renewal proposition receives a complete proof with the stated uniformity,
the result may advance to a formal candidate for rate `rho_star = 9/5`, whose
logarithmic exponent is `log_2(9/5) ~= 0.8480`.  If it does not close, the
correct status remains an empirical candidate certificate and the failure is a
mathematical diagnosis, not a density result.

## 7. Verdict and non-claims

```text
PAGE_STATUS = PAPER_OBLIGATION_OPEN
EMPIRICAL_INPUT = CANDIDATE_CERTIFICATE_EMPIRICAL
NEXT_GATE = REVIEW_RENEWAL_CONVERSION
NO_FORMAL_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_LEAN_OPERATOR
```

