# F3 R3 two-commit custody split v5

Date: 2026-07-25.

Status:

```text
CUSTODY_PLAN_SUCCESSOR_ONLY
V4_SUPERSEDED_HOLD_NOT_EXECUTABLE
NO_GIT_INDEX_CHANGE
NO_COMMIT
NO_PUSH
NO_LEAN_EXECUTION
TWO_COMMITS_EXACTLY_A_THEN_D
BATCH_A_HISTORICAL_EVIDENCE_NOT_PILOT_READINESS
BATCH_D_CANONICAL_GOVERNANCE_ONLY
REGISTRY_V9_CANONICAL_AT_THIS_CUT
CONTRACT_V5_GOVERNING_VERDICT_SCOPE
COMMANDS_V5_REQUIRES_INDEPENDENT_AUDIT_AND_EXPLICIT_HASH_AUTHORIZATION
BATCH_B_LEAN_NO_MUTATION_WITHOUT_TERMINAL_REGISTRY_AND_OWN_RUNBOOK
RESIDUAL_ALLOCATION_SOURCE_ONLY_NOT_RUN
LIVE_REMOTE_GATE_IMMEDIATELY_BEFORE_EACH_STAGE_AND_FINAL_PUSH
ATOMIC_ABSENCE_CAS_LEASE_ON_FINAL_PUSH
CLIENT_GIT_HOOKS_NEUTRALIZED
COMMIT_GPG_SIGNING_DISABLED
GIT_REPLACE_OBJECTS_DISABLED
NO_MERGE_REBASE_CHERRY_PICK_OR_SEQUENCER_STATE
EACH_COMMIT_EXACTLY_ONE_PARENT
```

## 1. Succession and closure of the v4 HOLD

This document supersedes `F3_R3_CUSTODY_SPLIT_v4.md`, SHA-256

```text
179cbea3c0da12f1f7c65474d8cd6d94b74fc911fa33cdcc31b70fd86a3c08a2
```

V4 is preserved unchanged as an immutable HOLD artifact and cannot govern
staging or publication.  Its two-commit allowlists and byte/parent gates were
sound, but its final absence check was not atomic with the push and it did not
neutralize client Git hooks.

V5 retains the same two explicit single-parent commits while replacing the
final update with an empty-expected-value lease and disabling client hooks,
commit signing side effects and replacement-object reinterpretation:

```text
frozen base
  -> Commit A: exactly eleven stable Lean source additions
  -> Commit D: exactly four canonical governance document additions
  -> one frozen-SHA public push of Commit D
```

Neither commit contains a Batch B Lean source, `.olean`, result, script,
payload or noncanonical output.

No Lean or Git command was executed while creating Split v5.

## 2. Governing runbook and non-circular self-document freeze

The sole candidate runbook is
`F3_R3_CUSTODY_COMMANDS_v5.md`, SHA-256

```text
0c59afd374ac69aa471008798a6b47d58009324e73bea1ec656a296f0858b36b
```

Commands v5 must receive an independent Bash 3.2/safety audit before use.
Commands v1--v4 are historical and not executable.

Commands v5 and Split v5 are themselves members of Commit D.  An ordinary
file cannot contain and verify its own SHA-256 without a self-reference
cycle.  Therefore the later explicit execution authorization must state and
export the exact SHA-256 of both final files as:

```text
F3_CUSTODY_COMMANDS_V5_SHA256
F3_CUSTODY_SPLIT_V5_SHA256
```

Commands v5 copies those values into readonly session-local variables, checks
their syntax, verifies that Split contains the authorized Commands hash as one
exact line, verifies working files, staged blobs, committed blobs and the
public commit against them, and never derives a replacement after staging.
Any mismatch is a fail-hard STOP.  This external authorization is the
non-circular hash ledger for the two self-custodied documents.

## 3. Coordinates inherited pending live runbook checks

The declared coordinates remain:

```text
WORKTREE = /Users/MoiTam/Documents/New project/coordinated/hilo2-f3
BRANCH = codex/hilo2-f3-r3-reverse-first-hit-v1
FROZEN_BASE = 8765d7083906e7b3e3b03951da6331fcf1427e1b
PUBLIC_BASE_REF = public/codex/hilo2-f3-r3-active-carrier-v1
PUBLIC_DESTINATION_REF = codex/hilo2-f3-r3-reverse-first-hit-v1
PUBLIC_FETCH_AND_PUSH_URL = https://github.com/Menta2357/collatz-classical.git
ORIGIN_FETCH_AND_PUSH_URL = /Users/MoiTam/Documents/Codex/2026-07-21/f3-density-update
```

These are declared inputs, not a new live remote snapshot.  Commands v5 must
require unique exact fetch and push URLs; branch/base and empty index; no
active merge/rebase/cherry-pick/revert/sequencer state; and status-safe live
`ls-remote` proof of the exact public base and absent destination immediately
before each of the two `git add` operations and again immediately before the
final push.  The final update additionally uses an empty expected-value
`--force-with-lease`, so a concurrent creation fails atomically instead of
being fast-forwarded.  Cached refs cannot replace a live check.  Both commits
and the push run with `core.hooksPath=/dev/null`; commit signing is disabled,
and `GIT_NO_REPLACE_OBJECTS=1` fixes actual object semantics.

## 4. Commit A — exact stable-source allowlist

Only these eleven sources may enter Commit A:

```text
CollatzClassical/KL2003/F3ReturnExcursionBlock0ActiveChannelIntervals.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0ReversePredecessor.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0OrderedFirstHit.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0OrderedFirstHitBool.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0R3OrderedInterfaceAxiomAudit.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0ActiveStaticPreconditions.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0ActiveStaticPreconditionsAxiomAudit.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0MassAtoms.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0MassAtomsAxiomAudit.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSData.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSVerifier.lean
```

Their exact source and local `.olean` hashes are the 11+11 ledger embedded in
Commands v5, byte-identical to the independently audited v2/v3 ledger.  The
runbook verifies source/object bytes and freshness before staging; index and
commit modes/statuses/bytes afterward.  `.olean` files are derived local
receipts and never enter a commit.

Commit A must contain exactly eleven additions in mode `100644` and exactly
one parent, the frozen base.  Its calibrated statement is only:

> Eleven stable-prefix sources are custodied with historical local build
> evidence; the ordered interface has joint audit evidence 55/55, Static has
> 2/2, MassAtoms has 11/11, and Data/Verifier remain build-only pending
> audit42.  No governing-run prerequisite is yet ready.

## 5. Commit D — exact canonical-document allowlist

Only these four documents may enter Commit D:

| path | exact SHA-256 source |
|---|---|
| `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_R3_EXECUTION_REGISTRY_v9.md` | fixed `c71d45a85e2f2e307abb026824f2b226ff6e7783f8bbc222a79d303aabaccef5` |
| `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_R3_REVERSE_BFS_PILOT_CONTRACT_v5.md` | fixed `7e2616e2a9d7be82e445cae30b8465cc39cff11bdee08ce45d117cb79c864369` |
| `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_R3_CUSTODY_COMMANDS_v5.md` | exact externally authorized `F3_CUSTODY_COMMANDS_V5_SHA256` |
| `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_R3_CUSTODY_SPLIT_v5.md` | exact externally authorized `F3_CUSTODY_SPLIT_V5_SHA256` |

Registry v9 is the canonical state at this cut.  Contract v5 is the governing
verdict-scope amendment on the v3 mathematics plus v4 custody/state machine.
Commands v5 and Split v5 are the governing publication successors.

No earlier registry/contract/commands/split document is admitted to Commit D.
Historical files remain locally available but are not republished as current
guidance by this split.  Commit D must contain exactly four additions in mode
`100644` and exactly one parent, Commit A.

Document custody does not turn a status claim into a proof.  In particular,
Registry v9 still says Profile `IN_PROGRESS`, pilot prerequisites not ready,
ResidualAllocation source-only, its trust audit not run and `202/443`
unproved.

## 6. Batch B Lean lane — absolute mutation STOP

The Batch B Lean candidates remain outside both commits:

```text
CollatzClassical/KL2003/F3ReturnExcursionBlock0MassDemandProfile.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0MassDemandProfileAxiomAudit.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSMassIntegration.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSAxiomAudit.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0SemanticChildBaseHit.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0SemanticChildBaseHitAxiomAudit.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSCompleteness.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSCompletenessAxiomAudit.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0SameParentDisjoint.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0SameParentDisjointAxiomAudit.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0FirstHitAllocation.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0FirstHitAllocationAxiomAudit.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0DemandOneClosed.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0DemandOneClosedAxiomAudit.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0ResidualCertificateAllocation.lean
CollatzClassical/KL2003/F3ReturnExcursionBlock0ResidualCertificateAllocationAxiomAudit.lean
```

At Registry v9, the final two files have exact hashes
`bd8a6a26ebf80e7e894ab779d0988b04094eacc3f7d45c8f93e4ef2328e0d96e`
and `6ca94e5c2f4d714edd8db2f70276db95a4b7ebff798501e6244fbad07d2d450f`,
but both remain `SOURCE_ONLY / NOT_RUN`; neither `.olean` exists and the
16-root trust audit has not executed.  Their presence proves no concrete
residual family and does not authorize the 452-owner run.

**No Batch B Lean index mutation, commit or push is authorized by Split v5 or
Commands v5.**  Before any Batch B mutation, all of the following must exist:

1. a terminal successor registry reconciled to Profile and every serially
   executed descendant;
2. an exact Batch B source/document allowlist with frozen SHA-256, mode,
   build/audit status and terminal receipts for every admitted entry;
3. a dedicated Batch B runbook that cannot stage A or D by accident and
   repeats URL, live-remote, operation-state and single-parent gates;
4. an independent audit of that exact runbook; and
5. new explicit human execution authorization.

Commands v1--v5 cannot be repurposed for Batch B.

## 7. Claims forbidden

Neither commit, PR nor public summary may claim:

```text
PROFILE_BUILD_OR_AUDIT_PASS
INTEGRATION_BUILD_PASS
REVERSE_BFS_AUDIT42_PASS
SEMANTIC_BASE_BUILD_OR_AUDIT_PASS
COMPLETENESS_BUILD_OR_AUDIT_PASS
RESIDUAL_ALLOCATION_BUILD_OR_AUDIT_PASS
RESIDUAL_ALLOCATION_16_OF_16_TRUST_PASS
PILOT_PREREQ_READY
SEVEN_PILOT_INPUTS_READY
B0_R0_P0_EXECUTION
SIX_ROW_EXECUTION_OR_PASS
SIX_ROW_SATURATION_STOP_RECEIPT
FULL_CAPACITY_SUBROUTE_STOP_RECEIPT
F3_STOP
CONCRETE_RESIDUAL_CERTIFICATE_FAMILY
BOUNDARY_202_OVER_443_THEOREM
RESIDUAL_D2_452_CONTRACT_OR_EXECUTION
ROOTWISE_PISTAR_AGGREGATION
FULL_FIRST_HIT_CAPACITY
RHO_9_OVER_5
F3_EXPONENT_OR_DENSITY
GLOBAL_COLLATZ
```

## 8. Future two-commit publication sequence; not executed here

1. Independently audit Commands v5 against this split, Registry v9, Contract
   v5, all 11+11 receipts, the four-document allowlist and Bash 3.2.
2. Issue explicit authorization that names and exports the final ordinary
   SHA-256 of Commands v5 and Split v5.
3. In one fresh Bash session, run the read-only joint preflight.
4. Run the contiguous live gate and stage exactly Batch A.  Audit exact
   additions, modes and bytes; commit once with parent=frozen base.
5. Revalidate the exact four document bytes, run the second contiguous live
   gate and stage exactly Batch D.  Audit exact additions, modes and bytes;
   commit once with parent=Commit A.
6. Revalidate both one-parent commits and document bytes, run the third
   contiguous live gate, and push only frozen Commit D with client hooks
   disabled and `--force-with-lease=refs/heads/$custody_branch:`.  The empty
   expected value is an absence CAS, not authorization to overwrite a ref.
7. Verify the public SHA, both parent links and both exact commit trees.
8. Stop.  Publication sets no readiness flag and authorizes no Batch B work.

No step in this sequence was executed while writing Split v5.
