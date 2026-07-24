# F3 arithmetic-codec pilot repair v4 run report v1

Status: `AUTHORIZED / FROZEN_PRE-RUN / NOT_EXECUTED`

Date: 2026-07-24.

This report freezes the sole v4 route-A execution. It creates a new result
directory and reuses no prior log.

## 1. Public custody and controlling commit

```text
V3_PUBLIC_HEAD = 4912af1dbe3f3f482d4e41d2887f8e8694d60562
V3_DRAFT_PR = https://github.com/Menta2357/collatz-classical/pull/6
V4_PREPARED_COMMIT = a0af200da893c214ca93be848d8cee4cc44f4a4a
V4_PARENT = 4912af1dbe3f3f482d4e41d2887f8e8694d60562
V4_ROUTE = A_SPLIT_IFS_THEN_RFL
V4_TERMINAL_PUSH = AUTHORIZED_FOR_PASS_OR_STOP
```

The Lean diff from v3 is exactly one proof hunk, `+1/-0`. Statements,
definitions and data are unchanged. Route B is outside this contract.

## 2. Frozen inputs

```text
v4 source sha256 =
e5683405008b438d8a7c00747e4e81384962d95ced0d759d42c18f05ff62219c
v4 contract sha256 =
99b9ef3a98a47ea37ebbb73015b1bd03de7b67f94676e2e0639f53846904dde7
v4 static review sha256 =
8d16ffb06825e839568fc43eb535cfdd54949fa16119ba0c3a25b7cdd9710686
unchanged audit sha256 =
a8e05246e9726afb79c25e206a90f86b12a50a0803251c50cf8b856eae40e0f1
unchanged inventory sha256 =
611bfc53a028e224c71ceb9287a01dd3587e9300e889c7facbb21fb5183ce74f
unchanged checker sha256 =
18d2e368b5e73519ec5d701cee59177982bc1f6a750b1b5546d8568866761e9e
ExactCoreMatrix source sha256 =
58ab7b1acdb7bc6d69fffa04c4baa7ae29ac31e24e80834387974113b70d2ba5
donor ExactCoreMatrix olean sha256 =
34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
donor lake-manifest.json sha256 =
230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b
first-hit contract sha256 =
b5f022271bbd696df2a1b2e9205a36d8ad134e058fe29adbf5b1565f167c44fa
budget document sha256 =
9f9bce6e8ed3a227a21e4f1890f54e78c8c670ba7b2e045adefac9abeb0d4b04
toolchain = leanprover/lean4:v4.21.0
```

The static checker returned 151/151/151 explicit declarations, 12/12 final
public theorems, empty inventory diffs and no forbidden syntax.

## 3. Artifact and log preflight

Before creating this report:

```text
repair olean = ABSENT
repair ilean = ABSENT
audit olean = ABSENT
audit ilean = ABSENT
v4 result directory = ABSENT
v4 compile log = ABSENT
v4 audit log = ABSENT
v4 checker log = ABSENT
```

Resource contract:

```text
maxHeartbeats = 200000
wall ceiling including import = 300 s
processes = 1
compile attempts = 1
audit attempts = 1 iff compile PASS
checker attempts = 1 iff audit PASS
retry/edit/route-change/resource-escalation after failure = forbidden
```

## 4. Sole compile command

```sh
/opt/homebrew/bin/gtimeout 300 /usr/bin/time -p env LEAN_PATH='/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Cli/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/batteries/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Qq/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/aesop/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/proofwidgets/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/importGraph/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/plausible/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/mathlib/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/build/lib/lean:/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean' /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean --root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3' -o '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean' -i '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.ilean' '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.lean' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V4_v1/v4_compile_raw.txt' 2>&1
```

## 5. Conditional audit and checker commands

The audit is forbidden unless compile exits zero and both repair artifacts
exist:

```sh
/opt/homebrew/bin/gtimeout 300 /usr/bin/time -p env LEAN_PATH='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Cli/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/batteries/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Qq/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/aesop/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/proofwidgets/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/importGraph/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/plausible/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/mathlib/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/build/lib/lean:/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean' /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean --root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3' -o '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.olean' -i '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.ilean' '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.lean' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V4_v1/v4_axiom_audit_raw.txt' 2>&1
```

The checker is forbidden unless audit exits zero:

```sh
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_core_arithmetic_codec_repair_inventory_check_v1.sh' --audit-log '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V4_v1/v4_axiom_audit_raw.txt' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V4_v1/v4_axiom_log_checker.txt' 2>&1
```

## 6. Pre-run ledger

```text
V4_COMPILE_INVOCATIONS = 0
V4_AUDIT_INVOCATIONS = 0
V4_CHECKER_INVOCATIONS = 0
FROZEN_INPUTS = MATCH
PUBLIC_PRE_RUN_PUSH = REQUIRED_BEFORE_EXECUTION
EXECUTION_GATE = OPEN_AFTER_THIS_REPORT_COMMIT_IS_PUSHED
NO_RETRY
NO_ROUTE_B_IN_V4
NO_243_SOURCE_EXTENSION
NO_SEMANTIC_FIRST_HIT_EXECUTION
```

## 7. Terminal result

`PENDING_SOLE_AUTHORIZED_EXECUTION`
