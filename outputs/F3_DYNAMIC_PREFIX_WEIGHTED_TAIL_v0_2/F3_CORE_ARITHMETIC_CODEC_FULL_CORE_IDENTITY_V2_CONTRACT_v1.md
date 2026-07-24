# F3 arithmetic-codec full core identity v2 contract v1

Status: `CONDITIONALLY_AUTHORIZED / EXECUTION_BLOCKED_PENDING_PUBLICATION_AND_GATE0 / NOT_EXECUTED`

Date: 2026-07-24.

## 1. Custody, target and non-claims

```text
branch = codex/hilo2-f3-full-core-identity-v2
parent terminal = 9ae5027f8e828fc3d42b099e6740e6665bce1831
public parent custody = https://github.com/Menta2357/collatz-classical/pull/14
required PR base = codex/hilo2-f3-full-core-identity-v1
```

This is a separately frozen successor to the immutable v1 C0 STOP.  It tests
the same finite identity between the historical 243-source/729-edge frozen
core and the arithmetic formula generator, changing only the two proof
bodies that failed to elaborate after the literal normalization had
succeeded.

A PASS establishes only the finite permutation and matrix identity.  It may
open a new, separately frozen and publicly custodied execution contract for
the predeclared first-hit gate.  It does not prove first-hit, the F3 exponent,
density, almost all, or Collatz.

## 2. Sole source repair

Against the parent STOP, the Lean diff is exactly two proof hunks and
`+9/-4`.  No statement, definition, import, namespace, declaration name,
literal data, rank, decoder, formula list or matrix definition changes.

The first failed proof is replaced exactly by:

```lean
theorem coreEdges_length_kernel : coreEdges.length = 729 := by
  rw [coreEdges_position_normalization]
  exact List.length_ofFn
```

The second is replaced by the explicitly typed core theorem application:

```lean
exact List.Perm.foldr_eq'
  (f := fun (e : CoreEdge) (acc : ℝ) =>
    channelWeight e.channel + acc)
  (coreEdges_perm_formulaCoreList.filter
    (fun e => e.source = s ∧ e.target = t))
  (fun x _ y _ z =>
    add_left_comm (channelWeight y.channel)
      (channelWeight x.channel) z)
  (0 : ℝ)
```

The source remains free of `native_decide`, `Lean.ofReduceBool`, `sorry`,
`admit`, a new axiom, `find?`, lookup tables, arrays, CSV data, `fin_cases`,
the historical native certificates and `ac_rfl`.

## 3. Frozen tracked inputs

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

v1 terminal report = 008f88f525e431717e6f4954c400c2de6ff47ca1e950ee8c14c3a27616e23e3a
v1 R0 log = 6cc31ee430fb5a0c28032bdc5b6a91387f15a62f37653c3b7d4d1e23c5ab55f3
v1 S0 log = 6cff016f93d41eb24ef8daae893c86ab1ec27bd76a20f1e3c2ab34b4e9de2963
v1 C0 STOP log = fb0a2e3f780d65bdf2310fdf5916002797b76fb84a0408447c0afbd66a3cfa20

decoder-v6 audit log = 76493a39a7e90e1eb833ba4c59112b9061204c66dcee8babee7f659ddde47ace
decoder source = 1715e45e2395f25bf4d4ac0e27c6ae9cc0dff3fc651e67e1e666be1684541ed1
pilot repair source = e5683405008b438d8a7c00747e4e81384962d95ced0d759d42c18f05ff62219c
ExactCoreMatrix source = 58ab7b1acdb7bc6d69fffa04c4baa7ae29ac31e24e80834387974113b70d2ba5
first-hit paper gate = b5f022271bbd696df2a1b2e9205a36d8ad134e058fe29adbf5b1565f167c44fa
donor lake-manifest = 230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b
lean-toolchain = d24fed434d3b13adfaab57724a0a7f270ea8bf1c818b5ae5cf25cbce24dd685c
```

The contract deliberately does not contain its own hash.  Its final hash,
the static-review hash, every script hash and the pre-run report hash must be
recorded by the pre-run/publication custody without creating a self-reference.

## 4. Independent local overlay

The v2 overlay is:

```text
.lake/f3-full-core-identity-v2-overlay/lib/lean
```

It must be absent at Gate 0 and is created only by S0.  The stage copies
exactly three regular `.olean` objects directly from the terminal-PASS
FullBlockDecoder overlay, never from the v1 STOP overlay:

```text
ExactCoreMatrix olean = 34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
PilotRepair olean = 480e605a5e3db74a1edf9ecce7f535b8f8c057965498ac5f73e787322c144372
FullBlockDecoder olean = 225e7cbca64ec5d9ad7e609fdc08bcf60401cbd356f2d4bd20d74b51662bc8ec
```

The frozen `LEAN_PATH` places only this new overlay before the nine package
roots and Lean 4.21.0 toolchain.  It excludes the v1 identity overlay, the
decoder donor overlay and both project build roots.  No later root may
contain `CollatzClassical/`.

This is local-artifact continuity, not fresh-clone reproduction.

## 5. Publication and Gate 0

The authorization becomes active automatically, without editing this
contract, only when all of the following hold:

1. the source, unchanged audit/inventory, five v2 scripts, contract, static
   review and `PRE_RUN_FROZEN / NOT_EXECUTED` report are committed;
2. a new draft PR is pushed from the declared branch and stacked exactly on
   the public parent branch at `9ae5027f8e828fc3d42b099e6740e6665bce1831`;
3. local HEAD equals the public PR head, ancestry is exact, and the tracked
   worktree is clean;
4. the Lean diff against the parent is exactly the two authorized proof
   hunks, while every hash in section 3 and all five script hashes match;
5. the v2 overlay is absent;
6. the result directory is a regular directory containing only the frozen
   pre-run report; all five runtime logs are absent;
7. all four v2 identity/audit `.olean` and `.ilean` targets are absent;
8. the three donor objects are regular non-symlinks with the frozen hashes;
9. later `LEAN_PATH` roots contain zero `CollatzClassical/` directories;
10. at least 4 GiB is free and no competing Lean or Lake process exists.

Gate-0 failure is `GATE0_ENVIRONMENT_STOP` and consumes no phase attempt.  If
Gate 0 passes but an input drifts once R0 is invoked, the executor creates the
R0 log before its failing precheck; that is a consumed terminal R0 STOP.

The report path is:

```text
outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/
F3_CORE_ARITHMETIC_CODEC_FULL_CORE_IDENTITY_V2_v1/
F3_CORE_ARITHMETIC_CODEC_FULL_CORE_IDENTITY_V2_RUN_REPORT_v1.md
```

## 6. Only authorized executor

Direct invocation of the overlay, compile, audit, checker or guard scripts is
forbidden after publication.  Each phase is invoked at most once, in order,
only through:

```sh
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_v2_phase_executor_v1.sh' R0
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_v2_phase_executor_v1.sh' S0
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_v2_phase_executor_v1.sh' C0
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_v2_phase_executor_v1.sh' A1
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_full_core_identity_v2_phase_executor_v1.sh' K1
```

The executor creates each log with `noclobber` before its phase precheck,
binds all parent/source/subordinate-script hashes, records the precheck
status, applies `gtimeout --kill-after=5` only after precheck PASS, records the
outer exit status, and requires unique predecessor PASS/zero markers.
Deleting, renaming, truncating or replacing a log to permit another
invocation is forbidden.

## 7. Phases and acceptance

### R0 — guard regression, 60 seconds

PASS requires the real decoder-v6 audit log at 640/640/640, the multiline
forbidden fixture rejected, the full-log forbidden scan absent,
`V2_GUARD_REGRESSION=PASS` and the v2 outer status zero.

### S0 — independent overlay, 120 seconds

PASS requires exactly three regular donor objects, zero symlinks, all hashes
matching, `FULL_CORE_IDENTITY_V2_OVERLAY_STAGE=PASS` and outer status zero.

### C0 — sole repaired compilation, 600 seconds

The source keeps `maxHeartbeats 200000` and `maxRecDepth 100000`.  PASS
requires internal and outer status zero, exactly five regular overlay files,
zero symlinks, unchanged source/upstream hashes and recorded identity
`.olean`/`.ilean` hashes.

Diagnostic classification after a nonzero result is:

- failure of the historical literal `rfl`:
  `FULL_LITERAL_NORMALIZATION_REGRESSION_STOP`;
- failure of the direct length theorem: `LENGTH_OF_FN_REPAIR_STOP`;
- failure of the explicitly typed permutation fold: `FOLDR_REPAIR_STOP`;
- timeout, other elaboration or postcheck failure:
  `FULL_CORE_IDENTITY_V2_COMPILE_STOP`.

Every class is terminal; A1 and K1 remain forbidden.

### A1 — sole total audit, 450 seconds

A1 must bind the unique C0 PASS record to the current source and both current
identity objects before Lean.  PASS requires internal and outer status zero,
exactly seven regular overlay files, zero symlinks, unchanged source/audit,
upstream and identity hashes, and recorded audit `.olean`/`.ilean` hashes.

### K1 — linked inventory/profile audit, 60 seconds

K1 must bind C0 output to A1 input and compare all seven overlay objects.
PASS requires 9/9/9 source/inventory/audit coverage, exact source-repair
syntax, seven of seven terminal profiles allowed, unique environmental
names, whole-log zero `Lean.ofReduceBool` and `sorryAx`, both checker PASS
markers and outer status zero.

Any A1/K1 mismatch is `FULL_CORE_IDENTITY_V2_AUDIT_STOP`.

## 8. Terminal STOP, custody and scope

The first nonzero exit, timeout, absent/duplicate marker, input drift,
hash/count mismatch, symlink, forbidden axiom or profile mismatch is terminal
STOP.  No retry, cleanup, source/audit/script edit, alternate proof, table,
shard, budget increase, amend, force-push, retarget or merge is authorized
after R0 begins.

PASS or STOP, the report and every created regular log must be committed and
fast-forwarded to the same public draft PR.  The terminal report must contain
a total table for five logs, seven overlay objects and seven designated
terminal profiles.  Uncreated entries are explicitly
`ABSENT_NOT_INVOKED` or `ABSENT_PHASE_STOP`; actual partial/unexpected overlay
entries are inventoried without cleanup.  Runtime logs are immutable.

```text
PRECONTRACT_TEXTUAL_REVIEW_ROUNDS = 3
PRECONTRACT_SCRIPT_EXECUTIONS = 0
PRECONTRACT_CHECKER_EXECUTIONS = 0
PRECONTRACT_BASH_N_EXECUTIONS = 5
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
