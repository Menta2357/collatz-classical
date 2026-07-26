# F3 R3 reverse-BFS six-row pilot contract v2

Date: 2026-07-25.

Status:

```text
CONTRACT_SUCCESSOR_PREDECLARED_BEFORE_REVERSE_SEARCH
V1_SELECTION_AND_SIX_ROWS_UNCHANGED
PRE_GENERATION_AND_POST_GENERATION_FREEZES_SEPARATED
REGISTRY_V4_PREREQUISITES_RECONCILED
NUMERIC_MEMORY_POLICY_PREDECLARED
EXECUTOR_AND_TOOLCHAIN_FREEZE_REQUIRED
SOURCE_HASH_FREEZE_PENDING
NO_ORBIT_EXECUTION_FOR_THIS_CONTRACT
NO_LEAN_EXECUTION_FOR_THIS_CONTRACT
NO_REVERSE_BFS_RESULT_OBSERVED
NO_R3_FINITE_PASS
NO_F3_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## 1. Succession and exact scope

This document is a governance successor to
`F3_R3_REVERSE_BFS_PILOT_CONTRACT_v1.md`, whose frozen SHA-256 is

```text
6054894fcadd6898e01f1c4c4ace61b6ec86a257f418610bd369b40ec3164316
```

V2 preserves v1's selection rule, six rows, order, mathematical checker,
resource times, PASS/STOP/INVALID meanings and no-claim boundary.  It
supersedes v1 only in three places:

1. generated payloads are frozen after generation, not circularly required
   in the pre-generation input manifest;
2. the six-row pilot is distinguished from a later residual-D2 expansion and
   its actual prerequisites are reconciled with Execution Registry v4;
3. the executor, literal commands, toolchain and a numerical memory policy
   are part of the mandatory pre-generation freeze.

The audited Registry v4 source has SHA-256

```text
ce41dbb63c77ddbc166382323caf892e6b5b3441ba3c45904a2f8503caecdc27
```

Registry v4 remains a historical snapshot.  V2 narrowly supersedes its
serial queue only where Section 3 below inserts the six-row pilot before
unrelated downstream bridge modules.  V2 does not rewrite any prior PASS,
STOP or source hash.

## 2. Six rows, unchanged from v1

The semantic key remains

```text
(rootIndex, rootValue, FormulaEdge constructor, formulaSource.val, ell.val?)
```

and every key must be reconstructed and proved inside Lean.  For each
constructor, the D2 row maximizes exact `qHi`; the D1 control maximizes exact
`qHi <= 1`; ties use the lexicographically least
`(rootIndex, formulaSource.val, ellKey)`, with retarded `ellKey = -1`.

The order is immutable:

| order | row id | constructor | demand | root index | parent `a` | source | `ell` | formula target | exact `qHi` | semantic child | child window |
|---:|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | `RET_D2_MAX` | `retarded` | 2 | 24 | 77 | 75 | - | 65 | `875/837` | 308 | 19712 |
| 2 | `RET_D1_CONTROL` | `retarded` | 1 | 11 | 38 | 37 | - | 152 | `10300/11907` | 152 | 9728 |
| 3 | `DIRECT_D2_MAX` | `advancedDirect` | 2 | 52 | 161 | 159 | 0 | 105 | `580743/404000` | 107 | 41088 |
| 4 | `DIRECT_D1_CONTROL` | `advancedDirect` | 1 | 76 | 233 | 231 | 0 | 153 | `2983/3000` | 155 | 59520 |
| 5 | `LIFT_D2_MAX` | `advancedParityLift` | 2 | 44 | 137 | 135 | 0 | 181 | `8007/6100` | 182 | 34944 |
| 6 | `LIFT_D1_CONTROL` | `advancedParityLift` | 1 | 224 | 677 | 189 | 2 | 172 | `157/162` | 902 | 173184 |

The background profile remains `1168` D1 owners, `452` D2 owners and `2072`
total atoms.  No first-hit datum was used to select the six rows.

## 3. Reconciled prerequisite graph

The six-row pilot and the later residual-D2 expansion are different gates.
Registry v4 merged them in one row.  V2 separates them:

```text
ordered/predecessor/static prerequisites already audited
  -> MassDemandProfile build + audit
  -> ReverseBFSMassIntegration build
  -> ReverseBFSAxiomAudit 42/42
  -> SemanticChildBaseHit build + audit 3/3
  -> ReverseBFSCompleteness build + audit 4/4
  -> SIX-ROW PILOT V2
  -> only after six-row PASS: new residual-D2 contract
```

`SameParentDisjoint`, `FirstHitAllocation`, and `DemandOneClosed` remain
valuable queued modules.  They are not imported by the six-row generator or
checker and therefore are not hard prerequisites for this pilot.  They must
not delay or silently enlarge the six-row experiment.  `DemandOneClosed` is
a prerequisite for reducing a future full ownerwise gate to the residual D2
carrier; `SameParentDisjoint` and `FirstHitAllocation` are downstream bridges
for using full capacity.  None may be used to promote a six-row PASS.

At v2 preparation time, the following evidence existed and must be rechecked
by hash before execution:

| layer | required state before generation |
|---|---|
| `ActiveChannelIntervals`, `OrderedFirstHit`, `OrderedFirstHitBool`, `ReversePredecessor` | build PASS and joint ordered-interface audit PASS, 55 explicit roots |
| `ActiveStaticPreconditions` | build PASS and audit PASS, 2/2 |
| `MassAtoms` | build PASS and audit PASS, 11/11 |
| `ReverseBFSData`, `ReverseBFSVerifier` | build PASS; included in later audit42 |
| `MassDemandProfile` | build PASS and audit PASS, 24/24 plus ordinary-`decide` subinventory 2/2 |
| `ReverseBFSMassIntegration` | build PASS |
| `ReverseBFSAxiomAudit` | audit PASS, 42/42 across Data, Verifier and Integration |
| `SemanticChildBaseHit` | build PASS and audit PASS, 3/3 |
| `ReverseBFSCompleteness` | build PASS and audit PASS, 4/4 |

No `IN_PROGRESS`, source-only file, `.ilean` alone, stale `.olean`, or absent
audit log satisfies this table.  A live build is not a PASS until its exit,
object freshness and audit receipt are recorded.

## 4. Non-circular two-manifest freeze

The result directory is fixed as

```text
outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/
  F3_R3_REVERSE_BFS_PILOT_v2/
```

### 4.1 Pre-generation manifest

Before any reverse node is generated, create and publish

```text
pre_generation_manifest.sha256
pre_generation_environment.txt
pre_generation_commands.txt
pre_generation_status.txt
```

The pre-generation manifest must hash:

- this finalized v2 contract and immutable v1;
- the exact registry reconciliation note;
- every prerequisite source and audit source named in Section 3;
- every prerequisite `.olean` actually loaded, with source-newer checks;
- the new typed row module and the untrusted generator harness;
- the acceptance-theorem and exhaustive-audit sources, written against the
  fixed future payload-module name but not yet compilable;
- the executor and memory-monitor scripts;
- `lean-toolchain`, `lake-manifest.json`, `lakefile.lean`;
- the exact Lean, Lake, timeout, shell, timing, hashing and memory-monitor
  binaries listed in Section 6;
- the literal command file and the clean declared Git base/status snapshot.

The following future sources must exist before this manifest is sealed:

```text
CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotRowsV2.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotGenerateV2.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotV2.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotV2AxiomAudit.lean
outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/
  f3_r3_reverse_bfs_pilot_v2_executor.sh
outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/
  f3_r3_reverse_bfs_pilot_v2_memory_guard.sh
```

Their hashes are `PENDING_PRE_GENERATION_FREEZE`.  Generation is forbidden
while any pending marker remains.  The manifest does not and cannot include
a generated payload, payload source, verification log or audit result.

### 4.2 Post-generation manifest

After all six untrusted generations finish, but before any acceptance theorem
is compiled, serialize the payloads once into

```text
CollatzClassical/KL2003/
  F3ReturnExcursionBlock0ReverseBFSPilotPayloadsV2.lean
```

Then create and publish `post_generation_manifest.sha256`, which hashes:

- `pre_generation_manifest.sha256` itself;
- all six raw generator stdout/stderr logs;
- the six literal certificates and their row-id/order metadata;
- `F3ReturnExcursionBlock0ReverseBFSPilotPayloadsV2.lean`;
- observed generator exit codes, wall times and peak process-tree RSS;
- a statement that no verifier or acceptance theorem has yet run.

The acceptance and audit sources were already frozen in the pre-generation
manifest.  Only after the post-generation manifest is immutable may they be
compiled against the frozen literal data:

```text
CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotV2.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotV2AxiomAudit.lean
```

The payload source cannot appear in the pre-generation manifest, and the
pre-generation inputs cannot be changed while preparing the post-generation
manifest.  This removes v1's circular freeze.

### 4.3 Final custody manifest

After verification and audit, `final_artifacts.sha256` records both manifests,
the verification/audit sources and objects, raw logs, checker coverage,
verdict and run report.  This third manifest is custody evidence; it does not
retroactively alter either frozen input surface.

## 5. Generator/checker and coverage boundary

Generation is untrusted.  Every accepted literal must pass exactly

```lean
verifyTypedReverseBFSCertificate selectedOccurrence literalCertificate = true
```

with ordinary kernel reduction.  The checker must cover, for every row:

1. typed demand and `massDemand_eq_shadow`;
2. claimed demand, positivity and nonempty nodes;
3. duplicate freedom;
4. complete structural checking of every enumerated node;
5. `firstHitViaChildAtBool` for every retained node and its Prop equivalence;
6. exact saturated length and empty closure rows; or
7. exact deficient closure rows and complete `preimagesWithin` equality;
8. saturated capacity soundness; and
9. deficient fibre-cardinality completeness.

The final audit enumerates all public declarations in Rows, Payloads, Pilot
and PilotAudit as applicable, sweeps every new namespace and fails outside

```text
propext, Classical.choice, Quot.sound
```

`native_decide`, `ofReduceBool`, `trustCompiler`, `sorryAx`, `axiom`,
`admit`, and `sorry` are forbidden from every public theorem cone.

## 6. Frozen toolchain and command surface

The following current tool identities are predeclared.  The pre-generation
manifest must rehash them byte-for-byte; drift is `INVALID_TOOL_DRIFT`.

| item | exact path | SHA-256 |
|---|---|---|
| toolchain pin | `lean-toolchain` | `d24fed434d3b13adfaab57724a0a7f270ea8bf1c818b5ae5cf25cbce24dd685c` |
| dependency manifest | `lake-manifest.json` | `230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b` |
| Lake project file | `lakefile.lean` | `e31ac41ac108fbd7e30db1bc982a065949d359146e110ee04212378645e54fca` |
| Lean binary | `/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean` | `c89073b8a577a5914ead7b740d2ad996af1ad5ad5b4bfc2825e0bce2f01b6aa4` |
| Lake binary | `/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lake` | `710879e84b005fa4a713f8f9a24f91fd36d1ffcdf5a10f5936e3be899a47ebcd` |
| timeout binary | `/opt/homebrew/Cellar/coreutils/9.7/bin/gtimeout` | `1ce578c938781a82c5bf7fd3fb2a1b9515f4f2486eb3c6511d0b2b4ec822bb1e` |
| shell | `/bin/bash` | `bf7d6ba0760621e651ae0eeaab0050c0810743a610f55335f3361892228150f9` |
| timing tool | `/usr/bin/time` | `deff9c9f23737474e7fe9a804043f5f5456b5864bb09273db8029165a5647073` |
| hash tool | `/usr/bin/shasum` | `835762dc5388a591ecf31540eaeb14ec8bc96ad48a3bd11fdef77b7106111eec` |
| process sampler | `/bin/ps` | `850793ab4f92e7e324db6b9e2d672d2b79dc2ace7b3c4f439b6db2999007408e` |
| sampler arithmetic | `/usr/bin/awk` | `734ff6a8999ae7b00e6cd0e5197fda09b21409a285d928c3265bdf6bcd4c501a` |
| monitor termination | `/bin/kill` | `dffb6fe5a83ae1345a4f85d791fac98a4651751937c1ed0274d2e24ae9f319e8` |
| free-memory sampler | `/usr/bin/vm_stat` | `0433d67aab98b8b7cd936bcd7783927957d3e89d2b9df6e8245e091a28fa7327` |

The only authorized phase invocations are the following literal commands,
once each and in order, with `G01` through `G06` using Section 2's row order:

```text
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v2_executor.sh' P0
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v2_executor.sh' B0
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v2_executor.sh' R0
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v2_executor.sh' G01
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v2_executor.sh' G02
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v2_executor.sh' G03
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v2_executor.sh' G04
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v2_executor.sh' G05
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v2_executor.sh' G06
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v2_executor.sh' P1
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v2_executor.sh' V0
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v2_executor.sh' A0
/bin/bash '/Users/MoiTam/Documents/New project/coordinated/hilo2-f3/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v2_executor.sh' F0
```

`P0` verifies the pre-generation freeze; `B0` builds cold prerequisites;
`R0` checks row constants; `G01..G06` generate untrusted payloads; `P1`
seals the post-generation manifest; `V0` verifies all six; `A0` runs the
audit; and `F0` emits custody.  Direct invocation of an internal command is
forbidden.  The executor and its complete internal command expansion must be
hashed and published before P0; their current state is
`PENDING_PRE_GENERATION_FREEZE`.

## 7. Numerical resource and memory policy

The v1 wall/heartbeat limits are unchanged:

| phase | wall ceiling | Lean options | attempts |
|---|---:|---|---:|
| `P0` static/hash/tool preflight | 600 s | no reverse generation | 1 |
| `B0` cold dependency build | 3600 s | no pilot payload | 1 |
| `R0` typed row build | 600 s | `maxHeartbeats 20000000`, `maxRecDepth 100000` | 1 |
| each `G01..G06` | 300 s | serial; 1800 s aggregate | 1 |
| `P1` post-generation freeze | 600 s | no verifier invocation | 1 |
| `V0` six-row kernel verification | 3600 s | `maxHeartbeats 20000000`, `maxRecDepth 100000` | 1 |
| `A0` exhaustive axiom audit | 3600 s | same heartbeat/depth ceilings | 1 |
| `F0` final custody | 600 s | no mathematical execution | 1 |

The memory policy is numerical and applies to `B0`, `R0`, every generation,
`V0`, and `A0`:

```text
MEMORY_SAMPLE_PERIOD_SECONDS = 1
MAX_PROCESS_TREE_RSS_KIB = 8388608
MAX_PROCESS_TREE_RSS_BYTES = 8589934592
MIN_FREE_MEMORY_BEFORE_PHASE_KIB = 4194304
```

The frozen memory guard sums RSS over the complete executor process tree once
per second, records every sample and the peak, and terminates the phase at the
first sample strictly above `8388608 KiB`.  Failure to enumerate the process
tree, a missing sample log, or free memory below `4194304 KiB` at phase start
is `INVALID_MEMORY_POLICY`; it is not permission to continue unmonitored.

All phases are serial.  After G01 starts, no time, heartbeat, recursion,
memory, fuel, demand, window, sample, row, command or tool limit may increase.
A timeout or memory stop is INVALID and receives no same-contract retry.

## 8. Verdicts

### `PASS_R3_REVERSE_BFS_PILOT_V2_6_OF_6`

PASS requires both manifests valid, six row identities exact, six typed
checks true, all six certificates saturated, exhaustive audit PASS, and all
command/resource/memory rules satisfied.  It proves capacity for six owners
only and authorizes preparation—not execution—of a new residual-D2 contract.

### `STOP_R3_REVERSE_CAPACITY_COUNTEREXAMPLE_V2`

STOP requires a kernel-accepted deficient certificate for a frozen row plus
the audited completeness theorem

```text
(orderedFirstHitFiber0 p).card < massDemand p.
```

No row, payload or window may be replaced after this result.

### `INVALID_R3_REVERSE_BFS_PILOT_V2`

INVALID covers any hash/tool/command drift, unmet prerequisite, failed row
identity, rejected payload, missing coverage, build/audit error, timeout,
memory-policy event, missing log, out-of-order invocation, direct internal
command, retry or forbidden mechanism.  INVALID has no mathematical sign.

## 9. No-claim boundary

V2 does not execute or certify the other 1614 owners.  It does not prove the
452-owner residual gate, same-parent aggregation, full Block0 capacity,
boundary control, depth uniformity, `rho = 9/5`, an exponent, density, or
Collatz.  Those claims remain outside this contract in PASS, STOP and INVALID
branches alike.
