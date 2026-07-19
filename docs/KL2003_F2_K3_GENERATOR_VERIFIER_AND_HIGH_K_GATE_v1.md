# KL2003 F2 k=3 generator/verifier pilot and high-k gate v1

Date: 2026-07-19

## Scope

This note records the first mathematical run of the high-k pipeline:

1. derive the EL trees and the reduced `L_3^NT` rows from the parametric
   KL2003 rules;
2. find an exact rational feasible candidate near the published `k=3`
   value;
3. emit canonical JSON and Lean-data twins;
4. recheck the data in Lean without trusting the generator or Z3; and
5. use the measured costs to decide the gate toward `k=9` and `k=11`.

This is a method pilot and certificate verification result. It is not a
formalization of the full KL2003 theorem at `k=3` and it is not a new Collatz
claim.

## Primary source

Local source:

```text
/Users/MoiTam/Documents/Codex/2026-07-05/
  tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/
  kl2003_src/30apr02.tex
```

SHA256:

```text
04fa4d484fe89256f6771f5651338891219385f6e049ffaf41035541016232cd
```

Source ranges consumed:

- tracked classes and minimization: lines 401-417;
- D1/D2/D3 and the three-way minimum: lines 426-452;
- `L_k^NT`: lines 494-570;
- splitting and deletion: lines 752-784;
- termination and order independence: lines 794-858;
- the non-critical-assignment argument: lines 967-1006;
- EL growth statistics: lines 1022-1056;
- published `k=3` values: line 1559.

The generator uses offsets `3^(k-1)` in L4. The printed exponents `3^k` at
lines 532 and 534 conflict with P3 at lines 401-405 and with the explicit
definition at lines 558-561. This is recorded as a source-internal indexing
normalization, not silently inferred from the k=2 baseline.

## Generated k=3 result

Generator:

```text
scripts/kl2003_f2_k3_generator_real_v1.py
```

Canonical package:

```text
outputs/KL2003_F2_K3_GENERATOR_REAL_v1/
```

The generator derives the trees before consulting the k=2 regression oracle.
It uses Z3 only to search for a candidate and recomputes every emitted
equality and inequality with Python `Fraction`.

Measured result:

```text
tracked classes                   9
pre-reduction classes            27
EL roots                          3  (8, 17, 26 mod 27)
EL nodes                        247
EL edges                        244
kept terminal literals          116  (4, 28, 84)
deleted nodes                    10  (0, 3, 7)
maximum expansion depth          10
L3NT rows                         9
generator runtime              ~0.07 s
```

The largest tree has depth 10 and 84 terminal literals, exactly reproducing
Table 1. The parametric `k=2` projection also passes its regression oracle.

Exact candidate parameters:

```text
lambda       = 152759/100000 = 1.52759
alpha lower  = 569/359
B lower      = 104843/125000
D lower      = 16015711837/12500000000
cmax         = 31599/9059
```

The minimum exact row slack is the mode-26 D3 slack:

```text
450047250673244841279 / 6164351422405091087500000000 > 0
```

Maximum rational sizes in the emitted certificate:

```text
numerator digits    24
denominator digits  31
```

Comparison with the source table:

```text
quantity  generated             source       absolute difference
lambda    1.527590000...        1.5275960    0.0000060
gamma     0.6112573808...       0.6112620    0.0000046192...
cmax      3.4881333480...       3.4881908    0.0000574520...
```

The pilot deliberately truncates lambda downward to a rational strictly below
the published decimal. Since `Real.logb 2` is increasing, the generated gamma
is correspondingly below the published gamma. This is the safe side for a
feasible witness and is a fidelity check, not a numerical discrepancy. The
pilot does not claim to reproduce or certify the published optimum.

## Lean verifier

Generated data:

```text
CollatzClassical/KL2003/KL2003K3CertificateDataGenerated.lean
```

Trusted checker and audit:

```text
CollatzClassical/KL2003/KL2003K3CertificateVerifier.lean
CollatzClassical/KL2003/KL2003K3CertificateVerifierAxiomAudit.lean
```

The generated data includes child-index adjacency, but the checker does not
trust it. It verifies:

- root-local index integrity;
- bidirectional and complete parent/child links;
- expansion-depth increments on every edge;
- D1/D2/D3 child shapes and exact symbolic shifts;
- all three members of each minimization node;
- terminal negativity;
- deletion ancestry, equal residue, and strict shift comparison;
- exact terminal/deletion/depth metrics;
- all L0/L4 box constraints;
- all nine L1/L2/L3 row equations and positive exact slacks; and
- the rational lower endpoint for the transcendental coefficient.

The aggregate theorem is intentionally calibrated as:

```lean
k3_pilot_certificate_verified : K3PilotCertificateVerified
```

It is not named as a `k3` lower-bound theorem because the general semantic
bridge from feasible `L_k^NT` data to concrete `piStar` bounds has not been
formalized for general `k`.

Observed verification cost on this run:

```text
generated data build       ~7 s
certificate verifier       ~14 s
axiom audit                ~5 s
```

The first checker version scanned all 247 nodes for every local lookup and did
not finish within 90 seconds. The final checker uses root-indexed arrays and a
verified adjacency table, reducing the build to about 14 seconds without
using `native_decide`. This measured kernel-cost correction is part of the
high-k gate: an unindexed checker is already non-viable at `k=3`, while the
indexed design leaves the flat-row route open for a measured `k=9` benchmark.

Axiom profile:

```text
k3_tree_data_valid              [propext]
k3_pilot_certificate_verified  [propext, Classical.choice, Quot.sound]
```

No `sorry`, `admit`, `unsafe`, `native_decide`, or project axiom is used.

## Scaling evidence

The source reports the worst EL expansion size:

```text
k   nested depth   terminal literals
2        3                  8
3       10                 84
4       41              12829
5     >226        >1000000000
```

Therefore explicit EL-tree materialization is already infeasible at `k=5`,
long before `k=9` or `k=11`. The successful 247-node `k=3` checker cannot be
extrapolated by multiplying it by the number of tracked classes.

This is also a statement-fidelity finding. KL2003 proves its `k=9` and `k=11`
results despite the EL expansion already exceeding one billion literals at
`k=5`; therefore the high-k proof cannot depend on materializing those trees.
The source-level route is the abstract splitting/deletion and non-critical
assignment argument, culminating in the general feasibility-to-bound theorem.
Formalizing that argument is not a workaround invented by this project: it is
the source-faithful high-k route exposed by the growth data.

The reduced `L_k^NT` certificate has a different scale:

```text
k    tracked classes  factor from k=3
3              9              1
9           6561            729
11         59049           6561
```

Thousands of flat exact-rational rows are potentially generator/checker
work. Billions of nested EL literals are not.

## F2 gate

### Verdict 1: k=3 pilot

```text
K3_GENERATOR_VERIFIER_PILOT_PASS
```

The generator reproduced the source metrics, found a source-near exact
rational candidate, emitted schema-v2.1 twins, and the Lean verifier rechecked
the tree, rows, slacks, and endpoint bounds.

### Verdict 2: explicit EL enumeration at high k

```text
NO_GO_EXPLICIT_EL_ENUMERATION_TO_K9_OR_K11
```

This route is rejected by the primary-source growth data, not merely by a
runtime estimate. The rejection concerns explicit materialization, not the
abstract EL argument used by the paper.

### Verdict 3: reduced LNT route to k=9

```text
CONDITIONAL_GO_TO_K9_LNT_CERTIFICATE_PIPELINE
```

The condition is architectural and binding:

1. Formalize the general-k semantic theorem that turns a feasible
   `L_k^NT(lambda)` certificate into the required lower bounds without
   materializing every EL tree. The Lean proof must internalize the
   well-founded splitting/deletion argument or an equivalent parametric
   invariant, including the source's non-critical-assignment step. This is the
   principal new mathematical module, not a mechanical generalization of M0C.
2. Generalize the flat `L_k^NT` data generator and exact checker from 9 to
   6561 tracked classes.
3. Benchmark generated-data size, exact-rational digit growth, checker time,
   and minimum slack at a rational lambda below `1.7615320`.
4. Proceed only if the generated k=9 certificate is kernel-rechecked within a
   documented resource budget.

The measured `k=3` minimum slack is about `7.3e-8`, with rationals reaching 24
numerator digits and 31 denominator digits. This does not predict failure at
`k=9`, but it makes rational-size and minimum-slack growth explicit gate
criteria rather than implementation details.

The k=11 target is deferred until the k=9 gate has passed:

```text
K11_DEFERRED_UNTIL_K9_PIPELINE_PASS
```

## Next technical milestone

The next milestone is not a `k=9` tree generator. It is a scoping and Lean
prototype for the general-k `L_k^NT` semantic bridge, plus a flat `k=9` data
size/runtime dry run. That milestone decides whether the conditional GO can be
promoted to an implementation GO.

## Reproduction

```text
python3 -m py_compile scripts/kl2003_f2_k3_generator_real_v1.py
python3 scripts/kl2003_f2_k3_generator_real_v1.py

python3 scripts/kl2003_f2_k3_certificate_schema_validator_v1.py \
  outputs/KL2003_F2_K3_GENERATOR_REAL_v1/kl2003_k3_certificate.json \
  --out-dir outputs/KL2003_F2_K3_GENERATOR_REAL_SCHEMA_VALIDATION_v1

lake build CollatzClassical.KL2003.KL2003K3CertificateDataGenerated
lake build CollatzClassical.KL2003.KL2003K3CertificateVerifier
lake env lean \
  CollatzClassical/KL2003/KL2003K3CertificateVerifierAxiomAudit.lean
```

## Classifications

```text
K3_REAL_GENERATOR_EXECUTED
K2_PARAMETRIC_REGRESSION_PASS
K3_EL_TABLE1_METRICS_REPRODUCED
K3_L3NT_EXACT_RATIONAL_CANDIDATE_FOUND
K3_GENERATED_DATA_SCHEMA_V2_1_PASS
K3_PILOT_CERTIFICATE_VERIFIED_IN_LEAN
K3_GENERATOR_VERIFIER_PILOT_PASS
NO_GO_EXPLICIT_EL_ENUMERATION_TO_K9_OR_K11
CONDITIONAL_GO_TO_K9_LNT_CERTIFICATE_PIPELINE
K11_DEFERRED_UNTIL_K9_PIPELINE_PASS
NO_K3_LOWER_BOUND_THEOREM_CLAIM
NO_K9_THEOREM_CLAIM
NO_K11_084_THEOREM_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
