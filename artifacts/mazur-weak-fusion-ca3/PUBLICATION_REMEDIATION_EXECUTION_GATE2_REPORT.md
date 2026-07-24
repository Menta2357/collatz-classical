# H1 publication-remediation execution Gate 2

Status: `FROZEN_EXECUTION_PENDING`

Frozen: 2026-07-24

This is a new execution gate. It does not amend, reuse, or reinterpret the
failed gate recorded in `PUBLICATION_REMEDIATION_BUILD_AUDIT_REPORT.md`.

## Capacity receipt before execution

```text
filesystem: /dev/disk3s5
size: 460 GiB
used: 409 GiB
available: 25 GiB / 25,881,084 KiB
capacity: 95%
```

The isolated target did not exist at freeze time:

```text
/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/reconstruction-publication-gate2-ef1a5a7
```

## Immutable inputs

```text
custody starting HEAD: 1d5cb27e12f4bbf14f4f2acdf06bedcf35948d93
payload custody commit: 4b34d5fb029248b389a33558d7121ab5c2349558
extension source commit: ef1a5a75d92f75c5550e2ba261726d7264005f4e
ca3 source commit: ca3dd0d63920411213403092aecc6946619eb082
source ZIP SHA-256: 401a4674263112b81ff7e3c3eb43f3fca3d7eb320f418a39a5b606fb3b20bf09
publication tar SHA-256: 4ceeb087ec3faa9ec95566888b6487dbabbc6317714c0e080dc44fd3b4d45b25
candidate manifest SHA-256: 738d42c6125323b4f762a9db38f3434b7e8d311b08d5c2636a122b96cb71c68f
base manifest SHA-256: db759754932379e318d628c3bd102bdbf1ef984bfcfe6e053adc18e36f9b4d4c
payload manifest SHA-256: 886705e02c8c803baca6a23cb973a3a1ea2251fafebd7217c28e6d776864f9fb
toolchain: leanprover/lean4:v4.30.0
mathlib: c5ea00351c28e24afc9f0f84379aa41082b1188f
```

Static inventory passed before freeze:

```text
tar regular files: 11
tar Lean files: 9
tar LICENSE: 1
tar NOTICE: 1
source remediation diff: 9 files, 76 insertions, zero deletions
dated local notices: 9/9
Formal Conjectures copyright/Apache header: present
git diff --check: PASS
sorry/admit/native_decide/Lean.ofReduceBool/odd_to_all/f386: 0
```

## Global execution rules

```text
ONE EXECUTION PER PHASE
STRICTLY SEQUENTIAL R0 -> R1 -> E1/E2 -> P1 -> A1
STOP ON FIRST NONZERO EXIT
NO RETRY
NO RESOURCE ESCALATION
NO SOURCE EDIT AFTER RECONSTRUCTION BASELINE
FULL COMBINED STDOUT/STDERR PER EXECUTED PHASE
POST-RUN TRACKED SOURCE DIFF REQUIRED
NO PUSH OR PR
```

Logs are written under:

```text
artifacts/mazur-weak-fusion-ca3/publication-remediation-gate2-logs/
```

### R0 — fresh extraction, ceiling 120 seconds

```text
/usr/bin/time -p /opt/homebrew/bin/gtimeout 120 unzip -q \
  /Users/MoiTam/Downloads/natural-density-log-time-collatz-checked-source-ca3dd0d63920.zip \
  -d /Users/MoiTam/Documents/New\ project/coordinated/hilo1-fusion/reconstruction-publication-gate2-ef1a5a7 \
  > artifacts/mazur-weak-fusion-ca3/publication-remediation-gate2-logs/R0_extract.full.log 2>&1
```

### R1 — guarded payload application, ceiling 120 seconds

```text
/usr/bin/time -p /opt/homebrew/bin/gtimeout 120 \
  ./artifacts/mazur-weak-fusion-ca3/apply_payload.sh \
  /Users/MoiTam/Documents/New\ project/coordinated/hilo1-fusion/reconstruction-publication-gate2-ef1a5a7 \
  > artifacts/mazur-weak-fusion-ca3/publication-remediation-gate2-logs/R1_apply.full.log 2>&1
```

Only after R1 passes, create a local Git baseline over the reconstructed
source. Its commit is evidence, not a publication commit.

### E1/E2 — dependency resolution and official cache hook, ceiling 300 seconds

From the isolated reconstruction:

```text
/usr/bin/time -p /opt/homebrew/bin/gtimeout 300 lake update \
  > /Users/MoiTam/Documents/New\ project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-weak-fusion-ca3/publication-remediation-gate2-logs/E1_lake_update.full.log 2>&1
```

E2 is satisfied only if the official Mathlib post-update hook reports
successful cache preparation. No independent redundant cache command is run.

### P1 — target build, ceiling 900 seconds

```text
/usr/bin/time -p /opt/homebrew/bin/gtimeout 900 \
  lake build Erdos1135.ND.FusionParametric \
  > /Users/MoiTam/Documents/New\ project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-weak-fusion-ca3/publication-remediation-gate2-logs/P1_fusion_build.full.log 2>&1
```

### A1 — full declared axiom audit, ceiling 300 seconds

```text
/usr/bin/time -p /opt/homebrew/bin/gtimeout 300 \
  lake env lean FusionParametricAxiomAudit.lean \
  > /Users/MoiTam/Documents/New\ project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-weak-fusion-ca3/publication-remediation-gate2-logs/A1_axiom_audit.full.log 2>&1
```

## Results

```text
R0: PENDING
R1: PENDING
reconstruction baseline: PENDING
E1/E2: PENDING
P1: PENDING
A1: PENDING
audit coverage/profile: PENDING
post-run source diff: PENDING
```

## Publication tooling boundary

GitHub CLI `2.79.0` is installed, but `gh auth status` reports the active
`Menta2357` token as invalid. Even if this execution gate passes, push and PR
creation remain blocked until explicit re-authentication.
