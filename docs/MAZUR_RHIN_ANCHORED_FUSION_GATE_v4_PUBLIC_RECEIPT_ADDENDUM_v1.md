# Rhin-anchored H1 cold gate v4 — public-receipt addendum

Status: `PRE-EXECUTION CLARIFICATION / NO AUTHORIZATION / NOT_RUN`

Date: 2026-07-25.

## 1. Exact defect corrected

The cold-gate contract requires the pre-run report to record an exact public
branch receipt before the frozen execution commit is pushed.  The static
implementation additionally proposed placing that report in an annotated tag
and atomically pushing the branch and tag.  A tag message fixed before that
push cannot truthfully report the result of the future push.  Consequently,
the values

```text
V4_PUBLIC_BRANCH_RECEIPT=EXACT_MATCH
V4_PUBLIC_TAG_RECEIPT=EXACT_MATCH
```

are temporally impossible as pre-push observations and are forbidden in the
v4 pre-run tag.

## 2. Binding interpretation

This addendum narrowly clarifies the timing of the public receipt; it changes
no mathematical input, phase, command, budget, STOP rule, lock, process audit,
one-attempt rule or PASS meaning.  Where Sections 1 and 3 of
`MAZUR_RHIN_ANCHORED_FUSION_GATE_v4_COLD_CONTRACT.md` require the pre-run
report to contain an already-observed exact public receipt before the push,
the following executable ordering supersedes that impossible temporal order:

1. Freeze execution commit `E`, including the contract, this addendum, the
   executor, the preflight and the static review.
2. Create the annotated pre-run tag whose name and peeled target are bound to
   `E`.  Its message must contain exactly:

   ```text
   V4_PUBLIC_BRANCH_RECEIPT=REQUIRED_AT_EXECUTION
   V4_PUBLIC_TAG_RECEIPT=REQUIRED_AT_EXECUTION
   V4_CONTRACT_CLARIFICATION=ADDENDUM_V1_REQUIRED_AT_EXECUTION_ACCEPTED
   ```

3. Push the exact branch and annotated tag atomically.
4. Before creating any v4 log or lock, the single executor must query the
   public remote and independently require both the public branch SHA and the
   public annotated-tag object/peeled target to match the local objects exactly.
5. Immediately before T0, F0 must repeat those public queries and exact-match
   checks.  Only these observed query results may be reported as public
   `EXACT_MATCH` evidence.

Thus `REQUIRED_AT_EXECUTION` is a prospective obligation recorded by the
immutable pre-run object, not a claim that the push has already happened.
The executor and F0 discharge the obligation by observation.  A missing ref,
query failure, malformed or extra row, object mismatch, or peeled-target
mismatch remains STOP exactly as in the original contract.

## 3. Hash and custody gate

The annotated tag must bind this exact file through one nonempty 64-lowercase-
hex field inside the delimited pre-run block:

```text
V4_CONTRACT_ADDENDUM_SHA256=<sha256 of this file>
```

Both the pre-executor gate and F0 must recompute and verify that binding.  The
addendum is therefore part of the frozen execution bytes and may not be edited
after `E` or omitted from the public tag.  This document does not itself grant
permission to create the tag, run the executor, create a lock, or invoke any
Lean/Lake phase.
