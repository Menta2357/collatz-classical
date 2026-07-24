# F3 arithmetic-codec pilot repair v4 contract v1

Status: `AUTHORIZED / ROUTE_A_FROZEN / EXECUTION_PENDING_FROZEN_RUN_COMMIT`

Date: 2026-07-24.

## 1. Custody and scope

This contract is a new attempt after the immutable v3 STOP:

```text
branch = codex/hilo2-f3-pilot-repair-v4
parent v3 STOP = 4912af1dbe3f3f482d4e41d2887f8e8694d60562
public v3 custody = PR #6
```

No v1, v2 or v3 report or raw log may be edited. The only Lean change is one
line in the retarded branch of `pilotFrozenPos_agrees`:

```lean
      split_ifs <;> rfl
```

Against the v3 STOP the Lean diff is exactly `+1/-0`, in one proof hunk. No
statement, definition, data, formula, codec, matrix construction, inventory,
audit or checker changes. This contract freezes route A. A finite kernel
`decide` route is not a fallback in v4; it would require a separately reviewed
v5 contract after a v4 STOP.

## 2. Frozen inputs

```text
v4 repair source sha256 =
e5683405008b438d8a7c00747e4e81384962d95ced0d759d42c18f05ff62219c

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

The unchanged static checker must report 151/151/151 declarations, 12/12
designated final public theorems and no forbidden source syntax. Before the
run all four local repair/audit `.olean` and `.ilean` targets must be absent.
Any mismatch is STOP without a Lean invocation.

## 3. Publication gate

The prepared source, this contract, its static review and the frozen pre-run
report must be committed and pushed before execution. A draft PR is stacked
on `codex/hilo2-f3-pilot-repair-v3`.

The pre-run report is
`results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V4_v1/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V4_RUN_REPORT_v1.md`.
It must freeze the controlling HEAD, all hashes and literal commands, record
compile/audit/checker counters as zero, and verify absence of the three v4 raw
logs plus all four repair/audit `.olean` and `.ilean` targets. Any mismatch is
preflight STOP without execution.

This contract explicitly authorizes a terminal fast-forward push after either
PASS or STOP. That push must contain the immutable source, contract, complete
run report and every raw log actually produced. It does not authorize amend,
force-push, retry, merge or retargeting.

## 4. Sole compile attempt

```text
maxHeartbeats = 200000
wall ceiling including import = 300 s
processes = 1
compile attempts = 1
retry/edit/resource escalation after failure = forbidden
```

Result directory:

```text
outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V4_v1
```

Exact command:

```sh
/opt/homebrew/bin/gtimeout 300 /usr/bin/time -p env LEAN_PATH='/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Cli/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/batteries/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Qq/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/aesop/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/proofwidgets/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/importGraph/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/plausible/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/mathlib/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/build/lib/lean:/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean' /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean --root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3' -o '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean' -i '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.ilean' '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.lean' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V4_v1/v4_compile_raw.txt' 2>&1
```

Any nonzero exit, timeout, heartbeat exhaustion, missing target artifact or
frozen-input mismatch is immediate STOP. Audit and checker remain forbidden.

## 5. Conditional audit

Only after compile exit zero and presence of both repair artifacts, invoke the
audit exactly once with the local build directory first in `LEAN_PATH`:

```sh
/opt/homebrew/bin/gtimeout 300 /usr/bin/time -p env LEAN_PATH='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Cli/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/batteries/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Qq/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/aesop/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/proofwidgets/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/importGraph/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/plausible/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/mathlib/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/build/lib/lean:/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean' /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean --root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3' -o '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.olean' -i '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.ilean' '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.lean' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V4_v1/v4_axiom_audit_raw.txt' 2>&1
```

Only after audit exit zero invoke the unchanged checker once:

```sh
bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_core_arithmetic_codec_repair_inventory_check_v1.sh' --audit-log '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V4_v1/v4_axiom_audit_raw.txt' > '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V4_v1/v4_axiom_log_checker.txt' 2>&1
```

PASS requires audit/checker exit zero, complete declared coverage, and no
profile containing `Lean.ofReduceBool` or `sorryAx`.
Any audit or checker nonzero exit, timeout, incomplete coverage, forbidden
profile or missing artifact is terminal STOP without retry, source edit,
route change or resource escalation.

## 6. Terminal scope

A PASS closes only the 27-source/81-edge arithmetic-codec pilot. It does not
authorize route B, extension to 243/729, semantic first-hit, rho, density or a
global Collatz claim.

```text
V4_COMPILE_INVOCATIONS = 0
V4_AUDIT_INVOCATIONS = 0
V4_CHECKER_INVOCATIONS = 0
NO_RETRY
NO_ROUTE_B_IN_V4
NO_243_SOURCE_EXTENSION
NO_SEMANTIC_FIRST_HIT_EXECUTION
```
