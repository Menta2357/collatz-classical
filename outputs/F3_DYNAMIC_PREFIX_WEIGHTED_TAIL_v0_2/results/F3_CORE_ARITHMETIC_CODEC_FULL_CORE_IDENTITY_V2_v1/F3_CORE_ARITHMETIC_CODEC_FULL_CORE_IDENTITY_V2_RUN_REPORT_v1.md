# F3 arithmetic-codec full core identity v2 run report v1

Status: `PRE_RUN_DRAFT / NOT_EXECUTED / PUBLICATION_AND_GATE0_PENDING`

Date: 2026-07-24.

## 1. Custody and exact scope

```text
branch = codex/hilo2-f3-full-core-identity-v2
parent terminal commit = 9ae5027f8e828fc3d42b099e6740e6665bce1831
public parent PR = https://github.com/Menta2357/collatz-classical/pull/14
required PR base = codex/hilo2-f3-full-core-identity-v1
prepared-input commit = PENDING_FIRST_CUSTODY_COMMIT
pre-run custody commit = PENDING_SECOND_CUSTODY_COMMIT
public v2 draft PR = PENDING_PUBLICATION
public v2 head = PENDING_PUBLICATION
terminal commit = NOT_APPLICABLE_PRE_RUN
```

This package repairs only the two elaboration failures recorded after the v1
literal normalization had survived.  The source uses `List.length_ofFn`
directly and fixes the exact real-valued folding function, permutation,
commutativity proof and initial value in `List.Perm.foldr_eq'`.

No theorem statement, definition, literal data, decoder, rank, formula list,
matrix construction, audit declaration or inventory entry changes.  A PASS
would establish only the finite 243-source/729-edge permutation and matrix
identity.  It would authorize only the preparation of a separate public
first-hit execution contract, not first-hit itself, exponent 0.848, density,
almost all, or Collatz.

Execution is forbidden while the custody fields above remain pending or any
publication/Gate-0 condition in the contract remains unmet.

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
pre-run report sha256 = SELF_REFERENCE_OMITTED_FREEZE_AFTER_CUSTODY
```

The contract hash is external to the contract itself, and the report omits
its own hash to avoid self-reference.  The terminal report, whether PASS or
STOP, must record the exact hash of this pre-run version after publication.

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
fresh-clone reproduction.  Their existence, regular-file status and hashes,
the absence of the v2 overlay, later-root isolation, disk floor and process
isolation remain Gate-0 checks and have not been claimed by this draft.

## 5. Pre-run invocation ledger

```text
PRECONTRACT_TEXTUAL_REVIEW_ROUNDS = 3
PRECONTRACT_FILE_HASH_READS = PERFORMED
PRECONTRACT_SCRIPT_EXECUTIONS = 0
PRECONTRACT_CHECKER_EXECUTIONS = 0
PRECONTRACT_GUARD_EXECUTIONS = 0
PRECONTRACT_BASH_N_EXECUTIONS = 5
R0_INVOCATIONS = 0
S0_INVOCATIONS = 0
C0_INVOCATIONS = 0
A1_INVOCATIONS = 0
K1_INVOCATIONS = 0
LEAN_INVOCATIONS = 0
LAKE_INVOCATIONS = 0
```

Only source/file reads, `apply_patch` writes and five static `bash -n` parses
were used to prepare this package.  Each v2 script was parsed exactly once
and all five returned zero.  No script logic, checker, guard, phase, Lean or
Lake command was invoked.  No overlay, runtime log or generated Lean object
was created.

## 6. Only conditionally authorized commands

After the publication and Gate-0 requirements in the contract are satisfied,
the sole phase routes are:

```sh
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_v2_phase_executor_v1.sh' R0
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_v2_phase_executor_v1.sh' S0
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_v2_phase_executor_v1.sh' C0
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_v2_phase_executor_v1.sh' A1
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_v2_phase_executor_v1.sh' K1
```

The phase caps are 60/120/600/450/60 seconds.  The source fixes 200000
heartbeats and recursion depth 100000.  Every phase is single-attempt,
ordered and terminal on its first failure.  Direct wrapper invocation,
retry, cleanup, log replacement or resource increase is forbidden.

## 7. Pre-run total tables

### Runtime logs

```text
v2_guard_regression_raw.txt = ABSENT_NOT_INVOKED
v2_overlay_stage_raw.txt = ABSENT_NOT_INVOKED
v2_compile_raw.txt = ABSENT_NOT_INVOKED
v2_axiom_audit_raw.txt = ABSENT_NOT_INVOKED
v2_axiom_log_checker.txt = ABSENT_NOT_INVOKED
```

### V2-overlay objects

```text
F3ReturnExcursionExactCoreMatrix.olean = ABSENT_NOT_STAGED
F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean = ABSENT_NOT_STAGED
F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.olean = ABSENT_NOT_STAGED
F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity.olean = ABSENT_NOT_COMPILED
F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity.ilean = ABSENT_NOT_COMPILED
F3ReturnExcursionCoreArithmeticCodecFullCoreIdentityAxiomAudit.olean = ABSENT_NOT_AUDITED
F3ReturnExcursionCoreArithmeticCodecFullCoreIdentityAxiomAudit.ilean = ABSENT_NOT_AUDITED
```

These absence labels describe the intended untouched pre-run state and must
be independently verified at Gate 0 before this report can be promoted from
draft to frozen custody.

### Seven designated terminal profiles

```text
coreEdges_position_normalization = UNKNOWN_NOT_AUDITED
coreEdges_length_kernel = UNKNOWN_NOT_AUDITED
core_position_at_formula = UNKNOWN_NOT_AUDITED
realize_mem_coreEdges = UNKNOWN_NOT_AUDITED
formulaCoreList_subset_coreEdges = UNKNOWN_NOT_AUDITED
coreEdges_perm_formulaCoreList = UNKNOWN_NOT_AUDITED
coreMatrix_eq_fullFormulaMatrix = UNKNOWN_NOT_AUDITED
```

## 8. Pending Gate 0 and terminal discipline

Before R0, custody must replace the pending commit/PR fields with evidence,
freeze the pre-run report version externally, and verify:

- exact public base/head and clean tracked tree;
- exact two-hunk Lean diff and every frozen file hash;
- new overlay absent and result directory containing only this report;
- five logs and seven v2-overlay objects absent;
- three donor objects exact and later `LEAN_PATH` roots isolated;
- at least 4 GiB free and no competing Lean/Lake process.

After R0 begins, any failed precheck, nonzero exit, timeout, missing or
duplicate marker, drift, symlink, count/hash mismatch or forbidden axiom is a
terminal STOP.  The terminal report must inventory every actual log and
overlay entry without cleanup and be fast-forwarded to the same draft PR.

```text
NO_EXECUTION_AUTHORIZATION_YET
NO_RETRY
NO_FULL_CORE_PASS
NO_MATRIX_IDENTITY
NO_AUDIT
NO_FIRST_HIT
NO_F3_EXPONENT
NO_DENSITY
NO_GLOBAL_COLLATZ_CLAIM
```
