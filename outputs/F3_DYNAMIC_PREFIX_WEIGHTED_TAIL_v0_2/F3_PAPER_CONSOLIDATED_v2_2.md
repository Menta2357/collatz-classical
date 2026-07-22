# F3 paper consolidated v2.2 — D3 route comparison

Date: 2026-07-22.

This is the consolidated paper after the D3 adversarial finding. Versions
v2.0/v2.1 remain historical inputs; this version withdraws their boundary
ledger conclusion and records both predeclared repairs.

## 1. Scope of the reopen

D1 (composition-cell multiplicity) and D2 (sterile channel outside the frozen
core matrix) remain repaired:

```text
C(n+2,2)*(2/3)^n <= 80/27 < 3,
```

with equality at `n=3,4`, and `0` sterile edges in `split_edges.csv` versus
`243` sterile rows in `split_tail_Q.csv`. The Chernoff valley, rational
supersolution, `K` recheck, overshoot, and base table are unchanged.

D3 rejects the remaining depth/parameter identification: a path can alternate
the two advanced letters and remain near the base while its tree depth grows.
Thus the prior assignment of a `(5/9)^n` parameter decay to every depth cell is
withdrawn by the paper's own STOP clause.

## 2. Route comparison

The frozen data give

```text
rho_star = 9/5,
delta = 1/100,
rho_prime = 2.5,
Perron(rho_prime) = 0.9576029720165454,
s_Omega = (1+delta)*Perron = 0.9671790017367109.
```

Route (i), Omega-weighted depth accounting, treats Omega mass as already
aggregated over all live composition cells and yields

```text
eta_Omega = [2/(9/5)^8] / (1-s_Omega)
          = 0.5529656687661839 < 1.
```

The explicit extra-cell guard is `3*eta_Omega=1.6588970062985515>1`; it is
not an additional loss, because it would count the same live cells twice.

Route (ii), relative deficit per complete row/block, uses the predeclared
`N_block=243` and two boundary roots:

```text
epsilon = 2/243,
q = (1-epsilon)/(1+delta) = 24100/24543,
eta_row = epsilon/(1-q) = 202/443 = 0.45598194130925507 < 1.
```

The extra-cell guard is intentionally retained:

```text
3*eta_row = 606/443 = 1.3679458239277653 > 1.
```

Both routes pass numerically under their respective denominator conventions.
Route (ii) has the larger margin and is selected, but only under the explicit
denominator lemma that `N_block` already is the complete per-row block. That
lemma prevents charging the same composition-cell loss twice.

## 3. Paper status

```text
PAPER_GATE_REOPENED_D3_ROUTE_II_SELECTED_ROUTE_I_ALSO_NUMERIC_PASS
ROUTE_I_OMEGA_AGGREGATE_NUMERIC_PASS
ROUTE_II_NUMERIC_PASS_PENDING_MEMBERWISE_DENOMINATOR_LEMMA
NO_FORMAL_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

The next paper action is to state and review the per-row denominator lemma.
Only after it passes may the combined ledger be reinstated and the paper move
to the adversarial review of the complete document. No holdout number is used
as a hypothesis.
