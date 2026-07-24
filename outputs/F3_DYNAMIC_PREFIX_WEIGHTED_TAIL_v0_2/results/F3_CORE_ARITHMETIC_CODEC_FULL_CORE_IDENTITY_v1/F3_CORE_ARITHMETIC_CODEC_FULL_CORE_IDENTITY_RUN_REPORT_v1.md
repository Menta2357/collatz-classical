# F3 arithmetic-codec full core identity run report v1

Status: `PRE_RUN_FROZEN / NOT_EXECUTED`

Date: 2026-07-24.

## 1. Public custody and exact scope

```text
branch = codex/hilo2-f3-full-core-identity-v1
public parent PR = https://github.com/Menta2357/collatz-classical/pull/13
public parent head = 39904f70fdfa1ec241d964fb36cbfbb862960ef6
prepared-input commit = 2807b14a7448bca032c37ed4e07dc284bbf41d2a
pre-run report commit = the public PR head containing this file
```

This gate tests the sole 729-entry positional normalization and derives the
finite permutation and matrix identity.  It proves no first-hit inequality,
F3 exponent, density statement or global Collatz claim.  PASS would authorize
only a new, separately published execution contract for the already
predeclared first-hit gate.

## 2. Frozen tracked inputs

```text
identity source = df1e2a1582e02c9c73c354ecb72705bd828a61ab53501bd88a7d2bf6e654937b
identity audit = 7a712c1844f799e43c4be26707b4ea71b5c424322c010098bdc48843ce4e2796
declaration inventory = 3cf3d62def66d381f609192ae44114afe6b43e455fa2b2ff11847618723aa7a4
inventory checker = 2da25a2ea0bae570057b7be8a5f4102694eeb681e49eb36988ffd95caec9456c
overlay stage = 1633ddeba4552e2b81e802b05454f9d2861efa3bac4fde6b169090e7dda0407e
compile wrapper = cfc6a1a353d830820cb42cf05ef6605eda15333cfa7a00eac681c4cfda2f3fbf
audit wrapper = 97f5fa1fd207ab1e59a534d1a11c903ee2384542add1d8ca69c7dedd61cd1b93
phase executor = e1c67e8d24851bb311f027c2d7ca11f51e437dad09c2fbf44f810bceb10b68ea
contract = b3bf6985d7a31f26ea40aa8817467c89b569bc79764dad6c2dff632a234609ca
static review = 7ee826aecc60356573532fb9ccd393800ed853f2c83b9968da49d9a6d0d78131
whole-log guard v2 = b064ecce31dd3d15b707b49b9ba3a0521d0070f8e46f138ac045499445e29b70
guard regression = 8f281c679fc06562be4b3a3608d99798e02492089811c0ad696533947fff56bc
wrapped-bad fixture = b8f9116a885f21db8cbc387b8d16ce8247312c5ad2c5726ec376e3059e99ef0c
decoder-v6 audit log = 76493a39a7e90e1eb833ba4c59112b9061204c66dcee8babee7f659ddde47ace
decoder terminal report = b55c0368f96235978ef323979d4f0e706dad06aac796ac23fa76fba161da32bf
decoder source = 1715e45e2395f25bf4d4ac0e27c6ae9cc0dff3fc651e67e1e666be1684541ed1
pilot repair source = e5683405008b438d8a7c00747e4e81384962d95ced0d759d42c18f05ff62219c
ExactCoreMatrix source = 58ab7b1acdb7bc6d69fffa04c4baa7ae29ac31e24e80834387974113b70d2ba5
first-hit paper gate = b5f022271bbd696df2a1b2e9205a36d8ad134e058fe29adbf5b1565f167c44fa
```

## 3. Frozen upstream objects and environment

```text
ExactCoreMatrix olean = 34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
PilotRepair olean = 480e605a5e3db74a1edf9ecce7f535b8f8c057965498ac5f73e787322c144372
FullBlockDecoder olean = 225e7cbca64ec5d9ad7e609fdc08bcf60401cbd356f2d4bd20d74b51662bc8ec
donor lake-manifest = 230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b
lean-toolchain = d24fed434d3b13adfaab57724a0a7f270ea8bf1c818b5ae5cf25cbce24dd685c
```

These ignored objects make the gate a local-artifact continuation, not a
fresh-clone reproduction.  The new overlay was absent before this report
directory was created.  The result directory then contained only this report;
all runtime logs and all seven new-overlay objects were absent.  The measured
free space was 28,380,596 KiB, above the 4 GiB gate.  Later `LEAN_PATH` roots
contained no `CollatzClassical/` directory.  The competing-Lean process check
remains a mandatory just-in-time Gate-0 check after public custody.

## 4. Invocation ledger before R0

```text
PRECONTRACT_STATIC_INVENTORY_CHECKS = 1
PRECONTRACT_BASH_SYNTAX_REVIEW_ROUNDS = 5
R0_INVOCATIONS = 0
S0_INVOCATIONS = 0
C0_INVOCATIONS = 0
A1_INVOCATIONS = 0
K1_INVOCATIONS = 0
LEAN_INVOCATIONS = 0
LAKE_INVOCATIONS = 0
```

No Lean, Lake, guard regression or phase executor was invoked while drafting
or reviewing this gate.

## 5. Only authorized commands

```sh
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_phase_executor_v1.sh' R0
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_phase_executor_v1.sh' S0
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_phase_executor_v1.sh' C0
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_phase_executor_v1.sh' A1
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_phase_executor_v1.sh' K1
```

The internal caps are respectively 60, 120, 600, 450 and 60 seconds.  The
source fixes 200000 heartbeats and recursion depth 100000.  Each phase log is
created with `noclobber` before its fail-fast precheck, so a precheck failure,
timeout, nonzero exit or postcheck failure consumes that phase and is terminal
STOP.  Direct wrapper invocation, retry, log removal, source/resource change
or cleanup after R0 is forbidden.

## 6. Pre-run total tables

### Runtime logs

```text
v1_guard_regression_raw.txt = ABSENT_NOT_INVOKED
v1_overlay_stage_raw.txt = ABSENT_NOT_INVOKED
v1_compile_raw.txt = ABSENT_NOT_INVOKED
v1_axiom_audit_raw.txt = ABSENT_NOT_INVOKED
v1_axiom_log_checker.txt = ABSENT_NOT_INVOKED
```

### New-overlay objects

```text
F3ReturnExcursionExactCoreMatrix.olean = ABSENT_NOT_INVOKED
F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean = ABSENT_NOT_INVOKED
F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.olean = ABSENT_NOT_INVOKED
F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity.olean = ABSENT_NOT_INVOKED
F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity.ilean = ABSENT_NOT_INVOKED
F3ReturnExcursionCoreArithmeticCodecFullCoreIdentityAxiomAudit.olean = ABSENT_NOT_INVOKED
F3ReturnExcursionCoreArithmeticCodecFullCoreIdentityAxiomAudit.ilean = ABSENT_NOT_INVOKED
```

Actual new-overlay inventory: `ABSENT_NOT_INVOKED`.

### Seven designated terminal profiles

```text
coreEdges_position_normalization = ABSENT_NOT_INVOKED
coreEdges_length_kernel = ABSENT_NOT_INVOKED
core_position_at_formula = ABSENT_NOT_INVOKED
realize_mem_coreEdges = ABSENT_NOT_INVOKED
formulaCoreList_subset_coreEdges = ABSENT_NOT_INVOKED
coreEdges_perm_formulaCoreList = ABSENT_NOT_INVOKED
coreMatrix_eq_fullFormulaMatrix = ABSENT_NOT_INVOKED
```

## 7. Terminal rule

The first failed phase stops the sequence.  The report will replace every
created entry above with its exact hash/size or profile and every unreachable
entry with `ABSENT_PHASE_STOP`.  PASS requires complete 5/5 logs, 7/7 objects
and 7/7 allowed terminal profiles, plus
`FULL_CORE_IDENTITY_K1_WRAPPER_EXIT_STATUS=0`.  PASS or STOP must be
fast-forwarded with every immutable created log to the same public draft PR.
