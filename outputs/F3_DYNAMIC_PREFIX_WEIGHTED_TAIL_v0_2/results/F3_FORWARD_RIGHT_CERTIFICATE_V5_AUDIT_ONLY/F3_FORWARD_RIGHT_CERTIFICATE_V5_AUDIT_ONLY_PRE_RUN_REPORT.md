# F3 forward-right certificate v5 audit-only — pre-run report

Status: `PRE_RUN_FROZEN — NO V5 PHASE EXECUTED`

Date: 2026-07-24.

Branch: `codex/hilo2-f3-forward-right-certificate-v5-audit-only`.

Declared base:

```text
bc27af64cbeff07f2430bd71390e7aa2cf1dc1ac
```

Contract SHA-256:

```text
036c8a353b72ad76e66e8658a46621d2f9d50d10044f039fbc6228859741012f
```

V5 is an audit-only successor.  It changes no mathematical source and writes
no Lean object.  It classifies the immutable C0/A1 objects produced at
`727e43fe3e739c8fbec428c30ada322415f1e1fb` and publicly custodied by the v4
terminal commit above.

## Static freeze

```text
v4 terminal report/logs           tracked and hash-bound
target/audit objects               4/4 exact hashes
overlay state                      211 olean / 2 ilean / 213 files / 0 links
stable source/audit inventory      21/21 exact names
namespace profiles                 129/129 unique
generated profiles                 108
old v4 allowlist accepted          127 profiles
old v4 allowlist rejected          2 generated profiles
exact rejected codegen axioms      3
exact rejected generated owners    2
other unmatched residues           0
forbidden compile/audit tokens      absent
bash syntax                         2/2 PASS
```

The three exceptions are fully qualified in the contract; no wildcard is
used.  Static inspection of Lean 4.21 identifies `_cstage*` and `_spec_*` as
old-codegen names.  The one authorized direct-Lean probe will still verify the
stronger facts in the loaded checked environment: all three are unsafe axiom
entries, both owners are unsafe, every stable declaration is safe and no
stable transitive cone contains an exception.

## Execution gate

The executor enforces a clean public v5 HEAD descended from public v4 terminal
`bc27af64cbeff07f2430bd71390e7aa2cf1dc1ac`, exact script/probe/report/log
hashes, `noclobber`, a 600-second limit and one attempt.  It runs no C0 or A1
compilation and creates no `.olean` or `.ilean`.

At freeze time the v5 raw log is absent.

```text
NO_A0_RUN
NO_C0_RECOMPILE
NO_A1_RECOMPILE
NO_OBJECT_WRITE
NO_BLOCK0_EXECUTION
```
