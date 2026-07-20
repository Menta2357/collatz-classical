# KL2003 F2 k=9 LNT Measurement Gate v1

Date: 2026-07-20

Status: `K9_FORMALIZATION_ENGINEERING_GO`

## Scope

This gate measures the flat `L_9^NT` certificate route after the general-k
semantic chain and its k=3 `piStar` consumer were proved in Lean. It does not
state or prove a k=9 lower-bound theorem. The authorized next scope is only the
integration of the generated exact certificate into the existing general-k
`LNTCertificate` interface.

The explicit EL-tree route remains rejected. No k=9 or k=11 EL tree is
materialized here.

## Source and candidate

The row topology is generated from `30apr02.tex` lines 494-570. The source
table at line 1571 reports:

```text
lambda_9 = 1.7615320
gamma_9  = 0.8168300
Cmax_9   = 43.3394210
```

The candidate deliberately uses a rational value on the safe side:

```text
lambda             = 70461/40000 = 1.761525
gamma diagnostic   = 0.8168249500642604...
Cmax candidate     = 4333739799/100000000 = 43.33739799
minimum row slack  = 8074574573/5516391690000000
                    = 1.46374206669...e-6
```

The gamma gap is expected: the rational lambda is below the published
near-optimal decimal. It is not presented as a source discrepancy.

## Flat generator

The generator emits and exactly rechecks:

```text
tracked principal classes  = 6561
auxiliary classes          = 2187
D1 / D2 / D3 rows          = 2187 / 2187 / 2187
pre-reduction classes      = 19683
power iterations           = 204
external exact recheck     = PASS
generator wall time        = 0.239098 s
maximum rational digits    = 30 numerator / 34 denominator
```

The numerical Perron iteration is untrusted search. Every box constraint, L4
constraint, endpoint witness and row slack is recomputed with Python
`Fraction` before emission. The original monolithic Z3 feasibility attempt did
not return within the interactive budget and is not part of the trusted or
recommended pipeline.

## Schema and artifacts

The schema-v2.1 validator accepts the 6561-row JSON artifact with zero errors
and one already named warning:

```text
EXTERNAL_MANIFEST_PRESENT_NOT_VALIDATED
```

The canonical JSON is about 12.9 MB. The chunked Lean data twin is about 1.26
MB. A monolithic Lean `Array` representation failed to elaborate within 322
seconds. Splitting the data into chunks of 81 reduced elaboration to 22.27
seconds. The chunked representation is therefore binding for the integration
pass.

## Kernel benchmark

Nine independent Lean shards recompute the exact rational row equalities,
positive slacks, principal lower boxes and all auxiliary L4 boxes with
`norm_num`.

```text
checker shards                 = 9/9 PASS
row equations rechecked        = 6561
auxiliary box groups rechecked = 2187
timeouts / failures            = 0 / 0
workers                        = 3
data elaboration               = 22.272169 s
sum of shard times             = 1244.451968 s
total wall time                = 437.152929 s
resource budget                = 900 s
```

No `native_decide` is used. These generated checker files prove arithmetic
facts about the candidate data. They are not the semantic k=9 theorem.

## Gate decision

All five measured conditions pass:

1. General-k semantic bridge: closed and validated at k=3.
2. Flat k=9 generator: 6561 rows generated from parametric rules.
3. Exact certificate scale: positive slack and manageable rational size.
4. Schema v2.1: pass.
5. Kernel resource budget: full arithmetic recheck below 900 seconds.

Therefore:

```text
K9_FORMALIZATION_ENGINEERING_GO
```

This authorizes only the next integration module: generated/chunked data,
construction of a concrete `LNTCertificate` at k=9, application of the already
proved general-k consumer, and a final axiom audit. Until that module exists:

```text
NO_K9_THEOREM_CLAIM
K9_SEMANTIC_INTEGRATION_NOT_STARTED
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```

## Reproduction

```text
python3 -m py_compile scripts/kl2003_f2_k9_lnt_measurement_v1.py
python3 scripts/kl2003_f2_k9_lnt_measurement_v1.py

python3 scripts/kl2003_f2_k3_certificate_schema_validator_v1.py \
  outputs/KL2003_F2_K9_LNT_MEASUREMENT_v1/kl2003_k9_lnt_certificate.candidate.json \
  --out-dir outputs/KL2003_F2_K9_LNT_SCHEMA_VALIDATION_v1

python3 -m py_compile scripts/kl2003_f2_k9_kernel_checker_benchmark_v1.py
python3 scripts/kl2003_f2_k9_kernel_checker_benchmark_v1.py

python3 -m py_compile scripts/kl2003_f2_k9_measurement_gate_v1.py
python3 scripts/kl2003_f2_k9_measurement_gate_v1.py
```
