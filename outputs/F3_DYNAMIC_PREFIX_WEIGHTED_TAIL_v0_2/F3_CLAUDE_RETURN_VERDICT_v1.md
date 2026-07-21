# F3 Claude return verdict v1

Date: 2026-07-21.

## Verdict received

Claude returned after the local continuation and accepted:

```text
PRE_SPECTRAL_CANDIDATE = ACCEPT
```

with the explicit caveat that the formal coordinated verdict was absent during
the local continuation and must not be retroactively invented.

## Accepted facts

```text
PHASE_A stopped honestly with q_fraction about 40%
visible alphabet correction accepted
PHASE_B identity checked:
  3 * 2^(y-1) * c(a) = 2^y * a - 2^(y-1)
PHASE_B all-residues holdout accepted as hook-clean
status = ingredients pass hooks, operator not yet built
```

## Five obligations for F3_PHASE_B_DYNAMIC_OPERATOR_v1

```text
O1 M is derived from rules, not data.
O2 weights are frozen before holdout.
O3 tail appears member-wise in the same inequality.
O4 y-uniformity is explicit; {8,9,10} alone is not uniform.
O5 every entry of M corresponds to a demonstrable member-wise inequality.
```

## Consequence

The next object is authorized:

```text
F3_PHASE_B_DYNAMIC_OPERATOR_v1
```

but only under these obligations. Any spectral pass without O1-O5 remains a
candidate diagnostic, not a certificate.

