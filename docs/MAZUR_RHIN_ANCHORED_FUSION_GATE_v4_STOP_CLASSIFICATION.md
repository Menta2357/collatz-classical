# Rhin-anchored H1 cold gate v4 — terminal STOP classification

Date: 2026-07-25.

Status:

```text
RHIN_V4_EXECUTED_ONCE
FINAL_VERDICT=RHIN_UNCONDITIONAL_STOP
STOP_CLASS=ENVIRONMENTAL_DISK_EXHAUSTION
THEOREM_NOT_REFUTED
NO_RETRY_V4
NO_RHIN_ANCHORED_THEOREM_CLAIM
```

## Exact execution coordinate

- Frozen execution commit:
  `b6fd47ffe014d9de65d4d2897e0202966e35e9cf`.
- Annotated pre-run tag:
  `rhin-v4-prerun-b6fd47ffe014d9de65d4d2897e0202966e35e9cf`.
- Tag object: `3909124180a931f16e01202926810e56e3a699b8`.
- Reconstruction commit:
  `b7da87864ced8abd6c3715b65320efc233c0d853`.

The public branch, annotated-tag object and peeled target were exact before
the executor acquired its persistent lock.

## Phase ledger

```text
F0_INVOCATIONS=1       PASS, 1.39 s
T0_INVOCATIONS=1       PASS, 8459/8459 cache objects, 222.23 s
D1a_INVOCATIONS=1      PASS, 2962/2962, 407.36 s
D1b_INVOCATIONS=1      STOP, exit 1, 2277.39 s
P1_INVOCATIONS=0       NOT_RUN
A1_INVOCATIONS=0       NOT_RUN
```

Every immediately preceding process audit reported zero matching Lean,
Lake, leanc or Mathlib-cache processes.  The executor stopped at D1b and did
not invoke P1 or A1.

## Classification evidence

The pre-run annotated receipt recorded `42948700` KiB available, exceeding
the contract minimum of `20971520` KiB.  During D1b, the filesystem reached
the full condition.  The immutable D1b log records thirteen occurrences of
`resource exhausted (error code: 28, no space left on device)`, including
failures while creating Lean setup JSON, `.olean` and intermediate build
files.  Lake then exited with `error: build failed`.

The terminal report records:

```text
FUSION_PARAMETRIC_OLEAN=PRESENT_NONEMPTY
RHIN_UNCONDITIONAL_OLEAN=ABSENT
FUSION_RHIN_ANCHORED_OLEAN=ABSENT
```

Accordingly this is an environmental disk-exhaustion STOP, not a Lean
counterexample, elaboration error, failed proof obligation or refutation of
the Rhin-anchored statement.  The v4 minimum-disk guardrail was empirically
insufficient for this cold graph.

## Custody and successor rule

The full generated receipt and phase/process logs live in
`artifacts/mazur-rhin-anchored-ca3/rhin-v4-logs/`.  Their hashes are recorded
inside `RHIN_V4_RUN_REPORT_v1.md`; the D1b log SHA-256 is
`8df110dc4c3d2f77934590b784a8717f70583a745eeb134377617a9c4da30a60`.
The immutable D1b tool output contains trailing whitespace at lines 268, 270,
275 and 277.  `git diff --cached --check` therefore flags those four raw-log
rows.  They are preserved byte-for-byte rather than normalized after the
executor recorded the hash; the classification document and all other staged
files pass the whitespace check when that raw receipt is excluded.

V4 is terminal and must not be retried.  Any successor requires a separately
reviewed v5 contract with a newly measured disk model, a fresh immutable
execution coordinate and explicit treatment of retained cold artifacts.
This classification does not authorize that successor or any cleanup.
