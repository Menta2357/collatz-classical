# F3 arithmetic-codec pilot repair v6 overlay-audit run report v1

Status: `PASS / TOTAL_COVERAGE / FORBIDDEN_AXIOMS_ABSENT`

Date: 2026-07-24.

## 1. Custody

```text
branch = codex/hilo2-f3-pilot-repair-v6-overlay-audit
public base branch = codex/hilo2-f3-pilot-repair-v5-audit-only
public base HEAD = 61247130fd59adf536a342f04b918990a8eaed68
public base custody = https://github.com/Menta2357/collatz-classical/pull/10
prepared local HEAD = 15c057d56a53057c9c991feee557bb886def9862
public v6 pre-run HEAD = 543e9a9fa9ede3c9e8feb54e791f08d75a43390e
public v6 custody = https://github.com/Menta2357/collatz-classical/pull/12
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

## 5. Results

S0 exited zero. Its log records:

```text
V6_OVERLAY_STAGE = PASS
real = 0.10 s
user = 0.07 s
sys = 0.02 s
overlay file count = 2
repair overlay hash = 480e605a5e3db74a1edf9ecce7f535b8f8c057965498ac5f73e787322c144372
ExactCoreMatrix overlay hash = 34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
S0 log sha256 = bc3f3894ffb383d48c23f3f7f39ae799d5ec619cf6b0e975782f0663312bf44b
```

A1 exited zero and produced both requested audit artifacts:

```text
real = 150.96 s
user = 17.82 s
sys = 14.49 s
audit log lines = 1315
audit log bytes = 95299
audit log sha256 = 76493a39a7e90e1eb833ba4c59112b9061204c66dcee8babee7f659ddde47ace
audit olean bytes = 37488
audit olean sha256 = 11aecca1e2d477c61c44f7614359cb21ff45804b355ab28ee5be583b4c72ef1b
audit ilean bytes = 35315
audit ilean sha256 = 3f12a60f53bcc0e5ed029947675a49745d8727856568a8b02fd3fa480257be12
```

C1 exited zero. The checker output is 17 lines and 621 bytes with SHA-256
`36ea1afb2646524aa2b23862582955918bef2cc196e308315414a302d17d39f9`.
It certifies:

```text
explicit source declarations = 151
inventory declarations = 151
explicit audit commands = 151
source/inventory/audit differences = empty
duplicates = none
private explicit declarations = none
final public theorems audited = 12/12
environmental namespace declarations = 640
environmental axiom profiles = 640
environmental profile names unique = 640/640
axioms across the 151 explicit declarations = propext, Quot.sound, Classical.choice
forbidden source syntax = absent
checker forbidden-environmental-axiom result = absent
```

Adversarial review found that C1 checks `Lean.ofReduceBool|sorryAx` only on the
first line of each `AXIOM_PROFILE`, while some profiles wrap across lines.
Therefore C1 alone does not establish whole-log absence. A separate exact scan
of the complete A1 log and C1 output,
`rg -n 'Lean\.ofReduceBool|sorryAx'`, returned zero matches. For this frozen run:

```text
whole-log Lean.ofReduceBool occurrences = 0
whole-log sorryAx occurrences = 0
checker line-wrapping robustness = OPEN_ENGINEERING_GAP
```

All frozen source, inventory, checker, manifest, toolchain and overlay-object
hashes were rechecked after C1 and did not drift.

## 6. Invocation ledger

```text
S0_INVOCATIONS = 1
A1_INVOCATIONS = 1
C1_INVOCATIONS = 1
REPAIR_OR_INPUT_COMPILE_INVOCATIONS = 0
A1_AUDIT_ELABORATION_INVOCATIONS = 1
LAKE_INVOCATIONS = 0
OVERLAY_STATE = PASS_EXACTLY_TWO_FROZEN_OBJECTS
AUDIT_STATE = PASS_EXIT_ZERO_ARTIFACTS_PRESENT
CHECKER_STATE = PASS_TOTAL_COVERAGE
WHOLE_LOG_SCAN_FORBIDDEN_AXIOMS = 0_OF_0
FINAL_VERDICT = PASS_27_SOURCE_81_EDGE_PILOT_AUDIT_ONLY
```

This PASS closes only the already compiled 27-source/81-edge pilot's complete
axiom audit. It does not prove the F3 exponent, authorize extension to 243/729,
or settle the semantic first-hit hook. No retry, source edit, budget change,
extension or first-hit work occurred under this contract.
