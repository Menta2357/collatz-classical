# F3 arithmetic-codec pilot repair contract v1

Status: `FROZEN_FOR_STATIC_IMPLEMENTATION — EXECUTION_NOT_AUTHORIZED`

Date: 2026-07-24.

## 1. Immutable provenance

The repair starts from the remote branch state

```text
origin/codex/f3-density-capture-gate =
  ed31d76c607092e89696f9b5b0daf0273590798e
```

The failed source, audit source, reports and returned logs were copied
byte-for-byte from the original worktree and committed separately before any
repair.  In particular:

```text
failed pilot source sha256 =
  ce072461c6283044a651fd576df5342b0890981b26f776e3023413640d906230
failed audit source sha256 =
  c83c174b8e3ac61043f1054e0179b2e7b0dd936cea0c84b45e245f612ac03cf6
failed report v2 sha256 =
  63a45a2ac545c3536166abd4bc0ada6a13bcf174be309a2ebfb6bf191f97e7cb
```

The repaired pilot uses new module names.  It does not overwrite either
failed Lean source.

## 2. Reconciliation of the wall-clock contract

Section 7 of `F3_CORE_ARITHMETIC_CODEC_SATURATION_DESIGN_v1.md` recorded an
obsolete 120-second total ceiling.  The independently measured cold import
cost was 116.75 seconds, so that ceiling did not represent the intended
elaboration budget.  The approved pre-execution recalibration in
`F3_CORE_ARITHMETIC_CODEC_PILOT_BUDGET_v2.md` is controlling:

```text
maxHeartbeats = 200000
total wall ceiling = 300 s
processes = 1
execution = sequential
compile attempts = 1
audit attempts = 1, if and only if compile exits 0
retry of the same frozen source = forbidden
resource increase after failure = forbidden
raw stdout and stderr capture = mandatory
```

The 300-second ceiling includes import and elaboration.  It is not 300 seconds
in addition to a separately prepaid import.  Nothing in this contract
authorizes execution; a heavy-compilation slot must be granted separately.

## 3. Fixed repair invoice

The failed elaboration produced six proof-engineering classes:

1. construct the `Fintype CoreCode` instance from the arithmetic equivalence;
2. split arithmetic closure into named bounds and congruence lemmas;
3. prove rank/unrank inverses with branch-local `simp only` and extensionality;
4. remove tactic tails that run after a goal has already closed;
5. replace the dependent `List.get` rewrite by an equality-transport-safe
   positional proof;
6. transport matrix folds through `List.Perm` using a separately proved
   commutative fold lemma.

No lookup table, generated source catalogue, `find?`, `HashMap`, array lookup,
CSV lookup, literal expected edge list, source case table, or native decision
proof is an admissible repair.

## 4. Static acceptance

Static review passes only if all of the following hold:

- codec and target maps remain formula-defined;
- eligibility is carried by `DirectSource` and `LiftSource`;
- rank/unrank cardinality does not inspect the frozen edge list;
- the sole frozen comparison is the declared positional normalization;
- inclusion plus `Nodup` plus matching length yields `List.Perm`;
- matrix equality is derived from the permutation and additive
  commutativity;
- there is no `native_decide`, `Lean.ofReduceBool`, `sorry`, `admit`, `axiom`,
  or opaque F3 identity assumption in the repaired sources;
- the axiom-audit module names every declaration introduced by the repaired
  module, not merely its final theorems.

Static PASS label:

```text
ARITHMETIC_CODEC_REPAIR_STATIC_PASS_AWAITING_HEAVY_SLOT
```

## 5. Runtime acceptance and STOP

A future authorized execution is GO only if the single compile exits zero
within both limits and the subsequent total-coverage audit exits zero with no
public dependency on `Lean.ofReduceBool` or `sorryAx`.

The expected public profile is a subset of

```text
[propext, Classical.choice, Quot.sound]
```

Any compile error, timeout, heartbeat exhaustion, incomplete audit coverage,
forbidden axiom, placeholder, lookup representation or literal expected RHS
is:

```text
ARITHMETIC_CODEC_REPAIR_STOP_AND_RECORD
```

There is no automatic retry and no authorization for the 243-source
extension.

## 6. Non-claims

```text
NO_COMPILE_PASS_YET
NO_AXIOM_AUDIT_PASS_YET
NO_FULL_CORE_IDENTITY
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
```
