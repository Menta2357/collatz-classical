# F3 forward-right certificate v3 — terminal report

Status: `F3_FORWARD_RIGHT_CERTIFICATE_V3_C0_PROOF_STOP`

Date: 2026-07-24.

Branch: `codex/hilo2-f3-forward-right-certificate-v3`.

Public G0 commit at execution:

```text
4a65e1914dc1f4714da1dfa4197041f95dd55e98
```

Frozen contract SHA-256:

```text
f89ed046510b0d21e143b7aaf37d37a35c337dc3b87f0ea6903d40d102367997
```

## S0, D0 and G0

S0 passed with 209 staged `.olean` files, no `.ilean` files and no symbolic
links.  D0 passed its direct-Lean import and three required producer checks,
and confirmed that the target objects were absent.  Their immutable logs and
hashes were committed and pushed in G0 before C0 was permitted to start.

```text
S0_LOG_SHA256=0dadbb9651093c35d94e1ce62747470d5e9151658e54398340611977bb1ea11f
D0_LOG_SHA256=a6f52c1125cdc224372f2b35c17a87934ccaa7f8889406e00505029a22139c55
G0_PUBLIC_PASS
```

## C0

Exactly one C0 invocation was made through the frozen executor under the
1,800-second ceiling.  Its complete precheck passed.  Direct Lean then stopped
with wrapper exit status 1 after 110.32 seconds at the first finite-certificate
proof:

```text
CollatzClassical/KL2003/F3ReturnExcursionForwardFormulaRightCertificate.lean:68:2:
error: failed to synthesize
  Decidable forwardRightNatCertificate
```

The C0 raw-log SHA-256 is:

```text
6f6bfb1e59e822d58c53d8f3ca8bec090c8ec42c308cfd6122c2a947436fc009
```

The raw log is 996 bytes.  No target `.olean` or `.ilean` was produced.  The
frozen source and audit files remained unchanged, with SHA-256 values
`37932fd8198e045c436c479455a362afb9b2ef720b2138c1f3308f552e16a4ab`
and
`fd9d431d4ce5657204e1b9fa98b8cfd2e8214454fee96bf4b042e0a8629432f2`,
respectively.

This is an actual Lean elaboration/decidability STOP.  It is not an
environmental dependency failure or a timeout.  It is also not a mathematical
counterexample: Lean did not derive a false row inequality; it could not
construct the `Decidable` instance requested by the tactic `decide` for the
named proposition.

The phase was not retried, the source was not changed and no resource limit
was increased under v3.

## A1 and K1

A1 and K1 were not executed, as required after C0 STOP.  Consequently no
public theorem or axiom-profile claim is made for this module under v3.

```text
S0_PASS
D0_PASS
G0_PUBLIC_PASS
C0_LEAN_ELABORATION_DECIDABILITY_STOP
A1_NOT_RUN
K1_NOT_RUN
TARGET_OBJECTS_ABSENT
THEOREM_STATUS_UNKNOWN_NOT_COMPILED
AXIOM_PROFILE_UNKNOWN_NOT_AUDITED
NO_BLOCK0_EXECUTION
NO_FIRST_HIT_GATE
NO_F3_EXPONENT_THEOREM
```
