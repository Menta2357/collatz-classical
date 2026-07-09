# KL2003_M0C_RETARDED_INDUCTION_SCOPING_v1

Fecha: 2026-07-07.

Estado: scoping documental para el puente abstracto de induccion retardada
M0C de KL2003. No se crea Lean nuevo en esta tarea.

## Clasificacion

```text
M0C_RETARDED_INDUCTION_SCOPED
ABSTRACT_PHI_SYSTEM_DEFINED
DELTA_MEASURE_IDENTIFIED
BASE_SEGMENT_INPUT_IDENTIFIED
CERTIFICATE_CONSUMER_PATH_DEFINED
ZERO_EXTENSION_DECISION_RECORDED
BASE_SEGMENT_0_14_REGISTERED
DELTA_VS_BASE_WIDTH_DISTINGUISHED
OLD_DELTA_LAMBDA_MINUS_TWO_DEPRECATED
DELTA_V2_REGISTERED
ROW22_ROW28_THRESHOLDS_REFERENCED
ROW25_ADVANCED_ROUNDING_IMMUNITY_REFERENCED
M0C_SCOPING_ALIGNED_WITH_SEAM_V2
M0C_LEAN_READY_BY_DOCUMENTATION
TREE_SEMANTICS_NOT_USED
D1_D2_D3_NOT_USED
M0C_SCOPING_PATCHED
NO_NEW_LEAN
NO_M0C_PROOF
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
NO_PISTAR_FINSET
NO_TREE_SEMANTICS
```

## Base

```text
docs/KL2003_M0_SEMANTIC_BRIDGE_SCOPING_v1.md
docs/KL2003_M0A_COMPUTABLE_PI_STAR_SEMANTICS_SCOPING_v1.md
docs/KL2003_M0A_PI_STAR_SEMANTICS_LEAN_AND_CROSS_VALIDATION_v1.md
docs/KL2003_M0C_BASE_SEGMENT_AND_ZERO_EXTENSION_PATCH_v1.md
docs/KL2003_SCALING_SEAM_PAPER_DRAFT_v1.md
docs/KL2003_SCALING_SEAM_LEDGER_MAP_AND_BASE_SEGMENT_PATCH_v2.md
CollatzClassical/KL2003/KL2003K2CertificateVerifier.lean
CollatzClassical/KL2003/KL2003K2TranscendentalEndpoints.lean
```

M0A ya fijo una semantica computable para `piStar`, pero M0C no debe consumir
esa semantica. El proposito de M0C es aislar el mecanismo de induccion
retardada sobre funciones abstractas de variable real.

Nota v2: este scoping fue escrito originalmente antes del scaling seam v2. El
modulo Lean futuro de M0C debe tomar como fuente de parametros el seam-v2:

```text
base segment final: 0 <= y < 14
DeltaV2 = (20/27)^14 / 2 = 1 / (2 * (27/20)^14)
row22 advanced rounding threshold: xAdv >= 128
row28 advanced rounding threshold: xAdv >= 37
row25/D2 no paga advanced rounding
```

Los parametros antiguos:

```text
base width 2
Delta = lambda^-2
```

quedan deprecados como parametros finales de M0C.

## Objeto abstracto

El objeto matematico de M0C es un sistema abstracto de tres funciones:

```text
phi_2^2 : Real -> Real
phi_2^5 : Real -> Real
phi_2^8 : Real -> Real
```

Firma Lean futura:

```lean
structure K2PhiSystem where
  phi22 : Real -> Real
  phi25 : Real -> Real
  phi28 : Real -> Real
```

No se define:

```text
phi_2^m(y) = pi_a^*(2^y * something)
```

en M0C. Esa identificacion pertenece a M0B/M0D, no al puente abstracto.

Parche M0C base/zero-extension: cuando el sistema abstracto represente la
semantica `piStar`, debe estar extendido por cero para argumentos negativos:

```lean
def K2PhiZeroExtension (Phi : K2PhiSystem) : Prop :=
  forall y, y < 0 ->
    Phi.phi22 y = 0 /\
    Phi.phi25 y = 0 /\
    Phi.phi28 y = 0
```

Motivo semantico: si `y < 0`, entonces `x = 2^y * a < a`; la raiz no esta en
la ventana y el conteo `piStar a x` debe ser cero. M0C solo registra esta
convencion; no prueba aqui el lema semantico de `piStar`.

## Inputs separados

M0C debe mantener separados cuatro tipos de input matematico, mas la
convencion semantica `K2PhiZeroExtension` registrada arriba.

### 1. Certificado k=2 cerrado

Se consume como dato ya probado:

```lean
k2CertificateData_valid :
  K2InteriorCertificateData.ValidData k2CertificateData
```

Este input aporta:

```text
lambda = 27/20
c22 = 73/40
c25 = 1001/1000
c28 = 69/40
c12 = 1
c12 <= c22, c25, c28
filas racionales L2NT con slack positivo
```

M0C no reprobara el certificado racional. Solo lo importara.

### 2. Endpoints B/D cerrados

Se consumen como hechos ya probados:

```lean
BReal_within_strong_interval :
  (119 / 135 : Real) <= BReal /\ BReal <= (8 / 9 : Real)

DReal_within_target_interval :
  (119 / 100 : Real) <= DReal /\ DReal <= (6 / 5 : Real)
```

con:

```lean
BReal = lambdaR ^ (alpha - 2)
DReal = lambdaR ^ (alpha - 1)
```

Ruta de consumo:

```text
certificado racional
+ endpoint inferior de B
+ endpoint inferior de D
-> desigualdades de coeficientes para propagar lower bounds.
```

M0C no reprobara los endpoints trascendentales.

### 3. Base segment lower bound pendiente

El tramo base sigue siendo una hipotesis externa, pero su forma queda fijada
por el scaling seam v2. El scoping original usaba el segmento pre-seam-v2:

```text
old: 0 <= y < 2
```

Ese parametro ya no debe usarse como base final. El seam-v2 ensancha el
segmento base para absorber ventanas pequenas que no satisfacen los umbrales
de redondeo advanced:

```text
new: 0 <= y < 14
```

La constante antigua:

```text
old Delta = lambda^-2 = (20/27)^2
```

queda deprecada como constante final. La constante v2 es:

```lean
noncomputable def DeltaV2 : Real := 1 / (2 * lambdaR ^ (14 : Real))
```

equivalentemente:

```text
DeltaV2 = (20/27)^14 / 2
```

Firma conceptual v2:

```lean
def BaseSegmentLowerBound (Phi : K2PhiSystem) : Prop :=
  forall y, 0 <= y -> y < 14 ->
    DeltaV2 * lambdaR ^ y <= Phi.phi22 y /\
    DeltaV2 * lambdaR ^ y <= Phi.phi25 y /\
    DeltaV2 * lambdaR ^ y <= Phi.phi28 y
```

La razon v2 es:

```text
0 <= y < 14
=> DeltaV2 * lambdaR^y <= 1/2 <= 1
=> phi_2^m(y) >= 1 por conteo de la raiz
```

La descarga Lean de que la raiz se cuenta a si misma pertenece a M0A/M0D, no a
M0C.

Condiciones laterales del seam-v2 que M0C debe citar, pero no probar:

```text
row22 advanced rounding absorbed for xAdv >= 128
row28 advanced rounding absorbed for xAdv >= 37
row25/D2 has no advanced rounding charge
small windows below thresholds are covered by base segment widening
```

### 4. Filas abstractas estilo I2/EL

Las desigualdades de arbol no se prueban aqui. M0C recibe un sistema abstracto
retardado como hipotesis sobre `Phi`.

Helpers conceptuales:

```lean
def min3 (a b c : Real) : Real := min a (min b c)

def M2 (Phi : K2PhiSystem) (y : Real) : Real :=
  min3
    (Phi.phi22 (y + 3 * alpha - 5))
    (Phi.phi25 (y + 3 * alpha - 5))
    (Phi.phi28 (y + 3 * alpha - 5))

def M1 (Phi : K2PhiSystem) (y : Real) : Real :=
  min
    (Phi.phi28 (y + 2 * alpha - 5) + M2 Phi y)
    (Phi.phi22 (y + 2 * alpha - 5))
```

Sistema de hipotesis abstractas:

```lean
structure I2ELAbstractRows (Phi : K2PhiSystem) : Prop where
  row22 :
    forall y,
      Phi.phi28 (y - 2)
        + min3
            (Phi.phi22 (y + alpha - 2))
            (Phi.phi25 (y + alpha - 2))
            (Phi.phi28 (y + alpha - 2))
        <= Phi.phi22 y
  row25 :
    forall y,
      Phi.phi22 (y - 2) <= Phi.phi25 y
  row28EL :
    forall y,
      Phi.phi25 (y - 2)
        + min
            (Phi.phi28 (y + alpha - 3) + M1 Phi y)
            (Phi.phi22 (y + alpha - 3))
        <= Phi.phi28 y
```

Estas filas son hipotesis, no pruebas. En particular:

```text
no se prueba ninguna desigualdad de arbol;
no se menciona `piStarFinset`;
no se abre la semantica de M0A;
no se prueba D1/D2/D3.
```

## Medida de induccion

Definicion requerida:

```lean
noncomputable def deltaM0C : Real := 5 - 3 * alpha

noncomputable def retardedRank (y : Real) : Nat :=
  Nat.ceil (y / deltaM0C)
```

La induccion futura sera sobre:

```text
retardedRank y
```

No se debe intentar una recursion estructural sobre `y : Real`.

Importante: `deltaM0C = 5 - 3*alpha` controla solo la medida bien fundada. No
controla el ancho del segmento base. El retardo mas profundo del sistema I2/EL
sigue siendo `-2`, pero el ancho base final v2 es `14`, impuesto por el
scaling seam y el ledger de redondeo, no por la profundidad logica minima del
sistema abstracto.

## Shifts activos

Despues de la eliminacion EL, todos los argumentos recursivos de las filas
abstractas son retardados. El conjunto que M0C debe auditar es:

```text
-2
alpha - 2
alpha - 3
2*alpha - 5
3*alpha - 5
```

Los shifts avanzados del sistema sin EL no pertenecen a M0C. En particular el
shift:

```text
alpha - 1 > 0
```

no debe aparecer como argumento recursivo en `I2ELAbstractRows`.

## Obligaciones sobre delta

La prueba Lean futura debe aislar primero los lemas elementales sobre:

```lean
deltaM0C = 5 - 3 * alpha
```

### Positividad

Objetivo:

```lean
theorem deltaM0C_pos : 0 < deltaM0C
```

Ruta:

```text
alpha_upper_bound : alpha < 8/5
=> 3*alpha < 24/5
=> 0 < 5 - 3*alpha
```

De hecho se obtiene el margen racional:

```text
1/5 < deltaM0C
```

### Comparacion de shifts con `-delta`

Objetivos:

```lean
theorem shift_minus_two_le_neg_delta :
  (-2 : Real) <= -deltaM0C

theorem shift_alpha_minus_two_le_neg_delta :
  alpha - 2 <= -deltaM0C

theorem shift_alpha_minus_three_le_neg_delta :
  alpha - 3 <= -deltaM0C

theorem shift_two_alpha_minus_five_le_neg_delta :
  2 * alpha - 5 <= -deltaM0C

theorem shift_three_alpha_minus_five_eq_neg_delta :
  3 * alpha - 5 = -deltaM0C
```

Rutas:

```text
3*alpha - 5 = -deltaM0C                    por ring
2*alpha - 5 <= 3*alpha - 5                 por 0 <= alpha
alpha - 3 <= 3*alpha - 5                   por 1 <= alpha
alpha - 2 <= 3*alpha - 5                   por 3/2 <= alpha
-2 <= -deltaM0C                            por deltaM0C <= 2
```

Los hechos `0 <= alpha`, `1 <= alpha`, `3/2 <= alpha` y `deltaM0C <= 2` salen
de `alpha_lower_bound : 19/12 < alpha`.

### Descenso de la medida

Lema mecanico esperado:

```lean
theorem retardedRank_drop
    {y beta : Real}
    (hdelta : 0 < deltaM0C)
    (hbeta : beta <= -deltaM0C)
    (hpos : 0 < retardedRank y) :
    retardedRank (y + beta) < retardedRank y
```

Idea:

```text
beta <= -delta
=> (y + beta) / delta <= y / delta - 1
=> ceil((y + beta) / delta) < ceil(y / delta)
```

El parche M0C base/zero-extension corrige la lectura del caso base: no debe
identificarse `retardedRank y = 0` con el segmento base. Tras seam-v2, la
induccion futura debe separar:

```text
y < 0       -> extension por cero
0 <= y < 14 -> base segment ensanchado
14 <= y     -> paso inductivo con descenso por deltaM0C
```

En la region `14 <= y`, todos los argumentos retardados permanecen no
negativos, porque todos los shifts activos son `>= -2`. El margen adicional
absorbe las ventanas pequenas del scaling seam.

## Target Lean futuro

Archivo futuro:

```text
CollatzClassical/KL2003/KL2003M0CRetardedInduction.lean
```

## M0C Lean contract after v2

El modulo futuro debe incluir:

```text
abstract Phi functions
EL row hypotheses
zero-extension for y < 0
retardedRank with delta = 5 - 3*alpha
base segment [0,14]
DeltaV2 = (20/27)^14 / 2
row22/row28 threshold assumptions referenced as seam inputs
row25 advanced rounding immunity referenced as seam input
```

M0C sigue siendo abstracto:

```text
M0C consumes EL rows as hypotheses
M0C does not touch piStarFinset
M0C does not prove the scaling seam
M0C does not prove the rounding ledger
M0C does not prove the M1 theorem
```

Conclusion abstracta esperada:

```text
phi_m(y) >= DeltaV2 * c_m * lambda^y
```

en la region inductiva, o la formulacion abstracta equivalente fijada en el
modulo Lean futuro.

Imports esperados:

```lean
import CollatzClassical.KL2003.KL2003K2CertificateVerifier
import CollatzClassical.KL2003.KL2003K2TranscendentalEndpoints
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Algebra.Order.Floor.Defs
import Mathlib.Tactic.Linarith
```

No importar en M0C:

```text
CollatzClassical.KL2003.KL2003M0APiStarSemantics
```

salvo que una tarea posterior pida explicitamente ensamblar semantica y
retarded induction. Esa union no pertenece a este modulo.

Skeleton conceptual:

```lean
namespace CollatzClassical
namespace KL2003

structure K2PhiSystem where
  phi22 : Real -> Real
  phi25 : Real -> Real
  phi28 : Real -> Real

noncomputable def deltaM0C : Real := 5 - 3 * alpha

noncomputable def DeltaV2 : Real := 1 / (2 * lambdaR ^ (14 : Real))

noncomputable def retardedRank (y : Real) : Nat :=
  Nat.ceil (y / deltaM0C)

def K2PhiZeroExtension (Phi : K2PhiSystem) : Prop :=
  forall y, y < 0 ->
    Phi.phi22 y = 0 /\
    Phi.phi25 y = 0 /\
    Phi.phi28 y = 0

structure I2ELAbstractRows (Phi : K2PhiSystem) : Prop where
  row22 : Prop
  row25 : Prop
  row28EL : Prop

def BaseSegmentLowerBound (Phi : K2PhiSystem) : Prop := ...

structure K2RetardedInductionInputs (Phi : K2PhiSystem) : Prop where
  certificate :
    K2InteriorCertificateData.ValidData k2CertificateData
  endpointsB :
    (119 / 135 : Real) <= BReal /\ BReal <= (8 / 9 : Real)
  endpointsD :
    (119 / 100 : Real) <= DReal /\ DReal <= (6 / 5 : Real)
  zeroExtension :
    K2PhiZeroExtension Phi
  base :
    BaseSegmentLowerBound Phi
  rows :
    I2ELAbstractRows Phi

-- Target abstracto, no teorema M0/M1:
def RetardedLowerBoundConclusion (Phi : K2PhiSystem) : Prop := ...

theorem k2_retarded_induction_abstract
    (Phi : K2PhiSystem)
    (hinputs : K2RetardedInductionInputs Phi) :
    RetardedLowerBoundConclusion Phi := by
  -- futura prueba por retardedRank
  sorry

end KL2003
end CollatzClassical
```

El `sorry` del skeleton es solo documental. No se introduce en el repositorio
en esta tarea.

## No objetivos

M0C no prueba:

```text
D1
D2
D3
desigualdades de arbol
semantica de piStar
scaling seam
rounding ledger
base segment lower bound semantico
M0
M1
teorema global de Collatz
```

M0C tampoco debe afirmar que `Phi` proviene de `piStar`. Esa es una obligacion
de ensamblaje posterior, no de la induccion abstracta.

## Resultado

```text
M0C_RETARDED_INDUCTION_SCOPED = yes
ABSTRACT_PHI_SYSTEM_DEFINED = yes
DELTA_MEASURE_IDENTIFIED = yes
BASE_SEGMENT_INPUT_IDENTIFIED = yes
CERTIFICATE_CONSUMER_PATH_DEFINED = yes
ZERO_EXTENSION_DECISION_RECORDED = yes
BASE_SEGMENT_0_14_REGISTERED = yes
DELTA_VS_BASE_WIDTH_DISTINGUISHED = yes
OLD_DELTA_LAMBDA_MINUS_TWO_DEPRECATED = yes
DELTA_V2_REGISTERED = yes
ROW22_ROW28_THRESHOLDS_REFERENCED = yes
ROW25_ADVANCED_ROUNDING_IMMUNITY_REFERENCED = yes
M0C_SCOPING_ALIGNED_WITH_SEAM_V2 = yes
M0C_LEAN_READY_BY_DOCUMENTATION = yes
TREE_SEMANTICS_NOT_USED = yes
D1_D2_D3_NOT_USED = yes
M0C_SCOPING_PATCHED = yes
NO_NEW_LEAN = yes
NO_M0C_PROOF = yes
NO_M0_PROOF = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
