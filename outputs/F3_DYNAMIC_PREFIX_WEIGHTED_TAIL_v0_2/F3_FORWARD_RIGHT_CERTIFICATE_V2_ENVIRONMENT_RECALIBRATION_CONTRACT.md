# F3 forward right certificate v2 — environment recalibration contract

Status: `PRE_RUN_FROZEN — ENVIRONMENT_REHYDRATION_AND_ONE_NEW_EXECUTION_AUTHORIZED`

Date: 2026-07-24.

Branch: `codex/hilo2-f3-forward-right-certificate-v2`.

## 1. Why v2 is legitimate

The v1 attempt is terminally custodied at:

```text
v1 STOP commit             e87085259b547291f9121317c369f2ec42f512ed
v1 terminal-report sha256  6471c5f137f6bb7fc899844eb98782af9ac7b1e367dc8da46e1fc61784139cbf
```

V1 stopped after 2.37 seconds because `.lake/packages` was empty and Lake's
dependency clone exited before Lean elaborated the certificate.  Thus no
theorem, tactic, finite row, or kernel reduction was observed.  V2 does not
expand resources in response to a mathematical failure.  It separates
environment provisioning from the theorem clock and enlarges the wall-clock
budgets before the first Lean elaboration of this module.

## 2. Byte-frozen mathematical state

V2 changes no theorem, proof, vector, coefficient, imported mathematical
input, audit declaration, heartbeat limit, or recursion-depth limit:

```text
certificate source sha256  37932fd8198e045c436c479455a362afb9b2ef720b2138c1f3308f552e16a4ab
total audit sha256          fd9d431d4ce5657204e1b9fa98b8cfd2e8214454fee96bf4b042e0a8629432f2
lake-manifest sha256        230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b
lakefile sha256             e31ac41ac108fbd7e30db1bc982a065949d359146e110ee04212378645e54fca
lean-toolchain sha256       d24fed434d3b13adfaab57724a0a7f270ea8bf1c818b5ae5cf25cbce24dd685c
maxHeartbeats               2000000
maxRecDepth                 100000
```

The five frozen mathematical-input hashes, vector hashes, controls,
orientation and scope are inherited unchanged from v1.  In particular, v2
authorizes no `Block0`, first-hit, boundary, exponent, density or Collatz
claim.

## 3. E0 — dependency rehydration

Run once, outside the C0 theorem clock:

```text
timeout --signal=TERM 3600s /usr/bin/time -p lake exe cache get
```

This phase may populate only ignored build/package state.  It may not run
`lake update`, alter the manifest/toolchain/sources, copy `.lake` from another
worktree, or compile either new v2 module.  A nonzero exit or timeout is:

```text
F3_FORWARD_RIGHT_CERTIFICATE_V2_E0_ENVIRONMENT_STOP
```

## 4. P0 — direct-import prepayment

Only after E0 PASS, run once outside the C0 theorem clock:

```text
timeout --signal=TERM 3600s /usr/bin/time -p lake build \
  CollatzClassical.KL2003.F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity \
  CollatzClassical.KL2003.F3ReturnExcursionExactCoreMatrixChannelBounds \
  CollatzClassical.KL2003.F3ReturnExcursionRealOperatorBridge
```

P0 may compile those imports and their dependency cones, but not the new
certificate or audit.  A scope breach, nonzero exit or timeout is STOP.

## 5. G0 — public environment gate

C0 is forbidden until a report is committed and publicly pushed proving:

- all hashes in sections 1–2 and all inherited frozen hashes still match;
- every package checkout is at the revision in `lake-manifest.json`;
- the three P0 module `.olean` files exist;
- neither v2 module has a pre-existing `.olean` or `.ilean`;
- E0 and P0 commands, elapsed times and exit codes are recorded;
- no tracked file changed and no `Block0` artifact was read or generated.

Any failure is `F3_FORWARD_RIGHT_CERTIFICATE_V2_G0_STOP`.

## 6. C0 — the certificate

Only after public G0 PASS, run exactly once:

```text
timeout --signal=TERM 1800s /usr/bin/time -p lake env lean \
  CollatzClassical/KL2003/F3ReturnExcursionForwardFormulaRightCertificate.lean
```

This doubles v1's wall ceiling while retaining the already generous audited
heartbeat setting.  Dependency acquisition during C0 is an environment-gate
breach.  Timeout, elaboration error or tactic error yields STOP without
patching or retry.  `COUNTEREXAMPLE_STOP` is reserved for a concrete failing
Nat row.

## 7. A1 and K1

Only after C0 PASS, run A1 exactly once:

```text
timeout --signal=TERM 1200s /usr/bin/time -p lake env lean \
  CollatzClassical/KL2003/F3ReturnExcursionForwardFormulaRightCertificateAxiomAudit.lean
```

K1 then has one 120-second static/log audit.  PASS requires:

- all 21 stable declarations explicitly audited;
- namespace `AXIOM_PROFILE` coverage matching the environmental declaration
  count;
- every profile contained in `[propext, Classical.choice, Quot.sound]`;
- no `native_decide`, `Lean.ofReduceBool`, `sorryAx`, `sorry`, or `admit` in
  the new source or public theorem cones;
- final frozen hashes unchanged.

## 8. Governance and scope

There is one attempt per E0, P0, C0, A1 and K1.  Every STOP or PASS is
custodied and pushed.  No failed phase may be retried under v2, and no
warming produced by it may be relabelled as a new attempt.  Any source,
audit, heartbeat, depth, manifest or toolchain modification invalidates v2.

A terminal PASS establishes only the forward R1 row-growth certificate and
its generic weighted-mass step.  It does not prove the semantic
operator-to-fibres bridge or the F3 exponent.

```text
NO_BLOCK0_EXECUTION
NO_FIRST_HIT_GATE
NO_OPERATOR_TO_FIBRES
NO_F3_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```
