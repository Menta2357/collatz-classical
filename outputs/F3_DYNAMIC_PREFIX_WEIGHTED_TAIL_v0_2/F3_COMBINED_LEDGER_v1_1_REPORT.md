# F3 combined ledger v1.1 — D1/D2 repair

Date: 2026-07-22.

Status:

```text
PASS_COMBINED_LEDGER_D1_D2_REPAIRED
PAPER_GATE_REOPENED_LEDGER_AGGREGATION_RESOLVED
NO_FORMAL_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. D2: sterile status checked against frozen code

The frozen operator files give:

```text
sterile edges in split_edges.csv = 0
sterile rows in split_tail_Q.csv = 243
```

Thus `c=0 (mod 3)` is not part of the matrix inequality that produced the
supersolution.  Those members are omitted from the claimed lower-bound
functional, so they are an undercount, not a loss line.  The repaired ledger
sets

```text
eta_sterile = 0.
```

This is a code-level status check, not an appeal to interpretation.

## 2. D1: cell multiplicity and absorption

With three shift letters, the number of composition cells at horizon `n` is at
most

```text
N_cells(n) = C(n+2,2).
```

The boundary line has raw decay factor `(5/9)^n` from the `rho_star` denominator.
Choose `kappa_cell=6/5`; the remaining factor is `(2/3)^n`.  The exact finite
absorption check is

```text
C(n+2,2)*(2/3)^n <= 80/27 < 3,
```

with the maximum at `n=3`.  Therefore the polynomial cell multiplicity is
absorbed by the declared constant `3` and does not remain hidden in the sum.

## 3. Corrected ledger

The base and comparison factors remain:

```text
C_I = 10
w_min = 0.0031
K_upper = 559/100000
C_I*w_min = 0.031
```

The only remaining Q line is the cell-corrected boundary line:

```text
q_boundary(8) = 2/(9/5)^8 = 0.01814888525423342
eta_boundary_cell = q_boundary(8)*3/(1-5/6)
                  = 0.32667993457620154
eta_sterile = 0
eta_phase = 0
```

Hence

```text
eta' = 1562500/4782969
     = 0.32667993457620154 < 1.
```

The corrected lower-bound coefficient is

```text
(1-eta')*C_I*w_min = 0.02087292202813775.
```

The predeclared STOP condition `eta' >= 1` is false.

## 4. Reproducibility

Checker:

```text
scripts/f3_combined_ledger_v1_1.py
```

Output:

```text
results/F3_RETURN_EXCURSION_SPLIT_EDGE_v1/combined_ledger_v1_1.json
```

The result keeps the denominator contract explicit: boundary `q_norm` is
computed in the declared `rho_star^y` normalized row unit, and cell multiplicity
is absorbed before the geometric sum.  The adversarial denominator identity
remains the review hook for the consolidated paper.

