# F3 forward right certificate v3 — pre-run report

Status: `PRE_RUN_FROZEN — NO V3 PHASE EXECUTED`

Date: 2026-07-24.

Branch: `codex/hilo2-f3-forward-right-certificate-v3`.

Declared base:

```text
0dc5c5bd43c3f9f347b1db3a59edd4f028a1249f
```

Contract sha256:

```text
f89ed046510b0d21e143b7aaf37d37a35c337dc3b87f0ea6903d40d102367997
```

V3 preserves the mathematical source and removes the two environmental
failure mechanisms observed in v1/v2.  It uses no Lake, network, cache
installer or `tar`; it uses one isolated direct-Lean package root assembled
from fully inventoried local objects.

## Frozen preflight

```text
donor Collatz olean manifest       206/206 verified
expected composite manifest       209/209 verified
expected initial ilean count       0
expected initial symlink count     0
target/audit objects globally      absent
donor package revisions            9/9 exact and clean
external olean roots               9/9 count+aggregate verified
Lean binary                        4.21.0; frozen hash
source/audit                       byte-identical to v1/v2
bash syntax                        7/7 scripts PASS
Block0 access                      none
```

The expected 209-object manifest was checked statically against the exact
donor or prior terminal-PASS overlay object selected for every path.  All 209
bytes matched.

## Host controls

```text
gtimeout 9.7 sha256  1ce578c938781a82c5bf7fd3fb2a1b9515f4f2486eb3c6511d0b2b4ec822bb1e
gsort 9.7 sha256     3e2705341516948679e48b245297318a2e79086639d02f8878404e3a9cb30b97
LC_ALL / LANG        C / C, verified available
```

The executor applies `noclobber`, public-HEAD equality, frozen-file hashes,
predecessor markers and ceilings of 600/600/1800/1200/120 seconds to
S0/D0/C0/A1/K1 respectively.  C0 is impossible until S0 and D0 logs plus G0
are committed and publicly pushed.

At freeze time the v3 composite root and every v3 raw log are absent.

```text
NO_S0_RUN
NO_D0_RUN
NO_G0_REPORT
NO_C0_RUN
NO_A1_RUN
NO_K1_RUN
NO_BLOCK0_EXECUTION
```
