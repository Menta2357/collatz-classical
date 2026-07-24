# Mazur ND31 weak-fusion publication preflight v1

Audit date: 2026-07-24

Status:

```text
STOP_NO_PUSH_NO_PR
REMOTE_AND_ANCESTRY_PASS
CA3_PACKAGE_COMMIT_ROLE_VERIFIED
F386_FROZEN_PAPER_ROLE_NOT_VERIFIED
ROOT_AND_ARTIFACT_NOTICE_REMEDIATED
PAYLOAD_MODIFIED_FILE_NOTICES_BLOCK_PUBLICATION
GH_CLI_MISSING_BLOCK_PUBLICATION
```

This is a publication preflight, not a publication authorization. It neither
creates nor pushes a branch and it does not open a pull request.

## Remote and ancestry receipts

The configured remote is
`https://github.com/Menta2357/collatz-classical.git`. A live, read-only
`git ls-remote` returned:

```text
origin/master = ccc561db3a6aa45006229ae15fef55e05fbb6ab0
origin/codex/mazur-density-fusion-custody =
  7f659eb482e5984a70b83fc7ab6e4548a3831596
```

The proposed public branch name
`agent/mazur-weak-fixed-target-fusion-ca3` and the internal name
`codex/mazur-density-fusion-weak-custody` returned no remote head. The branch
name is therefore free at this check.

For the reviewed publication candidate
`58981ffb2bb3ae6954a1871a402c04ce818419cd`:

```text
merge-base(candidate, base) = 7f659eb482e5984a70b83fc7ab6e4548a3831596
base is an ancestor of candidate = yes
commits after base = 7
base tree = 3618d4def48fbd7115582cddc493edb49b1f8c02
candidate tree = 9f4162411da06a4e7f3093ab95773358b55c611a
diff = 18 added paths, 576 inserted text lines, one 7544-byte tar payload
```

The diff contains no `.lake`, `.olean`, `Mathlib`, `vendor`, `third_party`,
`node_modules`, or other dependency tree. The tar contains exactly nine
entries and all nine end in `.lean`. The resolved Lake manifest records Git
dependency revisions but does not vendor those dependencies.

## ProofAtlas provenance roles

### `ca3dd0d...`: verified, with calibrated wording

The local ProofAtlas metadata literally records
`ca3dd0d63920411213403092aecc6946619eb082` as `packageCommit` in:

- `proofatlas-source-manifest.json`, whose schema is
  `public-site-source-bundle-manifest.v2`;
- `proofatlas-continuation.json`;
- both checked artifact evidence files.

The paper-package evidence also literally records
`currentPublicationRoute = reviewed_commit_pinned_public_source` and
`status = accepted_result_recorded`. This supports the wording:

```text
ProofAtlas package commit for the reviewed commit-pinned public-source route
```

It does not support silently identifying this commit with any other commit.
The same metadata has `releasePlanStatus = draft`, so the stronger shorthand
“released package” should be avoided unless ProofAtlas supplies a separate
literal receipt for that exact role.

### `f386357d...`: not verified

No recovered ZIP, bundle, object, source manifest, continuation metadata, or
ProofAtlas evidence file names `f386357d...`. `git cat-file` rejects that
prefix in both the custody repository and the local ca3 mirror, and no file in
the local Downloads inventory names it. Occurrences in this project are our
own discrepancy reports, not upstream evidence.

Consequently this preflight does **not** call `f386357d...` the frozen paper,
does not assert equality or ancestry between it and `ca3dd0d...`, and forbids
that attribution in the branch or PR until a literal upstream receipt is
obtained.

## License and NOTICE audit

The ca3 source ZIP contains the Apache License 2.0 and a separate NOTICE:

```text
LICENSE SHA-256 = cfc7749b96f63bd31c3c42b5c471bf756814053e847c10f3eb003417bc523d30
LICENSE bytes = 11358
NOTICE SHA-256 = 78d24afa82e943d2bd65af48accb0a802d1debc12043394e398899fdaacb3a3c
NOTICE bytes = 309
NOTICE copyright holder = Copyright 2026 Advameg, Inc.
```

The NOTICE says that Mathlib, retained Formal Conjectures material, and cited
papers retain their own copyrights and licenses. The custody repository's
pre-existing root `LICENSE` is also Apache-2.0 but is not byte-identical to the
source copy (SHA-256
`b40930bbcf80744c86c46a12bc9da056641d722716c378f5659b9e555ef833e1`).

Before this preflight the custody branch had no NOTICE. Because Apache-2.0
section 4(d) requires a readable copy of pertinent NOTICE attributions when a
distributed Work contains one, this preflight adds the exact 309-byte NOTICE
at repository root and exact upstream `LICENSE`/`NOTICE` copies under
`artifacts/mazur-weak-fusion-ca3/upstream-licensing/`. Their hashes match the
source ZIP byte for byte.

The frozen 7+2 tar itself contains only its nine Lean paths and no
`LICENSE`/`NOTICE`. It must not be released as a standalone archive. Repository
distribution must retain the root and artifact-local copies added here. A
future standalone archive must be regenerated to contain the applicable
license and NOTICE itself.

## Modified-file audit of the 7+2 payload

Apache-2.0 section 4(b) separately requires modified files to carry prominent
notices stating that they were changed. Current state:

| Path | Relationship to ca3 | Current notice state |
| --- | --- | --- |
| `Erdos1135/ND/CountingCore.lean` | extracts definitions from `Conventions.lean` | prose says factored out and bodies unchanged; explicit dated modification notice still advisable |
| `Erdos1135/ND/StatementCore.lean` | extracts definitions from `Statement.lean` | prose says factored out and bodies unchanged; explicit dated modification notice still advisable |
| `Erdos1135/ND/FiniteBaseCertificate.lean` | new integration module | no copied body identified |
| `Erdos1135/ND/FusionParametric.lean` | new integration module | no copied body identified |
| `Erdos1135/ND/Conventions.lean` | upstream file changed to import core and remove moved definitions | no explicit modification notice |
| `Erdos1135/ND/Statement.lean` | upstream file changed to import core and remove moved definitions | no explicit modification notice |
| `FusionParametricAxiomAudit.lean` | new audit module | no copied body identified |
| `Erdos1135/Basic.lean` | upstream import redirected | no explicit modification notice |
| `FormalConjectures/Wikipedia/CollatzStep.lean` | definition-only extraction from `CollatzConjecture.lean` | original copyright/license header and explicit change notice are missing |

The original Formal Conjectures source literally carries:

```text
Copyright 2025 The Formal Conjectures Authors.
Licensed under the Apache License, Version 2.0
```

Its exact source file SHA-256 is
`cc45c97c70147327f010caf8d827ad1eb5030ed5686872330188a13a3f6971c8`.
The compatibility extraction is Apache-compatible, but its omitted header is
a publication blocker. Therefore the final claim is not yet “all vendored
licensing clean”; it is “no incompatible dependency tree is vendored, with a
known attribution defect in one extracted compatibility file and missing
change notices in three directly modified upstream files.”

## Required remediation before push

1. Restore the Formal Conjectures copyright/Apache header in
   `CollatzStep.lean` and add a prominent definition-only extraction notice.
2. Add explicit modification notices to `Conventions.lean`, `Statement.lean`,
   and `Basic.lean`; make the existing extraction notices in the two core
   modules unambiguous.
3. Regenerate the 7+2 tar and every affected candidate/payload hash. Preserve
   the current tar as historical evidence; do not overwrite custody history.
4. Reconstruct from the ca3 ZIP and rerun the build/axiom gate against the
   publication payload. Comments should be semantically inert, but the
   published bytes must be the bytes that the final gate checks.
5. Update or explicitly mark the Gate-1 “build pending” text as a historical
   snapshot so it cannot be mistaken for current status.
6. Keep all `f386357d...` role and ancestry claims absent.
7. Install and authenticate GitHub CLI, then repeat remote/base checks.

## Prepared branch and draft PR

```text
branch: agent/mazur-weak-fixed-target-fusion-ca3
remote: origin
PR base: codex/mazur-density-fusion-custody
base commit: 7f659eb482e5984a70b83fc7ab6e4548a3831596
draft title: Add audited weak fixed-target density-fusion interface
```

The PR scope is the reproducible ca3-based 7+2 integration payload, guarded
reconstruction, conditional weak positive-lower-density API, finite-base
certificate interface, full build/axiom logs, provenance records, and exact
license/NOTICE custody. It must say explicitly that the mathematical theorem
is conditional, supplies no concrete `q` or finite base, proves no density
limit, and proves no global Collatz result.

Required final checks are listed in
`MAZUR_ND31_WEAK_FUSION_PR_DRAFT_v1.md`.

## Tooling gate

`gh --version` failed with exit code 127 (`command not found`). Under the
GitHub publication workflow, authentication cannot be checked and neither a
push nor PR creation is permitted. No branch was created, no push occurred,
and no PR was opened in this preflight.
