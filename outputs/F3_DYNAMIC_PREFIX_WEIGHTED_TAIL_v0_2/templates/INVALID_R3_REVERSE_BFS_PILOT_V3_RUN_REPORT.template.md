# F3 R3 reverse-BFS pilot v3 — INVALID custody report template

Candidate date: 2026-07-26

```text
DOCUMENT_CLASS = ADOPTION_CANDIDATE_BYTES
CANONICAL_TARGET = INVALID_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.template.md
ADOPTION_TRANSACTION_ROLE = POSTIMAGE_CANDIDATE
COORDINATED_FREEZE = REQUIRED_AFTER_7_OF_7_READBACK
EXECUTION_AUTHORITY = NONE
GO_FOR_P0 = NO
INVALID_CUSTODY_REPORT_ONLY
SIX_FIXED_PREDECLARED_ROWS
FINITE_MAXIMUM_SELECTION_CERTIFIED = NO
NO_EXTREMALITY_INFERENCE_FROM_LEGACY_ROW_ID
```

These adoption-candidate bytes target
`INVALID_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.template.md` and acquire
authority only through the coordinated v6/registry-v10 adoption transaction
and freeze. They record only a non-mathematical INVALID event and its
immutable custody. Before that freeze they cannot authorize execution. They
cannot report a valid deficient certificate, a saturation STOP or a six-row
PASS.

## 1. Frozen selection scope

```text
ROW_SELECTION_CLASSIFICATION = SIX_FIXED_PREDECLARED_ROWS
FINITE_MAXIMUM_SELECTION_CERTIFIED = NO
NO_EXTREMALITY_INFERENCE_FROM_LEGACY_ROW_ID
ROW_COUNT = 6
```

| Order | Canonical row ID | Demand | Child | Window | Legacy ID, metadata only |
|---:|---|---:|---:|---:|---|
| 1 | `FIXED_ROW_01_RET_D2` | 2 | 308 | 19712 | `RET_D2_MAX` |
| 2 | `FIXED_ROW_02_RET_D1` | 1 | 152 | 9728 | `RET_D1_CONTROL` |
| 3 | `FIXED_ROW_03_DIRECT_D2` | 2 | 107 | 41088 | `DIRECT_D2_MAX` |
| 4 | `FIXED_ROW_04_DIRECT_D1` | 1 | 155 | 59520 | `DIRECT_D1_CONTROL` |
| 5 | `FIXED_ROW_05_LIFT_D2` | 2 | 182 | 34944 | `LIFT_D2_MAX` |
| 6 | `FIXED_ROW_06_LIFT_D1` | 1 | 902 | 173184 | `LIFT_D1_CONTROL` |

The legacy strings prove no maximality, control property, extremality or
representativeness.

## 2. Sole legal classification

```text
REPORT_KIND = INVALID_CUSTODY
MACHINE_VERDICT = INVALID_R3_REVERSE_BFS_PILOT_V3
CLASSIFICATION = NON_MATHEMATICAL_INVALID
MATHEMATICAL_VERDICT_REACHED = NO
NORMAL_EXECUTION_RESUMABLE = NO
ONLY_PERMITTED_SUCCESSOR = C0_CUSTODY_ONCE
```

This report is legal only for the first non-mathematical failure of the
predeclared phase machine. A kernel-accepted deficient certificate after a
complete valid chain is not INVALID and must use the normal report's
`ANY_DEFICIENT_SCOPED_STOP` branch.

## 3. Exact first INVALID event

```text
GIT_HEAD = {{GIT_HEAD}}
GIT_BRANCH = {{GIT_BRANCH}}
WORKTREE = {{WORKTREE}}
CONTRACT_V6_SHA256 = {{CONTRACT_V6_SHA256}}
REGISTRY_V10_SHA256 = {{REGISTRY_V10_SHA256}}
FIRST_FAILED_PHASE = {{FIRST_FAILED_PHASE}}
INVALID_PREDICATE = {{INVALID_PREDICATE}}
TERMINAL_EXIT_STATUS = {{TERMINAL_EXIT_STATUS}}
EVENT_TIMESTAMP = {{EVENT_TIMESTAMP}}
```

`INVALID_PREDICATE` must identify an evidenced non-mathematical cause, for
example source/object/receipt drift, missing or malformed manifest, forbidden
phase transition, environment mismatch, timeout, resource or memory-policy
violation, generator/materializer failure, checker rejection, incomplete or
malformed certificate, verifier failure, audit failure, forbidden axiom,
missing audit coverage, or final read-back/custody failure. It must not be a
cardinal shortfall proved by a valid deficient certificate.

## 4. Phase state at the first failure

The phase chain is fixed:

```text
B0 -> R0 -> P0 -> G01 -> G02 -> G03 -> G04 -> G05 -> G06
   -> S0 -> P1 -> V0 -> A0 -> F0
```

| Phase | State at failure | Receipt SHA-256 or exact absence marker |
|---|---|---|
| `B0` | {{B0_STATE}} | {{B0_RECEIPT_OR_ABSENCE}} |
| `R0` | {{R0_STATE}} | {{R0_RECEIPT_OR_ABSENCE}} |
| `P0` | {{P0_STATE}} | {{P0_RECEIPT_OR_ABSENCE}} |
| `G01` | {{G01_STATE}} | {{G01_RECEIPT_OR_ABSENCE}} |
| `G02` | {{G02_STATE}} | {{G02_RECEIPT_OR_ABSENCE}} |
| `G03` | {{G03_STATE}} | {{G03_RECEIPT_OR_ABSENCE}} |
| `G04` | {{G04_STATE}} | {{G04_RECEIPT_OR_ABSENCE}} |
| `G05` | {{G05_STATE}} | {{G05_RECEIPT_OR_ABSENCE}} |
| `G06` | {{G06_STATE}} | {{G06_RECEIPT_OR_ABSENCE}} |
| `S0` | {{S0_STATE}} | {{S0_RECEIPT_OR_ABSENCE}} |
| `P1` | {{P1_STATE}} | {{P1_RECEIPT_OR_ABSENCE}} |
| `V0` | {{V0_STATE}} | {{V0_RECEIPT_OR_ABSENCE}} |
| `A0` | {{A0_STATE}} | {{A0_RECEIPT_OR_ABSENCE}} |
| `F0` | {{F0_STATE}} | {{F0_RECEIPT_OR_ABSENCE}} |

Every unstarted phase must be listed as `NEVER_STARTED_AFTER_INVALID`.
Every output that could not yet exist must be recorded as
`NOT_CREATED_BEFORE_INVALID`; no absent artifact, receipt or manifest may be
fabricated. A completed earlier output may be read and hashed but not
rewritten.

## 5. C0 custody-only record

```text
C0_INVOKED = {{C0_INVOKED}}
C0_ATTEMPT_COUNT = {{C0_ATTEMPT_COUNT}}
C0_LEAN_INVOCATION = NONE
C0_REVERSE_SEARCH = NONE
C0_GENERATION = NONE
INVALID_CUSTODY_MANIFEST_SHA256 = {{INVALID_CUSTODY_MANIFEST_SHA256}}
C0_TERMINAL_STATUS = {{C0_TERMINAL_STATUS}}
UNRESOLVED_PLACEHOLDERS = 0
```

`C0_ATTEMPT_COUNT` must be `0` exactly when `C0_INVOKED=NO`, and `1` exactly
when `C0_INVOKED=YES`; values greater than one are forbidden.

The custody manifest must record and hash, when present:

- contracts v1--v6, registry v10, both adopted templates and the declared Git
  state;
- every completed phase receipt and every file named by it;
- the first failed phase, exact INVALID predicate and terminal status;
- raw stdout/stderr, memory tables, objects, generated fragments, payload and
  manifests that existed at the stop point; and
- the explicit list of phases never started.

If C0 itself fails or drifts, the classification remains
`NON_MATHEMATICAL_INVALID`; partial raw custody is retained, and no retry,
normal phase, verification, audit, generation or reverse search is thereby
authorized.

## 6. Prohibited interpretations

```text
NO_SATURATION_STOP_FROM_INVALID
NO_CAPACITY_COUNTEREXAMPLE_FROM_INVALID
NO_F3_STOP_FROM_INVALID
NO_PASS_FROM_INVALID
NO_RETRY_OR_RESUME_AUTHORITY
```

An INVALID report provides no mathematical evidence about saturation,
deficiency, the reverse-BFS architecture, the six owners or any other owner.

## 7. Mandatory no-claims

```text
NO_FULL_BLOCK0_CAPACITY_CLAIM
NO_RESIDUAL_D2_CLAIM
NO_452_OWNER_CLAIM
NO_1620_OWNER_CLAIM
NO_RHO_CERTIFICATE
NO_RHO_2_PROGRESS_CLAIM
NO_F3_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
```

No non-mathematical INVALID event proves or refutes `rho = 9/5`, an exponent,
positive density, an almost-all statement or the Collatz conjecture.
