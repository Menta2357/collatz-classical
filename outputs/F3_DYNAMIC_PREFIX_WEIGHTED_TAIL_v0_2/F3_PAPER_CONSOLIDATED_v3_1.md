# F3 paper consolidated v3.1 — self-contained candidate

Date: 2026-07-22.

Status:

```text
PAPER_CONSOLIDATION_READY_FOR_FINAL_REVIEW
CANDIDATE_CERTIFICATE_EMPIRICAL
FORMAL_VERDICT_PENDING_PUBLIC_CUSTODY
NO_FORMAL_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_LEAN_OPERATOR
```

This is the single self-contained paper object. It incorporates the six lemas,
the D1/D2/D3 repairs, the exact row-deficit telescoping, and the independent
Omega fallback. The observed validation ranges `y={8,9,10}` are checks only;
the paper-shaped domain is `y>=8`. No holdout result is used as a hypothesis.

## 1. Frozen data and notation

The rule-derived split core has 243 states at `d0=5`. The fine 3-adic period is
`3^6=729`; including the parity/`nu2` reticle gives implementation period
`4*3^6=2916`. The frozen left vector has hash

```text
580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40
```

```text
rho_star = 9/5
delta = 1/100
rho_prime = 5/2
lambda_prime = 49/50
theta = log(rho_prime/rho_star) = 0.32850406697203605
```

The three active shifts are

```text
h_R = -2
h_A = log2(3)-1
h_L = log2(3)-2
```

For a path `P`, `H(P)` is the sum of its edge shifts and
`M_star(P)=m_P*rho_star^(H(P))`, where `m_P` is its split multiplicity. The
stopped-tree functional is `V_y=sum_s w_s*B_s(y)`, with complete populations
counted by `B_s`; omitted sterile and boundary populations enter `Q` at first
omission.

## 2. Lema I — finite enumeration and split fibres

There are `3^4=81` admissible residue groups `r mod 3^5` with `r=2 mod 3`, and
exactly three parity/`nu2` reticle states per group, giving 243 frozen core
states. The
missing fine digit has three fibres. A fixed fibre has density `1/3` in the
depth-six period, hence

```text
N_block = 3^6*(1/3) = 3^5 = 243.
```

The exhaustive frozen-state audit confirms 243 states, 81 residue groups with
three reticle states each, exactly 243 representatives in each fine-lift
fibre, 729 distinct representatives in total, and zero state/fibre
mismatches. Thus complete blocks split with exact multiplicities `1/3,1/3,1/3`,
by finite enumeration rather than probabilistic equidistribution. In Route II,
`N_block=243` means the complete per-row block population used in the frontier
deficit; it is not an extra factor for the 243-state matrix and not a second
count of the three reticle fibres. An interval remainder is removed before
splitting and charged to `Q_boundary`; the remainder is at most two roots per
core state.

## 3. Lema II — arithmetic channel inequalities

The retarded identity is

```text
2^(y-2)*4a = 2^y*a,
```

with shift `h_R=-2`. For `c=(2a-1)/3` and `c=2 (mod 3)`,

```text
3c+1=2a,
3*2^(y-1)*c=2^y*a-2^(y-1)<=2^y*a,
```

with shift `h_A=log2(3)-1`. If `c=1 (mod 3)`, the even lift `2c` returns to
the active sector, `T(2c)=c`, and the row-22 transfer gives shift
`h_L=log2(3)-2`. If `c=0 (mod 3)`, the pure-duplication ray is counted in
`Q_sterile`, not inserted as a core edge.

## 4. Lema III — support restriction

The matrix is restricted to its 243-state dominant core. Excluded feeders and
sterile sinks are not claimed absent; discarding them only decreases a lower
bound. The frozen code has zero sterile edges in the core matrix and 243
sterile rows in the separate `Q` file, so the sterile channel is an
undercount-free omission and `eta_sterile=0` in the corrected ledger.

## 5. Lema IV — disjoint-fibre composition

Compose member-wise injections along complete split-edge paths. Paths sharing a
prefix share population only until their first differing sibling edge; after
that, fine fibres are disjoint. Stopped contributions therefore add without
double counting, and a `Q` fragment is charged at its first omission. A live
path of length `n` carries

```text
A_star(P)=(1+delta)^n*M_star(P)*w_endpoint.
```

Applying the frozen row inequality only to live atoms preserves the invariant
that live plus stopped ledger is at least its initial atom.

## 6. Lema V — Chernoff first passage and row-deficit telescoping

Define `M_tilt(e)=m_e*rho_prime^(h_e)=M_star(e)*exp(theta*h_e)`. The rational
supersolution checks all 243 rows with zero failures and maximum
`lhs/rhs=0.9771460556`; `lambda_prime=49/50<100/101`. Therefore

```text
(1+delta)*Perron(M_tilt) <= 0.9671790017367109 < 1.
```

With `K_upper=559/100000` and `w_s<=K_upper*v_s`, a live path above `-H`
satisfies

```text
Live_n(H;s) <= K_upper*v_s*exp(theta*H)
                   *((1+delta)*lambda_prime)^n.
```

The maximum upward shift is below one and the maximum downward magnitude is
two. A base interval wider than two contains every first entry; Lema IV then
converts vanishing live remainder into stopped mass, subject to the base and
`Q` constants below.

The row-deficit normalization is fixed here, inside the telescoping where it
is used. If one step retains at most `1-epsilon` of a complete row while the
certified row mass grows by `1+delta`, the normalized frontier debt has ratio

```text
q=(1-epsilon)/(1+delta).
```

Consequently its debt is `epsilon*sum_{n>=0}q^n=epsilon/(1-q)`. For
`epsilon=2/N_block` and `N_block=243`,

```text
q=(241/243)*(100/101)=24100/24543,
epsilon/(1-q)=202/443.
```

This is the denominator used by the row-deficit route, not a later comparison
table or raw population fraction.

## 7. Lema VI — base, uniform Q, and combined ledger

The base interval is `[3,10369)` at `y_base=8`. Every core state has at least
ten explicit witnesses and reaches the fixed target in at most six core edges.
The provenance is non-duplicated: `C_I=10` is the witness minimum,
`w_min=0.0031` is the frozen-vector minimum, and `C_I*w_min=0.031`.

The exact sterile count is `y+1`, but those rows are outside the core matrix,
so the corrected core ledger sets `eta_sterile=0`. The boundary starts at

```text
q_boundary(8)=2/(9/5)^8=0.01814888525423342.
```

The D1 composition-cell check is

```text
C(n+2,2)*(2/3)^n <= 80/27 < 3,
```

with equality at `n=3,4`. This pays the cell-count issue once; the D3 row
route does not multiply its complete-row deficit by 3 again.

The independent Omega aggregate route uses

```text
s_Omega=(1+delta)*Perron(2.5)=0.9671790017367109,
eta_Omega=q_boundary(8)/(1-s_Omega)=0.5529656687661839<1.
```

It already sums over live cells. Multiplying by 3 is the explicit rejected
double-count guard `1.6588970062985515`. Route I is retained as an independent
numerical cross-check, not as a second formal proof. The selected Route II
ledger likewise rejects `3*eta_row=606/443` rather than charging the same cell
loss twice.

The selected complete-row route uses two boundary roots and `N_block=243`:

```text
epsilon=2/243,
eta_row=epsilon/(1-q)=202/443=0.45598194130925507<1,
3*eta_row=606/443=1.3679458239277653>1 (rejected guard).
```

The threshold and fine margin are

```text
(1+delta)(1-epsilon)>1 iff N_block>=203,
(1+delta)(1-epsilon)=24341/24300,
net gain=41/24300=0.16872427983539096% per step.
```

The paper-level candidate bound from the selected ledger is

```text
V_y >= (1-202/443)*C_I*w_min*(9/5)^(y-8)
     = 0.01686455981941309*(9/5)^(y-8),  y>=8.
```

The split-edge holdout is validation evidence only. It used the frozen vector
with hash `580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40`
on the one-use interval `[41473,82945)`: 13824 parent roots, 40824 complete
core rows, 648 boundary rows, zero split mismatches,
`q_boundary=0.015625`, acceptance budget `0.0295828177`, and weighted ratio
`1.0296185828`. The consumed range is not rerun. These numbers test the
frozen construction; they are not hypotheses in the paper-level argument.

## 8. Denominator contract and adversarial history

`q_boundary` and `eta_row` are normalized stopped-tree ledger charges, not raw
population fractions. The denominator is the stopped-tree functional after the
declared `rho_star^y` normalization; the row ratio `q` is derived in Lema V and
used once in its geometric sum.

The three reopens are recorded rather than erased:

| reopen | defect | resolution |
|---|---|---|
| D1 | one load per depth ignored `C(n+2,2)` cells | exact `80/27` bound |
| D2 | sterile status was ambiguous | zero core sterile edges; undercount-free |
| D3 | depth was paired with parameter height | two declared routes |
| D3 guard | extra cell factor could be hidden | `606/443>1` printed and rejected |

If any member-wise denominator identification fails, its eta is withdrawn and
the gate reopens; no denominator substitution is allowed.

## Appendix A — Omega independence fallback

The Omega route does not use `N_block`. Recomputing its formula for unused
values `N_block in {81,203,243,729}` returns the same
`eta_Omega=0.5529656687661839<1`. Thus a row-count failure would not silently
destroy the candidate: the Omega route is an explicit independent fallback,
subject to its own aggregate-cell interpretation.

## 9. Domain, provenance, and next gate

The candidate statement is uniform for `y>=8` under the six lemas and the two
denominator identifications above. The hook ranges `y={8,9,10}` are validation
data only.

This is a candidate paper object, not a theorem or formal certificate. The
next gate is final adversarial review of this consolidated paper, with public
custody still pending. No Lean M0 is authorized by this document; any future
Lean budget must be a separately predeclared governance decision after the
paper review.

```text
PAPER_CONSOLIDATION_READY_FOR_FINAL_REVIEW
CANDIDATE_CERTIFICATE_EMPIRICAL
NO_FORMAL_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_LEAN_OPERATOR
```
