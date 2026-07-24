# H1 reconstructed-build and axiom-audit report

Status: `PASS_WEAK_CONDITIONAL_API_BUILD_AND_AXIOM_AUDIT`

The guarded reconstruction was exercised once against a fresh extraction. The
frozen dependency, build, and axiom-audit sequence completed without retry,
resource increase, source edit, push, or publication.

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

#### Enmienda coordinada — 2026-07-24

E1 passed and its official Mathlib post-update hook itself built and executed
the cache client, reported the Azure cache origin, decompressed 8283
already-cached files, found no files to download, and completed successfully.
After the contractually required consultation, the coordinator classified E2
as `SATISFIED_BY_E1_OFFICIAL_POST_UPDATE_HOOK`. The independent E2 command is
therefore deliberately not executed: it would repeat the same official cache
route without buying additional environmental preparation. P1 is authorized
under this explicit amendment; all other ceilings and no-retry rules remain
unchanged.

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
E1 lake update exit code: 0
E1 timing: real 228.42s; user 75.97s; sys 53.22s
E2: SATISFIED_BY_E1_OFFICIAL_POST_UPDATE_HOOK; independent command not run
P1 build exit code: 0
P1 timing: real 440.51s; user 26.36s; sys 80.46s
P1 result: Build completed successfully (2962 jobs)
A1 audit exit code: 0
A1 timing: real 48.04s; user 1.82s; sys 6.71s
captured real time total: 716.97s
axiom coverage: 12/12 listed declarations
axiom profile: [propext, Classical.choice, Quot.sound] for every declaration
sorryAx: absent from every printed axiom profile
Lean.ofReduceBool: absent from every printed axiom profile
post-build tracked diff: empty
post-build untracked outputs: .lake/, lake-manifest.json, logs/
```

Full combined stdout/stderr is preserved byte-for-byte under `logs/`. The
resolved manifest and literal post-build Git evidence are under `evidence/`.
This PASS validates the reconstructed conditional API and its stated axiom
profile; it does not discharge any of the explicit mathematical hypotheses of
the conditional fusion theorem.
