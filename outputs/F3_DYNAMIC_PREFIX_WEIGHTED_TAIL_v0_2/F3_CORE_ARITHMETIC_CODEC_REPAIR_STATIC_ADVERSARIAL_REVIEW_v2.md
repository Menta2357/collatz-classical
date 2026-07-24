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

all-explicit-source audit:
a8e05246e9726afb79c25e206a90f86b12a50a0803251c50cf8b856eae40e0f1

historical design, marked superseded for execution:
79567ccc3c3556b13fea30be05499ff5ebfb00a50e280cc9f954693ff46e55d8

repair contract:
cd3cffcaa3a8cfec22b67f5411a01e8f79647bb4f274e1565cd333807a6ec7a4

first-hit gate contract:
b5f022271bbd696df2a1b2e9205a36d8ad134e058fe29adbf5b1565f167c44fa

declaration inventory:
611bfc53a028e224c71ceb9287a01dd3587e9300e889c7facbb21fb5183ce74f

inventory checker:
18d2e368b5e73519ec5d701cee59177982bc1f6a750b1b5546d8568866761e9e
```

Any source edit invalidates this static freeze and requires a new hash and
review before requesting execution.

The predecessor's 120-second budget is no longer concurrently live.  In the
successor copy of `F3_CORE_ARITHMETIC_CODEC_SATURATION_DESIGN_v1.md`, line 3
is `SUPERSEDED_FOR_EXECUTION — HISTORICAL_DESIGN_ONLY`, lines 5--13 name the
300-second repair contract as the sole authority, and lines 428--450 mark the
preserved Sections 7 and 8 as historical.  The exact successor file hash is
recorded above.

Authority is also separated from the spent pilot record:
`F3_CORE_ARITHMETIC_CODEC_PILOT_BUDGET_v2.md` supplies only the recalibrated
resource envelope (300 seconds, 200000 heartbeats, one process).  Its source
hashes and attempt authorization belong to the failed pilot, whose attempt is
spent.  The Repair contract plus the hashes and review in this document govern
the new sources and the separately granted single repair attempt.

## 2. Gate-zero findings

The adversarial pass found and corrected four execution-blocking defects
before any compile:

1. the copied audit imported the failed `...CodecPilot` module and opened its
   old namespace instead of the new repair;
2. the repair source opened `F3CoreArithmeticCodecPilotRepair` but originally
   closed `F3CoreArithmeticCodecPilot`;
3. the old audit listed only 25 selected theorems while the repair source now
   contains 151 explicit public source declarations;
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

## 5. All-explicit-source audit coverage

The frozen inventory contains every explicit public top-level `def`,
`theorem`, named `instance`, `abbrev` and `inductive` in the repair source.
There are no explicit private declarations.  Compiler-generated constructors,
recursors, cases/no-confusion helpers and deriving implementations are
excluded from the 151 count; both source inductive constants themselves are
included.  Consequently, the label is
`ALL_EXPLICIT_SOURCE_DECLARATIONS`, not all constants in an elaborated
namespace.

That exclusion does not create an axiom blind spot in the theorem boundary.
Generated constructors and recursors are kernel/elaborator infrastructure,
not user-authored opaque theorem claims.  A deriving implementation used by a
designated final public theorem lies in that theorem's dependency graph and
is traversed by `#print axioms`.  The checker separately requires all 12
designated final public theorems to occur in the audit: the codec inverses and
cardinality, both target closed forms, realization injectivity, full and pilot
formula cardinalities, the positional normalization, pilot permutation,
pilot scope, and pilot matrix equality.

Literal namespace coverage is now a distinct, post-elaboration layer in the
same audit.  After all 151 `#print axioms` commands, a validated `run_meta`
block enumerates every constant whose name has prefix
`CollatzClassical.KL2003.F3CoreArithmeticCodecPilotRepair`, including
generated declarations, and calls `Lean.collectAxioms` on each one.  Before
execution its honest status is `PRESENT_NOT_EXECUTED`.  In the conditional
audit log, the declared namespace count must equal the number of
`AXIOM_PROFILE` lines, and the log checker rejects any profile containing
`Lean.ofReduceBool` or `sorryAx`.

The repeatable static checker returned:

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

Thus each explicit inventoried constant has exactly one `#print axioms`
command and every designated final theorem is present.  This is static
explicit-source coverage, not an axiom PASS: those commands remain unopened
until the compile succeeds.  The environmental block is present but likewise
has not run.

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

Compile failure, timeout, heartbeat exhaustion, a missing explicit source or
designated final theorem audit command, a missing/mismatched environmental
count, or any namespace profile containing `Lean.ofReduceBool` or `sorryAx`
gives
`ARITHMETIC_CODEC_REPAIR_STOP_AND_RECORD`.  A compile PASS followed by the
all-explicit-source audit and a complete environmental log whose axiom sets
are subsets of `[propext, Classical.choice, Quot.sound]` closes only this
pilot gate.

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
