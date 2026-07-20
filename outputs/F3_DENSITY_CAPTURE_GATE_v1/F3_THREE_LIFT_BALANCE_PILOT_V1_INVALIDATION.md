# F3 — invalidación del holdout del piloto three-lift v1

Fecha: 2026-07-21.

## Veredicto

```text
V1_HOLDOUT_INVALID
GLOBAL_PARENT_ROOT_DISJOINTNESS_FAILED
NO_SCIENTIFIC_VERDICT_FROM_V1
OUTPUTS_PRESERVED_FOR_AUDIT
```

## Causa

El prerregistro v1 separó fases por el cociente \(q\) dentro de cada módulo:

```text
calibration q = 0..7
holdout q = 8..15
M = 36, 108
```

Esto garantiza disjunción dentro de un módulo, pero no entre módulos. Una raíz
puede tener un cociente pequeño en su representación módulo 108 y uno grande
en su representación módulo 36.

Auditoría global:

```text
calibration unique parent roots = 576
holdout unique parent roots     = 768
intersection                   = 192
```

Ejemplo:

```text
a = 866
calibration: M=108, class=2, r=2, t=2, q=2
holdout:     M=36,  class=2, r=2, t=0, q=8
```

## Consecuencia

Los resultados numéricos v1 se conservan, pero las etiquetas
`HOLDOUT_BALANCE_PASS` y `STOP_OR_REDESIGN` no tienen valor de holdout. No se
permite usarlos para aceptar o rechazar el lema de balance.

La corrida sí verifica que:

```text
todos los hooks aritmeticos y member-wise ejecutados pasaron
el codigo produjo las masas declaradas
el contrato hash permanecio intacto
```

Nada de eso repara la contaminación de la partición.

## Corrección permitida

V2 conserva exactamente:

```text
tipos M = {36,108}
clases = {2,8}
escalas y = {8,9,10}
freeze margin = 0.02
utility floor = 0.200
```

Solo cambia el split a dos intervalos globales disjuntos de la raíz padre. La
unidad de holdout se declara explícitamente como la raíz padre \(a\).

```text
V1_INVALIDATION_RECORDED_BEFORE_V2_HOLDOUT
NO_A_POSTERIORI_TYPE_CHANGE
NO_A_POSTERIORI_THRESHOLD_CHANGE
```

