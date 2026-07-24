# F3 arithmetic-codec pilot repair v5 audit-only run report

Status: `V5_AUDIT_MODULE_ROOT_RESOLUTION_STOP / CHECKER_NOT_RUN`

Date: 2026-07-24.

## 1. Public custody

```text
V4_TERMINAL_COMMIT = a7a720ebbf43674a1cf16d55d3be73f9f350d5e2
V4_DRAFT_PR = https://github.com/Menta2357/collatz-classical/pull/8
V5_PREPARED_COMMIT = 5b96a645eaad0a032c1e96d3390e588005b52462
V5_BRANCH = codex/hilo2-f3-pilot-repair-v5-audit-only
V5_EXECUTION_HEAD = THIS_REPORT_COMMIT
V5_FROZEN_RUN_COMMIT = 89e577bfc1d4fd5d6f808add90acce4dc3153634
V5_DRAFT_PR = https://github.com/Menta2357/collatz-classical/pull/10
V5_PUBLIC_PRE_RUN_PUSH = REQUIRED_BEFORE_AUDIT
```

## 2. Frozen inputs

```text
contract = a54efaae8b7b1bbad93cd6a14c08eb4b025f1038e77be273ea65e268a494a266
static review = 2539201d11fd3f014c19de51c5c92692bbe3349703322b529b68bf6a2a4ca013
repair source = e5683405008b438d8a7c00747e4e81384962d95ced0d759d42c18f05ff62219c
audit source = a8e05246e9726afb79c25e206a90f86b12a50a0803251c50cf8b856eae40e0f1
inventory = 611bfc53a028e224c71ceb9287a01dd3587e9300e889c7facbb21fb5183ce74f
checker = 18d2e368b5e73519ec5d701cee59177982bc1f6a750b1b5546d8568866761e9e
repair olean = 480e605a5e3db74a1edf9ecce7f535b8f8c057965498ac5f73e787322c144372
repair olean bytes = 5197264
repair ilean = 627ba7b79d66ab64a572a1ae53cf1d3cf0692cc7bd6f59078c3cf52208f28358
repair ilean bytes = 111183
donor ExactCoreMatrix olean = 34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
ExactCoreMatrix source = 58ab7b1acdb7bc6d69fffa04c4baa7ae29ac31e24e80834387974113b70d2ba5
donor lake-manifest.json = 230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b
lean-toolchain = d24fed434d3b13adfaab57724a0a7f270ea8bf1c818b5ae5cf25cbce24dd685c
v4 terminal report = d875d36f9c8b102e2368a7a525420427fd5f1cc04ac4816a726b54bc103c5f19
v4 compile log = 03f7d430e8df69df2ecf88d4e044000869c7a08357c599c5fe548daf8098c782
v4 failed audit log = 0a62ce8dcf7d0c495b951fc2a031466aed42aaa32c34fd66567fa67fe4a4f7c8
```

The three required binary objects are ignored local artifacts. Their hashes,
not their bytes, are publicly custodied. V5 is not fresh-clone reproducible.

## 3. Pre-run state

```text
tracked worktree = CLEAN
source changes from v4 = NONE
compile invocations = 0
Lake invocations = 0
repair olean/ilean = PRESENT_HASH_MATCH
donor ExactCoreMatrix olean = PRESENT_HASH_MATCH
audit olean/ilean = ABSENT
v5 audit log = ABSENT
v5 checker log = ABSENT
static coverage = 151/151/151_AND_12/12
```

## 4. Sole audit command

```sh
/opt/homebrew/bin/gtimeout 300 /usr/bin/time -p env LEAN_PATH='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Cli/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/batteries/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Qq/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/aesop/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/proofwidgets/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/importGraph/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/plausible/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/mathlib/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/build/lib/lean:/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean' /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean --root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3' -o '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.olean' -i '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.ilean' '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.lean' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V5_AUDIT_ONLY_v1/v5_axiom_audit_raw.txt' 2>&1
```

## 5. Conditional checker command

```sh
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_core_arithmetic_codec_repair_inventory_check_v1.sh' --audit-log '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V5_AUDIT_ONLY_v1/v5_axiom_audit_raw.txt' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V5_AUDIT_ONLY_v1/v5_axiom_log_checker.txt' 2>&1
```

## 6. Pre-run ledger

```text
V5_COMPILE_INVOCATIONS = 0
V5_LAKE_INVOCATIONS = 0
V5_AUDIT_INVOCATIONS = 0
V5_CHECKER_INVOCATIONS = 0
NO_REGENERATION
NO_RETRY
NO_243_SOURCE_EXTENSION
NO_SEMANTIC_FIRST_HIT_EXECUTION
TERMINAL_PUBLIC_PUSH = REQUIRED_FOR_PASS_OR_STOP
```

## 7. Terminal result

The sole audit invocation ran from frozen commit
`89e577bfc1d4fd5d6f808add90acce4dc3153634` and exited 1 after 0.43 seconds.
The corrected `LEAN_PATH` did contain the donor build root, but Lean still
requested `F3ReturnExcursionExactCoreMatrix.olean` from the local project build
root selected for the repair module and reported that local object absent.

This is confirmed `LEAN_PATH` package-root shadowing. In Lean 4.21,
`Lean/Util/Path.lean` selects the first search entry whose package-root
directory `CollatzClassical/` exists and `Lean/Environment.lean` checks the
requested object only afterward. The local entry is first and contains that
package root, so the later donor entry is never considered for the missing
ExactCoreMatrix object. V5 does not authorize reordering roots or copying an
object to the local root.

```text
V5_COMPILE_INVOCATIONS = 0
V5_LAKE_INVOCATIONS = 0
V5_AUDIT_INVOCATIONS = 1
V5_AUDIT_EXIT = 1
V5_AUDIT_TIMEOUT = false
V5_AUDIT_HEARTBEAT_EXHAUSTION = false
V5_AUDIT_WALL_SECONDS = 0.43
V5_AUDIT_USER_SECONDS = 0.02
V5_AUDIT_SYS_SECONDS = 0.06
V5_AUDIT_FAILURE_CLASS = LEAN_PATH_PACKAGE_ROOT_SHADOWING_CONFIRMED
V5_AUDIT_LOG_LINES = 4
V5_AUDIT_LOG_BYTES = 422
V5_AUDIT_LOG_SHA256 = ef9affe2cc14ed88e85b23ce5827c237eb63954bcc9efe8188817d585ff3cf78
V5_AUDIT_OLEAN = ABSENT
V5_AUDIT_ILEAN = ABSENT
V5_CHECKER_INVOCATIONS = 0
V5_CHECKER_RESULT = NOT_RUN_BY_CONTRACT
V5_AXIOM_PROFILE = UNKNOWN_NOT_AUDITED
FROZEN_TRACKED_INPUTS = UNCHANGED
```

Post-run hashes remain:

```text
repair olean = 480e605a5e3db74a1edf9ecce7f535b8f8c057965498ac5f73e787322c144372
repair ilean = 627ba7b79d66ab64a572a1ae53cf1d3cf0692cc7bd6f59078c3cf52208f28358
donor ExactCoreMatrix olean = 34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
```

There was no source edit, regeneration, copy, retry, extension or first-hit
execution.

```text
FINAL_VERDICT = V5_AUDIT_MODULE_ROOT_RESOLUTION_STOP
PILOT_KERNEL_CLEAN_CLAIM = NOT_ESTABLISHED
NO_RETRY
NO_REGENERATION
NO_243_SOURCE_EXTENSION
NO_SEMANTIC_FIRST_HIT_EXECUTION
TERMINAL_PUBLIC_CUSTODY = REQUIRED
```
