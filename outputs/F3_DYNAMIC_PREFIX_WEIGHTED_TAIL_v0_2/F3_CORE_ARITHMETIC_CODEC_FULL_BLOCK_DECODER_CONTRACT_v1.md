# F3 arithmetic-codec full block decoder contract v1

Status: `AUTHORIZED / SYMBOLIC_DECODER_ONLY / NOT_EXECUTED`

Date: 2026-07-24.

## 1. Custody and purpose

```text
branch = codex/hilo2-f3-full-block-decoder-v1
parent v6 terminal = ef39994163d7124b896aca32a02f3b452fd56637
public v6 custody = https://github.com/Menta2357/collatz-classical/pull/12
```

V6 closes the audited 27-source/81-edge pilot.  Directly scaling its
`fin_cases` proof to 243/729 would turn the only full-literal gate into a large
enumeration.  This contract instead validates a symbolic 81-by-9 block
decoder first.  It imports the audited pilot repair, proves source and
position shifts, and reduces the full inverse to the already audited pilot
inverse.

This gate does not mention the 729-entry literal `coreEdges`.  A PASS permits
drafting a separate full-core identity module whose sole new risk is the
literal normalization by `rfl`; it does not itself prove that normalization.

## 2. Frozen tracked inputs

```text
decoder source = 1715e45e2395f25bf4d4ac0e27c6ae9cc0dff3fc651e67e1e666be1684541ed1
decoder audit = 3c08fda4f6204ecc32b5d85720d66f8dc310d73972a29e97f668be5b1fb7ba54
decoder inventory = f1a37624bc2dc9940d6fbbed6cfa92afef094951cf605ce12f5e43c69b188bf4
decoder checker = 0578e3aad75296642e7c9c84e3d8e3c0fb3be512a686b88ca475f5efb5b661c6
whole-log guard v2 = b064ecce31dd3d15b707b49b9ba3a0521d0070f8e46f138ac045499445e29b70
guard regression = 8f281c679fc06562be4b3a3608d99798e02492089811c0ad696533947fff56bc
wrapped-bad fixture = b8f9116a885f21db8cbc387b8d16ce8247312c5ad2c5726ec376e3059e99ef0c
overlay stage script = ba54f2a36f50e5d3afeccfb285c5e34738cbb3bb505a8ccac11300c811526e1b
pilot repair source = e5683405008b438d8a7c00747e4e81384962d95ced0d759d42c18f05ff62219c
ExactCoreMatrix source = 58ab7b1acdb7bc6d69fffa04c4baa7ae29ac31e24e80834387974113b70d2ba5
historical design = 79567ccc3c3556b13fea30be05499ff5ebfb00a50e280cc9f954693ff46e55d8
first-hit paper gate = b5f022271bbd696df2a1b2e9205a36d8ad134e058fe29adbf5b1565f167c44fa
```

Static inventory acceptance is exactly 30/30/30 explicit declarations and
5/5 designated terminal public theorems.  The source contains no table,
lookup, `fin_cases`, `native_decide`, placeholder axiom or literal identity.

During contract drafting, before hashes and commands were frozen, the static
inventory checker and guard regression were each exercised once and passed.
Those development checks invoked no Lean and produced no retained runtime
log.  They are disclosed separately from the post-publication R0 authorized
below; no failed result, parameter change or adaptive retry occurred.

## 3. Frozen local objects and environment

```text
repair olean = 480e605a5e3db74a1edf9ecce7f535b8f8c057965498ac5f73e787322c144372
ExactCoreMatrix olean = 34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
donor lake-manifest = 230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b
lean-toolchain = d24fed434d3b13adfaab57724a0a7f270ea8bf1c818b5ae5cf25cbce24dd685c
```

The ignored objects make this a local-artifact continuation, not a fresh-clone
reproduction.  The isolated overlay begins with exactly those two objects.
The compile then writes only decoder `.olean`/`.ilean`; the audit writes only
audit `.olean`/`.ilean`.

## 4. Publication and STOP discipline

Source, audit, inventory, guard v2, regression, fixture, checker, stage script,
contract, static review and pre-run report must be committed and pushed to a
draft PR stacked on v6 before R0.  The same PR must receive terminal PASS or
STOP and every produced log by fast-forward.

No retry, source edit, alternate proof, resource increase, cleanup, amend,
force-push, retarget or merge is authorized after R0 begins.  Any failure or
timeout stops all later phases.  The report path is
`outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_FULL_BLOCK_DECODER_v1/F3_CORE_ARITHMETIC_CODEC_FULL_BLOCK_DECODER_RUN_REPORT_v1.md`.

## 5. R0 — guard-v2 regression

Invoke once with a 60-second cap:

```sh
/opt/homebrew/bin/gtimeout 60 /usr/bin/time -p bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_axiom_audit_log_guard_v2_regression.sh' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_FULL_BLOCK_DECODER_v1/v1_guard_regression_raw.txt' 2>&1
```

PASS requires the real v6 log to pass with 640 profiles and the wrapped-bad
fixture to be rejected.  Otherwise S0 and every Lean phase are forbidden.

## 6. S0 — isolated overlay

Only after R0 PASS, invoke once with a 120-second cap:

```sh
/opt/homebrew/bin/gtimeout 120 /usr/bin/time -p bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_block_decoder_overlay_stage_v1.sh' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_FULL_BLOCK_DECODER_v1/v1_overlay_stage_raw.txt' 2>&1
```

PASS requires exactly two regular files, zero symlinks and exact hashes.

## 7. C0 — sole decoder compilation

Only after S0 PASS, invoke once with a 300-second wall cap.  The source itself
sets `maxHeartbeats 200000` and `maxRecDepth 100000`.

```sh
/opt/homebrew/bin/gtimeout 300 /usr/bin/time -p env LEAN_PATH='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/f3-full-block-decoder-overlay/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Cli/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/batteries/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Qq/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/aesop/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/proofwidgets/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/importGraph/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/plausible/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/mathlib/.lake/build/lib/lean:/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean' /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean --root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3' -o '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/f3-full-block-decoder-overlay/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.olean' -i '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/f3-full-block-decoder-overlay/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.ilean' '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.lean' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_FULL_BLOCK_DECODER_v1/v1_compile_raw.txt' 2>&1
```

Any nonzero exit, timeout, missing decoder object, overlay count other than
four, symlink, input drift or forbidden source change is STOP.  A1/K1 remain
forbidden.

## 8. A1 and K1 — conditional total audit

Only after C0 PASS, invoke A1 once with a 300-second cap:

```sh
/opt/homebrew/bin/gtimeout 300 /usr/bin/time -p env LEAN_PATH='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/f3-full-block-decoder-overlay/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Cli/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/batteries/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Qq/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/aesop/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/proofwidgets/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/importGraph/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/plausible/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/mathlib/.lake/build/lib/lean:/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean' /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean --root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3' -o '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/f3-full-block-decoder-overlay/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoderAxiomAudit.olean' -i '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/f3-full-block-decoder-overlay/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoderAxiomAudit.ilean' '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoderAxiomAudit.lean' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_FULL_BLOCK_DECODER_v1/v1_axiom_audit_raw.txt' 2>&1
```

Only after A1 PASS, invoke K1 once with a 60-second cap:

```sh
/opt/homebrew/bin/gtimeout 60 /usr/bin/time -p bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_block_decoder_inventory_check_v1.sh' --audit-log '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_FULL_BLOCK_DECODER_v1/v1_axiom_audit_raw.txt' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_FULL_BLOCK_DECODER_v1/v1_axiom_log_checker.txt' 2>&1
```

PASS requires 30/30/30, 5/5, one unique profile per environmental namespace
declaration, and whole-log zero occurrences of `Lean.ofReduceBool` and
`sorryAx`.  Any mismatch is terminal STOP.

## 9. Scope

```text
R0_INVOCATIONS = 0
S0_INVOCATIONS = 0
C0_INVOCATIONS = 0
A1_INVOCATIONS = 0
K1_INVOCATIONS = 0
PRECONTRACT_STATIC_INVENTORY_CHECKS = 1
PRECONTRACT_GUARD_REGRESSION_INVOCATIONS = 1
LAKE_INVOCATIONS = 0
PUBLIC_TERMINAL_CUSTODY = REQUIRED
NO_FULL_LITERAL_NORMALIZATION
NO_FIRST_HIT
NO_RHO_OR_DENSITY
```
