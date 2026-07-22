# F3 combined ledger v1.2 — D3 route comparison

Date: 2026-07-22.

This report records the third adversarial reopen of the combined ledger. The
architecture, the Chernoff/supersolution input, the base table, the D1 cell
lemma, and the D2 sterile-channel classification are not reopened here. The
only question is how a frontier charge is paired with a path that can remain
near the base while its tree depth increases.

## 1. Frozen inputs and denominator

The audit uses `rho_star = 9/5`, `delta = 1/100`, `y_base = 8`, and the frozen
tilt point `rho_prime = 2.5`. Its measured Perron value is
`0.9576029720165454`, hence the growth-adjusted live-depth factor is

```text
s_Omega = (1+delta) Perron(rho_prime)
        = 0.9671790017367109.
```

The boundary line starts at

```text
q_boundary(8) = 2/(9/5)^8 = 0.01814888525423342.
```

The denominator is stated explicitly: a charge is measured against the
stopped-tree functional. Route (i) bounds it by live Omega mass per depth;
route (ii) bounds it by a complete per-row block deficit. No holdout result is
used as a hypothesis.

The D1 composition check is retained verbatim:

```text
C(n+2,2) * (2/3)^n <= 80/27 < 3,
```

with the exact maximum attained at both `n=3` and `n=4`. D2 remains `0`
sterile matrix edges and `243` sterile Q rows, so the sterile channel is an
undercount-free omission from the core lower bound.

## 2. Route (i): Omega-weighted depth accounting

Replacing the invalid `(5/9)^n` depth assignment by the Chernoff factor gives
the geometric boundary estimate. Here the Omega mass is, by definition, the
sum over all live composition cells; no separate cell multiplier is applied:

```text
eta_Omega = q_boundary(8) / (1 - s_Omega)
          = 0.5529656687661839 < 1.
```

Thus route (i) passes numerically. The explicit guard against applying the D1
cell factor a second time is

```text
3 * eta_Omega = 1.6588970062985515 > 1.
```

That guard is not an additional loss: it would count the same live cells twice.

## 3. Route (ii): relative deficit per complete row/block

Use the predeclared `N_block = 243` and at most two boundary roots. The exact
frontier deficit and retention/gain ratio are

```text
epsilon = 2/243,
q = (1-epsilon)/(1+delta) = 24100/24543.
```

Summing the relative deficit gives

```text
eta_row = epsilon/(1-q)
        = 202/443
        = 0.45598194130925507 < 1.
```

The corresponding provisional base coefficient is

```text
(1-eta_row) * C_I * w_min = 0.01686455981941309,
```

where `C_I=10` and `w_min=0.0031` are distinct factors.

The audit also prints the guard variant that multiplies this per-row charge by
the D1 cell factor. It is

```text
3 * eta_row = 606/443 = 1.3679458239277653,
```

and fails. This is the intended STOP guard: if `N_block=243` is not the
complete row/block population, the route must not silently discard the cell
factor. Conversely, if `N_block` is the complete per-row block, multiplying by
three would charge the same cell loss twice.

## 4. Gate verdict

```text
route (i), Omega aggregate: PASS numerically
route (i), extra-cell guard: STOP
route (ii), complete per-row block: PASS numerically
route (ii), extra-cell variant: STOP
```

Route (ii) has the larger numerical margin and is selected for the ledger;
route (i) remains an independent numerical cross-check. The selected route is
therefore
`ROUTE_II_SELECTED_ROUTE_I_ALSO_NUMERIC_PASS_PENDING_MEMBERWISE_DENOMINATOR_LEMMA`.

The remaining obligation is a paper lemma, not a new numerical choice:

> `N_block = 243` is the complete per-row block used by the frontier deficit;
> no independent composition-cell factor remains in that same row charge.

Until that statement is written and reviewed member-wise, the paper gate stays
reopened. The candidate remains empirical and all NO-CLAIMS remain active:
no formal rho certificate, no density theorem, and no Lean operator.
