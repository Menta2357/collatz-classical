# F3 forward-right certificate v5 — audit-only contract

Status: `PRE_RUN_FROZEN — ONE AUDIT-ONLY EXECUTION AUTHORIZED`

Date: 2026-07-24.

Branch: `codex/hilo2-f3-forward-right-certificate-v5-audit-only`.

## 1. Succession and purpose

V5 succeeds the publicly custodied v4 audit-policy STOP:

```text
v4 terminal commit          bc27af64cbeff07f2430bd71390e7aa2cf1dc1ac
v4 producer/G0 HEAD         727e43fe3e739c8fbec428c30ada322415f1e1fb
v4 terminal-report sha256   91c9b48f076b890cf24db3aa332bf1a592721b10432229ee7d8523c24b428507
v4 C0 raw-log sha256        ea398caeb54181bc601d6b638755f0e703cdf7f40e5fdfef07f2d0db8248b431
v4 A1 raw-log sha256        43a34ed395e89ac837adcc3df2cecfeb8efb017cb7ad82bce1d21805878e51f1
v4 K1 raw-log sha256        0e82877bc975f99f535096d2eb6c01c884c03b9f9b2bb7fcb9b4122b08a56d38
```

V4 C0 compiled the certificate and v4 A1 produced complete 129/129 profiles.
V4 K1 then stopped because its generated-declaration allowlist admitted only
the logical trio plus `lcProof`.  It rejected exactly three old-codegen
specialization axioms confined to two unsafe `_cstage2` owners.  The 21 stable
declarations contain none of them and depend only on the standard logical
trio or a subset.

V5 does not change or recompile the certificate or A1 audit.  It classifies
the three exact compiler artifacts with a stricter audit that verifies their
kind, unsafe flag, owner, occurrence count and absence from every stable
transitive cone.

## 2. Immutable proof objects

The existing v4 overlay is read-only input:

```text
.lake/f3-forward-right-certificate-v4-overlay/lib/lean
```

Its final state is 211 `.olean`, two `.ilean`, 213 regular files and zero
symlinks.  The four new objects are frozen at:

```text
target olean  376390a3f8fc72d2058a19c2b0028d08280a210a074ec88fd60a942781f017af
target ilean  9a479f85f00eb0bafb48a8ccdb52ef044ab2188ca39a4b8c5451d2777089ef57
audit olean   ca63fc1f43ae8da04347f2add16c8f42997cbd0bfdc6c39f886f067092148bba
audit ilean   55c10ae0d582ee52215ba5ae0ba26402466a3fccc32e2f82872903729f69aa31
```

Source and audit inputs remain:

```text
certificate source  75fb6b9b4f89f65df7e67b0b87704b17f0814950f17418d067ac1881bddc9f88
total audit source  fd9d431d4ce5657204e1b9fa98b8cfd2e8214454fee96bf4b042e0a8629432f2
```

## 3. Exact codegen exception map

Only these three fully qualified constants may be admitted as specialization
axioms, each exactly once and only in its declared generated owner:

```text
owner: CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.lowerForwardRowNat._cstage2
  List.filterTR.loop._at.CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.lowerForwardRowNat._spec_1
  List.foldrTR._at.CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.lowerForwardRowNat._spec_2

owner: CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.forwardRightWeight._cstage2
  Nat.cast._at.Real.instNatCast._spec_2
```

The direct Lean probe must find each special constant as
`ConstantInfo.axiomInfo` with `isUnsafe = true`, find both owners with
`isUnsafe = true`, find all 21 stable declarations safe, and prove that none
of the three constants occurs in any stable declaration's transitive
`collectAxioms` result.

The shell classifier independently requires 21 stable and 108 generated
profiles, 129/129 total and unique coverage, exactly the three mapped
specializations, exactly three `lcProof` occurrences, no unmatched residue
and exact owner placement.  No wildcard `_spec_*` rule is permitted.

## 4. Frozen audit executors

```text
v4 common shell       5e3d1cd4094dfb5bbd5c42c13a31ed22987fb9cafe65696b97c37c3d7ce66e4e
v5 shell classifier  5c3c6b2fd113f2bf996a9edb5197e2b7616b667aee438baadc256cd939a8581e
v5 Lean probe         4efe62b76345aba575a880c23033ae28f7add1a54812e4f7827f3976d73afc72
v5 executor           54cc7c0d4b5d95581db64d3c5afdcf4855710930126ff1978dc7f1cc3871647f
```

The executor also freezes the exact GNU `gtimeout` and `gsort` binaries,
requires a clean public v5 HEAD descended from the public v4 terminal commit,
and binds the v4 remote-tracking branch, report and three raw logs.

## 5. Single authorized phase

### A0 — audit only, 600 seconds

There is one invocation through the frozen v5 executor and no retry.  It:

1. verifies v4 provenance, logs, objects, counts and hashes;
2. replays the exact 21/108/129 profile classification over the immutable A1
   log;
3. scans source and logs for `Lean.ofReduceBool`, `ofReduceBool`, `sorryAx`,
   `sorry`, `admit` and `native_decide` as applicable;
4. imports the existing audit object through direct Lean `--stdin` and checks
   `axiomInfo`, `isUnsafe`, owners and all 21 stable cones;
5. repeats object/count/hash/freshness verification and writes no object.

The immutable raw log and a terminal report are committed and pushed for
either PASS or STOP before any downstream phase is considered.

PASS is labeled:

```text
PASS_WITH_EXPLICIT_CODEGEN_SPEC_EXCEPTIONS
```

It certifies that all 21 stable declarations have profiles contained in
`[propext, Classical.choice, Quot.sound]` while three explicitly named unsafe
codegen axioms remain confined to two explicitly named unsafe compiler-stage
owners.  It does not claim that the entire namespace is axiom-free, and it
does not retroactively turn v4 K1 into PASS.

Any new name, wrong owner, wrong kind, `isUnsafe = false`, stable occurrence,
coverage change, object mutation, forbidden token, timeout or precheck error
is terminal STOP and must be custodied before a successor.

## 6. Scope

```text
NO_C0_RECOMPILE
NO_A1_RECOMPILE
NO_OBJECT_WRITE
NO_WILDCARD_CODEGEN_ALLOWLIST
NO_BLOCK0_EXECUTION
NO_FIRST_HIT_GATE
NO_F3_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```
