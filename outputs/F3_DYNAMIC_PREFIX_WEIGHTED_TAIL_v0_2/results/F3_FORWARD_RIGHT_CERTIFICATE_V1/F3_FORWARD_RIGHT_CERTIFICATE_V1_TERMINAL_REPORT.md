# F3 forward right certificate v1 — terminal report

Status: `F3_FORWARD_RIGHT_CERTIFICATE_V1_EXECUTION_STOP`

Date: 2026-07-24.

Branch: `codex/hilo2-f3-forward-right-certificate-v1`.

Publicly custodied pre-execution HEAD:

```text
d1a5073
```

## R0

`R0_STATIC_PREFLIGHT_PASS`.

All frozen inputs, the contract, both vector hashes and the control values
matched.  The new module had 21 stable declarations, a 21/21 explicit audit,
a namespace-wide environmental inventory and no forbidden token.

## C0

Exactly one invocation was made under the frozen 900-second ceiling:

```text
timeout --signal=TERM 900s /usr/bin/time -p lake env lean \
  CollatzClassical/KL2003/F3ReturnExcursionForwardFormulaRightCertificate.lean
```

It exited with code 1 after 2.37 seconds:

```text
info: mathlib: cloning https://github.com/leanprover-community/mathlib4.git
error: external command 'git' exited with code 128
real 2.37
user 0.19
sys 0.27
```

At invocation time `.lake/packages` was empty.  `lake` therefore attempted
dependency acquisition and stopped before Lean elaborated the certificate
module.  No theorem, finite row, tactic proof, or kernel reduction was
tested.  This is an environmental dependency-acquisition STOP, not a
mathematical counterexample and not a Lean elaboration failure.

The v1 contract permits no retry.  The process was not rerun and no resource
limit was changed.

## A1 and K1

Not executed, as required after C0 STOP.  The module's theorem status and
axiom profile remain unknown.

```text
R0_STATIC_PREFLIGHT_PASS
C0_ENVIRONMENTAL_DEPENDENCY_ACQUISITION_STOP
A1_NOT_RUN
K1_NOT_RUN
THEOREM_STATUS_UNKNOWN_NOT_COMPILED
AXIOM_PROFILE_UNKNOWN_NOT_AUDITED
NO_BLOCK0_EXECUTION
NO_FIRST_HIT_GATE
NO_F3_EXPONENT_THEOREM
```
