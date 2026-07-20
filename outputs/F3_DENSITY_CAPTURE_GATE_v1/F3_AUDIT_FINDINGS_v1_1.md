# F3 Density Capture Gate — findings de auditoría v1.1

Fecha: 2026-07-21.

## Dictamen

El estado global permanece:

```text
RESEARCH_GRADE_UNKNOWN
EMPIRICAL_NOT_PROVED
PAPER_GATE_OPEN
NO_LEAN
```

El expediente es apto como registro de exploración. Todavía no es un paquete
auditor-grade completo de E1–E5 porque los cuatro scripts originales, sus
outputs y manifiestos no fueron entregados ni aparecen en el workspace.

## Calibración por experimento

### E1

Se conserva la observación finita de densidad aparente. “Idéntico” debe leerse
con la corrección explícita:

```text
pi*(1,x) = pi*(8,x) + 3
```

cuando la partición relevante y \(x\ge8\) aplican; los cocientes difieren en
\(3/x\). No se infiere límite ni densidad asintótica.

### E2

La muestra demuestra heterogeneidad extrema y un mínimo observado pequeño.
No demuestra que un ínfimo sobre todas las raíces “decaiga sin fondo”. La
frase “clavada ~0.002 (no converge)” se sustituye por “no se observó rebote en
las escalas ensayadas”; la estabilidad finita no decide convergencia.

### E3

Los ratios cercanos a 2 son válidos como medición de ampliación de ventana
sobre una familia fija de raíces. No son todavía la tasa de un operador
cerrado: las filas D1/D2/D3 envían la masa a imágenes afines estrictas, no a
las clases completas usadas en \(S_m\).

### E4

“Cola de contribución pequeña en esta muestra y escala” es aceptable. “Cola
despreciable” y “riqueza predecible” quedan como conjeturas. La firma de cinco
casos requiere frecuencia base, estabilidad multiescala y validación fuera de
muestra.

### E5

El 99.9013% se reproduce exactamente. Su shortfall se descompone en:

```text
0.0115114938%  atomo determinista omitido
0.0871584527%  perdida de ventana advanced
0.0986699464%  shortfall total E5
```

En \(y=7..12\), la pérdida advanced observada llega a 0.113881902% del
target. Por ello 0.1% no se usa como cota uniforme.

## Hallazgo estructural nuevo

Un estado basado solo en un residuo módulo fijo \(M=2^\ell3^k\) no determina
el hijo advanced. Los tres lifts del mismo tipo padre producen tres tipos hijo
distintos. Esto convierte el blocker de “redistribución rica/flaca” en una
obligación concreta:

```text
control unilateral de masa entre los tres lifts 3-adicos
o
prefijo 3-adico dinamico con una cola certificada
```

Un simple refinamiento fijo módulo 27, 81 o cualquier otro \(3^k2^\ell\) no
resuelve la obligación determinísticamente.

## Claims no autorizadas

```text
NO_DENSITY_THEOREM
NO_INFIMUM_ASYMPTOTIC
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_UNIFORM_0_1_PERCENT_BOUND
NO_RHO_CERTIFICATE
NO_LITERATURE_ABSENCE_CLAIM
```

La frase “no existe en literatura” requiere una búsqueda primaria separada.
Hasta entonces: “no se dispone en este proyecto de un lema de redistribución
que cierre el sistema”.

## Gate de continuación

Solo procede el piloto de balance de los tres lifts con tipos y umbrales
predeclarados. Si no produce una desigualdad unilateral en un ledger común,
F3 se clasifica `STOP` y no entra en Lean.

