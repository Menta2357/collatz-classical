# Rhin-anchored H1 successor build STOP v1

Status: `BUILD_TIMEOUT_STOP / TARGET_NOT_REACHED / AUDIT_NOT_RUN`

Date: 2026-07-24.

The sole predeclared build command was:

```sh
/opt/homebrew/bin/gtimeout 300 lake build Erdos1135.ND.FusionRhinAnchored
```

It returned exit 124 at the 300-second wall ceiling. The last reported progress
was `3397/3439`, while compiling the previously cold upstream Rhin/Tao
dependency closure. Only upstream linter/deprecation warnings were observed;
the target module was not reached and no theorem-level error was reported.

The execution harness streamed the command output but the predeclared gate did
not name a persistent raw-log path. This report does not claim a complete local
raw log. That evidence limitation is recorded rather than repaired by a second
run.

Post-run state:

```text
BUILD_INVOCATIONS = 1
BUILD_EXIT = 124
BUILD_TIMEOUT = true
BUILD_HEARTBEAT_EXHAUSTION = false
LAST_PROGRESS = 3397/3439
TARGET_OLEAN = ABSENT
TARGET_ILEAN = ABSENT
AUDIT_INVOCATIONS = 0
AUDIT_OLEAN = ABSENT
AUDIT_ILEAN = ABSENT
RETRY = false
RESOURCE_ESCALATION = false
SOURCE_EDIT_AFTER_RUN = false
FAILURE_CLASS = COLD_DEPENDENCY_CLOSURE_TIMEOUT
THEOREM_COMPILED = false
THEOREM_AXIOM_PROFILE = UNKNOWN_NOT_AUDITED
```

Candidate hashes remain:

```text
FusionRhinAnchored.lean =
a7f3bef1c7184b514c3cc6833da03a3eefd5f41b3bea58bf4062885d7bfab7b1
FusionRhinAnchoredAxiomAudit.lean =
4c75fd87933592842a70a4f861f29fa685c73ea81a62ed359437b8170506f688
```

The candidate still removes only the free `ND31Bounds` argument on paper. It
must not be called a theorem until a separately authorized cold/warm-aware
build contract compiles it and the producer plus consumer audit passes.
