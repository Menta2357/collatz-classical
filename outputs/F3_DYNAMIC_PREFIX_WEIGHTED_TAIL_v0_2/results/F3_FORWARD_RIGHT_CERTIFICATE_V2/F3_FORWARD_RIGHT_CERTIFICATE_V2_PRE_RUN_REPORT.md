# F3 forward right certificate v2 — pre-run report

Status: `PRE_RUN_FROZEN — NO V2 PHASE EXECUTED`

Date: 2026-07-24.

Branch: `codex/hilo2-f3-forward-right-certificate-v2`.

Declared base:

```text
e87085259b547291f9121317c369f2ec42f512ed
```

V2 contract sha256:

```text
ae8a43cdde69b95c128b0b03299f0efd121635d07b2d6f4e5c7cfeb90d191a59
```

The v1 attempt stopped at dependency acquisition after 2.37 seconds, before
Lean elaboration.  V2 therefore freezes the mathematical source and audit
byte-for-byte and changes only execution staging:

- E0 gets up to 3600 seconds to obtain the pinned dependency cache;
- P0 gets up to 3600 seconds to build only the three direct imports;
- G0 must prove and publicly custody a complete warm-environment gate;
- C0 gets a single 1800-second theorem attempt;
- A1 gets a single 1200-second total-audit attempt;
- K1 gets one 120-second coverage/forbidden-profile check.

The source remains at `maxHeartbeats 2000000` and `maxRecDepth 100000`.
This avoids changing an audited proof when the only observed failure was
environmental.

At freeze time:

```text
.lake/packages entries       0
certificate olean            absent
audit olean                  absent
v2 Lean phases run           0
Block0 executions            0
tracked worktree drift       contract + this report only
```

No v2 environment acquisition, dependency prepayment, target compilation,
audit or semantic enumeration occurred before this freeze.

```text
NO_E0_RUN
NO_P0_RUN
NO_C0_RUN
NO_A1_RUN
NO_K1_RUN
NO_BLOCK0_EXECUTION
```
