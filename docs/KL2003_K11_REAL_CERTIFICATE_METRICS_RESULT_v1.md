# KL2003 k=11 Real Certificate Metrics Result v1

## Verdict

```text
K11_REAL_CERTIFICATE_METRICS_PASS
```

The accepted budget was fixed before canonical artifact generation in
`KL2003_K11_REAL_CERTIFICATE_METRICS_GATE_v1.md`.  This result authorizes the
real Lean checker gate under the already accepted 81-shard hierarchical
architecture.  It is not a Lean certificate, endpoint theorem, or k=11
piStar theorem.

## Exact candidate

The generated flat `L_11^NT` candidate has:

```text
tracked rows       = 59049
auxiliary classes  = 19683
D1 / D2 / D3 rows  = 19683 / 19683 / 19683
lambda             = 71689/40000 = 1.792225
rounding scale      = 100000000
```

Every persisted row was recomputed with Python `Fraction`.  The exact checks
all pass:

- principal and auxiliary values are at least one;
- all lift slacks are nonnegative;
- all `59049` row slacks are strictly positive;
- `B^359 * lambda^149 <= 1`;
- `D^359 <= lambda^210`.

The minimum measurements are:

```text
minimum row slack          = 3263/5139312721
minimum row slack decimal  = 6.349097976986094e-7
minimum row slack mode     = 174632
minimum relative slack     = 89937170159/142866320462829841
minimum relative decimal   = 6.295197487248182e-7
minimum relative mode      = 29372
```

These are measurements of this candidate, not theorem constants.

## Source fidelity diagnostics

The source table records `lambda_11 = 1.7922310`, `gamma_11 = 0.8417560`,
and `C_11^max = 98.4009647`.  The safe rational lambda is below the printed
decimal by `0.0000060`, with resulting diagnostics:

```text
candidate gamma   = 0.8417517679800235666...
gamma safe gap    = 0.0000042320199764333...
candidate Cmax    = 98.39647125
Cmax absolute gap = 0.00449345
```

The candidate gamma being slightly below the printed value is the intended
safe direction.  These decimal comparisons support source fidelity but do
not replace the future exact endpoint proof.

## Cost and size

The persisted run completed within every fixed PASS threshold:

| Metric | Measured | PASS budget |
|---|---:|---:|
| total generator and exact recheck | `1.380964 s` | `<= 120 s` |
| exact recheck | about `0.30 s` | included above |
| power iterations | `213` | diagnostic |
| maximum numerator digits | `31` | `<= 50` |
| maximum denominator digits | `35` | `<= 50` |
| canonical JSON | `26892763 bytes` | `<= 250 MB` |
| row CSV | `11369977 bytes` | diagnostic |
| auxiliary CSV | `1565845 bytes` | diagnostic |

The four mathematical artifacts are byte-stable across two consecutive
runs.  Their SHA256 values are:

```text
certificate JSON  38cda619be386d29d88bfc39df042e60a6025bf021b0638704adf52a4d2143df
row CSV           a229b923cc654331b84ff29eaa0355db8dea05350b823862de3203aad7480430
auxiliary CSV     7246c7372708edf1677298ce94d5ab055baaf1fd3ba961cbe9c76ee314e7f5f5
slack CSV         5dbf7e77776610e501eca4c7fcd448c5ec3af2f25264a07c3000521444822d0f
```

The summary runtime is intentionally not byte-stable because it records
wall-clock measurements.

## Comparison with earlier measured candidates

The k=11 candidate does not exhibit the feared rational-size explosion:

| Candidate | Rows | Minimum row slack | Max numerator/denominator digits |
|---|---:|---:|---:|
| k=3 | `9` | about `7.30e-8` | `24 / 31` |
| k=9 | `6561` | about `1.46e-6` | `30 / 34` |
| k=11 | `59049` | about `6.35e-7` | `31 / 35` |

The candidates use different normalizations and searches, so this table is a
resource panel rather than a trend law.  It supports proceeding to the real
checker without claiming monotonic slack behavior.

## Next gate

The next authorized work is the real k=11 Lean data/checker package:

```text
81 data shards
-> thin global router
-> 81 arithmetic checker shards
-> 9 group dispatchers
-> 1 top dispatcher
```

That gate must retain the predeclared resource budgets, record real source and
`.olean` sizes, enforce the memory policy where the host exposes RSS, and
finish with an axiom audit.  No `LNTCertificate` may be declared before every
shard and both dispatcher levels compile.

Endpoint specialization, a `gammaK11 > 21/25` lemma, and the arbitrary-`x`
piStar theorem remain downstream.

## Reproduction

```text
python3 -m py_compile scripts/kl2003_f2_k11_lnt_measurement_v1.py
python3 scripts/kl2003_f2_k11_lnt_measurement_v1.py
git diff --check
```

## Classifications

`K11_REAL_CERTIFICATE_METRICS_PASS`

`K11_59049_EXACT_ROW_SLACKS_POSITIVE`

`K11_RATIONAL_SIZE_WITHIN_BUDGET`

`K11_CANONICAL_ARTIFACTS_DETERMINISTIC`

`K11_REAL_LEAN_CHECKER_AUTHORIZED`

`K11_LEAN_CERTIFICATE_NOT_PROVED`

`NO_K11_THEOREM_CLAIM`

`NO_GLOBAL_COLLATZ_CLAIM`
