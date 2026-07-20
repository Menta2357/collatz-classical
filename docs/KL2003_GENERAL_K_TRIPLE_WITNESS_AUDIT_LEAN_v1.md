# KL2003 general-k triple-witness audit Lean v1

Date: 2026-07-20

## Result

`KL2003GeneralKTripleWitnessAudit.lean` proves that the following local
ingredients do not exclude three simultaneous deletion witnesses:

- a source-typed walk at `k = 5`;
- thirteen valid D1/D3/retarded transitions;
- nonnegative evaluated shifts at every strict prefix; and
- a final D1 split whose three lifted children are valid tracked modes.

The walk is

```text
107 -> 152 -> 182 -> 161 -> 26 -> 179 -> 38 -> 152
    -> 182 -> 161 -> 188 -> 206 -> 137 -> 20.
```

Its final label is `(20, 12*alpha-17)`. Splitting that D1 node creates modes
`26`, `107`, and `188` at common shift `13*alpha-19`. The earlier labels

```text
(26, 4*alpha-5), (107, 0), (188, 9*alpha-13)
```

have the same respective modes and strictly smaller shifts. Lean therefore
proves `HasDeletionWitness` for all three children.

The ancestor list is not handwritten evidence: Lean computes it as
`packedPrefixLabels` of the typed `SourceWalk`, followed by its final label,
and proves that this computed trace equals the displayed fourteen labels.

## Source boundary

The primary source is `30apr02.tex`, SHA256
`04fa4d484fe89256f6771f5651338891219385f6e049ffaf41035541016232cd`.
Lines 763-777 define splitting and deletion. Lines 782-784 state that all
three new leaves cannot be removed. Lines 963-1010 justify removed vertices
through positive monotone functions, critical assignments, and the analogue
of equation (305).

Accordingly, this audit does **not** claim:

- that the candidate is reachable in the complete deterministic scheduler;
- that KL2003 Theorem 3.1 is false;
- that an empty minimum should be introduced; or
- that the semantic critical-assignment argument has been refuted.

It proves the narrower and operationally decisive fact that source typing,
local genealogy and prefix nonnegativity alone cannot discharge the
triple-witness case. The next termination module must use the source semantic
critical-assignment invariant, or establish an equivalent global scheduler
invariant, to recover the no-triple-deletion property.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKTripleWitnessAudit
lake env lean CollatzClassical/KL2003/KL2003GeneralKTripleWitnessAuditAxiomAudit.lean
git diff --check
```

## Classification

```text
K5_TYPED_SOURCE_TRIPLE_WITNESS_CANDIDATE_PROVED
K5_CANDIDATE_PREFIX_TRACE_COMPUTED
K5_CANDIDATE_PREFIX_NONNEGATIVITY_PROVED
ALL_THREE_D1_CHILDREN_HAVE_SYNTACTIC_WITNESSES
LOCAL_TRIPLE_WITNESS_EXCLUSION_REFUTED
SCHEDULER_REACHABILITY_NOT_PROVED
KL2003_THEOREM31_NOT_REFUTED
SEMANTIC_CRITICAL_ASSIGNMENT_INVARIANT_REQUIRED
EL_TERMINATION_NOT_YET_PROVED
NO_K3_PISTAR_THEOREM_CLAIM
NO_K9_FORMALISATION_AUTHORIZATION
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
