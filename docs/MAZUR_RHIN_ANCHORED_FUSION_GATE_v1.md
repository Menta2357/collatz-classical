# Rhin-anchored H1 successor gate v1

Status: `BUILD_TIMEOUT_STOP / TARGET_NOT_REACHED / AUDIT_NOT_RUN`

Date: 2026-07-24.

Base publication commit:

```text
973ee134784cda35e2cff9a62c93da5d3c39d191
```

This successor does not modify the audited 7+2 payload. It adds a separate
two-file overlay importing the pinned upstream
`Erdos1135.ND.RhinUnconditional` theorem
`ndRhinRate_sameD_6993_200000` and the already published
`FusionParametric` consumer.

The target theorem removes only the free `ND31Bounds d` premise. It retains
`hN0`, the strict `hsmall` inequality for the upstream existential witness,
and `FiniteBaseVerified N0 T`.

Predeclared execution:

```text
build attempts = 1
audit attempts = 1 iff build PASS
build wall ceiling = 300 s
audit wall ceiling = 300 s
retry or resource escalation after failure = forbidden
```

Commands:

```sh
/opt/homebrew/bin/gtimeout 300 lake build Erdos1135.ND.FusionRhinAnchored
/opt/homebrew/bin/gtimeout 300 lake env lean FusionRhinAnchoredAxiomAudit.lean
```

Acceptance requires both commands to exit zero and both printed profiles to
contain only `propext`, `Classical.choice`, and `Quot.sound`. No claim is
made that `hsmall` or the finite base is discharged.

## Terminal result

The sole build reached its 300-second ceiling at progress `3397/3439` while
compiling the cold upstream Rhin/Tao closure and returned exit 124. The target
module was not reached; its `.olean` and `.ilean` are absent. The conditional
audit was therefore not invoked. There was no retry, source edit or resource
increase.

The candidate remains `UNKNOWN_NOT_AUDITED`, not a theorem. Full details are
recorded in
`artifacts/mazur-rhin-anchored-ca3/BUILD_TIMEOUT_STOP_REPORT.md`.
