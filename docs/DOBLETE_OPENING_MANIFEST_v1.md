# Doublet opening manifest v1

Date: `2026-07-22`.

Status: `DOUBLET_DRAFTS_READY_DRAFT_PENDING_HOSTILE_REVIEW`.

The doublet is opened in the order agreed by governance: the house first,
then the dragon's Lean budget. This manifest records the two writing objects;
it does not publish either object.

## Pieces

| Piece | Artifact | Scope | Status |
|---|---|---|---|
| 1 | `docs/ELIAHOU1993_CC_CHALLENGE_AUDIT_REPORT_DRAFT_v2.md` | consequence-only Eliahou audit; exact-period and `hk` gaps visible; author-first hold preserved | `DRAFT_PENDING_HOSTILE_REVIEW` |
| 2 | `docs/KL2003_AUDITABLE_GENERATOR_VERIFIER_METHOD_PAPER_DRAFT_v2.md` | ITP/CPP/CICM method paper; ladder, trust architecture, erratum, dispatch, and k=11 timebox | `DRAFT_PENDING_HOSTILE_REVIEW` |

Draft hashes at opening:

```text
ELIAHOU1993_CC_CHALLENGE_AUDIT_REPORT_DRAFT_v2.md
  74d3ed3b144d45db2afc51d4254b298a2a77e20fd9a1194ee6b04fcde6d5225e
KL2003_AUDITABLE_GENERATOR_VERIFIER_METHOD_PAPER_DRAFT_v2.md
  2479e11b663acfc45841bb8749c9247652a469f8a82499dcf9f8a52c812bd1ff
```

## Hard governance locks

```text
ELIAHOU_PUBLICATION = HOLD_FOR_HUMAN_OR_UPSTREAM_RESPONSE
ELIAHOU_FORUM_POST = NOT_PUBLISHED
ELIAHOU_AUDIT_LINK = NOT_CREATED
METHOD_PAPER = NOT_SUBMITTED
F3_IN_METHOD_PAPER = ONE_FUTURE_WORK_LINE_WITHOUT_NUMBERS
LEAN_BUDGET = NOT_OPENED
```

The Eliahou hold exits only on an upstream response or explicit user
instruction. The method paper's reported `732 s -> 19 s` dispatch figure is
marked `PENDING_POINTER`; it is not silently promoted to an evidentiary claim.

## Hostile-review order

1. Check every sentence against a commit, audit, hook, output, or explicit
   negative finding.
2. Check that partial formalization is not described as the full Eliahou
   theorem.
3. Check the ladder's four waypoints and the k=11 non-claim.
4. Check that F3 appears once, without numbers, and without changing its
   separate gate.
5. Check the author-first hold and the unpinned dispatch measurement.

Only after this review may the project decide whether to open the Lean M0
budget. That decision is outside this manifest.

## Custody

```text
repository: https://github.com/Menta2357/collatz-classical
branch: codex/f3-density-capture-gate
```
