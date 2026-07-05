# ELIaHOU1993_NATIVE_DECIDE_TO_NORM_NUM_PROBE_v1

Fecha: 2026-07-06, Europe/Madrid.

Estado: probe local completado. No publicado en Forum. No audit link. No issue upstream. No claim oficial. No global Collatz claim.

## Base

Nota mecanica previa:
- `/Users/MoiTam/Documents/Codex/collatz-classical/docs/ELIAHOU1993_LOCAL_MECHANICAL_AUDIT_RUN_v1.md`

Repo externo local:
- `/Users/MoiTam/Documents/Codex/2026-07-05/tarea-cc-challenge-audit-entry-phase0/work/eliahou-collatz-bounds`

Commit base:
- `fdb0b2e1ac0d774f4e288ffa2106785efd351563`

## Guardarrailes

- NO_FORUM_POST.
- NO_AUDIT_LINK.
- NO_OFFICIAL_CLAIM.
- NO_GLOBAL_COLLATZ_CLAIM.
- NO_UPSTREAM_ISSUE_YET.

## Usos localizados

Los 7 usos originales de `native_decide` en `Collatz/ContinuedFractions.lean` eran:

```text
Collatz/ContinuedFractions.lean:82:  native_decide +revert
Collatz/ContinuedFractions.lean:100:  native_decide +revert
Collatz/ContinuedFractions.lean:106:  exact mod_cast by native_decide;
Collatz/ContinuedFractions.lean:119:  native_decide +revert
Collatz/ContinuedFractions.lean:130:    exact mod_cast by native_decide;
Collatz/ContinuedFractions.lean:141:    exact mod_cast by native_decide;
Collatz/ContinuedFractions.lean:158:  rw [ div_pow, div_le_iff₀ ] <;> exact mod_cast by native_decide;
```

Hay tambien:

```text
Collatz/ContinuedFractions.lean:88:  decide +revert
Collatz/Defs.lean:78:@[simp] theorem collatzComp_one : collatzComp 1 = 2 := by decide
Collatz/Defs.lean:79:@[simp] theorem collatzComp_two : collatzComp 2 = 1 := by decide
```

## Caso grande elegido

Caso ideal escogido por tamano numerico:

```lean
theorem three_pow_lt_two_pow_15 : (3 : ℕ) ^ 10781274 < 2 ^ 17087915 := by
  native_decide +revert
```

Razon:
- compara enteros de millones de digitos;
- es uno de los facts que alimentan la prueba real de `logb_three_lt_conv15`;
- si se reemplazara por una prueba kernel-checked practica, reduciria una parte importante de la frontera `native_decide`.

Probe scratch:

```lean
import Mathlib

set_option maxHeartbeats 4000000

example : (3 : ℕ) ^ 10781274 < 2 ^ 17087915 := by
  norm_num
```

Comando:

```bash
env LC_ALL=C lake env lean /private/tmp/eliahou1993_norm_num_probe_big.lean
```

Resultado:
- no produjo resultado tras aproximadamente 2.5 minutos;
- proceso Lean seguia activo y usando CPU;
- se aborto manualmente con `kill`;
- exit code final observado: 143.

Clasificacion para el caso grande:
- NORM_NUM_TOO_SLOW_OR_FAILS.

Interpretacion:
- `norm_num` directo no parece una sustitucion practica para el caso de potencias gigantes.
- Este resultado no prueba imposibilidad: solo descarta el reemplazo naive `by norm_num` como probe local razonable.

## Reemplazo local que si funciona

Despues del fallo del caso grande, se probo un reemplazo pequeno pero real:

```diff
 theorem farey_13_15 : 301994 * 10781274 - 17087915 * 190537 = 1 := by
-  native_decide +revert
+  norm_num
```

Este cambio elimina un `native_decide` de una identidad aritmetica cerrada.

Estado tras el cambio:

```text
 M Collatz/ContinuedFractions.lean
```

El diff es local/experimental y no se publico upstream.

## Build

Comando:

```bash
env LC_ALL=C lake build
```

Resultado: PASS.

Output relevante:

```text
✔ [8029/8030] Built Collatz.ContinuedFractions (263s)
Build completed successfully (8030 jobs).
```

Clasificacion:
- NORM_NUM_REPLACEMENT_WORKS para `farey_13_15`.

## Axiom audit

Scratch:

```lean
import Collatz.ContinuedFractions

#print axioms farey_13_15
#print axioms eliahou_bound
#print axioms rational_approx_bound
#print axioms log_bound_at_2_40
```

Comando:

```bash
env LC_ALL=C lake env lean /private/tmp/eliahou1993_norm_num_probe_axioms.lean
```

Resultado: PASS.

Output exacto:

```text
'farey_13_15' depends on axioms: [propext]
'eliahou_bound' depends on axioms: [propext, Classical.choice, Lean.ofReduceBool, Lean.trustCompiler, Quot.sound]
'rational_approx_bound' depends on axioms: [propext,
 Classical.choice,
 Lean.ofReduceBool,
 Lean.trustCompiler,
 Quot.sound]
'log_bound_at_2_40' depends on axioms: [propext, Lean.ofReduceBool, Lean.trustCompiler]
```

Interpretacion:
- El theorem reemplazado `farey_13_15` ya no arrastra `Lean.ofReduceBool` ni `Lean.trustCompiler`.
- El theorem central `eliahou_bound` sigue arrastrando `Lean.ofReduceBool` y `Lean.trustCompiler`.
- La frontera de confianza permanece por los otros facts numericos con `native_decide`, especialmente desigualdades de potencias enormes.

Clasificacion:
- TRUST_BOUNDARY_REMAINS.

## Estado de native_decide tras el cambio experimental

Scan posterior:

```text
Collatz/ContinuedFractions.lean:88:  decide +revert
Collatz/ContinuedFractions.lean:100:  native_decide +revert
Collatz/ContinuedFractions.lean:106:  exact mod_cast by native_decide;
Collatz/ContinuedFractions.lean:119:  native_decide +revert
Collatz/ContinuedFractions.lean:130:    exact mod_cast by native_decide;
Collatz/ContinuedFractions.lean:141:    exact mod_cast by native_decide;
Collatz/ContinuedFractions.lean:158:  rw [ div_pow, div_le_iff₀ ] <;> exact mod_cast by native_decide;
```

Conteo:
- antes: 7 usos de `native_decide` en `ContinuedFractions`;
- despues: 6 usos de `native_decide` en `ContinuedFractions`;
- la dependencia de `eliahou_bound` en `Lean.trustCompiler` permanece.

## Conclusiones

Clasificaciones finales:
- NORM_NUM_REPLACEMENT_WORKS.
- NORM_NUM_TOO_SLOW_OR_FAILS.
- TRUST_BOUNDARY_REMAINS.
- NO_FORUM_POST.
- NO_AUDIT_LINK.
- NO_OFFICIAL_CLAIM.
- NO_GLOBAL_COLLATZ_CLAIM.
- NO_UPSTREAM_ISSUE_YET.

Conclusion local:
- Al menos un `native_decide` aritmetico pequeno puede reemplazarse por `norm_num` y pasar `lake build`.
- El caso numericamente grande elegido, `three_pow_lt_two_pow_15`, no fue viable con `norm_num` directo en este probe.
- El theorem central `eliahou_bound` sigue dependiendo de la frontera `native_decide`/compilador por los facts numericos grandes restantes.

Recomendacion tecnica:
- La mejora pequena `farey_13_15 := by norm_num` es plausible y de bajo riesgo.
- Para los facts de potencias enormes, una reduccion real de frontera de confianza probablemente requiere certificados intermedios, desigualdades logaritmicas/racionales, bitlength bounds, o una prueba por monotonicidad/interval arithmetic formalizada, no `norm_num` directo.
