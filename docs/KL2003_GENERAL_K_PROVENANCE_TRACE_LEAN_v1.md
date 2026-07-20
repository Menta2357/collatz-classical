# KL2003 general-k provenance trace Lean v1

## Result

`KL2003GeneralKProvenanceTrace.lean` identifies the raw EL deletion context
with the typed source genealogy carried by the provenanced scheduler.

The module defines the strict-prefix label trace of a packed `SourceWalk` and
the recursive invariant `TraceConsistentFrom`. It proves that:

- extending a provenanced node appends exactly the parent EL label;
- source splits and every min-three retention preserve the trace;
- terminal replacement, `sourceStep`, the deterministic scheduler and every
  finite run preserve the trace;
- on a canonical run, `context.expandedLabels` is exactly the list of strict
  typed-source prefixes; and
- a deletion witness is exactly an earlier same-mode prefix with smaller
  shift. Consequently, a nonnegative retained terminal without a witness is
  no higher than every earlier occurrence of its mode.

This closes the traffic seam between syntactic deletion witnesses and actual
typed source walks. It does not prove that every retained advanced branch is
witness-free: the all-three-witness retention case remains the exact blocker.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKProvenanceTrace
lake env lean CollatzClassical/KL2003/KL2003GeneralKProvenanceTraceAxiomAudit.lean
```

## Classification

```text
PROVENANCE_PREFIX_LABEL_TRACE_DEFINED
TRACE_CONSISTENCY_PRESERVED_BY_SOURCE_SCHEDULER
RAW_DELETION_CONTEXT_EQUALS_TYPED_SOURCE_PREFIXES
DELETION_WITNESS_TRANSLATED_TO_SOURCE_GENEALOGY
WITNESS_FREE_TERMINAL_SHIFT_MONOTONICITY_PROVED
TRIPLE_WITNESS_EXCLUSION_STILL_OPEN
NO_K3_PISTAR_THEOREM_YET
NO_K9_FORMALIZATION
NO_GLOBAL_COLLATZ_CLAIM
```
