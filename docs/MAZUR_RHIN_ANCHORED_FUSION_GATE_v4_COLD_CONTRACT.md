# Rhin-anchored H1 cold gate v4 — pre-execution contract

Status: `HOLD_DISK / DOCUMENT-ONLY / PRE-EXECUTION / NOT_RUN`

Date: 2026-07-24.

## 1. Scope and public baseline

This contract is the cold successor to the terminal v3 dependency-prepayment
STOP. It authorizes no command by itself and records no PASS. Its only purpose
is to freeze the inputs, phase separation, budgets, STOP rules and meaning of a
future verdict before that run is prepared.

`HOLD_DISK` is a hard pre-execution state, not a failed attempt. It may be
lifted only when the frozen pre-run evidence records at least 20 GiB available
and every other gate below passes. This document makes no execution or theorem
claim.

The public v3 baseline was checked read-only before this file was created:

```text
repository = https://github.com/Menta2357/collatz-classical.git
v3 branch = agent/mazur-rhin-anchored-warm-gate-v3
local v3 HEAD = 43fc72754a3c08eea988799d18d8c1b1afcc34bc
public v3 HEAD = 43fc72754a3c08eea988799d18d8c1b1afcc34bc
public ref = refs/heads/agent/mazur-rhin-anchored-warm-gate-v3
public receipt = EXACT_MATCH
v3 draft PR = https://github.com/Menta2357/collatz-classical/pull/11
v3 verdict = F0_PASS / D1_DEPENDENCY_PREPAY_TIMEOUT_STOP / P1_A1_NOT_RUN
reconstruction .lake at contract creation = ABSENT
```

The intended successor ref is exactly:

```text
v4 branch = agent/mazur-rhin-anchored-cold-gate-v4
v4 public ref = refs/heads/agent/mazur-rhin-anchored-cold-gate-v4
```

A separate pre-run report must name the exact frozen v4 execution commit. That
commit must be publicly visible at the exact ref above before F0. F0 must use
`git ls-remote --exit-code --refs` and require one row whose SHA is exactly the
local execution HEAD. A missing ref, query failure, extra/malformed row or SHA
mismatch is STOP.

## 2. Frozen mathematical and environment inputs

The v4 run must use the same candidate, audit, manifest and reconstruction as
v3, byte for byte and commit for commit:

```text
custody theorem path = artifacts/mazur-rhin-anchored-ca3/payload/Erdos1135/ND/FusionRhinAnchored.lean
candidate theorem sha256 = a7f3bef1c7184b514c3cc6833da03a3eefd5f41b3bea58bf4062885d7bfab7b1

custody audit path = artifacts/mazur-rhin-anchored-ca3/payload/FusionRhinAnchoredAxiomAudit.lean
candidate audit sha256 = 4c75fd87933592842a70a4f861f29fa685c73ea81a62ed359437b8170506f688

reconstruction root = /Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/reconstruction-publication-gate2-ef1a5a7
reconstruction commit = b7da87864ced8abd6c3715b65320efc233c0d853
lake-manifest.json sha256 = bc45e15b36f7aede2ceed922babf4bbcacb6789a1ec2d85bd571105fcd73926e
toolchain = leanprover/lean4:v4.30.0
mathlib revision = c5ea00351c28e24afc9f0f84379aa41082b1188f
```

The reconstruction copies of the theorem and audit must equal the custody
copies byte for byte before execution. The custody and reconstruction tracked
worktrees must be clean. No source, manifest, toolchain, package revision,
candidate, audit or contract may change after the frozen pre-run commit.

The run has one future entry point and no manual phase entry points:

```text
single executor path = artifacts/mazur-rhin-anchored-ca3/scripts/rhin_v4_cold_executor.sh
single executor sha256 = REQUIRED_EXACT_64_HEX_BEFORE_PRE_RUN_FREEZE
v4 preflight path = artifacts/mazur-rhin-anchored-ca3/scripts/rhin_v4_cold_preflight.sh
v4 preflight sha256 = REQUIRED_EXACT_64_HEX_BEFORE_PRE_RUN_FREEZE
v4 contract sha256 = REQUIRED_EXACT_64_HEX_BEFORE_PRE_RUN_FREEZE
```

The executor and preflight do not yet exist under this contract. Their creation
does not count as authorization to run them. Before execution, a static review
and the pre-run report must replace every requirement above with the literal
path and actual SHA-256 digest, and must bind the executor, preflight, this
contract, candidate, audit, manifest and reconstruction to the same frozen
execution commit. A missing file, placeholder, digest mismatch or post-freeze
change is `PRE_RUN_HASH_GATE_STOP`.

For provenance, the terminal v3 run froze these additional receipts:

```text
v3 preflight script sha256 = 9ede3d3f3e94e5f46dd60bd5a7a9369cfd9300c6f5e942813c6bee6ec34e6a76
v3 contract sha256 = fe26ee7200cb398a75533fc363d06a18744f2c84a51a0839cae3cf18223b9d0f
v3 static review sha256 = 1e71290ff961ff967cdb39b3519783a3307b7336f80a2be714defe5eadd4238d
v3 F0 log sha256 = f499a3321483236c1093e60cc1c8f37823a46425266b9cb6eea5a75b30424b9a
v3 D1 log sha256 = 2795087e5c32ac37186675c90bf8e57f527b243fd48e71f52f9271e88a69ce6e
```

All files below
`artifacts/mazur-rhin-anchored-ca3/rhin-v3-logs/` are immutable evidence.
V4 must neither edit, delete, rename nor overwrite them. All v4 evidence must
live below a new `artifacts/mazur-rhin-anchored-ca3/rhin-v4-logs/` directory.

## 3. Cold-start, single executor and exclusivity preconditions

The only permitted future invocation is the frozen single executor. Before it
opens or redirects `F0_preflight.full.log`, that executor must:

1. Verify its own externally recorded digest and all pre-run hashes.
2. Verify that all six phase logs are absent:
   `F0_preflight.full.log`, `T0_cache_get.full.log`,
   `D1a_fusion_parametric.full.log`, `D1b_rhin_unconditional.full.log`,
   `P1_target_build.full.log` and `A1_axiom_audit.full.log`. Any existing log
   is `PRE_EXECUTOR_PRIOR_V4_EVIDENCE_STOP`.
3. Acquire one atomically exclusive v4 execution lock. Failure to acquire it is
   `EXECUTOR_EXCLUSIVITY_STOP`. The exact lock path and acquisition mechanism
   must be frozen in the executor and static review; no second launcher or
   manual phase command is allowed.
4. Perform the frozen process audit immediately before F0 and then immediately
   before each later phase. The audit must find no concurrent Lean, Lake,
   `leanc` or Mathlib cache process from any project, excluding only the frozen
   executor's own process ancestry. It must record its complete output. Any
   match is `CONCURRENT_BUILD_STOP`; waiting and continuing is forbidden.
5. Launch each exact phase command itself, in order, and terminate at the first
   STOP. No human shell may resume the sequence.

Once the executor has opened the F0 log, F0 must require all of the following
before T0 is permitted:

1. The reconstruction root has no `.lake` path at all. An existing `.lake`,
   whether complete or partial, is `F0_EXPECTED_COLD_TREE_STOP`. This contract
   does not authorize deleting or moving an existing `.lake`.
2. `df -Pk` reports at least `20971520` KiB available on the filesystem that
   contains the reconstruction root, i.e. at least 20 GiB. Less space is
   `F0_DISK_STOP`.
3. The dedicated cache directory
   `/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/.rhin-v4-mathlib-cache`
   is absent, while its parent
   `/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion` exists as a
   directory and is writable. F0 must not create the cache directory. A present
   cache directory or unwritable/missing parent is `F0_CACHE_DIR_STATE_STOP`;
   this contract does not authorize deleting or moving an existing directory.
4. Only the five later phase logs are absent:
   `T0_cache_get.full.log`, `D1a_fusion_parametric.full.log`,
   `D1b_rhin_unconditional.full.log`, `P1_target_build.full.log` and
   `A1_axiom_audit.full.log`. F0 must not test its own already-open log for
   absence. Existing later evidence is `F0_PRIOR_LATER_EVIDENCE_STOP`.
5. The executor holds the exclusive lock and its immediately preceding process
   audit passed. F0 must not reacquire the lock or substitute another audit.
6. The exact public v4 branch SHA equals local HEAD; both tracked worktrees are
   clean; the fixed hashes, byte identities, reconstruction commit, toolchain
   and manifest checks all pass.

The pre-run report must record the disk measurement, process-audit output,
absence of `.lake`, absence of v4 logs, exact public receipt and zero invocation
counters before the frozen execution commit is pushed. It must also record the
actual contract, executor and preflight SHA-256 digests, the dedicated cache
path, the executor-lock specification and the exact process-audit matcher.

The prescribed new evidence paths are:

```text
v4 preflight script = artifacts/mazur-rhin-anchored-ca3/scripts/rhin_v4_cold_preflight.sh
v4 single executor = artifacts/mazur-rhin-anchored-ca3/scripts/rhin_v4_cold_executor.sh
v4 log root = artifacts/mazur-rhin-anchored-ca3/rhin-v4-logs
v4 run report = artifacts/mazur-rhin-anchored-ca3/rhin-v4-logs/RHIN_V4_RUN_REPORT_v1.md
dedicated cache dir = /Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/.rhin-v4-mathlib-cache
```

## 4. Fixed sequential phases

Every command below runs from the fixed reconstruction root. Phases are
strictly sequential. A phase is forbidden unless every preceding phase passed.
The first nonzero exit, timeout, missing required artifact, hash mismatch,
profile mismatch or precondition mismatch terminates the run.

Every phase must return literal exit status zero. Download progress, generated
files, late output or apparently useful artifacts never reinterpret a nonzero
exit as PASS. The fixed phase-command wall ceilings sum to exactly 7620 seconds
(2 hours 7 minutes): `120 + 3600 + 900 + 2400 + 300 + 300`. Budgets do not
roll over between phases; executor and process-audit overhead cannot be used to
extend a phase.

### F0 — cold/public/environment preflight, 120 seconds

F0 performs only the checks in Sections 1–3. Its implementation must itself be
frozen and hashed in the pre-run report. Its invocation is limited by:

```sh
env LC_ALL=C LANG=C /usr/bin/time -p /opt/homebrew/bin/gtimeout 120 bash '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/scripts/rhin_v4_cold_preflight.sh' > '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/rhin-v4-logs/F0_preflight.full.log' 2>&1
```

F0 PASS requires exit zero and an explicit receipt for every Section 1–3
condition. It must leave `.lake` absent. F0 may not fetch dependencies or build
anything.

### T0 — cold dedicated-cache acquisition, 3600 seconds

Only after F0 PASS:

```sh
env LC_ALL=C LANG=C MATHLIB_CACHE_DIR='/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/.rhin-v4-mathlib-cache' /usr/bin/time -p /opt/homebrew/bin/gtimeout 3600 lake exe cache get > '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/rhin-v4-logs/T0_cache_get.full.log' 2>&1
```

T0 PASS requires exit zero, a materialized package tree at the fixed Mathlib
revision, clean tracked package worktrees, and no change to any frozen input.
T0 does not count as evidence that either dependency root or the target
elaborates. Timeout or any nonzero exit is `CACHE_GET_STOP`. In particular, an
exit status 1 after successful-looking downloads remains STOP and may not be
reinterpreted, repaired or followed by a phase command.

### D1a — `FusionParametric`, 900 seconds

Only after T0 PASS:

```sh
env LC_ALL=C LANG=C /usr/bin/time -p /opt/homebrew/bin/gtimeout 900 lake build Erdos1135.ND.FusionParametric > '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/rhin-v4-logs/D1a_fusion_parametric.full.log' 2>&1
```

D1a PASS requires exit zero and nonempty `.olean` and `.ilean` artifacts for
`Erdos1135.ND.FusionParametric`. Otherwise the verdict is
`FUSION_PARAMETRIC_STOP`.

### D1b — `RhinUnconditional`, 2400 seconds

Only after D1a PASS:

```sh
env LC_ALL=C LANG=C /usr/bin/time -p /opt/homebrew/bin/gtimeout 2400 lake build Erdos1135.ND.RhinUnconditional > '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/rhin-v4-logs/D1b_rhin_unconditional.full.log' 2>&1
```

D1b PASS requires exit zero and nonempty `.olean` and `.ilean` artifacts for
`Erdos1135.ND.RhinUnconditional`. Otherwise the verdict is
`RHIN_UNCONDITIONAL_STOP`.

### P1 — anchored target, 300 seconds

Only after D1b PASS:

```sh
env LC_ALL=C LANG=C /usr/bin/time -p /opt/homebrew/bin/gtimeout 300 lake build Erdos1135.ND.FusionRhinAnchored > '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/rhin-v4-logs/P1_target_build.full.log' 2>&1
```

P1 PASS requires exit zero and nonempty `.olean` and `.ilean` artifacts for
`Erdos1135.ND.FusionRhinAnchored`. Otherwise the verdict is
`TARGET_ELABORATION_STOP` and A1 is forbidden.

### A1 — complete named producer/consumer audit, 300 seconds

Only after P1 PASS:

```sh
env LC_ALL=C LANG=C /usr/bin/time -p /opt/homebrew/bin/gtimeout 300 lake env lean FusionRhinAnchoredAxiomAudit.lean > '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/rhin-v4-logs/A1_axiom_audit.full.log' 2>&1
```

A1 must print profiles for both exact declarations:

```text
Erdos1135.ND.ndRhinRate_sameD_6993_200000
Erdos1135.ND.fusion_of_rhin_6993_200000_of_finiteBaseVerified
```

A1 PASS requires exit zero, both declarations present, and each transitive
profile equal to exactly `{propext, Classical.choice, Quot.sound}`. A missing
declaration, missing profile or any additional axiom is `AUDIT_STOP`.

## 5. One-attempt rule and terminal custody

The entire sequence has one attempt:

```text
F0_MAX_INVOCATIONS = 1
T0_MAX_INVOCATIONS = 1
D1a_MAX_INVOCATIONS = 1
D1b_MAX_INVOCATIONS = 1
P1_MAX_INVOCATIONS = 1
A1_MAX_INVOCATIONS = 1
STOP_AT_FIRST_FAILURE = true
NO_RETRY
NO_SOURCE_OR_TACTIC_EDIT
NO_MANIFEST_OR_TOOLCHAIN_EDIT
NO_CACHE_DELETION_OR_SUBSTITUTION
NO_BUDGET_CHANGE
NO_COMMAND_CHANGE
NO_PHASE_REORDERING_OR_COMBINATION
NO_CONTINUATION_AFTER_STOP
SINGLE_EXECUTOR_ONLY
LITERAL_EXIT_ZERO_REQUIRED
FIXED_LOCALE_LC_ALL_C_LANG_C
PHASE_WALL_BUDGET_SECONDS = 7620
```

No timeout or failure may be followed by a retry, repair, extra diagnostic
build, resource increase or opportunistic continuation under v4. A new idea
requires a separately reviewed v5 contract and a fresh branch.

Whether the outcome is PASS or STOP, the run report, all logs that actually
exist, their byte counts and SHA-256 hashes, invocation counters, last progress,
artifact presence, post-run input hashes and tracked-worktree status must be
committed without amending history and pushed explicitly to the exact v4
public ref. A STOP is not terminally custodied until that push is publicly
verified; a PASS is not claimable until the same verification succeeds.

## 6. Exact meaning of a full PASS

A full `F0/T0/D1a/D1b/P1/A1 PASS` establishes all and only the following for
the frozen files and pinned environment:

1. Lean elaborated the exact candidate theorem
   `Erdos1135.ND.fusion_of_rhin_6993_200000_of_finiteBaseVerified`.
2. The theorem consumes the pinned upstream producer
   `ndRhinRate_sameD_6993_200000`, thereby removing a free `ND31Bounds`
   hypothesis from this anchored corollary.
3. Given `2 ≤ N0`, the displayed strict prefactor inequality `hsmall`, and a
   witness `FiniteBaseVerified N0 T`, the theorem concludes
   `HasPositiveLowerNatDensity collatzReachesOneSet`.
4. The named producer and consumer have exactly the audited transitive axiom
   profile `{propext, Classical.choice, Quot.sound}` in this pinned build.
5. The terminal public receipt binds that result to the frozen candidate,
   audit, manifest, reconstruction and logs named by this contract.

A PASS does **not** prove `hsmall` for any usable `N0`; construct or verify a
finite base; exhibit `N0` or `T`; optimize the prefactor; establish density one;
prove that every orbit reaches one; prove the Collatz conjecture; validate any
other module or environment; or turn this local extension into a theorem of the
upstream `ca3dd0d` package. Those remain explicit open obligations.

Neither `HOLD_DISK`, a completed download, a populated dedicated cache, a T0
PASS, an intermediate dependency PASS nor the mere existence of future scripts
is a theorem or audit claim. Before terminal public custody, even a local full
PASS is `UNPUBLISHED_RESULT_NOT_CLAIMABLE`.

```text
F0_INVOCATIONS = 0
T0_INVOCATIONS = 0
D1a_INVOCATIONS = 0
D1b_INVOCATIONS = 0
P1_INVOCATIONS = 0
A1_INVOCATIONS = 0
V4_EXECUTION = NOT_RUN
V4_STATUS = HOLD_DISK
V4_EXECUTOR = REQUIRED_BUT_NOT_CREATED
V4_PREFLIGHT = REQUIRED_BUT_NOT_CREATED
PHASE_WALL_BUDGET_SECONDS = 7620
TERMINAL_PUBLIC_CUSTODY = REQUIRED_FOR_PASS_OR_STOP
```
