# F3 R3 reverse-BFS pilot v3 — normal terminal report template

Candidate date: 2026-07-26

```text
DOCUMENT_CLASS = ADOPTION_CANDIDATE_BYTES
CANONICAL_TARGET = F3_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.template.md
ADOPTION_TRANSACTION_ROLE = POSTIMAGE_CANDIDATE
COORDINATED_FREEZE = REQUIRED_AFTER_7_OF_7_READBACK
EXECUTION_AUTHORITY = NONE
GO_FOR_P0 = NO
NORMAL_TERMINAL_REPORT_ONLY
SIX_FIXED_PREDECLARED_ROWS
FINITE_MAXIMUM_SELECTION_CERTIFIED = NO
NO_EXTREMALITY_INFERENCE_FROM_LEGACY_ROW_ID
```

These adoption-candidate bytes target
`F3_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.template.md` and acquire authority
only through the coordinated v6/registry-v10 adoption transaction and freeze.
They record exactly the two legal mathematical branches of a completely valid
normal run. Before that freeze they cannot authorize execution. They must
never be used to report an environmental, custody, checker, timeout, resource
or audit failure; those belong exclusively to the INVALID report template.

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

The legacy strings do not prove maximum, nearest control, worst case or
representativeness. This report is scoped to the six rows above and to no
other owner.

## 2. Frozen provenance and custody header

The materialized report must replace every double-braced field with the exact
value sealed by the run. No field may be inferred from an unpinned “current”
file, a glob or a later reconstruction.

```text
REPORT_KIND = NORMAL_TERMINAL
GIT_HEAD = {{GIT_HEAD}}
GIT_BRANCH = {{GIT_BRANCH}}
WORKTREE = {{WORKTREE}}
CONTRACT_V6_PATH = {{CONTRACT_V6_PATH}}
CONTRACT_V6_SHA256 = {{CONTRACT_V6_SHA256}}
CONTRACT_V6_LINES = {{CONTRACT_V6_LINES}}
REGISTRY_V10_PATH = {{REGISTRY_V10_PATH}}
REGISTRY_V10_SHA256 = {{REGISTRY_V10_SHA256}}
REGISTRY_V10_LINES = {{REGISTRY_V10_LINES}}
PRE_GENERATION_MANIFEST_SHA256 = {{PRE_GENERATION_MANIFEST_SHA256}}
POST_GENERATION_MANIFEST_SHA256 = {{POST_GENERATION_MANIFEST_SHA256}}
FINAL_ARTIFACTS_SHA256 = {{FINAL_ARTIFACTS_SHA256}}
FINAL_READBACK = PASS
```

The full v1--v6 contract chain, registry v10, both adopted templates, all
seven frozen pilot inputs, fresh prerequisite sources/audits/objects, loaded
object traces, commands, tools, environment and Git base must be reachable
from the two manifests and terminal receipt chain.

## 3. Complete normal phase chain

Every row below must be `PASS`, have an exact receipt SHA-256 and have passed
the required pre/post revalidation. A missing or invalid row makes this
normal report illegal and requires the INVALID template instead.

| Phase | Status | Terminal receipt SHA-256 | Pre/post chain revalidation |
|---|---|---|---|
| `B0` | {{B0_STATUS}} | `{{B0_RECEIPT_SHA256}}` | {{B0_REVALIDATION}} |
| `R0` | {{R0_STATUS}} | `{{R0_RECEIPT_SHA256}}` | {{R0_REVALIDATION}} |
| `P0` | {{P0_STATUS}} | `{{P0_RECEIPT_SHA256}}` | {{P0_REVALIDATION}} |
| `G01` | {{G01_STATUS}} | `{{G01_RECEIPT_SHA256}}` | {{G01_REVALIDATION}} |
| `G02` | {{G02_STATUS}} | `{{G02_RECEIPT_SHA256}}` | {{G02_REVALIDATION}} |
| `G03` | {{G03_STATUS}} | `{{G03_RECEIPT_SHA256}}` | {{G03_REVALIDATION}} |
| `G04` | {{G04_STATUS}} | `{{G04_RECEIPT_SHA256}}` | {{G04_REVALIDATION}} |
| `G05` | {{G05_STATUS}} | `{{G05_RECEIPT_SHA256}}` | {{G05_REVALIDATION}} |
| `G06` | {{G06_STATUS}} | `{{G06_RECEIPT_SHA256}}` | {{G06_REVALIDATION}} |
| `S0` | {{S0_STATUS}} | `{{S0_RECEIPT_SHA256}}` | {{S0_REVALIDATION}} |
| `P1` | {{P1_STATUS}} | `{{P1_RECEIPT_SHA256}}` | {{P1_REVALIDATION}} |
| `V0` | {{V0_STATUS}} | `{{V0_RECEIPT_SHA256}}` | {{V0_REVALIDATION}} |
| `A0` | {{A0_STATUS}} | `{{A0_RECEIPT_SHA256}}` | {{A0_REVALIDATION}} |
| `F0` | {{F0_STATUS}} | `{{F0_RECEIPT_SHA256}}` | {{F0_REVALIDATION}} |

```text
NORMAL_PHASE_COUNT = 14
ALL_NORMAL_PHASES_COMPLETED_ONCE = {{ALL_NORMAL_PHASES_COMPLETED_ONCE}}
ALL_HASH_AND_MANIFEST_REVALIDATIONS = {{ALL_HASH_AND_MANIFEST_REVALIDATIONS}}
MEMORY_POLICY_VALID = {{MEMORY_POLICY_VALID}}
VERIFIER_COVERAGE_VALID = {{VERIFIER_COVERAGE_VALID}}
AXIOM_AUDIT_COVERAGE_VALID = {{AXIOM_AUDIT_COVERAGE_VALID}}
UNRESOLVED_PLACEHOLDERS = 0
```

## 4. Six checker-accepted row outcomes

For every row, `KIND` is exactly `SATURATED` or `DEFICIENT`; `m(p)` is the
audited cardinality of `orderedFirstHitFiber0 p`; and `D(p)` is the frozen
`massDemand p`. A deficient row must retain its exact fiber/cardinality and
shortfall proof. It is valid mathematical evidence, not an INVALID event.

| Row | `D(p)` | Kind | Typed checker | `m(p)` | Capacity/shortfall theorem | Certificate SHA-256 |
|---|---:|---|---|---:|---|---|
| `FIXED_ROW_01_RET_D2` | 2 | {{ROW01_KIND}} | {{ROW01_CHECK}} | {{ROW01_M}} | {{ROW01_THEOREM}} | `{{ROW01_CERT_SHA256}}` |
| `FIXED_ROW_02_RET_D1` | 1 | {{ROW02_KIND}} | {{ROW02_CHECK}} | {{ROW02_M}} | {{ROW02_THEOREM}} | `{{ROW02_CERT_SHA256}}` |
| `FIXED_ROW_03_DIRECT_D2` | 2 | {{ROW03_KIND}} | {{ROW03_CHECK}} | {{ROW03_M}} | {{ROW03_THEOREM}} | `{{ROW03_CERT_SHA256}}` |
| `FIXED_ROW_04_DIRECT_D1` | 1 | {{ROW04_KIND}} | {{ROW04_CHECK}} | {{ROW04_M}} | {{ROW04_THEOREM}} | `{{ROW04_CERT_SHA256}}` |
| `FIXED_ROW_05_LIFT_D2` | 2 | {{ROW05_KIND}} | {{ROW05_CHECK}} | {{ROW05_M}} | {{ROW05_THEOREM}} | `{{ROW05_CERT_SHA256}}` |
| `FIXED_ROW_06_LIFT_D1` | 1 | {{ROW06_KIND}} | {{ROW06_CHECK}} | {{ROW06_M}} | {{ROW06_THEOREM}} | `{{ROW06_CERT_SHA256}}` |

## 5. Select exactly one legal terminal branch

The materializer must include exactly one of Sections 5A and 5B in the final
normal report and delete the other. It may not synthesize a third branch.

```text
UNSELECTED_TERMINAL_SECTION_PRESENT = NO
```

### 5A. ALL SIX SATURATED PASS

This branch is legal iff the complete custody/audit chain is valid and all
six typed checkers accept saturated certificates proving `D(p) <= m(p)`.

```text
TERMINAL_BRANCH = ALL_SIX_SATURATED_PASS
MACHINE_VERDICT = PASS_R3_REVERSE_BFS_PILOT_V3_6_OF_6
SCOPED_CLASSIFICATION = SIX_OWNER_SATURATION_PASS
SATURATED_ROWS = 6
DEFICIENT_ROWS = 0
```

It proves only the six selected owner inequalities.

### 5B. ANY DEFICIENT — scoped saturation STOP

This branch is legal iff the complete custody/audit chain is valid and at
least one typed checker accepts a deficient certificate whose audited
completeness result proves `m(p) < D(p)`.

```text
TERMINAL_BRANCH = ANY_DEFICIENT_SCOPED_STOP
MACHINE_VERDICT = STOP_R3_REVERSE_CAPACITY_COUNTEREXAMPLE_V3
SCOPED_CLASSIFICATION_1 = SIX_ROW_SATURATION_STOP
SCOPED_CLASSIFICATION_2 = FULL_CAPACITY_SUBROUTE_STOP
SCOPED_CLASSIFICATION_3 = NO_F3_STOP
SATURATED_ROWS = {{SATURATED_ROWS}}
DEFICIENT_ROWS = {{DEFICIENT_ROWS}}
```

For each deficient row, custody must record the retained and omitted atoms:

| Row | `D(p)` | `m(p)` | Retained atoms | Omitted atoms | Symbolic boundary term |
|---|---:|---:|---:|---:|---|
| {{DEFICIENT_ROW_ID}} | {{D_P}} | {{M_P}} | `m(p)` | `D(p)-m(p)` | `(D(p)-m(p))*Q(p)/D(p)` |

The materializer must replicate the table row exactly once for every
deficient owner and then satisfy:

```text
DEFICIENT_TABLE_ROW_COUNT = {{DEFICIENT_ROWS}}
```

This branch refutes only simultaneous saturation of the six fixed owners and
the full-capacity subroute using each deficient owner. It preserves each
certified first-hit atom for future weighted-boundary accounting. It is not
permission to execute that future accounting or any residual-owner run.

## 6. Final immutable custody

```text
VERIFICATION_RECEIPT_SHA256 = {{V0_VERIFICATION_RECEIPT_SHA256}}
AUDIT_RECEIPT_SHA256 = {{A0_AUDIT_RECEIPT_SHA256}}
FINAL_ARTIFACTS_MANIFEST_PATH = {{FINAL_ARTIFACTS_MANIFEST_PATH}}
FINAL_ARTIFACTS_MANIFEST_SHA256 = {{FINAL_ARTIFACTS_MANIFEST_SHA256}}
FINAL_READBACK_AFTER_REPORT = PASS
NO_PRIOR_OUTPUT_REWRITTEN = TRUE
```

The final custody surface must hash the exact certificates, generated
fragments, materialized payload, manifests, all raw logs, memory tables,
source/object traces, verifier/audit outputs and every receipt named above.

## 7. Mandatory no-claims

Whatever legal branch is selected:

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

Neither six-row PASS nor scoped STOP establishes `rho = 9/5`, an exponent,
positive density, an almost-all statement or the Collatz conjecture.
