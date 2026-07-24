# F3 forward right certificate v2 — terminal report

Status: `F3_FORWARD_RIGHT_CERTIFICATE_V2_E0_ENVIRONMENT_STOP`

Date: 2026-07-24.

Branch: `codex/hilo2-f3-forward-right-certificate-v2`.

Public pre-execution commit:

```text
e8d2892
```

## E0 result

The one authorized E0 invocation was:

```text
timeout --signal=TERM 3600s /usr/bin/time -p lake exe cache get
```

It cloned and checked out all nine revisions pinned by the manifest, built
Mathlib's cache utility and downloaded the `leantar 0.1.15` archive.  It then
exited with code 1 after 120.51 seconds while extracting that utility:

```text
installing leantar 0.1.15
uncaught exception: failure in tar [...]
tar: Failed to set default locale
real 120.51
user 57.88
sys 11.68
```

This is an environmental locale failure.  It occurred before P0 and before
Lean elaborated either new v2 module.  It supplies no evidence for or against
the Nat certificate or any theorem proof.

The E0 command was not retried.  Under the v2 contract, P0, G0, C0, A1 and K1
were not executed.  The partially populated ignored `.lake/packages` state
is retained only as an honest trace of E0 and is not authorized as a warm
input to a successor attempt.

```text
E0_ENVIRONMENT_LOCALE_STOP
P0_NOT_RUN
G0_NOT_RUN
C0_NOT_RUN
A1_NOT_RUN
K1_NOT_RUN
THEOREM_STATUS_UNKNOWN_NOT_COMPILED
AXIOM_PROFILE_UNKNOWN_NOT_AUDITED
NO_BLOCK0_EXECUTION
NO_FIRST_HIT_GATE
NO_F3_EXPONENT_THEOREM
```
