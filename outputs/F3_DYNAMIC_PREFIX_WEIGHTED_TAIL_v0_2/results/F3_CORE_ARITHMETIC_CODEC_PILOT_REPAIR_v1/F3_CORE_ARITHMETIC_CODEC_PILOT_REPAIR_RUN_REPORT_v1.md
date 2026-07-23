# F3 arithmetic-codec pilot repair run report v1

Status: `ARITHMETIC_CODEC_REPAIR_STOP_AND_RECORD / LEAN_ELABORATION_ERRORS / NOT_MATHEMATICAL_COUNTEREXAMPLE — AUDIT_NOT_OPENED`

Date: 2026-07-24.

This report freezes the only authorized repair run before either Lean command
is invoked.  The donor tree is read-only.  All generated Lean artifacts stay
under this isolated clone's `.lake/build/lib/lean/CollatzClassical/KL2003/`,
and all raw logs stay in this report directory.

## 1. Frozen custody

```text
CONTROLLING_CODE_HEAD = aa9c2dda84258f98b332ead3e880eeac71d65051

repair source sha256 =
567d48c19b2b5bd2321e6a46b5a39dd9b54b8714adac7f6636a46405393bbf4d

repair audit sha256 =
a8e05246e9726afb79c25e206a90f86b12a50a0803251c50cf8b856eae40e0f1

audit-log checker sha256 =
18d2e368b5e73519ec5d701cee59177982bc1f6a750b1b5546d8568866761e9e

ExactCoreMatrix source sha256 =
58ab7b1acdb7bc6d69fffa04c4baa7ae29ac31e24e80834387974113b70d2ba5

donor ExactCoreMatrix olean sha256 =
34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798

donor lake-manifest.json sha256 =
230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b

toolchain = leanprover/lean4:v4.21.0
donor repair olean = ABSENT
donor repair ilean = ABSENT
local repair olean before run = ABSENT
local repair ilean before run = ABSENT
```

The root is exactly:

```text
/Users/MoiTam/Documents/New project/coordinated/hilo2-f3
```

## 2. Sole authorized compile command

This command may be invoked exactly once.  Its 300-second ceiling includes
import and elaboration, and its stdout/stderr plus `/usr/bin/time -p` output
are combined in `pilot_compile_raw.txt`.

```sh
/opt/homebrew/bin/gtimeout 300 /usr/bin/time -p env LEAN_PATH='/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Cli/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/batteries/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Qq/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/aesop/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/proofwidgets/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/importGraph/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/plausible/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/mathlib/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/build/lib/lean:/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean' /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean --root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3' -o '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean' -i '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.ilean' '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.lean' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_v1/pilot_compile_raw.txt' 2>&1
```

Any nonzero exit, timeout, heartbeat exhaustion, absent output artifact or
source mutation is immediate `ARITHMETIC_CODEC_REPAIR_STOP_AND_RECORD`.
There is no edit, retry, or resource increase.

## 3. Conditional sole audit command

This command is forbidden unless the compile command exits zero and both
repair artifacts exist.  It prepends only the current clone's build library
to the identical donor `LEAN_PATH`.  It may be invoked exactly once.

```sh
/opt/homebrew/bin/gtimeout 300 /usr/bin/time -p env LEAN_PATH='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Cli/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/batteries/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Qq/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/aesop/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/proofwidgets/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/importGraph/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/plausible/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/mathlib/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/build/lib/lean:/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean' /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean --root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3' -o '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.olean' -i '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.ilean' '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.lean' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_v1/axiom_audit_raw.txt' 2>&1
```

Only after an audit exit zero, this non-Lean checker is run once:

```sh
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_core_arithmetic_codec_repair_inventory_check_v1.sh' --audit-log '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_v1/axiom_audit_raw.txt' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_v1/axiom_log_checker.txt' 2>&1
```

The checker requires one positive namespace count, one environmental profile
per namespace declaration, and no `Lean.ofReduceBool` or `sorryAx` anywhere.

## 4. Frozen decision boundary

```text
compile attempts = 1
audit attempts = 1 iff compile PASS
audit-log checker = 1 iff audit PASS
retry = forbidden
source repair after attempt = forbidden
243-source extension = forbidden
push = forbidden
```

## 5. Result ledger

The pre-execution report was frozen in commit
`73767dd122663929fad9cbaf158d88b1021c0080`.  The sole compile command was
invoked once and returned exit 1 after 117.56 seconds.  It did not time out or
exhaust the heartbeat budget.  Lean emitted six arithmetic elaboration
failures:

- one `omega` failure at each of `55:23`, `56:31`, and `57:31` while
  constructing the three residue alternatives of the `encode` subtype
  witness;
- three branch-specific `omega` failures at `1097:20` in
  `pilotFrozenPos_agrees`.

The log also contains three nonfatal `unnecessarySimpa` warnings.  No repair
`.olean` or `.ilean` was produced.  Therefore the conditional audit command
and the audit-log checker were not invoked.

The complete combined compiler log has 75 lines, 3386 bytes, and hash

```text
619fd7361557309f4f5519f22cba5fe304ac1c00409da62f5c170446290fcfc2
```

Post-run hashing reproduced every frozen input hash in Section 1.  A targeted
`git diff --exit-code` over the repair source, audit, checker and dependency
source returned empty.  The donor dependency object retained its frozen hash.

```text
COMPILE_INVOCATIONS = 1
COMPILE_EXIT = 1
COMPILE_WALL_SECONDS = 117.56
COMPILE_USER_SECONDS = 15.60
COMPILE_SYS_SECONDS = 11.98
COMPILE_TIMEOUT = false
COMPILE_HEARTBEAT_EXHAUSTION = false
COMPILE_FAILURE_CLASS = LEAN_ELABORATION_ERRORS
COMPILE_OLEAN = ABSENT
COMPILE_ILEAN = ABSENT
AUDIT_INVOCATIONS = 0_BY_CONTRACT
AUDIT_EXIT = NOT_RUN_BY_CONTRACT
AUDIT_OLEAN = ABSENT
AUDIT_ILEAN = ABSENT
ENVIRONMENTAL_LOG_CHECK = NOT_RUN_BY_CONTRACT
POST_RUN_SOURCE_HASHES = MATCH_FROZEN_INPUTS
POST_RUN_SOURCE_DIFF = EMPTY
RETRY = false
SOURCE_EDIT_AFTER_ATTEMPT = false
FULL_EXTENSION_OPENED = false
FINAL_VERDICT = ARITHMETIC_CODEC_REPAIR_STOP_AND_RECORD / LEAN_ELABORATION_ERRORS / NOT_MATHEMATICAL_COUNTEREXAMPLE
```

This failure is an elaboration STOP for the frozen repair attempt.  It is not
a mathematical counterexample and it does not establish any axiom profile,
because the audit gate never opened.

## 6. Diagnostic postmortem only

This classification does not authorize a source edit or describe an
executable repair for the spent gate.

- At `55:23`, `56:31`, and `57:31`, the intended residue fact is already
  represented by `encodeNat_mod9`, but the failed goals retain subtype
  projections and quotient variables that `omega` did not identify with that
  formula.  This is a need for explicit definitional reduction or named
  projection/congruence lemmas, not a new mathematical mechanism.
- The three goals at `1097:20` are the three retarded-position branches of
  `pilotFrozenPos_agrees`.  Their constraints show the historical-position
  subtype value remaining opaque to the arithmetic solver.  They likewise
  require explicit definitional normalization or separately stated division
  and remainder identities; they do not expose a new combinatorial or
  dynamical obstruction.
- The three `unnecessarySimpa` messages at lines 233, 236, and 241 are linter
  warnings, not proof failures, and played no role in the exit code.

Thus all six obligations are classified as proof-engineering/elaboration
gaps.  No evidence from this run requires new mathematics, but the frozen
single attempt is nevertheless spent and remains STOP.
