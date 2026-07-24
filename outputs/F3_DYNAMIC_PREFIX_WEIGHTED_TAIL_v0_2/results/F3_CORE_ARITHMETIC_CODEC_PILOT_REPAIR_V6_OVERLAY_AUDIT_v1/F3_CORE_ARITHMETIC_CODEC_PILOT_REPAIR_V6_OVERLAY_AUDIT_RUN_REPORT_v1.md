# F3 arithmetic-codec pilot repair v6 overlay-audit run report v1

Status: `PRE_RUN_FROZEN / NOT_EXECUTED`

Date: 2026-07-24.

## 1. Custody

```text
branch = codex/hilo2-f3-pilot-repair-v6-overlay-audit
public base branch = codex/hilo2-f3-pilot-repair-v5-audit-only
public base HEAD = 61247130fd59adf536a342f04b918990a8eaed68
public base custody = https://github.com/Menta2357/collatz-classical/pull/10
prepared local HEAD = 15c057d56a53057c9c991feee557bb886def9862
contract sha256 = 1f16abc55568d3b6ed987153d160dae887c94adcc60d87b685346a6f10fde78d
static review sha256 = 0caf996db5b6bd022a0d75d1988e0904bb8a0ff89f26b5fae0410bc14f6f2297
stage script sha256 = b4e734695418494b7231dbe2cae45bf0de0b78193467d50c911085623c5c45b3
```

This report is committed and published before S0. Its terminal update will be
fast-forwarded whether the result is PASS or STOP.

## 2. Frozen inputs

```text
repair source sha256 = e5683405008b438d8a7c00747e4e81384962d95ced0d759d42c18f05ff62219c
repair olean sha256 = 480e605a5e3db74a1edf9ecce7f535b8f8c057965498ac5f73e787322c144372
repair olean bytes = 5197264
ExactCoreMatrix source sha256 = 58ab7b1acdb7bc6d69fffa04c4baa7ae29ac31e24e80834387974113b70d2ba5
ExactCoreMatrix olean sha256 = 34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
audit source sha256 = a8e05246e9726afb79c25e206a90f86b12a50a0803251c50cf8b856eae40e0f1
inventory sha256 = 611bfc53a028e224c71ceb9287a01dd3587e9300e889c7facbb21fb5183ce74f
checker sha256 = 18d2e368b5e73519ec5d701cee59177982bc1f6a750b1b5546d8568866761e9e
donor lake-manifest sha256 = 230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b
lean-toolchain sha256 = d24fed434d3b13adfaab57724a0a7f270ea8bf1c818b5ae5cf25cbce24dd685c
```

The two `.olean` inputs are ignored local artifacts. V6 is not a fresh-clone
reproduction; it tests only whether these exact frozen bytes support the total
axiom audit.

## 3. Preflight evidence

```text
overlay absent = PASS
result directory absent before this report = PASS
S0 log absent = PASS
A1 log absent = PASS
C1 log absent = PASS
audit olean absent = PASS
audit ilean absent = PASS
post-overlay LEAN_PATH roots containing CollatzClassical/ = 0
source edits = 0
compile invocations = 0
Lake invocations = 0
```

The ten roots after the overlay comprise nine dependency package roots and the
pinned Lean toolchain. None contains a `CollatzClassical/` directory. Thus the
overlay will be the only owner of that package during A1.

## 4. Frozen literal commands

S0, authorized once with a 120-second cap:

```sh
/opt/homebrew/bin/gtimeout 120 /usr/bin/time -p bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_core_arithmetic_codec_v6_overlay_stage_v1.sh' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V6_OVERLAY_AUDIT_v1/v6_overlay_stage_raw.txt' 2>&1
```

A1, authorized once after S0 PASS with a 300-second cap:

```sh
/opt/homebrew/bin/gtimeout 300 /usr/bin/time -p env LEAN_PATH='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/f3-v6-audit-overlay/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Cli/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/batteries/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Qq/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/aesop/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/proofwidgets/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/importGraph/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/plausible/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/mathlib/.lake/build/lib/lean:/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean' /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean --root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3' -o '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.olean' -i '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.ilean' '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.lean' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V6_OVERLAY_AUDIT_v1/v6_axiom_audit_raw.txt' 2>&1
```

C1, authorized once only after A1 PASS:

```sh
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_core_arithmetic_codec_repair_inventory_check_v1.sh' --audit-log '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V6_OVERLAY_AUDIT_v1/v6_axiom_audit_raw.txt' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V6_OVERLAY_AUDIT_v1/v6_axiom_log_checker.txt' 2>&1
```

## 5. Invocation ledger

```text
S0_INVOCATIONS = 0
A1_INVOCATIONS = 0
C1_INVOCATIONS = 0
COMPILE_INVOCATIONS = 0
LAKE_INVOCATIONS = 0
OVERLAY_STATE = ABSENT
AUDIT_STATE = NOT_EXECUTED
CHECKER_STATE = NOT_EXECUTED
FINAL_VERDICT = NOT_EXECUTED
```

No retry, source edit, budget change, extension to 243/729 or first-hit work is
authorized by this report.
