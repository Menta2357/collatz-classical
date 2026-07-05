# ELIAHOU1993_LOCAL_MECHANICAL_AUDIT_PREP_v1

Fecha: 2026-07-05, Europe/Madrid.

Estado: preparacion local privada para auditoria mecanica. No publicada en Forum. No registrada como audit link. No ejecuta `lake build`.

## Guardarrailes

- NO_FORUM_POST.
- NO_AUDIT_LINK.
- NO_OFFICIAL_CC_CLAIM.
- NO_GLOBAL_COLLATZ_CLAIM.
- EXTERNAL_REPO_NOT_MODIFIED.
- No se modifica el repo externo `tangentstorm/eliahou-collatz-bounds`.

## Base

Repo de notas:
- `https://github.com/Menta2357/collatz-classical`

Documentos base:
- `docs/ELIAHOU1993_FORUM_INTENTION_POST_PREP_AND_SNAPSHOT_v1.md`
- `docs/ELIAHOU1993_LOCAL_STATEMENT_FIDELITY_AUDIT_v1.md`
- `docs/ELIAHOU1993_L_VS_CARDOMEGA_BRIDGE_AUDIT_v1.md`

Repo formalizacion auditada:
- `https://github.com/tangentstorm/eliahou-collatz-bounds`
- clone local inspeccionado: `/Users/MoiTam/Documents/Codex/2026-07-05/tarea-cc-challenge-audit-entry-phase0/work/eliahou-collatz-bounds`
- commit auditado: `fdb0b2e1ac0d774f4e288ffa2106785efd351563`
- commit subject: `removed unused/unproven 'precise' reformulation`
- estado local del repo externo al preparar esta nota: clean.

## Configuracion Lean/Lake

BUILD_COMMANDS_IDENTIFIED: yes.

Toolchain:

```text
leanprover/lean4:v4.28.0
```

`lakefile.toml`:

```toml
name = "eliahou-collatz"
defaultTargets = ["Collatz"]

[[require]]
name = "mathlib"
git = "https://github.com/leanprover-community/mathlib4.git"
rev = "v4.28.0"

[[lean_lib]]
name = "Collatz"
globs = ["Collatz.+"]
```

`lake-manifest.json`:
- direct dependency: `mathlib`, input rev `v4.28.0`, resolved rev `8f9d9cff6bd728b17a24e163c9402775d9e6a365`;
- inherited dependencies include `plausible`, `LeanSearchClient`, `importGraph`, `proofwidgets`, `aesop`, `Qq`, `batteries`, and `Cli`.

Files in scope:
- `Main.lean`
- `Collatz/Defs.lean`
- `Collatz/ProductFormula.lean`
- `Collatz/Sandwich.lean`
- `Collatz/ContinuedFractions.lean`
- README/summary files only as metadata, not as proof files.

## Build plan

MECHANICAL_AUDIT_PLAN_READY: yes.

No heavy build was executed in this prep phase. The build cost is not fully known; the upstream README says Mathlib from source can take hours and recommends cache retrieval first.

Commands to run from the external repo root when mechanical audit is approved:

```bash
git status --short
git rev-parse HEAD
cat lean-toolchain
lake exe cache get
lake build
```

Notes:
- `lake exe cache get` may require network and downloads prebuilt Mathlib oleans.
- `lake build` should be run only after confirming the audited commit remains `fdb0b2e1ac0d774f4e288ffa2106785efd351563`.
- If cache retrieval is unavailable, do not silently fall back to a long Mathlib-from-source build; record the blocker and ask before spending that time.

## Lightweight text scan already performed

These scans were run over `*.lean` files only.

```bash
rg -n "\bsorry\b" . --glob '*.lean'
rg -n "\badmit\b" . --glob '*.lean'
rg -n "\baxiom\b" . --glob '*.lean'
rg -n "\bunsafe\b" . --glob '*.lean'
```

Result:
- no `sorry` in Lean files;
- no `admit` in Lean files;
- no `axiom` declarations in Lean files;
- no `unsafe` in Lean files.

Important metadata note:
- `Collatz/README.md` and `ARISTOTLE_SUMMARY.md` still mention an old `eliahou_precise`/`sorry`.
- `rg eliahou_precise` finds that name only in documentation/summary text, not in Lean code.
- The audited commit subject says the unused/unproven `precise` reformulation was removed.
- Therefore this is a README/summary freshness issue for later metadata review, not evidence of a code-level `sorry` in the current Lean files.

## Central theorems identified

CENTRAL_THEOREMS_IDENTIFIED: yes.

Central theorem, ASCII transcription of the Lean signature:

```lean
-- Collatz/ContinuedFractions.lean:206
theorem eliahou_bound {L : Nat} (c : CollatzCycle L)
    (hmin : (2 : Nat) ^ 40 < c.minElem)
    (hk : 0 < c.numOdd) :
    17087915 <= L
```

Direct driver, ASCII transcription of the Lean signature:

```lean
-- Collatz/ContinuedFractions.lean:173
theorem rational_approx_bound {k1 L : Nat} (hk1 : 0 < k1)
    {m : Nat} (hm : 2 ^ 40 < m)
    (hlower : Real.logb 2 3 < (L : Real) / k1)
    (hupper : (L : Real) / k1 <= Real.logb 2 (3 + 1 / (m : Real))) :
    17087915 <= L
```

Relevant sandwich/product chain:
- `Collatz/Sandwich.lean:75` `ratio_le_log`
- `Collatz/Sandwich.lean:87` `log_le_ratio`
- `Collatz/Sandwich.lean:98` `eliahou_sandwich`
- `Collatz/Sandwich.lean:106` `log2_three_lt_ratio`
- `Collatz/ProductFormula.lean:57` `prod_collatzComp_eq_prod`
- `Collatz/ProductFormula.lean:109` `eliahou_product_formula`
- `Collatz/ProductFormula.lean:127` `eliahou_product_formula_real`

Relevant definitions:
- `Collatz/Defs.lean:20` `collatzComp`
- `Collatz/Defs.lean:42` `CollatzCycle`
- `Collatz/Defs.lean:57` `CollatzCycle.numOdd`
- `Collatz/Defs.lean:65` `CollatzCycle.minElem`
- `Collatz/Defs.lean:72` `CollatzCycle.maxElem`

Numerical/continued-fraction facts feeding `rational_approx_bound`:
- `Collatz/ContinuedFractions.lean:81` `farey_13_15`
- `Collatz/ContinuedFractions.lean:87` `farey_14_15`
- `Collatz/ContinuedFractions.lean:93` `coprime_15`
- `Collatz/ContinuedFractions.lean:99` `three_pow_lt_two_pow_15`
- `Collatz/ContinuedFractions.lean:105` `two_pow_lt_three_pow_14`
- `Collatz/ContinuedFractions.lean:117` `log_bound_at_2_40`
- `Collatz/ContinuedFractions.lean:126` `logb_three_lt_conv15`
- `Collatz/ContinuedFractions.lean:136` `conv14_lt_logb_three`
- `Collatz/ContinuedFractions.lean:147` `logb_three_plus_lt_conv13`

## Native decide audit plan

NATIVE_DECIDE_AUDIT_PLAN_READY: yes.

Text scan for proof-by-evaluation commands:

```bash
rg -n "native_decide|decide \+revert|by decide|ofReduceBool|#print axioms" . --glob '*.lean'
```

Occurrences found:
- `Collatz/Defs.lean:78` `collatzComp_one : collatzComp 1 = 2 := by decide`
- `Collatz/Defs.lean:79` `collatzComp_two : collatzComp 2 = 1 := by decide`
- `Collatz/ContinuedFractions.lean:82` `farey_13_15` by `native_decide +revert`
- `Collatz/ContinuedFractions.lean:88` `farey_14_15` by `decide +revert`
- `Collatz/ContinuedFractions.lean:100` `three_pow_lt_two_pow_15` by `native_decide +revert`
- `Collatz/ContinuedFractions.lean:106` `two_pow_lt_three_pow_14` by `exact mod_cast by native_decide`
- `Collatz/ContinuedFractions.lean:119` `log_bound_at_2_40` by `native_decide +revert`
- `Collatz/ContinuedFractions.lean:130` `logb_three_lt_conv15` uses `exact mod_cast by native_decide`
- `Collatz/ContinuedFractions.lean:141` `conv14_lt_logb_three` uses `exact mod_cast by native_decide`
- `Collatz/ContinuedFractions.lean:158` `logb_three_plus_lt_conv13` uses `exact mod_cast by native_decide`

Audit questions:
1. Confirm each `native_decide` target is a closed numeric proposition after preceding rewrites/casts.
2. Separate tiny definitional checks (`collatzComp_one`, `collatzComp_two`) from large integer/exponential certificates.
3. Confirm the derived real-log theorems use `native_decide` only for closed Nat/Int arithmetic subgoals after `Real.log` transformations.
4. Run `#print axioms` on the central theorem and selected auxiliary facts; do not infer "standard axioms only" from README text.
5. If necessary, inspect selected proof terms for `native_decide`/`ofReduceBool` artifacts with proof printing enabled, but avoid dumping huge proof terms unless needed.
6. Record exact Lean output and toolchain version in the mechanical audit note.

Candidate classification of `native_decide` facts before build:
- closed arithmetic identity: `farey_13_15`;
- closed arithmetic identity using `decide`: `farey_14_15`;
- closed exponential Nat inequalities: `three_pow_lt_two_pow_15`, `two_pow_lt_three_pow_14`, `log_bound_at_2_40`;
- real-log lemmas whose hard numeric subgoals appear to reduce to closed Nat inequalities after rewrites: `logb_three_lt_conv15`, `conv14_lt_logb_three`, `logb_three_plus_lt_conv13`.

This classification is preparatory. Final status requires build plus `#print axioms` output.

## Axiom audit plan

Proposed scratch file outside the external repo:

```lean
import Collatz.ContinuedFractions

#print axioms eliahou_bound
#print axioms rational_approx_bound
#print axioms logb_three_plus_lt_conv13
#print axioms log_bound_at_2_40
#print axioms logb_three_lt_conv15
#print axioms conv14_lt_logb_three
#print axioms eliahou_sandwich
#print axioms log2_three_lt_ratio
#print axioms ratio_le_log
#print axioms log_le_ratio
#print axioms eliahou_product_formula_real
#print axioms eliahou_product_formula
#print axioms prod_collatzComp_eq_prod
```

Command:

```bash
lake env lean /private/tmp/eliahou1993_axiom_audit.lean
```

Notes:
- Run this after cache/build, because importing `Collatz.ContinuedFractions` may compile dependencies if oleans are missing.
- Capture exact output for each theorem.
- Expected categories to check include standard Lean/Mathlib axioms versus any unexpected local axiom. Do not predeclare the result.

## Mechanical audit checklist

Minimum checklist for the next phase:

```bash
git status --short
git rev-parse HEAD
cat lean-toolchain
lake exe cache get
lake build
rg -n "\bsorry\b" . --glob '*.lean'
rg -n "\badmit\b" . --glob '*.lean'
rg -n "\baxiom\b" . --glob '*.lean'
rg -n "\bunsafe\b" . --glob '*.lean'
rg -n "native_decide|decide \+revert|by decide|ofReduceBool|#print axioms" . --glob '*.lean'
lake env lean /private/tmp/eliahou1993_axiom_audit.lean
```

Decision gates:
- If `lake build` fails, stop and classify failure before touching code.
- If any new `sorry`/`admit`/`axiom`/`unsafe` appears at the audited commit, record exact file and line.
- If `#print axioms eliahou_bound` reports unexpected dependencies, audit those before any public claim.
- If `native_decide` creates performance or trust ambiguity, keep the audit local and report the ambiguity as mechanical scope, not as a proof rejection.

## Scope link to prior semantic audit

This mechanical prep does not change the previous statement-fidelity scope:
- the current theorem is still a partial/consequence-focused statement around `17087915 <= L`;
- exact-period/cardinality glue remains the main semantic bridge to inspect separately;
- `hk : 0 < c.numOdd` remains an added Lean hypothesis that appears derivable but is not currently internalized as a lemma;
- no Forum post and no audit link should be created from this mechanical prep alone.

## Classifications

- MECHANICAL_AUDIT_PLAN_READY: yes
- BUILD_COMMANDS_IDENTIFIED: yes
- CENTRAL_THEOREMS_IDENTIFIED: yes
- NATIVE_DECIDE_AUDIT_PLAN_READY: yes
- NO_FORUM_POST: yes
- AUDIT_LINK_NOT_CREATED: yes
- EXTERNAL_REPO_NOT_MODIFIED: yes
