# Rhin-anchored H1 successor gate v2 run report

Status: `F0_CUSTODY_UPSTREAM_REF_STOP / D1_P1_A1_NOT_RUN`

Date: 2026-07-24.

This report creates the dedicated log directory and freezes the sequential
F0/D1/P1/A1 execution before any phase invocation.

## 1. Custody

```text
V1_STOP_COMMIT = 7c40912b8223c2ed7797073dd7f804cd0a0430ac
V1_STOP_PR = https://github.com/Menta2357/collatz-classical/pull/7
V2_PREPARED_COMMIT = 804ababc1baa770e7e1e77fccd98e6a6c5bc2b9a
V2_BRANCH = agent/mazur-rhin-anchored-warm-gate-v2
V2_EXECUTION_HEAD = THIS_REPORT_COMMIT
V2_FROZEN_RUN_COMMIT = d2c1792efd5e19382680e65151c7c8d90013e887
V2_DRAFT_PR = https://github.com/Menta2357/collatz-classical/pull/9
V2_PUBLIC_UPSTREAM_RECEIPT = PASS_EXTERNALLY_VERIFIED
F0_LOCAL_UPSTREAM_RESOLUTION = STOP
RECONSTRUCTION_COMMIT = b7da87864ced8abd6c3715b65320efc233c0d853
NO_CONCURRENT_HEAVY_BUILD = CONFIRMED_BY_ROOT_PROCESS_AUDIT
```

## 2. Frozen hashes

```text
candidate theorem = a7f3bef1c7184b514c3cc6833da03a3eefd5f41b3bea58bf4062885d7bfab7b1
candidate audit = 4c75fd87933592842a70a4f861f29fa685c73ea81a62ed359437b8170506f688
lake-manifest.json = bc45e15b36f7aede2ceed922babf4bbcacb6789a1ec2d85bd571105fcd73926e
v2 preflight script = 947f5f3cfe16b12ec5c1f81262ea4fb9f99cd1c777d34cf938bfb57d01322d45
v2 contract = 929373ff344da13dd4af3f9a0b0066761df3ac6b6ab3bae5a3309e9664bece9a
v2 static review = acdb607aae59f9ed4c8198f38eb749a2e43ca32a3e438ceb9aabf1dc01f87300
toolchain = leanprover/lean4:v4.30.0
mathlib rev = c5ea00351c28e24afc9f0f84379aa41082b1188f
```

The theorem and audit copies in reconstruction are byte-identical to the
custody payload. The reconstruction and Mathlib tracked worktrees are clean.

## 3. Pre-run state

Before creating this report:

```text
F0 log = ABSENT
D1 log = ABSENT
P1 log = ABSENT
A1 log = ABSENT
FusionParametric olean/ilean = PRESENT_CACHE_NOT_PASS_EVIDENCE
RhinUnconditional olean/ilean = ABSENT
FusionRhinAnchored olean/ilean = ABSENT
available disk = AT_LEAST_12_GIB
```

## 4. Literal commands

F0, once and with a 120-second cap:

```sh
/usr/bin/time -p /opt/homebrew/bin/gtimeout 120 bash '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/scripts/rhin_v2_preflight.sh' > '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/rhin-v2-logs/F0_preflight.full.log' 2>&1
```

D1, once and only after F0 PASS:

```sh
/usr/bin/time -p /opt/homebrew/bin/gtimeout 900 lake build Erdos1135.ND.FusionParametric Erdos1135.ND.RhinUnconditional > '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/rhin-v2-logs/D1_dependency_prepay.full.log' 2>&1
```

P1, once and only after D1 PASS:

```sh
/usr/bin/time -p /opt/homebrew/bin/gtimeout 300 lake build Erdos1135.ND.FusionRhinAnchored > '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/rhin-v2-logs/P1_target_build.full.log' 2>&1
```

A1, once and only after P1 PASS:

```sh
/usr/bin/time -p /opt/homebrew/bin/gtimeout 300 lake env lean FusionRhinAnchoredAxiomAudit.lean > '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/rhin-v2-logs/A1_axiom_audit.full.log' 2>&1
```

## 5. Pre-run ledger

```text
F0_INVOCATIONS = 0
D1_INVOCATIONS = 0
P1_INVOCATIONS = 0
A1_INVOCATIONS = 0
FROZEN_INPUTS = MATCH
PUBLIC_PRE_RUN_PUSH = REQUIRED_BEFORE_F0
STOP_AT_FIRST_FAILURE = true
RETRY = forbidden
SOURCE_EDIT = forbidden
RESOURCE_ESCALATION = forbidden
TERMINAL_PUBLIC_PUSH = required_for_PASS_or_STOP
```

## 6. Terminal result

F0 was invoked exactly once from frozen commit
`d2c1792efd5e19382680e65151c7c8d90013e887`. It exited 1 after 0.02 seconds,
before any candidate, dependency or target build.

The local branch configuration names `origin` and
`refs/heads/agent/mazur-rhin-anchored-warm-gate-v2`, but this custody clone's
fetch refspec stores only
`codex/mazur-density-fusion-custody`. Consequently `git rev-parse '@{u}'`
could not resolve a remote-tracking ref and the frozen script stopped. The
branch itself is publicly present in draft PR #9; the failure is the local
upstream-receipt mechanism, not evidence that the push was absent.

```text
F0_INVOCATIONS = 1
F0_EXIT = 1
F0_WALL_SECONDS = 0.02
F0_USER_SECONDS = 0.00
F0_SYS_SECONDS = 0.01
F0_FAILURE_CLASS = UPSTREAM_BRANCH_NOT_STORED_AS_REMOTE_TRACKING_REF
F0_REMAINING_CHECKS = NOT_REACHED
F0_LOG_LINES = 4
F0_LOG_BYTES = 143
F0_LOG_SHA256 = 28f95091aea6ce3e74f7a41378e982240267c0b866690b31e53f900ca5d3e22f
D1_INVOCATIONS = 0
P1_INVOCATIONS = 0
A1_INVOCATIONS = 0
```

External read-only verification after the STOP found the exact public head at
`d2c1792efd5e19382680e65151c7c8d90013e887` through the remote branch,
`refs/pull/9/head` and the open draft PR. This verification classifies the
failure but does not retroactively turn F0 into PASS or authorize D1.

No dependency, target or audit phase was opened. No source, contract, script,
budget or cache was changed after the STOP, and no retry was made. The
candidate remains `UNKNOWN_NOT_AUDITED`.

```text
FINAL_VERDICT = F0_CUSTODY_UPSTREAM_REF_STOP
THEOREM_COMPILED = false
THEOREM_AXIOM_PROFILE = UNKNOWN_NOT_AUDITED
NO_RETRY
NO_DEPENDENCY_PREPAY
NO_TARGET_BUILD
NO_AUDIT
TERMINAL_PUBLIC_CUSTODY = REQUIRED
```
