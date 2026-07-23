# H1 reconstructed-build and axiom-audit report

Status: `RECONSTRUCTION_SMOKE_PASS_COMPILATION_PENDING_COORDINATOR_SLOT`

The guarded reconstruction was exercised once against a fresh extraction. No
Lean elaboration or build command has been run.

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
