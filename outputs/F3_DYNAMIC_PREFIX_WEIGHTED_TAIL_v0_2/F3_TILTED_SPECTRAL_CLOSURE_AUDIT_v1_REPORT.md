# F3 tilted spectral closure audit v1

Date: 2026-07-22.

Status:

```text
PASS_TILT_VALLEY
DIAGNOSTIC_INPUT_TO_LEMMA_B
NO_FORMAL_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. Predeclared object and reconstruction check

The audit uses the frozen split core and the published vector

```text
rho_star = 9/5 = 1.8
delta = 1/100
core_state_count = 243
frozen_w_sha256 = 580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40
```

For a rule edge with shift `h`, the frozen edge weight is re-evaluated at
`rho_prime` by the exact tilt identity

```text
M(rho_prime)_e = M(rho_star)_e * (rho_prime/rho_star)^h.
```

The three shifts are

```text
retarded                 h = -2
advanced_direct_c2       h = log2(3)-1
advanced_parity_lift_c1  h = log2(3)-2
```

Sterile `c=0` rows remain `Q` and are not transitions of the core matrix.
Reconstructing at `rho_prime=rho_star` gives

```text
rho_star_reconstruction_perron = 1.0399310992822715
```

which agrees with the frozen core diagnostic `1.0399310992822715`.

## 2. Predeclared grid

The grid was fixed before reading its values:

```text
rho_prime in {1.9, 2.0, 2.05, 2.1, 2.2, 2.35, 2.5}.
```

The full curve is:

| `rho_prime` | `theta=log(rho_prime/rho_star)` | Perron | `gamma=1-Perron` |
|---:|---:|---:|---:|
| 1.90 | 0.0540672213 | 1.0176080340 | −0.0176080340 |
| 2.00 | 0.1053605157 | 1.0000000000 | approximately 0 |
| 2.05 | 0.1300531282 | 0.9926791302 | 0.0073208698 |
| 2.10 | 0.1541506798 | 0.9862216433 | 0.0137783567 |
| 2.20 | 0.2006706955 | 0.9755834711 | 0.0244165289 |
| 2.35 | 0.2666286633 | 0.9643563954 | 0.0356436046 |
| 2.50 | 0.3285040670 | 0.9576029720 | 0.0423970280 |

The best grid point is

```text
rho_prime = 2.5
theta = 0.32850406697203605
perron = 0.9576029720165454
gamma = 0.04239702798345457
```

The spectral-valley condition `min_grid_perron < 1` passes.  For the actual
weighted live ledger, the row-growth factor `(1+delta)` must also be paid.  The
growth-adjusted closure numbers are

```text
(1+delta)*Perron(rho_prime) = 0.9671790017367109
effective_gamma = 1 - (1+delta)*Perron = 0.0328209982632891
```

Thus the stronger predeclared condition `(1+delta)*min_grid_perron < 1`
passes as well.  The script also records `C_vector_min = 0.0031`, but labels
it correctly as a vector-minimum proxy.  The base constant `C` in Lemma B is
not thereby proved.

## 3. Consequence for the paper route

The tilt audit removes the specific Azuma obstruction: the same rule-derived
operator has a tilted Perron value below one.  The intended Chernoff argument
now has named constants

```text
theta = log(2.5/1.8)
gamma = 1 - Perron(M_split(2.5))
      = 0.04239702798345457.
```

For the path ledger including the frozen row growth, the usable margin is
`gamma_eff = 0.0328209982632891`.

For the eventual paper proof, one must still write the operator-Chernoff
inequality with the state-dependent Perron vector, prove the first-passage
stopping decomposition from Lemma A, and insert a genuinely proved base mass
from Lemma C.  The audit is therefore a PASS for the route, not a formal
renewal theorem.

## 4. Reproducibility and gate

Source script:

```text
scripts/f3_tilted_spectral_closure_audit.py
```

Output:

```text
results/F3_RETURN_EXCURSION_SPLIT_EDGE_v1/tilted_spectral_closure_audit.json
```

The next accepted object is the Chernoff-form rewrite of Lemma B.  It must
retain the three-shift alphabet, use `theta` and `gamma` above, and not promote
`C_vector_min` to the base constant without Lemma C.

## 5. Non-claims

```text
NO_FORMAL_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_LEAN_OPERATOR
```
