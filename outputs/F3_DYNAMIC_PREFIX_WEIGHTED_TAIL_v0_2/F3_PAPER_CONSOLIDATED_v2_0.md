# F3 paper consolidated v2.0

Date: 2026-07-22.

Status:

```text
PAPER_CONSOLIDATED_v2_0
PAPER_GATE_COMPLETE_PENDING_ADVERSARIAL_REVIEW
CANDIDATE_CERTIFICATE_EMPIRICAL
NO_FORMAL_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

This document is the single review object.  It consolidates the split-edge
operator, the Chernoff conversion, the base segment, the uniform Q counts, and
the combined ledger.  The validation ranges `{8,9,10}` remain empirical
checks; the stated paper domain is `y >= 8`.

## 1. Frozen data and notation

The rule-derived core has 243 states at `d0=5`, fine period
`4*3^6=2916`, and frozen left vector hash

```text
580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40
```

The scale parameters are

```text
rho_star = 9/5
delta = 1/100
rho_prime = 5/2
lambda_prime = 49/50
theta = log(rho_prime/rho_star) = 0.32850406697203605
```

The three shifts are

```text
h_R = -2
h_A = log2(3)-1
h_L = log2(3)-2.
```

For a path `P`, let `m_P` be its split multiplicity and

```text
H(P) = sum of its edge shifts,
M_star(P) = m_P * rho_star^(H(P)).
```

The weighted functional is

```text
V_y = sum_{s in Core} w_s * B_s(y),
```

where `B_s(y)` counts complete fine-block populations and all omitted sterile
or boundary populations are charged row-wise to `Q`.

## 2. Lema I — exact finite enumeration

For every complete fine block modulo `4*3^6`, the missing 3-adic digit gives
exactly one member in each of the three fine lifts.  The split multiplicities
are therefore `1/3,1/3,1/3`.  This is a finite residue enumeration, not a
probabilistic equidistribution assumption.

If an interval cuts a block, the fragment is removed before applying the split
and charged to `Q_boundary`.  For each core state the three fine-lift counts
differ by at most one; removing `3*min(count_0,count_1,count_2)` leaves at most
two boundary roots.

## 3. Lema II — arithmetic channel inequalities

The three active channels and the sterile channel are justified as follows.

### Retarded

```text
2^(y-2) * 4a = 2^y * a.
```

This is an exact window injection with shift `h_R=-2`.

### Advanced direct

For `c=(2a-1)/3` and `c=2 (mod 3)`,

```text
3c+1 = 2a
3*2^(y-1)*c = 2^y*a - 2^(y-1) <= 2^y*a.
```

This is the PHASE_B lower-bound identity with shift `h_A=log2(3)-1`.

### Advanced parity lift

For `c=1 (mod 3)`, the even lift `2c` returns to the active sector,
`T(2c)=c`, and the row-22 transfer gives the exact duplication factor.  Its
shift is `h_L=log2(3)-2`, not `h_A`; this third letter is retained everywhere.

### Sterile channel

For `c=0 (mod 3)`, the descendants form the exact pure-duplication ray.  They
are counted and charged to `Q_sterile`; they are not inserted as a core edge.

## 4. Lema III — support restriction

The split matrix is restricted to its 243-state dominant core.  The functional
is defined on that support only.  Excluded feeders and sterile sinks are not
claimed absent; discarding them can only decrease a lower-bound functional, and
the sterile rows are explicitly charged to `Q`.

## 5. Lema IV — composition with disjoint fibres

Compose member-wise injections along complete split-edge paths.  Two paths with
the same prefix share population only until their first differing sibling edge;
after that divergence their fine fibres are disjoint.  Consequently stopped
path contributions add without double counting.  A `Q` fragment is charged at
its first omission only.

For the live/stopped tree ledger, a path of length `n` carries

```text
A_star(P) = (1+delta)^n * M_star(P) * w_endpoint.
```

Only live atoms are expanded.  Applying the frozen row inequality to each live
state preserves the invariant “live plus stopped ledger is at least its initial
atom”.

## 6. Lema V — Chernoff first passage

Define the tilted matrix by

```text
M_tilt(e) = m_e * rho_prime^(h_e)
           = M_star(e) * exp(theta*h_e).
```

The rational supersolution checker uses the upward envelope and verifies, for
all 243 rows,

```text
M_tilt_upper * v <= (49/50) * v.
```

The checker result is `0` failing rows and maximum `lhs/rhs=0.9771460556`.
The strict comparison `49/50 < 100/101=1/(1+delta)` gives

```text
(1+delta)*Perron(M_tilt) <= 0.9671790017367109 < 1.
```

Let `v>0` be the right Perron/supersolution vector and choose the rational
comparison constant

```text
K_upper = 559/100000,
w_s <= K_upper*v_s for every core state.
```

For a path that is still live above `-H`,
`M_star(P)=M_tilt(P)*exp(-theta H(P)) <= exp(theta H)M_tilt(P)`.  Therefore,
using `M_tilt v <= lambda_prime v`,

```text
Live_n(H;s)
 <= K_upper*exp(theta H)*(1+delta)^n*(M_tilt^n v)_s
 <= K_upper*v_s*exp(theta H)*((1+delta)*lambda_prime)^n.
```

The last factor decays geometrically.  Choose

```text
n_star = ceil((theta*H + log(K_upper*v_s/epsilon)) /
              (-log((1+delta)*lambda_prime))).
```

The maximum upward shift is below one and the maximum downward magnitude is
two.  With a base interval of width greater than two, first entry cannot jump
over the base.  Lema IV then converts the vanishing live remainder into stopped
mass, subject to the base and Q constants below.

## 7. Lema VI — base, Q, and combined ledger

### Base segment and provenance

The base interval is `[3,10369)` at `y_base=8`.  Every core state has at least
ten explicit root witnesses, and every state reaches the fixed target state in
at most six core edges.  The two factors in the base coefficient are distinct:

| factor | value | provenance | used once |
|---|---:|---|---|
| `C_I` | `10` | minimum root witnesses per core state | yes |
| `w_min` | `0.0031` | minimum frozen split-core weight | yes |
| `C_I*w_min` | `0.031` | product of the preceding two rows | — |

No additional `w_min` is inserted in the ledger.

### Uniform sterile Q

The exact sterile count is `y+1`.  The denominator is written explicitly as
the declared normalized row unit `rho_star^y`:

```text
q_sterile(y) = (y+1)/rho_star^y.
q_sterile(8) = 9/(9/5)^8 = 0.08166998364405038.
```

The polynomial factor is absorbed by the declared conservative base
`kappa_sterile=3/2`:

```text
(y+2)/(y+1) * (kappa_sterile/rho_star)
 <= (10/9)*(5/6) = 25/27 < 1       (y>=8).
```

Hence

```text
q_sterile(y) <= 0.08166998364405038*(3/2)^(-(y-8))
eta_sterile = 0.24500995093215114.
```

### Uniform boundary Q

For each core state the fine-period count leaves at most two boundary roots.
Against the same declared `rho_star^y` normalized row unit,

```text
q_boundary(8) = 2/(9/5)^8 = 0.01814888525423342.
kappa_boundary = 9/5.
eta_boundary = 0.04083499182202519.
```

The PHASE_B identity is exact, so `eta_phase=0`.

### Combined sum

The geometric sum is executed exactly:

```text
eta = eta_sterile + eta_boundary + eta_phase
    = 2734375/9565938
    = 0.2858449427541763 < 1.
```

The STOP condition `eta>=1` is false.  The resulting paper-level lower bound
is

```text
V_y >= (1-eta)*C_I*w_min*rho_star^(y-y_base)
     = 0.02213880677462053*(9/5)^(y-8),       y>=8.
```

## 8. Denominator contract for adversarial review

The symbols `q_sterile` and `q_boundary` are not raw population fractions.  In
this paper they mean `Q_line(y)/D_s(y)` in the normalized row ledger, with the
declared normalization `D_s(y)=rho_star^y` before the base coefficient is
factored out.  The final conversion factors out `C_I*w_min` once at `y_base`.

The adversarial reviewer must check that this `D_s(y)` is exactly the same row
functional denominator used in the Chernoff stopped-tree inequality, rather
than an unrelated scale proxy.  If that identification fails, the numerical
eta is withdrawn and the gate reopens; no denominator substitution is allowed.

## 9. Domain, provenance, and next gate

The theorem-shaped statement is uniform for `y>=8` under the six lemmas and the
denominator identification above.  The observed hook ranges `y={8,9,10}` are
validation data only, never hypotheses of the statement.

The next gate is adversarial review of this single document.  Only after it
passes may the program write and approve a Lean M0 renewal budget.

```text
NO_FORMAL_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_LEAN_OPERATOR
```

