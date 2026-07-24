# F3 arithmetic-codec pilot — environment checkpoint v1

Status: `ENV_READY_VERIFIED_FOR_PILOT — PILOT_EXECUTED=NO — HUMAN_REAUTHORIZATION_HOLD`

No pilot elaboration is authorized by this checkpoint.

## Matching project inputs

Worktree:
`/Users/MoiTam/Documents/Codex/2026-07-21/f3-density-update`.

Dependency build donor:
`/Users/MoiTam/Documents/Codex/collatz-classical`.

```text
Lean toolchain              leanprover/lean4:v4.21.0
lean-toolchain sha256       d24fed434d3b13adfaab57724a0a7f270ea8bf1c818b5ae5cf25cbce24dd685c
lakefile.lean sha256        e31ac41ac108fbd7e30db1bc982a065949d359146e110ee04212378645e54fca
lake-manifest.json sha256   230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b
Mathlib commit              308445d7985027f538e281e18df29ca16ede2ba3
```

The toolchain, lakefile, manifest, Mathlib commit, and all pinned dependency
heads match between the F3 worktree and donor.  The pilot import closure is:

```text
F3ReturnExcursionCoreArithmeticCodecPilot
  -> F3ReturnExcursionExactCoreMatrix
  -> Mathlib
```

## Frozen dependency

```text
source path:
<F3_WORKTREE>/CollatzClassical/KL2003/F3ReturnExcursionExactCoreMatrix.lean

source sha256:
58ab7b1acdb7bc6d69fffa04c4baa7ae29ac31e24e80834387974113b70d2ba5

source commit:
2f0981d7a8d5084c1873637e12d4cc045f500c22

olean path:
<DONOR>/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionExactCoreMatrix.olean

olean sha256:
34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
```

The source hash is custodied in
`F3_LEAN_M0B_REAL_BRIDGE_MANIFEST_v1.json`.  The exact-matrix compile report
records a successful 220.18-second build; the `.olean` timestamp follows the
source timestamp and downstream audited modules were built successfully from
it under Lean 4.21.  An independent non-elaborating dependency preflight with
direct Lean, explicit `LEAN_PATH`, `--root=<F3_WORKTREE>`, and `--deps`
resolved this exact `.olean`, returned zero, and produced no output artifact.

## Root mismatch found and corrected

The recorded `STOP_BEFORE_ELABORATION` came from invoking `lake env lean` in
the donor root while passing a source outside that root.  Lake rejected the
path before Lean parsed the file.

The corrected arrangement is:

1. current directory and `--root` are the F3 worktree;
2. invoke the exact Lean 4.21 binary directly, not Lake in the donor root;
3. set `LEAN_PATH` to the donor's verified build paths;
4. write `-o` and `-i` only below the F3 worktree;
5. for a post-PASS audit, prepend the F3 local build path to the same
   dependency path.

This avoids root containment without modifying `master`.

## Independent source-to-olean rebuild history

After the initial checkpoint, an independent process attempted to rebuild
only `F3ReturnExcursionExactCoreMatrix` in the disposable root
`/tmp/f3_env_gate.sRowrU`.  Its controlled inputs were:

```text
source sha256          58ab7b1acdb7bc6d69fffa04c4baa7ae29ac31e24e80834387974113b70d2ba5
Lean                   4.21.0
LEAN_PATH              compatible package/Mathlib builds, donor project olean excluded
root                   /tmp/f3_env_gate.sRowrU
wall ceiling           300 s
```

The process exited `124` at 300 seconds, emitted no diagnostic, and produced
neither `.olean` nor `.ilean`.  `GenuineBandRate` compilation was active in
parallel, so contention is a live alternative explanation.  This result is
therefore neither a mathematical failure nor evidence that the dependency is
unreproducible.  It establishes only:

```text
ENV_REBUILD_NOT_COMPLETED = true
ENV_REBUILD_SECONDS = 300
ENV_REBUILD_CONTENTION_POSSIBLE = true
SOURCE_TO_REBUILT_OLEAN_IDENTITY = NOT_ESTABLISHED
```

The pilot itself was not executed or elaborated, and its worktree was not
modified by this independent attempt.

### Final isolated rebuild — PASS

A later isolated rebuild closed the source-to-olean identity under an idle,
compatible environment.  It used the same frozen source and did not use the
project donor build:

```text
source sha256          58ab7b1acdb7bc6d69fffa04c4baa7ae29ac31e24e80834387974113b70d2ba5
Lean                   4.21.0
Mathlib commit         308445d7985027f538e281e18df29ca16ede2ba3
donor build used       no
exit code              0
real seconds           138.42
rebuilt olean bytes    1967392
rebuilt olean sha256   34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
donor olean sha256     34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
byte comparison        identical (cmp=0)
```

Thus the independently rebuilt object is byte-identical to the custodied
donor object.  This supersedes the earlier inconclusive timeout as the final
environmental verdict without erasing that timeout from the history.

### Minimal import probe — PASS

A separate minimal probe contained only the import plus checks of
`CoreEdge`, `coreEdges`, and `coreMatrix`:

```text
probe source sha256    7ea3093c5f3e4354f9c606809c5e0314dd7cd6ded57003545ba81347eeceddf8
exit code              0
real seconds           116.75
names/types exposed    CoreEdge, coreEdges, coreMatrix
```

No pilot declaration was executed or elaborated.  No process remained after
the checks, and the F3 worktree and pilot source remained intact.

## Final environment verdict

The four environment labels are intentionally distinct:

```text
ENV_RESOLUTION_READY = true
ENV_READY_BY_CUSTODY = available
ENV_REBUILD_NOT_COMPLETED_PRIOR_ATTEMPT = true
ENV_REBUILD_COMPLETED_FINAL = true
ENV_READY_VERIFIED_FOR_PILOT = true
PILOT_EXECUTED = NO
```

`ENV_RESOLUTION_READY` means every required import is resolvable and the safe
invocation route is known.  `ENV_READY_BY_CUSTODY` remains a valid historical
route, but the byte-identical isolated rebuild now independently establishes
`ENV_READY_VERIFIED_FOR_PILOT`.

Only governance remains open: `HUMAN_REAUTHORIZATION_HOLD`.  No new pilot
attempt may run until an explicit fresh-attempt authorization is recorded.
