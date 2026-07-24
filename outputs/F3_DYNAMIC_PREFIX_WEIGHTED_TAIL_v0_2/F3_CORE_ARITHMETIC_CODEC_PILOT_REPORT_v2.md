# F3_CORE_ARITHMETIC_CODEC_PILOT_REPORT_v2

Status: `STOP_AND_RECORD — PILOT_COMPILE_EXIT_1 — AXIOM_AUDIT_NOT_OPENED`

Date: 2026-07-23.

This report preserves v1 as the historical `STOP_BEFORE_ELABORATION` record
and records the one fresh elaboration attempt authorized under the
recalibrated v2 budget.

## Verdict

The environment gate passed independently and the direct Lean route loaded
the frozen `ExactCoreMatrix` dependency.  The single authorized pilot
compilation then exited 1 after 152.87 seconds with Lean elaboration errors.
It did not time out or exhaust the 200000-heartbeat contract, and produced
neither `.olean` nor `.ilean`.

The contract therefore requires `STOP_AND_RECORD`.  The source and axiom
audit remain byte-for-byte frozen, there was no retry or resource increase,
the conditional axiom audit was not run, and the 243-state/729-edge extension
was not opened.

```text
E0_ENVIRONMENT = PASS
STATIC_SOURCE_CONTRACT = PASS
AUTHORIZED_COMPILE_ATTEMPTS = 1
PILOT_COMPILE = FAIL_EXIT_1
REAL_SECONDS = 152.87
TIMEOUT = false
HEARTBEAT_EXHAUSTION = false
OLEAN_PRODUCED = false
ILEAN_PRODUCED = false
AXIOM_AUDIT = NOT_RUN_BY_CONTRACT
FINAL_VERDICT = STOP_AND_RECORD
```

## Frozen inputs

```text
pilot source sha256:
ce072461c6283044a651fd576df5342b0890981b26f776e3023413640d906230

axiom-audit source sha256:
c83c174b8e3ac61043f1054e0179b2e7b0dd936cea0c84b45e245f612ac03cf6

budget v2 sha256:
9f9bce6e8ed3a227a21e4f1890f54e78c8c670ba7b2e045adefac9abeb0d4b04

ExactCoreMatrix source sha256:
58ab7b1acdb7bc6d69fffa04c4baa7ae29ac31e24e80834387974113b70d2ba5

ExactCoreMatrix olean sha256:
34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
```

Re-hashing after the attempt confirmed that both frozen Lean inputs retain
the declared hashes.  No local pilot `.olean` or `.ilean` exists.

## Environment gate

The environment status before spending the attempt was
`ENV_READY_VERIFIED_FOR_PILOT`:

- Lean 4.21.0 and Mathlib commit
  `308445d7985027f538e281e18df29ca16ede2ba3`;
- isolated rebuild of `ExactCoreMatrix`: exit 0 in 138.42 seconds;
- rebuilt object byte-identical to the donor object;
- minimal import probe: exit 0 in 116.75 seconds;
- direct Lean invocation with the F3 worktree as root and verified dependency
  paths;
- no modification of `master` or the donor build.

The former root mismatch and contention-era dependency timeout remain in the
historical record, but neither occurred in this authorized elaboration.

## Elaboration diagnostics

The failures are proof-engineering obligations in the pilot source, not a
single mathematical refutation.  The terminal diagnostics fall into these
classes:

1. arithmetic closure failures in the codec witness and finite branch proofs
   (`omega` at lines 48, 132-134, 787, 793, 938-961, 1013-1038, and
   1120-1129);
2. a missing `Fintype CoreCode` instance at `coreCode_card`, lines 119-123;
3. simplifier recursion-depth failures in the formula rank/unrank and list
   length obligations, lines 689, 696, and 718;
4. tactic sequencing reaching `no goals to be solved`, lines 224 and 230;
5. a dependent rewrite failure at `pilot_frozen_at_formula`, line 1079,
   because the `Fin` index type contains `pilotFrozen.length`;
6. a fold commutativity proof whose final `dsimp` branch made no progress,
   lines 1140-1145.

These diagnostics provide a bounded repair map for a future, newly budgeted
gate.  They do not authorize edits or a retry under this contract.

The command was not initially piped to a persistent raw-stderr file.  The v2
compile log is therefore an explicit structured transcription of the returned
terminal diagnostics, not a byte-identical raw compiler transcript.  This is
a custody limitation of the attempt and must be corrected in any future gate
by predeclaring output capture before execution.

## Axiom status

The audit was predeclared to run if and only if the pilot compilation exited
zero.  Because compilation exited 1, it was not executed.  Consequently the
public theorem axiom sets, `Lean.ofReduceBool` status, and `sorryAx` status for
this uncompiled pilot are all `UNKNOWN_NOT_AUDITED`, not PASS.

Historical provenance remains separate: importing a module that exposes
native-decide declarations is not itself a dependency on those proof terms.
Only a future successful compile followed by `#print axioms` can establish
the intended public-theorem boundary for this pilot.

## Scope and next gate

The architecture remains a reviewed design with a failed first Lean
elaboration.  Any repair requires a new paper-first change list, fresh source
and audit hashes, and a separately authorized budget.  No repair, retry, or
full extension is licensed by this report.

```text
NO_LEAN_PASS
NO_AXIOM_AUDIT_PASS
NO_243_STATE_EXTENSION
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
```
