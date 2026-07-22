# F3 split-edge certificate — paper page v1.2 (Chernoff tilt)

Date: 2026-07-22.

Status:

```text
PAPER_OBLIGATION_OPEN
TILT_VALLEY_PASS
LEMMA_B_CHERNOFF_DRAFT
CANDIDATE_CERTIFICATE_EMPIRICAL_INPUT
NO_FORMAL_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

This page is the Chernoff-tilt replacement for the failed Azuma closure in
v1.1.  It retains the three-shift alphabet and the path/fibre bookkeeping of
Lemmas A and C.

## 1. Frozen constants

```text
rho_star = 9/5 = 1.8
rho_prime = 2.5
theta = log(rho_prime/rho_star) = 0.32850406697203605
delta = 1/100
Perron(M_split(rho_prime)) = 0.9576029720165454
gamma = 1 - Perron = 0.04239702798345457
gamma_eff = 1 - (1+delta)*Perron = 0.0328209982632891
```

The last margin is the one relevant to the path ledger, because each live row
also carries the certified factor `(1+delta)`.  The predeclared grid audit
reconstructs `Perron(M_split(rho_star))=1.0399310992822715` and passes the
strong condition `(1+delta)*Perron(M_split(rho_prime))<1`.

The frozen vector hash remains
`580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40`.
The number `min_s w_s=0.0031` is only a finite vector proxy; it is not the base
constant in the theorem.

## 2. Tilt identity and Perron vector

For each rule edge `e` with shift `h_e`,

```text
M_star(e) = m_e * rho_star^(h_e)
M_tilt(e) = m_e * rho_prime^(h_e)
             = M_star(e) * exp(theta*h_e).
```

The shifts are

```text
h_R = -2,
h_A = alpha-1,
h_L = alpha-2,
alpha = log2(3).
```

Let `r=Perron(M_tilt)<1` and let `v>0` be a right Perron vector,
`M_tilt v = r v`.  Since the core is finite and irreducible, `v` is strictly
positive.  Define the finite comparison constant

```text
K = max_s w_s/v_s.
```

Computing a rational enclosure for `v` and `K` is part of the paper audit; no
floating-point eigenvector is silently promoted to a proof constant.

## 3. Lemma B — Chernoff form

**Statement.** Let `I=[y_base,y_base+L]` with `L>2`.  Assume Lemma A's
disjoint-fibre composition, Lemma C's positive base mass, the six member-wise
channel inequalities, and the frozen split matrix.  If

```text
(1+delta)*Perron(M_tilt) < 1,
```

then the stopped first-entry family has positive weighted mass and

```text
V_y >= C_I * rho_star^(y-y_base) - E_y,
```

with `E_y` consisting only of the explicitly charged `Q` and boundary rows.
If `E_y <= eta*C_I*rho_star^(y-y_base)` for an explicit `eta<1`, then

```text
V_y >= (1-eta)*C_I*rho_star^(y-y_base).
```

### Proof draft

1. **Tree ledger and stopping.** For a path `P` of length `n`, write

   ```text
   A_star(P) = (1+delta)^n * product_e M_star(e) * w_endpoint.
   ```

   Stop a path at its first entry into `I`; stopped atoms are frozen and only
   live atoms are expanded.  Lemma A gives disjointness after the first
   differing sibling edge.  Applying the row inequality to each live endpoint
   gives the tree invariant “live plus stopped ledger is at least its initial
   atom”, without using a power of `M_star` as a surrogate for stopping.

2. **Tilted live bound.** If a length-`n` path is still live above the lower
   boundary `-H`, its net shift satisfies `H(P)>-H`.  Since
   `M_star(P)=M_tilt(P)*exp(-theta*H(P))`,

   ```text
   M_star(P) <= exp(theta*H) * M_tilt(P).
   ```

   Summing first over all paths (which only enlarges the live family) and using
   `w_t <= K*v_t` gives, for a start state `s`,

   ```text
   Live_n(H;s)
      <= K*exp(theta*H) * (1+delta)^n * (M_tilt^n v)_s
      = K*v_s*exp(theta*H) * ((1+delta)*r)^n.                 (B.4)
   ```

   The factor `((1+delta)*r)^n` decays because
   `gamma_eff=1-(1+delta)r=0.0328209982632891>0`.

3. **Choose a finite horizon.** For any prescribed remainder `epsilon>0`, set

   ```text
   n_star(H,s,epsilon) = ceil(
       (theta*H + log(K*v_s/epsilon)) /
       (-log((1+delta)*r))
   ).
   ```

   Then (B.4) is at most `epsilon`.  The live contribution can therefore be
   made smaller than any fixed fraction of the initial ledger by a finite,
   explicitly named horizon.  No uniform local drift is needed; the Perron
   vector incorporates the state dependence.

4. **First entry, overshoot, and base mass.** The only shifts are
   `{-2,alpha-1,alpha-2}`.  The maximum upward jump is below one and the
   maximum downward magnitude is two, so `L>2` prevents a crossing from
   jumping over `I`.  Lemma A makes the stopped fibres disjoint, and Lemma C
   supplies the positive base constant `C_I`.  The first omissions are charged
   once to `Q` or `Q_boundary`; subtracting their explicit total gives `E_y`.
   Letting `epsilon` tend to the declared `eta` yields the displayed lower
   bound.

The only non-contingent analytic input in this draft is the finite-dimensional
Perron inequality and the elementary Chernoff comparison (B.4).  The proof is
not yet formal because the paper still has to publish rational enclosures for
`v,K`, the finite base table in Lemma C, and the all-`y` `Q` bounds.

## 4. Remaining acceptance hooks

```text
1. rationally enclose the positive right Perron vector v of M_tilt;
2. compute and freeze K=max_s w_s/v_s with a safety margin;
3. publish the 243-state base-segment table proving C_I>0;
4. prove the sterile-ray and boundary Q bounds for all y;
5. instantiate eta and verify E_y <= eta*C_I*rho_star^(y-y_base).
```

Only after these hooks pass may the page advance to a formal candidate theorem
or a budgeted Lean M0.  The tilt audit itself remains empirical evidence for
the route.

## 5. Verdict and non-claims

```text
PAGE_STATUS = PAPER_OBLIGATION_OPEN
TILT_AUDIT = PASS_TILT_VALLEY_GROWTH_ADJUSTED
LEMMA_B = CHERNOFF_DRAFT_PENDING_K_BASE_Q
NEXT_GATE = RATIONAL_PERRON_VECTOR_AND_BASE_HOOKS
NO_FORMAL_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_LEAN_OPERATOR
```

