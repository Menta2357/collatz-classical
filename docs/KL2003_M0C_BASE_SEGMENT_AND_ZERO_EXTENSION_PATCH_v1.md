# KL2003_M0C_BASE_SEGMENT_AND_ZERO_EXTENSION_PATCH_v1

Fecha: 2026-07-07.

Estado: parche documental al scoping M0C. No se crea Lean nuevo y no se
prueban desigualdades de arbol.

## Clasificacion

```text
ZERO_EXTENSION_DECISION_RECORDED
BASE_SEGMENT_WIDTH_TWO_RECORDED
DELTA_VS_BASE_WIDTH_DISTINGUISHED
DELTA_LAMBDA_MINUS_TWO_SELECTED
M0C_SCOPING_PATCHED
NO_LEAN_PROOF
NO_D1_D2_D3
NO_M0_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Guardarrailes:

```text
NO_D1_D2_D3
NO_TREE_INEQUALITY_PROOF
NO_M0_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
NO_NEW_LEAN
```

## Base

```text
docs/KL2003_M0C_RETARDED_INDUCTION_SCOPING_v1.md
CollatzClassical/KL2003/KL2003K2TranscendentalEndpoints.lean
CollatzClassical/KL2003/KL2003M0APiStarSemantics.lean
```

La nota complementaria:

```text
docs/KL2003_M0A_PISTAR_ZERO_AND_ROOT_BASE_LEMMAS_v1.md
```

existe y prueba los corolarios semanticos M0A relevantes para este parche:
`piStarFinset_eq_empty_of_x_lt_a`, `piStar_eq_zero_of_x_lt_a`,
`a_mem_piStarFinset_self_window`, y `one_le_piStar_of_one_le_a_le_x`.

## Decision 1: extension por cero

La semantica futura de `phi` debe quedar extendida por cero para argumentos
negativos:

```text
y < 0 -> phi_2^2(y) = 0
y < 0 -> phi_2^5(y) = 0
y < 0 -> phi_2^8(y) = 0
```

Firma Lean futura como convencion o hipotesis visible:

```lean
def K2PhiZeroExtension (Phi : K2PhiSystem) : Prop :=
  forall y, y < 0 ->
    Phi.phi22 y = 0 /\
    Phi.phi25 y = 0 /\
    Phi.phi28 y = 0
```

Justificacion semantica prevista:

```text
x = 2^y * a
y < 0
=> x < a
=> la raiz a no esta dentro de la ventana acotada
=> piStar a x = 0
```

En la definicion computable M0A, la aceptacion de un hit comprueba primero que
el estado actual esta dentro de la ventana. Por tanto un hit en la raiz no debe
contarse si `a > x`. La descarga Lean exacta requerira fijar en M0B/M0D la
conversion entre el parametro real `2^y * a` y el bound natural usado por
`piStarFinset`.

M0C no debe importar `piStarFinset` para probar esto. El puente de induccion
solo debe aceptar que el sistema `Phi` ya esta cero-extendido.

## Decision 2: base segment de ancho 2

El retardo mas profundo del sistema I2/EL abstracto es:

```text
-2
```

Por tanto el segmento base relevante para la induccion sobre `y >= 0` es:

```text
0 <= y < 2
```

No es el segmento `y <= Y0` sin cota inferior. Ese formato era demasiado
grueso para M0C, porque con extension por cero la cota positiva no puede
exigirse en `y < 0`.

## Decision 3: Delta base

Seleccion:

```lean
noncomputable def DeltaM0CBase : Real := lambdaR ^ (-(2 : Real))
```

Numericamente:

```text
DeltaM0CBase = lambda^-2 = (20/27)^2 = 400/729
```

La obligacion elemental del tramo base es:

```lean
theorem DeltaM0CBase_mul_lambda_pow_le_one_of_base
    {y : Real} (hy0 : 0 <= y) (hy2 : y < 2) :
    DeltaM0CBase * lambdaR ^ y <= 1
```

Ruta de prueba futura:

```text
lambdaR > 1
y < 2
=> lambdaR^y <= lambdaR^2
=> lambdaR^-2 * lambdaR^y <= 1
```

La razon semantica de `phi(y) >= 1` en el segmento base es que la raiz se
cuenta a si misma cuando pertenece a la ventana:

```text
0 <= y
=> x = 2^y * a >= a
=> a se cuenta con longitud orbital 0
=> phi_2^m(y) >= 1
```

Lema M0A/M0D futuro esperado:

```lean
theorem root_mem_piStarFinset
    {a x : Nat} (ha : 1 <= a) (hax : a <= x) :
    a ∈ piStarFinset a x
```

Este lema no se prueba en M0C. Solo se registra como fuente futura del anclaje
`phi(y) >= 1`.

## BaseSegmentLowerBound corregido

Firma conceptual revisada:

```lean
def BaseSegmentLowerBound (Phi : K2PhiSystem) : Prop :=
  forall y, 0 <= y -> y < 2 ->
    DeltaM0CBase * lambdaR ^ y <= Phi.phi22 y /\
    DeltaM0CBase * lambdaR ^ y <= Phi.phi25 y /\
    DeltaM0CBase * lambdaR ^ y <= Phi.phi28 y
```

Este formato expresa exactamente el anclaje trivial:

```text
DeltaM0CBase * lambdaR^y <= 1 <= phi_2^m(y)
```

para `0 <= y < 2`.

## Separacion delta vs ancho base

Hay dos constantes distintas y no deben mezclarse:

```text
deltaM0C = 5 - 3*alpha
```

controla la medida bien fundada:

```text
retardedRank y = Nat.ceil (y / deltaM0C)
```

mientras que:

```text
2
```

controla el ancho del segmento base, porque el retardo mas profundo es `-2`.

Consecuencia:

```text
retardedRank y = 0
```

no debe identificarse con el segmento base `0 <= y < 2`. La induccion futura
debe separar tres regiones:

```text
y < 0       -> extension por cero
0 <= y < 2  -> base segment por raiz
2 <= y      -> paso inductivo con descenso por deltaM0C
```

Para `2 <= y`, todos los argumentos retardados de I2/EL quedan no negativos,
porque todos los shifts activos son `>= -2`.

## No objetivos

Este parche no prueba:

```text
D1
D2
D3
desigualdades de arbol
root_mem_piStarFinset
piStar a x = 0 para bounds bajo la raiz
base segment Lean
M0
M1
teorema global de Collatz
```

## Resultado

```text
ZERO_EXTENSION_DECISION_RECORDED = yes
BASE_SEGMENT_WIDTH_TWO_RECORDED = yes
DELTA_VS_BASE_WIDTH_DISTINGUISHED = yes
DELTA_LAMBDA_MINUS_TWO_SELECTED = yes
M0C_SCOPING_PATCHED = yes
NO_LEAN_PROOF = yes
NO_D1_D2_D3 = yes
NO_M0_PROOF = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
