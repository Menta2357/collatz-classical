# Auditable generator-verifier formalization for KL2003

Method paper draft v1.

Date prepared: `2026-07-19`.

Status: `COMPLETE_INTERNAL_DRAFT_NOT_SUBMITTED`.

## Proposed title

```text
From Source Equations to Kernel-Checked Certificates:
An Auditable Generator-Verifier Pipeline for Collatz Counting Bounds
```

## Abstract

Large computer-assisted arguments create a recurring formalization problem:
the mathematical proof may reduce to a finite certificate, while the program
that discovers that certificate is too large or too heuristic to place in the
trusted base. We report a generator-verifier workflow developed while
formalizing the difference-inequality method of Krasikov and Lagarias for the
3x+1 problem. The workflow separates an untrusted source-derived generator,
canonical JSON and Lean-data twins, a kernel-checked verifier, and independent
member-wise semantic hooks. At `k=2` the pipeline is regressed against a
manual Lean development, including a nested elimination tree and exact
rational slacks. That regression exposed and repaired a project-introduced
source normalization error before the concrete seam was accepted. At `k=3`
the generator reproduces the source's tree metrics and published numerical
scale, emits an exact rational feasible certificate, and is rechecked by Lean
in approximately 14 seconds. Primary-source growth data simultaneously rules
out explicit elimination-tree materialization for high `k`, isolating the
general semantic feasibility theorem as the source-faithful next formalization
target. The case study yields reusable design rules for source fidelity,
certificate schemas, trust boundaries, regression oracles, and calibrated
claims in AI-assisted formal mathematics.

## 1. Problem setting

Krasikov-Lagarias 2003 derives lower bounds for the number of integers whose
3x+1 trajectories enter a specified root. The proof combines:

```text
inverse-orbit semantics
difference inequalities indexed by residue classes
splitting and deletion of nested elimination trees
finite linear feasibility certificates
a retarded lower-bound induction
an asymptotic translation to power-law counting bounds
```

The source reports high-`k` numerical results, but the corresponding full row
systems and certificates are not printed. A faithful formalization therefore
needs both mathematical reconstruction and a disciplined way to handle
generated finite data.

The repository first closes a calibrated `k=2` surrogate theorem:

```lean
kl2003_k2_m1_surrogate_root8_lower_bound
```

which gives, for every natural `x >= 2^17`, a lower bound of the form

```text
DeltaV2 * (x/8)^gammaK2 <= piStar 8 x,
gammaK2 = log_2(27/20) > 3/7.
```

This is not the full KL2003 high-`k` theorem and not a global Collatz claim.

## 2. Trust architecture

The pipeline has four deliberately separate layers.

### 2.1 Untrusted generator

The generator reads source-level rules and searches for finite data. It may
use ordinary Python, exact `Fraction` arithmetic, graph algorithms, and an SMT
solver for candidate discovery. Its output is not accepted because the
program ran successfully.

### 2.2 Canonical twin artifacts

Each generated certificate has two synchronized representations:

```text
canonical JSON       provenance, external audit, hooks, stable hashes
generated Lean data  Nat/Rat literals consumed by the formal verifier
```

The manifest records hashes for the JSON, Lean data, and translator. Rational
strings are reduced and sign-normalized. No floating-point number is admitted
as certificate evidence.

### 2.3 Kernel-checked verifier

Lean rechecks every property needed by the mathematical consumer. Generated
adjacency or indexing tables are treated as candidate accelerators and are
validated before use. The verifier, not the generator, belongs to the trusted
mathematical chain.

### 2.4 Independent semantic hooks

Member-wise scripts instantiate generated branches against concrete bounded
predecessor sets. These hooks are not proofs, but they catch wrong class maps,
window directions, overlap assumptions, and source normalizations before the
data reaches Lean.

## 3. The manual k=2 baseline

The `k=2` development was completed manually before the general generator was
trusted. It contains three tracked classes modulo `9`, source-faithful rows,
concrete lower envelopes, a rational certificate, and the retarded induction.

The regression baseline requires the generator to reproduce:

```text
row25: single retarded branch
row22: two branches plus the parity lift c -> 2c
row28: nested M1V3/M2V3 structure and post-deletion c-prime split
Figure A1: 16 nodes, 15 edges, two deleted nodes
lambda = 27/20
c22 = 73/40
c25 = 1001/1000
c28 = 69/40
exact D1/D2/D3 slacks
```

The baseline is an oracle, never an input source. The generator must derive
the rows from the parametric rules and only then compare its result with the
manual artifacts.

## 4. Regression ladder

The generator was introduced in increasing semantic difficulty.

| Stage | New behavior tested | Result |
|---|---|---|
| row25 | Single-branch derivation and exact window transfer | Diff pass |
| row22 | Detection of an untracked child and parity lift | Diff and member-wise pass |
| row28 | Nested min/sum AST, deletion, c/c-prime splits | Diff pass |
| Figure A1 | Saturation of the parametric deletion rule | Exact 16/15/two-cross match |
| Full k=2 | Rows, tree, constants, slacks, schema twins | Full regression pass |

This ladder distinguishes a rule-derived generator from a baseline re-emitter.
Every stage has its own trace and failure classification.

## 5. Source normalization as proof debt

The most important fidelity incident occurred in the nested row28 formula.
An early project report treated the source arm

```text
phi_2^5(y + 2 alpha - 5)
```

as a likely typo and normalized it to `phi_2^2`. The abstract Lean induction
over that altered row system was valid, but the concrete seam could not realize
the changed branch without circularity.

Four independent checks reversed the normalization:

```text
the TeX formula
the Figure A1 graph
the deletion rule
a member-wise concrete hook
```

The source-faithful `phi_2^5` branch is realized by a simple `4 * node` chain;
the substituted `phi_2^2` branch is not uniform in the repeated class-8 case.
The row contract was migrated from historical V2 to source-faithful V3, its
arithmetic was rechecked, and the concrete seam then closed.

Process rule:

```text
A source normalization is a mathematical claim and carries proof debt.
It must be tested when introduced, not when a downstream seam fails.
```

## 6. Schema evolution

Flat rows fit the initial certificate schema. Row28 forced an explicit v2.1
extension for nested elimination data:

```text
nested min/sum nodes
M1V3/M2V3 references
source-faithful phi25 guardrail
post-deletion edges
Figure A1 node ids and statuses
sibling groups
anti parent-descendant overlap constraints
deletion and termination source references
```

The validation suite preserves backward compatibility with flat v2 artifacts
and rejects malformed nested data. Negative fixtures include a `phi22`
substitution in M1V3, a dangling reference, a cycle, a deleted-but-counted
node, and a parent-descendant sum.

## 7. k=3 pilot

The real pilot runs the parametric source rules at `k=3` before any attempt at
`k=9`.

Measured tree data:

```text
tracked classes                  9
pre-reduction classes           27
EL roots                         3
EL nodes                       247
EL edges                       244
kept terminal literals         116
deleted nodes                   10
maximum expansion depth         10
L3NT rows                        9
generator runtime             about 0.07 s
```

The largest tree has 84 terminal literals, reproducing the source table.

The generator finds the exact rational witness:

```text
lambda = 152759/100000
```

strictly below the source decimal `1.5275960`. Consequently, its generated
exponent

```text
0.6112573808...
```

lies safely below the printed `0.6112620`. The gap is an intentional
one-sided rationalization, not a discrepancy or a claim to certify the source
optimum.

The minimum exact row slack is positive and uses rationals up to 24 numerator
digits and 31 denominator digits.

## 8. Verifier performance

The first verifier searched all 247 nodes for each local lookup and did not
finish within 90 seconds. Replacing repeated scans with root-indexed arrays
and a verified adjacency table reduced the certificate-verifier build to
approximately 14 seconds.

The final verifier checks:

```text
index integrity and complete bidirectional links
depth increments
D1/D2/D3 child shapes and symbolic shifts
minimum-node membership
terminal negativity
deletion ancestry and strict shift comparison
source tree metrics
box constraints
all nine row equations and exact positive slacks
the rational endpoint bound
```

No `sorry`, `admit`, `unsafe`, `native_decide`, or project axiom is used.
The aggregate pilot theorem is intentionally named:

```lean
k3_pilot_certificate_verified : K3PilotCertificateVerified
```

It is not named as a `piStar` lower-bound theorem because the general semantic
bridge has not yet been formalized.

## 9. Scaling gate

Primary-source growth data reports:

| k | Maximum nested depth | Maximum terminal literals |
|---:|---:|---:|
| 2 | 3 | 8 |
| 3 | 10 | 84 |
| 4 | 41 | 12,829 |
| 5 | greater than 226 | greater than 1,000,000,000 |

Explicit EL-tree materialization is therefore rejected long before `k=9`.
This is not merely an implementation failure: KL2003 itself obtains high-`k`
results without printing or materializing billion-node trees. The faithful
route is the abstract splitting/deletion and non-critical-assignment theorem.

Gate decisions:

```text
K3_GENERATOR_VERIFIER_PILOT_PASS
NO_GO_EXPLICIT_EL_ENUMERATION_TO_K9_OR_K11
K9_LNT_CERTIFICATE_PIPELINE_PASS
K9_PISTAR_ARBITRARY_X_THEOREM_PROVED
K11_GATE_NOT_STARTED
```

## 10. General-k work decomposition

The implemented semantic chain was not a single lemma. Its load-bearing
decomposition has the following conceptual modules:

1. General residue indexing, concrete predecessor semantics, and `Phi_k`.
2. Well-founded splitting/deletion termination and semantic preservation.
3. Feasibility transfer from the reduced `L_k^NT` system to the EL system.
4. Generic retarded/non-critical lower-bound induction.
5. Composition to concrete `piStar`, first instantiated at `k=3`.

The `k=3` integration theorem closed first. The flat generator and match-
dispatch checker were then measured on all 6,561 tracked `k=9` classes, and
the resulting certificate was consumed by the same semantic chain to prove
the k=9 arbitrary-`x` theorem. A separate measured gate is required before
starting k=11.

## 11. Reproducibility

Main evidence packages:

```text
docs/KL2003_AUDIT_READY_FIDELITY_PACKAGE_v1.md
docs/KL2003_META_ERRATA_M1_PHI5_REINSTATEMENT_v1.md
docs/KL2003_F2_K2_FULL_GENERATOR_REGRESSION_v1.md
docs/KL2003_F2_K3_GENERATOR_VERIFIER_AND_HIGH_K_GATE_v1.md
outputs/KL2003_F2_K2_FULL_GENERATOR_REGRESSION_v1/
outputs/KL2003_F2_K3_GENERATOR_REAL_v1/
CollatzClassical/KL2003/KL2003K3CertificateVerifier.lean
CollatzClassical/KL2003/KL2003K9CertificateMatchAggregate.lean
CollatzClassical/KL2003/KL2003K9LNTCertificate.lean
CollatzClassical/KL2003/KL2003K9PiStarTheorem.lean
docs/KL2003_K9_PISTAR_THEOREM_LEAN_v1.md
```

Core reproduction commands:

```text
python3 scripts/kl2003_f2_k2_full_generator_regression_v1.py
python3 scripts/kl2003_f2_k3_generator_real_v1.py
lake build CollatzClassical.KL2003.KL2003K3CertificateDataGenerated
lake build CollatzClassical.KL2003.KL2003K3CertificateVerifier
lake env lean CollatzClassical/KL2003/KL2003K3CertificateVerifierAxiomAudit.lean
lake build CollatzClassical.KL2003.KL2003K9PiStarTheorem
lake env lean CollatzClassical/KL2003/KL2003K9PiStarTheoremAxiomAudit.lean
```

## 12. Limitations and no-claims

```text
The proved k=3 and k=9 results are stated only with their exact Lean domains.
The k=9 comparison with Applegate--Lagarias 1995 is an exponent benchmark
comparison; literal statement equivalence and world-first priority are not
claimed.
No k=11 theorem or exponent 0.8417560 is claimed.
No claim is made that k=11 is a mathematical ceiling.
No global Collatz claim is made.
The generator is not trusted; only the properties rechecked in Lean enter the
formal chain.
```

## 13. Conclusion

The central engineering result is not that a large program produced numbers.
It is that source-derived data can be searched by an untrusted generator,
serialized canonically, regressed against a hand-proved instance, and then
rechecked by a small formal consumer with an explicit axiom profile.

The central mathematical lesson is complementary: measured source growth can
show that a tempting finite expansion is not the proof route used at scale.
In this case, the failed extrapolation identifies the abstract general-`k`
semantic theorem as both the source-faithful and computationally viable next
target.

## Draft classification

```text
METHOD_PAPER_INTERNAL_DRAFT_COMPLETE
GENERATOR_VERIFIER_TRUST_BOUNDARY_EXPLICIT
K2_MANUAL_BASELINE_REGRESSION_DOCUMENTED
META_ERRATUM_CASE_STUDY_DOCUMENTED
K3_PILOT_MEASUREMENTS_DOCUMENTED
HIGH_K_ENUMERATION_NO_GO_DOCUMENTED
GENERAL_K_FIVE_MODULE_PLAN_DOCUMENTED
NOT_SUBMITTED
NO_HIGH_K_THEOREM_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
