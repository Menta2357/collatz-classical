# F3 forward-right certificate v4 — pre-run report

Status: `PRE_RUN_FROZEN — NO V4 PHASE EXECUTED`

Date: 2026-07-24.

Branch: `codex/hilo2-f3-forward-right-certificate-v4`.

Declared base and predecessor:

```text
07f245e7bd617cf48a1207a9640d4091554d3510
```

Contract SHA-256:

```text
b98442efb3d695608baccdf9e7b07fd4dcec6ce760f5f9b334519cffecd278db
```

V4 changes one tactic line only: it unfolds the named finite proposition
before the existing kernel `decide`.  No statement, definition, table,
coefficient, vector, audit entry or resource bound changes.

## Frozen repair gate

```text
source diff against v3 terminal      +1/-0, one `unfold` tactic line
v4 source sha256                     75fb6b9b4f89f65df7e67b0b87704b17f0814950f17418d067ac1881bddc9f88
unchanged audit sha256               fd9d431d4ce5657204e1b9fa98b8cfd2e8214454fee96bf4b042e0a8629432f2
stable source declarations           21
explicit #print-axioms declarations  21
forbidden source/audit tokens        absent
native_decide / ofReduceBool         absent
new definitions or data tables       none
bash syntax                          7/7 scripts PASS
```

## Frozen environment gate

```text
donor Collatz olean manifest       206/206 inherited and byte-identical
expected composite manifest       209/209 inherited and byte-identical
expected initial ilean count       0
expected initial symlink count     0
v4 target/audit objects            absent
v4 overlay                         absent
v3 overlay reuse                   forbidden
donor package revisions            9/9 exact and clean at runtime gate
external olean roots               9/9 count+aggregate checked at runtime
Block0 access                      none
```

The v4 scripts reproduce all v3 provenance, package, manifest,
anti-shadowing, global-freshness and single-root checks while substituting
only a fresh v4 overlay, result directory, log namespace and repaired source
hash.

## Host controls and sequence

```text
gtimeout 9.7 sha256  1ce578c938781a82c5bf7fd3fb2a1b9515f4f2486eb3c6511d0b2b4ec822bb1e
gsort 9.7 sha256     3e2705341516948679e48b245297318a2e79086639d02f8878404e3a9cb30b97
LC_ALL / LANG        C / C
phase ceilings       600/600/1800/1200/120 seconds
attempts             one per phase; no retry
```

The executor applies `noclobber`, public-HEAD equality, frozen-file hashes,
predecessor markers and phase ordering.  C0 is impossible until S0 and D0
logs plus a hash-binding G0 report are committed and publicly pushed.

At freeze time the v4 overlay, G0 report and every v4 raw log are absent.

```text
NO_S0_RUN
NO_D0_RUN
NO_G0_REPORT
NO_C0_RUN
NO_A1_RUN
NO_K1_RUN
NO_BLOCK0_EXECUTION
```
