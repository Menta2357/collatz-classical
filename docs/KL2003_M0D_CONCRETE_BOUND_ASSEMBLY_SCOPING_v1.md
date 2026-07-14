# KL2003_M0D_CONCRETE_BOUND_ASSEMBLY_SCOPING_v1

Fecha: 2026-07-14.

Estado: scoping documental para el modulo final de ensamblaje M0d. No se crea
Lean nuevo en esta tarea.

## Clasificacion

```text
M0D_SCOPED
K2_INPUTS_V3_CONCRETE_READY_TO_ASSEMBLE
GAMMA_GT_THREE_SEVENTHS_TARGET_DEFINED
NO_M1_THEOREM_YET
NO_GLOBAL_COLLATZ_CLAIM
```

Guardarrailes:

```text
NO_NEW_LEAN
NO_M1_THEOREM_YET
NO_GLOBAL_COLLATZ_CLAIM
NO_UNROUNDED_TO_ROUNDED_WINDOW_SILENT_STEP
NO_CIINF_DIRECTION_CONFUSION
```

## Condicion previa

La condicion previa para M0d es:

```lean
concretePhi_rowsV3 : I2ELAbstractRowsV3 concretePhi
```

Estado actual:

```text
cerrada en CollatzClassical/KL2003/KL2003ConcretePhiRealization.lean
```

M0d solo debe empezar despues de este punto. No debe depender de V2 como
statement fuente.

## Target Lean futuro

Archivo futuro recomendado:

```text
CollatzClassical/KL2003/KL2003M0DConcreteBoundAssembly.lean
```

Imports esperados:

```lean
import CollatzClassical.KL2003.KL2003ConcretePhiRealization
```

Ese import ya trae:

```text
KL2003M0CRetardedInduction
KL2003M0B reachability/core instantiations
root-count unit base
concretePhi
```

## Ensamblaje ya probado

Las piezas que M0d debe ensamblar sin reprobar son:

```lean
concretePhi_zeroExtension :
  K2PhiZeroExtension concretePhi

concretePhi_weightedBase :
  BaseSegmentWeightedLowerBound concretePhi

concretePhi_rowsV3 :
  I2ELAbstractRowsV3 concretePhi
```

Por tanto el primer teorema M0d debe ser mecanico:

```lean
theorem concretePhi_k2_inputs_v3 :
    K2RetardedInductionInputsV3 concretePhi := by
  exact
    k2_retarded_inputs_v3_from_closed_certificate
      concretePhi
      concretePhi_zeroExtension
      concretePhi_weightedBase
      concretePhi_rowsV3
```

Este teorema consume tambien, a traves del constructor cerrado:

```text
k2CertificateData_valid
BReal_within_strong_interval
DReal_within_target_interval
```

## Instanciacion M0C

Segundo teorema objetivo:

```lean
theorem concretePhi_retarded_bound_v3 :
    RetardedLowerBoundConclusion concretePhi := by
  exact m0c_retarded_induction_bound_v3 concretePhi_k2_inputs_v3
```

Expande a:

```text
forall y, 14 <= y ->
  DeltaV2 * c22R * lambdaR^y <= concretePhi.phi22 y
  DeltaV2 * c25R * lambdaR^y <= concretePhi.phi25 y
  DeltaV2 * c28R * lambdaR^y <= concretePhi.phi28 y
```

con:

```lean
DeltaV2 = 1 / (2 * lambdaR ^ (14 : Real))
lambdaR = 27/20
c22R = 73/40
c25R = 1001/1000
c28R = 69/40
```

## Bajar del infimo al miembro concreto

El puente `concretePhi -> piStar` usa la direccion ya disponible:

```lean
concretePhiComponent_le_piStar_of_classRoot :
  0 <= y ->
  (a : ClassRoots m) ->
  concretePhiComponent m y <=
    (piStar a.1 (concreteWindow y a.1) : Real)
```

Conceptualmente es `ciInf_le`: el infimo esta por debajo de cada miembro. La
composicion correcta es:

```text
lower <= concretePhiComponent m y <= piStar a window
```

No se debe invertir esta desigualdad.

Targets por residuo:

```lean
theorem concrete_root_bound_mod2
    {y : Real} (hy14 : 14 <= y) (a : ClassRoots 2) :
    DeltaV2 * c22R * lambdaR ^ y <=
      (piStar a.1 (concreteWindow y a.1) : Real)

theorem concrete_root_bound_mod5
    {y : Real} (hy14 : 14 <= y) (a : ClassRoots 5) :
    DeltaV2 * c25R * lambdaR ^ y <=
      (piStar a.1 (concreteWindow y a.1) : Real)

theorem concrete_root_bound_mod8
    {y : Real} (hy14 : 14 <= y) (a : ClassRoots 8) :
    DeltaV2 * c28R * lambdaR ^ y <=
      (piStar a.1 (concreteWindow y a.1) : Real)
```

La prueba sera:

```text
concretePhi_retarded_bound_v3 hy14
+ concretePhiComponent_le_piStar_of_classRoot
```

con `hy0 : 0 <= y` obtenido de `hy14`.

## Traduccion rpow/window

La conclusion abstracta esta parametrizada por `y`:

```text
piStar a (ceil(2^y * a)) >= DeltaV2 * c_m * lambdaR^y
```

El statement tipo M1-surrogate quiere una variable de ventana:

```text
piStar a x >= Delta * (x/a)^gamma
```

La traduccion no debe hacerse silenciosamente. Hay que separar:

### 1. Identidad de exponentes

Definir:

```lean
noncomputable def gammaK2 : Real := Real.logb 2 lambdaR
```

Meta:

```lean
lambdaR ^ y = ((2 : Real) ^ y) ^ gammaK2
```

Ruta esperada:

```text
lambdaR = 2^gammaK2
lambdaR^y = (2^gammaK2)^y = (2^y)^gammaK2
```

con `Real.rpow_logb`, `Real.rpow_mul`, positividad de `2` y `lambdaR`.

### 2. Ventana concreta

La definicion actual es:

```lean
concreteWindow y a = Nat.ceil ((2 : Real)^y * (a : Real))
```

Por tanto si:

```text
x = concreteWindow y a
```

solo se obtiene:

```text
2^y * a <= x
```

Para obtener una cota en funcion de `(x/a)^gamma`, hay dos opciones futuras:

```text
ceil-window statement:
  piStar a (ceil(2^y*a)) >= DeltaV2*c_m*lambda^y

arbitrary-x statement:
  escoger y = log_2(x/a) o un y con ceil(2^y*a) <= x,
  usar monotonicidad de piStar en x,
  pagar una perdida de constante si se redondea hacia abajo.
```

M0d debe registrar explicitamente que `ceil` va en la direccion:

```text
ceil(2^y*a) >= 2^y*a
```

y que no basta para reemplazar automaticamente `lambda^y` por `(x/a)^gamma`
con la misma constante en una cota para ventana arbitraria `x`.

### 3. Constante Delta

La constante abstracta disponible es:

```text
DeltaV2 * c_m
```

Para un statement uniforme por raiz se puede tomar:

```lean
DeltaConcreteK2 := DeltaV2 * min c22R (min c25R c28R)
```

Como:

```text
c25R = 1001/1000
c28R = 69/40
c22R = 73/40
```

el minimo real esperado es `c25R`, pero M0d no necesita optimizarlo en la
primera version. Tambien es valido escoger una constante mas pequena y mas facil
de probar, por ejemplo:

```text
DeltaV2
```

porque todos los `c_m >= 1`.

Decision recomendada para el primer Lean:

```text
usar DeltaV2 como constante uniforme inicial;
dejar DeltaV2 * minCoeff como refinamiento posterior.
```

## Gamma y cota 3/7

Definir:

```lean
noncomputable def gammaK2 : Real := Real.logb 2 lambdaR
```

Registrar:

```lean
theorem gammaK2_eq_logb :
    gammaK2 = Real.logb 2 (27 / 20 : Real)

theorem gammaK2_gt_three_sevenths :
    (3 / 7 : Real) < gammaK2
```

La prueba real-log debe usar el witness entero ya cerrado:

```lean
k2_gamma_gt_three_sevenths_int :
  8 * 20 ^ 7 < 27 ^ 7
```

Interpretacion:

```text
27^7 > 8 * 20^7
<=> (27/20)^7 > 2^3
<=> log_2(27/20) > 3/7
```

Obligacion auxiliar futura:

```lean
theorem logb_gt_rat_of_pow_gt
    {b x : Real} {p q : Nat}
    (hb : 1 < b) (hx : 0 < x) (hq : 0 < q)
    (hpow : b ^ p < x ^ q) :
    (p : Real) / q < Real.logb b x
```

o una variante especializada a:

```lean
b = 2
x = lambdaR
p = 3
q = 7
```

No usar `native_decide`; el witness entero es `norm_num`-ready en
`KL2003K2CertificateData.lean`.

## Statement M1-surrogate exacto

M0d todavia no debe declarar un `M1 theorem`. El statement final debe quedar
como target separado:

```lean
def M1SurrogateK2CeilWindowStatement : Prop :=
  exists Delta : Real, 0 < Delta /\
    (3 / 7 : Real) < gammaK2 /\
    forall {m : Nat} (hm : m = 2 \/ m = 5 \/ m = 8)
      (a : ClassRoots m) {y : Real},
        14 <= y ->
        Delta * lambdaR ^ y <=
          (piStar a.1 (concreteWindow y a.1) : Real)
```

Luego, solo despues de cerrar el ledger de redondeo/window:

```lean
def M1SurrogateK2ArbitraryWindowStatement : Prop :=
  exists Delta : Real, 0 < Delta /\
    (3 / 7 : Real) < gammaK2 /\
    forall {m : Nat} (hm : m = 2 \/ m = 5 \/ m = 8)
      (a : ClassRoots m) {x : Nat},
        largeEnough a x ->
        Delta * ((x : Real) / a.1) ^ gammaK2 <=
          (piStar a.1 x : Real)
```

`largeEnough` debe incluir:

```text
a >= 1
x >= a
threshold equivalente a y >= 14
rounding direction/floor-or-ceil convention
```

## Orden recomendado M0d

1. Crear `concretePhi_k2_inputs_v3`.
2. Crear `concretePhi_retarded_bound_v3`.
3. Probar los tres `concrete_root_bound_mod{2,5,8}` por `ciInf_le`.
4. Definir `gammaK2`.
5. Probar `gammaK2_gt_three_sevenths` desde `k2_gamma_gt_three_sevenths_int`.
6. Formular solo el statement ceil-window.
7. Dejar arbitrary-window como target posterior si requiere perdida de
   constante o ledger de redondeo.

## No objetivos

M0d scoping no prueba:

```text
K2RetardedInductionInputsV3 concretePhi
m0c_retarded_induction_bound_v3 concretePhi
gammaK2_gt_three_sevenths
ceil-window theorem
arbitrary-window theorem
M1 theorem
global Collatz claim
```

## Resultado

```text
M0D_SCOPED = yes
K2_INPUTS_V3_CONCRETE_READY_TO_ASSEMBLE = yes
GAMMA_GT_THREE_SEVENTHS_TARGET_DEFINED = yes
NO_M1_THEOREM_YET = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
