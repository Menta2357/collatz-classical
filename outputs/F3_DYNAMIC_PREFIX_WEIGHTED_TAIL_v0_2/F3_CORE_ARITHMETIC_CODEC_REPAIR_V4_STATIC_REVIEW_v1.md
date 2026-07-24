# F3 arithmetic-codec repair v4 static review v1

Status: `STATIC_V4_PREPARATION_PASS / ROUTE_A_ONLY / NOT_EXECUTED`

Date: 2026-07-24.

## Custody and exact diff

The branch forks from the immutable v3 STOP
`4912af1dbe3f3f482d4e41d2887f8e8694d60562`, publicly custodied by PR #6.
No prior report or log is edited.

The complete Lean delta is one insertion in `pilotFrozenPos_agrees`:

```diff
       simp only [pilotFrozenPos, rowStart, fin27To243]
+      split_ifs <;> rfl
```

The residual v3 goal had identical nested `if` conditions on both sides, with
only the coercion of the selected `Fin` value remaining. Explicit case
splitting followed by reflexivity is therefore the narrowest static repair.
This is not a compile claim.

```text
LEAN_FILES_CHANGED = 1
LEAN_PROOF_HUNKS = 1
SOURCE_DIFF = +1/-0
STATEMENTS_CHANGED = 0
DEFINITIONS_CHANGED = 0
DATA_CHANGED = 0
ROUTE_B_DECIDE = DEFERRED_TO_SEPARATE_V5_IF_NEEDED
```

## Hashes and coverage

```text
v4 source = e5683405008b438d8a7c00747e4e81384962d95ced0d759d42c18f05ff62219c
audit = a8e05246e9726afb79c25e206a90f86b12a50a0803251c50cf8b856eae40e0f1
inventory = 611bfc53a028e224c71ceb9287a01dd3587e9300e889c7facbb21fb5183ce74f
checker = 18d2e368b5e73519ec5d701cee59177982bc1f6a750b1b5546d8568866761e9e
```

The unchanged checker returned:

```text
ALL_EXPLICIT_SOURCE_DECLARATIONS=151
EXPLICIT_INVENTORY_DECLARATIONS=151
EXPLICIT_AUDIT_COMMANDS=151
SOURCE_INVENTORY_DIFF=EMPTY
INVENTORY_AUDIT_DIFF=EMPTY
FINAL_PUBLIC_THEOREMS_IN_AUDIT=12_OF_12
FORBIDDEN_SOURCE_SYNTAX=ABSENT
STATIC_EXPLICIT_INVENTORY_CHECK=PASS
```

All four local repair/audit `.olean` and `.ilean` targets were absent. No
Lean, Lake, audit, semantic or extension command was invoked during this
review.

## Decision

The v4 contract permits one 300-second, 200000-heartbeat route-A compile,
followed conditionally by one audit and one total-coverage checker. Any STOP
forbids editing or route-B fallback. Both PASS and STOP must be committed and
pushed to the stacked draft PR.

```text
STATIC_V4_PREPARATION = PASS
LEAN_INVOCATIONS = 0
AUDIT_INVOCATIONS = 0
PUBLIC_TERMINAL_CUSTODY = REQUIRED
NO_243_SOURCE_EXTENSION
NO_SEMANTIC_FIRST_HIT_EXECUTION
```
