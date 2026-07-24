# F3 arithmetic-codec full core identity v2 run report v1

Status: `TERMINAL PASS / FULL_CORE_IDENTITY_V2_PASS`

Date: 2026-07-24.

## 1. Custody and exact scope

```text
branch = codex/hilo2-f3-full-core-identity-v2
parent terminal commit = 9ae5027f8e828fc3d42b099e6740e6665bce1831
public parent PR = https://github.com/Menta2357/collatz-classical/pull/14
required PR base = codex/hilo2-f3-full-core-identity-v1
prepared-input commit = b18e664a3e2541f6715539680381b2bf71da84bd
pre-run custody commit = 78894ce47d35b7d83d1475bca14b73c1ac7215d2
public v2 draft PR = https://github.com/Menta2357/collatz-classical/pull/15
public v2 prepared head = b18e664a3e2541f6715539680381b2bf71da84bd
terminal commit = FUTURE_PUBLIC_HEAD_CONTAINING_THIS_TERMINAL_REPORT
```

This package repairs only the two elaboration failures recorded after the v1
literal normalization had survived.  The source uses `List.length_ofFn`
directly and fixes the exact real-valued folding function, permutation,
commutativity proof and initial value in `List.Perm.foldr_eq'`.

No theorem statement, definition, literal data, decoder, rank, formula list,
matrix construction, audit declaration or inventory entry changed.  This
PASS establishes the finite 243-source/729-edge permutation and matrix
identity with the terminal profiles recorded below.  It authorizes only the
preparation of a separate public first-hit execution contract, not first-hit
itself, exponent 0.848, density, almost all, or Collatz.

All five phases were invoked exactly once after public custody and Gate 0.
No retry, resource increase, cleanup or runtime-log edit occurred.

## 2. Frozen source and operational package

```text
identity source = 6bfd513abedf81c980e818b20efff46fc720dafabb710031c0e5aba1d5abffad
unchanged identity audit = 7a712c1844f799e43c4be26707b4ea71b5c424322c010098bdc48843ce4e2796
unchanged declaration inventory = 3cf3d62def66d381f609192ae44114afe6b43e455fa2b2ff11847618723aa7a4
whole-log guard v2 = b064ecce31dd3d15b707b49b9ba3a0521d0070f8e46f138ac045499445e29b70
guard regression = 8f281c679fc06562be4b3a3608d99798e02492089811c0ad696533947fff56bc
wrapped-bad fixture = b8f9116a885f21db8cbc387b8d16ce8247312c5ad2c5726ec376e3059e99ef0c

v2 overlay stage = 9cb0da0964be1528ef71a1232256719757ce84dd10b7a142260223c59198b7c7
v2 compile wrapper = 7a7cb21807a188d51b5efadf711c9d765c1e0bb9d765da1f46b0382241282e3d
v2 audit wrapper = 3dc1cfd4d673954ab5015f4eea2b1befa88f0040d1556ed7079faf949e5f3347
v2 inventory checker = b5e46c42b9b139b0ec203483283c2eb7e19b5bfa7075b7612b1b9cb5e21ca83a
v2 phase executor = 77e605f6ad947d91de9a9bf9a6f7e5d6ee704c47ab6f174493c1cedef6878ed2
v2 static review = bc646e83e2cd760e89edaae5bca59d40ee9e05947108696848cfce1e46065da9
v2 contract = 5cfae0dd964320accaf58ed1b1f72bc19f28b1898acd589d589836432086708c
pre-run report sha256 = a49a7ca2a23404154d38cf5607b3ce7fa6373dbeab7c9599f1df2bfc3ce9eae5
```

The contract hash is external to the contract itself.  The pre-run report
hash above identifies the exact version published at `78894ce`; this terminal
version deliberately omits its own future commit/hash to avoid self-reference.

## 3. Immutable parent evidence

```text
v1 terminal report = 008f88f525e431717e6f4954c400c2de6ff47ca1e950ee8c14c3a27616e23e3a
v1 terminal report bytes = 10193
v1 R0 log = 6cc31ee430fb5a0c28032bdc5b6a91387f15a62f37653c3b7d4d1e23c5ab55f3
v1 R0 log bytes = 603
v1 S0 log = 6cff016f93d41eb24ef8daae893c86ab1ec27bd76a20f1e3c2ab34b4e9de2963
v1 S0 log bytes = 2233
v1 C0 STOP log = fb0a2e3f780d65bdf2310fdf5916002797b76fb84a0408447c0afbd66a3cfa20
v1 C0 STOP log bytes = 3601
v1 identity source = df1e2a1582e02c9c73c354ecb72705bd828a61ab53501bd88a7d2bf6e654937b
```

The v1 result remains `FULL_CORE_IDENTITY_COMPILE_STOP`: R0 and S0 passed,
C0 exited 1 after 121.63 seconds, and A1/K1 were not invoked.  This v2 package
does not edit, relabel, reuse or remove any v1 runtime artifact.

## 4. Frozen upstream objects and environment

The new overlay path is:

```text
.lake/f3-full-core-identity-v2-overlay/lib/lean
```

S0 must create it directly from the terminal-PASS FullBlockDecoder overlay,
not from the v1 STOP overlay.  Its initial objects are:

```text
ExactCoreMatrix olean = 34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
PilotRepair olean = 480e605a5e3db74a1edf9ecce7f535b8f8c057965498ac5f73e787322c144372
FullBlockDecoder olean = 225e7cbca64ec5d9ad7e609fdc08bcf60401cbd356f2d4bd20d74b51662bc8ec

decoder-v6 audit log = 76493a39a7e90e1eb833ba4c59112b9061204c66dcee8babee7f659ddde47ace
decoder source = 1715e45e2395f25bf4d4ac0e27c6ae9cc0dff3fc651e67e1e666be1684541ed1
pilot repair source = e5683405008b438d8a7c00747e4e81384962d95ced0d759d42c18f05ff62219c
ExactCoreMatrix source = 58ab7b1acdb7bc6d69fffa04c4baa7ae29ac31e24e80834387974113b70d2ba5
first-hit paper gate = b5f022271bbd696df2a1b2e9205a36d8ad134e058fe29adbf5b1565f167c44fa
donor lake-manifest = 230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b
lean-toolchain = d24fed434d3b13adfaab57724a0a7f270ea8bf1c818b5ae5cf25cbce24dd685c
```

These ignored objects make the run a local-artifact continuation, not a
fresh-clone reproduction.  Before R0, Gate 0 verified their existence,
regular-file status and hashes, the absence of the v2 overlay, later-root
isolation, the disk floor and process isolation.

## 5. Terminal invocation ledger

```text
PRECONTRACT_TEXTUAL_REVIEW_ROUNDS = 3
PRECONTRACT_FILE_HASH_READS = PERFORMED
PRECONTRACT_SCRIPT_EXECUTIONS = 0
PRECONTRACT_CHECKER_EXECUTIONS = 0
PRECONTRACT_GUARD_EXECUTIONS = 0
PRECONTRACT_BASH_N_EXECUTIONS = 5
PHASE_EXECUTOR_INVOCATIONS = 5
R0_INVOCATIONS = 1
S0_INVOCATIONS = 1
C0_INVOCATIONS = 1
A1_INVOCATIONS = 1
K1_INVOCATIONS = 1
GUARD_REGRESSION_INVOCATIONS = 1
INVENTORY_CHECKER_INVOCATIONS = 1
LEAN_INVOCATIONS = 2
LAKE_INVOCATIONS = 0
RETRIES = 0
RUNTIME_LOG_EDITS = 0
BUDGET_INCREASES = 0
POST_RUN_CLEANUPS = 0
```

Before execution, each v2 script was parsed exactly once and all five returned
zero.  R0 through K1 were then invoked once each through the sole executor.
The only Lean invocations were C0 and A1; no Lake command was invoked.

## 6. Contracted commands

The sole phase routes used, once each and in order, were:

```sh
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_v2_phase_executor_v1.sh' R0
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_v2_phase_executor_v1.sh' S0
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_v2_phase_executor_v1.sh' C0
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_v2_phase_executor_v1.sh' A1
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_v2_phase_executor_v1.sh' K1
```

The phase caps were 60/120/600/450/60 seconds.  The source fixed 200000
heartbeats and recursion depth 100000.  No direct wrapper invocation, retry,
cleanup, log replacement or resource increase occurred.

## 7. Terminal total tables

### Runtime logs

```text
v2_guard_regression_raw.txt = sha256:063b5c6be16d5664d9fad229477ee5da6978e417f6a66361b28711831f6e599e size:6612
v2_overlay_stage_raw.txt = sha256:8f3647dc1c69568aa2a28b5eff825c401d3767b135793da73266ce3a561efec3 size:8527
v2_compile_raw.txt = sha256:a652993106d17ce076588b1237d5174204c0b7a73666fad1ce8244092f0b2be1 size:9838
v2_axiom_audit_raw.txt = sha256:b40135db06b68af4e98ec9b86491bb076bad9cfc447de15ee23f897e5ca5266e size:14931
v2_axiom_log_checker.txt = sha256:d6fcc493b41dbf0a8823fd9e9ed0407c034b602733cf15a0e52c1a3cd993bc99 size:11317
```

### V2-overlay objects

```text
F3ReturnExcursionExactCoreMatrix.olean = sha256:34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798 size:1967392
F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean = sha256:480e605a5e3db74a1edf9ecce7f535b8f8c057965498ac5f73e787322c144372 size:5197264
F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.olean = sha256:225e7cbca64ec5d9ad7e609fdc08bcf60401cbd356f2d4bd20d74b51662bc8ec size:814224
F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity.olean = sha256:b97217ba7cd34ce4d1d5b2c4dc76a31537d6be1693eb51eda523256df6597a18 size:68416
F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity.ilean = sha256:14b544ac1b712c7957395f137fddef465b6d091b5bf8b4ff68d1ec6e9b73b22e size:9417
F3ReturnExcursionCoreArithmeticCodecFullCoreIdentityAxiomAudit.olean = sha256:e5faa23b89e15022d2829246caba57314656f06386c90ca42cafddd9e876184b size:36304
F3ReturnExcursionCoreArithmeticCodecFullCoreIdentityAxiomAudit.ilean = sha256:745d80fbe26d211cb8e051b04bd5bc30b9f07caa3e99a8852498b6f4aecb4d3c size:3518
```

Actual overlay inventory: exactly the seven regular files listed above under
`CollatzClassical/KL2003/`, with zero symlinks and zero unexpected or partial
entries.

### Seven designated terminal profiles

```text
coreEdges_position_normalization = [propext,Classical.choice,Quot.sound]
coreEdges_length_kernel = [propext,Classical.choice,Quot.sound]
core_position_at_formula = [propext,Classical.choice,Quot.sound]
realize_mem_coreEdges = [propext,Classical.choice,Quot.sound]
formulaCoreList_subset_coreEdges = [propext,Classical.choice,Quot.sound]
coreEdges_perm_formulaCoreList = [propext,Classical.choice,Quot.sound]
coreMatrix_eq_fullFormulaMatrix = [propext,Classical.choice,Quot.sound]
```

The linked audit reported 11 namespace declarations, 11 profiles and 11
unique names in the complete audit log.  The static source/inventory/audit
coverage is 9/9/9, and all seven designated terminal theorem profiles are
allowed.  The whole log contains neither `Lean.ofReduceBool` nor `sorryAx`.

## 8. Recorded phase verdicts

```text
R0 = PASS
  precheck/wrapper = 0/0
  namespace/profile/unique-name counts = 640/640/640
  decoder-v6 log = PASS
  forbidden fixture = REJECTED
  elapsed real = 0.01 s / 60 s cap

S0 = PASS
  precheck/wrapper = 0/0
  overlay regular-file/symlink counts = 3/0
  donor hashes = 3/3 MATCH
  elapsed real = 0.13 s / 120 s cap

C0 = PASS
  precheck/preflight = 0/PASS
  Lean/wrapper = 0/0
  overlay regular-file/symlink counts = 5/0
  source and upstream hashes = MATCH
  elapsed real = 112.22 s / 600 s cap

A1 = PASS
  precheck/preflight = 0/PASS
  Lean/wrapper = 0/0
  C0 input objects = 2/2 MATCH
  overlay regular-file/symlink counts = 7/0
  elapsed real = 255.83 s / 450 s cap

K1 = PASS
  precheck/wrapper = 0/0
  source/inventory/audit = 9/9/9
  designated profiles = 7/7 ALLOWED
  complete-log forbidden axioms = ABSENT
  linked overlay objects = 7/7 MATCH
  elapsed real = 0.28 s / 60 s cap
```

## 9. Terminal disposition and exact scope

The contracted finite identity survived compilation and total linked audit.
The result is a reusable local `.olean` continuation whose public source and
contract are already custodied in the draft PR.  The five immutable logs and
this terminal report must now be fast-forwarded to that same PR.  The ignored
objects themselves are local artifacts, so this is not a fresh-clone binary
reproduction claim.

This PASS proves the exact finite permutation between the frozen core edge
list and the formula-generated list and the resulting `Fin 243 → Fin 243 → ℝ`
matrix equality.  It does not test or prove the predeclared first-hit
inequality.  That next gate remains forbidden until a separate execution
contract is frozen and published.

```text
NO_RETRY
FULL_CORE_IDENTITY_V2_PASS
MATRIX_IDENTITY_AUDIT_PASS
NO_FIRST_HIT
NO_F3_EXPONENT
NO_DENSITY
NO_GLOBAL_COLLATZ_CLAIM
```
