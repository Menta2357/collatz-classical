# KL2003 k=11 Real Certificate Metrics Gate v1

## Purpose

This gate generates the first persisted exact-rational candidate for the flat
`L_11^NT` system.  It measures feasibility, slack, rational digits, data size,
and generator time before any Lean checker, `ClassRootsK` specialization,
endpoint theorem, or `gammaK11` theorem is attempted.

The primary source table at `30apr02.tex:1543-1578` records:

```text
gamma_11 = 0.8417560
lambda_11 = 1.7922310
C_11^max = 98.4009647
```

The candidate uses the exact rational

```text
lambda = 71689/40000 = 1.792225
```

which is strictly below the printed decimal by `0.0000060`.

## Coefficients

The existing exact lower witness `569/359 < alpha` is used only to select
safe rational coefficient candidates:

```text
A = lambda^(-2)
B = 784931055601/1000000000000
D = lambda * B
```

The generator must recheck with `Fraction`:

```text
B^359 * lambda^149 <= 1
D^359 <= lambda^210
```

These checks make the persisted candidate exact.  Formal Real endpoint
theorems remain downstream and may require a sharper alpha witness after the
real slack data are known.

## Required artifact

The generator emits:

- canonical JSON containing all `59049` row records, `19683` auxiliary
  records, exact coefficients, exact slacks, and topology indices;
- CSV views of rows, auxiliary lift constraints, and exact slacks;
- a metrics summary and mismatch file;
- a SHA256 manifest.

No Lean data or checker module is emitted in this gate.  The accepted
hierarchical architecture will translate the candidate in the next pass.

## Metrics and acceptance

The normalized row slack is defined exactly as:

```text
relative_slack_m = row_slack_m / c_m
```

| Metric | PASS | OPTIMIZATION_REQUIRED | FAIL |
|---|---:|---:|---:|
| Exact row slacks | all `> 0` | n/a | any `<= 0` |
| Exact lift slacks | all `>= 0` | n/a | any `< 0` |
| Principal and auxiliary boxes | all `>= 1` | n/a | any violation |
| Maximum numerator/denominator digits | `<= 50` | `51..70` | `> 70` |
| Canonical JSON size | `<= 250 MB` | `(250, 500] MB` | `> 500 MB` |
| Generator plus exact recheck | `<= 120 s` | `(120, 300] s` | `> 300 s` |
| Candidate gamma | below source, gap `<= 1e-5` | below source, larger gap | at/above source |
| Candidate `Cmax` diagnostic | absolute gap `<= 0.1` | larger gap | not a proof blocker |

Minimum absolute and relative slacks are measurements, not preselected lower
bounds.  Positivity is the binding mathematical criterion.

## Preliminary parameter sanity check

Before this artifact budget was written, a non-persisted in-memory run checked
that the selected lambda, B, and rounding scale were capable of producing
positive exact rows.  Therefore this document is not claimed to be blind to
basic feasibility.  It is fixed before canonical artifact generation and
governs the persisted runtime, sizes, digit growth, fidelity diagnostics, and
exact recheck.

## Trust boundary

- NumPy is used only to search for a positive vector.
- Every persisted row and lift inequality is recomputed with Python
  `Fraction`.
- Python and the candidate remain untrusted for the future theorem.
- Lean must recheck the candidate through the 81-shard hierarchical design.

## Guardrails

- No `LNTCertificate` is declared here.
- No Lean module is added or changed.
- No endpoint or arbitrary-`x` theorem is claimed.
- No k=11 `0.84` theorem or global Collatz claim is made.

## Classifications

`K11_REAL_CERTIFICATE_METRICS_BUDGET_FIXED`

`K11_SAFE_RATIONAL_LAMBDA_SELECTED`

`K11_EXACT_FRACTION_RECHECK_REQUIRED`

`K11_LEAN_CHECKER_NOT_STARTED`

`NO_K11_THEOREM_CLAIM`

`NO_GLOBAL_COLLATZ_CLAIM`
