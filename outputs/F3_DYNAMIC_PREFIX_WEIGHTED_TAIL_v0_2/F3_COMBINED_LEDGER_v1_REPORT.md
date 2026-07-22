# F3 combined ledger v1

Date: 2026-07-22.

Status:

```text
PASS_COMBINED_LEDGER
PAPER_GATE_COMPLETE_PENDING_ADVERSARIAL_REVIEW
NO_FORMAL_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. Denominators and constants

The ledger uses the declared `rho_star`-normalized row units:

```text
q_norm_line(y) = Q_line(y) / rho_star^y
rho_star = 9/5
y_base = 8
C_I = 10 root witnesses per core state
w_min = 0.0031
C_I*w_min = 0.031
```

The comparison constant for the Chernoff vector is rationalized upward as

```text
K_upper = 559/100000 = 0.00559
K_exact_max = 0.005581  (state_id = 474)
K_reverify_bad_count = 0
```

## 2. Decay lines

### Sterile ray

The exact count is `y+1`.  At the base:

```text
q_sterile(8) = 9/(9/5)^8 = 0.08166998364405038.
```

Choose `kappa_sterile=3/2`.  Since
`((y+2)/(y+1))/(9/5) <= 25/27 < 1` for `y>=8`,

```text
q_sterile(y) <= 0.08166998364405038 * (3/2)^(-(y-8)).
eta_sterile = q_sterile(8)/(1-2/3)
             = 0.24500995093215114.
```

### Boundary fragments

The three fine residue counts differ by at most one, so the boundary remainder
is at most two roots per state.  With the same declared `rho_star^y`
denominator,

```text
q_boundary(8) = 2/(9/5)^8 = 0.01814888525423342.
kappa_boundary = 9/5.
eta_boundary = q_boundary(8)/(1-5/9)
              = 0.04083499182202519.
```

### Phase

```text
eta_phase = 0
```

because the PHASE_B window identity is exact.

## 3. Sum and final coefficient

The exact sum is

```text
eta = 2734375/9565938
    = 0.2858449427541763 < 1.
```

The final paper-level bound is therefore

```text
V_y >= (1-eta) * C_I * w_min * rho_star^(y-y_base)
     = 0.02213880677462053 * rho_star^(y-y_base).
```

The predeclared STOP condition `eta >= 1` is false.  The computation is in
`scripts/f3_combined_ledger_v1.py` and its output is
`results/F3_RETURN_EXCURSION_SPLIT_EDGE_v1/combined_ledger_v1.json`.

## 4. Scope of the PASS

This closes the combined numerical ledger under the declared normalization and
the rational-envelope inputs.  The remaining review obligation is adversarial:
verify that the `rho_star^y` denominator used by each Q line is exactly the
same denominator as the row functional in Lemma B, and replace decimal scale
envelopes by proved real enclosures before calling the result formal.  Until
that review, this is a completed paper candidate, not a rho certificate.

