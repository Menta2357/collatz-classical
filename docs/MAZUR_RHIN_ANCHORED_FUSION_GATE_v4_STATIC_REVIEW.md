# Rhin-anchored H1 cold gate v4 — executor static review

Status: `ADVERSARIAL_STATIC_REVIEW_PASS / PHASES_NOT_EXECUTED / TAG_NOT_CREATED`

Date: 2026-07-25.

## 1. Scope and non-claim

This review supplies the concrete executor, preflight, locking, process-audit
and external pre-run-receipt mechanisms required, but deliberately left
uninstantiated, by
`MAZUR_RHIN_ANCHORED_FUSION_GATE_v4_COLD_CONTRACT.md`.  No Lean, Lake,
Mathlib-cache, phase or executor command was run during this review.  No v4
log, lock, annotated tag or theorem claim was created.

The frozen implementation candidates, including the narrow public-receipt
addendum required by the adversarial review, are:

```text
contract sha256 = 961ee5c327a675e93de2640c3de459956dfd979c36c2fbaa674fa8d3498b2711
contract custody commit = 14705133a2169a8539cbcb39cfe7e2ca9fb4f5fd
addendum path = docs/MAZUR_RHIN_ANCHORED_FUSION_GATE_v4_PUBLIC_RECEIPT_ADDENDUM_v1.md
addendum sha256 = 867ce88268c552d50c09695e26474e284f9c9d8ff7171fdc65b00c879efa0d1f
executor path = artifacts/mazur-rhin-anchored-ca3/scripts/rhin_v4_cold_executor.sh
executor sha256 = 4e91600ea9a97d074ea2f8663c318e626e111fc85f538795f90cd0320f4c0303
preflight path = artifacts/mazur-rhin-anchored-ca3/scripts/rhin_v4_cold_preflight.sh
preflight sha256 = 4de83be339d49f2f0e6f4d1badf1d0f956435fa836a0e3a752826dc44fac0c35
candidate sha256 = a7f3bef1c7184b514c3cc6833da03a3eefd5f41b3bea58bf4062885d7bfab7b1
audit sha256 = 4c75fd87933592842a70a4f861f29fa685c73ea81a62ed359437b8170506f688
manifest sha256 = bc45e15b36f7aede2ceed922babf4bbcacb6789a1ec2d85bd571105fcd73926e
reconstruction commit = b7da87864ced8abd6c3715b65320efc233c0d853
```

The SHA-256 of this review is intentionally not self-recorded here.  It must
be recorded in the external annotated-tag receipt described below.
The contract and addendum digests are additionally hard-coded in both scripts;
the tag cannot legitimize a substituted contract merely by binding its hash.

## 2. Non-self-referential and temporally sound public pre-run receipt

A tracked report cannot contain the SHA of the same Git commit whose tree
contains that report: changing the text changes the commit.  V4 therefore
uses the contract's “separate pre-run report” as the complete message of one
annotated Git tag created only *after* the frozen execution commit `E` exists:

```text
tag name = rhin-v4-prerun-<40-hex E>
tag object type = tag
peeled tag target = E
branch ref = refs/heads/agent/mazur-rhin-anchored-cold-gate-v4
tag ref = refs/tags/rhin-v4-prerun-<40-hex E>
peeled tag ref = refs/tags/rhin-v4-prerun-<40-hex E>^{}
```

The branch and annotated tag must be pushed atomically in one explicit
`git push --atomic` operation before the executor is invoked.  The tag cannot
truthfully claim to have observed that future push.  The binding interpretation
is therefore fixed by
`MAZUR_RHIN_ANCHORED_FUSION_GATE_v4_PUBLIC_RECEIPT_ADDENDUM_v1.md`: the tag
records the prospective obligation `REQUIRED_AT_EXECUTION`, and both the
executor before opening F0 and F0 itself discharge it by requiring:

1. local tag object type exactly `tag`;
2. local peeled target exactly local `HEAD = E`;
3. public branch SHA exactly `E`;
4. public tag object exactly the local tag object; and
5. public peeled tag target exactly `E`.

The tag message is the pre-run report.  Its machine-readable field block must
be delimited by exact `V4_PRE_RUN_FIELDS_BEGIN` and
`V4_PRE_RUN_FIELDS_END` rows, and must contain exactly one nonempty
`KEY=value` row for every field consumed by the scripts:

```text
V4_PRE_RUN_FIELDS_BEGIN
V4_FROZEN_EXECUTION_COMMIT
V4_PRE_RUN_TAG_NAME
V4_PRE_RUN_TAG_TARGET
V4_CONTRACT_CUSTODY_COMMIT
V4_PUBLIC_REF
V4_PUBLIC_HEAD
V4_PUBLIC_TAG_REF
V4_PUBLIC_TAG_PEELED_REF
V4_PUBLIC_BRANCH_RECEIPT=REQUIRED_AT_EXECUTION
V4_PUBLIC_TAG_RECEIPT=REQUIRED_AT_EXECUTION
V4_RECONSTRUCTION_COMMIT
V4_CANDIDATE_SHA256
V4_AUDIT_SHA256
V4_MANIFEST_SHA256
V4_CONTRACT_SHA256
V4_CONTRACT_ADDENDUM_SHA256
V4_EXECUTOR_SHA256
V4_PREFLIGHT_SHA256
V4_STATIC_REVIEW_SHA256
V4_CACHE_DIR
V4_LOCK_PATH
V4_PROCESS_MATCHER_ID=rhin-v4-process-matcher-v3
V4_PRE_RUN_AVAILABLE_KB
V4_PRE_RUN_RECONSTRUCTION_LAKE=ABSENT
V4_PRE_RUN_PHASE_LOGS=ABSENT
V4_PRE_RUN_PROCESS_MATCH_COUNT=0
V4_PRE_RUN_PROCESS_AUDIT=PASS
V4_CONTRACT_CLARIFICATION=ADDENDUM_V1_REQUIRED_AT_EXECUTION_ACCEPTED
F0_INVOCATIONS=0
T0_INVOCATIONS=0
D1a_INVOCATIONS=0
D1b_INVOCATIONS=0
P1_INVOCATIONS=0
A1_INVOCATIONS=0
V4_PRE_RUN_FIELDS_END
```

The complete pre-run process snapshot must appear between literal marker rows
`V4_PRE_RUN_PROCESS_SNAPSHOT_BEGIN` and
`V4_PRE_RUN_PROCESS_SNAPSHOT_END`.  The disk row must parse as an integer at
least `20971520`.  No tag is authorized until the actual disk measurement,
zero-invocation evidence, absent `.lake`, absent phase logs, exact file hashes,
clean tracked worktrees and process snapshot have been collected.

This annotated-tag mechanism plus the hash-bound addendum is a concrete,
temporally satisfiable interpretation of the contract's external-report
requirement, not a weakening of the remote gate.  The tag message cannot be
amended: any correction requires a newly reviewed v5 contract, not tag
replacement.  The clarification field is a hard gate so the executor cannot
silently adopt this interpretation without the public pre-run object saying
so.  The pre-executor query and the independent F0 query are the only places
where `EXACT_MATCH` is asserted as an observed fact.

## 3. Lock and process audit

The exact lock is:

```text
path = /Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/.rhin-v4-executor.lock
acquisition = atomic mkdir
release = never under v4
owner receipt = owner_pid plus execution_head inside the lock directory
```

The executor checks all six phase logs, all six dynamic process-audit logs and
the terminal report for absence before acquiring the lock.  It then retains
the lock after PASS or STOP, making a second launch fail independently of the
phase-log guard.

The exact process matcher has identifier
`rhin-v4-process-matcher-v3`.  It records the complete `ps -axo
pid=,ppid=,comm=` snapshot, excludes only the executor PID and its process
ancestry, and flags actual `comm` executable basenames exactly equal to:

- `lean`, `lake` or `leanc`; or
- `cache`, `Mathlib.Cache` or `mathlib-cache`.

The `lake` identity covers `lake exe cache`; a spawned cache helper is covered
by the cache identities.  Arbitrary command-line arguments are deliberately
not recorded because the Q0–Q5 receipts are destined for public custody and
unrelated processes may carry secrets in `argv`.  This is a privacy hardening,
not an exclusion of any executable family named by the contract.

The audit runs immediately before F0, T0, D1a, D1b, P1 and A1.  Any match is
`CONCURRENT_BUILD_STOP`; there is no wait-and-continue branch.  Each complete
snapshot and match set is preserved in its own Q0–Q5 evidence file.

## 4. Phase and STOP review

Static inspection confirms the literal ordered commands and wall ceilings:

```text
F0  = 120 seconds  = cold/public/environment preflight
T0  = 3600 seconds = lake exe cache get with the dedicated MATHLIB_CACHE_DIR
D1a = 900 seconds  = lake build Erdos1135.ND.FusionParametric
D1b = 2400 seconds = lake build Erdos1135.ND.RhinUnconditional
P1  = 300 seconds  = lake build Erdos1135.ND.FusionRhinAnchored
A1  = 300 seconds  = lake env lean FusionRhinAnchoredAxiomAudit.lean
sum = 7620 seconds
```

Every command runs from the fixed reconstruction root with `LC_ALL=C` and
`LANG=C`.  T0 alone additionally receives the fixed dedicated cache path.  The
executor first removes any ambient `MATHLIB_CACHE_DIR`, so F0 and the build
phases cannot inherit a competing cache override.  The
contract specifies no heartbeat override; the executor therefore introduces
none.  Adding one would change an exact phase command and is forbidden under
v4.

Each phase increments its counter exactly once immediately before invocation.
A literal nonzero exit, timeout, missing required `.olean`/`.ilean`, changed
frozen input, dirty tracked worktree, package-revision mismatch or A1 profile
mismatch writes the terminal report and exits.  No later phase command is
reachable.  An EXIT trap also attempts a terminal
`UNEXPECTED_EXECUTOR_STOP` report for an otherwise unhandled nonzero shell
exit after the persistent lock has been acquired; it neither retries nor
continues a phase.  A1 requires exactly two profile rows and each must equal
exactly `[propext, Classical.choice, Quot.sound]` for the named producer and
consumer.

The generated terminal report inventories every existing phase/process log
with byte count and SHA-256, all invocation counters, both repository heads,
post-run hashes for the contract, addendum, executor, preflight, static review,
both custody inputs, both reconstruction inputs and manifest, plus
tracked-worktree state and artifact presence.  It deliberately says
`TERMINAL_PUBLIC_CUSTODY=PENDING_COMMIT_AND_PUSH`; publication is a required
post-run custody action, not something a build success may claim for itself.

## 5. Static checks and remaining gates

Both scripts pass `bash -n`.  The adversarial diff review found and closed the
otherwise impossible pre-push `EXACT_MATCH` assertion, tightened the delimited
field/snapshot parsing, replaced command-text inference with the privacy-safe
`comm` process identity, and added a post-lock unexpected-exit receipt.  No P0 or P1 remains
in the reviewed implementation.  No Lean phase was invoked.  Before any v4 run,
all of the following still must occur in order:

1. commit the scripts, addendum and this review, then compute this review's
   SHA-256;
2. prepare the final execution commit `E` without changing any frozen byte;
3. collect the pre-run disk/process/absence evidence and prospective public
   obligations;
4. create the exact annotated tag whose complete message is that evidence and
   contains every actual hash;
5. push the exact branch and tag atomically;
6. verify both remote receipts read-only; and
7. invoke the single executor once, only if the 20 GiB gate and every other
   gate pass.

Until those steps are complete:

```text
V4_EXECUTION=NOT_RUN
V4_TAG=NOT_CREATED
V4_LOCK=NOT_CREATED
V4_PHASE_LOGS=ABSENT
V4_THEOREM_STATUS=UNKNOWN_NOT_COMPILED_UNDER_V4
```
