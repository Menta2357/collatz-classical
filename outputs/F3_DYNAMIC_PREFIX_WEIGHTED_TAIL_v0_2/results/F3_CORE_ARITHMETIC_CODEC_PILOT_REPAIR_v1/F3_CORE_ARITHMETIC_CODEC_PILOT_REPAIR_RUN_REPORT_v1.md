# F3 arithmetic-codec pilot repair run report v1

Status: `FROZEN_PRE_EXECUTION — HEAVY_SLOT_GRANTED — RESULT_PENDING`

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

```text
COMPILE_EXIT = PENDING
COMPILE_WALL_SECONDS = PENDING
COMPILE_OLEAN = PENDING
COMPILE_ILEAN = PENDING
AUDIT_EXIT = CONDITIONALLY_PENDING
AUDIT_WALL_SECONDS = CONDITIONALLY_PENDING
ENVIRONMENTAL_LOG_CHECK = CONDITIONALLY_PENDING
POST_RUN_SOURCE_HASHES = PENDING
POST_RUN_SOURCE_DIFF = PENDING
FINAL_VERDICT = PENDING
```
