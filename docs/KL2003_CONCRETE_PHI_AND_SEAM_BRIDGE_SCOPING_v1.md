# KL2003_CONCRETE_PHI_AND_SEAM_BRIDGE_SCOPING_v1

Fecha: 2026-07-12.

Estado: scoping documental de la instancia concreta de `Phi : K2PhiSystem`
desde `piStar`, y mapa de obligaciones para alimentar
`K2RetardedInductionInputsV2`. No se crea Lean nuevo en esta pasada.

## Clasificacion

```text
CONCRETE_PHI_SCOPED
SEAM_BRIDGE_OBLIGATIONS_MAPPED
K2_RETARDED_INPUTS_V2_TARGET_READY
ROOT_COUNT_UNIT_BRIDGE_IDENTIFIED
REAL_TO_NAT_WINDOW_POLICY_OPEN
PHI_MONOTONICITY_OPEN
ROWS_V2_SEAM_PROOF_OPEN
M0D_NOT_STARTED
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Guardarrailes:

```text
NO_NEW_LEAN
NO_M1_THEOREM
NO_GLOBAL_COLLATZ
NO_COLLATZ_CLOSURE
NO_ALMOST_ALL
NO_SEAM_LEDGER_REOPEN
```

## Objeto A Instanciar

M0C ya cerro el teorema abstracto:

```lean
m0c_retarded_induction_bound_v2 :
  K2RetardedInductionInputsV2 Phi ->
  RetardedLowerBoundConclusion Phi
```

La siguiente fase debe producir un `Phi : K2PhiSystem` semantico y una prueba
de:

```lean
K2RetardedInductionInputsV2 Phi
```

sin modificar el teorema M0C ni crear una conclusion V2.

## Definicion Documental De Phi

La lectura matematica prevista es:

```text
Phi.phi22 y = phi_2^2(y)
Phi.phi25 y = phi_2^5(y)
Phi.phi28 y = phi_2^8(y)
```

Cada componente es una envolvente inferior de conteos `piStar` para raices en
una clase residual modulo 9:

```text
phi_2^m(y) ~= inf/envelope {
  (piStar a (window y a) : Real)
  | 1 <= a,
    a % 9 = m,
    a es admisible para la capa KL,
    window y a es la ventana Nat asociada a y
}
```

con:

```text
m = 2 -> Phi.phi22
m = 5 -> Phi.phi25
m = 8 -> Phi.phi28
```

Para `y < 0`, la instancia concreta debe satisfacer la zero-extension que M0C
consume:

```lean
K2PhiZeroExtension Phi
```

La forma recomendada es definir `Phi.phi_m y = 0` por convenio cuando `y < 0`,
y usar la envolvente semantica solo para `0 <= y`. Esto no interfiere con las
filas V2, porque M0C solo consume filas para `14 <= y` y los shifts auditados
caen en la region no negativa.

## No Fijar Todavia sInf

Aunque la lectura natural usa un infimo, el primer bridge Lean no deberia
forzar todavia una implementacion concreta con `sInf`. Hay deudas de:

```text
no vacuidad del dominio
coerciones Nat -> Real
propiedades de infimos reales
monotonicidad del envelope
```

Recomendacion: introducir primero una estructura de realizacion semantica:

```text
ConcretePhiRealization
  Phi : K2PhiSystem
  window : Real -> Nat -> Nat
  admissible : Nat -> Prop
  class22/class25/class28 : Nat -> Prop
  lowerEnvelope22 :
    (forall a, admissible a -> a % 9 = 2 ->
      b <= (piStar a (window y a) : Real)) ->
    b <= Phi.phi22 y
  lowerEnvelope25 : ...
  lowerEnvelope28 : ...
  zeroExtension : K2PhiZeroExtension Phi
```

Despues se puede implementar esta realizacion mediante `sInf` o mediante una
definicion mas computable. M0D no debe depender de esa decision demasiado
pronto.

## Separacion De Datos

### Clase/residuo de raiz

La clase del caller/root determina la fila que paga el ledger:

```text
a % 9 = 2 -> row22 -> Phi.phi22
a % 9 = 5 -> row25 -> Phi.phi25
a % 9 = 8 -> row28 -> Phi.phi28
```

La clase del child determina que componente aparece dentro del `min` o `min3`,
pero no determina que fila paga el redondeo advanced.

### Ventana Nat asociada a y

La politica de ventana sigue abierta. La candidata canonica es:

```text
window y a = floor(2^y * a)
```

o una variante conservadora equivalente si el seam la requiere.

Debe quedar como modulo separado:

```text
RealToNatWindowPolicy
```

con obligaciones:

```text
RootInWindow:
  0 <= y -> y <= 14 -> 1 <= a -> a <= window y a

RetardedWindow:
  window (y - 2) (4*a) <= xRet

AdvancedWindow:
  window (y + shift) c <= xAdv
```

para los shifts padded que aparecen en V2.

### Relacion piStar

El conteo concreto de una raiz `a` en una ventana Nat `x` es:

```text
piStar a x = (piStarFinset a x).card
```

M0A ya fija la semantica computable. M0B trabaja con cardinales de
`piStarFinset`; M0D debe convertir esos cardinales a los valores reales que
alimentan `Phi`.

### Normalizacion por clase

No se debe dividir `piStar` por `c22/c25/c28`. Los coeficientes `c_m` ya viven
en el certificado/M0C:

```text
Phi22LowerBoundAt Phi y := DeltaV2 * c22R * lambdaR^y <= Phi.phi22 y
Phi25LowerBoundAt Phi y := DeltaV2 * c25R * lambdaR^y <= Phi.phi25 y
Phi28LowerBoundAt Phi y := DeltaV2 * c28R * lambdaR^y <= Phi.phi28 y
```

Por tanto `Phi.phi_m y` debe representar conteos/envelopes crudos de
`piStar`, no una cantidad ya ponderada por `c_m`.

## Obligaciones Para K2RetardedInductionInputsV2

El constructor objetivo puede seguir siendo:

```lean
k2_retarded_inputs_v2_from_closed_certificate
```

una vez se prueben:

```lean
K2PhiZeroExtension Phi
BaseSegmentWeightedLowerBound Phi
I2ELAbstractRowsV2 Phi
```

Los endpoints y el certificado ya estan cerrados por los modulos k=2.

### zeroExtension

Obligacion:

```lean
forall y, y < 0 ->
  Phi.phi22 y = 0 /\
  Phi.phi25 y = 0 /\
  Phi.phi28 y = 0
```

Ruta recomendada:

```text
definir Phi por casos:
  y < 0 -> 0
  0 <= y -> envelope piStar
```

Esto no debe usar `piStar` ni filas Nat en la region negativa.

### weightedBase

Ruta ya preparada:

```lean
base_weighted_of_unit :
  BaseSegmentUnitLowerBound Phi ->
  BaseSegmentWeightedLowerBound Phi
```

Por tanto M0D debe probar:

```lean
BaseSegmentUnitLowerBound Phi
```

desde:

```lean
root_count_unit_lower_bound_for_window :
  1 <= a -> a <= x -> 1 <= piStar a x
```

y una politica de ventana con:

```text
0 <= y -> y <= 14 -> 1 <= a -> a <= window y a
```

Mas el principio de envelope:

```text
si todo conteo puntual de la clase m es >= 1,
entonces Phi.phi_m y >= 1.
```

### rowsV2

Obligacion:

```lean
I2ELAbstractRowsV2 Phi
```

Filas a descargar:

```text
row22 : 14 <= y ->
  Phi.phi28 (y - 2)
    + min3
        Phi.phi22 (y + shiftAlphaMinus2Pad)
        Phi.phi25 (y + shiftAlphaMinus2Pad)
        Phi.phi28 (y + shiftAlphaMinus2Pad)
  <= Phi.phi22 y

row25 : 14 <= y ->
  Phi.phi22 (y - 2) <= Phi.phi25 y

row28EL : 14 <= y ->
  Phi.phi25 (y - 2)
    + min
        (Phi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 Phi y)
        Phi.phi22 (y + shiftAlphaMinus3Pad)
  <= Phi.phi28 y
```

La ruta de prueba debe tener tres capas:

```text
1. M0B combinatorio Nat:
   d1_core_instantiation
   d2_single_branch_core_instantiation
   d3_core_instantiation

2. Seam/window:
   demostrar que las ventanas concretas de los argumentos shifted caben dentro
   de las ventanas Nat usadas por M0B.

3. Envelope/Phi:
   convertir cotas puntuales por clase en cotas de Phi mediante lowerEnvelope.
```

## Filas: Mapa Semantico

### row22

Caller/root:

```text
a % 9 = 2
target: piStar a (window y a)
```

M0B usa:

```text
d1_core_instantiation
source retarded root = 4*a, class 8
source advanced root = c, 3*c + 1 = 2*a
```

Obligaciones de ventana:

```text
window (y - 2) (4*a) <= xRet
window (y + shiftAlphaMinus2Pad) c <= xAdv
xRet <= window y a
xAdv <= window y a
```

El child `c` puede caer en clases `2/5/8`; por eso la fila usa `min3`.

### row25

Caller/root:

```text
a % 9 = 5
```

M0B usa:

```text
d2_single_branch_core_instantiation
source retarded root = 4*a, class 2
```

Obligaciones de ventana:

```text
window (y - 2) (4*a) <= xRet
xRet <= window y a
```

No hay cargo advanced ni rama advanced consumida por el ledger EL. Esta es la
inmunidad row25 ya documentada en seam-v2.

### row28EL

Caller/root:

```text
a % 9 = 8
```

La fila EL V2 ya no es la fila D3 cruda. Debe obtenerse de M0B + seam + la
eliminacion EL que produce el bloque anidado:

```text
M1V2 Phi y
M2V2 Phi y
```

Obligaciones de ventana externas:

```text
window (y - 2) (4*a) <= xRet
window (y + shiftAlphaMinus3Pad) c <= xAdv
```

Obligaciones nested para el bloque EL:

```text
window (y + shift2AlphaMinus5Pad2) child <= ventana nested nivel 2
window (y + shift3AlphaMinus5Pad3) child <= ventana nested nivel 3
```

El factor uniforme `9997/10000` ya fue absorbido aritmeticamente en M0C; el
seam debe justificar que el pad `epsilon0` cubre las perdidas Nat reales de
redondeo en row22/row28.

## Que Ya Esta Probado

### M0A / root-count

```lean
one_le_piStar_of_one_le_a_le_x
root_count_unit_lower_bound_for_window
```

Estado:

```text
ROOT_COUNT_UNIT_LEMMA_PROVED
```

### M0B / filas combinatorias Nat

```lean
d1_core_instantiation
d2_single_branch_core_instantiation
d3_core_instantiation
```

Mas los lemas de residuos para retarded/advanced branches.

### M0C / induccion abstracta

```lean
m0c_retarded_induction_bound_v2 :
  K2RetardedInductionInputsV2 Phi ->
  RetardedLowerBoundConclusion Phi
```

Estado:

```text
M0C_MAIN_INDUCTION_PROVED
ABSTRACT_PHI_BOUND_PROVED
```

### Certificado k=2 / aritmetica padded

Ya estan cerrados:

```lean
base_weighted_of_unit
padded_row22_arithmetic
row25_no_advanced_pad_arithmetic
padded_row28_arithmetic
EL_A
EL_C
row22_assembly
row25_assembly
row28_assembly
```

Tambien estan disponibles los endpoints trascendentales:

```text
BReal in [119/135, 8/9]
DReal in [119/100, 6/5]
```

## Que Falta

### Real-to-Nat window policy

Debe fijarse formalmente:

```text
window y a
```

y probar sus propiedades para:

```text
root in window
retarded exactness or monotone inclusion
advanced conservative inclusion
padded shifted windows
```

Clasificacion:

```text
REAL_TO_NAT_WINDOW_POLICY_OPEN
```

### Monotonicidad

Hacen falta dos niveles:

```text
piStar/window monotonicity:
  x1 <= x2 -> piStar a x1 <= piStar a x2

Phi/envelope monotonicity or lower-envelope transfer:
  pointwise lower bounds over a class -> lower bound for Phi.phi_m
```

M0B ya tiene `reachesWithin_window_mono` en la API Prop, pero la version
cardinal concreta para `piStar` y su transporte a `Phi` siguen como deuda.

Clasificacion:

```text
PHI_MONOTONICITY_OPEN
```

### Mapping de clases

Debe convertirse en API Lean explicita:

```text
root class 2/5/8 -> component phi22/phi25/phi28
retarded class:
  4*(9t+2) mod 9 = 8
  4*(9t+5) mod 9 = 2
  4*(9t+8) mod 9 = 5
advanced D3 split:
  c mod 9 in {5,2,8}
```

Clasificacion:

```text
CLASS_TO_COMPONENT_MAPPING_OPEN
```

### Seam proof to rowsV2

Debe probarse:

```lean
I2ELAbstractRowsV2 Phi
```

desde:

```text
M0B core Nat rows
window inclusions
piStar monotonicity
Phi lower-envelope transfer
rounding ledger with epsilon0 pads
```

Clasificacion:

```text
ROWS_V2_SEAM_PROOF_OPEN
```

### Admisibilidad y ciclos

Los corolarios M0B consumen:

```lean
NotInCycle a
```

El dominio semantico de `Phi` debe decidir si:

```text
1. admissible a incluye NotInCycle a como hipotesis local; o
2. se crea una capa separada que descarga NotInCycle para el dominio usado.
```

No se debe convertir esta deuda en un claim global de Collatz.

## Siguiente Modulo Recomendado

Primer paso Lean recomendado:

```text
CollatzClassical/KL2003/KL2003ConcretePhiScaffolding.lean
```

Alcance sugerido:

```text
structure ConcretePhiRealization
structure ConcreteWindowPolicy
class predicates for residues 2/5/8
zeroExtension contract
lowerEnvelope transfer axioms/as fields, not axioms Lean
root-count-to-BaseSegmentUnitLowerBound using an abstract RootInWindow field
```

No incluir todavia:

```text
sInf implementation
full Real-to-Nat floor proof
rowsV2 seam proof
M1 theorem
```

Segundo paso:

```text
KL2003ConcretePhiWindowPolicy.lean
```

para fijar `window y a`.

Tercer paso:

```text
KL2003RowsV2FromSeam.lean
```

para descargar `I2ELAbstractRowsV2 Phi`.

## Resultado

```text
CONCRETE_PHI_SCOPED = yes
SEAM_BRIDGE_OBLIGATIONS_MAPPED = yes
K2_RETARDED_INPUTS_V2_TARGET_READY = yes
ROOT_COUNT_UNIT_BRIDGE_IDENTIFIED = yes
REAL_TO_NAT_WINDOW_POLICY_OPEN = yes
PHI_MONOTONICITY_OPEN = yes
ROWS_V2_SEAM_PROOF_OPEN = yes
M0D_NOT_STARTED = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
