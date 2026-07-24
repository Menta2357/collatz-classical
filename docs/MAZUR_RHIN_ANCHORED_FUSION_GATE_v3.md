# Rhin-anchored H1 successor gate v3

Status: `AUTHORIZED / REMOTE_RECEIPT_REPAIRED / NOT_EXECUTED`

Date: 2026-07-24.

## 1. Exact successor scope

```text
branch = agent/mazur-rhin-anchored-warm-gate-v3
parent v2 terminal = d902528a118193e50ac7d1158e87219375737c21
public v2 custody = https://github.com/Menta2357/collatz-classical/pull/9
```

V2 stopped in F0 because the clone's narrow fetch refspec did not store the
new branch as `refs/remotes/origin/*`. V3 changes only that custody check: F0
uses read-only `git ls-remote` and requires the exact public SHA to equal local
HEAD. It does not fetch, modify refspecs or create remote-tracking refs.

The candidate, reconstruction, caches, phase commands and budgets remain
unchanged. V2 evidence is immutable.

## 2. Frozen inputs

```text
candidate theorem = a7f3bef1c7184b514c3cc6833da03a3eefd5f41b3bea58bf4062885d7bfab7b1
candidate audit = 4c75fd87933592842a70a4f861f29fa685c73ea81a62ed359437b8170506f688
lake-manifest.json = bc45e15b36f7aede2ceed922babf4bbcacb6789a1ec2d85bd571105fcd73926e
reconstruction = b7da87864ced8abd6c3715b65320efc233c0d853
toolchain = leanprover/lean4:v4.30.0
mathlib = c5ea00351c28e24afc9f0f84379aa41082b1188f
```

## 3. Publication discipline

The prepared contract/review/script and a pre-run report must be committed,
then pushed explicitly without `-u`:

```sh
git push origin HEAD:refs/heads/agent/mazur-rhin-anchored-warm-gate-v3
```

F0 must print matching local/public SHAs. Terminal PASS or STOP must be
committed and pushed by the same explicit refspec. `git fetch`, refspec edits,
manual remote-tracking refs, `git push -u`, retry, source edit, resource
increase, amend, force-push, retarget and merge are forbidden.

Only one heavy build may run at a time. The coordinating root must confirm
that no other project build is active before D1.

The pre-run report path is
`artifacts/mazur-rhin-anchored-ca3/rhin-v3-logs/RHIN_V3_RUN_REPORT_v1.md`.
It freezes the prepared commit, hashes, literal commands, zero counters and
absence of all four v3 raw logs.

## 4. Sequential phases

All commands run from the reconstruction root and stop at first failure.

### F0 — public receipt and environment, 120 s

```sh
/usr/bin/time -p /opt/homebrew/bin/gtimeout 120 bash '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/scripts/rhin_v3_preflight.sh' > '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/rhin-v3-logs/F0_preflight.full.log' 2>&1
```

F0 may terminate as `F0_PUBLIC_REF_QUERY_STOP`, `F0_PUBLIC_REF_SHAPE_STOP`,
`F0_PUBLIC_HEAD_MISMATCH_STOP` or another preflight mismatch.

### D1 — dependency prepayment, 900 s

Only after F0 PASS:

```sh
/usr/bin/time -p /opt/homebrew/bin/gtimeout 900 lake build Erdos1135.ND.FusionParametric Erdos1135.ND.RhinUnconditional > '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/rhin-v3-logs/D1_dependency_prepay.full.log' 2>&1
```

D1 PASS requires exit zero and `.olean` plus `.ilean` for both roots. Failure
is `DEPENDENCY_PREPAY_STOP`; P1/A1 remain forbidden.

### P1 — target elaboration, 300 s

Only after D1 PASS:

```sh
/usr/bin/time -p /opt/homebrew/bin/gtimeout 300 lake build Erdos1135.ND.FusionRhinAnchored > '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/rhin-v3-logs/P1_target_build.full.log' 2>&1
```

P1 PASS requires target `.olean` plus `.ilean`; otherwise
`TARGET_ELABORATION_STOP` and A1 remains forbidden.

### A1 — producer/consumer audit, 300 s

Only after P1 PASS:

```sh
/usr/bin/time -p /opt/homebrew/bin/gtimeout 300 lake env lean FusionRhinAnchoredAxiomAudit.lean > '/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo/artifacts/mazur-rhin-anchored-ca3/rhin-v3-logs/A1_axiom_audit.full.log' 2>&1
```

PASS requires both producer and consumer profiles to contain exactly
`propext`, `Classical.choice`, `Quot.sound`. Any nonzero exit, missing profile
or extra axiom is `AUDIT_STOP`.

## 5. Scope of PASS

PASS establishes only the anchored conditional corollary. It does not
discharge `hsmall`, construct the finite base, prove density one or Collatz.

```text
F0_INVOCATIONS = 0
D1_INVOCATIONS = 0
P1_INVOCATIONS = 0
A1_INVOCATIONS = 0
PUBLIC_TERMINAL_CUSTODY = REQUIRED
NO_RETRY
```
