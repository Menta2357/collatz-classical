# F3 forward-right certificate v4 — G0 report

Status: `G0_PASS_WITH_HOST_SLEEP_TIMING_ANOMALY`.

Date: 2026-07-24.

Branch: `codex/hilo2-f3-forward-right-certificate-v4`.

Public pre-execution HEAD:

```text
96c6637ef2a3d6360abeac2cebcec9aad8aed25d
```

## S0

S0 passed its complete precheck and created the fresh v4 overlay from the
frozen inputs.  It contains 209 `.olean` files, zero `.ilean` files, 209
regular files and zero symbolic links.  No target or audit object exists.

```text
stage tree sha256  47f559f88e7b103fe0d775b1a7b5a5e3a3fd5e9327cd4619129dbc4c473707d8
real/user/sys      11.51 / 6.45 / 1.48 seconds
wrapper exit       0
```

## D0

D0 passed its complete precheck, direct-Lean import, three required producer
checks, single-Collatz-root check and post-probe freshness check.  The overlay
remained exactly 209/0/209 with no symlinks, and no target or audit object was
created.  The frozen `gtimeout 600` wrapper returned exit status 0.

The nested `/usr/bin/time` receipt is:

```text
real/user/sys      2473.98 / 41.08 / 18.33 seconds
wrapper exit       0
```

The large civil-time value is a documented host-suspension anomaly, not a
claim that D0 completed within 600 seconds of ordinary wall time.  The probe
log was created at 19:56:51 +0200 and last modified at 20:38:05 +0200.
macOS `pmset -g log` records entry into `Clamshell Sleep` at 19:58:34 and the
final user wake at 20:37:19, with maintenance sleep cycles in between.  Thus
`/usr/bin/time` included the suspended interval while the frozen GNU
`gtimeout` 9.7 mechanism did not expire.  The import/check computation ran
for far less than 600 seconds outside the documented suspension.

D0 was not rerun.  This timing annotation changes no import, name-resolution
or mathematical claim and does not create a proof object.

## Gate binding

The two immutable raw logs have the following SHA-256 values.  This report
and both logs must be committed and pushed before C0 can pass its precheck.

F3_FORWARD_V4_G0=PASS
F3_FORWARD_V4_S0_LOG_SHA256=b6971dd70c3e40c2357a12b4cfd41b8fa62c448aa48e5b4ae86649c86ebd07cd
F3_FORWARD_V4_D0_LOG_SHA256=a0d83f1f1dc977a242051735b665ca5a7aca7c42ef73d95e4254f57cbab36c11
F3_FORWARD_V4_D0_TIMING=PASS_WITH_HOST_SLEEP_ANOMALY

```text
S0_PASS
D0_PASS_UNDER_FROZEN_GTIMEOUT_SEMANTICS
NO_D0_RETRY
STRICT_CIVIL_WALL_UNDER_600_NOT_CLAIMED
TARGET_OBJECTS_ABSENT
AUDIT_OBJECTS_ABSENT
NO_C0_RUN
NO_A1_RUN
NO_K1_RUN
```
