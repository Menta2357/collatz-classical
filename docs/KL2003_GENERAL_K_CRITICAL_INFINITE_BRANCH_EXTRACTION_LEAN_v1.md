# KL2003 general-k critical infinite branch extraction in Lean

Date: 2026-07-20

## Scope

This module closes the compactness half of Layer C for a never-stopping
critical scheduler. The preceding run module supplies critical-selected
source walks of arbitrarily large finite length. The present module forms the
finite inverse system of exact-depth action-list prefixes and applies Konig's
lemma to obtain one coherent infinite typed `SourceWalk`.

The construction proves:

- every exact prefix depth has a critical-selected representative;
- prefix projections are coherent under `List.take`;
- the resulting packed stream is typed at every adjacent pair;
- every finite prefix of the extracted infinite walk is a prefix of a
  terminal selected by the critical scheduler; and
- every accumulated shift of the extracted branch is nonnegative.

The proof reuses the existing packed-action, source-walk and strict-prefix
infrastructure. The only scheduler-specific input is the unbounded-depth
theorem for critical selections.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKCriticalInfiniteBranchExtraction
lake env lean CollatzClassical/KL2003/KL2003GeneralKCriticalInfiniteBranchExtractionAxiomAudit.lean
```

## Remaining work

Prefix selection and branch nonnegativity do not by themselves provide the
`WitnessFreeAdvancedPrefixRealization` required by the advanced-recurrence
consumer. The next module must identify each advanced arrival in the coherent
branch with a selected D1/D3 child and transfer the one-step witness-free
retention theorem to that prefix. No termination, final `SatisfiesEL`, k=3
`piStar`, k=9 authorization, or global Collatz result is claimed here.

Classifications:

```text
GENERAL_K_CRITICAL_KONIG_EXTRACTION_PROVED
CRITICAL_SELECTED_PREFIX_INVERSE_SYSTEM_PROVED
CRITICAL_INFINITE_TYPED_SOURCE_WALK_EXTRACTED
CRITICAL_EXTRACTED_BRANCH_SHIFTS_NONNEGATIVE
CRITICAL_ADVANCED_PREFIX_REALIZATION_NOT_YET_PROVED
GENERAL_K_EL_CONCLUSION_NOT_PROVED
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_FORMALISATION_NOT_AUTHORIZED
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
