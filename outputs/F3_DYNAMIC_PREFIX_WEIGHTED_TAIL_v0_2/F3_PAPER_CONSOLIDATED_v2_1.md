# F3 paper consolidated v2.1 — adversarial repairs

Date: 2026-07-22.

This is the v2.0 consolidated paper with the adversarial ledger findings
resolved.  Lemas I–V, the tilt supersolution, `K`, overshoot, base table, and
the no-holdout-as-hypothesis rule are unchanged.

## 1. D2 sterile-channel correction

The frozen code separates the channels:

```text
split_edges.csv:    0 advanced_sterile_tail_c0 edges
split_tail_Q.csv: 243 advanced_sterile_tail_c0 rows
```

The certified matrix and its row inequality therefore never charged sterile
members.  They are an undercount of the lower-bound functional and not a loss
term.  The corrected ledger sets `eta_sterile=0`.

## 2. D1 composition-cell lemma

At horizon `n`, three shift letters produce at most

```text
N_cells(n) = C(n+2,2)
```

distinct composition cells.  The boundary line has raw factor `(5/9)^n`.
With `kappa_cell=6/5`,

```text
N_cells(n)*(kappa_cell/rho_star)^n
 = C(n+2,2)*(2/3)^n
 <= 80/27 < 3.
```

The maximum is attained at `n=3`; the bound then decreases.  Thus the factor
three in the repaired boundary ledger is a proved absorption of cell
multiplicity, not an aggregate assumption.

## 3. Corrected combined ledger

The denominator convention remains explicit: `q_norm` is measured in the
declared `rho_star^y` normalized row unit, with cell multiplicity absorbed
before summation.  The base provenance is unchanged and non-duplicated:

```text
C_I = 10 root witnesses per core state
w_min = 0.0031 frozen-vector minimum
C_I*w_min = 0.031
```

The corrected lines are

```text
eta_sterile = 0
eta_boundary = [2/(9/5)^8] * 3 / (1-5/6)
              = 0.32667993457620154
eta_phase = 0
```

Therefore

```text
eta' = 1562500/4782969
     = 0.32667993457620154 < 1
(1-eta')*C_I*w_min = 0.02087292202813775.
```

The paper-level conclusion is consequently

```text
V_y >= 0.02087292202813775 * (9/5)^(y-8),   y>=8,
```

under the six lemas and the denominator identification.

## 4. Status after repair

```text
PAPER_CONSOLIDATED_v2_1
PAPER_GATE_REPAIRED_PENDING_ADVERSARIAL_REVIEW
NO_FORMAL_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

The remaining adversarial target is unchanged and isolated: prove that the
`rho_star^y` row normalization used for the Q lines is exactly the denominator
of the stopped-tree functional.  No holdout result is used as a hypothesis.

