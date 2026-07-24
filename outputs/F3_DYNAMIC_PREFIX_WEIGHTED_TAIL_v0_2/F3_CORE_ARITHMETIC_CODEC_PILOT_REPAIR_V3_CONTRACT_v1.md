# F3 arithmetic-codec pilot repair v3 contract v1

Status: `HUMAN_AUTHORIZED / EXECUTION_BLOCKED_PENDING_PUBLICATION_GATE_AND_ROOT_GO`

Date: 2026-07-24.

This contract prepares the separately authorized v3 gate after the immutable
v2 STOP.  It does not itself authorize a Lean, Lake, compiler, audit, retry,
semantic first-hit, 243-source extension, or publication invocation.  The
execution gate becomes active only after both conditions below are recorded:

1. the coordinating root confirms that the preceding publication phase
   completed or was formally blocked; and
2. the coordinating root sends an explicit `GO F3 V3` against the frozen v3
   custody commit.

## 1. Separate custody and immutable parent evidence

```text
branch = codex/hilo2-f3-pilot-repair-v3
parent v2 STOP = a37a4ebd975c12846d12264be59f37f374ba7ef4
v2 frozen-run commit = ec3890141e860e3b9239cc9ffe23724487c4db6d
v2 prepared-source commit = 1681b89c17d9cf48189bf1b278341ceadd8d21dc
```

The v2 run returned one elaboration error at `1088:18`, after 146.69 seconds,
without timeout or heartbeat exhaustion.  Its report and complete raw log are
not edited by this gate:

```text
v2 final run report sha256 =
497c78b1fc3df89c3b40ff08c771bfbb926cafae38165e31114e3de92fb8676d

v2 raw compile log sha256 =
d1163ebb2de79f0dbbbb0affef58fab834a602cee5b0c1af535586cccb2aa8ef
```

No v1 or v2 report, raw log, result label, or attempt ledger may be rewritten.

## 2. Sole v3 source change

The v3 source differs from the final v2 STOP in exactly one proof hunk,
`+4/-1`.  The failed bare `rfl` in the retarded branch of
`pilotFrozenPos_agrees` is replaced by explicit target normalization:

```lean
| retarded i =>
    change
      (pilotFrozenPos (.retarded i)).1 = rowStart (fin27To243 i)
    simp only [pilotFrozenPos, rowStart, fin27To243]
```

This is the exact mechanism proposed in the v2 postmortem.  No theorem
statement, definition, data, channel formula, rank, list, matrix construction,
encoder branch, advanced branch, or other proof is changed.  Whether Lean
accepts the `change` and closes the normalized equality remains deliberately
unclaimed until the single authorized invocation.

## 3. Frozen inputs

```text
v3 repair source sha256 =
44796367e408b40a42752587c8dde64af899731bec59f68765cdbb59266c7750

unchanged axiom audit sha256 =
a8e05246e9726afb79c25e206a90f86b12a50a0803251c50cf8b856eae40e0f1

unchanged explicit inventory sha256 =
611bfc53a028e224c71ceb9287a01dd3587e9300e889c7facbb21fb5183ce74f

unchanged audit-log checker sha256 =
18d2e368b5e73519ec5d701cee59177982bc1f6a750b1b5546d8568866761e9e

ExactCoreMatrix source sha256 =
58ab7b1acdb7bc6d69fffa04c4baa7ae29ac31e24e80834387974113b70d2ba5

donor ExactCoreMatrix olean sha256 =
34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798

donor lake-manifest.json sha256 =
230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b

first-hit gate contract sha256 =
b5f022271bbd696df2a1b2e9205a36d8ad134e058fe29adbf5b1565f167c44fa

budget document sha256 =
9f9bce6e8ed3a227a21e4f1890f54e78c8c670ba7b2e045adefac9abeb0d4b04

toolchain = leanprover/lean4:v4.21.0
```

Before any invocation, a new v3 run report must freeze the controlling commit,
these hashes, the exact commands below, and the absence of all four local v3
repair/audit `.olean` and `.ilean` targets.  Any mismatch is STOP without
execution.

## 4. Static invariants

The unchanged static checker reports 151 source declarations, 151 inventory
entries, 151 explicit audit commands, all 12 designated final public theorems,
and the environmental namespace enumerator.  It reports no forbidden source
syntax.

The v3 source contains no `native_decide`, `Lean.ofReduceBool`, `sorry`,
`admit`, explicit `axiom`, `find?`, `HashMap`, array/CSV lookup, finite source
catalogue, table, or literal expected right-hand side.  The audit and its
coverage mechanism are byte-identical to v2.

## 5. Sole possible v3 compile

Only after the two orchestration conditions in the preamble and the separate
frozen run-report commit may the following route be invoked once:

```text
maxHeartbeats = 200000 (set in the frozen source)
total wall ceiling including import = 300 s
processes = 1
compile attempts = 1
retry/edit/resource escalation after failure = forbidden
```

The exact direct-Lean route is below.  The result directory is
`outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V3_v1`
and must be created before the run report is frozen, without reusing any v1 or
v2 log.

```sh
/opt/homebrew/bin/gtimeout 300 /usr/bin/time -p env LEAN_PATH='/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Cli/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/batteries/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Qq/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/aesop/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/proofwidgets/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/importGraph/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/plausible/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/mathlib/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/build/lib/lean:/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean' /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean --root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3' -o '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean' -i '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.ilean' '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.lean' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V3_v1/v3_compile_raw.txt' 2>&1
```

Its combined stdout/stderr and `/usr/bin/time -p` output must be written only
to a new v3 result directory.  Any nonzero exit, timeout, heartbeat exhaustion,
missing output, or frozen-input mismatch is immediate STOP without audit,
edit, retry, or resource increase.

## 6. Conditional audit with declared total coverage

The audit is forbidden unless the compile exits zero and both repair artifacts
exist.  It then has one 300-second attempt.  Its sole route, with the local
build directory prepended to `LEAN_PATH`, is:

```sh
/opt/homebrew/bin/gtimeout 300 /usr/bin/time -p env LEAN_PATH='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Cli/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/batteries/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Qq/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/aesop/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/proofwidgets/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/importGraph/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/plausible/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/mathlib/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/build/lib/lean:/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean' /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean --root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3' -o '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.olean' -i '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.ilean' '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.lean' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V3_v1/v3_axiom_audit_raw.txt' 2>&1
```

Only after audit exit zero, the unchanged checker may be invoked once with
this exact route:

```sh
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_core_arithmetic_codec_repair_inventory_check_v1.sh' --audit-log '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V3_v1/v3_axiom_audit_raw.txt' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V3_v1/v3_axiom_log_checker.txt' 2>&1
```

Acceptance requires:

- exactly one positive environmental namespace declaration count;
- exactly one printed profile for every declaration in that count;
- 151/151 explicit source declarations matched by 151/151 inventory entries
  and 151/151 explicit audit commands;
- all 12 designated final public theorems present; and
- no profile containing `Lean.ofReduceBool` or `sorryAx`.

Any audit/checker failure or incomplete coverage is STOP without retry.

## 7. Terminal decision rule and scope

A PASS closes only the 27-source arithmetic-codec pilot and returns its logs,
timings, hashes, generated artifacts, and complete axiom profiles for review.
It does not authorize publication from this branch, the 243-source/729-edge
extension, the semantic first-hit computation, or any density conclusion.

```text
V3_LEAN_INVOCATIONS = 0
V3_AUDIT_INVOCATIONS = 0
EXECUTION_GATE = BLOCKED_PENDING_PUBLICATION_GATE_AND_ROOT_GO
NO_RETRY
NO_243_SOURCE_EXTENSION
NO_SEMANTIC_FIRST_HIT_EXECUTION
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```
