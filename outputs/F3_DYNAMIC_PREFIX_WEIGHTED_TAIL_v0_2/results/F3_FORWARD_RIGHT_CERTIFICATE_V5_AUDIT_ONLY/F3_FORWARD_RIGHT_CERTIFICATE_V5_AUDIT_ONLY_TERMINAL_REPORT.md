# F3 forward-right certificate v5 — terminal report

Status: `PASS_WITH_EXPLICIT_CODEGEN_SPEC_EXCEPTIONS`

Date: 2026-07-24.

Branch: `codex/hilo2-f3-forward-right-certificate-v5-audit-only`.

Public pre-execution HEAD:

```text
f6512a0638b496991bd3f9ecd823b1688e6ea41b
```

Frozen contract SHA-256:

```text
036c8a353b72ad76e66e8658a46621d2f9d50d10044f039fbc6228859741012f
```

## A0 — PASS

Exactly one A0 invocation was made.  Its public-custody precheck passed and
the frozen audit-only executor exited with status zero under its 600-second
limit.  It did not run C0 or A1 and did not write a Lean object.

```text
direct Lean real/user/sys  125.60 / 6.49 / 11.75 seconds
wrapper real/user/sys      189.39 / 45.02 / 17.48 seconds
wrapper exit               0
stable declarations        21
generated declarations     108
namespace profiles         129
exact unsafe spec axioms   3
exact unsafe owners        2
lcProof occurrences        3
stable codegen axioms      0
object postcheck            unchanged
```

The shell replay accounted for all 129 unique A1 profiles with no residue.
The direct Lean probe found every one of the 21 stable declarations safe and
verified that every member of each stable declaration's transitive
`collectAxioms` set belongs to exactly the allowed set
`{propext, Classical.choice, Quot.sound}`.

The probe verified that the following three exact constants are unsafe
`axiomInfo` compiler specializations and that both named owners are unsafe.
Independently, the shell replay verified that, within the 129 audited
namespace profiles, each specialization occurs exactly once and only in its
mapped generated owner:

```text
owner: CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.lowerForwardRowNat._cstage2
  List.filterTR.loop._at.CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.lowerForwardRowNat._spec_1
  List.foldrTR._at.CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.lowerForwardRowNat._spec_2

owner: CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.forwardRightWeight._cstage2
  Nat.cast._at.Real.instNatCast._spec_2
```

None of those three names occurs in any stable declaration's transitive
axiom cone.  The audit used no wildcard exception rule.  Forbidden tokens
were absent under the contract's declared scans.

The immutable object state remained 211 `.olean`, two `.ilean`, 213 regular
files and zero symlinks.  All four proof-object hashes were unchanged:

```text
target olean  376390a3f8fc72d2058a19c2b0028d08280a210a074ec88fd60a942781f017af
target ilean  9a479f85f00eb0bafb48a8ccdb52ef044ab2188ca39a4b8c5451d2777089ef57
audit olean   ca63fc1f43ae8da04347f2add16c8f42997cbd0bfdc6c39f886f067092148bba
audit ilean   55c10ae0d582ee52215ba5ae0ba26402466a3fccc32e2f82872903729f69aa31
```

Raw-log SHA-256:

```text
e7498f79f80c7ce4eefe02a003917c66687e72593c354bd0dd36efa046992a03
```

## Calibration

V5 signs the exact stable-declaration result and the exact classification of
the three compiler-generated exceptions.  It does not claim that the entire
namespace is axiom-free, does not retroactively convert the v4 K1 STOP into a
PASS and does not establish Block0, the first-hit hook, the proposed F3
exponent or a density theorem.

```text
V4_K1_STOP_REMAINS
V5_A0_SINGLE_INVOCATION
V5_A0_PASS_WITH_EXPLICIT_CODEGEN_SPEC_EXCEPTIONS
STABLE_DECLARATIONS_21_OF_21_SAFE
STABLE_AXIOM_CONES_WITHIN_LOGICAL_TRIO
GENERATED_DECLARATIONS_108_OF_108_CLASSIFIED
NAMESPACE_PROFILES_129_OF_129_CLASSIFIED
EXACT_UNSAFE_SPEC_AXIOMS_3
EXACT_UNSAFE_CODEGEN_OWNERS_2
NO_WILDCARD_EXCEPTION
OBJECTS_UNCHANGED
FULL_NAMESPACE_AXIOM_FREE_NOT_CLAIMED
NO_BLOCK0_EXECUTION
NO_FIRST_HIT_GATE
NO_F3_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```
