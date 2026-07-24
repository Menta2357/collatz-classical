# F3 arithmetic-codec repair v3 static review v1

Status: `STATIC_V3_PREPARATION_PASS / EXECUTION_BLOCKED_PENDING_PUBLICATION_GATE_AND_ROOT_GO`

Date: 2026-07-24.

No Lean, Lake, compiler, axiom-audit, semantic, or extension command was
invoked while preparing this review.

## 1. Custody

The local branch `codex/hilo2-f3-pilot-repair-v3` forks exactly from the final
v2 STOP:

```text
v3 parent = a37a4ebd975c12846d12264be59f37f374ba7ef4
v2 run report sha256 =
497c78b1fc3df89c3b40ff08c771bfbb926cafae38165e31114e3de92fb8676d
v2 raw compile log sha256 =
d1163ebb2de79f0dbbbb0affef58fab834a602cee5b0c1af535586cccb2aa8ef
```

Neither immutable v2 artifact appears in the v3 diff.

The new execution contract is:

```text
F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V3_CONTRACT_v1.md sha256 =
2f8724c455920d11b99b3dd2474fff283a8a3ef96b7991d318b2d81ec4c379d0
```

## 2. Exact minimal-diff invoice

Against `a37a4eb`, the Lean delta is exactly one file, one proof hunk, four
insertions and one deletion:

```diff
@@ theorem pilotFrozenPos_agrees (e : PilotFormulaEdge) :
-  | retarded i => rfl
+  | retarded i =>
+      change
+        (pilotFrozenPos (.retarded i)).1 = rowStart (fin27To243 i)
+      simp only [pilotFrozenPos, rowStart, fin27To243]
```

There are no other Lean hunks.  In particular:

- theorem and definition declaration headers are byte-identical;
- the statement of `pilotFrozenPos_agrees` is byte-identical;
- all other proof branches are byte-identical;
- all definitions, inductive types, executable data, channel formulae, ranks,
  lists, codec formulae and matrix constructions are byte-identical; and
- no result artifact, audit source, inventory, checker, dependency, first-hit
  contract, or prior contract is edited.

The v3 mechanism is exactly the explicit normalization proposed in Section 7
of the final v2 report.  It introduces no new lemma or declaration.

## 3. Frozen hashes and environment preflight

```text
v2 stopped source sha256 =
80be816012ebc0da09b1e86bfaa5c4eb482ccb5dbd7f4b4913d117ce9c1f408c

v3 prepared source sha256 =
44796367e408b40a42752587c8dde64af899731bec59f68765cdbb59266c7750

unchanged audit sha256 =
a8e05246e9726afb79c25e206a90f86b12a50a0803251c50cf8b856eae40e0f1

unchanged inventory sha256 =
611bfc53a028e224c71ceb9287a01dd3587e9300e889c7facbb21fb5183ce74f

unchanged checker sha256 =
18d2e368b5e73519ec5d701cee59177982bc1f6a750b1b5546d8568866761e9e

ExactCoreMatrix source sha256 =
58ab7b1acdb7bc6d69fffa04c4baa7ae29ac31e24e80834387974113b70d2ba5

donor ExactCoreMatrix olean sha256 =
34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798

donor lake-manifest.json sha256 =
230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b

first-hit contract sha256 =
b5f022271bbd696df2a1b2e9205a36d8ad134e058fe29adbf5b1565f167c44fa

budget document sha256 =
9f9bce6e8ed3a227a21e4f1890f54e78c8c670ba7b2e045adefac9abeb0d4b04
```

The donor dependency exists at the frozen path.  Before execution all four
local repair/audit `.olean` and `.ilean` targets are absent.

## 4. Static coverage audit

The unchanged non-Lean inventory checker returned:

```text
ALL_EXPLICIT_SOURCE_DECLARATIONS=151
EXPLICIT_INVENTORY_DECLARATIONS=151
EXPLICIT_AUDIT_COMMANDS=151
SOURCE_INVENTORY_DIFF=EMPTY
INVENTORY_AUDIT_DIFF=EMPTY
DUPLICATES=NONE
PRIVATE_EXPLICIT_DECLARATIONS=NONE
FINAL_PUBLIC_THEOREMS_IN_AUDIT=12_OF_12
ENVIRONMENTAL_NAMESPACE_ENUMERATOR=PRESENT_NOT_EXECUTED
GENERATED_NAMESPACE_ENUMERATION=DEFERRED_TO_CONDITIONAL_AUDIT
AUDIT_IMPORT_NAMESPACE=REPAIR_MODULE
FORBIDDEN_SOURCE_SYNTAX=ABSENT
STATIC_EXPLICIT_INVENTORY_CHECK=PASS
```

Manual review of the sole proof hunk and an exact forbidden-syntax scan find
no `native_decide`, `Lean.ofReduceBool`, `sorry`, `admit`, explicit `axiom`,
table, lookup, finite source catalogue, literal expected RHS, `find?`,
`HashMap`, array or CSV mechanism.

## 5. Resource and decision gates

The literal resource contract remains:

```text
maxHeartbeats = 200000
wall ceiling including import = 300 s
processes = 1
compile attempts = 1
audit attempts = 1 iff compile PASS
retry/edit/resource escalation after failure = forbidden
audit coverage = every explicit declaration plus every declaration found in
                 the imported namespace
forbidden axiom profiles = Lean.ofReduceBool, sorryAx
```

The human authorization has been recorded, but execution is not open.  Two
orchestration conditions remain mandatory: root confirmation that the
publication phase completed or was formally blocked, followed by an explicit
`GO F3 V3` against the future frozen v3 custody commit.  After that message, a
new run report must be frozen and committed before the single invocation.

## 6. Residual risk and verdict

The v2 error was a definitional-normalization failure of bare `rfl`.  The v3
candidate exposes the intended RHS wrapper and unfolds only the three named
definitions.  Static inspection makes this the narrowest mechanism already
predeclared by the v2 postmortem, but does not establish that Lean will accept
the `change` or close the goal.  Only the single gated compilation can decide
that question.

```text
STATIC_V3_PREPARATION = PASS
LEAN_INVOCATIONS = 0
LAKE_INVOCATIONS = 0
AUDIT_INVOCATIONS = 0
V2_STOP_MUTATION = NONE
STATEMENTS_CHANGED = 0
DEFINITIONS_CHANGED = 0
DATA_CHANGED = 0
LEAN_PROOF_HUNKS = 1
SOURCE_DIFF = +4/-1
EXECUTION = BLOCKED_PENDING_PUBLICATION_GATE_AND_ROOT_GO
NO_RETRY
NO_243_SOURCE_EXTENSION
NO_SEMANTIC_FIRST_HIT_EXECUTION
```
