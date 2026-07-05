# ELIAHOU1993_LOCAL_MECHANICAL_AUDIT_RUN_v1

Fecha: 2026-07-05, Europe/Madrid.

Estado: auditoria mecanica local ejecutada y completada tras resolver la falta de espacio en disco. No publicada en Forum. No registrada como audit link. No modifica archivos versionados del repo externo.

## Guardarrailes

- NO_FORUM_POST.
- NO_AUDIT_LINK.
- NO_EXTERNAL_REPO_MODIFICATION sobre codigo/archivos versionados.
- NO_GLOBAL_COLLATZ_CLAIM.

## Base

Documento base:
- `docs/ELIAHOU1993_LOCAL_MECHANICAL_AUDIT_PREP_v1.md`

Repo externo local:
- `/Users/MoiTam/Documents/Codex/2026-07-05/tarea-cc-challenge-audit-entry-phase0/work/eliahou-collatz-bounds`

Commit requerido y auditado:
- `fdb0b2e1ac0d774f4e288ffa2106785efd351563`

## Resumen ejecutivo

Clasificaciones:
- ELIAHOU_BUILD_PASS.
- NO_SORRY_ADMIT_AXIOM_UNSAFE.
- NATIVE_DECIDE_DEPENDENCIES_IDENTIFIED.
- AXIOM_AUDIT_RECORDED.
- EXTERNAL_REPO_NOT_MODIFIED sobre archivos versionados.
- FORUM_NOT_POSTED.
- AUDIT_LINK_NOT_CREATED.
- NO_GLOBAL_COLLATZ_CLAIM.

Resultado:
- `lake exe cache get` PASS tras reintento con red permitida y `LC_ALL=C`.
- `lake build` PASS: `Build completed successfully (8030 jobs).`
- `rg` no encuentra `sorry`, `admit`, `axiom` ni `unsafe` en archivos Lean.
- `#print axioms eliahou_bound` registra dependencia en `Lean.ofReduceBool` y `Lean.trustCompiler`, coherente con el uso de `native_decide` en facts numericos cerrados.
- El repo externo queda `git status --short` limpio; `.lake` es artefacto ignorado.

Nota ambiental:
- Un intento anterior habia fallado por `No space left on device`.
- Tras borrar solo los `tmp_pack_*` que Git reportaba como garbage en `/Users/MoiTam/Documents/.git/objects/pack`, se recupero espacio suficiente.
- El resultado mecanico vigente es el PASS documentado abajo.

## Commit y limpieza

Comando:

```bash
git rev-parse HEAD
```

Output:

```text
fdb0b2e1ac0d774f4e288ffa2106785efd351563
```

Comando:

```bash
git status --short
```

Output inicial:

```text
```

Output final:

```text
```

Interpretacion:
- commit exacto confirmado;
- repo externo clean en terminos de Git antes y despues;
- `.lake` fue creado/usado como artefacto de ejecucion ignorado por Git;
- no se tocaron archivos versionados del repo externo.

## Cache

Primer reintento tras liberar espacio:

```bash
env LC_ALL=C lake exe cache get
```

Resultado inicial en sandbox: FAIL, exit code 1.

Output:

```text
info: mathlib: cloning https://github.com/leanprover-community/mathlib4.git
error: external command 'git' exited with code 128
```

Interpretacion:
- fallo ambiental de red/sandbox al clonar Mathlib, no fallo de Lean.

Reintento con red permitida:

```bash
env LC_ALL=C lake exe cache get
```

Resultado: PASS, exit code 0.

Output relevante:

```text
info: mathlib: cloning https://github.com/leanprover-community/mathlib4.git
info: mathlib: checking out revision '8f9d9cff6bd728b17a24e163c9402775d9e6a365'
info: plausible: cloning https://github.com/leanprover-community/plausible
info: plausible: checking out revision '55c8532eb21ec9f6d565d51d96b8ca50bd1fbef3'
info: LeanSearchClient: cloning https://github.com/leanprover-community/LeanSearchClient
info: LeanSearchClient: checking out revision 'c5d5b8fe6e5158def25cd28eb94e4141ad97c843'
info: importGraph: cloning https://github.com/leanprover-community/import-graph
info: importGraph: checking out revision '85b59af46828c029a9168f2f9c35119bd0721e6e'
info: proofwidgets: cloning https://github.com/leanprover-community/ProofWidgets4
info: proofwidgets: checking out revision 'be3b2e63b1bbf496c478cef98b86972a37c1417d'
info: aesop: cloning https://github.com/leanprover-community/aesop
info: aesop: checking out revision 'f642a64c76df8ba9cb53dba3b919425a0c2aeaf1'
info: Qq: cloning https://github.com/leanprover-community/quote4
info: Qq: checking out revision 'b8f98e9087e02c8553945a2c5abf07cec8e798c3'
info: batteries: checking out revision '495c008c3e3f4fb4256ff5582ddb3abf3198026f'
info: Cli: cloning https://github.com/leanprover/lean4-cli
info: Cli: checking out revision '4f10f47646cb7d5748d6f423f4a07f98f7bbcc9e'
Fetching ProofWidgets cloud release... done!
Current branch: HEAD
Using cache (Azure) from origin: leanprover-community/mathlib4
No files to download
Decompressing 8007 file(s) (3 already decompressed)
Decompressed in 10293 ms
Completed successfully!
```

Post-cache disk/artifact state:

```text
Filesystem     Size   Used  Avail Capacity
/dev/disk3s5  460Gi  409Gi   18Gi    96%
```

```text
6.8G    .lake
5.9G    .lake/packages/mathlib/.lake/build
```

## Build

Comando:

```bash
env LC_ALL=C lake build
```

Resultado: PASS, exit code 0.

Output exacto relevante:

```text
✔ [8026/8030] Built Collatz.Defs (285s)
✔ [8027/8030] Built Collatz.ProductFormula (301s)
✔ [8028/8030] Built Collatz.Sandwich (376s)
✔ [8029/8030] Built Collatz.ContinuedFractions (354s)
Build completed successfully (8030 jobs).
```

Post-build disk/artifact state:

```text
Filesystem     Size   Used  Avail Capacity
/dev/disk3s5  460Gi  409Gi   15Gi    97%
```

```text
6.9G    .lake
```

Interpretacion:
- ELIAHOU_BUILD_PASS confirmado localmente en el commit auditado.
- El fallo anterior fue ambiental por espacio insuficiente.
- El build completo verifica los targets locales `Collatz.Defs`, `Collatz.ProductFormula`, `Collatz.Sandwich` y `Collatz.ContinuedFractions`.

## Text scans

NO_SORRY_ADMIT_AXIOM_UNSAFE: yes.

Comandos:

```bash
rg -n "\bsorry\b" . --glob '*.lean'
rg -n "\badmit\b" . --glob '*.lean'
rg -n "\baxiom\b" . --glob '*.lean'
rg -n "\bunsafe\b" . --glob '*.lean'
```

Outputs:

```text
<no matches for sorry>
<no matches for admit>
<no matches for axiom>
<no matches for unsafe>
```

Exit code:
- cada `rg` sin matches retorno exit code 1, esperado para no matches.

## Native decide scan

NATIVE_DECIDE_DEPENDENCIES_IDENTIFIED: yes.

Comando:

```bash
rg -n "native_decide|decide \+revert|by decide|ofReduceBool|#print axioms" . --glob '*.lean'
```

Output:

```text
./Collatz/Defs.lean:78:@[simp] theorem collatzComp_one : collatzComp 1 = 2 := by decide
./Collatz/Defs.lean:79:@[simp] theorem collatzComp_two : collatzComp 2 = 1 := by decide
./Collatz/ContinuedFractions.lean:82:  native_decide +revert
./Collatz/ContinuedFractions.lean:88:  decide +revert
./Collatz/ContinuedFractions.lean:100:  native_decide +revert
./Collatz/ContinuedFractions.lean:106:  exact mod_cast by native_decide;
./Collatz/ContinuedFractions.lean:119:  native_decide +revert
./Collatz/ContinuedFractions.lean:130:    exact mod_cast by native_decide;
./Collatz/ContinuedFractions.lean:141:    exact mod_cast by native_decide;
./Collatz/ContinuedFractions.lean:158:  rw [ div_pow, div_le_iff₀ ] <;> exact mod_cast by native_decide;
```

Interpretacion:
- `Collatz.Defs` usa `by decide` para los dos valores basicos `collatzComp_one` y `collatzComp_two`.
- `Collatz.ContinuedFractions` usa `native_decide`/`decide +revert` para facts numericos cerrados sobre identidades Farey, desigualdades de potencias y comparaciones numericas cerradas.
- Estos usos explican la presencia de `Lean.ofReduceBool` y `Lean.trustCompiler` en el cierre axiomatico de algunos teoremas dependientes.

## Theorems centrales identificados

Lista de declarations relevantes:

```text
Collatz/ProductFormula.lean:57:theorem prod_collatzComp_eq_prod {L : ℕ} (c : CollatzCycle L) :
Collatz/ProductFormula.lean:109:theorem eliahou_product_formula {L : ℕ} (c : CollatzCycle L) :
Collatz/ProductFormula.lean:127:theorem eliahou_product_formula_real {L : ℕ} (c : CollatzCycle L) :
Collatz/Sandwich.lean:75:theorem ratio_le_log {L : ℕ} (c : CollatzCycle L) (hk : 0 < c.numOdd) :
Collatz/Sandwich.lean:87:theorem log_le_ratio {L : ℕ} (c : CollatzCycle L) (hk : 0 < c.numOdd) :
Collatz/Sandwich.lean:98:theorem eliahou_sandwich {L : ℕ} (c : CollatzCycle L) (hk : 0 < c.numOdd) :
Collatz/Sandwich.lean:106:theorem log2_three_lt_ratio {L : ℕ} (c : CollatzCycle L) (hk : 0 < c.numOdd) :
Collatz/ContinuedFractions.lean:173:theorem rational_approx_bound {k₁ L : ℕ} (hk₁ : 0 < k₁)
Collatz/ContinuedFractions.lean:206:theorem eliahou_bound {L : ℕ} (c : CollatzCycle L)
```

Statement central:

```lean
theorem eliahou_bound {L : ℕ} (c : CollatzCycle L)
    (hmin : (2 : ℕ) ^ 40 < c.minElem)
    (hk : 0 < c.numOdd) :
    17087915 ≤ L := by
  apply rational_approx_bound (by omega) hmin
    (log2_three_lt_ratio c hk) (ratio_le_log c hk)
```

Mechanical-scope interpretation:
- El theorem central del repo es la consecuencia `17087915 <= L` para `CollatzCycle L`.
- Mantiene la hipotesis adicional explicita `hk : 0 < c.numOdd`.
- Esta nota mecanica no resuelve por si sola el gap semantico statement-fidelity ya documentado sobre `L` vs `Card Omega`/periodo exacto.

## Axiom audit

Scratch file:

```text
/private/tmp/eliahou1993_axiom_audit.lean
```

Contenido:

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

Comando:

```bash
env LC_ALL=C lake env lean /private/tmp/eliahou1993_axiom_audit.lean
```

Resultado: PASS, exit code 0.

Output exacto:

```text
'eliahou_bound' depends on axioms: [propext, Classical.choice, Lean.ofReduceBool, Lean.trustCompiler, Quot.sound]
'rational_approx_bound' depends on axioms: [propext,
 Classical.choice,
 Lean.ofReduceBool,
 Lean.trustCompiler,
 Quot.sound]
'logb_three_plus_lt_conv13' depends on axioms: [propext,
 Classical.choice,
 Lean.ofReduceBool,
 Lean.trustCompiler,
 Quot.sound]
'log_bound_at_2_40' depends on axioms: [propext, Lean.ofReduceBool, Lean.trustCompiler]
'logb_three_lt_conv15' depends on axioms: [propext, Classical.choice, Lean.ofReduceBool, Lean.trustCompiler, Quot.sound]
'conv14_lt_logb_three' depends on axioms: [propext, Classical.choice, Lean.ofReduceBool, Lean.trustCompiler, Quot.sound]
'eliahou_sandwich' depends on axioms: [propext, Classical.choice, Quot.sound]
'log2_three_lt_ratio' depends on axioms: [propext, Classical.choice, Quot.sound]
'ratio_le_log' depends on axioms: [propext, Classical.choice, Quot.sound]
'log_le_ratio' depends on axioms: [propext, Classical.choice, Quot.sound]
'eliahou_product_formula_real' depends on axioms: [propext, Classical.choice, Quot.sound]
'eliahou_product_formula' depends on axioms: [propext, Classical.choice, Quot.sound]
'prod_collatzComp_eq_prod' depends on axioms: [propext, Classical.choice, Quot.sound]
```

Interpretacion:
- Teoremas no computacionales principales de product/sandwich solo muestran axiomas habituales de Mathlib/classical reasoning: `propext`, `Classical.choice`, `Quot.sound`.
- Los theorems numericos de continued fractions introducen `Lean.ofReduceBool` y `Lean.trustCompiler`.
- El theorem central `eliahou_bound` hereda esas dependencias por depender de `rational_approx_bound` y de los facts numericos cerrados.
- Esto no es un `axiom` declarado por el repo, pero si es una frontera de confianza relevante para auditoria: parte numerica via `native_decide` confia en evaluacion nativa/compilador.

## Conclusion local

La auditoria mecanica local del commit `fdb0b2e1ac0d774f4e288ffa2106785efd351563` queda completada:

- build local PASS;
- no `sorry/admit/axiom/unsafe` en archivos Lean;
- usos de `native_decide` localizados y coherentes con facts numericos cerrados;
- `#print axioms` registrado para theorem central y auxiliares;
- repo externo limpio en Git despues de la ejecucion;
- no Forum post;
- no audit link;
- no claim oficial CC;
- no global Collatz claim.

Clasificacion final:
- ELIAHOU_BUILD_PASS.
- NO_SORRY_ADMIT_AXIOM_UNSAFE.
- NATIVE_DECIDE_DEPENDENCIES_IDENTIFIED.
- AXIOM_AUDIT_RECORDED.
- EXTERNAL_REPO_NOT_MODIFIED.
- FORUM_NOT_POSTED.
- AUDIT_LINK_NOT_CREATED.
- NO_GLOBAL_COLLATZ_CLAIM.
