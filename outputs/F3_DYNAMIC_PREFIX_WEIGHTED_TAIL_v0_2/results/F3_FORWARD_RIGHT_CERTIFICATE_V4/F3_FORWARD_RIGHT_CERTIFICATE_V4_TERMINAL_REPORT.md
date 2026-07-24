# F3 forward-right certificate v4 — terminal report

Status: `F3_FORWARD_RIGHT_CERTIFICATE_V4_K1_GENERATED_PROFILE_ALLOWLIST_STOP`

Date: 2026-07-24.

Branch: `codex/hilo2-f3-forward-right-certificate-v4`.

Public G0 and execution HEAD:

```text
727e43fe3e739c8fbec428c30ada322415f1e1fb
```

Frozen contract SHA-256:

```text
b98442efb3d695608baccdf9e7b07fd4dcec6ce760f5f9b334519cffecd278db
```

## S0, D0 and G0

S0 passed with the exact fresh 209/0/209 overlay and no symlinks.  D0 passed
all imports, producer checks, root/freshness checks and wrapper conditions.
Its 2,474-second civil span included 2,277 seconds of sleep intervals recorded
by macOS, leaving at most 197 seconds outside suspension.  The frozen
`gtimeout 600` therefore returned 0; no strict claim of civil wall time below
600 seconds is made and D0 was not rerun.  Both immutable logs and the
calibrated G0 report were committed and pushed before C0.

## C0 — PASS

Exactly one C0 invocation was made.  Its complete precheck passed and direct
Lean compiled the repaired certificate source successfully under the frozen
1,800-second limit.

```text
real/user/sys       1109.31 / 49.02 / 139.70 seconds
Lean exit           0
wrapper exit        0
target olean        376390a3f8fc72d2058a19c2b0028d08280a210a074ec88fd60a942781f017af
target ilean        9a479f85f00eb0bafb48a8ccdb52ef044ab2188ca39a4b8c5451d2777089ef57
post-C0 state       210 olean / 1 ilean / 211 regular files
```

Thus the finite Nat certificate, its transfer to the real forward-row
certificate and the generic weighted-mass step all compiled.  This is a C0
proof-object PASS, not yet a namespace-wide axiom-audit PASS.

## A1 — PASS

Exactly one A1 invocation was made after C0.  It compiled the total audit and
printed an axiom profile for every declaration under the target namespace.

```text
real/user/sys       325.22 / 13.38 / 29.80 seconds
Lean exit           0
wrapper exit        0
namespace count     129
profile count       129
unique profiles     129
stable declarations 21
explicit audits     21
audit olean         ca63fc1f43ae8da04347f2add16c8f42997cbd0bfdc6c39f886f067092148bba
audit ilean         55c10ae0d582ee52215ba5ae0ba26402466a3fccc32e2f82872903729f69aa31
post-A1 state       211 olean / 2 ilean / 213 regular files / 0 symlinks
```

The 21 explicit stable-declaration profiles printed by Lean contain only the
standard logical set `[propext, Classical.choice, Quot.sound]` or a subset.
The compile and audit logs contain no `Lean.ofReduceBool`, `sorryAx` or
`native_decide`; this absence was confirmed by a read-only postmortem scan,
because the frozen K1 stopped at its allowlist AWK before reaching its own
final grep.

## K1 — STOP

Exactly one K1 invocation was made.  Its precheck passed.  It exited with
status 1 after 32.29 seconds and emitted no K1 PASS marker.

```text
real/user/sys       32.29 / 19.24 / 2.85 seconds
wrapper exit        1
final object state  211 olean / 2 ilean / 213 regular files / 0 symlinks
```

Read-only postmortem of the already frozen A1 log identifies two rejected
generated namespace profiles and three non-allowlisted helpers:

```text
CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.lowerForwardRowNat._cstage2
[List.filterTR.loop._at.CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.lowerForwardRowNat._spec_1,
 propext, Quot.sound, Classical.choice,
 List.foldrTR._at.CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.lowerForwardRowNat._spec_2]

CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.forwardRightWeight._cstage2
[propext, Quot.sound, Nat.cast._at.Real.instNatCast._spec_2]
```

These are generated compiler-stage declarations, not members of the 21
stable public declarations.  Nevertheless, v4 K1 allowed generated profiles
to contain only the logical trio plus `lcProof`; the two list-recursion
specializations and the `Nat.cast` specialization therefore make the frozen
whole-namespace allowlist check fail.  V4 does not reclassify those helpers
after seeing the result.

This is an audit-classification STOP.  It does not retract the C0 compilation
or the A1 output, and it is not a false row inequality or a mathematical
counterexample.  It also means that v4 does not sign the stronger
whole-namespace kernel-clean label.  The phase was not retried, no object was
changed and no limit was increased.

Raw-log SHA-256 values:

```text
C0  ea398caeb54181bc601d6b638755f0e703cdf7f40e5fdfef07f2d0db8248b431
A1  43a34ed395e89ac837adcc3df2cecfeb8efb017cb7ad82bce1d21805878e51f1
K1  0e82877bc975f99f535096d2eb6c01c884c03b9f9b2bb7fcb9b4122b08a56d38
```

```text
S0_PASS
D0_PASS_WITH_DOCUMENTED_HOST_SLEEP_ANOMALY
G0_PUBLIC_PASS
C0_CERTIFICATE_COMPILE_PASS
A1_TOTAL_AUDIT_COMPILE_PASS
STABLE_DECLARATIONS_21_OF_21_PROFILED
STABLE_PROFILES_WITHIN_LOGICAL_TRIO
NAMESPACE_PROFILES_129_OF_129
K1_GENERATED_PROFILE_ALLOWLIST_STOP
FULL_NAMESPACE_KERNEL_CLEAN_NOT_SIGNED
NO_K1_RETRY
NO_BLOCK0_EXECUTION
NO_FIRST_HIT_GATE
NO_F3_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```
