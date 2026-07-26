# F3 R3 v3 exact-seven execution-freeze P1 retraction and successor repair gate v1

Date: 2026-07-26.

## Root verdict

```text
PUBLIC_CUSTODY_COMMIT = 8cd1dd2889798ce9bf9a5850b96ac9649f521373
PUBLIC_CUSTODY_BYTES_VERDICT = PASS_EXACT_TEN_PATH_COMMIT
EXACT_SEVEN_BYTE_IDENTITY = PRESERVED_7_OF_7
EXECUTION_FREEZE_VERDICT = RETRACTED_P1
P1_RESIDUAL = NONZERO
B0_AUTHORITY = NONE
R0_AUTHORITY = NONE
DEPENDENCY_OBSERVATION_AUTHORITY = NONE
LEAN_AUTHORITY = NONE
LAKE_AUTHORITY = NONE
PILOT_EXECUTION_OPENED = NO
STOP_BEFORE_B0
```

The public commit remains valid custody of exactly seven authored inputs, two
static audits, and one root freeze.  This act does not rewrite or delete that
historical evidence.  It retracts only its fitness as an execution freeze:
the two `P1_RESIDUAL=0` audit conclusions and the v1 root freeze may not be
used to authorize B0.

## Confirmed P1: uncensused Lake configuration artifacts

The frozen executor snapshots only:

```text
$ROOT/.lake/build
$ROOT/.lake/packages
/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean
```

Its unexpected-path traversal likewise covers the result root,
`$ROOT/.lake/build`, and `CollatzClassical/KL2003`, but not the direct children
of `$ROOT/.lake` outside `build` and `packages`.

The pinned Lake 4.21 source
`src/lean/Lake/Lake/Load/Lean/Elab.lean` defines and may create, remove, or
rewrite these package-configuration paths during configuration loading:

```text
.lake/lakefile.olean
.lake/lakefile.olean.trace
.lake/lakefile.olean.lock
```

The first two are already observed in the author checkout as regular files;
the lock is a conditional configuration-lock path.  A clean worktree can
therefore acquire writes outside the executor's frozen evidence surface while
the current source still claims that every other write is INVALID.  This is a
source-contract P1, independent of whether a particular future invocation
happens to reuse a current trace.

## Additional pre-B0 P1 obligations

The successor review must also resolve, rather than defer to a runbook:

1. a dedicated worktree does not inherit `.lake/packages`, while B0 requires
   zero package/sysroot delta;
2. package and sysroot snapshots are currently compared within one phase,
   but their cross-phase frozen identity and the static-preexisting object
   ledger require an explicit proof or repair;
3. the command table's exact object paths and order require a separately
   authorized, non-speculative derivation before B0; and
4. the future runbook is authority number seven and must enter public custody
   before the execution HEAD and typed manifests can name it.

No typed input, runbook, or dependency ledger may be frozen while the first
two obligations remain unresolved.

## Authorized successor work under this gate

This gate authorizes only read-only source inspection, local hash/Git checks,
and preparation of a narrowly scoped successor-repair proposal.  It does not
authorize editing the seven inputs yet.  A later root act must name the exact
replacement paths, schemas, write set, validation commands, two-audit tuple,
and successor-freeze names before any repair is applied.

The successor proposal must at minimum provide:

- explicit pre/post states for every allowed direct `.lake` artifact;
- fail-closed census of unexpected direct `.lake` entries and configuration
  lock residue;
- immutable package/sysroot prestate semantics across the whole run;
- C0 custody of partial or drifted configuration/package states;
- updated authority paths that no longer rely on the retracted v1 audit pair
  and freeze as current PASS evidence; and
- two new independent static audits of the complete final seven-byte tuple.

## No-claim boundary

```text
NO_B0_RESULT
NO_R0_RESULT
NO_GENERATED_CERTIFICATE
NO_CHECKER_RESULT
NO_SIX_ROW_PASS_OR_STOP
NO_RHO_CERTIFICATE
NO_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
```
