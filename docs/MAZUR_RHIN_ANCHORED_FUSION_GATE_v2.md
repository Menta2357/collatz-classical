# Rhin-anchored H1 successor gate v2

Status: `AUTHORIZED / WARM_AWARE_PHASES_FROZEN / NOT_EXECUTED`

Date: 2026-07-24.

## 1. Custody and purpose

```text
branch = agent/mazur-rhin-anchored-warm-gate-v2
parent v1 STOP = 7c40912b8223c2ed7797073dd7f804cd0a0430ac
public v1 STOP = https://github.com/Menta2357/collatz-classical/pull/7
reconstruction base = b7da87864ced8abd6c3715b65320efc233c0d853
```

The v1 attempt timed out in the cold dependency closure before reaching the
target. This new contract does not repeat that combined target. It first asks
Lake to validate and complete the two direct dependency roots under a distinct
900-second D1 phase, then gives the target and audit separate budgets.

No v1 source, report or evidence is modified. Existing `.lake` objects are
cache inputs only, not evidence of PASS; Lake must validate them. `lake update`,
`cache get`, `.lake` deletion and from-scratch reconstruction are forbidden.

## 2. Frozen candidate and environment

```text
FusionRhinAnchored.lean sha256 =
a7f3bef1c7184b514c3cc6833da03a3eefd5f41b3bea58bf4062885d7bfab7b1
FusionRhinAnchoredAxiomAudit.lean sha256 =
4c75fd87933592842a70a4f861f29fa685c73ea81a62ed359437b8170506f688
lake-manifest.json sha256 =
bc45e15b36f7aede2ceed922babf4bbcacb6789a1ec2d85bd571105fcd73926e
toolchain = leanprover/lean4:v4.30.0
mathlib rev = c5ea00351c28e24afc9f0f84379aa41082b1188f
```

The candidate removes only the free `ND31Bounds` argument by consuming
`ndRhinRate_sameD_6993_200000.2.1`. It retains `hN0`, the strict `hsmall`
inequality and `FiniteBaseVerified N0 T`.

## 3. Publication and execution discipline

The preflight script, this contract, the static review and a pre-run report
must be committed and pushed to a draft PR stacked on the public v1 STOP
before F0. The terminal result and every log actually produced must be
committed and fast-forward pushed after either PASS or STOP.

The pre-run report must live at
`artifacts/mazur-rhin-anchored-ca3/rhin-v2-logs/RHIN_V2_RUN_REPORT_v1.md`.
It creates the log directory and freezes the prepared HEAD, public upstream
receipt, hashes, literal commands, zero phase counters and absence of all four
raw logs before execution.

No phase may be retried. A nonzero exit, timeout, missing artifact, source
drift, unexpected profile or resource mismatch is terminal. No source edit,
budget increase, amend, force-push, merge or retarget is authorized.

Only one heavy build may run at a time. The coordinating root must confirm
that no other project build is active before D1.

## 4. Sequential phase contract

Run all commands from the reconstruction root. Stop at the first failure.

### F0 — deterministic preflight, 120 s

```sh
/usr/bin/time -p /opt/homebrew/bin/gtimeout 120 bash '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/scripts/rhin_v2_preflight.sh' > '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/rhin-v2-logs/F0_preflight.full.log' 2>&1
```

F0 must verify the published custody branch and clean tracked state, the
reconstruction commit and clean tracked state, exact expected untracked scope,
byte-identical candidate, frozen hashes/toolchain/manifest, the actual clean
Mathlib checkout at the pinned revision, at least 12 GiB free, present
`FusionParametric` cache, absent Rhin/target artifacts and absent later-phase
logs.

### D1 — dependency prepayment, 900 s

Only after F0 PASS:

```sh
/usr/bin/time -p /opt/homebrew/bin/gtimeout 900 lake build Erdos1135.ND.FusionParametric Erdos1135.ND.RhinUnconditional > '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/rhin-v2-logs/D1_dependency_prepay.full.log' 2>&1
```

D1 PASS requires exit zero and `.olean` plus `.ilean` for both roots. A D1
failure is `DEPENDENCY_PREPAY_STOP`; P1 and A1 remain forbidden.

### P1 — isolated target elaboration, 300 s

Only after D1 PASS:

```sh
/usr/bin/time -p /opt/homebrew/bin/gtimeout 300 lake build Erdos1135.ND.FusionRhinAnchored > '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/rhin-v2-logs/P1_target_build.full.log' 2>&1
```

P1 PASS requires exit zero and target `.olean` plus `.ilean`. A P1 failure is
`TARGET_ELABORATION_STOP`; A1 remains forbidden.

### A1 — producer and consumer audit, 300 s

Only after P1 PASS:

```sh
/usr/bin/time -p /opt/homebrew/bin/gtimeout 300 lake env lean FusionRhinAnchoredAxiomAudit.lean > '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/rhin-v2-logs/A1_axiom_audit.full.log' 2>&1
```

PASS requires both printed declarations — the pinned upstream producer and
the anchored consumer — to contain exactly the standard profile
`propext`, `Classical.choice`, `Quot.sound`, with no additional axiom. Any
other result is `AUDIT_STOP` and establishes no kernel-clean claim.

## 5. Scope of a PASS

A PASS establishes only the anchored conditional corollary: given the strict
quantitative gate and a certified finite base, the pinned upstream ND31 bound
implies positive lower natural density. It does not discharge `hsmall`, build
the finite base, prove density one or prove Collatz.

```text
F0_INVOCATIONS = 0
D1_INVOCATIONS = 0
P1_INVOCATIONS = 0
A1_INVOCATIONS = 0
PUBLIC_TERMINAL_CUSTODY = REQUIRED
NO_RETRY
NO_GLOBAL_COLLATZ_CLAIM
```
