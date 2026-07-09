# KL2003_M0C_RETARDED_INDUCTION_LEAN_v1

Fecha: 2026-07-09.

Estado: modulo Lean abstracto M0C creado y compilado. La capa de sistema,
base seam-v2, filas EL como hipotesis y descenso de `retardedRank` esta
formalizada. El teorema ponderado completo `m0c_retarded_induction_bound` no
se declara, porque el contrato base seam-v2 documentado es mas debil que la
base ponderada que necesita el primer paso inductivo.

## Clasificacion

```text
M0C_ABSTRACT_SYSTEM_DEFINED
M0C_BASE_SEGMENT_V2_FORMALIZED
M0C_SHIFT_DESCENT_LEMMAS_PROVED
BASE_SEGMENT_V2_CONSUMED
DELTA_V2_USED
EL_ROWS_CONSUMED_AS_HYPOTHESES
RETARDED_RANK_DESCENT_PROVED
M0C_BLOCKED_ON_RETARDED_INDUCTION
M0C_BLOCKED_ON_BASE_WEIGHTED_LOWER_BOUND
M0C_BLOCKED_ON_CERTIFICATE_ROW_ARITHMETIC
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
```

Tambien define:

```text
min3
M2
M1
K2PhiZeroExtension
I2ELAbstractRows
BaseSegmentLowerBound
BaseSegmentWeightedLowerBound
K2RetardedInductionInputs
RetardedLowerBoundConclusion
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

## Bloqueo Exacto Del Teorema Ponderado

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

Esa base no es ponderada por `c22R`, `c25R`, `c28R`.

En el primer paso inductivo desde `y = 14`, las llamadas retardadas caen en
el segmento base:

```text
y - 2
y + alpha - 2
y + alpha - 3
y + 2*alpha - 5
y + 3*alpha - 5
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

La forma natural de desbloqueo es una de estas dos:

```text
1. fortalecer el input base a BaseSegmentWeightedLowerBound; o
2. probar desde el seam/base semantico que, para 0 <= y < 14,
   DeltaV2 * c_m * lambdaR^y <= Phi.phi_m y
   usando Cmax = 2 y el lower bound de raiz.
```

Esta segunda ruta pertenece al scaling seam/base semantic bridge, no a M0C
abstracto.

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
base segment semantico
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
BASE_SEGMENT_V2_CONSUMED = yes
DELTA_V2_USED = yes
EL_ROWS_CONSUMED_AS_HYPOTHESES = yes
RETARDED_RANK_DESCENT_PROVED = yes
ABSTRACT_PHI_BOUND_PROVED = no
M0C_RETARDED_INDUCTION_ABSTRACT_PROVED = no
M0C_BLOCKED_ON_RETARDED_INDUCTION = yes
M0C_BLOCKED_ON_BASE_WEIGHTED_LOWER_BOUND = yes
M0C_BLOCKED_ON_CERTIFICATE_ROW_ARITHMETIC = yes
M0C_BLOCKED_ON_REAL_CEIL_RANK = no
NO_PISTAR_SEMANTICS = yes
NO_SCALING_SEAM_PROOF = yes
NO_ROUNDING_LEDGER_PROOF = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
