# KL2003_SCALING_SEAM_ROUNDING_EMPIRICAL_TEST_v1

Fecha: 2026-07-08.

Estado: test empirico del scaling seam/rounding ledger. No se abre Lean, no se
modifican modulos Lean y no se cambia el certificado.

## Clasificacion

```text
SCALING_SEAM_EMPIRICAL_TEST_COMPLETED
CORE_NAT_INEQUALITY_RECONFIRMED
ROUNDING_LEDGER_EMPIRICAL_SIGNAL
C25_RISK_MEASURED
DEFINITIVE_BUDGETS_USED
NO_LEAN
NO_M0C
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Senales diagnosticas adicionales:

```text
ROUNDING_NORMALIZATION_UNDEFINED
C25_BUDGET_THREAT_SIGNAL under normalization_candidate = advanced_floor_loss / x
```

Estas dos no son un contraejemplo Nat y no cierran el ledger formal; solo
indican que la normalizacion candidata es demasiado fuerte o que falta una
absorcion/base-segment mas fina.

## Artefactos

Script:

```text
scripts/kl2003_scaling_seam_rounding_empirical_v1.py
```

Outputs:

```text
outputs/KL2003_SCALING_SEAM_ROUNDING_EMPIRICAL_v1/summary.json
outputs/KL2003_SCALING_SEAM_ROUNDING_EMPIRICAL_v1/grid.csv
outputs/KL2003_SCALING_SEAM_ROUNDING_EMPIRICAL_v1/mismatch.csv
outputs/KL2003_SCALING_SEAM_ROUNDING_EMPIRICAL_v1/c25_cases.csv
outputs/KL2003_SCALING_SEAM_ROUNDING_EMPIRICAL_v1/manifest_sha256.csv
```

Manifest:

```text
script sha256  = 7ee05de44e67e86a9904f2f7f16d1d2cb468aa219ab7c88d0f8490207ada656b
summary sha256 = 21b08b78a6adeaccd50b1a45b94543cfa03f4684f8d3ae2d787ae6680606da96
grid sha256    = f29506c71c6d6ef2ab6d739944ea54fd413cd637ecb562fbcd31027c830bca02
c25 sha256     = 6716d4cb5a5cbe1b97593a3ed6935e70fb9da1afb198e1708780bd353c814180
```

## Grid

Rango ejecutado:

```text
a in [1, 500]
a % 9 in {2, 5, 8}
x in [a, min(10000, 32*a)]
```

Filas:

```text
total_rows = 1109082
grid.csv lines = 1109083 including header
```

El script usa la semantica M0A por arbol inverso acotado con `path_max`: un
nodo cuenta para `piStar(root,x)` si el maximo de la ruta inversa desde `root`
hasta ese nodo es `<= x`.

## Ventanas

Para cada fila:

```text
xRet = x
qAdv = ceil(x/(2*a))
xAdv = x - qAdv
```

Se verifica:

```text
xRet <= x
xAdv <= x
c <= xAdv cuando c existe
```

Resultado:

```text
advanced_usable_count = 1109082
advanced_not_usable_count = 0
```

Aqui `advanced_usable` significa solo la condicion Nat `c <= xAdv`; no significa
que la rama advanced sea consumible por el ledger phi en D2.

## Core Nat

Presupuestos definitivos usados:

```text
D1 = 29/9720
D2 = 271/729000
D3 = 2077/145800
```

Resultado de desigualdades Nat:

```text
core_nat_ok_count = 1109019
core_nat_fail_count = 0
core_nat_skipped_count = 63
mismatch_count = 0
```

Las 63 filas saltadas corresponden al root `a = 2`, donde no aplica la
hipotesis formal `NotInCycle a`. No se cuentan como fallos.

`mismatch.csv` contiene solo cabecera.

## Redondeos

El test fija:

```text
target_floor_loss = 0
```

porque el grid toma `x` como ventana Nat objetivo. Para la rama advanced se
mide:

```text
advanced_floor_loss =
  x * (2*a - 1)/(2*a) - (x - ceil(x/(2*a)))
```

Resultado:

```text
max_target_floor_loss = 0
max_advanced_floor_loss = 999/1000
```

Normalizacion candidata usada para diagnostico:

```text
normalized_loss_candidate = advanced_floor_loss / x
```

Esta normalizacion no esta formalmente fijada. Por tanto las comparaciones de
budget no son teoremas y no deben registrarse como PASS/FAIL formal del
ledger.

## Senal Por Fila

Maximos aplicables por fila:

```text
D1 max normalized loss = 1/22
  worst: a=11, x=11, c=7

D2 max normalized loss = 1/10
  worst: a=5, x=5, c=3

D3 max normalized loss = 1/16
  worst: a=8, x=8, c=5, c mod 9 = 5
```

Comparacion diagnostica con presupuestos:

```text
D1 margin = 29/9720 - 1/22       = -4541/106920
D2 margin = 271/729000 - 1/10    = -72629/729000
D3 margin = 2077/145800 - 1/16   = -14071/291600
```

Conclusion diagnostica:

```text
candidate_fits_budget = false for D1, D2, D3
```

Esto no contradice las desigualdades Nat; solo dice que la normalizacion
`loss/x` no puede cerrar el ledger por si sola en este grid.

## C25 / D2

Casos marcados como `c25_or_d2_case`:

```text
c25_case_count = 498222
c25_cases.csv lines = 498223 including header
advanced_c25_case_count = 125346
d2_row_count = 372876
```

Peor caso D2/c25 bajo la normalizacion candidata:

```text
a = 5
x = 5
row = D2
c = 3
c mod 9 = 3
advanced_floor_loss = 1/2
normalized_loss_candidate = 1/10
budget used = D2 = 271/729000
margin = -72629/729000
```

Peor caso advanced class `c25`:

```text
a = 8
x = 8
row = D3
c = 5
c mod 9 = 5
advanced_floor_loss = 1/2
normalized_loss_candidate = 1/16
```

Conclusion:

```text
C25_RISK_MEASURED = yes
C25_BUDGET_THREAT_SIGNAL under diagnostic normalization = yes
```

No se declara que el ledger formal falle, porque la normalizacion final sigue
abierta.

## Comandos Ejecutados

```text
python3 -m py_compile scripts/kl2003_scaling_seam_rounding_empirical_v1.py
python3 scripts/kl2003_scaling_seam_rounding_empirical_v1.py
python3 -m py_compile scripts/kl2003_scaling_seam_rounding_empirical_v1.py
python3 scripts/kl2003_scaling_seam_rounding_empirical_v1.py
```

Se ejecuto una segunda vez despues de separar los maximos all-grid de los
maximos aplicables, para no usar el root ciclico `a=2` en el margen D1.

## No Objetivos

```text
No se abre Lean.
No se modifica ningun modulo Lean.
No se cambia el certificado.
No se abre M0C.
No se prueba M1.
No se reclama ningun resultado global de Collatz.
```

## Resultado

```text
SCALING_SEAM_EMPIRICAL_TEST_COMPLETED = yes
CORE_NAT_INEQUALITY_RECONFIRMED = yes
ROUNDING_LEDGER_EMPIRICAL_SIGNAL = yes
C25_RISK_MEASURED = yes
DEFINITIVE_BUDGETS_USED = yes
NO_LEAN = yes
NO_M0C = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
