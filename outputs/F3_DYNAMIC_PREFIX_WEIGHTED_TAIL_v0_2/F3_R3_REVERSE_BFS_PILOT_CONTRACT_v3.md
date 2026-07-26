# F3 R3 reverse-BFS six-row pilot contract v3

Date: 2026-07-25.

Status:

```text
CONTRACT_SUCCESSOR_PREDECLARED_BEFORE_REVERSE_SEARCH
V2_SELECTION_AND_SIX_ROWS_UNCHANGED
BUILD_THEN_FREEZE_ORDER_CORRECTED
GENERATOR_OBJECT_CLOSURE_MUST_BE_FROZEN
CANONICAL_PAYLOAD_MATERIALIZATION_PHASE_PREDECLARED
INVALID_VERDICT_PRECEDENCE_PREDECLARED
MEMORY_MEASUREMENT_SEMANTICS_PREDECLARED
SOURCE_HASH_FREEZE_PENDING
NO_ORBIT_EXECUTION_FOR_THIS_CONTRACT
NO_LEAN_EXECUTION_FOR_THIS_CONTRACT
NO_REVERSE_BFS_RESULT_OBSERVED
NO_R3_FINITE_PASS
NO_F3_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## 1. Succession and narrow correction surface

This document is the governance successor to
`F3_R3_REVERSE_BFS_PILOT_CONTRACT_v2.md`, whose frozen SHA-256 is

```text
0378df70dc1dc0d67460299562a7c12034fa5598378aaed1e8a0887f6e6725cb
```

V3 preserves v2's selection rule, six rows and order, mathematical checker,
prerequisite graph, wall and heartbeat ceilings, one-attempt rule, public
theorem-cone audit and no-claim boundary.  It supersedes v2 only where needed
to remove four pre-freeze ambiguities:

1. cold objects and the generator are built before the pre-generation input
   surface is sealed;
2. the exact generator object/executable and loaded-object closure are part
   of that seal;
3. canonical payload materialization is an explicit, prehashed phase;
4. `INVALID` dominates every mixed outcome, and the sampled memory policy has
   one exact operational meaning.

Any v2 text inconsistent with Sections 4--7 below is superseded.  All other
v2 requirements remain binding.  No v2 source or receipt is modified.

The audited Execution Registry v4 source remains frozen at SHA-256

```text
ce41dbb63c77ddbc166382323caf892e6b5b3441ba3c45904a2f8503caecdc27
```

## 2. Six-row surface, unchanged

The semantic key remains

```text
(rootIndex, rootValue, FormulaEdge constructor, formulaSource.val, ell.val?)
```

The D2 and D1 selection rules of v1/v2 remain unchanged.  No first-hit datum
was used to select a row.  The immutable order is:

| order | row id | constructor | demand | root index | parent `a` | source | `ell` | formula target | exact `qHi` | semantic child | child window |
|---:|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | `RET_D2_MAX` | `retarded` | 2 | 24 | 77 | 75 | - | 65 | `875/837` | 308 | 19712 |
| 2 | `RET_D1_CONTROL` | `retarded` | 1 | 11 | 38 | 37 | - | 152 | `10300/11907` | 152 | 9728 |
| 3 | `DIRECT_D2_MAX` | `advancedDirect` | 2 | 52 | 161 | 159 | 0 | 105 | `580743/404000` | 107 | 41088 |
| 4 | `DIRECT_D1_CONTROL` | `advancedDirect` | 1 | 76 | 233 | 231 | 0 | 153 | `2983/3000` | 155 | 59520 |
| 5 | `LIFT_D2_MAX` | `advancedParityLift` | 2 | 44 | 137 | 135 | 0 | 181 | `8007/6100` | 182 | 34944 |
| 6 | `LIFT_D1_CONTROL` | `advancedParityLift` | 1 | 224 | 677 | 189 | 2 | 172 | `157/162` | 902 | 173184 |

The background profile remains `1168` D1 owners, `452` D2 owners and `2072`
total atoms.  A six-row PASS cannot be promoted to a residual-D2 or full
ownerwise result.

## 3. Prerequisites, unchanged and still fail-closed

The exact gate remains:

```text
ordered/predecessor/static prerequisites already audited
  -> MassDemandProfile build + audit 24/24 and decide inventory 2/2
  -> ReverseBFSMassIntegration build
  -> ReverseBFSAxiomAudit 42/42
  -> SemanticChildBaseHit build + audit 3/3
  -> ReverseBFSCompleteness build + audit 4/4
  -> SIX-ROW PILOT V3
  -> only after six-row PASS: a new residual-D2 contract
```

`ActiveChannelIntervals`, `OrderedFirstHit`, `OrderedFirstHitBool`,
`ReversePredecessor`, `ActiveStaticPreconditions`, `MassAtoms`,
`ReverseBFSData`, and `ReverseBFSVerifier` retain the exact build/audit
requirements listed in v2 Section 3.

`SameParentDisjoint`, `FirstHitAllocation`, and `DemandOneClosed` are not hard
prerequisites of this six-row pilot.  They remain downstream prerequisites
for stronger uses and cannot be used to promote this pilot.

No `IN_PROGRESS`, source-only file, `.ilean` alone, stale `.olean`, missing
receipt or failed audit satisfies a prerequisite.

## 4. Corrected freeze and materialization protocol

The fixed result directory is

```text
outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/
  F3_R3_REVERSE_BFS_PILOT_v3/
```

### 4.1 Preparation: `B0` then `R0`

`B0` performs the one authorized cold prerequisite build.  `R0` checks the
typed row constants and builds the exact untrusted generator artifact that
will be invoked by `G01` through `G06`.  Neither phase may generate a reverse
node, payload or first-hit result.

Both phases write append-only receipts containing their exact command,
executor hash, tool hashes, environment, exit status, wall time, object list
and peak sampled process-group RSS.  `R0` also emits the complete loaded
`.olean` trace for the typed-row/generator build and the exact path and hash
of every generator `.olean`, shared object and executable that `G01..G06`
will use.  If the generator is interpreted rather than linked, the exact
interpreter command, generator source/object and loaded `.olean` closure are
the corresponding frozen artifact.

Any source/object mutation after its preparation receipt and before `P0` is
allowed only insofar as `P0` observes it as a different input surface; the
old receipt then cannot establish freshness.  There is no reverse search
before `P0` succeeds.

### 4.2 Pre-generation seal: `P0`

Only after successful `B0` and `R0`, `P0` creates and seals:

```text
pre_generation_manifest.sha256
pre_generation_environment.txt
pre_generation_commands.txt
pre_generation_loaded_objects.txt
pre_generation_status.txt
```

The manifest hashes all inputs required by v2 Section 4.1, plus:

- the `B0` and `R0` raw receipts;
- every source and fresh `.olean` in their complete loaded-object traces;
- the exact generator source, generator `.olean`/shared objects and generator
  executable or interpreter surface;
- the six fixed row definitions and compiled typed-row object;
- the prewritten acceptance and axiom-audit sources against the fixed future
  payload-module name;
- the executor, memory guard and canonical materializer scripts;
- the literal internal expansion of every phase command;
- the exact working directory and a minimal explicit environment, including
  `PATH`, `LEAN_PATH`, `TMPDIR`, locale variables and toolchain variables;
- every executable used by any script, including any helper not present in
  v2's tool table; and
- the clean declared Git base/status snapshot.

The future source names are:

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

Their hashes remain `PENDING_PRE_GENERATION_FREEZE`.  `P0` is invalid while
any pending marker remains.  After `P0`, no hashed source, object, executable,
script, command, environment or prerequisite may change.  Before every later
phase the executor rehashes the complete pre-generation manifest; drift is
`INVALID_INPUT_DRIFT`.

### 4.3 Six untrusted generations and canonical `S0`

Each `G0i` consumes exactly row `i` and emits exactly:

```text
row_0i.raw.stdout
row_0i.raw.stderr
row_0i.exit_status
row_0i.resource_receipt
row_0i.canonical_fragment.lean
```

The generator itself emits the canonical Lean literal fragment; there is no
manual transcription, post-hoc normalization or alternate serializer.  The
fragment contains its immutable row id/order metadata.  A generation phase
may not import or invoke the acceptance theorem or checker.

After `G06`, the explicit `S0` phase invokes only the prehashed materializer.
It verifies that exactly six fragments exist, rejects duplicates or extra
fragments, checks their frozen names/order, and concatenates them without
semantic rewriting into

```text
CollatzClassical/KL2003/
  F3ReturnExcursionBlock0ReverseBFSPilotPayloadsV3.lean
```

`S0` performs no reverse search, acceptance check or Lean compilation.  Its
only allowed data transformation is fixed wrapper/preamble/postamble output
plus byte-for-byte ordered inclusion of the six fragments.  The wrapper and
all materializer bytes are frozen by `P0`.

### 4.4 Post-generation and final seals

After `S0` and before any verifier invocation, `P1` seals
`post_generation_manifest.sha256`.  It hashes the pre-generation manifest,
all six raw outputs and receipts, all six canonical fragments, the S0 raw
receipt, the materialized payload source, exit codes, wall times and sampled
RSS logs.  It states that no verifier or acceptance theorem has run.

Only then may `V0` compile the prewritten acceptance source against the
frozen payload and check all six rows.  `A0` performs the exhaustive public
declaration/cone audit required by v2.  `F0` seals `final_artifacts.sha256`
over both manifests, sources, objects, logs, audit coverage, verdict and run
report.  Neither `P1` nor `F0` can alter an earlier frozen surface.

## 5. Authorized command order

The only authorized top-level phase invocations are the following literal
commands, once each and in this exact order:

```text
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_executor.sh' B0
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_executor.sh' R0
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_executor.sh' P0
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_executor.sh' G01
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_executor.sh' G02
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_executor.sh' G03
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_executor.sh' G04
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_executor.sh' G05
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_executor.sh' G06
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_executor.sh' S0
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_executor.sh' P1
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_executor.sh' V0
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_executor.sh' A0
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_executor.sh' F0
```

The executor and complete internal command expansion must be prewritten
before `B0`, recorded in the `B0`/`R0` receipts, and byte-identical when P0
freezes them.  Direct invocation of an internal command is forbidden.

## 6. Numerical resources and exact memory semantics

V2's wall, heartbeat and recursion ceilings remain unchanged.  `S0` receives
one 600-second attempt, no Lean invocation and no mathematical execution.
The sequence remains serial; there is no retry or post-G01 resource increase.

The memory constants remain:

```text
MEMORY_SAMPLE_PERIOD_SECONDS = 1
MAX_SAMPLED_PROCESS_GROUP_RSS_KIB = 8388608
MAX_SAMPLED_PROCESS_GROUP_RSS_BYTES = 8589934592
MIN_AVAILABLE_MEMORY_BEFORE_PHASE_KIB = 4194304
```

For `B0`, `R0`, each `G0i`, `V0` and `A0`, the executor performs exactly this
policy:

1. Parse `/usr/bin/vm_stat` immediately before launch.  The page size is the
   unique positive integer in its header.  `Pages free`, `Pages inactive` and
   `Pages speculative` must each occur exactly once and parse as nonnegative
   integers.
2. Define, without any other category,

   ```text
   AVAILABLE_KIB = floor(
     (Pages_free + Pages_inactive + Pages_speculative) * page_size_bytes / 1024
   )
   ```

   `AVAILABLE_KIB < 4194304` is `INVALID_MEMORY_POLICY` and the phase is not
   launched.
3. Launch the phase root in a fresh, recorded process group.  The guard runs
   outside that group.  Record root PID and PGID before accepting the first
   sample.
4. Take an immediate sample, then one sample per elapsed second, and a final
   sample before collecting the phase status.  Parse
   `/bin/ps -axo pid=,ppid=,pgid=,rss=`.  Recursively enumerate descendants of
   the recorded root and require every live descendant to remain in the
   recorded PGID.  Sum the `rss` KiB field of every live member of that PGID.
5. A parse/enumeration failure, a descendant outside the group, a missing
   sample, or a sampled sum strictly above `8388608` is
   `INVALID_MEMORY_POLICY`.  On violation the guard immediately sends
   group-directed `SIGKILL` through the frozen `/bin/kill` invocation, waits
   for the root, records the event and forbids continuation.

The 8-GiB value is explicitly a **sampled process-group ceiling**, not a claim
that a sub-second spike is impossible.  The period and all sampling semantics
are immutable after `P0`.  Every binary/helper actually used by the guard
must appear with path and SHA-256 in the pre-generation manifest; an unlisted
helper makes `P0` fail.

## 7. Verdict precedence and mathematical boundary

Verdicts are evaluated in this order:

1. **INVALID first.**  Any v2/v3 INVALID condition anywhere in the run,
   including missing/out-of-order phase, hash drift, rejected checker,
   timeout, memory-policy event, incomplete audit/custody, retry or forbidden
   mechanism, yields `INVALID_R3_REVERSE_BFS_PILOT_V3`.  INVALID dominates and
   suppresses PASS and STOP even if some other row was deficient.
2. **STOP only after a completely valid run.**  If every mandatory phase,
   manifest, checker invocation, exhaustive audit and custody step succeeds,
   and at least one frozen row has a kernel-accepted deficient certificate
   together with the audited completeness theorem

   ```text
   (orderedFirstHitFiber0 p).card < massDemand p
   ```

   then the verdict is `STOP_R3_REVERSE_CAPACITY_COUNTEREXAMPLE_V3`.  No row,
   payload, window or resource may be replaced.
3. **PASS only after a completely valid saturated run.**  If the same validity
   gate succeeds and all six exact typed certificates are checker-accepted
   and saturated, the verdict is `PASS_R3_REVERSE_BFS_PILOT_V3_6_OF_6`.
4. Any fully executed state satisfying neither the STOP nor PASS predicate is
   INVALID, never an informal or mixed verdict.

Generation remains untrusted.  Every literal accepted by V0 must pass

```lean
verifyTypedReverseBFSCertificate selectedOccurrence literalCertificate = true
```

by ordinary kernel reduction, with the exhaustive checker and public theorem
cone coverage of v2 Section 5.  All forbidden mechanisms and the permitted
axiom profile remain unchanged.

## 8. No-claim boundary

V3 does not execute or certify the other 1614 owners.  It does not prove the
452-owner residual gate, same-parent aggregation, full Block0 capacity,
boundary control, depth uniformity, `rho = 9/5`, an exponent, density, or
Collatz.  PASS authorizes preparation, not execution, of a separately frozen
residual-D2 contract.  STOP and INVALID have only the meanings above.
