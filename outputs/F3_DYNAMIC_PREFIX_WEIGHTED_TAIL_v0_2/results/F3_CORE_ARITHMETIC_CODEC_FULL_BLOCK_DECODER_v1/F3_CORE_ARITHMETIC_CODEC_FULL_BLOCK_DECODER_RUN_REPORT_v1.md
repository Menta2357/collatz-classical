# F3 arithmetic-codec full block decoder run report v1

Status: `PASS / SYMBOLIC_DECODER_ONLY / LOCAL_ARTIFACT_CONTINUATION`

Date: 2026-07-24.

## 1. Public custody and exact scope

```text
branch = codex/hilo2-f3-full-block-decoder-v1
public base PR = https://github.com/Menta2357/collatz-classical/pull/12
public base head = ef39994163d7124b896aca32a02f3b452fd56637
prepared-input commit = cb5a63537407bd59238a8bd365de23da2c4df668
pre-run report commit = 0eff966d51442b1e4daa21541265d4f9d90f2894
public execution custody = https://github.com/Menta2357/collatz-classical/pull/13
```

This is a symbolic decoder gate for the factorization `729 = 9 * 81`.  It
reuses the audited 27-source/81-edge pilot decoder and proves the block shifts
and inverse formulas needed for a later full-core identity gate.

It does **not** prove the 729-entry literal normalization, a full-core
permutation or matrix identity, the first-hit inequality, an F3 exponent, or
any density theorem.  A PASS authorizes only a separately frozen contract for
the full literal identity.

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
contract = f90cca9365bd20b9d49c1544ce38bd5b785f8a81fbc58a1641e28d001e2d984e
independent static review = d6c01cfa75606cc8230b3f4db7ccd61b61a8a0a4c4a892cf14517fa465575fb1
```

## 3. Frozen local objects and environment

```text
pilot repair olean = 480e605a5e3db74a1edf9ecce7f535b8f8c057965498ac5f73e787322c144372
ExactCoreMatrix olean = 34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
donor lake-manifest = 230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b
lean-toolchain = d24fed434d3b13adfaab57724a0a7f270ea8bf1c818b5ae5cf25cbce24dd685c
```

The two `.olean` inputs are ignored local artifacts.  Therefore this run can
establish local-artifact continuity, not fresh-clone reproducibility.  The
overlay and result directory were absent before this report directory was
created.  At freeze time the result directory contained only this report;
there were no runtime logs and the decoder/audit `.olean` and `.ilean`
objects did not exist.

The frozen `LEAN_PATH` below starts with the isolated overlay, followed by
nine dependency-package roots and the Lean toolchain.  No later path root is
the local or donor `CollatzClassical` build root; consequently the decoder can
only see the two explicitly staged `CollatzClassical` objects (one local pilot
object and one donor object) until it writes its own objects.

## 4. Invocation ledger before R0

```text
PRECONTRACT_STATIC_INVENTORY_CHECKS = 1
PRECONTRACT_GUARD_REGRESSION_INVOCATIONS = 1
R0_INVOCATIONS = 0
S0_INVOCATIONS = 0
C0_INVOCATIONS = 0
A1_INVOCATIONS = 0
K1_INVOCATIONS = 0
LAKE_INVOCATIONS = 0
```

The two precontract checks were development-time static shell checks.  They
invoked neither Lean nor Lake, retained no runtime log, caused no adaptive
change after a failure, and do not replace the post-publication R0/K1 gates.

## 5. Frozen execution sequence

R0, once after public custody, with a 60-second cap:

```sh
/opt/homebrew/bin/gtimeout 60 /usr/bin/time -p bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_axiom_audit_log_guard_v2_regression.sh' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_FULL_BLOCK_DECODER_v1/v1_guard_regression_raw.txt' 2>&1
```

S0, once and only after R0 PASS, with a 120-second cap:

```sh
/opt/homebrew/bin/gtimeout 120 /usr/bin/time -p bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_block_decoder_overlay_stage_v1.sh' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_FULL_BLOCK_DECODER_v1/v1_overlay_stage_raw.txt' 2>&1
```

C0, once and only after S0 PASS, with a 300-second wall cap and the source
limits `maxHeartbeats 200000` and `maxRecDepth 100000`:

```sh
/opt/homebrew/bin/gtimeout 300 /usr/bin/time -p env LEAN_PATH='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/f3-full-block-decoder-overlay/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Cli/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/batteries/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Qq/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/aesop/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/proofwidgets/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/importGraph/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/plausible/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/mathlib/.lake/build/lib/lean:/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean' /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean --root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3' -o '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/f3-full-block-decoder-overlay/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.olean' -i '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/f3-full-block-decoder-overlay/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.ilean' '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.lean' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_FULL_BLOCK_DECODER_v1/v1_compile_raw.txt' 2>&1
```

A1, once and only after C0 PASS, with a 300-second cap:

```sh
/opt/homebrew/bin/gtimeout 300 /usr/bin/time -p env LEAN_PATH='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/f3-full-block-decoder-overlay/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Cli/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/batteries/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Qq/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/aesop/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/proofwidgets/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/importGraph/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/plausible/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/mathlib/.lake/build/lib/lean:/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean' /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean --root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3' -o '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/f3-full-block-decoder-overlay/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoderAxiomAudit.olean' -i '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/f3-full-block-decoder-overlay/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoderAxiomAudit.ilean' '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoderAxiomAudit.lean' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_FULL_BLOCK_DECODER_v1/v1_axiom_audit_raw.txt' 2>&1
```

K1, once and only after A1 PASS, with a 60-second cap:

```sh
/opt/homebrew/bin/gtimeout 60 /usr/bin/time -p bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_block_decoder_inventory_check_v1.sh' --audit-log '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_FULL_BLOCK_DECODER_v1/v1_axiom_audit_raw.txt' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_FULL_BLOCK_DECODER_v1/v1_axiom_log_checker.txt' 2>&1
```

## 6. Acceptance and STOP rule

R0 must accept the real v6 audit log with 640 profiles and reject the wrapped
bad fixture.  S0 must stage exactly two regular files, zero symlinks and the
two frozen hashes.  C0 must exit zero and leave exactly four overlay files,
zero symlinks, with decoder `.olean` and `.ilean` present.  A1 must exit zero.
K1 must report 30/30/30 declarations, 5/5 terminal theorems, one unique
profile for every environmental namespace declaration, and whole-log zero
occurrences of `Lean.ofReduceBool` and `sorryAx`.  The five terminal theorem
profiles will also be recorded explicitly in the terminal report.

The first nonzero exit, timeout, missing artifact, input drift, count/hash
mismatch or forbidden occurrence is terminal STOP.  No retry, edit, alternate
proof, budget change, cleanup, amend, force-push, retarget, merge or later
phase is authorized after R0 begins.  PASS or STOP, the immutable logs and
terminal report must be fast-forwarded to the same public draft PR.

## 7. Terminal invocation ledger and phase results

```text
PRECONTRACT_STATIC_INVENTORY_CHECKS = 1
PRECONTRACT_GUARD_REGRESSION_INVOCATIONS = 1
R0_INVOCATIONS = 1
S0_INVOCATIONS = 1
C0_INVOCATIONS = 1
A1_INVOCATIONS = 1
K1_INVOCATIONS = 1
LAKE_INVOCATIONS = 0
RETRIES = 0
POST_R0_SOURCE_EDITS = 0
POST_R0_BUDGET_CHANGES = 0
```

All five authorized phases ran once, in order, from the public pre-run head.
No phase failed or timed out, and no prohibited continuation occurred.

```text
R0 = PASS; exit 0; real 0.01s; 640/640/640; good log accepted; bad fixture rejected
S0 = PASS; exit 0; real 0.10s; 2 regular files; 0 symlinks; 2/2 hashes exact
C0 = PASS; exit 0; real 140.71s; 4 regular files; 0 symlinks
A1 = PASS; exit 0; real 241.12s; audit objects present; terminal profiles emitted
K1 = PASS; exit 0; real 0.03s; 30/30/30; 5/5; 124/124/124; forbidden axioms absent
```

After A1 the overlay contains exactly six regular files and zero symlinks.
The two staged inputs retained their frozen hashes throughout.

## 8. Terminal artifact hashes

```text
R0 log (11 lines, 258 bytes) = 64ca372320da664bde3065a826e4b9d2c86f53bb1ff30e8883adda23ab3853c7
S0 log (37 lines, 1480 bytes) = 59a7134f62a11df5ea4a48871f78595fa6c5f324387620f299d616557c0d1b1a
C0 log (3 lines, 32 bytes) = 5cbbd296d3893cb23c5f7dead6be5c7c0d35c5c31b03a80ab3b82c07809da3a3
A1 log (251 lines, 18799 bytes) = cb1474bf1d70fbc336b3d2c21cf7d8b5dc4729edad8e6f8dbbe49b68faae68c8
K1 log (18 lines, 544 bytes) = 045d55872b4465b326a025bc63ff592f185b80dbedf7f08e46eaca286570d846
decoder olean = 225e7cbca64ec5d9ad7e609fdc08bcf60401cbd356f2d4bd20d74b51662bc8ec
decoder ilean = 20cad64e00ba1826e30b7d686e03a1341516bb8e680fa03f8b0b2cf0e4222ffe
audit olean = dba6fe1b8badd53ef43a5bce8717a7abcdc06c776fde830cd4d0840b6b9256f9
audit ilean = 6b63ac833f29a942a656ebdd5a04354758c3cc19c4bd48650b7b71b909c95b55
```

## 9. Five designated terminal theorem profiles

```text
liftPilotEdge_edgeBlock_edgeLocal = [propext, Classical.choice, Quot.sound]
frozenPos_liftPilotEdge = [propext, Quot.sound]
frozenPos_eq_joinPosition = [propext, Classical.choice, Quot.sound]
corePositionUnrank_frozenPos = [propext, Classical.choice, Quot.sound]
corePositionToRank_frozenPos = [propext, Classical.choice, Quot.sound]
```

The whole A1 log has 124 environmental namespace declarations, 124 profiles
and 124 unique profile names.  It contains zero occurrences of
`Lean.ofReduceBool` and `sorryAx`.

## 10. Calibrated verdict

`FULL_BLOCK_SYMBOLIC_DECODER_GATE = PASS`.

The machine-checked result is the symbolic decoder and its left-inverse law:
it recovers every formula edge from that edge's frozen position in the
243-source/729-edge type, using the audited 81-edge pilot blocks.  This
removes that decoding risk before any full literal normalization is
attempted.

The gate remains dependent on two ignored staged objects and therefore is not
a fresh-clone result.  It does not establish that the frozen 729-entry
`coreEdges` literal is `List.ofFn corePositionRealize`; that normalization,
the resulting permutation/matrix identity, and the predeclared first-hit gate
remain separate future gates.  No F3 exponent or density theorem follows from
this PASS alone.
