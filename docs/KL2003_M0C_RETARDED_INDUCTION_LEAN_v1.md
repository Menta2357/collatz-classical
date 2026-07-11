# KL2003_M0C_RETARDED_INDUCTION_LEAN_v1

Fecha: 2026-07-09. Patches M0C: contrato ponderado y base desde unidad
aritmetica, 2026-07-10.

Estado: modulo Lean abstracto M0C creado y compilado, con patch de contrato
ponderado y cierre aritmetico de la base ponderada desde una base unitaria
abstracta. La capa de sistema, base seam-v2 ponderada como hipotesis, filas EL
como hipotesis y descenso de `retardedRank` esta formalizada. El teorema
ponderado completo `m0c_retarded_induction_bound` no se declara en este patch.

## Clasificacion

```text
M0C_ABSTRACT_SYSTEM_DEFINED
M0C_BASE_SEGMENT_V2_FORMALIZED
M0C_SHIFT_DESCENT_LEMMAS_PROVED
M0C_WEIGHTED_BASE_CONTRACT_PATCHED
BASE_SEGMENT_WEIGHTED_LOWER_BOUND_CONSUMED_AS_INPUT
BASE_WEIGHTED_FROM_UNIT_PROVED
BASE_ARITHMETIC_DEBT_CLOSED_IN_M0C
ROOT_COUNT_UNIT_BASE_DEFERRED
BASE_WEAK_INPUT_NOT_USED_FOR_WEIGHTED_TARGET
M0C_LAYER_SEPARATION_RESTORED
ROOT_COUNT_BRIDGE_DEFERRED
BASE_SEGMENT_V2_CONSUMED_AS_WEAK_DOCUMENTAL_INPUT
DELTA_V2_USED
EL_ROWS_CONSUMED_AS_HYPOTHESES
RETARDED_RANK_DESCENT_PROVED
I2_EL_ROWS_V2_DEFINED
EPSILON0_DEFINED
PADDED_SHIFT_DESCENT_LEMMAS_PROVED
V1_RETAINED_AS_IDEAL_CONTRACT
V2_NOT_YET_CONSUMED_BY_MAIN_TARGET
PADDED_CERTIFICATE_RECHECK_STILL_PENDING
M0C_MAIN_INDUCTION_NOT_STARTED
NO_PISTAR_SEMANTICS
NO_SCALING_SEAM_PROOF
NO_ROUNDING_LEDGER_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

No se clasifica como:

```text
M0C_RETARDED_INDUCTION_ABSTRACT_PROVED
ABSTRACT_PHI_BOUND_PROVED
M0C_BLOCKED_ON_BASE_WEIGHTED_LOWER_BOUND
M0C_BLOCKED_ON_REAL_CEIL_RANK
```

## Archivos

Creado:

```text
CollatzClassical/KL2003/KL2003M0CRetardedInduction.lean
CollatzClassical/KL2003/KL2003M0CRetardedInductionAxiomAudit.lean
docs/KL2003_M0C_RETARDED_INDUCTION_LEAN_v1.md
```

## Contenido Formalizado

El modulo define:

```text
K2PhiSystem
  phi22 : Real -> Real
  phi25 : Real -> Real
  phi28 : Real -> Real

deltaM0C := 5 - 3 * alpha
DeltaV2 := 1 / (2 * lambdaR ^ (14 : Real))

c22R := 73/40
c25R := 1001/1000
c28R := 69/40
c12R := 1

shiftMinusTwo := -2
shiftAlphaMinusTwo := alpha - 2
shiftAlphaMinusThree := alpha - 3
shiftTwoAlphaMinusFive := 2*alpha - 5
shiftThreeAlphaMinusFive := 3*alpha - 5

epsilon0 := 1/10000
shiftAlphaMinus2Pad := alpha - 2 - epsilon0
shiftAlphaMinus1Pad := alpha - 1 - epsilon0
shiftAlphaMinus3Pad := alpha - 3 - epsilon0
shift2AlphaMinus5Pad2 := 2*alpha - 5 - 2*epsilon0
shift3AlphaMinus5Pad3 := 3*alpha - 5 - 3*epsilon0
```

Tambien define:

```text
min3
M2
M1
K2PhiZeroExtension
I2ELAbstractRows
I2ELAbstractRowsV2
BaseSegmentLowerBound
BaseSegmentUnitLowerBound
BaseSegmentWeightedLowerBound
K2RetardedInductionInputs
RetardedLowerBoundConclusion
```

`K2RetardedInductionInputs` consume ahora:

```text
weightedBase : BaseSegmentWeightedLowerBound Phi
```

La base debil `BaseSegmentLowerBound` permanece definida para documentar un
input no ponderado. La nueva base unitaria abstracta:

```text
BaseSegmentUnitLowerBound Phi
```

usa el segmento cerrado `0 <= y <= 14`. Esta decision es intencional: la
aritmetica de monotonicidad de `lambdaR^y` se cierra naturalmente hasta el
endpoint `14`, mientras que `BaseSegmentWeightedLowerBound` sigue consumiendo
el segmento abierto `0 <= y < 14` y usa `le_of_lt` para aplicar la hipotesis
unitaria.

El input operativo del target ponderado sigue siendo:

```text
weightedBase : BaseSegmentWeightedLowerBound Phi
```

Las filas EL quedan como hipotesis abstractas:

```text
row22
row25
row28EL
```

El modulo no importa la semantica computable M0A ni las filas combinatorias
M0B.

## Lemas Cerrados

Se probaron:

```text
DeltaV2_pos
c22R_pos
c25R_pos
c28R_pos
c22R_le_two
c25R_le_two
c28R_le_two
lambdaR_rpow_le_pow_fourteen
DeltaV2_mul_two_mul_lambdaR_pow_fourteen
DeltaV2_mul_coeff_mul_lambdaR_rpow_le_one
DeltaV2_mul_c22R_mul_lambdaR_rpow_le_one
DeltaV2_mul_c25R_mul_lambdaR_rpow_le_one
DeltaV2_mul_c28R_mul_lambdaR_rpow_le_one
base_weighted_of_unit
deltaM0C_pos
one_fifth_lt_deltaM0C
deltaM0C_le_two
alpha_pos
alpha_nonneg
one_le_alpha
three_halves_le_alpha
```

Y los descensos de shifts:

```text
shiftMinusTwo <= -deltaM0C
shiftAlphaMinusTwo <= -deltaM0C
shiftAlphaMinusThree <= -deltaM0C
shiftTwoAlphaMinusFive <= -deltaM0C
shiftThreeAlphaMinusFive = -deltaM0C
```

Tambien se probo el lema generico:

```text
retardedRank_drop :
  beta <= -deltaM0C ->
  0 < retardedRank y ->
  retardedRank (y + beta) < retardedRank y
```

y sus cinco instancias para los shifts activos.

## Patch Del Contrato Ponderado

El target deseado pide, para `14 <= y`:

```text
DeltaV2 * c22R * lambdaR^y <= Phi.phi22 y
DeltaV2 * c25R * lambdaR^y <= Phi.phi25 y
DeltaV2 * c28R * lambdaR^y <= Phi.phi28 y
```

Pero el base segment seam-v2 documentado y formalizado como input es:

```text
0 <= y -> y < 14 ->
  DeltaV2 * lambdaR^y <= Phi.phi22 y
  DeltaV2 * lambdaR^y <= Phi.phi25 y
  DeltaV2 * lambdaR^y <= Phi.phi28 y
```

Esa base no es ponderada por `c22R`, `c25R`, `c28R`, asi que ahora M0C consume
explicitamente:

```text
BaseSegmentWeightedLowerBound Phi
```

con helpers:

```text
weightedBaseSegment_phi22
weightedBaseSegment_phi25
weightedBaseSegment_phi28
```

La base debil queda como objeto documental, no como input suficiente para el
target ponderado.

M0C tambien prueba ahora la parte aritmetica que permite generar la base
ponderada desde una base unitaria:

```text
base_weighted_of_unit :
  BaseSegmentUnitLowerBound Phi ->
  BaseSegmentWeightedLowerBound Phi
```

La demostracion usa:

```text
c22R <= 2
c25R <= 2
c28R <= 2
lambdaR^y <= lambdaR^14      para y <= 14
DeltaV2 * 2 * lambdaR^14 = 1
```

Por tanto, para `0 <= y < 14`:

```text
DeltaV2 * c_m * lambdaR^y <= 1
```

y la hipotesis unitaria `1 <= Phi.phi_m y` cierra la base ponderada.

En el primer paso inductivo desde `y = 14`, las llamadas retardadas caen en
el segmento base:

```text
y - 2
y + alpha - 2
y + alpha - 3
y + 2*alpha - 5
y + 3*alpha - 5
```

## Rows V2 Epsilon Pad

El modulo mantiene dos contratos de filas:

```text
I2ELAbstractRows    -- V1 ideal/continuo
I2ELAbstractRowsV2  -- V2 seam-compatible con pads epsilon
```

`I2ELAbstractRowsV2` se definio en paralelo y no reemplaza todavia el input
principal:

```text
K2RetardedInductionInputs.rows : I2ELAbstractRows Phi
```

La constante formalizada es:

```text
epsilon0 := 1/10000
```

con lemas:

```text
epsilon0_pos
epsilon0_nonneg
epsilon0_lt_one
```

La V2 restringe las filas a la region inductiva `14 <= y`. Los terminos
retardados permanecen exactos:

```text
y - 2
```

Los terminos advanced/min reciben pads:

```text
row22:
  y + shiftAlphaMinus2Pad

row25:
  y - 2
  -- single-branch; no advanced pad

row28EL:
  y + shiftAlphaMinus3Pad
  M1V2 with y + shift2AlphaMinus5Pad2
  M2V2 with y + shift3AlphaMinus5Pad3
```

Tambien queda definido `shiftAlphaMinus1Pad` para bookkeeping de endpoints o
seam, pero no se consume como shift retardado de V2 y por eso no tiene lema de
descenso asociado en este patch.

Se probaron las comparaciones:

```text
shiftAlphaMinus2Pad <= shiftAlphaMinusTwo
shiftAlphaMinus3Pad <= shiftAlphaMinusThree
shift2AlphaMinus5Pad2 <= shiftTwoAlphaMinusFive
shift3AlphaMinus5Pad3 <= shiftThreeAlphaMinusFive
```

y por transitividad con los shifts V1:

```text
shiftAlphaMinus2Pad <= -deltaM0C
shiftAlphaMinus3Pad <= -deltaM0C
shift2AlphaMinus5Pad2 <= -deltaM0C
shift3AlphaMinus5Pad3 <= -deltaM0C
```

Esto da las instancias:

```text
retardedRank_drop_shiftAlphaMinus2Pad
retardedRank_drop_shiftAlphaMinus3Pad
retardedRank_drop_shift2AlphaMinus5Pad2
retardedRank_drop_shift3AlphaMinus5Pad3
```

La aritmetica del certificado con pads todavia no se re-chequea aqui. El
estado correcto es:

```text
V1 retained as ideal contract
V2 defined as seam-compatible contract
V2 not yet consumed by main target
padded certificate recheck pending
```

El certificado racional de filas usa coeficientes ponderados, por ejemplo:

```text
lambda^-2 * c28 + lambda^(alpha-2) * 1 >= c22
lambda^-2 * c22 >= c25
lambda^-2 * c25 + lambda^(alpha-1) * 1 >= c28
```

Con la base no ponderada, la primera fila empezaria solo con:

```text
lambda^-2 * 1 + lambda^(alpha-2) * 1
```

que no alcanza `c22`. Por tanto no es correcto declarar el teorema ponderado
completo sin una entrada adicional.

La deuda restante pertenece al modulo posterior:

```text
BASE_SEGMENT_WEIGHTED_FROM_ROOT_COUNT
```

Ese puente ya no necesita repetir la aritmetica anterior. Solo debera probar la
base unitaria semantica:

```text
BaseSegmentUnitLowerBound Phi
```

desde root-count/conteo de la raiz. M0C no importa esa semantica ni prueba ese
origen.

Resumen de separacion:

```text
M0C prueba:    BaseSegmentUnitLowerBound -> BaseSegmentWeightedLowerBound
Futuro prueba: root-count/piStar -> BaseSegmentUnitLowerBound
```

## Verificacion

Ejecutado:

```text
lake build CollatzClassical.KL2003.KL2003M0CRetardedInduction
lake env lean CollatzClassical/KL2003/KL2003M0CRetardedInductionAxiomAudit.lean
```

Resultado:

```text
LEAN_BUILD_PASS = yes
AXIOM_AUDIT_PASS = yes
```

El audit reporta solo dependencias habituales de Mathlib/Real:

```text
propext
Classical.choice
Quot.sound
```

## No Objetivos

No se prueba:

```text
scaling seam
rounding ledger
base segment semantico/root-count
M0 theorem
M1 theorem
global Collatz claim
```

No se usa:

```text
sorry
admit
axiom
unsafe
native_decide
```

## Resultado

```text
M0C_ABSTRACT_SYSTEM_DEFINED = yes
M0C_BASE_SEGMENT_V2_FORMALIZED = yes
M0C_SHIFT_DESCENT_LEMMAS_PROVED = yes
M0C_WEIGHTED_BASE_CONTRACT_PATCHED = yes
BASE_SEGMENT_WEIGHTED_LOWER_BOUND_CONSUMED_AS_INPUT = yes
BASE_WEIGHTED_FROM_UNIT_PROVED = yes
BASE_ARITHMETIC_DEBT_CLOSED_IN_M0C = yes
ROOT_COUNT_UNIT_BASE_DEFERRED = yes
BASE_WEAK_INPUT_NOT_USED_FOR_WEIGHTED_TARGET = yes
M0C_LAYER_SEPARATION_RESTORED = yes
ROOT_COUNT_BRIDGE_DEFERRED = yes
BASE_SEGMENT_V2_CONSUMED_AS_WEAK_DOCUMENTAL_INPUT = yes
DELTA_V2_USED = yes
EL_ROWS_CONSUMED_AS_HYPOTHESES = yes
RETARDED_RANK_DESCENT_PROVED = yes
I2_EL_ROWS_V2_DEFINED = yes
EPSILON0_DEFINED = yes
PADDED_SHIFT_DESCENT_LEMMAS_PROVED = yes
V1_RETAINED_AS_IDEAL_CONTRACT = yes
V2_NOT_YET_CONSUMED_BY_MAIN_TARGET = yes
PADDED_CERTIFICATE_RECHECK_STILL_PENDING = yes
M0C_MAIN_INDUCTION_NOT_STARTED = yes
ABSTRACT_PHI_BOUND_PROVED = no
M0C_RETARDED_INDUCTION_ABSTRACT_PROVED = no
M0C_BLOCKED_ON_RETARDED_INDUCTION = not_assessed_in_contract_patch
M0C_BLOCKED_ON_BASE_WEIGHTED_LOWER_BOUND = no_explicit_contract_now
M0C_BLOCKED_ON_CERTIFICATE_ROW_ARITHMETIC = not_assessed_in_contract_patch
M0C_BLOCKED_ON_REAL_CEIL_RANK = no
NO_PISTAR_SEMANTICS = yes
NO_SCALING_SEAM_PROOF = yes
NO_ROUNDING_LEDGER_PROOF = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
