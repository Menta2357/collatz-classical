# F3 arithmetic-codec pilot — execution budget v2

Status: `AUTHORIZED_FROZEN_SOURCE_SINGLE_ATTEMPT`

Date: 2026-07-23.

This contract supersedes only the 120-second wall ceiling in the reviewed
pilot design.  It does not change the source architecture, theorem scope,
heartbeats, or acceptance conditions.

## E0 — environment and provenance

```text
E0 = PASS_AND_ALREADY_PAID
ENVIRONMENT = ENV_READY_VERIFIED_FOR_PILOT
minimal import probe = 116.75 s, exit 0
ExactCoreMatrix source sha256 =
  58ab7b1acdb7bc6d69fffa04c4baa7ae29ac31e24e80834387974113b70d2ba5
ExactCoreMatrix olean sha256 =
  34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
isolated rebuild = exit 0, 138.42 s, byte-identical to donor
```

The original 120-second total ceiling left only 3.25 seconds after the
verified minimal import cost.  Raising the total wall ceiling before the
pilot is executed is therefore a pre-execution recalibration, not a resource
increase after a failed elaboration.

## Frozen inputs

```text
pilot source:
CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilot.lean
sha256 = ce072461c6283044a651fd576df5342b0890981b26f776e3023413640d906230

axiom audit source:
CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotAxiomAudit.lean
sha256 = c83c174b8e3ac61043f1054e0179b2e7b0dd936cea0c84b45e245f612ac03cf6
```

No source or audit edit is allowed after this freeze during the execution
gate.

## Pilot compile gate

```text
maxHeartbeats = 200000
total wall ceiling = 300 s
process count = 1
execution = sequential
attempts = 1
route = direct Lean 4.21, F3 worktree root, verified LEAN_PATH
output = F3 worktree only
```

Any timeout or error is `STOP_AND_RECORD`.  There is no edit, retry, dynamic
resource increase, search, table, generated catalogue, or donor/master
modification.

## Axiom-audit gate

The audit opens if and only if the pilot compile exits zero.

```text
total wall ceiling = 300 s
process count = 1
attempts = 1
acceptance = no Lean.ofReduceBool and no sorryAx in every printed public theorem
```

An audit timeout, nonzero exit, `Lean.ofReduceBool`, or `sorryAx` is
`STOP_AND_RECORD` with no retry.

## Terminal scope

Even a full PASS returns to review with logs, timings, hashes, and exact axiom
sets.  It does not authorize the 243-state/729-edge extension.

```text
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
```

