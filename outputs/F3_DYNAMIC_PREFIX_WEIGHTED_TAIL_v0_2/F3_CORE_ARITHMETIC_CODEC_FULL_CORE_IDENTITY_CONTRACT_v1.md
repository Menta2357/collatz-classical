# F3 arithmetic-codec full core identity contract v1

Status: `AUTHORIZED / FULL_LITERAL_AND_MATRIX_ONLY / NOT_EXECUTED`

Date: 2026-07-24.

## 1. Custody, target and non-claims

```text
branch = codex/hilo2-f3-full-core-identity-v1
parent terminal = 39904f70fdfa1ec241d964fb36cbfbb862960ef6
public parent custody = https://github.com/Menta2357/collatz-classical/pull/13
```

The target is the exact finite identity between the historical 243-source,
729-edge frozen core and the arithmetic formula generator.  The source has a
single full-literal normalization:

```lean
coreEdges = List.ofFn corePositionRealize := by
  rfl
```

Coverage, matching cardinality and formula-side Nodup then yield
`coreEdges.Perm formulaCoreList`; filtering and commutative folding yield the
matrix identity.  No historical native edge-count/channel theorem enters the
proof cone.

A PASS opens only a separately frozen execution contract for the predeclared
first-hit gate.  It does not prove first-hit, the F3 exponent, density, almost
all, or Collatz.

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
static review = 7ee826aecc60356573532fb9ccd393800ed853f2c83b9968da49d9a6d0d78131
whole-log guard v2 = b064ecce31dd3d15b707b49b9ba3a0521d0070f8e46f138ac045499445e29b70
guard regression = 8f281c679fc06562be4b3a3608d99798e02492089811c0ad696533947fff56bc
wrapped-bad fixture = b8f9116a885f21db8cbc387b8d16ce8247312c5ad2c5726ec376e3059e99ef0c
decoder terminal report = b55c0368f96235978ef323979d4f0e706dad06aac796ac23fa76fba161da32bf
decoder-v6 audit log = 76493a39a7e90e1eb833ba4c59112b9061204c66dcee8babee7f659ddde47ace
decoder source = 1715e45e2395f25bf4d4ac0e27c6ae9cc0dff3fc651e67e1e666be1684541ed1
pilot repair source = e5683405008b438d8a7c00747e4e81384962d95ced0d759d42c18f05ff62219c
ExactCoreMatrix source = 58ab7b1acdb7bc6d69fffa04c4baa7ae29ac31e24e80834387974113b70d2ba5
first-hit paper gate = b5f022271bbd696df2a1b2e9205a36d8ad134e058fe29adbf5b1565f167c44fa
```

Static coverage is exactly 9/9/9 declarations and seven designated terminal
theorems.  The checker accepts genuinely empty axiom profiles, captures
multiline profiles, and allows on terminal theorems only `propext`,
`Classical.choice` and `Quot.sound`.

## 3. Frozen local objects and environment

The new overlay starts with exactly these three regular `.olean` files copied
from the decoder PASS overlay:

```text
ExactCoreMatrix olean = 34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
PilotRepair olean = 480e605a5e3db74a1edf9ecce7f535b8f8c057965498ac5f73e787322c144372
FullBlockDecoder olean = 225e7cbca64ec5d9ad7e609fdc08bcf60401cbd356f2d4bd20d74b51662bc8ec
donor lake-manifest = 230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b
lean-toolchain = d24fed434d3b13adfaab57724a0a7f270ea8bf1c818b5ae5cf25cbce24dd685c
```

Overlay path:
`.lake/f3-full-core-identity-overlay/lib/lean`.  The frozen `LEAN_PATH`
inside the wrappers puts it first, followed only by the nine package roots
`Cli`, `batteries`, `Qq`, `aesop`, `proofwidgets`, `importGraph`,
`LeanSearchClient`, `plausible`, `mathlib`, and the Lean 4.21.0 toolchain.
No later root may contain `CollatzClassical/`; neither the local/donor build
root nor the preceding overlay is in `LEAN_PATH`.

This is local-artifact continuity, not fresh-clone reproduction.

## 4. Gate 0 and publication before execution

Before R0 all of the following must hold:

1. branch, base and HEAD are recorded; the worktree is clean;
2. source, audit, all scripts, inventory, contract, static review and a
   `PRE_RUN_FROZEN / NOT_EXECUTED` report are committed and pushed to a draft
   PR stacked on the public parent branch;
3. the new overlay is absent;
4. the result directory exists, is a regular directory and contains only the
   pre-run report; the five runtime logs are absent;
5. identity/audit `.olean` and `.ilean` targets are absent;
6. every frozen hash above matches and all three upstream objects are regular
   non-symlinks;
7. later `LEAN_PATH` roots contain zero `CollatzClassical/` directories;
8. at least 4 GiB is free and no other Lean process is running.

Gate-0 failure is `GATE0_ENVIRONMENT_STOP` and consumes no phase attempt.
If all Gate-0 checks pass but an input drifts before or during R0, the
executor creates the R0 log first; its failing precheck is then a consumed
terminal R0 STOP.

The report path is
`outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_FULL_CORE_IDENTITY_v1/F3_CORE_ARITHMETIC_CODEC_FULL_CORE_IDENTITY_RUN_REPORT_v1.md`.

## 5. The only authorized executor

Direct invocation of the overlay, compile, audit, checker or guard scripts is
forbidden after publication.  Each phase must be invoked once, in order, only
through the frozen executor:

```sh
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_phase_executor_v1.sh' R0
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_phase_executor_v1.sh' S0
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_phase_executor_v1.sh' C0
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_phase_executor_v1.sh' A1
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_phase_executor_v1.sh' K1
```

The executor creates each phase log with `noclobber` before its phase
precheck, records that precheck status, applies `gtimeout --kill-after=5`
only after precheck PASS, appends the outer exit status and refuses to run the
next phase unless the prior log has unique PASS/zero markers.  Deleting,
renaming, truncating or replacing a phase log to permit a second invocation
is forbidden.

## 6. Frozen phases and acceptance

### R0 — guard regression, 60 seconds

PASS requires the real decoder-v6 audit log to pass at 640/640/640, the
multiline forbidden fixture to be rejected, `V2_GUARD_REGRESSION=PASS`, and
`FULL_CORE_IDENTITY_R0_WRAPPER_EXIT_STATUS=0`.

### S0 — overlay stage, 120 seconds

PASS requires exactly three regular files, zero symlinks, all three frozen
hashes, `FULL_CORE_IDENTITY_OVERLAY_STAGE=PASS`, and
`FULL_CORE_IDENTITY_S0_WRAPPER_EXIT_STATUS=0`.

### C0 — sole identity compilation, 600 seconds

The source itself fixes `maxHeartbeats 200000` and `maxRecDepth 100000`.
PASS requires internal and outer exit status zero, the literal normalization
to elaborate, exactly five regular overlay files, zero symlinks, unchanged
source/upstream hashes, and recorded identity `.olean`/`.ilean` hashes.

Any mismatch at the literal is `FULL_LITERAL_NORMALIZATION_STOP`; any other
nonzero/timeout/elaboration result is `FULL_CORE_IDENTITY_COMPILE_STOP`.
A1 and K1 remain forbidden after either STOP.

### A1 — sole total audit, 450 seconds

A1 must bind the unique C0 PASS record to the current source and identity
objects before invoking Lean.  PASS requires internal and outer status zero,
exactly seven regular overlay files, zero symlinks, unchanged source/audit,
upstream and identity hashes, and recorded audit `.olean`/`.ilean` hashes.

### K1 — linked inventory/profile audit, 60 seconds

K1 must bind C0 output to A1 input and compare all seven current overlay
objects to their recorded hashes.  PASS requires 9/9/9, seven of seven
terminal profiles allowed, unique environmental names, whole-log zero
`Lean.ofReduceBool` and `sorryAx`, both checker PASS markers, and
`FULL_CORE_IDENTITY_K1_WRAPPER_EXIT_STATUS=0`.

Any A1/K1 mismatch is `FULL_CORE_IDENTITY_AUDIT_STOP`.

## 7. STOP, custody and terminal scope

The first nonzero exit, timeout, absent marker, duplicate marker, input drift,
hash/count mismatch, symlink, forbidden axiom or profile mismatch is terminal
STOP.  No retry, source/audit/script edit, alternate proof, table, shard,
budget increase, cleanup, log removal, amend, force-push, retarget or merge is
authorized after R0 begins.

PASS or STOP, the report and every created regular log must be committed and
fast-forwarded to the same public draft PR.  The terminal report must contain
a total table for five logs, seven overlay objects and seven designated
terminal profiles.  Each created entry records its hash/size or profile; each
uncreated entry is explicitly `ABSENT_NOT_INVOKED` or `ABSENT_PHASE_STOP`.
Invocation counts are always recorded.  PASS requires complete 5/5, 7/7 and
7/7 tables.  The report also inventories every actual overlay entry,
including any unexpected or partial output left by a STOP.  Runtime logs may
not be edited.

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
NO_FULL_CORE_PASS_YET
NO_FIRST_HIT
NO_F3_EXPONENT
NO_DENSITY
```
