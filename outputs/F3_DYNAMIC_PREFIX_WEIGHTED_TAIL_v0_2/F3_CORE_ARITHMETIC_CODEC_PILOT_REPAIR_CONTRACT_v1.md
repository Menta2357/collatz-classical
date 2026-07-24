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
`F3_CORE_ARITHMETIC_CODEC_PILOT_BUDGET_v2.md` supplies the controlling resource
envelope:

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

`F3_CORE_ARITHMETIC_CODEC_PILOT_BUDGET_v2.md` controls only those resource
figures: 300 seconds, 200000 heartbeats and one sequential process.  Its
frozen source hashes and attempt authorization belong to the failed pilot;
that old attempt was spent and cannot be reused.  The present Repair contract,
the current source hashes and the static freeze/review control the new files
and the separately granted single repair attempt.

The 300-second ceiling includes import and elaboration.  It is not 300 seconds
in addition to a separately prepaid import.  Nothing in this contract
authorizes execution; a heavy-compilation slot must be granted separately.
At the successor HEAD the historical design file is explicitly labelled
`SUPERSEDED_FOR_EXECUTION`; its preserved 120-second text has no concurrent
authority.  This 300-second contract is the only live execution budget.

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
- the axiom-audit module names every explicit public top-level `def`,
  `theorem`, named `instance`, `abbrev`, and `inductive` introduced by the
  repaired source, not merely selected theorems;
- the designated final public theorem set is frozen as
  `decode_encode`, `encode_decode`, `coreCode_card`,
  `directTarget_closed_form`, `liftTarget_closed_form`, `realize_injective`,
  `formulaEdge_card`, `pilotFormulaEdge_card`,
  `pilotFrozen_position_normalization`, `pilotFrozen_perm_formula`,
  `pilot_frozen_scope`, and `pilot_matrix_eq_formulaMatrix`, and every member
  has a `#print axioms` command;
- after those 151 commands, the same audit imports `Lean.Meta.Basic` and
  `Lean.Util.CollectAxioms`, enumerates every environment constant under
  `CollatzClassical.KL2003.F3CoreArithmeticCodecPilotRepair`, and logs
  `Lean.collectAxioms` for each one.

The 151-entry label is

```text
ALL_EXPLICIT_SOURCE_DECLARATIONS
```

not “all declarations in the elaborated module namespace.”  Constructors,
recursors, no-confusion helpers and deriving implementations created by the
elaborator are not user-authored opaque theorem claims and are not counted as
separate explicit source declarations.  If one is used by a designated final
public theorem, its axioms are traversed transitively by that theorem's
`#print axioms`.  Separately, the environmental `run_meta` closes literal
namespace coverage after elaboration by including those generated constants.
It is `PRESENT_NOT_EXECUTED` before the conditional audit and is not part of
the 151-entry precompile claim.

Static PASS label:

```text
ARITHMETIC_CODEC_REPAIR_STATIC_PASS_AWAITING_HEAVY_SLOT
```

## 5. Runtime acceptance and STOP

A future authorized execution is GO only if the single compile exits zero
within both limits and the subsequent all-explicit-source audit exits zero
with no designated final public theorem dependency on `Lean.ofReduceBool` or
`sorryAx`.  The same audit invocation must also emit exactly one
`NAMESPACE_DECLARATION_COUNT=n` line and exactly `n` `AXIOM_PROFILE` lines.
The execution-side checker must reject the log if `n = 0`, if the counts
differ, or if any environmental profile contains `Lean.ofReduceBool` or
`sorryAx`.

The expected public profile is a subset of

```text
[propext, Classical.choice, Quot.sound]
```

Any compile error, timeout, heartbeat exhaustion, missing explicit source
declaration or designated final public theorem in the audit, absent or
incomplete environmental namespace log, forbidden axiom in any logged
profile, placeholder, lookup representation or literal expected RHS is:

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
