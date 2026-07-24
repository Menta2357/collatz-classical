# H1 Apache-remediated publication build and axiom audit

Status: `STATIC_PASS_EXECUTION_PENDING`

Frozen: 2026-07-24

## Immutable inputs

```text
custody payload commit: 4b34d5fb029248b389a33558d7121ab5c2349558
extension source commit: ef1a5a75d92f75c5550e2ba261726d7264005f4e
source ZIP SHA-256: 401a4674263112b81ff7e3c3eb43f3fca3d7eb320f418a39a5b606fb3b20bf09
publication tar SHA-256: 4ceeb087ec3faa9ec95566888b6487dbabbc6317714c0e080dc44fd3b4d45b25
toolchain: leanprover/lean4:v4.30.0
mathlib: c5ea00351c28e24afc9f0f84379aa41082b1188f
```

The tar was independently rebuilt three times from the exact extension commit
with byte-identical output. It has 11 regular files: nine Lean sources, the
exact ca3 `LICENSE`, and the exact ca3 `NOTICE`. All nine Lean paths carry a
calibrated local modification/addition notice. The Formal Conjectures
compatibility extraction restores the source's exact 15-line copyright and
Apache-2.0 header before the local modification notice.

Static diff from the previously built source commit adds only 76 comment
lines across the nine Lean paths. `git diff --check` passed; no `sorry`,
`admit`, `native_decide`, `Lean.ofReduceBool`, `odd_to_all`, or `f386357d`
occurs in the publication proof surface.

## Execution rules

```text
ONE EXECUTION PER PHASE
NO RESOURCE INCREASE
NO RETRY AFTER FAILURE
STOP ON FIRST NONZERO EXIT
FULL COMBINED STDOUT/STDERR PER PHASE
NO SOURCE EDIT AFTER RECONSTRUCTION BASELINE
NO PUSH OR PR
```

Execution target:

```text
/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/reconstruction-publication-ef1a5a7
```

Logs:

```text
/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-weak-fusion-ca3/publication-remediation-logs
```

### R0 — one fresh extraction

```text
/usr/bin/time -p /opt/homebrew/bin/gtimeout 120 unzip -q \
  /Users/MoiTam/Downloads/natural-density-log-time-collatz-checked-source-ca3dd0d63920.zip \
  -d /Users/MoiTam/Documents/New\ project/coordinated/hilo1-fusion/reconstruction-publication-ef1a5a7 \
  > artifacts/mazur-weak-fusion-ca3/publication-remediation-logs/R0_extract.full.log 2>&1
```

### R1 — one guarded payload application

```text
/usr/bin/time -p /opt/homebrew/bin/gtimeout 120 \
  ./artifacts/mazur-weak-fusion-ca3/apply_payload.sh \
  /Users/MoiTam/Documents/New\ project/coordinated/hilo1-fusion/reconstruction-publication-ef1a5a7 \
  > artifacts/mazur-weak-fusion-ca3/publication-remediation-logs/R1_apply.full.log 2>&1
```

Only after R1 passes, initialize a local Git baseline over the reconstructed
source and record its commit. This baseline is evidence only.

### E1 — one dependency resolution

From the reconstructed target:

```text
/usr/bin/time -p /opt/homebrew/bin/gtimeout 300 lake update \
  > /Users/MoiTam/Documents/New\ project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-weak-fusion-ca3/publication-remediation-logs/E1_lake_update.full.log 2>&1
```

If the official Mathlib post-update hook reports successful cache preparation,
that hook satisfies E2; no redundant independent cache command is run.

### P1 — one theorem build

```text
/usr/bin/time -p /opt/homebrew/bin/gtimeout 900 \
  lake build Erdos1135.ND.FusionParametric \
  > /Users/MoiTam/Documents/New\ project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-weak-fusion-ca3/publication-remediation-logs/P1_fusion_build.full.log 2>&1
```

### A1 — one axiom audit

```text
/usr/bin/time -p /opt/homebrew/bin/gtimeout 300 \
  lake env lean FusionParametricAxiomAudit.lean \
  > /Users/MoiTam/Documents/New\ project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-weak-fusion-ca3/publication-remediation-logs/A1_axiom_audit.full.log 2>&1
```

## Results

```text
R0: PENDING
R1: PENDING
reconstruction baseline: PENDING
E1: PENDING
E2: PENDING
P1: PENDING
A1: PENDING
axiom inventory: PENDING
post-build source diff: PENDING
```
