# KL2003 F2 High-k Source Review and Generator Path v1

Date: 2026-07-16

Status: `F2_HIGH_K_SOURCE_REVIEW_STARTED`

## Purpose

This note records the first post-inventory source review for the F2 high-k
feasibility gate.

It corrects one important target-label issue and records the preliminary
architecture consequence: the high-k KL2003 route is a generator/verifier
project, not a manual transcription project.

## Source facts

Primary local source:

```text
/Users/MoiTam/Documents/Codex/2026-07-05/tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/kl2003_src/30apr02.tex
sha256 = 04fa4d484fe89256f6771f5651338891219385f6e049ffaf41035541016232cd
```

Source archive:

```text
/Users/MoiTam/Documents/Codex/2026-07-05/tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/kl2003.tar
size_bytes = 26236
sha256 = c35de018067ae838c17b647f0ce0354141a8bcfaa45b4966be2bb9a380252951
```

Relevant source ranges:

```text
30apr02.tex:309-313   k=9 described as yielding an x^0.81 lower bound in AL95b
30apr02.tex:326-338   KL2003 improves the k=9 line and then uses k=11 for x^0.84
30apr02.tex:1549-1578 table of NT bounds, including k=9 and k=11
```

The table gives:

```text
k=9:  gamma_9  = 0.8168300, lambda_9  = 1.7615320
k=11: gamma_11 = 0.8417560, lambda_11 = 1.7922310
```

## Target correction

The shorthand "k=9 / 0.84" is not source-faithful.

Correct calibration:

```text
k=9  = high-k intermediate station, gamma_9 = 0.8168300
k=11 = source target for the advertised 0.84 line, gamma_11 = 0.8417560
```

The F2 gate therefore tracks both:

- k=9 as the first large-scale high-k feasibility station;
- k=11 as the actual KL2003 `0.84` target.

## Printed-data implication

The local source archive is about 26 KB compressed and contains the TeX plus
figures already custodied.  Together with the source ranges above, this
supports the following preliminary classification:

```text
printed_k9_data      = MISSING_PRINTED_STRUCTURAL
printed_k11_084_data = MISSING_PRINTED_STRUCTURAL
```

Meaning: the paper/source contains the algorithmic framework, a table of
high-k numerical summaries, and the final exponent claims.  It does not contain
the full explicit k=9 or k=11 row/certificate data needed for direct manual
formalization.

This is not a mathematical NO-GO.  It changes the F2 question:

```text
Can we build a source-faithful generator whose output is independently checked?
```

## Generator path

The likely F2 verdict is `CONDITIONAL_GO_M3_WITH_GENERATOR`, not direct GO.

Required architecture:

1. A generator emits high-k data:
   - row system;
   - post-deletion trees/populations;
   - certificate constants;
   - rational slacks;
   - manifests and hashes.
2. A Lean/data verifier checks the emitted data without trusting the generator:
   - well-formed rows;
   - deletion-rule correctness;
   - certificate feasibility;
   - positive slacks;
   - source-indexed manifests.
3. Empirical hooks sample generated row populations member-wise against the
   already validated `piStar` semantics.

The generator may search or construct.  The verifier is the trust boundary.

## Scale metrics

```text
tracked_classes(k) = 3^(k - 1)
k=2  -> 3
k=9  -> 6561     factor from k=2 = 2187
k=11 -> 59049    factor from k=2 = 19683
```

Manual transcription is not plausible at either high-k scale.

## Cheap next experiment

Before committing to k=9 or k=11, run a toy generator/verifier pilot at k=3.

Purpose:

- exercise the generator -> manifest -> verifier architecture;
- measure rational size and slack behavior on a nontrivial but small system;
- determine whether proof checking should be row-by-row `norm_num`, batched
  rational checking, or a verified checker over generated data.

The k=3 pilot is a method test, not a theorem target.

## Open questions after this review

```text
1. Can the paper's general-k algorithm be translated into a generator without
   source ambiguity?
2. Are the k=9/k=11 certificate constants recoverable by recomputing the LP,
   or do they require unavailable historical data?
3. What is the smallest exact rational slack at k=3, then k=9/k=11?
4. What is the Lean kernel cost of checking thousands of generated rows?
5. Is the final public target k=11 directly, or k=9 as an intermediate
   formalized high-k milestone before k=11?
```

## Classification

```text
F2_HIGH_K_SOURCE_REVIEW_STARTED
K9_NOT_084_TARGET_CORRECTED
K11_084_TARGET_RECORDED
PRINTED_K9_DATA_MISSING_STRUCTURAL
PRINTED_K11_084_DATA_MISSING_STRUCTURAL
GENERATOR_VERIFIER_PATH_REQUIRED
K3_GENERATOR_PILOT_RECOMMENDED
NO_K9_THEOREM_CLAIM
NO_084_EXPONENT_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
