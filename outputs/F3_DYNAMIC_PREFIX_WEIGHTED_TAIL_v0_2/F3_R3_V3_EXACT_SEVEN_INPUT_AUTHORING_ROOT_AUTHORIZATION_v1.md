# F3 R3 v3 exact-seven input authoring root authorization v1

Date: 2026-07-26.

## 1. Authority and verdict

```text
AUTHORIZATION_VERDICT = AUTHOR_EXACTLY_SEVEN_INPUTS
AUTHORIZED_CONTENT_PATHS = 7/7
AUTHORIZED_MODE_CHANGES = THREE_SCRIPTS_TO_100755_ONLY
STATIC_PARSE_AND_SOURCE_AUDIT_AUTHORITY = YES
LEAN_AUTHORITY = NONE
LAKE_AUTHORITY = NONE
REVERSE_BFS_AUTHORITY = NONE
GENERATOR_AUTHORITY = NONE
B0_AUTHORITY = NONE
R0_AUTHORITY = NONE
P0_AUTHORITY = NONE
PILOT_EXECUTION_OPENED = NO
```

This act authorizes one initial authoring tuple at exactly the seven paths in
Section 4, followed only by static inspection, two independent audits of the
same byte tuple, and a separate root freeze decision.  It does not authorize
Lean, Lake, a generator, reverse BFS, any normal pilot phase, or custody phase
`C0`.

## 2. Public base and controlling review

| Item | Identity |
|---|---|
| branch | `codex/hilo2-f3-r3-reverse-first-hit-v1` |
| public/local HEAD | `d4b5867513c3d8de7541c24aceaaada752214dd3` |
| controlling review | `F3_R3_V3_INPUT_REGISTRY_AND_PREEXECUTION_REVIEW_v1.md` |
| controlling review SHA-256 | `ed5244016f11456a6d432c6183e8344b16cceba2259d0842559860bd49dd9982` |
| controlling review lines | `268` |
| review authorization | `F3_R3_V3_INPUT_REGISTRY_AND_PREEXECUTION_REVIEW_ROOT_AUTHORING_AUTHORIZATION_v1.md` |
| review authorization SHA-256 | `0a71770dba428a023beeb83f5d31121f0629fd3605e614927372ef613b3bc6e5` |
| public prerequisite closure | `57/57` sources at `3e3245373d51171603ab9849626d79f662e4f0cc` |

At authorization time all seven targets are absent, the eight expected
prerequisite `.olean` objects are absent, and local and public branch heads
are equal.  The worktree contains unrelated untracked material; it is not an
authorized edit surface and must be preserved.

## 3. Normative precedence

The following resolution is binding for this authoring tuple:

1. contract v2 supplies checker, resource and tool baselines;
2. contract v3 supplies the corrected
   `B0 -> R0 -> P0 -> G01..G06 -> S0 -> P1 -> V0 -> A0 -> F0` sequence;
3. contract v4 supplies immutable receipt chaining, memory outputs and
   custody-only `C0`;
4. contracts v5 and v6 supply the branch-complete outcome and the scoped
   meaning of a deficient row;
5. registry v10 supplies the six current fixed rows and paths; and
6. the controlling review supplies the author/audit/freeze-before-B0 order,
   the corrected audit counts, and the timing of the payload-dependent
   acceptance source.

Sections 8 and 9 below narrowly reconcile two remaining operational
cycles.  No mathematical statement, row, resource ceiling, attempt count,
verdict precedence or no-claim boundary is weakened.

## 4. Exact authorized write set

Only these paths may be created or modified under this act:

1. `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotRowsV3.lean`
2. `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotGenerateV3.lean`
3. `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotV3.lean`
4. `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotV3AxiomAudit.lean`
5. `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_executor.sh`
6. `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_memory_guard.sh`
7. `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_materialize.sh`

The four Lean files must be regular, non-symlink mode `100644`.  The three
scripts must be regular, non-symlink mode `100755`.  Parent directories must
be regular directory ancestry with no symlink component.  The generated
`F3ReturnExcursionBlock0ReverseBFSPilotPayloadsV3.lean` remains absent: it is
an `S0` output, not an eighth input.

## 5. Lean source architecture

### 5.1 Rows

`PilotRowsV3` imports the sharded demand profile and ordered-first-hit layer.
It must not import the verifier, mass-integration checker, completeness,
payload, pilot or audit modules.

It defines one typed `FixedPilotRowV3` structure and exactly six public fixed
rows in registry-v10 order.  The rows reconstruct their occurrences from the
root indices and constructor APIs inside Lean; metadata is not accepted as a
substitute for a typed occurrence.

| # | canonical ID | root index/value | constructor | demand | raw qHi API pair | reduced contract pair | child | window |
|---:|---|---:|---|---:|---:|---:|---:|---:|
| 1 | `FIXED_ROW_01_RET_D2` | `24/77` | retarded | 2 | `2625/2511` | `875/837` | 308 | 19712 |
| 2 | `FIXED_ROW_02_RET_D1` | `11/38` | retarded | 1 | `10300/11907` | `10300/11907` | 152 | 9728 |
| 3 | `FIXED_ROW_03_DIRECT_D2` | `52/161` | direct | 2 | `580743/404000` | `580743/404000` | 107 | 41088 |
| 4 | `FIXED_ROW_04_DIRECT_D1` | `76/233` | direct | 1 | `268470/270000` | `2983/3000` | 155 | 59520 |
| 5 | `FIXED_ROW_05_LIFT_D2` | `44/137` | parity lift | 2 | `64056/48800` | `8007/6100` | 182 | 34944 |
| 6 | `FIXED_ROW_06_LIFT_D1` | `224/677` | parity lift | 1 | `15700/16200` | `157/162` | 902 | 173184 |

Six public coordinate theorems must certify order, both IDs, root,
constructor, source/fine-lift tag, target, the raw values returned by
`qHiNumerator` and `qHiDenominator`, mass demand, semantic child and child
window.  Each theorem also proves by cross multiplication that the raw pair
equals the reduced contractual pair in the table.  A reduced paper fraction
must never be asserted as the literal result of a raw API when the pairs
differ.  Ordinary `decide`, `simp` and `omega` are legal; native or
compiler-trusting evaluation is not.

The source contains literally:

```text
ROW_SELECTION_CLASSIFICATION = SIX_FIXED_PREDECLARED_ROWS
FINITE_MAXIMUM_SELECTION_CERTIFIED = NO
NO_EXTREMALITY_INFERENCE_FROM_LEGACY_ROW_ID
```

### 5.2 Untrusted generator

`PilotGenerateV3` imports only `PilotRowsV3` and `ReverseBFSData`.  Its full
transitive import cone must exclude the verifier, mass-integration checker,
completeness, payload, pilot and axiom-audit modules.

Its CLI accepts exactly one of these six complete canonical IDs:

```text
FIXED_ROW_01_RET_D2
FIXED_ROW_02_RET_D1
FIXED_ROW_03_DIRECT_D2
FIXED_ROW_04_DIRECT_D1
FIXED_ROW_05_LIFT_D2
FIXED_ROW_06_LIFT_D1
```

It generates exactly one certificate from the typed row through
`generateReverseBFSCertificate` and `configOfOccurrence`, using the sharded
`massDemandShadow`.  It must not call `generateTypedReverseBFSCertificate`,
because that import surface contains the checker.

The serializer is explicit and deterministic for every natural, list, node,
closure row, kind and certificate field.  It must not use `repr` as Lean
syntax, contain expected nodes or kinds, look up hidden outcomes, or
normalize output after generation.  Successful stdout is only one canonical
Lean fragment defining the row's `fixedRow0iCertificate`; diagnostics go only
to stderr.  A bad argument count or token exits nonzero.

### 5.3 Payload-dependent acceptance

`PilotV3` imports Rows, the future Payloads module, MassIntegration and
Completeness.  It defines the exact branch-complete
`VerifiedTypedReverseBFSOutcome` interface of contract v6 and derives it from
`verifyTypedReverseBFSCertificate = true`.

The saturated branch consumes `verified_typed_saturated_capacity`.  The
deficient branch explicitly transports the typed check to
`verifyReverseBFSCertificate p (massDemand p) cert = true` and consumes the
exact fibre equality, cardinal/length equality and strict shortfall theorems
from Completeness.

It exposes exactly the twelve required row declarations:

```text
fixedRow01_check ... fixedRow06_check
fixedRow01_outcome ... fixedRow06_outcome
```

The checks use ordinary kernel reduction.  No source statement may presume
which generated rows are saturated or deficient.

### 5.4 Exhaustive axiom audit

The only project import of `PilotV3AxiomAudit` is `PilotV3`; exactly the two
infrastructure imports `Lean.Meta.Basic` and `Lean.Util.CollectAxioms` are
also required.  No other project or Lean infrastructure import is permitted.
It explicitly inventories all public source declarations in Rows, Payloads
and Pilot, including all twelve checks/outcomes.

The audit separates stable declarations from compiler-generated internal
details.  Its stable allowlist contains the source declarations plus exactly
these generated names under the frozen Lean toolchain:

```text
FixedPilotRowV3.mk
FixedPilotRowV3.order
FixedPilotRowV3.canonicalId
FixedPilotRowV3.legacyRowId
FixedPilotRowV3.occurrence
FixedPilotRowV3.rec
FixedPilotRowV3.recOn
FixedPilotRowV3.casesOn
FixedPilotRowV3.noConfusionType.withCtorType
FixedPilotRowV3.noConfusionType.withCtor
FixedPilotRowV3.noConfusionType
FixedPilotRowV3.noConfusion
FixedPilotRowV3.mk.inj
FixedPilotRowV3.mk.injEq
FixedPilotRowV3.mk.sizeOf_spec
VerifiedTypedReverseBFSOutcome.saturated
VerifiedTypedReverseBFSOutcome.deficient
VerifiedTypedReverseBFSOutcome.rec
VerifiedTypedReverseBFSOutcome.recOn
VerifiedTypedReverseBFSOutcome.casesOn
```

It rejects duplicate entries in every explicit or stable-generated inventory
and compares `actualStable := actual.filter (! ·.isInternalDetail)` with the
expected stable set in both directions.  Every internal-detail declaration in
`actual` must descend from an expected stable declaration.  It then calls
`collectAxioms` over the complete `actual` set, including every internal
detail.  Empty, missing, duplicate, orphaned-internal or unexpected namespace
state fails even when an unexpected declaration happens to have an allowed
axiom profile.  Exact equality against unstable `_proof_*`, `_cstage*`,
`eq_*` or `match_*` names is deliberately not claimed before elaboration.

Every actual declaration is passed to `Lean.collectAxioms`.  Each expected
stable/public declaration must have axioms contained in exactly the public
allowlist `propext`, `Classical.choice`, `Quot.sound`.  An internal-detail
realization may additionally report the frozen compiler implementation axiom
`lcProof`; it remains tied to an expected stable ancestor and is never counted
as a public theorem.  Every profile, stable or internal, absolutely forbids
`native_decide`, `Lean.ofReduceBool`, `Lean.trustCompiler`, `sorryAx`, any
user-declared axiom, `admit` and `sorry`.  This two-profile rule prevents
compiler `_cstage*` details from making exhaustive A0 impossible while keeping
the complete public cone kernel-clean.

## 6. Script architecture and exact phase commands

The executor accepts exactly one token from the fourteen normal phases or
custody-only `C0`.  There is no generic command argument, `eval`, `source`,
debug subcommand, reset, resume, cleanup, prefix match or environment-chosen
command.

The normal phase list is exactly:

```text
B0 R0 P0 G01 G02 G03 G04 G05 G06 S0 P1 V0 A0 F0
```

`C0` is the only successor after the first terminal INVALID and is never a
normal fifteenth phase.

Every normal phase and C0 has exactly one attempt.  The six G ceilings remain
`300` seconds each and `1800` seconds aggregate.  No retry, phase repetition,
resource increase or alternate row is available under these bytes.

Every invocation has cwd exactly
`/Users/MoiTam/Documents/New project/coordinated/hilo2-f3-r3-pilot-v3-run`.
This is a separately created clean execution worktree at the frozen public
commit, not the dirty authoring worktree.  Its inherited
environment is discarded.  The explicit base environment is exactly:

```text
HOME=/Users/MoiTam
ELAN_HOME=/Users/MoiTam/.elan
PATH=/Users/MoiTam/.elan/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
LC_ALL=C
LANG=C
TMPDIR=/Users/MoiTam/Documents/New project/coordinated/hilo2-f3-r3-pilot-v3-run/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_R3_REVERSE_BFS_PILOT_v3/tmp
```

The public executor's first line is an audited `/usr/bin/env -S -i` shebang
that fixes `HOME`, `ELAN_HOME`, `PATH`, `LC_ALL` and `LANG` before
`/bin/bash --noprofile --norc` starts; only after that sanitized Bash begins
does it assign the fixed TMPDIR above.  Thus inherited `BASH_ENV`, shell
functions and startup variables cannot execute before `env -i`.  Invoking the
public executor through an inherited Bash or any alternate interpreter is
INVALID.  The runbook pins `/usr/bin/env` and statically verifies `-S` support
before granting B0.

No caller-provided variable changes a path, command, limit, row, output or
phase.  Variables introduced by the literal `lake env` child are recorded
verbatim and sealed; an unrecorded variable or different value is INVALID.

After validating the sole public phase token, the executor maps it to one
literal numeric ceiling and list-execs the pinned `env -i` base above followed
by the pinned `gtimeout --foreground --signal=TERM --kill-after=5`, that
ceiling, `/usr/bin/perl`, `-e`, the embedded `CONTROLLER_PROGRAM_V1` and the
literal token.  This one outer watchdog encloses admission, lease publication,
payload, dependency traces, hashing, receipts, F0 exterior custody and lock
release.  The controller records a monotonic deadline at entry.  Every helper
it launches, including the memory guard, is nested under pinned `gtimeout`
with the conservative positive integral seconds remaining; zero remaining is
INVALID.  Thus a helper cannot restart the phase wall clock.  Timeout of the
outer controller closes only the controller's writer descriptor and
deliberately leaves the active lease for C0; the kernel writer lock remains
held by every surviving supervisor/descendant until that entire subtree is
killed and reaped.

For a memory-controlled phase `X`, the executor's only child-command entry is
the literal invocation

```text
/bin/bash /Users/MoiTam/Documents/New project/coordinated/hilo2-f3-r3-pilot-v3-run/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_memory_guard.sh X
```

The guard accepts only the ten tokens `B0`, `R0`, `G01`--`G06`, `V0`, `A0`
and maps each token to one literal sequence table.  After the fresh-session
handshake it constructs one argv array whose first six elements are exactly
`/opt/homebrew/Cellar/coreutils/9.7/bin/gtimeout`, `--foreground`,
`--signal=TERM`, `--kill-after=5`, the controller-supplied conservative
decimal seconds remaining, and `/usr/bin/time`; the remaining elements are exactly `-p`,
`/usr/bin/perl`, `-e`, the embedded `SEQUENCE_PROGRAM_V1` byte string and the
literal phase token.  `SEQUENCE_PROGRAM_V1` is a closed token switch containing
the complete argv arrays specified below.  It uses list-form `exec`, never a
shell string.  The source-audit receipts must report the SHA-256 and byte count
of that embedded string.  Neither authored script may contain angle-bracket
metavariables, `PENDING`, a caller-supplied command, or an environment-selected
program.

At this pre-authoring stage the three embedded byte strings
`CONTROLLER_PROGRAM_V1`, `SEQUENCE_PROGRAM_V1` and
`ENV_CAPTURE_AND_EXEC_V1` have
`HASH_STATE=NOT_YET_OBSERVED_AUTHORING_STAGE`.  This is not a SHA field.  After
authoring, each independent static audit computes their actual SHA-256, byte
count and the canonical argc/length/byte framing of every constructed argv;
the later root freeze pins the observed values.  No value is predicted here.

For B0, R0, V0 and A0 the sequence is the listed `lake build` argv followed,
only after status zero, by the exact `lean --deps` argv for each phase root in
listed order.  For G0i the sequence has only its listed generator argv.  The
same session leader, PGID, aggregate gtimeout ceiling and memory samples cover
the complete sequence; no trace command runs outside the guard.

Every `lake env ... lean` step uses the same embedded
`ENV_CAPTURE_AND_EXEC_V1` Perl byte string as its `-e` argument.  That program
takes exactly a literal phase, an absolute environment-output path and a
nonempty argv, serializes every current environment key/value in bytewise key
order into the typed hex encoding of Section 7 (rejecting NUL), atomically publishes
the first copy and requires every later copy for the same phase to be
byte-identical, then list-form `exec`s the remaining argv.  It writes nothing
to stdout or stderr on success.  The source-audit receipts report its SHA-256
and byte count.  Thus G stdout remains only the canonical fragment and no
variable introduced by `lake env` remains uncaptured.

The notation `ENV_CAPTURE_AND_EXEC_V1` below denotes that one exact embedded
argv element; it is a defined program identifier, not text present in the
authored scripts.  `PHASE_X` denotes the literal phase token and `ENV_X` the
fixed absolute path
`.../results/F3_R3_REVERSE_BFS_PILOT_v3/X.lake_environment.tsv`, with the
literal phase substituted at authoring time.  Static audit rejects those
documentary identifier strings if they appear in executable argv arrays.

```text
B0 PAYLOAD ARGV:
/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lake build
CollatzClassical.KL2003.F3ReturnExcursionBlock0MassDemandProfileSharded
CollatzClassical.KL2003.F3ReturnExcursionBlock0MassDemandProfileShardedAxiomAudit
CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSMassIntegration
CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSAxiomAudit
CollatzClassical.KL2003.F3ReturnExcursionBlock0SemanticChildBaseHit
CollatzClassical.KL2003.F3ReturnExcursionBlock0SemanticChildBaseHitAxiomAudit
CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSCompleteness
CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSCompletenessAxiomAudit

R0 PAYLOAD ARGV:
/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lake build
CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSPilotRowsV3
CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSPilotGenerateV3

G PAYLOAD ARGV CONSTRUCTION (one row per phase):
prefix = /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lake env /usr/bin/perl -e ENV_CAPTURE_AND_EXEC_V1 PHASE_X ENV_X /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean --run /Users/MoiTam/Documents/New project/coordinated/hilo2-f3-r3-pilot-v3-run/CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotGenerateV3.lean
G01 suffix = FIXED_ROW_01_RET_D2
G02 suffix = FIXED_ROW_02_RET_D1
G03 suffix = FIXED_ROW_03_DIRECT_D2
G04 suffix = FIXED_ROW_04_DIRECT_D1
G05 suffix = FIXED_ROW_05_LIFT_D2
G06 suffix = FIXED_ROW_06_LIFT_D1

V0 PAYLOAD ARGV:
/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lake build
CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSPilotV3

A0 PAYLOAD ARGV:
/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lake build
CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSPilotV3AxiomAudit
```

The wall ceilings are `3600` for B0/V0/A0, `600` for R0/P0/S0/P1/F0/C0 and
`300` for each G phase.  The declared `1800`-second G aggregate is the exact
sum of the six disjoint one-attempt ceilings; no gap between invocations is
charged as execution time and no row can borrow unused time from another.
Heartbeats `20000000` and recursion depth `100000`
are frozen in the authored R0/V0/A0 sources; no command-line override exists.

The non-memory phase command surface is also closed.  It contains no unbounded
read loop or wait, and bounded controller operations occur only beneath the
outer watchdog.  In particular:

- `P0`, `P1` and `F0` execute only fixed receipt-writer/validator subprograms
  embedded in the executor;
- `S0` invokes the pinned nested `gtimeout` with the seconds remaining, then
  exactly `/bin/bash` followed by the absolute materializer path and no
  arguments;
- `C0` executes only the fixed invalid-custody subprogram under the same
  aggregate `600`-second rule.

### 6.1 Exact result-path allowlists

The fixed result root is
`outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_R3_REVERSE_BFS_PILOT_v3`.
The only pre-existing regular run inputs there are
`F3_R3_V3_FROZEN_RUN_INPUT_MANIFEST.sha256`,
`F3_R3_V3_BASE_ENVIRONMENT.tsv` and `F3_R3_V3_COMMAND_TABLE.tsv`, created and
frozen by the later B0 runbook before any attempt.
Besides the phase-specific paths below, only the fixed directories `memory`,
`fragments`, `tmp`, `control` and `leases` are legal.  The later runbook
precreates regular non-symlink `control/admission.guard` and
`control/writer.guard` on the same local filesystem.  The only other control
files are `control/active_normal_lease.tsv`,
`control/active_c0_lease.tsv`, `control/first_contention.tsv` and one archived
`leases/X.lease.tsv` for a consumed phase token.  Candidate paths are fixed,
not PID-derived: `control/normal-lease.candidate`,
`control/c0-lease.candidate`, `control/contention.candidate`, and exactly one
`tmp/X.ROLE.candidate` for each canonical phase publication role embedded in
the script.  They are regular mode `100600` and included explicitly in every
failure/C0 census.  Control
paths are never mathematical success evidence; every one is included in the
fixed terminal/custody census.

| Phase | Success-path allowlist, in receipt order |
|---|---|
| B0 | `B0.inputs.sha256`, `B0.raw.stdout`, `B0.raw.stderr`, `B0.exit_status`, `B0.resource_receipt.tsv`, `B0.lake_environment.tsv`, `B0.dependencies.raw`, `B0.loaded_objects.tsv`, `B0.lake_delta.tsv`, `memory/B0.vm_stat_pre.txt`, `memory/B0.rss_members.tsv`, `memory/B0.rss_summary.tsv`, `memory/B0.guard_receipt.sha256`, `B0.outputs.sha256`, `B0_terminal_receipt.sha256` |
| R0 | `R0.inputs.sha256`, `R0.raw.stdout`, `R0.raw.stderr`, `R0.exit_status`, `R0.resource_receipt.tsv`, `R0.lake_environment.tsv`, `R0.dependencies.raw`, `R0.loaded_objects.tsv`, `R0.lake_delta.tsv`, `memory/R0.vm_stat_pre.txt`, `memory/R0.rss_members.tsv`, `memory/R0.rss_summary.tsv`, `memory/R0.guard_receipt.sha256`, `R0.outputs.sha256`, `R0_terminal_receipt.sha256` |
| P0 | `P0.inputs.sha256`, `P0.raw.stdout`, `P0.raw.stderr`, `P0.exit_status`, `pre_generation_manifest.sha256`, `pre_generation_environment.txt`, `pre_generation_commands.txt`, `pre_generation_loaded_objects.txt`, `pre_generation_status.txt`, `P0.outputs.sha256`, `P0_terminal_receipt.sha256` |
| G0i | `G0i.inputs.sha256`, `row_0i.raw.stdout`, `row_0i.raw.stderr`, `row_0i.exit_status`, `row_0i.resource_receipt`, `G0i.lake_environment.tsv`, `fragments/row_0i.canonical_fragment.lean`, `memory/G0i.vm_stat_pre.txt`, `memory/G0i.rss_members.tsv`, `memory/G0i.rss_summary.tsv`, `memory/G0i.guard_receipt.sha256`, `G0i.outputs.sha256`, `G0i_terminal_receipt.sha256` |
| S0 | `S0.inputs.sha256`, `S0.raw.stdout`, `S0.raw.stderr`, `S0.exit_status`, `S0.outputs.sha256`, `S0_terminal_receipt.sha256`, plus the payload source at its fixed project path |
| P1 | `P1.inputs.sha256`, `P1.raw.stdout`, `P1.raw.stderr`, `P1.exit_status`, `post_generation_manifest.sha256`, `P1.outputs.sha256`, `P1_terminal_receipt.sha256` |
| V0 | `V0.inputs.sha256`, `V0.raw.stdout`, `V0.raw.stderr`, `V0.exit_status`, `V0.resource_receipt.tsv`, `V0.lake_environment.tsv`, `V0.dependencies.raw`, `V0.loaded_objects.tsv`, `V0.lake_delta.tsv`, `V0.checker_coverage.tsv`, `memory/V0.vm_stat_pre.txt`, `memory/V0.rss_members.tsv`, `memory/V0.rss_summary.tsv`, `memory/V0.guard_receipt.sha256`, `V0.outputs.sha256`, `V0_verification_receipt.sha256` |
| A0 | `A0.inputs.sha256`, `A0.raw.stdout`, `A0.raw.stderr`, `A0.exit_status`, `A0.resource_receipt.tsv`, `A0.lake_environment.tsv`, `A0.dependencies.raw`, `A0.loaded_objects.tsv`, `A0.lake_delta.tsv`, `A0.public_declarations.tsv`, `A0.axiom_profiles.tsv`, `memory/A0.vm_stat_pre.txt`, `memory/A0.rss_members.tsv`, `memory/A0.rss_summary.tsv`, `memory/A0.guard_receipt.sha256`, `A0.outputs.sha256`, `A0_audit_receipt.sha256` |
| F0 | `F0.inputs.sha256`, `F0.raw.stdout`, `F0.raw.stderr`, `F0.exit_status`, `final_artifacts.sha256`, `F0.outputs.sha256`, `F0_terminal_receipt.sha256`, `F3_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.md`, `F0_report_custody_receipt.sha256` |
| C0 | `invalid_custody_manifest.sha256`, `INVALID_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.md` |

For a local module `M`, `LAKE7(M)` means exactly these seven regular,
non-symlink build paths and no others:

```text
.lake/build/lib/lean/M.olean
.lake/build/lib/lean/M.ilean
.lake/build/lib/lean/M.trace
.lake/build/lib/lean/M.olean.hash
.lake/build/lib/lean/M.ilean.hash
.lake/build/ir/M.c
.lake/build/ir/M.c.hash
```

Slashes replace dots in `M` after the `CollatzClassical` prefix.  B0 embeds
the statically reproduced exact 57-module local import closure at public commit
`3e3245373d51171603ab9849626d79f662e4f0cc` and authorizes only
`LAKE7(M)` for those modules.  R0 authorizes `LAKE7` for RowsV3 and GenerateV3;
V0 authorizes it for PayloadsV3 and PilotV3; A0 authorizes it for
PilotV3AxiomAudit.  Every phase records the complete before/after census and
the exact changed subset in `X.lake_delta.tsv`; all mandatory root artifacts
must exist after success.  A delta under `.lake/packages`, the Lean sysroot,
an unrelated project module, or any eighth artifact kind is INVALID.  Every
other new result file, project source, object or directory is INVALID.

Absolute executable paths are required.  The final seven-file freeze must
record and hash every helper actually used, including Bash, Lake, Lean,
`env`, `gtimeout`, `time`, Perl, `vm_stat`, `ps`, `kill`, `sleep`, `find`,
`ln`, `rm`, `mkdir`, `shasum`, `stat`, `date`, `git`, `awk` and any additional
helper introduced by the authored bytes.  Locale is exactly `LC_ALL=C` and
`LANG=C`.

## 7. Typed canonical evidence, attempts and materialization

Every canonical manifest, environment capture, loaded-object trace or receipt
is ASCII/LF tagged TSV.  Its first line is exactly
`F3_EVIDENCE_V2<TAB>TYPE`, where `TYPE` is one entry from the schema registry
below.  Raw stdout/stderr,
resource samples, generated fragments and predecessor-schema auxiliary tables
are hashed payloads and need not themselves be ASCII.
After the header, indices are globally consecutive from `0001`.  The only
generic row encodings are:

```text
META<TAB>index<TAB>KEY<TAB>VALUE
ENV<TAB>index<TAB>lowercase-hex-key-bytes<TAB>lowercase-hex-value-bytes
FILE<TAB>index<TAB>lowercase-64-hex-sha256<TAB>base10-bytes<TAB>fixed-path
ABSENT<TAB>index<TAB>fixed-path
NONCANONICAL<TAB>index<TAB>type-token<TAB>mode-octal-or-dash<TAB>detail-sha256<TAB>fixed-path
DELTA<TAB>index<TAB>pre-state<TAB>pre-sha-or-dash<TAB>pre-bytes-or-dash<TAB>post-state<TAB>post-sha-or-dash<TAB>post-bytes-or-dash<TAB>fixed-path
UNEXPECTED_FILE<TAB>index<TAB>lowercase-64-hex-sha256<TAB>base10-bytes<TAB>lowercase-hex-path-bytes
UNEXPECTED_NONCANONICAL<TAB>index<TAB>type-token<TAB>mode-octal-or-dash<TAB>detail-sha256<TAB>lowercase-hex-path-bytes
```

Every META key is the literal uppercase token in its registry row; its VALUE
is nonempty printable ASCII without TAB/CR/LF.  META rows precede data rows in
the exact listed key order.  Counts use unsigned base-10 without leading zero
except the value zero; booleans and verdicts use only their predeclared literal
tokens.

`FILE` means a readable regular non-symlink file and records its bytes.
`ABSENT` means `lstat` returned ENOENT.  `NONCANONICAL` covers every other
state, including symlink, directory, FIFO, socket, device, unreadable regular
file, stat error or changing file; `type-token` is one of
`SYMLINK DIRECTORY FIFO SOCKET DEVICE UNREADABLE STAT_ERROR CHANGED OTHER`,
and `detail-sha256` hashes the canonical diagnostic bytes.  Successful
evidence uses `FILE` for every required-present member and `ABSENT` only where
the literal typed vector requires a protected absence (build prestate,
candidate, contention, active-C0 or future lease); any different state or any
`NONCANONICAL` is INVALID.  A failure census contains exactly one of the
three row kinds for every path in its fixed array.  No unknown row, unknown
META key, repeated key/path, skipped index or optional field is accepted.
Contractual fixed arrays remain in literal source order and may not be sorted
at runtime; only ENV rows and the explicitly dynamic unexpected-path tail use
their specified unsigned-byte ordering.

After the fixed array, failure and C0 evidence append every path outside the
allowlist as `UNEXPECTED_FILE` or `UNEXPECTED_NONCANONICAL`.  The path itself
is hex encoded, so TAB, LF and arbitrary non-NUL filename bytes remain
representable.  This tail is ordered by unsigned bytewise comparison of raw
relative path bytes.  Discovery uses `lstat`, never follows a symlink and
walks only the exact project build, result, generated-source and control roots.
An unexpected path always makes the run INVALID, but its presence is evidence
to serialize—not an excuse for the parser to abort before custody.

The schema registry is exact:

| Header | Exact META keys in order | Exact row array |
|---|---|---|
| `F3_ENVIRONMENT_V1` | `PHASE ENTRY_COUNT VECTOR_SHA256` | one `ENV` row per complete environment entry in unsigned bytewise key order |
| `F3_LAKE_DELTA_V1` | `PHASE ALLOWED_PATH_COUNT CHANGED_PATH_COUNT PACKAGE_DELTA_COUNT SYSROOT_DELTA_COUNT` | one `DELTA` row for every changed allowed Lake path in the embedded module/artifact order |
| `F3_RUN_INPUT_MANIFEST_V1` | `GIT_HEAD GIT_BRANCH CWD AUTHORITY_COUNT CONTRACT_COUNT SEVEN_INPUT_COUNT SOURCE_COUNT TOOL_COUNT COMMAND_TABLE_SHA256 BASE_ENVIRONMENT_SHA256 BUILD_PRESTATE_COUNT CONTROL_COUNT CONTROL_VECTOR_SHA256 CONTROL_CAPTURE` | seven exact authority files, contracts/templates/registry, seven authored inputs, prerequisite source closure, every tool, command/environment inputs, complete B0/R0 build prestate and the `BOOTSTRAP_PRE_ATTEMPT` control vector |
| `F3_PRE_GENERATION_MANIFEST_V1` | `PHASE PREDECESSOR_PHASES PREDECESSOR_RECEIPT_SHA256S AUTHORITY_COUNT SEVEN_INPUT_COUNT SOURCE_COUNT OBJECT_COUNT TRANSITIVE_FILE_COUNT TRANSITIVE_VECTOR_SHA256 CONTROL_COUNT CONTROL_VECTOR_SHA256 CONTROL_CAPTURE` | frozen run-input manifest, B0/R0 terminal and output manifests, seven inputs, source tuple, resolved object tuple and the `LOCKED_SPECIAL_PREARCHIVE` control snapshot |
| `F3_POST_GENERATION_MANIFEST_V1` | `PHASE PREDECESSOR_PHASES PREDECESSOR_RECEIPT_SHA256S FRAGMENT_COUNT PAYLOAD_SHA256 BUILD_PRESTATE_COUNT TRANSITIVE_FILE_COUNT TRANSITIVE_VECTOR_SHA256 CONTROL_COUNT CONTROL_VECTOR_SHA256 CONTROL_CAPTURE` | pre-generation manifest, G01--G06/S0 terminal and output manifests, six fragments, generated Payloads source, V0/A0 build prestate and the `LOCKED_SPECIAL_PREARCHIVE` control snapshot |
| `F3_FINAL_ARTIFACTS_MANIFEST_V1` | `PHASE PREDECESSOR_PHASES PREDECESSOR_RECEIPT_SHA256S PREDECESSOR_PHASE_COUNT TERMINAL_RECEIPT_COUNT TRANSITIVE_FILE_COUNT TRANSITIVE_VECTOR_SHA256 VERDICT_INPUT_COUNT CONTROL_COUNT CONTROL_VECTOR_SHA256 CONTROL_CAPTURE` | complete acyclic chain through A0 (13 predecessor phases/receipts), every phase output manifest, generated source, verified objects, coverage, axiom profiles and the `LOCKED_SPECIAL_PREARCHIVE` control snapshot; no F0 successor |
| `F3_INPUT_MANIFEST_V1` | `PHASE ATTEMPT GIT_HEAD GIT_BRANCH CWD AUTHORITY_COUNT PREDECESSOR_COUNT SOURCE_COUNT TOOL_COUNT OBJECT_COUNT CONTROL_COUNT CONTROL_VECTOR_SHA256 CONTROL_CAPTURE` | literal authorities, predecessor receipts, source tuple, tool tuple and pre-existing object tuple consumed by that phase, then the exact control vector at `POST_ACTIVE_PRE_PAYLOAD` |
| `F3_OUTPUT_MANIFEST_V1` | `PHASE ATTEMPT RESULT RESULT_PATH_COUNT LAKE_ALLOWED_COUNT LAKE_CHANGED_COUNT PACKAGE_DELTA_COUNT SYSROOT_DELTA_COUNT ROOT_COUNT DEPENDENCY_LINE_COUNT UNIQUE_OBJECT_COUNT CONTROL_COUNT CONTROL_VECTOR_SHA256 CONTROL_CAPTURE` | every preterminal Section 6.1 phase path except the output manifest and terminal receipt, every allowed `LAKE7` path in embedded module order, every fixed phase/role publication candidate in Section 6.1 order, then the exact control vector; candidates are all `ABSENT` for `RESULT=PASS`, while `RESULT=INVALID` records their literal states; `RESULT=PASS` requires `CONTROL_CAPTURE=LOCKED_PRETERMINAL_POST_ARCHIVE`, while `RESULT=INVALID` requires `CONTROL_CAPTURE=FAILURE_LOCKED_CENSUS`; F0 also excludes its future report and report-custody receipt; the three dependency counters are zero outside B0/R0/V0/A0 |
| `F3_GUARD_RECEIPT_V1` | `PHASE ATTEMPT ROOT_PID PROCESS_START_TOKEN PGID AVAILABLE_KIB MIN_AVAILABLE_KIB MAX_SAMPLED_RSS_KIB SAMPLE_PERIOD_SECONDS PEAK_SAMPLED_RSS_KIB EXIT_STATUS MEMORY_VIOLATION EXACT_CHILD_ARGV_SHA256 START_UTC END_UTC` | exactly `vm_stat_pre`, `rss_members` and `rss_summary`; the guard receipt excludes itself |
| `F3_LOADED_OBJECT_TRACE_V1` | `PHASE ROOT_COUNT DEPENDENCY_LINE_COUNT UNIQUE_OBJECT_COUNT PROJECT_OBJECT_COUNT PACKAGE_OBJECT_COUNT SYSROOT_OBJECT_COUNT` | `OBJECT` rows in canonical first-occurrence order |
| `F3_PHASE_TERMINAL_RECEIPT_V1` | `PHASE ATTEMPT RESULT GIT_HEAD GIT_BRANCH PREDECESSOR_PHASES PREDECESSOR_RECEIPT_SHA256S COMMAND_SHA256 CWD LC_ALL LANG WALL_LIMIT_SECONDS EXIT_STATUS START_UTC END_UTC PRE_REVALIDATION POST_REVALIDATION INPUT_MANIFEST_SHA256 OUTPUT_MANIFEST_SHA256` | exactly the input manifest, output manifest and every phase-local nonmanifest result path before the terminal receipt in Section 6.1 order |
| `F3_F0_TERMINAL_RECEIPT_V1` | all phase-terminal keys in the same order, followed by `FINAL_ARTIFACTS_SHA256 TERMINAL_BRANCH CHECKER_CLASSIFICATION MACHINE_VERDICT SCOPED_CLASSIFICATION_1 SCOPED_CLASSIFICATION_2 SCOPED_CLASSIFICATION_3 SATURATED_ROWS DEFICIENT_ROWS` | exactly F0 input/output manifests, raw/status evidence and final manifest; no report or future receipt; the terminal branch fields obey the closed table below |
| `F3_F0_REPORT_CUSTODY_V1` | `RESULT GIT_HEAD GIT_BRANCH FINAL_ARTIFACTS_SHA256 F0_TERMINAL_RECEIPT_SHA256 REPORT_SHA256` | exactly final manifest, F0 terminal receipt and completed report; excludes itself |
| `F3_INVALID_CUSTODY_MANIFEST_V1` | `RESULT FIRST_INVALID_PHASE FIRST_INVALID_PREDICATE WRITER_LOCK_ACQUIRED NORMAL_PHASES_NEVER_STARTED C0_ATTEMPT` | exhaustive fixed census of all normal phase paths, build artifacts, guard files, active/archived leases and contention state, excluding the future invalid report and itself |

Loaded-object rows have the sole additional encoding
`OBJECT<TAB>index<TAB>lowercase-64-hex-sha256<TAB>base10-bytes<TAB>absolute-olean-path`.
No other schema may use `OBJECT`; only `F3_LAKE_DELTA_V1` may use `DELTA`.
Each DELTA state is `FILE`, `ABSENT` or `NONCANONICAL` with the same meaning as
the path rows; hash and byte fields are `-` unless that state is `FILE`.

For every canonical `F3_PHASE_TERMINAL_RECEIPT_V1` and
`F3_F0_TERMINAL_RECEIPT_V1`, the only legal values of both
`PRE_REVALIDATION` and `POST_REVALIDATION` are the literal token `PASS`.  They
mean that the complete typed input, predecessor, authority, source, tool and
pre-existing-object vectors were byte-identically revalidated before and after
the phase.  A pre- or post-revalidation that is not `PASS`, is not reached, or
cannot be completed makes a normal terminal receipt ineligible; no sentinel or
guessed hash is written and only C0 may seal that state.  Generic phase
receipts use `RESULT=PASS` or `RESULT=INVALID`; the latter is legal only on the
eligible failure-seal branch of Section 7.1.

`F3_F0_TERMINAL_RECEIPT_V1` is reserved for a fully valid through-F0 custody
chain and has exactly two legal rows of terminal META values:

| terminal field | all six saturated | at least one deficient |
|---|---|---|
| `RESULT` | `PASS_R3_REVERSE_BFS_PILOT_V3_6_OF_6` | `STOP_R3_REVERSE_CAPACITY_COUNTEREXAMPLE_V3` |
| `TERMINAL_BRANCH` | `ALL_SIX_SATURATED_PASS` | `ANY_DEFICIENT_SCOPED_STOP` |
| `CHECKER_CLASSIFICATION` | `SIX_CHECKER_ACCEPTED_SATURATED_ROWS` | `AT_LEAST_ONE_CHECKER_ACCEPTED_DEFICIENT_ROW` |
| `MACHINE_VERDICT` | `PASS_R3_REVERSE_BFS_PILOT_V3_6_OF_6` | `STOP_R3_REVERSE_CAPACITY_COUNTEREXAMPLE_V3` |
| `SCOPED_CLASSIFICATION_1` | `SIX_OWNER_SATURATION_PASS` | `SIX_ROW_SATURATION_STOP` |
| `SCOPED_CLASSIFICATION_2` | `NOT_APPLICABLE` | `FULL_CAPACITY_SUBROUTE_STOP` |
| `SCOPED_CLASSIFICATION_3` | `NOT_APPLICABLE` | `NO_F3_STOP` |
| `SATURATED_ROWS` | `6` | base-10 integer in `0..5` |
| `DEFICIENT_ROWS` | `0` | base-10 integer in `1..6` |

In the deficient branch the two row counts sum to exactly `6`; in both
branches `RESULT` and `MACHINE_VERDICT` are byte-identical, and the preceding
`F0.outputs.sha256` has `RESULT=PASS` because the checker/custody chain is valid
in either mathematical branch.  The specialized receipt is forbidden for an operational INVALID.  An eligible operational F0
failure may use `F3_PHASE_TERMINAL_RECEIPT_V1` at the same fixed terminal path;
otherwise it routes directly to C0.  A bare historical STOP token, any missing
scoped classification, `MATHEMATICAL_STOP`, `CAPACITY_COUNTEREXAMPLE` or
`F3_STOP` is schema-invalid.

The normal-phase control vector has exactly 23 fixed members, in this order:
the two guard files; normal-lease, C0-lease and contention candidates; active
normal and active C0 leases; first-contention marker; then archived leases in
the fourteen normal phase order followed by C0.  At
`BOOTSTRAP_PRE_ATTEMPT`, captured by the later B0 runbook while it holds both
unused kernel locks, guards are `FILE` and every candidate, active lease,
contention marker and archive is `ABSENT`.  At
`POST_ACTIVE_PRE_PAYLOAD`, guards and active-normal are `FILE`, all candidates,
active-C0 and first-contention are `ABSENT`, completed predecessor archives are
`FILE`, and current/future archives are `ABSENT`.  At
`LOCKED_SPECIAL_PREARCHIVE`, used only for the P0, P1 and F0 special manifests
after the controller has reacquired admission while retaining writer, the
literal vector is the same as `POST_ACTIVE_PRE_PAYLOAD`; no special manifest
may be published before that lock point.  At
`LOCKED_PRETERMINAL_POST_ARCHIVE`, the current archive is additionally `FILE`
and must be the same inode, hash and bytes as active-normal; every other state
is unchanged.  This capture is valid only for `RESULT=PASS`.  At
`FAILURE_LOCKED_CENSUS`, every one of the same 23 members records its actual
`FILE`, `ABSENT` or `NONCANONICAL` state in the exhaustive census restarted
after the executor has acquired and retained both locks.  No success-state
constraint is imposed: in particular, failure after creation of
`normal-lease.candidate` but before publication of active-normal is represented
as candidate `FILE`, active-normal `ABSENT` and current archive `ABSENT`.
Contention, partial candidates and every other malformed control state are
serialized rather than normalized, and make the result INVALID.  The run,
pre-generation, post-generation and final-artifacts manifests declare exactly
the capture tokens assigned above; input, successful-output and failed-output
manifests declare their respective exact tokens.  Any mismatch between a
declared capture and its literal rows is INVALID.

Control rows are explicitly capture-time state.  While the owner still holds
both locks, the terminal receipt revalidates the complete output snapshot.
After successful close removes active-normal, later phases revalidate the
immutable output-manifest bytes and the identical archived lease, not the
historical active pathname.  This is the only sanctioned persistent
post-snapshot control transition.  Fixed publication candidates outside the
23-member control vector may transiently move `ABSENT -> FILE -> ABSENT` only
for their one no-replace publication; target read-back, candidate unlink and
parent-directory `fsync` must finish before terminal revalidation.  A failed
transient is retained as orphan evidence, makes the run INVALID and authorizes
only C0 rather than a second publication.

`F3_R3_V3_FROZEN_RUN_INPUT_MANIFEST.sha256`,
`pre_generation_manifest.sha256`, `post_generation_manifest.sha256` and
`final_artifacts.sha256` have respectively the four distinct types
`F3_RUN_INPUT_MANIFEST_V1`, `F3_PRE_GENERATION_MANIFEST_V1`,
`F3_POST_GENERATION_MANIFEST_V1` and `F3_FINAL_ARTIFACTS_MANIFEST_V1`; none is
an alias for the per-phase `F3_INPUT_MANIFEST_V1`.  A file named `*.sha256`
therefore contains a full canonical typed receipt, not merely a bare digest.

Each `X.inputs.sha256` hashes all actual consumed authorities, sources,
scripts, pinned executable files, predecessor receipts and pre-existing
objects.  Each `X.outputs.sha256` hashes all phase-local evidence plus the
complete allowed Lake census and changed subset, but excludes itself and the
future terminal receipt.  A terminal receipt hashes those two manifests;
it does not repeat hundreds of transitive rows.  The guard receipt hashes
only its three already-written memory data files, and the output manifest
then hashes the guard receipt, eliminating every self-cycle.

The predecessor arrays are exactly: none for B0; B0 for R0; B0+R0 for P0;
P0 for G01; P0 plus all prior G receipts for each later G; P0+G01--G06 for
S0; P0+G01--G06+S0 for P1; the complete chain through P1 for V0; through V0
for A0; and through A0 for F0.  Each predecessor and input is revalidated
before and after the phase.  A manifest or receipt excludes itself; its hash
first appears only in an acyclic successor.

Exclusive creation of `control/normal-lease.candidate` after both kernel locks
are held, followed immediately by successful `fsync` of its parent directory,
is the sole durable normal attempt boundary.  No candidate content write,
active publication or payload may begin before that composite boundary.  It
consumes the attempt even if the lease later remains partial.  If power loss
occurs after `O_EXCL` returns but before the directory `fsync` completes,
recovery is determined only by durable observable state: an observable
candidate consumes the attempt; if it is absent, no payload could have begun
and no attempt is consumed.  Raw stdout/status publication occurs only after
the active lease exists and is secondary evidence, never a second boundary.
A crash, timeout or partial write after the durable boundary routes only to
`C0`; no reset or silent retry exists.  A crash before candidate `O_EXCL`
writes no invocation-owned path and consumes no attempt; the
post-`O_EXCL`/pre-`fsync` interval is governed by the observable-state recovery
rule above.

### 7.1 Kernel-serialized attempts and orphaned custody

PID inspection is metadata, never the concurrency primitive.  Every normal
or C0 controller opens the two precreated guard files without following
symlinks and uses Perl's kernel `flock`.  The admission descriptor has
`FD_CLOEXEC`; the writer descriptor deliberately does not.  The controller,
every nested timeout/supervisor and every payload descendant retain the writer
descriptor until that subtree has been killed if necessary and completely
waited/reaped.  A child that closes, unlocks or daemonizes away from that
descriptor is INVALID and is impossible for the literal argv/tool set.  The
controller first takes `admission.guard`, then tries
`writer.guard` exclusive/nonblocking.  A normal winner exclusively creates the
fixed candidate and fsyncs its parent directory, completing the durable attempt
boundary; it then writes, fsyncs and validates the complete lease and publishes
it by one no-replace hard link to `control/active_normal_lease.tsv` while it
still holds both locks.  Publication follows the already-consumed attempt
boundary.  The immutable lease records phase, PID,
process-start token, executor path/hash, canonical argv hash, UTC, branch and
HEAD.  Any crash after the durable candidate boundary is a consumed
`ORPHANED_ATTEMPT`, whether or not active publication completed; the recovery
rule above handles the narrower pre-fsync power-loss interval.

A normal loser, while still holding admission, writes the fixed contention
candidate and publishes at most the first complete
`control/first_contention.tsv` by the same no-replace protocol.  It
records the requested phase and the active-lease hash/state, then writes
nothing else.  Presence of that marker, even malformed, makes the active run
INVALID.  The owner retains writer for the entire phase.  Before declaring
success it reacquires admission while still holding writer, verifies absence
of contention, hard-links active-normal to the fixed `leases/X.lease.tsv` and
fsyncs that directory, then materializes and rereads the locked output
snapshot and all terminal evidence.  Only after terminal read-back does it
remove active-normal and release writer/admission.  This ordering leaves no
final-check/unlock race and makes the archived lease available to the terminal
manifest.  F0 retains both locks and active-normal through read-back of the
exterior report-custody receipt, then removes active-normal and releases.

On INVALID, signal, timeout, crash or power loss, every active normal lease and
every candidate whose target publication or read-back did not complete are
never removed.  A candidate whose target was published and reread successfully
is removed and its parent directory fsynced even when the enclosing result is
INVALID; its published target is the evidence.  Retained candidates and any
durable marker without a valid terminal receipt are exact orphan evidence: that
phase is consumed, every unstarted normal phase is forbidden and only one C0
may follow.  C0 takes admission and then tries
exclusive writer nonblocking; failure publishes only the first contention
marker, releases admission and opens no C0 attempt.  Acquiring writer is the
sole proof that no normal writer is live and is immune to PID reuse.  Under
both locks, exclusive creation of the fixed C0 candidate followed by immediate
successful parent-directory `fsync` is C0's sole durable attempt boundary; it
then writes/fsyncs the lease, publishes `control/active_c0_lease.tsv`, removes
and fsyncs the successfully published candidate, hard-links the active lease to
`leases/C0.lease.tsv` and fsyncs the archive directory.  C0 retains both admission and writer throughout
the exhaustive census, invalid manifest, report and all read-backs.  It leaves
both active-C0 and archived-C0 links present forever and never removes or
rewrites the orphaned normal lease.  Thus a completed invalid manifest snapshots
the final control state and needs no cyclic successor.  Presence of the fixed
C0 candidate, active custody lease or C0 archive consumes C0 and forbids any
second C0 attempt; the same observable-state recovery rule applies if power
loss occurs between C0 `O_EXCL` and parent `fsync`.  Normal and custody writers
cannot overlap.

The runbook verifies before B0 that both kernel locks exclude a second probe
on the actual result filesystem and that the writer descriptor survives the
literal exec chain.  The memory guard detects controller-parent loss, kills
its complete payload PGID, waits/reaps it and exits only afterward.  Every
nonmemory helper is beneath a remaining-time supervisor that retains writer
until its child is reaped.  Therefore outer-watchdog death cannot let C0 take
writer while a descendant still writes.  Inability to prove these properties
is `NO_GO`, not a fallback to PID locking.  Guard files,
active/archived leases and contention state are all exact
input/output-manifest members.

If an executor survives failure, it retains writer, takes and holds admission,
waits/reaps its complete descendant tree and first classifies active-normal,
the current archive, the typed input manifest, the output-manifest target and
candidate, and the terminal-receipt target and candidate without following
links.  A normal failure seal is eligible only if active-normal and the typed
input manifest are canonical `FILE`, complete pre- and post-revalidation both
return the literal token `PASS`, and all four output/terminal target and
candidate paths are `ABSENT`.  If active-normal is a canonical `FILE` and the
archive is `ABSENT`, it hard-links active-normal to that fixed archive and
fsyncs the archive directory; if both are canonical `FILE`, it requires
identical inode, hash and bytes and does not rewrite either.  Any other
active/archive combination is ineligible for a normal failure seal and is not
normalized.

Only on that eligible branch, still holding both locks, the executor restarts
from the beginning the exhaustive `FILE/ABSENT/NONCANONICAL` census over the
phase's entire fixed output, Lake, control and unexpected-path universe.  It
may then publish exactly one output manifest with `RESULT=INVALID` and
`CONTROL_CAPTURE=FAILURE_LOCKED_CENSUS`, followed by exactly one terminal
failure receipt that hashes the already valid input and new output manifests.
If either target or candidate ceases to be absent, or any creation,
publication or read-back step fails, it publishes no replacement and performs
no retry.

On every ineligible or interrupted-seal branch—including failure before active
publication or typed input creation, after an output manifest already exists,
during either output/terminal candidate, after a terminal receipt exists, or
during F0 report custody—the executor preserves every literal target,
candidate, lease and archive state, creates no further normal receipt, and
releases the two locks only after descendants are reaped.  Only C0 may then
seal the global exhaustive census.  Thus a published active lease and matching
archive remain for C0 when they exist, while a pre-publication failure remains
literally candidate-present/active-absent/archive-absent and no schema invents
an absent input manifest.
If the executor does not survive, C0 performs the global exhaustive census
under both locks from the durable marker and lease.  No failure path presumes
that any stdout, stderr, status, resource, fragment, object or memory file
exists.  Every census is restarted from the beginning after its final lock
set is held; no pre-lock observation is sealed.

Publication of every canonical file uses its one fixed phase/role candidate in
the same filesystem.  Immediately after exclusive creation, before any
fallible content write, its parent directory is opened and `fsync`ed so even an
empty/partial attempt marker is power-loss durable.  Publication then requires
complete write, file `fsync`,
read-back and rehash, then one no-replace hard link onto an absent target.
After every link, unlink or lease archive operation, the containing directory
is opened and `fsync`ed before the next causal step.  A candidate is removed
and its directory `fsync`ed again only after successful target publication and
read-back; every incomplete or failed publication retains it, whereas a
successfully published candidate is removed even if a later enclosing verdict
is INVALID.  No evidence target is overwritten.  Every possible fixed
candidate state is included in the exhaustive failure census; a self/future
C0 publication candidate is recorded `ABSENT` at the locked snapshot and must
return to `ABSENT` after its successful publication/read-back cleanup.

The fragment directory is dedicated.  The materializer enumerates directory
entries without shell glob expansion, compares them against the six literal
fragment paths, requires regular non-symlink files `6/6`, rejects every extra,
duplicate, directory or special file, and rehashes before and after
materialization.  It concatenates a fixed wrapper plus fragments in order 01
through 06 byte-for-byte and a fixed closing wrapper.  It performs no semantic
rewrite, Lean invocation, generation or check.

## 8. Memory-group mechanism frozen for authoring

macOS has no `setsid` executable in this environment.  The memory guard must
therefore use `/usr/bin/perl` with `POSIX::setsid` as a fixed supervisor
mechanism, not accept an arbitrary command.  A validated phase token selects
one literal argv array already present in the guard.

The child calls `setsid`, requires `getpgrp() = PID`, and performs a two-pipe
ready/go handshake using two anonymous unidirectional Perl `pipe()` pairs.
No filesystem FIFO is created.  Unused pipe ends are closed immediately and
all handshake descriptors are closed after release.  The guard stays outside the new process group, records
PID/PGID, takes sample zero before releasing the child, then permits the child
to exec `gtimeout --foreground`, `/usr/bin/time -p`, and the literal phase
command.  A missing handshake, early exit or mismatch is INVALID.

The guard parses one complete `/bin/ps -axo pid=,ppid=,pgid=,rss=` snapshot
per sample, computes the transitive PPID closure from the phase root, requires
every live descendant to be a member of the recorded PGID and every counted
PGID member to be in that closure, and sums each member once.  Sampling is
immediate, every completed second, and final.  Parse failure, escaped child,
missing sample or sampled total above `8388608` KiB sends group-directed
`SIGKILL` through frozen `/bin/kill`, waits for the supervisor and yields
INVALID.

The exact availability formula, 4-GiB launch floor, one-second sampling and
four memory outputs are those of contracts v3/v4.  The members and summary
TSV files have no header because every row is numeric under the v4 schema.
The guard receipt carries PID, PGID, constants, parsed availability, peak,
exit, violation and exact command.

## 9. Narrow operational-cycle reconciliation

Sections 6.1 and 7 control every evidence grammar and path vector.  This
section controls only causal order and verdict meaning where consistent with
those typed schemas.

### 9.1 F0 hash chain

Contract v3 Section 4.4 asked `final_artifacts.sha256` to include the run
report, while the normal report template asks the report to contain the hash
of `final_artifacts.sha256` and of the later F0 receipt.  That graph is
cryptographically cyclic and has no fixed ordering.

For this successor lane, the normal template pinned by registry v10 remains
historical input but is not used verbatim.  Exactly one successor wrapper is
embedded literally in the executor and frozen as part of that script.  It is
identified by the line
`REPORT_SCHEMA_ID = F3_R3_REVERSE_BFS_PILOT_V3_SUCCESSOR_REPORT_V1`
immediately after `REPORT_KIND = NORMAL_TERMINAL`.  Starting from the pinned
template, only these structural replacements are legal; every other heading,
prose paragraph, six-row table, provenance field, custody field and mandatory
no-claim line remains in the same order, with each placeholder replaced from
sealed evidence:

1. Section 3's first sentence is replaced by: “Rows B0 through A0 must have
   status PASS; F0 must have the exact specialized machine verdict; all
   fourteen rows require exact receipt hashes and PASS pre/post revalidation.”
   The phase-table order is unchanged.  `B0_STATUS` through `A0_STATUS` are
   literal `PASS`; `F0_STATUS` is byte-identical to the specialized terminal
   receipt's `MACHINE_VERDICT`; every `X_REVALIDATION` is literal `PASS`.
2. Exactly one Section 5 branch remains.  Its fenced key order and mapping are
   the exact branch blocks below.  In the PASS report only,
   receipt `SCOPED_CLASSIFICATION_1` is emitted under the historical singular
   report key `SCOPED_CLASSIFICATION`; receipt fields 2 and 3 must both be
   `NOT_APPLICABLE` and are not emitted.  The STOP report emits the three
   numbered keys without a singular alias.
3. Deficient table rows are emitted exactly once in registry-v10 row order and
   their count equals `DEFICIENT_ROWS`; no deficient table is emitted in PASS.
4. In Section 6, the impossible future line
   `FINAL_READBACK_AFTER_REPORT = PASS` is removed.  In its exact position the
   wrapper emits, in order, `F0_TERMINAL_RECEIPT_SHA256 =` followed by the
   receipt hash, `F0_REPORT_CUSTODY_ROLE = EXTERIOR_NONPHASE_SUCCESSOR`, and
   `REPORT_AUTHORITY_REQUIRES_F0_REPORT_CUSTODY_RECEIPT = YES`.  No report
   self-hash or future custody-receipt hash is emitted.

The exact selected branch blocks are:

```text
TERMINAL_BRANCH = ALL_SIX_SATURATED_PASS
CHECKER_CLASSIFICATION = SIX_CHECKER_ACCEPTED_SATURATED_ROWS
MACHINE_VERDICT = PASS_R3_REVERSE_BFS_PILOT_V3_6_OF_6
SCOPED_CLASSIFICATION = SIX_OWNER_SATURATION_PASS
SATURATED_ROWS = 6
DEFICIENT_ROWS = 0
```

or:

```text
TERMINAL_BRANCH = ANY_DEFICIENT_SCOPED_STOP
CHECKER_CLASSIFICATION = AT_LEAST_ONE_CHECKER_ACCEPTED_DEFICIENT_ROW
MACHINE_VERDICT = STOP_R3_REVERSE_CAPACITY_COUNTEREXAMPLE_V3
SCOPED_CLASSIFICATION_1 = SIX_ROW_SATURATION_STOP
SCOPED_CLASSIFICATION_2 = FULL_CAPACITY_SUBROUTE_STOP
SCOPED_CLASSIFICATION_3 = NO_F3_STOP
SATURATED_ROWS = {{SATURATED_ROWS}}
DEFICIENT_ROWS = {{DEFICIENT_ROWS}}
```

The two double-braced STOP fields are replaced only by the byte-identical
base-10 values in the terminal receipt and must satisfy its range/sum rules.
Those replacements change only the F0/report custody interface and make the
v6 checker meaning explicit; they preserve every mathematical row, verdict and
no-claim field.  Any additional deletion, insertion, key alias or reordering is
INVALID.

The binding acyclic order is:

```text
final_artifacts.sha256
  -> F0.outputs.sha256
  -> F0_terminal_receipt.sha256
  -> F3_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.md
  -> F0_report_custody_receipt.sha256
```

`final_artifacts.sha256` excludes all four successors.  After complete
through-A0 revalidation, `F0.outputs.sha256` hashes the final manifest,
F0 raw/status evidence, excluding every successor; there is no separate
revalidation-record path.  `F0_terminal_receipt.sha256` carries the exact
singleton `PRE_REVALIDATION=PASS` and `POST_REVALIDATION=PASS` META values,
hashes the F0 input/output manifests and those scoped raw/status inputs,
excludes itself and establishes the fourteenth phase's exact saturated PASS or
three-label scoped STOP row from the closed terminal table.  It does not hash a
future report.

Only after that receipt passes read-back may the successor normal report be
materialized.  Its phase table therefore has the exact mapping:

```text
B0_STATUS..A0_STATUS = PASS
F0_STATUS = exact MACHINE_VERDICT copied from F0_terminal_receipt.sha256
F0_RECEIPT_SHA256 = exact SHA-256 of F0_terminal_receipt.sha256
F0_REVALIDATION = PASS
```

The report's selected branch uses only the exact mapping and key order above.
Thus no F0 status, row count or receipt hash is predicted.  The report records
the exact final-manifest and F0-terminal-receipt hashes.  The exterior
`F0_report_custody_receipt.sha256` is not a fifteenth phase; it excludes itself
and hashes the final manifest, F0 terminal receipt and completed report.  A
failure before its read-back leaves the run INVALID and routes only to C0;
the report wrapper states that it is authoritative only together with this
valid exterior receipt.  This narrowly supersedes the old template's cyclic
F0 row and impossible future-hash field.

### 9.2 Failed generation receipt

On successful `G0i`, its typed output manifest exhausts the exact G0i row of
Section 6.1 and the terminal receipt hashes that manifest, the applicable
input manifest, predecessors and guard receipt.  On failure, Section 7.1's
exhaustive `FILE/ABSENT/NONCANONICAL` array applies to the same fixed universe
without assuming any subset is present.  If a valid canonical fragment was
not atomically published, it is `ABSENT`; partial stdout remains raw evidence
and is never promoted.  A hard crash may leave no terminal receipt, in which
case the durable marker and stale lease are `ORPHANED_ATTEMPT` evidence and
authorize only C0.  This totalizes v4's success receipt and terminal-failure
intent without fabricating bytes.

### 9.3 Loaded-object trace

Within the same `SEQUENCE_PROGRAM_V1`, session leader, PGID, aggregate timeout
and memory guard as the successful build, B0 next runs the argv

```text
/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lake env /usr/bin/perl -e ENV_CAPTURE_AND_EXEC_V1 PHASE_X ENV_X /Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean --deps ROOT_SOURCE
```

once for each of its eight absolute root sources in Section 6 order.  R0 uses
the same construction for Rows then Generate; V0 for Payloads then Pilot; A0
for its audit root.  `ENV_CAPTURE_AND_EXEC_V1`, `PHASE_X`, `ENV_X` and `ROOT_SOURCE` are
the defined array components of Section 6, not literal strings in the script.
The authored guard embeds every absolute source and environment path; no
caller supplies one.  All steps for one phase require byte-identical captured
environment bytes.

Raw outputs are concatenated in root order into `X.dependencies.raw` with a
delimiter line exactly
`@@F3_DEPS_ROOT<TAB>four-digit-root-index<TAB>lowercase-hex-absolute-source-path@@<LF>`
before each root's byte-exact output.  Root indices begin `0001`; a Lean output
line beginning `@@F3_DEPS_ROOT<TAB>` is ambiguous and INVALID.  Repetition in
that raw multi-root output is expected and retained.  Every reported dependency must resolve to one unique regular
non-symlink `.olean` under exactly one of the project build, Lake package or
frozen Lean sysroot roots.  `X.loaded_objects.tsv` stable-deduplicates by the
resolved canonical absolute path at first occurrence, includes all declared
roots, and has exact rows

```text
OBJECT<TAB>four-digit-index<TAB>lowercase-sha256<TAB>base10-bytes<TAB>absolute-olean-path
```

The trace records `ROOT_COUNT`, `DEPENDENCY_LINE_COUNT` and
`UNIQUE_OBJECT_COUNT`; root counts are `8`, `2`, `2`, `1` for B0, R0, V0,
A0.  A repeated canonical path in the final deduplicated vector, non-path
output, unresolved, ambiguous, missing or outside-root object is INVALID.
The same three META values in `X.outputs.sha256` must be byte-identical to
those in `X.loaded_objects.tsv`; every nontrace phase records literal
`0 0 0`.  Any disagreement is INVALID.
The raw command output, resolver tool and all resolved objects are hashed.
This is the binding meaning of “complete loaded-object trace”; a nominal
local-import list alone is insufficient.

### 9.4 C0 acyclic custody

`invalid_custody_manifest.sha256` is written and revalidated first.  It
excludes the future invalid report and exhaustively records
`FILE/ABSENT/NONCANONICAL` state, the durable marker or failure receipt, both
kernel guards, every active/archived lease, contention state, first INVALID
predicate and every never-started phase.  Its own and the future report's
publication candidates are `ABSENT` in that snapshot.  At this locked snapshot both
`control/active_c0_lease.tsv` and `leases/C0.lease.tsv` already exist with
identical bytes and remain permanently present; the successfully published C0
lease candidate has already been removed and fsynced.  Publication and
read-back of the manifest remove/fsync its candidate, returning that path to
the recorded `ABSENT` state.  The invalid
report is then materialized from
the pinned invalid template with exact tokens:

```text
C0_INVOKED = YES
C0_ATTEMPT_COUNT = 1
C0_TERMINAL_STATUS = MANIFEST_SEALED_REPORT_IS_FINAL_UNRECEIPTED_OUTPUT
INVALID_CUSTODY_MANIFEST_SHA256 = exact manifest hash
```

The report makes no claim that its own future read-back succeeded and has no
self-hash or successor receipt.  On successful publication/read-back its
candidate is removed and its directory fsynced, so the final candidate state
again equals the manifest snapshot and no control transition follows.  If its
atomic publication or read-back fails, the candidate is retained, the earlier
manifest is only a valid pre-report snapshot rather than terminal-final
custody, classification remains INVALID and the sole C0 attempt is consumed;
there is no retry or false completion claim.  This two-file order is acyclic
and preserves v4's exact C0 output surface.

## 10. Static authoring audit and freeze

After authoring, the only permitted checks are read-only source/hash/Git
inspection and, for each script, this literal sanitized argv construction:

```text
/usr/bin/env -i HOME=/Users/MoiTam ELAN_HOME=/Users/MoiTam/.elan PATH=/Users/MoiTam/.elan/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin LC_ALL=C LANG=C /bin/bash --noprofile --norc -n ABSOLUTE_SCRIPT_PATH
```

`ABSOLUTE_SCRIPT_PATH` is documentary notation replaced by one of the three
literal authorized paths; it must not occur in the executed argv or authored
script.  Static review may inspect executable availability and hashes but may
not invoke any pilot phase or Lean/Lake/generator command.

Two independent auditors must examine the same exact seven-path tuple and
both report `P1_RESIDUAL=0` and `P2_RESIDUAL=0`.  Their audit must cover at
least:

- exact paths, regularity, modes, hashes, lines, LF, no NUL/CRLF;
- imports and full generator-cone exclusion;
- all six typed coordinates and the twelve public check/outcome statements;
- explicit serializer with no expected outcomes;
- exact phase grammar, adjacency, one-attempt markers and INVALID dominance;
- exact commands, outputs, receipts, resources and memory schemas;
- absence of generic execution, reset, resume, cleanup, overwrite and glob
  expansion;
- materializer `6/6` byte-preserving behavior;
- forbidden theorem-cone mechanisms and exhaustive audit coverage; and
- no write outside the seven-path authoring set.

Under this act the two audits are read-only and their messages are out-of-band;
they are not authorized additions to the seven-path write set.  Persisting
either audit, repairing any P1/P2, or creating a freeze decision requires a
separate root act.  Static audit verdicts must say
`SOURCE_CONFORMANCE_ONLY` and `NO_BUILD_OR_RUNTIME_RESULT`; generated Lean
declarations and the actual axiom cone remain A0-only evidence.

Before B0 can become eligible, later separate custody must publish and pin
these exact authority paths (the names are fixed now; their future hashes are
not guessed):

1. `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_R3_V3_EXACT_SEVEN_INPUT_AUTHORING_ROOT_AUTHORIZATION_v1.md`;
2. `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_R3_V3_INPUT_REGISTRY_AND_PREEXECUTION_REVIEW_ROOT_AUTHORING_AUTHORIZATION_v1.md`;
3. `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_R3_V3_INPUT_REGISTRY_AND_PREEXECUTION_REVIEW_v1.md`;
4. `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_R3_V3_EXACT_SEVEN_INPUT_INDEPENDENT_STATIC_AUDIT_1_PASS_v1.md`;
5. `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_R3_V3_EXACT_SEVEN_INPUT_INDEPENDENT_STATIC_AUDIT_2_PASS_v1.md`;
6. `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_R3_V3_EXACT_SEVEN_INPUT_ROOT_FREEZE_DECISION_v1.md`; and
7. `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_R3_V3_B0_EXECUTION_ROOT_AUTHORIZATION_AND_RUNBOOK_v1.md`.

The later runbook must additionally publish exact typed inputs named
`F3_R3_V3_FROZEN_RUN_INPUT_MANIFEST.sha256`,
`F3_R3_V3_BASE_ENVIRONMENT.tsv` and `F3_R3_V3_COMMAND_TABLE.tsv` under the
fixed result root.  It must embed the finite module/artifact arrays and every
tool/program hash; no script may invent or amend them at execution time.

That runbook must create or verify the dedicated execution worktree at
`/Users/MoiTam/Documents/New project/coordinated/hilo2-f3-r3-pilot-v3-run`
from the public frozen seven-input commit.  Immediately before B0 it requires:
regular non-symlink ancestry, exact branch/HEAD, empty index, zero tracked
diff, the frozen source tuple, and the frozen `.lake` prestate.  The checkout
must have zero untracked paths before runbook bootstrap; bootstrap then creates
only the three typed run inputs, exact result/control directory ancestry, both
guard files and exact Lake parent-directory closure.  The immediate pre-B0
untracked/ignored vector must equal that frozen bootstrap allowlist byte for
byte—never a blanket ignore—and package/sysroot prestates are immutable.  The
dirty authoring checkout is never an execution cwd.

B0 must hash all seven authority paths and the three typed run inputs in its
input manifest.  R0 must revalidate
them.  P0 must include them by exact path, SHA-256 and size in the
pre-generation manifest, and every later phase revalidates them transitively.
An authority artifact outside that chain makes B0/P0 INVALID.  Only the later
root freeze decision may make a separately authored B0 runbook eligible; the
seven-file freeze itself still grants no execution.

## 11. No-claim boundary

```text
NO_B0_RESULT
NO_R0_RESULT
NO_GENERATED_CERTIFICATE
NO_CHECKER_RESULT
NO_SIX_ROW_PASS_OR_STOP
NO_RESIDUAL_D2_RESULT
NO_RHO_CERTIFICATE
NO_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
```
