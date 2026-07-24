# Rhin-anchored H1 successor gate v3 static review

Status: `STATIC_PASS / PHASES_NOT_EXECUTED`

Date: 2026-07-24.

V3 is an exact successor of the public v2 F0 STOP at `d902528`. It changes no
Lean candidate, cache, mathematical statement, phase budget or build command.
The sole mechanism change is the F0 public-receipt check:

```text
v2 = rev-parse @{u} against an unstored remote-tracking ref
v3 = ls-remote --exit-code --refs origin <exact-public-ref>
```

The v3 script requires one remote row, exact ref name and exact equality of
the public SHA with local HEAD. No fallback exists. Network/query/shape/SHA
failure is STOP.

Static shell syntax, candidate hashes, reconstruction commit, Mathlib state,
cache/absence conditions, 12 GiB disk gate and sequential STOP semantics are
preserved. Both PASS and STOP require public terminal custody.
