# F3 arithmetic-codec pilot repair v2 run report v1

Status: `ARITHMETIC_CODEC_REPAIR_V2_STOP_AND_RECORD / LEAN_ELABORATION_ERROR / NOT_MATHEMATICAL_COUNTEREXAMPLE — AUDIT_NOT_OPENED`

Date: 2026-07-24.

This report freezes the newly authorized v2 gate before either Lean command
is invoked.  It does not reuse any v1 artifact or log.  The donor tree remains
read-only, Lean outputs stay under the isolated clone's local build directory,
and raw logs use this new v2 result directory.

## 1. Human-gate conditions and preflight

```text
branch = codex/hilo2-f3-pilot-repair-v2
CONTROLLING_CODE_HEAD = 1681b89c17d9cf48189bf1b278341ceadd8d21dc
parent v1 STOP = ef6513aec7899ad0ab7ac896abc595e57eedb616

Lean source diff files = 1
Lean proof hunks = 2
Lean insertions/deletions = +4/-13
statement changes = 0
definition changes = 0
data changes = 0

maxHeartbeats = 200000
wall ceiling including import = 300 s
compile attempts = 1
audit attempts = 1 iff compile PASS
retry/edit/resource escalation after failure = forbidden
```

Static inventory preflight returned 151 source declarations, 151 inventory
entries and 151 audit commands, with 12/12 final theorems and the environmental
enumerator present but unexecuted.

## 2. Frozen hashes

```text
v2 repair source sha256 =
80be816012ebc0da09b1e86bfaa5c4eb482ccb5dbd7f4b4913d117ce9c1f408c

repair audit sha256 =
a8e05246e9726afb79c25e206a90f86b12a50a0803251c50cf8b856eae40e0f1

audit-log checker sha256 =
18d2e368b5e73519ec5d701cee59177982bc1f6a750b1b5546d8568866761e9e

v2 contract sha256 =
7d1fc396ad2fa1985f647207eaa300b5858594798c5c6319822191676cf927a2

v2 static review sha256 =
558101302e598f974ae5de92be46e569d65319755bee4c248f54c976d3f3221e

ExactCoreMatrix source sha256 =
58ab7b1acdb7bc6d69fffa04c4baa7ae29ac31e24e80834387974113b70d2ba5

donor ExactCoreMatrix olean sha256 =
34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798

donor lake-manifest.json sha256 =
230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b

first-hit paper contract sha256 =
b5f022271bbd696df2a1b2e9205a36d8ad134e058fe29adbf5b1565f167c44fa

toolchain = leanprover/lean4:v4.21.0
local repair olean before v2 = ABSENT
local repair ilean before v2 = ABSENT
local audit olean before v2 = ABSENT
local audit ilean before v2 = ABSENT
```

The root is exactly:

```text
/Users/MoiTam/Documents/New project/coordinated/hilo2-f3
```

## 3. Sole authorized v2 compile command

This exact command may be invoked once.  Its stdout/stderr and
`/usr/bin/time -p` output are combined in the new `v2_compile_raw.txt`.

```sh
/opt/homebrew/bin/gtimeout 300 /usr/bin/time -p env LEAN_PATH='/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Cli/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/batteries/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Qq/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/aesop/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/proofwidgets/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/importGraph/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/plausible/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/mathlib/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/build/lib/lean:/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean' /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean --root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3' -o '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean' -i '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.ilean' '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.lean' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V2_v1/v2_compile_raw.txt' 2>&1
```

Any nonzero exit, timeout, heartbeat exhaustion, missing artifact or frozen
input mismatch is immediate STOP without audit, edit or retry.

## 4. Conditional sole explicit-plus-environmental audit

This exact command is forbidden unless compile exits zero and both repair
artifacts exist.  It may be invoked once and writes only new v2 audit outputs
and the new `v2_axiom_audit_raw.txt`.

```sh
/opt/homebrew/bin/gtimeout 300 /usr/bin/time -p env LEAN_PATH='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Cli/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/batteries/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Qq/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/aesop/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/proofwidgets/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/importGraph/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/plausible/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/mathlib/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/build/lib/lean:/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean' /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean --root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3' -o '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.olean' -i '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.ilean' '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.lean' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V2_v1/v2_axiom_audit_raw.txt' 2>&1
```

Only after audit exit zero, this non-Lean checker is invoked once:

```sh
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_core_arithmetic_codec_repair_inventory_check_v1.sh' --audit-log '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V2_v1/v2_axiom_audit_raw.txt' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V2_v1/v2_axiom_log_checker.txt' 2>&1
```

The checker requires one positive environmental declaration count, exactly
one profile per declaration, and rejects `Lean.ofReduceBool` or `sorryAx`.

## 5. First-hit paper contract review — no execution

The existing contract already contains every requested term and is not
rewritten:

```text
Block0 [3,2919): lines 29--32
y0=8 and window: lines 36--37
five member-wise duties: lines 67--73
discount and acceptance inequality: lines 80--92
PASS rule: lines 105--107
mismatch/counterexample STOP: lines 109--115
```

No first-hit data are computed and the semantic gate remains closed.

## 6. Result ledger

The pre-execution v2 report was frozen in commit
`ec3890141e860e3b9239cc9ffe23724487c4db6d`.  The sole compile command was
invoked once and returned exit 1 after 146.69 seconds.  It did not time out or
exhaust the heartbeat budget.

The three v1 encoder-witness errors are absent: Lean elaborated the new
`encodeNat_mod9` proof branches.  The sole error is at `1088:18`:

```text
tactic 'rfl' failed; the two retarded-position values were not recognized as
definitionally equal.
```

The log also contains three nonfatal `unnecessarySimpa` warnings at lines 232,
235, and 240.  No repair `.olean` or `.ilean` was produced, so the conditional
audit and checker were not invoked.

The complete combined compiler log has 16 lines, 1311 bytes, and hash:

```text
d1163ebb2de79f0dbbbb0affef58fab834a602cee5b0c1af535586cccb2aa8ef
```

Post-run hashing reproduced all frozen source, audit, checker, dependency and
first-hit contract hashes.  Targeted `git diff --exit-code` over those inputs
returned empty.  The first-hit document retained the exact lines recorded in
Section 5 and no semantic computation was performed.

```text
COMPILE_INVOCATIONS = 1
COMPILE_EXIT = 1
COMPILE_WALL_SECONDS = 146.69
COMPILE_USER_SECONDS = 16.13
COMPILE_SYS_SECONDS = 13.97
COMPILE_TIMEOUT = false
COMPILE_HEARTBEAT_EXHAUSTION = false
COMPILE_FAILURE_CLASS = LEAN_ELABORATION_ERROR
COMPILE_OLEAN = ABSENT
COMPILE_ILEAN = ABSENT
AUDIT_INVOCATIONS = 0
AUDIT_EXIT = NOT_RUN_BY_CONTRACT
AUDIT_OLEAN = ABSENT
AUDIT_ILEAN = ABSENT
ENVIRONMENTAL_CHECK = NOT_RUN_BY_CONTRACT
POST_RUN_HASHES = MATCH_FROZEN_INPUTS
POST_RUN_SOURCE_DIFF = EMPTY
RETRY = false
SOURCE_EDIT_AFTER_ATTEMPT = false
SEMANTIC_FIRST_HIT_EXECUTION = false
FULL_EXTENSION_OPENED = false
PUSH = false
FINAL_VERDICT = ARITHMETIC_CODEC_REPAIR_V2_STOP_AND_RECORD / LEAN_ELABORATION_ERROR / NOT_MATHEMATICAL_COUNTEREXAMPLE
```

```text
NO_243_SOURCE_EXTENSION
NO_SEMANTIC_FIRST_HIT_EXECUTION
NO_PUSH
```

## 7. Static postmortem and minimal v3 proposal — not implemented

The run separates the two v2 mechanisms cleanly:

- theorem reuse with `simpa [h0/h1/h2] using encodeNat_mod9 i` discharged all
  three encoder branches;
- bare `rfl` is insufficient for the retarded position because Lean leaves the
  wrapper definitions opaque at that proof boundary.

This is a definitional-normalization mismatch, not a new arithmetic,
combinatorial, or dynamical obstruction.  A minimal v3 candidate is the
following explicit target normalization, without changing any statement,
definition, or data:

```lean
| retarded i =>
    change
      (pilotFrozenPos (.retarded i)).1 = rowStart (fin27To243 i)
    simp only [pilotFrozenPos, rowStart, fin27To243]
```

Equivalently, a v3 could first package that exact `change`/`simp only` proof as
a named lemma and use it in the retarded branch; the proposed lemma statement
would be:

```lean
theorem pilotRetardedPos_agrees (i : Fin 27) :
    (pilotFrozenPos (.retarded i)).1 = rowStart (fin27To243 i)
```

Neither form is added to the source here.  Any v3 edit or invocation requires
a new branch, contract, static review, and explicit human gate.
