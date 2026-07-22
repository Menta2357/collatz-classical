# Doublet review-reopen manifest v2

Date: `2026-07-22`.

Status: `METHOD_V3_PENDING_HOSTILE_REVIEW`.

This is the corrected custody record after the adversarial review of the
opening doublet. It is based on `origin/master` at `42e866b`, not on the older
F3 branch snapshot.

## Review result

```text
ELIAHOU1993_CC_CHALLENGE_AUDIT_REPORT_DRAFT_v2 = PASS
KL2003_AUDITABLE_GENERATOR_VERIFIER_METHOD_PAPER_DRAFT_v2 = REOPEN_P1
```

The Eliahou document remains publication-ready subject only to the existing
human author-first hold. The method document is superseded by v3 below.

## Corrected pieces

| Piece | Current artifact | Correction |
|---|---|---|
| Eliahou audit | `docs/ELIAHOU1993_CC_CHALLENGE_AUDIT_REPORT_DRAFT_v2.md` | consequence-only scope and human hold unchanged |
| Method paper | `docs/KL2003_AUDITABLE_GENERATOR_VERIFIER_METHOD_PAPER_DRAFT_v3.md` | k=11 theorem and resource asterisk taken from master; unpinned `732 -> 19` anecdote removed |
| Opening history | `docs/DOBLETE_OPENING_MANIFEST_v1.md` | retained as the historical opening snapshot |

Current artifact hashes:

```text
KL2003_AUDITABLE_GENERATOR_VERIFIER_METHOD_PAPER_DRAFT_v3.md
  10530c9496f13866a259cb5c8bf9ae5656f497e3c1ae92e19e126db4aa26eb96
```

## Master-grounded k=11 facts

```text
master commit = 42e866b
theorem = exists_k11_piStar_arbitrary_x_lower_bound
comparison = gammaK11 > 21/25
lambdaR11 = 71689/40000
axiom audits = theorem, certificate, class-roots audits present
controlled checker recovery = 5286.696696 s
maintainability budget = PASS <=1320 s; architecture fail >1800 s
```

The theorem is claimed with its engineering asterisk. The checker result is
not silently converted into a clean-cold benchmark; the custody document
labels it a controlled recovery.

## Hard locks

```text
ELIAHOU_FORUM_POST = NOT_PUBLISHED
ELIAHOU_AUDIT_LINK = NOT_CREATED
METHOD_PAPER = NOT_SUBMITTED
F3_IN_METHOD_PAPER = ONE_FUTURE_WORK_LINE_WITHOUT_NUMBERS
LEAN_BUDGET_F3 = NOT_OPENED
```

Next action is a short hostile re-pass of v3. Only after that may the project
choose a venue or open the separate F3 Lean budget.
