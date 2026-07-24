# F3 arithmetic-codec pilot repair v3 run report v1

Status: `ARITHMETIC_CODEC_REPAIR_V3_STOP_AND_RECORD / LEAN_UNSOLVED_GOAL / NOT_MATHEMATICAL_COUNTEREXAMPLE — AUDIT_NOT_OPENED`

Date: 2026-07-24.

This report freezes the sole authorized v3 execution before any Lean, Lake,
compiler or axiom-audit invocation.  It creates a new result directory and
reuses no v1 or v2 log.

## 1. Publication and authorization gate

```text
H1_PUBLIC_HEAD = 973ee134784cda35e2cff9a62c93da5d3c39d191
H1_DRAFT_PR = https://github.com/Menta2357/collatz-classical/pull/4
H2_V2_PUBLIC_HEAD = a37a4ebd975c12846d12264be59f37f374ba7ef4
H2_V2_DRAFT_PR = https://github.com/Menta2357/collatz-classical/pull/5
H3_PUBLICATION = FORMALLY_DEFERRED_BY_HUMAN_GATE
PUBLICATION_PHASE = SATISFIED
```

The human pre-emitted `GO F3 V3` only for a custody hash freezing exactly the
one-hunk `+4/-1` tactical repair, byte-identical statements/definitions/data,
the 151/151/151 inventory and audit surface, all 12 designated public
theorems, and the two v3 contract/review documents.  The resulting custody
commit is:

```text
V3_CUSTODY_COMMIT = f30a3005eea0ff9dcc2914378e05a5af6ec746da
V3_PARENT_V2_STOP = a37a4ebd975c12846d12264be59f37f374ba7ef4
GO_F3_V3 = MATERIALIZED_AGAINST_f30a3005eea0ff9dcc2914378e05a5af6ec746da
```

No deviation was found: the Lean diff is one proof hunk, `+4/-1`, replacing
only the failed retarded-branch `rfl` with the predeclared `change` and
`simp only`.  Statement, definition and data changes are all zero.

## 2. Immutable parent evidence and frozen inputs

```text
v2 frozen-run commit = ec3890141e860e3b9239cc9ffe23724487c4db6d
v2 prepared-source commit = 1681b89c17d9cf48189bf1b278341ceadd8d21dc
v2 final run report sha256 =
497c78b1fc3df89c3b40ff08c771bfbb926cafae38165e31114e3de92fb8676d
v2 raw compile log sha256 =
d1163ebb2de79f0dbbbb0affef58fab834a602cee5b0c1af535586cccb2aa8ef

v3 repair source sha256 =
44796367e408b40a42752587c8dde64af899731bec59f68765cdbb59266c7750
unchanged axiom audit sha256 =
a8e05246e9726afb79c25e206a90f86b12a50a0803251c50cf8b856eae40e0f1
unchanged explicit inventory sha256 =
611bfc53a028e224c71ceb9287a01dd3587e9300e889c7facbb21fb5183ce74f
unchanged audit-log checker sha256 =
18d2e368b5e73519ec5d701cee59177982bc1f6a750b1b5546d8568866761e9e
ExactCoreMatrix source sha256 =
58ab7b1acdb7bc6d69fffa04c4baa7ae29ac31e24e80834387974113b70d2ba5
donor ExactCoreMatrix olean sha256 =
34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
donor lake-manifest.json sha256 =
230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b
first-hit gate contract sha256 =
b5f022271bbd696df2a1b2e9205a36d8ad134e058fe29adbf5b1565f167c44fa
budget document sha256 =
9f9bce6e8ed3a227a21e4f1890f54e78c8c670ba7b2e045adefac9abeb0d4b04
toolchain = leanprover/lean4:v4.21.0
```

The donor paths are readable and the static checker returned:

```text
ALL_EXPLICIT_SOURCE_DECLARATIONS = 151
EXPLICIT_INVENTORY_DECLARATIONS = 151
EXPLICIT_AUDIT_COMMANDS = 151
FINAL_PUBLIC_THEOREMS_IN_AUDIT = 12_OF_12
SOURCE_INVENTORY_DIFF = EMPTY
INVENTORY_AUDIT_DIFF = EMPTY
FORBIDDEN_SOURCE_SYNTAX = ABSENT
```

## 3. Artifact and resource preflight

Before this report was created:

```text
repair olean = ABSENT
repair ilean = ABSENT
audit olean = ABSENT
audit ilean = ABSENT
v3 result directory = ABSENT
prior v3 compile log = ABSENT
prior v3 audit log = ABSENT
prior v3 checker log = ABSENT
```

The literal resource contract is:

```text
maxHeartbeats = 200000
total wall ceiling including import = 300 s
processes = 1
compile attempts = 1
audit attempts = 1 iff compile PASS
retry/edit/resource escalation after failure = forbidden
```

## 4. Sole compile command

```sh
/opt/homebrew/bin/gtimeout 300 /usr/bin/time -p env LEAN_PATH='/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Cli/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/batteries/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Qq/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/aesop/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/proofwidgets/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/importGraph/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/plausible/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/mathlib/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/build/lib/lean:/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean' /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean --root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3' -o '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean' -i '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.ilean' '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.lean' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V3_v1/v3_compile_raw.txt' 2>&1
```

Any nonzero exit, timeout, heartbeat exhaustion, missing output or frozen-input
mismatch is immediate STOP without audit, edit, retry or resource increase.

## 5. Conditional sole audit and checker

The audit is forbidden unless the compile exits zero and both repair artifacts
exist.  Its exact route is:

```sh
/opt/homebrew/bin/gtimeout 300 /usr/bin/time -p env LEAN_PATH='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Cli/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/batteries/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Qq/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/aesop/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/proofwidgets/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/importGraph/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/plausible/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/mathlib/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/build/lib/lean:/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean' /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean --root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3' -o '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.olean' -i '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.ilean' '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.lean' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V3_v1/v3_axiom_audit_raw.txt' 2>&1
```

Only after audit exit zero, the checker may run once:

```sh
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_core_arithmetic_codec_repair_inventory_check_v1.sh' --audit-log '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V3_v1/v3_axiom_audit_raw.txt' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V3_v1/v3_axiom_log_checker.txt' 2>&1
```

Acceptance requires one environmental namespace count, one profile per
declaration, 151/151/151 explicit coverage, all 12 final public theorems, and
no profile containing `Lean.ofReduceBool` or `sorryAx`.

## 6. Pre-run terminal ledger

```text
V3_COMPILE_INVOCATIONS = 0
V3_AUDIT_INVOCATIONS = 0
V3_CHECKER_INVOCATIONS = 0
FROZEN_INPUTS = MATCH
GO_SCOPE = MATCH
EXECUTION_GATE = OPEN_FOR_SOLE_COMPILE_AFTER_THIS_REPORT_COMMIT
NO_RETRY
NO_243_SOURCE_EXTENSION
NO_SEMANTIC_FIRST_HIT_EXECUTION
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## 7. Terminal result

The sole compile command was invoked once from frozen-run commit
`005258d080260d5502b42bde03672ed4d8449f20`.  It returned exit 1 after
140.37 seconds.  It did not time out or exhaust the heartbeat budget.

The three nonfatal `unnecessarySimpa` warnings from v2 remain.  The only error
is the retarded branch of `pilotFrozenPos_agrees`.  The explicit `change` and
named unfolding expose the intended piecewise arithmetic expression, but the
restricted `simp only` does not close the remaining equality between the
`Fin` value projection and the same piecewise natural-number expression.
This is a tactic/elaboration STOP, not a failed arithmetic instance or a
counterexample to the pilot construction.

The complete combined compiler log contains 17 lines and 1425 bytes:

```text
v3 compile log sha256 =
3d9596ba1ebe3254b8cad9aba6219716629104847589f94c7f3612a51febd1c6
```

No repair `.olean` or `.ilean` was produced.  Therefore the conditional axiom
audit and coverage checker were not invoked.  All frozen hashes were
recomputed after the run and match; the source, audit, inventory and checker
diff against custody commit `f30a300...` is empty.

```text
V3_COMPILE_INVOCATIONS = 1
V3_COMPILE_EXIT = 1
V3_COMPILE_WALL_SECONDS = 140.37
V3_COMPILE_USER_SECONDS = 15.83
V3_COMPILE_SYS_SECONDS = 13.45
V3_COMPILE_TIMEOUT = false
V3_COMPILE_HEARTBEAT_EXHAUSTION = false
V3_COMPILE_FAILURE_CLASS = LEAN_UNSOLVED_GOAL
V3_COMPILE_OLEAN = ABSENT
V3_COMPILE_ILEAN = ABSENT
V3_AUDIT_INVOCATIONS = 0
V3_AUDIT_EXIT = NOT_RUN_BY_CONTRACT
V3_AUDIT_OLEAN = ABSENT
V3_AUDIT_ILEAN = ABSENT
V3_CHECKER_INVOCATIONS = 0
POST_RUN_HASHES = MATCH_FROZEN_INPUTS
POST_RUN_SOURCE_DIFF = EMPTY
RETRY = false
SOURCE_EDIT_AFTER_ATTEMPT = false
SEMANTIC_FIRST_HIT_EXECUTION = false
FULL_EXTENSION_OPENED = false
FINAL_VERDICT = ARITHMETIC_CODEC_REPAIR_V3_STOP_AND_RECORD / LEAN_UNSOLVED_GOAL / NOT_MATHEMATICAL_COUNTEREXAMPLE
```

No next repair is implemented or authorized here.  A future route would need
a new branch and contract for a materially explicit treatment of the three
piecewise cases or of the `Fin` value projection.  This report does not claim
that either mechanism compiles.

```text
NO_RETRY
NO_AUDIT
NO_243_SOURCE_EXTENSION
NO_SEMANTIC_FIRST_HIT_EXECUTION
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```
