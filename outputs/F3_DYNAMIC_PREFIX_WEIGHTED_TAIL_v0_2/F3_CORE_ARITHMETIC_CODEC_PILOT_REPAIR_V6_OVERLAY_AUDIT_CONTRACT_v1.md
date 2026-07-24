# F3 arithmetic-codec pilot repair v6 overlay-audit contract v1

Status: `AUTHORIZED / SINGLE_PACKAGE_OVERLAY / NOT_EXECUTED`

Date: 2026-07-24.

## 1. Custody and mechanism

```text
branch = codex/hilo2-f3-pilot-repair-v6-overlay-audit
parent v5 terminal = 61247130fd59adf536a342f04b918990a8eaed68
public v5 custody = https://github.com/Menta2357/collatz-classical/pull/10
source edits = 0
compile invocations = 0
Lake invocations = 0
```

V5 confirmed Lean 4.21 package-root shadowing: the first `LEAN_PATH` entry
containing `CollatzClassical/` owns all modules of that package, even when the
requested object is absent. Reordering two fragmentary roots cannot provide
both repair and ExactCoreMatrix.

V6 creates one isolated package root containing exactly those two frozen
objects, then excludes both fragmentary project roots from audit `LEAN_PATH`.
The import graph is closed and exhaustive for the audit module:

```text
audit -> repair -> ExactCoreMatrix -> Mathlib
audit -> Lean.Meta.Basic -> toolchain
audit -> Lean.Util.CollectAxioms -> toolchain
```

The ExactCoreMatrix source imports only `Mathlib`.

## 2. Local-artifact and overlay contract

This remains a local-artifact continuation, not fresh-clone reproducible. The
source object bytes are ignored by Git; public custody records hashes only.

```text
repair olean = 480e605a5e3db74a1edf9ecce7f535b8f8c057965498ac5f73e787322c144372
repair olean bytes = 5197264
ExactCoreMatrix olean = 34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
repair source = e5683405008b438d8a7c00747e4e81384962d95ced0d759d42c18f05ff62219c
ExactCoreMatrix source = 58ab7b1acdb7bc6d69fffa04c4baa7ae29ac31e24e80834387974113b70d2ba5
audit source = a8e05246e9726afb79c25e206a90f86b12a50a0803251c50cf8b856eae40e0f1
inventory = 611bfc53a028e224c71ceb9287a01dd3587e9300e889c7facbb21fb5183ce74f
checker = 18d2e368b5e73519ec5d701cee59177982bc1f6a750b1b5546d8568866761e9e
stage script = b4e734695418494b7231dbe2cae45bf0de0b78193467d50c911085623c5c45b3
donor lake-manifest = 230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b
lean-toolchain = d24fed434d3b13adfaab57724a0a7f270ea8bf1c818b5ae5cf25cbce24dd685c
```

The overlay must be absent before S0. S0 may create it once and copy exactly
the two listed `.olean` files. No other copy, symlink, compilation,
regeneration or cleanup is authorized. Partial S0 failure is terminal STOP.

## 3. Publication discipline

Contract, stage script, static review and pre-run report must be committed and
pushed to a draft PR stacked on v5 before S0. Terminal PASS or STOP, the run
report and every produced log must be fast-forward pushed.

No retry, source edit, budget increase, amend, force-push, retarget or merge is
authorized. The full repository-relative pre-run report path is
`outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V6_OVERLAY_AUDIT_v1/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V6_OVERLAY_AUDIT_RUN_REPORT_v1.md`.
Before S0 that report must freeze the public HEAD; contract, review and stage
script hashes; literal S0/A1/C1 commands; zero invocation counters; and the
absence of the overlay, result logs and audit objects.

## 4. S0 — deterministic overlay staging

Invoke once with a 120-second cap:

```sh
/opt/homebrew/bin/gtimeout 120 /usr/bin/time -p bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_core_arithmetic_codec_v6_overlay_stage_v1.sh' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V6_OVERLAY_AUDIT_v1/v6_overlay_stage_raw.txt' 2>&1
```

PASS requires exit zero, exactly two overlay files and exact hashes. Otherwise
audit/checker are forbidden.

## 5. A1 — sole audit

Only after S0 PASS, invoke once with a 300-second cap. The `LEAN_PATH` contains
the overlay, dependency package roots and toolchain; it contains neither the
local nor donor `CollatzClassical` build root.

```sh
/opt/homebrew/bin/gtimeout 300 /usr/bin/time -p env LEAN_PATH='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/f3-v6-audit-overlay/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Cli/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/batteries/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Qq/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/aesop/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/proofwidgets/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/importGraph/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/plausible/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/mathlib/.lake/build/lib/lean:/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean' /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean --root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3' -o '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.olean' -i '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.ilean' '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.lean' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V6_OVERLAY_AUDIT_v1/v6_axiom_audit_raw.txt' 2>&1
```

Any nonzero exit, timeout, missing audit object or overlay/input hash drift is
terminal STOP; checker remains forbidden.

## 6. C1 — conditional total-coverage checker

Only after A1 PASS:

```sh
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_core_arithmetic_codec_repair_inventory_check_v1.sh' --audit-log '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V6_OVERLAY_AUDIT_v1/v6_axiom_audit_raw.txt' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V6_OVERLAY_AUDIT_v1/v6_axiom_log_checker.txt' 2>&1
```

PASS requires checker exit zero, 151/151/151 explicit coverage, 12/12 final
public theorems, one profile per environmental declaration and absence of
`Lean.ofReduceBool` and `sorryAx`. Any mismatch or post-run hash drift is STOP.

## 7. Scope

A PASS closes only the 27-source/81-edge pilot audit. It does not authorize
243/729 extension or first-hit.

```text
S0_INVOCATIONS = 0
A1_INVOCATIONS = 0
C1_INVOCATIONS = 0
COMPILE_INVOCATIONS = 0
LAKE_INVOCATIONS = 0
PUBLIC_TERMINAL_CUSTODY = REQUIRED
NO_EXTENSION
NO_FIRST_HIT
```
