# F3 arithmetic-codec pilot repair v5 audit-only contract v1

Status: `AUTHORIZED / LOCAL_ARTIFACT_CONTINUATION / NOT_EXECUTED`

Date: 2026-07-24.

## 1. Scope and custody

```text
branch = codex/hilo2-f3-pilot-repair-v5-audit-only
parent v4 terminal = a7a720ebbf43674a1cf16d55d3be73f9f350d5e2
public v4 custody = https://github.com/Menta2357/collatz-classical/pull/8
compile invocations authorized = 0
Lake invocations authorized = 0
source edits authorized = 0
```

V4 compiled the route-A repair but its audit stopped because the frozen audit
`LEAN_PATH` omitted the donor project build root. V5 changes only that process
environment. It does not alter or rebuild Lean source.

## 2. Local-artifact limitation and frozen inputs

The repair objects and donor ExactCoreMatrix object are ignored `.lake`
artifacts and are not stored in Git. Therefore this gate is explicitly a local
continuation, not reproducible from a fresh clone. Preflight fails closed if
any required object is absent or changed. Regeneration, copying or
recompilation is forbidden.

```text
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
toolchain = leanprover/lean4:v4.21.0
```

Before execution the branch and public upstream must equal the frozen pre-run
HEAD, tracked diff must be empty, the v5 audit/checker logs and audit objects
must be absent, and all listed hashes/sizes must match.

## 3. Publication discipline

The contract, static review and pre-run report must be committed and pushed to
a draft PR stacked on v4 before execution. The terminal report and every log
actually produced must be fast-forward pushed after PASS or STOP.

The pre-run report path is
`results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V5_AUDIT_ONLY_v1/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V5_AUDIT_ONLY_RUN_REPORT_v1.md`.
It must freeze the public execution HEAD, contract/review hashes, literal
commands and zero counters; verify all three required local objects; and record
the audit/checker logs plus audit `.olean`/`.ilean` as absent.

No retry, source edit, artifact regeneration, resource increase, amend,
force-push, retarget or merge is authorized.

## 4. Sole audit attempt

The result directory is:

```text
outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V5_AUDIT_ONLY_v1
```

Invoke once, with a 300-second wall cap:

```sh
/opt/homebrew/bin/gtimeout 300 /usr/bin/time -p env LEAN_PATH='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Cli/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/batteries/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Qq/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/aesop/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/proofwidgets/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/importGraph/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/plausible/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/mathlib/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/build/lib/lean:/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean' /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean --root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3' -o '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.olean' -i '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.ilean' '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.lean' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V5_AUDIT_ONLY_v1/v5_axiom_audit_raw.txt' 2>&1
```

Any nonzero exit, timeout, missing audit artifact or input drift is terminal
STOP. The checker remains forbidden.

## 5. Conditional checker

Only after audit exit zero and presence of audit `.olean` plus `.ilean`, invoke
the unchanged total-coverage checker once:

```sh
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_core_arithmetic_codec_repair_inventory_check_v1.sh' --audit-log '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V5_AUDIT_ONLY_v1/v5_axiom_audit_raw.txt' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V5_AUDIT_ONLY_v1/v5_axiom_log_checker.txt' 2>&1
```

PASS requires checker exit zero, 151/151/151 explicit coverage, one profile
per environmental namespace declaration, all 12 designated public theorems,
and no `Lean.ofReduceBool` or `sorryAx`. Frozen repair objects must retain their
preflight hashes after audit/checker.

Any checker nonzero exit, incomplete coverage, forbidden profile, missing
output or post-run drift of a repair or donor object is terminal STOP without
retry, regeneration, source edit or resource increase.

## 6. Scope of PASS

A PASS closes only the 27-source/81-edge arithmetic-codec pilot and its axiom
audit. It does not authorize recompilation, 243/729 extension, first-hit, rho,
density or a global Collatz claim.

```text
V5_COMPILE_INVOCATIONS = 0
V5_AUDIT_INVOCATIONS = 0
V5_CHECKER_INVOCATIONS = 0
PUBLIC_TERMINAL_CUSTODY = REQUIRED
NO_243_SOURCE_EXTENSION
NO_SEMANTIC_FIRST_HIT_EXECUTION
```
