# F3 arithmetic-codec repair v2 static review v1

Status: `EXECUTION_NOT_AUTHORIZED_PENDING_HUMAN_GATE`

Date: 2026-07-24.

No Lean, Lake, compiler or audit command was invoked in preparing this gate.

## 1. Custody verdict

The local branch `codex/hilo2-f3-pilot-repair-v2` forks from
`ef6513aec7899ad0ab7ac896abc595e57eedb616`, the committed v1 STOP.  Static
hashing confirms that the v1 run report and raw compiler log remain:

```text
run report = 23a2a24ceda2790b8631a5d79a2fa27e63c249b9e6d90c869b3e5599d956bef4
raw log   = 619fd7361557309f4f5519f22cba5fe304ac1c00409da62f5c170446290fcfc2
```

Neither file appears in the v2 diff.

## 2. Frozen v2 hashes

```text
repair source:
80be816012ebc0da09b1e86bfaa5c4eb482ccb5dbd7f4b4913d117ce9c1f408c

unchanged audit:
a8e05246e9726afb79c25e206a90f86b12a50a0803251c50cf8b856eae40e0f1

unchanged explicit inventory:
611bfc53a028e224c71ceb9287a01dd3587e9300e889c7facbb21fb5183ce74f

unchanged checker:
18d2e368b5e73519ec5d701cee59177982bc1f6a750b1b5546d8568866761e9e

dependency source:
58ab7b1acdb7bc6d69fffa04c4baa7ae29ac31e24e80834387974113b70d2ba5

dependency donor olean:
34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798

v2 contract:
7d1fc396ad2fa1985f647207eaa300b5858594798c5c6319822191676cf927a2
```

## 3. Minimal-diff invoice

The Lean source delta against the v1 STOP is exactly:

```text
files changed = 1
proof hunks = 2
insertions = 4
deletions = 13
statement changes = 0
definition changes = 0
data changes = 0
```

| Hunk | v1 diagnostic | v2 proof mechanism |
|---|---|---|
| `encode` witness | `omega` could not see the proved modulo-nine identity through subtype projections at `55:23`, `56:31`, `57:31` | reuse `encodeNat_mod9 i` with branch-local `simpa [h0/h1/h2]`, retaining the same nested `Or` witnesses |
| `pilotFrozenPos_agrees`, retarded | three opaque arithmetic branches at `1097:20` | use the definitional identity `rfl`; no `change`, solver or enumeration added |

The mechanisms directly match the v1 postmortem.  They are proof-term
normalization changes, not mathematical strengthening.

## 4. Static audit

The unchanged checker returned:

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

Manual diff review finds no table, lookup, `find?`, `HashMap`, array/CSV
lookup, source catalogue, literal RHS, native decision proof, placeholder, or
new declaration.  The audit module and its environmental enumerator are
byte-identical to v1.

## 5. Residual risk and verdict

The `simpa` branches are tied to an already proved theorem.  The retarded
branch is syntactically the same definitional position on both sides after
unfolding the existing wrappers, so `rfl` is the smallest static mechanism.
No `change` was needed in the source text.  Because execution is forbidden,
this review does not claim that elaboration has accepted either mechanism.

The resource envelope remains 200000 heartbeats, 300 seconds total, one
process, one possible compile and one conditional audit, with no retry.  It
is merely recorded for a later decision; it is not active authorization.

```text
STATIC_V2_PREPARATION = PASS
EXECUTION = NOT_AUTHORIZED
LEAN_INVOCATIONS = 0
LAKE_INVOCATIONS = 0
V1_STOP_MUTATION = NONE
NEXT_DECISION = HUMAN_GATE
```
