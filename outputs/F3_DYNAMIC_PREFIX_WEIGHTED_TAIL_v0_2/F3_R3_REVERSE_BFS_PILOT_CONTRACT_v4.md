# F3 R3 reverse-BFS six-row pilot contract v4

Date: 2026-07-25.

Status:

```text
V4_CUSTODY_SUCCESSOR_PREDECLARED_BEFORE_REVERSE_SEARCH
V3_MATHEMATICS_ROWS_PREREQUISITES_RESOURCES_UNCHANGED
SEVEN_PENDING_SOURCE_ARTIFACTS_UNCHANGED
PHASE_OUTPUTS_HASHED_AT_CREATION
POST_GENERATION_MANIFEST_REVALIDATED_FAIL_HARD
VERIFICATION_AND_AUDIT_RECEIPTS_CHAINED
EARLY_INVALID_CUSTODY_BRANCH_PREDECLARED
RSS_OUTPUT_SCHEMA_PREDECLARED
SOURCE_HASH_FREEZE_PENDING
NO_LEAN_EXECUTION_FOR_THIS_CONTRACT
NO_REVERSE_BFS_RESULT_OBSERVED
NO_R3_FINITE_PASS
NO_F3_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## 1. Succession and exact amendment scope

This document is a minimal custody successor to
`F3_R3_REVERSE_BFS_PILOT_CONTRACT_v3.md`, whose frozen SHA-256 is

```text
620f15497644be361f7a06ef4fa31362f325f94eda37b02de145450712fe30d6
```

V4 changes no row, row order, prerequisite, checker proposition, resource
ceiling, attempt count, mathematical verdict predicate or no-claim boundary.
The v3 artifact/module names and v3 verdict names remain deliberate: this is
a custody amendment, not a new mathematical pilot.

V4 supersedes v3 only on four operational points:

1. every prepared/generated output is hashed in its phase receipt before the
   next phase may start;
2. the post-generation manifest is revalidated fail-hard before and after
   every verifier/audit/custody phase;
3. memory samples have exact filenames and schemas; and
4. the first INVALID event branches to one non-mathematical custody phase
   instead of leaving an unauthorised or unrecorded partial run.

All v3 requirements not expressly replaced below remain binding.

## 2. Seven pending source artifacts, exactly

The pre-generation source surface still contains exactly these seven pending
artifacts:

```text
CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotRowsV3.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotGenerateV3.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotV3.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotV3AxiomAudit.lean
outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/
  f3_r3_reverse_bfs_pilot_v3_executor.sh
outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/
  f3_r3_reverse_bfs_pilot_v3_memory_guard.sh
outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/
  f3_r3_reverse_bfs_pilot_v3_materialize.sh
```

The generated payload module is intentionally not an eighth pending input.
It is created only by `S0` after all six generation receipts exist.  Manifests,
logs, receipts and memory tables are run outputs, not prewritten source
artifacts.  Generation remains forbidden until all seven input hashes replace
their pending markers and `P0` succeeds.

## 3. Deterministic phase state machine

The sole normal path remains

```text
B0 -> R0 -> P0 -> G01 -> G02 -> G03 -> G04 -> G05 -> G06
   -> S0 -> P1 -> V0 -> A0 -> F0
```

Each transition requires a successful terminal receipt for the immediately
preceding phase and fail-hard revalidation of every earlier receipt required
by Section 4.  A phase may run at most once.

At the first INVALID condition in any normal phase, that phase records its
terminal failure receipt, all unstarted normal phases become permanently
forbidden, and the only permitted successor is `C0`.  `C0` may run once.  It
performs custody only and cannot resume, retry, verify, audit or generate.

The only new top-level command is therefore:

```text
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_executor.sh' C0
```

It is authorised only immediately after the first terminal INVALID receipt.
Invoking it on the normal path, invoking a skipped normal phase, or invoking
anything after `C0` is INVALID.  The exact normal-path commands remain the
literal v3 Section 5 commands.

`C0` has one 600-second attempt, no Lean invocation, no reverse search and no
mathematical execution.  It cannot change INVALID into STOP or PASS.

## 4. Hash chain and immutable transition rules

### 4.1 Preparation receipts

At successful completion, `B0` and `R0` write, respectively,
`B0_terminal_receipt.sha256` and `R0_terminal_receipt.sha256`.  Each receipt
hashes every source, object, executable, loaded-object trace, environment
file, raw log and memory output produced or consumed by that phase, excluding
only the receipt file itself so that no self-hash is requested.  `R0` first
revalidates the complete `B0` receipt.  `P0` first revalidates both complete
receipts and then seals the pre-generation manifest.

Contrary to the permissive sentence in v3 Section 4.1, no source, object,
script, command or executable may mutate after the successful receipt that
records it.  A mismatch before `P0` is INVALID; it does not authorise a
same-contract rebuild, new receipt or retry.

`P0` hashes the final bytes of its own manifest and status outputs into its
terminal receipt after writing them, and immediately revalidates that receipt.
Every later normal phase revalidates the P0 receipt and the complete
pre-generation manifest both immediately before and immediately after its
work.  Any drift is INVALID even if the phase otherwise exits zero.

### 4.2 Per-row generation receipts

Each `G0i` writes a separate `G0i_terminal_receipt.sha256`, which hashes
exactly its five v3 outputs:

```text
row_0i.raw.stdout
row_0i.raw.stderr
row_0i.exit_status
row_0i.resource_receipt
row_0i.canonical_fragment.lean
```

Before `G0i` starts, the executor revalidates every earlier `G0j` receipt and
output.  It repeats that revalidation after `G0i` finishes.  Thus an earlier
fragment cannot be changed while later rows are generated.

`S0` first revalidates all six generation receipts and inputs.  Its separate
`S0_terminal_receipt.sha256` hashes those six receipt hashes, the fixed
wrapper bytes, its raw stdout/stderr/status, and the exact materialized
payload source.  `P1` first
revalidates the six generation receipts and the S0 receipt; after sealing
`post_generation_manifest.sha256`, it records the final bytes and SHA-256 of
that manifest in `P1_terminal_receipt.sha256` and immediately revalidates it.

### 4.3 Verifier, audit and final custody

Before invoking Lean or loading any pilot object, `V0` must fail-hard
revalidate:

```text
P0 terminal receipt and complete pre-generation manifest
six G0i terminal receipts and their complete output sets
S0 terminal receipt and materialized payload source
P1 terminal receipt and complete post-generation manifest
```

`V0` repeats this full revalidation after Lean exits.  Only then may it seal
`V0_verification_receipt.sha256`, which hashes its source/object inputs, exact
Lean command, stdout/stderr/status, checker coverage and produced acceptance
object.

Before invoking Lean, `A0` revalidates the entire V0 input chain plus
`V0_verification_receipt.sha256` and every file named by it.  It repeats that
revalidation after the audit exits.  Only then may it seal
`A0_audit_receipt.sha256`, including the exhaustive namespace/cone coverage,
raw outputs, status and audit object.

Before writing final custody, `F0` revalidates the complete P0, G01--G06, S0,
P1, V0 and A0 chains.  It then writes `final_artifacts.sha256`, hashes the
final manifest into its terminal report, and performs a final read-back
verification.  Any missing file, mismatch or unparseable receipt at any point
is INVALID and branches to `C0`; it is never a reason to run Lean first.

## 5. Exact memory output surface

For every memory-controlled phase `X`, the frozen guard must create exactly:

```text
memory/X.vm_stat_pre.txt
memory/X.rss_members.tsv
memory/X.rss_summary.tsv
memory/X.guard_receipt.sha256
```

`X.rss_members.tsv` has these fields in this exact order, separated by one
U+0009 TAB byte:

```text
sample_index<TAB>elapsed_seconds<TAB>pid<TAB>ppid<TAB>pgid<TAB>rss_kib
```

and one row for every process counted at every sample.  `X.rss_summary.tsv`
has these fields in this exact order, again separated by one U+0009 TAB byte:

```text
sample_index<TAB>elapsed_seconds<TAB>member_count<TAB>total_rss_kib
```

and exactly one row per sample index.  Indices start at zero and increase by
one.  `elapsed_seconds` is an integer: zero for the immediate sample and the
number of completed one-second sampling intervals thereafter.  PID, PPID,
PGID, member count and RSS fields are base-ten nonnegative integers.

`X.vm_stat_pre.txt` is the unmodified raw `/usr/bin/vm_stat` output used by
the exact v3 availability formula.  `X.guard_receipt.sha256` hashes the three
other files and records the root PID, PGID, constants, parsed available KiB,
peak sampled group RSS, phase exit, violation flag and exact guard command.

A missing/extra file, header mismatch, duplicate/missing sample index,
members/summary disagreement, arithmetic mismatch, nonmonotone elapsed field,
or receipt hash mismatch is `INVALID_MEMORY_POLICY`.  The appropriate B0/R0,
G0i, V0 or A0 phase receipt must include and revalidate all four files.  This
schema supplements, and does not relax, v3's exact process-group, page-count,
sampling and termination semantics.

## 6. Early INVALID custody

`C0` reads but does not repair the partial run.  It writes:

```text
invalid_custody_manifest.sha256
INVALID_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.md
```

These record and hash, when present:

- v1, v2, v3 and v4 contracts and the declared Git state;
- every completed phase receipt and its named files;
- the first failed phase, exact INVALID predicate and terminal status;
- all raw stdout/stderr, memory tables, objects, fragments and manifests that
  existed when normal execution stopped; and
- an explicit list of phases never started.

Absence of a later manifest because failure occurred early is recorded as
`NOT_CREATED_BEFORE_INVALID`, not fabricated or treated as PASS.  `C0` must
not rewrite a prior output.  If `C0` itself fails or drifts, the mathematical
verdict remains INVALID, its partial raw custody is preserved, and no retry or
other phase is authorised.

## 7. Verdicts and no-claim boundary

The exact v3 precedence and names remain unchanged:

```text
INVALID_R3_REVERSE_BFS_PILOT_V3
STOP_R3_REVERSE_CAPACITY_COUNTEREXAMPLE_V3
PASS_R3_REVERSE_BFS_PILOT_V3_6_OF_6
```

Any custody/hash/memory failure is INVALID and therefore dominates STOP and
PASS.  STOP still requires a completely valid run plus a kernel-accepted
deficient certificate and the audited completeness theorem.  PASS still
requires a completely valid run and six exact checker-accepted saturated
certificates.  `C0` supplies evidence for INVALID only.

No statement in v4 promotes the six rows, certifies any other owner, or proves
a residual-D2 gate, full Block0 capacity, `rho = 9/5`, an exponent, density or
Collatz.
