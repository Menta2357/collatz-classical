# F3 R3 v3 Lake top-level and frozen-environment repair root authorization v1

Date: 2026-07-26.

## Root decision

```text
AUTHORIZATION = GRANTED_STATIC_SUCCESSOR_AUTHORING_ONLY
AUTHORIZED_CODE_TARGET_COUNT = 1
AUTHORIZED_CODE_TARGET = outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_executor.sh
AUTHORIZED_EVIDENCE_WRITE_COUNT = 3
AUTHORIZED_POSTPUBLICATION_RECEIPT_COUNT = 1
EXACT_SEVEN_CARDINALITY_AFTER_REPAIR = 7
LEAN_AUTHORITY = NONE
LAKE_AUTHORITY = NONE
BFS_AUTHORITY = NONE
GENERATOR_AUTHORITY = NONE
B0_AUTHORITY = NONE
R0_AUTHORITY = NONE
PILOT_EXECUTION_OPENED = NO
GLOBAL_PRE_B0_P1_RESIDUAL = NONZERO
```

This act is the successor authoring authority required by
`F3_R3_V3_EXACT_SEVEN_EXECUTION_FREEZE_P1_RETRACTION_AND_SUCCESSOR_REPAIR_GATE_v1.md`,
SHA-256
`7d760deb7dabf89c5983912948fb6592ecb97e77793da6942a80b3ee742867a6`.
It does not revive either v1 static audit or the v1 execution freeze.

The public custody commit
`8cd1dd2889798ce9bf9a5850b96ac9649f521373` remains the historical byte
custody of the original exact-seven tuple.  The retraction commit is
`de9481ccff69e0d7db091e49771b3f5328ce81d3`.  No execution occurred under
the retracted freeze.

## Exact write set

The candidate-authoring transaction authorized by this act may modify or
create only the following four paths:

1. `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_executor.sh`;
2. `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_R3_V3_EXACT_SEVEN_INPUT_INDEPENDENT_STATIC_AUDIT_1_PASS_v2.md`;
3. `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_R3_V3_EXACT_SEVEN_INPUT_INDEPENDENT_STATIC_AUDIT_2_PASS_v2.md`;
4. `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_R3_V3_EXACT_SEVEN_INPUT_ROOT_FREEZE_DECISION_v2.md`.

After that candidate commit exists publicly, one separate postpublication
transaction may create exactly this fifth path and no other path:

5. `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_R3_V3_EXACT_SEVEN_INPUT_PUBLIC_CUSTODY_RECEIPT_v2.md`.

The fifth path records the candidate commit hash, its parent, its public
remote/ref verification, and the hashes of the four candidate-transaction
paths.  It cannot be created in the candidate commit and may not alter any
candidate byte.

This authorization file is published alone before that transaction and is
not part of its mutable write set.  The two audit paths may be created only
by independent read-only audits after the executor candidate is frozen.  The
root-freeze path may be created only after both audits report, for the same
seven-byte tuple, the literal fields without abbreviation
`P1_RESIDUAL_IN_LAKE_ENVIRONMENT_REPAIR_SCOPE=0` and
`P2_RESIDUAL_IN_LAKE_ENVIRONMENT_REPAIR_SCOPE=0`.  They must simultaneously
report `GLOBAL_PRE_B0_P1_RESIDUAL=NONZERO`.

No contract, registry, template, Lean source, memory guard, materializer,
typed run input, result path, `.lake` path, worktree, branch, or toolchain file
may be modified by the repair transaction.

## Six immutable members of the successor exact-seven tuple

The following members must remain byte- and mode-identical:

| Path | SHA-256 | Bytes | Lines | Mode |
|---|---|---:|---:|---:|
| `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotRowsV3.lean` | `1279be4863dc8fdbda04c6e763f010420e69328abb08450ce0ec27f565cec2b1` | 8862 | 202 | 0644 |
| `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotGenerateV3.lean` | `300060274c49a18bbbf34491490dfe9e22f428ce170e2e1ae634d8626cc6a6d9` | 3970 | 107 | 0644 |
| `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotV3.lean` | `74c402e7b906813eeb4127b4a46f7465ecd9e33b7f1e5463f951509d50799248` | 4824 | 134 | 0644 |
| `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotV3AxiomAudit.lean` | `d6ac2625e0ac0961a3f0d6b40f3a7c65d9571273e1cd103cd981647bfbb9e569` | 13196 | 306 | 0644 |
| `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_memory_guard.sh` | `cc894111363adf16e10a04fe1bc3b7157c831b71a84b64720768259bb85c844a` | 21796 | 497 | 0755 |
| `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_materialize.sh` | `5f4c9b5469cc5312af54e7e1053046b752d16833f33213f94f23d78c1a8f7897` | 6414 | 181 | 0755 |

The executor starts from SHA-256
`6f20261d3c93bff4cc783bcfccfa542643d2da51efcfaeceff5534e1cf8a61c4`,
143474 bytes, 818 lines, mode 0755.  Its successor SHA is deliberately
unknown until the authorized patch is complete.

## Mandatory repair semantics

The successor executor must implement every item in this section.  A
partial implementation is a static-audit STOP.

### 1. Root Lake configuration and override paths

Keep `lake_paths($phase)` restricted to the seven module artifacts per Lean
module.  Define a separate exact configuration surface:

```text
.lake/lakefile.olean          FILE
.lake/lakefile.olean.trace    FILE
.lake/lakefile.olean.lock     ABSENT
.lake/package-overrides.json  ABSENT
```

The first two files are immutable warm configuration inputs for every phase.
The lock and override must remain absent.  They are not `LAKE7` outputs and
must never be accepted as a phase delta.

The executor must census the direct children of `$ROOT/.lake` without
descending from that census.  A PASS state has exactly these four direct
entries:

```text
build                       DIRECTORY
packages                    DIRECTORY
lakefile.olean              FILE
lakefile.olean.trace        FILE
```

Any additional direct child, noncanonical state, changed mode, lock residue,
or override is an environmental INVALID or a pre-attempt STOP, depending on
whether a normal phase has already crossed its attempt boundary.

### 2. Canonical full-tree identities

Upgrade `tree_snapshot` so that regular-file identity includes mode as well
as SHA-256 and byte length.  Directory identity includes mode.  A symlink is
permitted only inside the package/sysroot tree.  `readlink` must succeed; the
raw target must be nonempty, relative, NUL-free, and committed by raw target
bytes, byte length, mode, and SHA-256.  Starting at the symlink's containing
directory, lexical normalization removes `.` components and consumes `..`
components; escape above the tree root is fatal.  The normalized target must
exist inside the same tree, so dangling and externally resolving symlinks are
fatal.  The walker never dereferences the symlink while hashing its own row.
All other filesystem kinds are rejected.

For each tree, the canonical identity is a big-endian length-framed SHA-256
over the root row and all descendant rows in unsigned-byte path order.  Every
row frames, in order:

```text
root-relative path
kind: DIRECTORY | FILE | SYMLINK
mode
byte length or '-'
content SHA-256, symlink-target SHA-256, or '-'
```

The vector begins with a 32-bit big-endian row count.  Every field is
preceded by its 32-bit big-endian byte length.  Duplicate paths, NUL bytes,
path escape, unreadable entries, or a value exceeding the framing range are
fatal.

The root row uses relative path `.`.  `PACKAGE_PRESTATE_COUNT` and
`SYSROOT_PRESTATE_COUNT` include that row and every descendant row.

The same bootstrap identities of these two trees must be revalidated before
and after every normal phase:

```text
$ROOT/.lake/packages
/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean
```

The pre-snapshots computed while validating the frozen run manifest may be
cached and reused as the phase pre-snapshots; the phase must still compute
fresh post-snapshots.  No phase-local `pre == post` comparison may substitute
for equality to the one bootstrap commitment.

The direct top-level Lake vector uses the same five-field row framing, but is
nonrecursive and has exactly five rows in unsigned-byte path order: root `.`,
`build`, `lakefile.olean`, `lakefile.olean.trace`, and `packages`.  Thus
`TOP_LEVEL_LAKE_ENTRY_COUNT=5`; the count includes the root row.  Directories
use `bytes='-'` and `sha='-'`; files use exact mode, byte length, and SHA-256.
Lock and override are absent specs and therefore are not vector rows.  Any
other child prevents a PASS vector and is reported separately as an
unexpected direct entry.

### 3. Static-preexisting object identity

After parsing the command table, collect every unique object whose role is
`STATIC_PREEXISTING`.  Freeze and revalidate an unsigned-byte ordered,
length-framed vector containing:

```text
absolute path | role | mode | byte length | SHA-256
```

The static-object vector uses the same count prefix and five length-framed
fields per row, with literal role `STATIC_PREEXISTING`.  Its count is the
number of unique objects and has no synthetic root row.

This identity must be checked before every normal phase and by C0.  A first
use may not silently bless an object changed between phases.

### 4. Frozen run-input schema

Extend `F3_RUN_INPUT_MANIFEST_V1` with these fixed META fields:

```text
LAKE_CONFIG_PATH_COUNT
TOP_LEVEL_LAKE_ENTRY_COUNT
TOP_LEVEL_LAKE_VECTOR_SHA256
STATIC_PREEXISTING_OBJECT_COUNT
STATIC_PREEXISTING_OBJECT_VECTOR_SHA256
PACKAGE_PRESTATE_COUNT
PACKAGE_PRESTATE_VECTOR_SHA256
SYSROOT_PRESTATE_COUNT
SYSROOT_PRESTATE_VECTOR_SHA256
```

Insert the four ordered configuration/override rows after the current fixed
source/tool/base-environment prefix and before `BUILD_PRESTATE`.  The two
warm configuration files are `FILE`; lock and override are `ABSENT`.
`BUILD_PRESTATE_COUNT` continues to describe only `.lake/build`.
`LAKE_CONFIG_PATH_COUNT` is literally 4 in every producer and validator.

Historical validation must not use the generic historical-ABSENT shortcut
for the lock or override: both must be absent in the live state whenever any
phase is validated.

### 5. Active authority chain

Replace the retracted audit/freeze paths in `authority_paths()`.  The active
successor chain has exactly eleven paths, in this order:

1. `F3_R3_V3_EXACT_SEVEN_INPUT_AUTHORING_ROOT_AUTHORIZATION_v1.md`;
2. `F3_R3_V3_INPUT_REGISTRY_AND_PREEXECUTION_REVIEW_ROOT_AUTHORING_AUTHORIZATION_v1.md`;
3. `F3_R3_V3_INPUT_REGISTRY_AND_PREEXECUTION_REVIEW_v1.md`;
4. `F3_R3_V3_EXACT_SEVEN_EXECUTION_FREEZE_P1_RETRACTION_AND_SUCCESSOR_REPAIR_GATE_v1.md`;
5. `F3_R3_V3_LAKE_TOP_LEVEL_AND_FROZEN_ENVIRONMENT_REPAIR_ROOT_AUTHORIZATION_v1.md`;
6. `F3_R3_V3_EXACT_SEVEN_INPUT_INDEPENDENT_STATIC_AUDIT_1_PASS_v2.md`;
7. `F3_R3_V3_EXACT_SEVEN_INPUT_INDEPENDENT_STATIC_AUDIT_2_PASS_v2.md`;
8. `F3_R3_V3_EXACT_SEVEN_INPUT_ROOT_FREEZE_DECISION_v2.md`;
9. `F3_R3_V3_EXACT_SEVEN_INPUT_PUBLIC_CUSTODY_RECEIPT_v2.md`;
10. `F3_R3_V3_DEPENDENCY_OBSERVATION_AND_ENVIRONMENT_PREPARATION_ROOT_AUTHORIZATION_v1.md`;
11. `F3_R3_V3_B0_EXECUTION_ROOT_AUTHORIZATION_AND_RUNBOOK_v2.md`.

Every generated and validated `AUTHORITY_COUNT` literal becomes 11.
`SEVEN_INPUT_COUNT` remains 7.

### 6. Phase deltas and INVALID semantics

The Lake delta and output schemas must record these fields in the following
relative order after their existing phase/result fields and before their
existing dependency/control fields:

```text
LAKE_CONFIG_PATH_COUNT
TOP_LEVEL_EXPECTED_COUNT
TOP_LEVEL_EXPECTED_SHA256
TOP_LEVEL_PRE_COUNT
TOP_LEVEL_PRE_SHA256
TOP_LEVEL_POST_COUNT
TOP_LEVEL_POST_SHA256
PROJECT_DELTA_COUNT
PROJECT_DELTA_VECTOR_SHA256
PACKAGE_EXPECTED_COUNT
PACKAGE_EXPECTED_SHA256
PACKAGE_PRE_COUNT
PACKAGE_PRE_SHA256
PACKAGE_POST_COUNT
PACKAGE_POST_SHA256
SYSROOT_EXPECTED_COUNT
SYSROOT_EXPECTED_SHA256
SYSROOT_PRE_COUNT
SYSROOT_PRE_SHA256
SYSROOT_POST_COUNT
SYSROOT_POST_SHA256
STATIC_EXPECTED_COUNT
STATIC_EXPECTED_SHA256
STATIC_PRE_COUNT
STATIC_PRE_SHA256
STATIC_POST_COUNT
STATIC_POST_SHA256
INVALID_PREDICATE
INVALID_PREDICATE_COUNT
INVALID_PREDICATES
INVALID_PREDICATE_VECTOR_SHA256
CHILD_EXECUTED
```

`DELTA` rows remain exactly the phase's `LAKE7` paths and retain the cold
`ABSENT -> FILE` rule.  `PROJECT_DELTA_VECTOR_SHA256` is a count-prefixed,
length-framed vector of changed paths with canonical pre-state and post-state
fields; only the phase's exact `LAKE7` changes are legal on PASS.  The four
config/override rows are also emitted after the phase result rows: exact
`FILE,FILE,ABSENT,ABSENT` on PASS and `CENSUS` on INVALID.

A PASS requires equality of expected, pre, and post count/hash for top-level,
packages, sysroot, and static objects; an exact LAKE7-only project vector;
`INVALID_PREDICATE=NONE`; `INVALID_PREDICATE_COUNT=0`;
`INVALID_PREDICATES=NONE`; and the canonical SHA-256 of the empty predicate
vector.  `CHILD_EXECUTED` is exactly:

```text
YES                              B0,R0,G01-G06,S0,V0,A0 after exec/system
NOT_APPLICABLE_INTERNAL          P0,P1,F0 normal internal writer
NO_PRECHILD_ENVIRONMENT_INVALID  any phase stopped after lease/input publication but before child/internal work
```

Environmental drift must seal `RESULT=INVALID` even when the child exits 0.
The terminal receipt preserves the real child exit; the outer executor may
exit 125 after sealing.  Distinct fail-closed predicates must distinguish at
least the following.  If more than one condition is present, every token is
recorded in `INVALID_PREDICATES` in this exact priority order; the first token
is the singular `INVALID_PREDICATE`.  The predicate vector uses the same
count prefix and one length-framed token field per row:

```text
ROOT_CONFIG_LOCK_RESIDUE
PACKAGE_OVERRIDE_DRIFT
UNEXPECTED_DIRECT_LAKE_ENTRY
ROOT_CONFIG_PRESTATE_DRIFT
PACKAGE_PRESTATE_DRIFT
SYSROOT_PRESTATE_DRIFT
STATIC_PREEXISTING_OBJECT_DRIFT
PROJECT_UNEXPECTED_DELTA
ROOT_CONFIG_POSTSTATE_DRIFT
PACKAGE_POSTSTATE_DRIFT
SYSROOT_POSTSTATE_DRIFT
PAYLOAD_NONZERO
```

The textual `INVALID_PREDICATES` META value is `NONE` for the empty vector;
otherwise it is the ordered tokens joined by a single comma byte with no
spaces.  No token contains a comma.

The exact phase-bundle validator and failure sealer must accept exit 0 only
for an environmental INVALID whose complete pre/post identities, counters,
predicate vector, and primary predicate reconstruct exactly; it must never
reinterpret that state as PASS.

### 7. C0 and frontier attribution

C0 must parse the expected frozen environment commitments before comparing
them to live state.  Its custody manifest records expected and observed
count/hash values for top-level Lake, packages, sysroot, and static objects,
plus the four fixed config/override rows and direct `.lake` census.

After its existing custody metadata and before its evidence rows, the C0
schema records these META fields in this exact order:

```text
TOP_LEVEL_EXPECTED_COUNT
TOP_LEVEL_EXPECTED_SHA256
TOP_LEVEL_OBSERVED_COUNT
TOP_LEVEL_OBSERVED_SHA256
PACKAGE_EXPECTED_COUNT
PACKAGE_EXPECTED_SHA256
PACKAGE_OBSERVED_COUNT
PACKAGE_OBSERVED_SHA256
SYSROOT_EXPECTED_COUNT
SYSROOT_EXPECTED_SHA256
SYSROOT_OBSERVED_COUNT
SYSROOT_OBSERVED_SHA256
STATIC_EXPECTED_COUNT
STATIC_EXPECTED_SHA256
STATIC_OBSERVED_COUNT
STATIC_OBSERVED_SHA256
INVALID_PREDICATE_COUNT
INVALID_PREDICATES
INVALID_PREDICATE_VECTOR_SHA256
CHILD_EXECUTED
```

An unconstructible observed tree uses count `0`, SHA token
`UNAVAILABLE_NONCANONICAL`, and a specific primary predicate; it may not copy
the expected value.  If a phase already sealed an INVALID output, C0 must
preserve that output's complete predicate vector and child token.  If drift
is first observed between phases, C0 constructs the vector from the current
frontier comparison and uses `CHILD_EXECUTED=NO_PRECHILD_ENVIRONMENT_INVALID`.

If an active normal lease exists, drift belongs to that phase.  Otherwise,
after a nonempty prefix of completed phases, drift belongs to the first
`CLEAN_NEVER` frontier.  It must not be retroactively assigned to an earlier
completed phase.  Before any B0 marker or completed phase exists, frozen-input
drift is `STOP_PREATTEMPT` and does not create a false C0 attempt.

### 8. Known universe

The four config/override paths and direct `.lake` census must participate in
normal output validation, C0 custody, and unexpected-path discovery.  The
full package/sysroot rows need not be emitted into every evidence file; their
canonical counts and vector hashes are mandatory META evidence.

## Static acceptance suite

Both independent audits must, without invoking the executor or any build,
verify at least:

1. exact mode/hash/bytes/lines of all seven final inputs;
2. unchanged identity of the six immutable inputs;
3. the one-path executable diff and `git diff --check`;
4. shell parse-only success for executor, guard, and materializer;
5. independent extraction and syntax validation of the embedded controller;
6. exact eleven-path authority order and every `AUTHORITY_COUNT=11` consumer;
7. exact four-path config surface and direct `.lake` census;
8. mode-aware, framed package/sysroot and static-object commitments;
9. pre/post equality to the bootstrap identities for every phase;
10. exit-zero environmental INVALID sealing and exact reconstruction;
11. frontier-aware C0 attribution and `STOP_PREATTEMPT` before B0;
12. absence of any new invocation of Lean, Lake, BFS, generator, network,
    `native_decide`, `ofReduceBool`, `find?`, `sorry`, `admit`, or an axiom;
13. no change to mathematical statements, row data, contracts, registry,
    templates, guard, or materializer.

Parse-only checks do not authorize execution of a script body.  No audit may
create a typed run input or populate a result directory.

## Successor freeze and remaining gate

The v2 root freeze must bind the final seven tuple, the two v2 audits, this
authorization, the retraction, the exact candidate parent commit, and the
exact hashes/modes of the other three candidate-transaction paths: executor
and two audits.  It must not claim its own hash or the candidate commit hash.
The separate public-custody receipt then binds all four paths, including the
freeze, plus the candidate commit and verified remote ref without changing
any candidate byte.  The freeze must state:

```text
P1_RESIDUAL_IN_LAKE_ENVIRONMENT_REPAIR_SCOPE = 0
P2_RESIDUAL_IN_LAKE_ENVIRONMENT_REPAIR_SCOPE = 0
GLOBAL_PRE_B0_P1_RESIDUAL = NONZERO_DEPENDENCY_OBSERVATION_AND_WORKTREE_PREPARATION
EXECUTION_AUTHORITY = NONE
DEPENDENCY_OBSERVATION_AUTHORITY = NONE
B0_AUTHORITY = NONE
```

Even a successful repair does not solve the command-table dependency-ledger
circularity and does not prepare the dedicated worktree.  The next permitted
gate after public v2 freeze is a separate, narrowly authorized
`F3_R3_V3_DEPENDENCY_OBSERVATION_AND_ENVIRONMENT_PREPARATION` act.  It must
freeze its own worktree, package/config bootstrap, commands, outputs, and
single-attempt policy before any Lean or Lake process is started.

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
