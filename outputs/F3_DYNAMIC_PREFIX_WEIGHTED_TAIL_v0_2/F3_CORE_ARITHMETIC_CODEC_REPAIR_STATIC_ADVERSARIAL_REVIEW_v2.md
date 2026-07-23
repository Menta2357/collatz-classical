# F3 arithmetic-codec repair static adversarial review v2

Status: `ARITHMETIC_CODEC_REPAIR_STATIC_PASS_AWAITING_HEAVY_SLOT`

Date: 2026-07-24.

This is a static verdict only.  Neither repaired Lean module has been
compiled, no axiom command has been executed, and no `.olean` or `.ilean` for
the repair exists.

## 1. Custody and frozen inputs

The isolated branch starts from

```text
origin/codex/f3-density-capture-gate
ed31d76c607092e89696f9b5b0daf0273590798e
```

Commit `1a34239b741e68c60fd7ab298d561a6784faf091` preserves the failed pilot,
its audit sources, reports, environment records and returned logs before any
repair.  The repaired sources have new names and do not overwrite that
record.

The static freeze reviewed here is:

```text
repair source:
567d48c19b2b5bd2321e6a46b5a39dd9b54b8714adac7f6636a46405393bbf4d

total audit source:
700a321f0f70566ed2e5a8566c2329775c500f127782225f2993abf19a803cbc

repair contract:
b256d550aff5e497a66e3013bbb7812d2ffecde776b51867bdfde0376d9fa9b4

first-hit gate contract:
b5f022271bbd696df2a1b2e9205a36d8ad134e058fe29adbf5b1565f167c44fa

declaration inventory:
29bd1b22ef15148597c05d99f5bd209ac1839047abfd86c7d8c205d4c56a648d

inventory checker:
20fb2a96e142aa76225cc9767cb727eb052159ab686156e004dcab7bad22cf9c
```

Any source edit invalidates this static freeze and requires a new hash and
review before requesting execution.

## 2. Gate-zero findings

The adversarial pass found and corrected four execution-blocking defects
before any compile:

1. the copied audit imported the failed `...CodecPilot` module and opened its
   old namespace instead of the new repair;
2. the repair source opened `F3CoreArithmeticCodecPilotRepair` but originally
   closed `F3CoreArithmeticCodecPilot`;
3. the old audit listed only 25 selected theorems while the repair source now
   contains 151 explicit public declarations;
4. the symbolic `split_ifs; omega` proof of the positional decoder was still
   the exact proof block reported failing in the custodied attempt.  It is now
   a definitional exhaustive proof over the typed `Fin 27`, `Fin 9` and
   `Fin 3` pilot inputs using `fin_cases` and `rfl`.  This enumerates proof
   cases only; it introduces no edge table, lookup structure or literal RHS.

The first-hit paper contract also contained an unjustified endpoint `10369`.
That number is an older calibration/holdout boundary and is not an integral
number of fine periods.  Before inspecting first-hit data it was replaced by
the source-derived complete period

```text
P_FINE = 4 * 3^6 = 2916,
Block0 = {a | 3 <= a < 2919 and a % 3 = 2}.
```

The contract records
`NO_BLOCK0_DATA_INSPECTION_BEFORE_FREEZE = true`.  No semantic gate was run.

## 3. Repair invoice review

The six recorded elaboration classes now have distinct repairs:

1. `CoreCode` obtains its named `Fintype` from the proved arithmetic
   equivalence; the encoder constructs the three residue alternatives
   explicitly.
2. Boolean bucket branches and frozen-position arithmetic are separated into
   branch-local bounds/decompositions; the previously failing finite
   positional inverse uses definitional reduction over the declared pilot
   types.
3. Formula and pilot rank inverses now go through explicit injectivity proofs,
   avoiding the recursive simplifier paths reported in the failed attempt;
   list lengths use `List.length_ofFn` directly.
4. The two tactic tails reached after closed goals were removed.
5. The dependent `List.get` rewrite was removed.  The positional witness is
   now exposed by `pilot_frozen_at_formula`, and membership is transported via
   `List.mem_ofFn'`, so no index type contains a rewritten list length.
6. The permutation fold proof supplies the commutative step directly with
   `ac_rfl`, without the failed `dsimp` tail.

The scope proof is factored through the separate arithmetic lemma
`pilotEmbed_source_lt_27` rather than asking one terminal `omega` call to
unfold the full embedding.

## 4. Formula-versus-literal boundary

The codec, eligibility subtypes, three channels, targets, rank/unrank maps and
generated lists are all formula-defined.  Static search finds none of:

```text
native_decide  Lean.ofReduceBool  sorry  admit  explicit axiom
find?          HashMap            Array  CSV lookup
```

The sole contact with historical edge data is the named, audited theorem

```text
pilotFrozen_position_normalization :
  coreEdges.take 81 = List.ofFn pilotPositionRealize
```

proved by definitional equality.  Saturation then uses generated inclusion,
generated `Nodup`, equal length and `List.Perm`; matrix equality follows from
the permutation and addition commutativity.  This is only the 27-source,
81-edge pilot.  It is not the 243-source/729-edge identity and does not prove
the real operator identity.

## 5. Total audit coverage

The frozen inventory contains every explicit public top-level `def`,
`theorem`, named `instance`, `abbrev` and `inductive` in the repair source.
There are no explicit private declarations.  Compiler-generated constructors,
recursors, cases/no-confusion helpers and deriving implementations are
excluded as generated definitional infrastructure; both source inductive
constants themselves are included.

The repeatable static checker returned:

```text
SOURCE_DECLARATIONS=151
INVENTORY_DECLARATIONS=151
AUDIT_COMMANDS=151
SOURCE_INVENTORY_DIFF=EMPTY
INVENTORY_AUDIT_DIFF=EMPTY
DUPLICATES=NONE
PRIVATE_EXPLICIT_DECLARATIONS=NONE
AUDIT_IMPORT_NAMESPACE=REPAIR_MODULE
FORBIDDEN_SOURCE_SYNTAX=ABSENT
STATIC_INVENTORY_CHECK=PASS
```

Thus each inventoried constant has exactly one `#print axioms` command.  This
is static coverage, not an axiom PASS: those commands remain unopened until
the compile succeeds.

## 6. Execution request and decision rule

The static gate requests one heavy slot under the already frozen contract:

```text
maxHeartbeats = 200000
wall ceiling including import = 300 s
compile attempts = 1
audit attempts = 1 iff compile exits 0
sequential single process
raw stdout/stderr captured in a new repair-results directory
no retry and no resource increase after failure
```

Compile failure, timeout, heartbeat exhaustion, missing audit declaration,
or any public dependency on `Lean.ofReduceBool` or `sorryAx` gives
`ARITHMETIC_CODEC_REPAIR_STOP_AND_RECORD`.  A compile PASS followed by a total
audit whose axiom sets are subsets of
`[propext, Classical.choice, Quot.sound]` closes only this pilot gate.

```text
NO_COMPILE_PASS_YET
NO_AXIOM_AUDIT_PASS_YET
NO_243_SOURCE_EXTENSION
NO_FULL_CORE_IDENTITY
NO_SEMANTIC_FIRST_HIT_HOOK
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```
