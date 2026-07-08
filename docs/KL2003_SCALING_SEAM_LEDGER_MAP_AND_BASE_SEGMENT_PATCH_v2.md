# KL2003_SCALING_SEAM_LEDGER_MAP_AND_BASE_SEGMENT_PATCH_v2

Fecha: 2026-07-09.

Estado: patch documental del scaling seam. No se crea Lean, no se modifica el
certificado y no se ejecuta otro scan empirico.

## Clasificacion

```text
SCALING_SEAM_LEDGER_MAP_CORRECTED
ROUNDING_CHARGE_BY_CALLER_ROW
ROW25_ADVANCED_ROUNDING_IMMUNE
C25_THREAT_RECLASSIFIED_AS_DIAGNOSTIC_ARTIFACT
ROW22_ROW28_THRESHOLDS_RECORDED
BASE_SEGMENT_WIDENING_DEFINED
DELTA_RENORMALIZATION_DEFINED
M0C_READY_BY_DESIGN
NO_NEW_LEAN
NO_M0C_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Correccion Principal

La lectura anterior del test empirico cargaba la perdida advanced segun la
clase residual del child:

```text
c % 9 = 2 -> c22
c % 9 = 5 -> c25
c % 9 = 8 -> c28
```

Ese mapa era util como diagnostico, pero no es el ledger correcto.

Mapa corregido:

```text
perdida advanced carga contra la fila del caller/root

a % 9 = 2 -> row22
a % 9 = 8 -> row28
a % 9 = 5 -> no advanced rounding charge
```

La razon es estructural: row25/D2 es single-branch en el sistema EL consumido
por M0C. Su rama retardada usa:

```text
xRet := x
```

y por tanto:

```text
perdida retardada = 0
```

Luego:

```text
D2_slack = 271/729000
```

no se usa para absorber redondeo advanced.

## Reinterpretacion Del Test Empirico

Lectura preservada:

```text
total_rows = 1109082
core_nat_ok_count = 1109019
core_nat_fail_count = 0
core_nat_skipped_count = 63
mismatch_count = 0
```

El core Nat queda reconfirmado en el grid.

Lectura corregida:

```text
C25_BUDGET_THREAT_SIGNAL
```

queda reclasificada como:

```text
ARTIFACT_OF_CHILD_CLASS_CHARGE_MAP
```

La normalizacion:

```text
advanced_floor_loss / x
```

se mantiene como senal diagnostica, no como criterio formal de cierre.

## Umbrales De Absorcion

Condicion documental:

```text
coef_advanced * gamma / xAdv <= slack(row)
```

Umbrales indicados:

```text
row22 absorbe cuando xAdv >= 128
row28 absorbe cuando xAdv >= 37
```

Estos umbrales deben verificarse racionalmente antes del cierre Lean del
ledger. En particular, esta nota no afirma que ya esten formalizados.

No hay umbral row25 para advanced rounding, porque row25 no consume esa rama.

## Base Segment Widening

Para ventanas pequenas:

```text
row22: xAdv < 128
row28: xAdv < 37
```

no se fuerza absorcion por slack. Se cubren por un segmento base ensanchado.

Diseno registrado:

```text
base segment aproximadamente y in [0,14]
profundidad EL <= 5
Cmax = 2
lambda = 27/20
Delta := 1 / (Cmax * lambda^14)
       = 1 / (2 * (27/20)^14)
       = (20/27)^14 / 2
```

`Delta` es positivo y racional/interval-computable. La descarga formal exacta
queda pendiente.

## M0C Readiness

M0C queda listo por diseno porque:

```text
filas abstractas EL fijadas
medida retardedRank fijada
base segment ensanchado
redondeo advanced solo afecta row22/row28 con umbrales
row25 no paga advanced rounding
```

No se reclama:

```text
M0C probado
ledger formal Lean cerrado
umbrales 128/37 formalizados
M0 theorem
M1 theorem
claim global de Collatz
```

## Archivos

Actualizado:

```text
docs/KL2003_SCALING_SEAM_PAPER_DRAFT_v1.md
```

Creado:

```text
docs/KL2003_SCALING_SEAM_LEDGER_MAP_AND_BASE_SEGMENT_PATCH_v2.md
```

## Resultado

```text
SCALING_SEAM_LEDGER_MAP_CORRECTED = yes
ROUNDING_CHARGE_BY_CALLER_ROW = yes
ROW25_ADVANCED_ROUNDING_IMMUNE = yes
C25_THREAT_RECLASSIFIED_AS_DIAGNOSTIC_ARTIFACT = yes
ROW22_ROW28_THRESHOLDS_RECORDED = yes
BASE_SEGMENT_WIDENING_DEFINED = yes
DELTA_RENORMALIZATION_DEFINED = yes
M0C_READY_BY_DESIGN = yes
NO_NEW_LEAN = yes
NO_M0C_PROOF = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
