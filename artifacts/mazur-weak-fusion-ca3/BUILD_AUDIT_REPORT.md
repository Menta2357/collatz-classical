# H1 reconstructed-build and axiom-audit report

Status: `RECONSTRUCTION_SMOKE_PASS_COMPILATION_PENDING_COORDINATOR_SLOT`

The guarded reconstruction was exercised once against a fresh extraction. No
Lean elaboration or build command has been run.

## Frozen execution contract — 2026-07-24

Execution root:

```text
/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/reconstruction-smoke
```

Global rules:

```text
ONE ATTEMPT PER PHASE
NO RESOURCE INCREASE
NO RETRY AFTER FAILURE
NO PUSH OR PUBLICATION
FULL COMBINED STDOUT/STDERR IN ONE LOG PER PHASE
POST-BUILD GIT STATUS AND DIFF REQUIRED
```

### E0 — frozen reconstruction

The target was created from a fresh extraction of the ZIP with SHA-256
`401a4674263112b81ff7e3c3eb43f3fca3d7eb320f418a39a5b606fb3b20bf09`.
`apply_payload.sh` returned exit code `0`; its base checks passed and all 11
candidate source/environment hashes passed. Before E1 the reconstructed tree
was committed as local Git baseline
`96fd91b910150c6e832dd9a889ddd01cad64b5f6`, solely to make the post-build diff
auditable. No source edit is authorized after that baseline.

### E1 — dependency lock

Exactly one execution, ceiling 300 seconds:

```text
/usr/bin/time -p /opt/homebrew/bin/gtimeout 300 lake update \
  > logs/E1_lake_update.full.log 2>&1
```

Any nonzero exit is `STOP_ENVIRONMENTAL`.

### E2 — declared Mathlib cache route

Only if E1 passes. Exactly one execution, ceiling 600 seconds:

```text
/usr/bin/time -p /opt/homebrew/bin/gtimeout 600 lake exe cache get \
  > logs/E2_mathlib_cache_get.full.log 2>&1
```

If the executable does not exist or the command fails, the result is
`STOP_ENVIRONMENTAL`; no alternate cache route or manual dependency copying is
authorized. If E1 exposes a different already-resolved cache route, execution
stops for coordinator consultation before changing this contract.

### P1 — unique theorem build

Only if E2 passes. Exactly one execution, ceiling 900 seconds:

```text
/usr/bin/time -p /opt/homebrew/bin/gtimeout 900 \
  lake build Erdos1135.ND.FusionParametric \
  > logs/P1_fusion_build.full.log 2>&1
```

Any nonzero exit is `STOP_BUILD`; there is no repair or second attempt in this
slot.

### A1 — unique axiom audit

Only if P1 passes. Exactly one execution, ceiling 300 seconds:

```text
/usr/bin/time -p /opt/homebrew/bin/gtimeout 300 \
  lake env lean FusionParametricAxiomAudit.lean \
  > logs/A1_axiom_audit.full.log 2>&1
```

Any nonzero exit, missing declaration, or `sorryAx` is `STOP_AUDIT`.

## Reconstruction

```text
base source commit: ca3dd0d63920411213403092aecc6946619eb082
payload: weak-fixed-target-fusion-7plus2.tar.gz
toolchain: leanprover/lean4:v4.30.0
mathlib: c5ea00351c28e24afc9f0f84379aa41082b1188f
```

## Authorized commands when the slot is granted

```text
./artifacts/mazur-weak-fusion-ca3/apply_payload.sh CLEAN_SOURCE_COPY
cd CLEAN_SOURCE_COPY
lake update
lake build Erdos1135.ND.FusionParametric
lake env lean FusionParametricAxiomAudit.lean
```

## Results

```text
apply exit code: 0
reconstruction candidate hashes: 11/11 PASS
lake update exit code: PENDING
build exit code: PENDING
audit exit code: PENDING
wall time: PENDING
axiom profile: PENDING
sorryAx: PENDING
post-build diff: PENDING
```

Promotion is forbidden until every field is replaced by captured evidence.
