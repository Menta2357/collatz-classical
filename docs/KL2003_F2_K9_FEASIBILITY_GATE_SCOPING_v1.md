# KL2003 F2 k=9 Feasibility Gate Scoping v1

Date: 2026-07-16

Status: `F2_K9_FEASIBILITY_GATE_OPENED`

## Purpose

This note opens the post-k=2 feasibility gate for deciding whether the next
mathematical target should be a high-k KL2003 formalization, or a
consolidation/writing phase around the completed k=2 surrogate.

Source clarification from `30apr02.tex`: k=9 is an intermediate high-k station
with `gamma_9 = 0.8168300`; the advertised `0.84` exponent comes from the k=11
computation, with `gamma_11 = 0.8417560`.  F2 therefore tracks both k=9 and
k=11: k=9 as the first large-scale feasibility target, and k=11 as the actual
KL2003 `0.84` target.

The gate is intentionally data-first. It does not claim a k=9 theorem, does not
start a k=9 Lean proof, and does not change any global Collatz status.

The question is:

```text
Can the high-k KL2003 certificate and row systems, especially k=9 and the k=11
`0.84` target, be reconstructed, audited, and formalized with manageable source
fidelity, arithmetic size, and Lean engineering cost?
```

## Current baseline

The k=2 line is complete enough to serve as the model case.

Closed baseline:

- `kl2003_k2_m1_surrogate_ceil_window_lower_bound`
- `kl2003_k2_m1_surrogate_arbitrary_x_lower_bound`
- `kl2003_k2_m1_surrogate_root8_lower_bound`
- `gammaK2_gt_three_sevenths`
- `concretePhi_retarded_lower_bound`
- `concretePhi_rowsV3`
- M0A/M0B/M0C/M0D infrastructure up to the k=2 concrete surrogate

Audit posture:

- Lean builds and axiom audits pass for the k=2 surrogate modules.
- The public root-8 statement is arbitrary-x above the threshold `2^17`.
- The current no-claims remain: no full M1 theorem, no high-k theorem
  (`k=9`/`gamma_9 = 0.8168300` or `k=11`/`0.84`), no small-x theorem below
  stated thresholds, and no global Collatz claim.

## Why F2 is needed

k=9 would change the category of the result: from a k=2 M1-surrogate
formalization to a large-scale KL2003 exponent line.  k=11 is the target that
corresponds to the paper's `0.84` claim.

It would not change the global Collatz problem. It would formalize a known
published theorem, not prove a new mathematical fact. Its value is nevertheless
high: it would likely be the flagship formalization in this repository and a
natural continuation of the completed k=2 architecture.

The decision should be made by evidence, not momentum.

## F2 deliverables

### 1. Source inventory

Identify and custody the exact source material needed for the high-k path:

- KL2003 tables relevant to the k=9 and k=11 systems.
- Certificate weights/endpoints/slacks.
- Reduced residue classes and elimination rules.
- Tree/literal figures if the k=9 system uses deletion or graphical row data.
- Any TeX, figure overlays, CSVs, or reconstruction reports needed to make the
  Lean statements source-faithful.

Expected output:

```text
outputs/KL2003_F2_K9_FEASIBILITY_GATE_v1/source_inventory.json
outputs/KL2003_F2_K9_FEASIBILITY_GATE_v1/source_inventory.csv
docs/KL2003_F2_K9_SOURCE_INVENTORY_v1.md
```

The inventory is not an open-ended grep. It must answer the fixed checklist
below, because these are the items that decide whether high-k KL2003 is a
formalization track or a generator/reconstruction project.

### 1A. Fixed source checklist

Each item must be represented in the JSON/CSV output with:

```text
item_id
description
expected_evidence
status
source_paths
line_ranges_or_record_ids
sha256
notes
```

Required checklist:

1. General-k system definition for `I_k`/EL.
   Evidence: TeX ranges defining the splitting and deletion rules
   parametrically, not only the k=2 instance.
2. Printed k=9/k=11 row system or certificate.
   Evidence: explicit paper/source tables for k=9 or k=11 rows, weights, endpoints,
   or certificate data. If the paper contains only the algorithm and final
   result, mark this `MISSING` rather than inferring it.
3. Table of exponents `gamma(k)`.
   Evidence: printed or source-derived values for intermediate k, especially
   k=3 through k=11, to identify possible intermediate targets between the
   completed k=2 surrogate, k=9, and k=11.
4. k=9/k=11 lambda/endpoint precision.
   Evidence: the exact or approximate values that would play the role of
   `lambdaR`, together with enough precision to reconstruct rational intervals
   and slacks.
5. k=9/k=11 deletion/tree source material.
   Evidence: figure overlays, graphical source, TeX tables, or algorithmic
   descriptions sufficient to reconstruct member-wise populations without
   inventing them.
6. Existing reusable Lean assets.
   Evidence: a hand-maintained table, not just grep output, classifying which
   k=2 modules are genuinely generic.
7. k=2-cabled assets that must be replaced.
   Evidence: a hand-maintained table marking files/declarations tied to mod 9,
   the k=2 certificate, k=2 row labels, or k=2-specific case trees.

### 2. Dimension and complexity count

Measure the actual size of the high-k task:

- number of tracked classes after reductions;
- number of row inequalities;
- number of min/max auxiliary terms;
- number of literal/tree populations;
- maximum elimination depth;
- number of certificate constants;
- expected number of generated Lean declarations;
- expected row proof families versus genuinely exceptional rows.

The key question is whether high-k KL2003 looks like "k=2 scaled by a
generator" or a new manual proof project.

The first scale metric is known before source extraction:

```text
tracked_classes(k) = 3^(k - 1)
tracked_classes(2) = 3
tracked_classes(9) = 6561
tracked_classes(11) = 59049
scale_factor_from_k2_to_k9 = 2187
scale_factor_from_k2_to_k11 = 19683
```

This metric does not decide feasibility by itself, but it rules out any plan
that relies on hand-writing the k=9 or k=11 row system. F2 should therefore
treat the generator question as central:

```text
Can the high-k row/certificate data be generated in a way that is
source-faithful, manifested, and independently verified by Lean/data-only
checkers?
```

### 3. Rational certificate audit

Before any Lean proof attempt, reconstruct the certificate in exact arithmetic.

Measurements:

- numerator/denominator bit lengths;
- smallest slack;
- rows with near-zero margin;
- whether the verifier can be data-only and `norm_num`/kernel-rational;
- whether interval endpoints match the current alpha/lambda infrastructure.

The k=2 project caught several mixed-generation constants. F2 should assume
the same class of bug is possible at k=9 and audit for it deliberately.

### 4. Architecture reuse audit

Classify what generalizes directly from k=2 and what does not.

Expected direct reuse:

- `piStar` semantics and root-count lemmas;
- Bool/Prop reachability bridge;
- entry-predecessor fiber disjointness;
- finite row/core injection pattern;
- certificate verifier style;
- alpha/lambda/rpow/log toolkit;
- retarded-rank induction shape;
- concrete-phi/envelope pattern;
- arbitrary-x translation via `logb`.

Expected non-automatic work:

- k=9 row system extraction;
- k=9 deletion/elimination rules;
- k=9 row tree/literal materialization;
- k=9 certificate constants and slacks;
- base segment and rounding/pad ledger;
- code generation or proof generation if the row count is too large.

### 5. Empirical hooks

Every source-normalization step should get a hook before Lean.

Required hooks:

- row/member-wise validation for extracted k=9 row chains;
- exact rational certificate verifier outside Lean;
- source-vs-normalized statement diff;
- finite-grid sanity checks for the translated row inequalities;
- manifest hashes for generated CSV/JSON outputs.

Process rule inherited from the k=2 meta-errata:

```text
Every source normalization is a mathematical assertion. It must be validated
when introduced, not months later during the seam.
```

## GO / NO-GO criteria

### `GO_M3_K9`

Open the k=9 formalization track if all of the following hold:

- sources for the k=9 rows and certificate are complete enough to audit;
- constants can be represented as exact rational data;
- slacks are positive with no unexplained near-zero rows;
- row/literal population count is manageable manually or by generator;
- deletion/elimination rules are source-faithful and empirically validated;
- expected Lean build cost is plausible based on k=2 scaling;
- no hidden dependency requires a new mathematical theorem outside KL2003.

### `CONDITIONAL_GO_M3_WITH_GENERATOR`

Proceed only after building a generator if:

- the mathematics is source-complete and audited;
- the row count is too large for manual Lean;
- the proof families are regular enough for generated declarations;
- generated output can be audited by manifests and source references.

### `NO_GO_M3_CONSOLIDATE`

Do not open k=9 if:

- source material is missing or ambiguous in a way that changes the theorem;
- the certificate exists only in floating form with no reliable rationalization;
- deletion/tree rules cannot be reconstructed source-faithfully;
- the smallest slacks are too fine for the rounding ledger without new ideas;
- Lean proof size requires an automation project disproportionate to the value;
- F2 reveals that the right next paper is consolidation rather than escalation.

## Suggested first task

Create the inventory script:

```text
scripts/kl2003_f2_k9_feasibility_inventory_v1.py
```

It should scan the local KL2003 source custody, existing docs, and output
directories for k=9-relevant data; produce a JSON/CSV inventory for the fixed
and k=11-relevant data; produce a JSON/CSV inventory for the fixed checklist;
compute the scale metrics; and explicitly mark every required source item as:

```text
FOUND_SOURCE
FOUND_DERIVED
MISSING
AMBIGUOUS
NOT_NEEDED
```

The script should not infer theorem content. It should inventory evidence,
compute simple dimensions, and leave human-curated fields blank or marked
`REQUIRES_HUMAN_REVIEW` when a grep cannot decide them.

The initial JSON should include at least:

```text
{
  "run_id": "KL2003_F2_K9_FEASIBILITY_GATE_v1",
  "tracked_classes": {
    "k2": 3,
    "k9": 6561,
    "k11": 59049,
    "scale_factor_k9_from_k2": 2187,
    "scale_factor_k11_from_k2": 19683
  },
  "checklist": [...],
  "candidate_sources": [...],
  "reusable_assets": [...],
  "k2_cabled_assets": [...],
  "open_questions": [...]
}
```

The scoping document and the inventory script should be committed together, so
inventory outputs can cite a custodied gate definition.

## Guardrails

- No k=9 theorem claim.
- No 0.84 theorem claim.
- No full M1 theorem claim from the k=2 surrogate.
- No global Collatz claim.
- No Lean high-k module until F2 produces a GO/CONDITIONAL_GO.
- No generated proof data without source manifests.

## Classification

```text
F2_K9_FEASIBILITY_GATE_OPENED
K2_BASELINE_COMPLETE_AND_AUDIT_READY
K9_SOURCE_INVENTORY_REQUIRED
K9_CERTIFICATE_SIZE_UNKNOWN
K9_ROW_SYSTEM_DIMENSION_UNKNOWN
K9_GENERATOR_NEED_UNKNOWN
K9_TRACKED_CLASS_SCALE_6561_RECORDED
K11_TARGET_FOR_084_RECORDED
K11_TRACKED_CLASS_SCALE_59049_RECORDED
K9_MANUAL_TRANSCRIPTION_NOT_PLAUSIBLE
NO_K9_THEOREM_CLAIM
NO_084_EXPONENT_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
