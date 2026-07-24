# Rhin-anchored H1 successor gate v3 run report

Status: `F0_PASS / D1_DEPENDENCY_PREPAY_TIMEOUT_STOP / P1_A1_NOT_RUN`

Date: 2026-07-24.

## 1. Custody

```text
V2_TERMINAL_COMMIT = d902528a118193e50ac7d1158e87219375737c21
V2_DRAFT_PR = https://github.com/Menta2357/collatz-classical/pull/9
V3_PREPARED_COMMIT = 22fa70c4de26a11d8e54be52950f721bd96c4a9a
V3_BRANCH = agent/mazur-rhin-anchored-warm-gate-v3
V3_EXECUTION_HEAD = THIS_REPORT_COMMIT
V3_FROZEN_RUN_COMMIT = c5f3c6989e19f1c228cfcf7fb04ba7b13957b194
V3_DRAFT_PR = https://github.com/Menta2357/collatz-classical/pull/11
V3_PUBLIC_RECEIPT = DYNAMIC_EXACT_SHA_CHECK_IN_F0
RECONSTRUCTION_COMMIT = b7da87864ced8abd6c3715b65320efc233c0d853
```

## 2. Frozen hashes

```text
candidate theorem = a7f3bef1c7184b514c3cc6833da03a3eefd5f41b3bea58bf4062885d7bfab7b1
candidate audit = 4c75fd87933592842a70a4f861f29fa685c73ea81a62ed359437b8170506f688
lake-manifest.json = bc45e15b36f7aede2ceed922babf4bbcacb6789a1ec2d85bd571105fcd73926e
v3 preflight script = 9ede3d3f3e94e5f46dd60bd5a7a9369cfd9300c6f5e942813c6bee6ec34e6a76
v3 contract = fe26ee7200cb398a75533fc363d06a18744f2c84a51a0839cae3cf18223b9d0f
v3 static review = 1e71290ff961ff967cdb39b3519783a3307b7336f80a2be714defe5eadd4238d
toolchain = leanprover/lean4:v4.30.0
mathlib = c5ea00351c28e24afc9f0f84379aa41082b1188f
```

## 3. Pre-run state

```text
tracked custody worktree = CLEAN
tracked reconstruction worktree = CLEAN
candidate copies = BYTE_IDENTICAL
F0 log = ABSENT
D1 log = ABSENT
P1 log = ABSENT
A1 log = ABSENT
FusionParametric olean/ilean = PRESENT_CACHE_NOT_PASS_EVIDENCE
RhinUnconditional olean/ilean = ABSENT
FusionRhinAnchored olean/ilean = ABSENT
available disk = AT_LEAST_12_GIB
```

## 4. Literal phase commands

F0:

```sh
/usr/bin/time -p /opt/homebrew/bin/gtimeout 120 bash '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/scripts/rhin_v3_preflight.sh' > '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/rhin-v3-logs/F0_preflight.full.log' 2>&1
```

D1 only after F0 PASS:

```sh
/usr/bin/time -p /opt/homebrew/bin/gtimeout 900 lake build Erdos1135.ND.FusionParametric Erdos1135.ND.RhinUnconditional > '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/rhin-v3-logs/D1_dependency_prepay.full.log' 2>&1
```

P1 only after D1 PASS:

```sh
/usr/bin/time -p /opt/homebrew/bin/gtimeout 300 lake build Erdos1135.ND.FusionRhinAnchored > '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/rhin-v3-logs/P1_target_build.full.log' 2>&1
```

A1 only after P1 PASS:

```sh
/usr/bin/time -p /opt/homebrew/bin/gtimeout 300 lake env lean FusionRhinAnchoredAxiomAudit.lean > '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/rhin-v3-logs/A1_axiom_audit.full.log' 2>&1
```

## 5. Pre-run ledger

```text
F0_INVOCATIONS = 0
D1_INVOCATIONS = 0
P1_INVOCATIONS = 0
A1_INVOCATIONS = 0
PUBLIC_PRE_RUN_PUSH = REQUIRED_BEFORE_F0
STOP_AT_FIRST_FAILURE = true
NO_FETCH_OR_REFSPEC_EDIT
NO_RETRY
NO_SOURCE_EDIT
NO_RESOURCE_ESCALATION
TERMINAL_PUBLIC_PUSH = REQUIRED_FOR_PASS_OR_STOP
```

## 6. Terminal result

F0 ran once and passed. Its public receipt records the same exact SHA
`c5f3c6989e19f1c228cfcf7fb04ba7b13957b194` for local HEAD and the public
branch. All custody, candidate, Mathlib, disk, cache and artifact checks passed.

```text
F0_INVOCATIONS = 1
F0_EXIT = 0
F0_WALL_SECONDS = 0.71
F0_USER_SECONDS = 0.07
F0_SYS_SECONDS = 0.17
F0_LOG_LINES = 43
F0_LOG_BYTES = 1521
F0_LOG_SHA256 = f499a3321483236c1093e60cc1c8f37823a46425266b9cb6eea5a75b30424b9a
```

After a separate process audit confirmed no concurrent Lean/Lake build, D1
ran exactly once. It reached the 900-second ceiling and returned exit 124. The
last reported progress was `3690/3877`; the remaining closure was still in the
upstream Tao/ND dependency graph. `FusionParametric` remains materialized, but
`RhinUnconditional` did not emit `.olean` or `.ilean`.

```text
D1_INVOCATIONS = 1
D1_EXIT = 124
D1_TIMEOUT = true
D1_HEARTBEAT_EXHAUSTION = false
D1_WALL_SECONDS = 900.06
D1_USER_SECONDS = 399.35
D1_SYS_SECONDS = 646.62
D1_LAST_PROGRESS = 3690/3877
D1_LOG_LINES = 293
D1_LOG_BYTES = 17824
D1_LOG_SHA256 = 2795087e5c32ac37186675c90bf8e57f527b243fd48e71f52f9271e88a69ce6e
FUSION_PARAMETRIC_OLEAN_SHA256 = 8ffc4f99d9823bf0b2164b4fd1fca8a0619b712e26d3fbfc33aac17aa8048fed
FUSION_PARAMETRIC_ILEAN_SHA256 = cd7d3760db38d1a547fa2e0516e2faf78c2fba0d0a3178bd88ae0d76727bb15d
RHIN_UNCONDITIONAL_OLEAN = ABSENT
RHIN_UNCONDITIONAL_ILEAN = ABSENT
POST_D1_RECONSTRUCTION_TRACKED_DIFF = EMPTY
POST_D1_MATHLIB_TRACKED_DIFF = EMPTY
POST_D1_INPUT_HASHES = MATCH
```

By contract the timeout closed P1 and A1. No target build or audit command was
invoked. There was no retry, budget increase, source edit, cache deletion or
new dependency command.

```text
P1_INVOCATIONS = 0
A1_INVOCATIONS = 0
FUSION_RHIN_ANCHORED_OLEAN = ABSENT
FUSION_RHIN_ANCHORED_ILEAN = ABSENT
FINAL_VERDICT = DEPENDENCY_PREPAY_TIMEOUT_STOP
THEOREM_COMPILED = false
THEOREM_AXIOM_PROFILE = UNKNOWN_NOT_AUDITED
NO_RETRY
TERMINAL_PUBLIC_CUSTODY = REQUIRED
```
