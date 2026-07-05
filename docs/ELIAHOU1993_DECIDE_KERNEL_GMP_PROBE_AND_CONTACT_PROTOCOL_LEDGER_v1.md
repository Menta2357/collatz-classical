# ELIAHOU1993_DECIDE_KERNEL_GMP_PROBE_AND_CONTACT_PROTOCOL_LEDGER_v1

Fecha: 2026-07-06, Europe/Madrid.

Estado: probe tecnico y ledger de protocolo completados. No Forum post. No audit link. No issue upstream. No claim oficial. No global Collatz claim.

## Base

Notas base:
- `docs/ELIAHOU1993_LOCAL_MECHANICAL_AUDIT_RUN_v1.md`
- `docs/ELIaHOU1993_NATIVE_DECIDE_TO_NORM_NUM_PROBE_v1.md`
- `docs/ELIAHOU1993_EXACT_PERIOD_GLUE_RECOMMENDATION_v1.md`
- `docs/ELIAHOU1993_FORUM_INTENTION_POST_PREP_AND_SNAPSHOT_v1.md`
- `STATUS.md`

Repo externo local:
- `/Users/MoiTam/Documents/Codex/2026-07-05/tarea-cc-challenge-audit-entry-phase0/work/eliahou-collatz-bounds`

Commit base auditado:
- `fdb0b2e1ac0d774f4e288ffa2106785efd351563`

Nota de estado:
- El repo externo conserva el diff experimental local previo:

```diff
 theorem farey_13_15 : 301994 * 10781274 - 17087915 * 190537 = 1 := by
-  native_decide +revert
+  norm_num
```

Este cambio no fue publicado upstream.

## Guardarrailes

- NO_FORUM_POST.
- NO_AUDIT_LINK.
- NO_OFFICIAL_CLAIM.
- NO_GLOBAL_COLLATZ_CLAIM.
- NO_UPSTREAM_ISSUE_YET.

## Norm-num small Farey confirmado

NORM_NUM_SMALL_FAREY_CONFIRMED: yes.

Del probe previo:
- `farey_13_15` puede reemplazarse por `norm_num`;
- `lake build` paso con ese cambio local;
- `#print axioms farey_13_15` bajo a:

```text
'farey_13_15' depends on axioms: [propext]
```

Interpretacion:
- Al menos una identidad aritmetica cerrada pequena no necesita `native_decide`.
- Esto no elimina la frontera de confianza del theorem central.

## Decide kernel/GMP probe

Objetivo:
- probar si el hecho grande usado por `three_pow_lt_two_pow_15` compila con `by decide`.

Scratch:

```text
/private/tmp/eliahou1993_decide_kernel_gmp_probe.lean
```

Contenido:

```lean
import Mathlib

set_option maxHeartbeats 4000000

example : (3 : ℕ) ^ 10781274 < 2 ^ 17087915 := by
  decide
```

Comando:

```bash
env LC_ALL=C lake env lean /private/tmp/eliahou1993_decide_kernel_gmp_probe.lean
```

Medicion:
- tras aproximadamente 1 minuto, el proceso Lean seguia activo:

```text
lean /private/tmp/eliahou1993_decide_kernel_gmp_probe.lean
```

- justo antes del cierre, se observo:

```text
lake env lean ... 03:45
lean /private/tmp/eliahou1993_decide_kernel_gmp_probe.lean 03:29
```

Resultado final: FAIL, exit code 1.

Output exacto:

```text
/private/tmp/eliahou1993_decide_kernel_gmp_probe.lean:6:2: warning: exponent 10781274 exceeds the threshold 256, exponentiation operation was not evaluated, use `set_option exponentiation.threshold <num>` to set a new threshold
/private/tmp/eliahou1993_decide_kernel_gmp_probe.lean:6:2: error: maximum recursion depth has been reached
use `set_option maxRecDepth <num>` to increase limit
use `set_option diagnostics true` to get diagnostic information
```

Clasificacion:
- DECIDE_KERNEL_GMP_TEST_PASS: no.
- DECIDE_KERNEL_GMP_TEST_FAILS_OR_TOO_SLOW: yes.
- TRUST_BOUNDARY_POTENTIALLY_REMOVABLE_FOR_LARGE_FACTS: no, not established.
- TRUST_BOUNDARY_REMAINS: yes.

Interpretacion:
- `by decide` directo no ofrece una sustitucion viable para el hecho grande en este probe.
- El fallo no fue un contraejemplo matematico; fue un fallo de elaboracion/evaluacion por limites internos (`exponentiation.threshold` y `maxRecDepth`).
- No se ejecuto una variante forzando thresholds enormes, porque eso seria un experimento distinto y potencialmente mucho mas costoso; el test pedido de `by decide` directo no paso.

## Trust boundary

TRUST_BOUNDARY_REMAINS: yes.

Motivo:
- `eliahou_bound` seguia dependiendo de `Lean.ofReduceBool` y `Lean.trustCompiler` tras el reemplazo pequeno de `farey_13_15`;
- el test `by decide` para el hecho grande no paso;
- los hechos de potencias enormes todavia dependen de `native_decide` o pruebas derivadas de esos facts.

Referencia del axiom audit previo:

```text
'eliahou_bound' depends on axioms: [propext, Classical.choice, Lean.ofReduceBool, Lean.trustCompiler, Quot.sound]
```

Conclusion tecnica:
- Reemplazos pequenos via `norm_num` son plausibles.
- Reemplazos grandes directos via `norm_num` o `by decide` no son plausibles segun estos probes.
- Reducir la frontera de confianza para los hechos grandes probablemente requiere certificados intermedios, interval arithmetic formalizada, bounds racionales/logaritmicos, o una estrategia proof-producing mas fina que no evalúe potencias gigantes de forma monolitica.

## Contact protocol ledger

AUTHOR_FIRST_PROTOCOL_SELECTED: yes.

Decision registrada:
- Contactar primero a `tangentstorm`/maintainers con un paquete completo privado antes de publicar en Forum o abrir issue.

Motivo:
- Ya no hay solo una sospecha de statement-fidelity; hay un paquete coherente:
  - scope consequence-only plausible;
  - exact-period/cardinality glue missing;
  - `hk : 0 < c.numOdd` missing but likely derivable;
  - mechanical build PASS;
  - no `sorry/admit/axiom/unsafe`;
  - `native_decide` trust boundary identified;
  - small `norm_num` replacement works;
  - large `by decide`/`norm_num` replacements do not currently remove the trust boundary.
- Contactar primero al autor/maintainer es mas justo que publicar hallazgos parciales como veredicto publico.
- Partial formalizations are acceptable if scoped; el contacto debe abrir con respeto y pedir confirmacion del scope previsto.

STATUS.md actualizado:

```text
AUTHOR_FIRST_PROTOCOL_SELECTED
FORUM_DEFERRED_BY_RECORDED_DECISION
NO_AUDIT_LINK
NO_UPSTREAM_ISSUE_YET
NO_GLOBAL_COLLATZ_CLAIM
```

## Public actions

FORUM_DEFERRED_BY_RECORDED_DECISION: yes.

No se hizo:
- no Forum post;
- no audit link;
- no GitHub issue;
- no contacto upstream;
- no claim oficial CC;
- no global Collatz claim.

## Clasificaciones finales

- NORM_NUM_SMALL_FAREY_CONFIRMED.
- DECIDE_KERNEL_GMP_TEST_FAILS_OR_TOO_SLOW.
- TRUST_BOUNDARY_REMAINS.
- AUTHOR_FIRST_PROTOCOL_SELECTED.
- FORUM_DEFERRED_BY_RECORDED_DECISION.
- NO_AUDIT_LINK.
- NO_GLOBAL_COLLATZ_CLAIM.

No aplican como positivas:
- DECIDE_KERNEL_GMP_TEST_PASS.
- TRUST_BOUNDARY_POTENTIALLY_REMOVABLE_FOR_LARGE_FACTS.
