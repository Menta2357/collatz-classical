# F3 R3 execution registry v7

Snapshot: `2026-07-25T16:10:37+0200`.

```text
BRANCH = codex/hilo2-f3-r3-reverse-first-hit-v1
BASE_HEAD = 8765d7083906e7b3e3b03951da6331fcf1427e1b
WORKTREE_STATUS_FOR_QUEUED_FILES = UNTRACKED
GOVERNING_PILOT_CONTRACT = V3_PLUS_V4
PROFILE_EXECUTION = IN_PROGRESS
PROFILE_OLEAN_AT_SNAPSHOT = ABSENT
PILOT_PREREQ_READY = NO
LEAN_EXECUTION_WHILE_PREPARING_THIS_REGISTRY = NONE
```

V7 is a new successor; no earlier registry was edited.  It corrects the last
two calibration defects in v6:

1. historical fresh-object/build evidence is separated from contractual
   `PILOT_PREREQ_READY`, which additionally requires frozen receipts, raw
   logs, hashes and audit coverage; and
2. infrastructure/elaboration/resource STOPs are separated from a
   kernel-certified `MATHEMATICAL_STOP`.

It also spells out the pre-execution authoring gate that must occur before
the fourteen normal phases.

| registry | SHA-256 | status |
|---|---|---|
| v4 | `ce41dbb63c77ddbc166382323caf892e6b5b3441ba3c45904a2f8503caecdc27` | immutable historical snapshot |
| v5 | `dc8068e8fc1be1f037e11fc4b78354ad0eabb729b6392ee995cea19178cf4bf5` | `SUPERSEDED_DRAFT_NOT_EXECUTABLE` |
| v6 | `2e75af1f9a6d95bc406775a96adabe4c18704ff59253dff098393a1378c22a02` | `SUPERSEDED_CALIBRATION_DRAFT_NOT_EXECUTABLE` |
| v7 | this file | canonical snapshot after independent audit |

## 1. Status vocabulary and evidence levels

| label | exact meaning in v7 |
|---|---|
| `SOURCE_ONLY` | source exists, but no corresponding current `.olean` exists |
| `IN_PROGRESS` | one authorized process is live or has no terminal receipt; neither PASS nor failure |
| `HISTORICAL_BUILD_EVIDENCE` | a current local `.olean` or a named earlier report evidences a build; this alone is not pilot readiness |
| `HISTORICAL_AUDIT_EVIDENCE` | a current audit `.olean` or named earlier report evidences an audit; this alone is not pilot readiness |
| `PILOT_PREREQ_READY` | exact source hash, fresh `.olean`, terminal build receipt/raw log, audit receipt/raw log and declared coverage are all present and revalidated for the governing run |
| `PILOT_PREREQ_NOT_READY` | at least one item in the preceding readiness definition is missing or not yet frozen |
| `CONTRACT_FROZEN` | the contract document is hashed; future sources, manifests and execution may still be absent |
| `PENDING_SOURCE_HASHES` | required future source/scripts do not yet exist or are not sealed |
| `NOT_RUN` | no attempt has started under the governing contract |
| `ENGINEERING_STOP` | environment, path, elaboration, timeout, memory, audit or custody failure; no mathematical counterexample follows |
| `NON_MATHEMATICAL_INVALID` | any governing-run INVALID, including input drift or a checker-rejected payload; it has no mathematical sign |
| `MATHEMATICAL_STOP` | a completely valid run yields a kernel-accepted deficient certificate and audited strict capacity shortfall |

`HISTORICAL_*` never implies `PILOT_PREREQ_READY`.  In particular, freshness
of an `.olean` is necessary evidence but does not replace a terminal receipt,
raw log, coverage report, source/object hash freeze and governing-manifest
revalidation.

## 2. Governing contract and honest pending state

| contract | SHA-256 | role |
|---|---|---|
| pilot v1 | `6054894fcadd6898e01f1c4c4ace61b6ec86a257f418610bd369b40ec3164316` | immutable origin, superseded |
| pilot v2 | `0378df70dc1dc0d67460299562a7c12034fa5598378aaed1e8a0887f6e6725cb` | immutable successor, superseded |
| pilot v3 | `620f15497644be361f7a06ef4fa31362f325f94eda37b02de145450712fe30d6` | mathematical/execution base |
| pilot v4 | `9c6954e5985559b7a977064f21bf631199e265674ed5dc326175dfb5cfa8109c` | governing custody amendment |

The combined v3+v4 state is exactly:

```text
CONTRACT_FROZEN
SEVEN_SOURCE_HASHES_PENDING
PILOT_PREREQ_NOT_READY
NO_PILOT_PAYLOAD
PILOT_NOT_RUN
```

V4's receipt chaining, post-generation revalidation, exact RSS schema and C0
branch passed read-only adversarial review.  That GO certifies contract design
only; it does not manufacture any of the seven inputs or any execution PASS.

## 3. Authoring gate, then fourteen execution phases

The complete order has a non-execution preparation prefix:

```text
CREATE_SEVEN_INPUT_SOURCES_AND_SCRIPTS
  -> READ_ONLY_STATIC_AND_ADVERSARIAL_PREAUDIT
  -> RECORD_PROPOSED_SOURCE_COMMAND_AND_TOOL_HASHES
  -> B0
  -> R0
  -> P0
  -> G01 -> G02 -> G03 -> G04 -> G05 -> G06
  -> S0 -> P1 -> V0 -> A0 -> F0
```

The first three entries are authoring/review gates, not extra executable
pilot phases and not substitutes for P0.  Today they are incomplete because
all seven inputs are absent.

The normal executable path still contains exactly fourteen phases:

```text
B0, R0, P0, G01, G02, G03, G04, G05, G06, S0, P1, V0, A0, F0
```

`B0` produces the cold-prerequisite receipts and logs; `R0` builds/checks the
typed rows and exact generator surface; `P0` revalidates those receipts and
seals the pre-generation surface.  Only a successful P0 can turn the complete
prerequisite surface into readiness for generation.

At the first INVALID event, all unstarted normal phases are forbidden and the
only permitted successor is custody-only `C0`.  C0 is one 600-second attempt,
performs no Lean/search/verification/mathematics, and cannot change INVALID
into STOP or PASS.

## 4. Shared mathematical/build queue

The theorem/build dependency order required before the six-row execution is:

```text
ordered-interface/static historical surfaces
  -> MassDemandProfile build + audit 24/24 and decide inventory 2/2
  -> ReverseBFSMassIntegration build
  -> ReverseBFSAxiomAudit 42/42
  -> SemanticChildBaseHit build + audit 3/3
  -> ReverseBFSCompleteness build + audit 4/4
  -> seven-source authoring/preaudit
  -> B0 -> R0 -> P0
  -> six-row generation/verification
```

Current state:

| order | artifact | local/historical evidence | pilot readiness | exact next gate |
|---:|---|---|---|---|
| 0 | ordered-interface and static preconditions | historical build/audit evidence; details in Section 6 | `NOT_READY`: no v3+v4 B0/P0 receipt chain yet | retain hashes; rebuild/revalidate under B0/P0 when seven inputs exist |
| 1 | `MassDemandProfile` | `IN_PROGRESS`; no `.olean` | `NOT_READY` | wait for terminal process receipt |
| 2 | `MassDemandProfileAxiomAudit` | source contract reviewed GO; no `.olean`, log or receipt | `NOT_READY` | execute once only after Profile terminal build success |
| 3 | `ReverseBFSMassIntegration` | `SOURCE_ONLY`; no `.olean` | `NOT_READY` | compile only after Profile audit succeeds |
| 4 | `ReverseBFSAxiomAudit` (`audit42`) | `SOURCE_ONLY`; no `.olean` | `NOT_READY` | compile fail-hard `42/42` only after Integration |
| 5 | `SemanticChildBaseHit` | `SOURCE_ONLY`; no `.olean` | `NOT_READY` | build, then run its `3/3` audit |
| 6 | `ReverseBFSCompleteness` | `SOURCE_ONLY`; no `.olean` | `NOT_READY` | build, then run its `4/4` audit |
| 7 | six-row pilot v3+v4 | contract only; seven inputs absent; no payload | `NOT_READY` | create/preaudit seven inputs, then B0/R0/P0 |

`SameParentDisjoint`, `FirstHitAllocation`, and `DemandOneClosed` are not
prerequisites of the six-row pilot.

## 5. Profile live snapshot and dormant fallback

Profile was rechecked while v7 was written:

```text
SOURCE_SHA256 = abad4d0198cb449035934784e2a7acaf2747bab375b3a64e9003b3266d2d3178
COMMAND = /usr/bin/time -p lake build CollatzClassical.KL2003.F3ReturnExcursionBlock0MassDemandProfile
START = 2026-07-25T15:32:30+0200
OBSERVED_AGAIN = 2026-07-25T16:10:37+0200
PARENT_PID = 99295
LAKE_PID = 99306
LEAN_PID = 99330
ELAPSED_AT_RECHECK = 00:38:02 parent / 00:38:00 Lean
LEAN_RSS_KIB_AT_RECHECK = 543088
TERMINAL_RECEIPT = ABSENT
PROFILE_OLEAN = ABSENT
AUDIT_OLEAN = ABSENT
STATUS = IN_PROGRESS
```

This is a snapshot, not a timeout policy.  A later completion does not
retroactively alter v7; a successor must cite exit code, raw-log hash, object
freshness and audit evidence.

The dormant successor is
`F3_MASS_DEMAND_PROFILE_SHARD_FALLBACK_v1.md`, SHA-256
`67d64fe6099ed17a8cc3ac7142f021ef2090afe90d227650fa742af782acc0a9`.
It activates only after a nonzero resource failure localized to
`shadowDemand_profile_exact` under its full five-part criterion.  A resource
failure is an `ENGINEERING_STOP`, not a `MATHEMATICAL_STOP`.  There is no
monolithic retry or heartbeat increase.

## 6. Historical evidence versus pilot readiness

The table deliberately does not label these rows `PILOT_PREREQ_READY`:

| surface | historical evidence at snapshot | readiness gap |
|---|---|---|
| `ActiveStaticPreconditions` | source `41a536...18d`, fresh `.olean` `d67190...f09`; audit source `4b76a0...e85`, fresh audit `.olean` `d91351...96b` | governing B0/P0 terminal receipts, raw logs and manifest revalidation not yet exist |
| ordered interface including `ActiveChannelIntervals` | joint `55/55` audit object current; audit source `ad0cf8...613`, object `0c59ef...c9b`; intervals source `c112a6...623` | governing B0/P0 receipt/log/hash chain absent |
| `Block0MassAtoms` | source/audit objects current; source-level `11/11` audit evidence | governing B0/P0 receipt/log/hash chain absent |
| active carrier/operator reindex | named historical execution report plus current source/audit objects | must be revalidated and named by the governing B0/P0 manifests |
| `ReverseBFSData`, `ReverseBFSVerifier` | current local build objects | audit42 has not run; governing receipts/logs absent |
| forward-right certificate v5 audit-only | exact historical verdict `PASS_WITH_EXPLICIT_CODEGEN_SPEC_EXCEPTIONS` | its stable declaration evidence must be carried by the governing dependency/receipt surface; no full-namespace clean claim |

Thus:

```text
HISTORICAL_BUILD_EVIDENCE_PRESENT = YES
HISTORICAL_AUDIT_EVIDENCE_PRESENT = YES_FOR_NAMED_ROWS
PILOT_PREREQ_READY = NO
```

The forward-right literal status is never shortened to generic audit PASS or
kernel-clean.

## 7. Seven absent input artifacts

All seven are absent at this snapshot:

```text
CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotRowsV3.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotGenerateV3.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotV3.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotV3AxiomAudit.lean
outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_executor.sh
outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_memory_guard.sh
outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_materialize.sh
```

`F3ReturnExcursionBlock0ReverseBFSPilotPayloadsV3.lean` is also absent, as it
must be: it is an S0 output, not an eighth prewritten input.  No B0, R0, P0 or
generation phase is authorized before the seven inputs are created and pass
the pre-execution source review required in Section 3.

## 8. Separate full-coverage lane

These are source-only future bridges.  Their audit sources passed read-only
design review, not Lean audit execution:

| module | state | role |
|---|---|---|
| `SameParentDisjoint`; its audit | `SOURCE_ONLY / NOT_RUN`; audit-design GO only | same-parent disjointness and root accounting |
| `FirstHitAllocation`; its audit | `SOURCE_ONLY / NOT_RUN`; audit-design GO only | owner-preserving allocation/capacity bridge |
| `DemandOneClosed`; its audit | `SOURCE_ONLY / NOT_RUN`; audit-design GO only | reduction of full capacity to `demandTwoCarrier`; blocked by Profile/SemanticBase/Integration |
| future residual-D2 contract | `DOES_NOT_EXIST / NOT_RUN` | may be prepared only after a valid six-row PASS |

These modules cannot promote a six-row result and do not alter current pilot
readiness.

## 9. Source-hash ledger

```text
abad4d0198cb449035934784e2a7acaf2747bab375b3a64e9003b3266d2d3178  F3ReturnExcursionBlock0MassDemandProfile.lean
c9c337f069ac1d9e892d3edda4688b29cc085972e7382d40fd8486c3169b3ce3  F3ReturnExcursionBlock0MassDemandProfileAxiomAudit.lean
0e2d799f99d1030e622e48333c6fd3d074db87ce0fa526cb2289b64ac93c8093  F3ReturnExcursionBlock0ReverseBFSMassIntegration.lean
b8d8f5f7f8dc246de600885f56c4e65ef966ca944086a89827c5f0e1a4c02f7e  F3ReturnExcursionBlock0ReverseBFSAxiomAudit.lean
014873cbcae6a35eda427aeb5943ef72b7f41eaee69998b8ff455fc294bfcf37  F3ReturnExcursionBlock0SemanticChildBaseHit.lean
bede0aabe2da7d0b99f717133d0fbdbc016e01ff088ad5294070145df581b916  F3ReturnExcursionBlock0SemanticChildBaseHitAxiomAudit.lean
a549f0cd1a6995c91e2f6f3ed33f1c62f2168969c2f09f73e899becc3123188e  F3ReturnExcursionBlock0ReverseBFSCompleteness.lean
51e11e34413122e2225a92a0f7ac2fb1ca263c72571aa83325d0221f65a20767  F3ReturnExcursionBlock0ReverseBFSCompletenessAxiomAudit.lean
552a617db0ed1d8a861ba73607756a2aa5e3a4fb55ae68db8ef1e57be7cea201  F3ReturnExcursionBlock0SameParentDisjoint.lean
05d3848eb342b2225157235ea8521c06b0423b925e052a5a4a6859aef5e5e2e2  F3ReturnExcursionBlock0SameParentDisjointAxiomAudit.lean
6d79c051e2c4cacab9977fb36ea30a646f7c8c036a89706483e55b9a9db3d12c  F3ReturnExcursionBlock0FirstHitAllocation.lean
5f3e9efe4307948afaa077fe6d5302a74eb98bd6861fdc500fa2172f6aee01b8  F3ReturnExcursionBlock0FirstHitAllocationAxiomAudit.lean
b6bbfa327e89a7c8f7a1f5b85384346a04768c64926452559e8cb91cb1f6c41a  F3ReturnExcursionBlock0DemandOneClosed.lean
e53b6e00720ee513982c3d3a1c6d2f06eecf2f010a98daefa824a7a83fb517c8  F3ReturnExcursionBlock0DemandOneClosedAxiomAudit.lean
```

Source drift requires a successor registry or explicit reconciliation before
that artifact executes.

## 10. Failure and STOP classification

Historical codec and forward-right environment/path/elaboration/audit/resource
STOPs are recorded as `ENGINEERING_STOP`.  Their later successful successors
do not erase them, and none is a mathematical counterexample.

For the governing six-row pilot:

```text
INVALID_R3_REVERSE_BFS_PILOT_V3 = NON_MATHEMATICAL_INVALID
STOP_R3_REVERSE_CAPACITY_COUNTEREXAMPLE_V3 = MATHEMATICAL_STOP
PASS_R3_REVERSE_BFS_PILOT_V3_6_OF_6 = SIX_OWNER_PILOT_PASS
```

`MATHEMATICAL_STOP` requires a completely valid 14-phase chain, all manifests
and audits, plus a kernel-accepted deficient certificate proving

```text
(orderedFirstHitFiber0 p).card < massDemand p.
```

INVALID dominates any apparent deficient row.  No current artifact has
status `MATHEMATICAL_STOP`.  A governing INVALID may arise from engineering,
custody, input drift, source mismatch or checker rejection; none is relabeled
as a mathematical failure.

## 11. NO-CLAIMS

```text
PROFILE_IN_PROGRESS_NOT_PASS
NO_PROFILE_BUILD_PASS_AT_THIS_SNAPSHOT
NO_PROFILE_AUDIT_PASS
NO_INTEGRATION_BUILD_PASS
NO_REVERSE_BFS_42_AUDIT_PASS
NO_SEMANTIC_BASE_BUILD_OR_AUDIT_PASS
NO_COMPLETENESS_BUILD_OR_AUDIT_PASS
NO_PILOT_PREREQ_READY
NO_SEVEN_PILOT_INPUT_HASHES
NO_B0_R0_P0_EXECUTION
NO_PILOT_PAYLOAD
NO_R3_SIX_ROW_EXECUTION
NO_R3_SIX_ROW_PASS
NO_MATHEMATICAL_STOP
NO_RESIDUAL_D2_CONTRACT_OR_EXECUTION
NO_FULL_FIRST_HIT_CAPACITY_THEOREM
NO_F3_RHO_THEOREM
NO_F3_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

The strongest current statement is procedural: the ordered-interface/static
surface has historical local build/audit evidence, Profile has one live
attempt, and the governing pilot remains contract-only until seven inputs,
receipt-backed prerequisite builds/audits and P0 are all present.
