# KL2003_BASE_SEGMENT_UNIT_FROM_ROOT_COUNT_SCOPING_v1

Fecha: 2026-07-10.

Estado: scoping documental del puente semantico minimo para descargar
`BaseSegmentUnitLowerBound Phi` desde root-count/piStar. No se crea Lean nuevo,
no se reabre el ledger de redondeos y no se prueba M0/M1.

## Clasificacion

```text
BASE_SEGMENT_UNIT_BRIDGE_SCOPED
ROOT_COUNT_SEMANTIC_DEBT_ISOLATED
M0C_WEIGHTED_BASE_CONSUMER_READY
NO_RETARDED_INDUCTION
NO_SCALING_LEDGER
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Guardarrailes:

```text
NO_NEW_M1_THEOREM
NO_GLOBAL_COLLATZ
NO_COLLATZ_CLOSURE
NO_ALMOST_ALL
NO_SEAM_LEDGER_REOPEN
```

## Objetivo Formal Local

M0C ya define y consume:

```lean
def BaseSegmentUnitLowerBound (Phi : K2PhiSystem) : Prop :=
  forall y, 0 <= y -> y <= 14 ->
    1 <= Phi.phi22 y /\
    1 <= Phi.phi25 y /\
    1 <= Phi.phi28 y
```

M0C tambien prueba:

```lean
base_weighted_of_unit :
  BaseSegmentUnitLowerBound Phi ->
  BaseSegmentWeightedLowerBound Phi
```

Por tanto la deuda restante para la base es solo semantica:

```text
root-count/piStar -> BaseSegmentUnitLowerBound Phi
```

No pertenece a esta deuda:

```text
retarded induction
filas EL
D1/D2/D3
ledger de redondeos
M1 theorem
```

## Phi Semantico Necesario

El `Phi : K2PhiSystem` que M0C consume debe realizar las tres envolventes por
clase residual:

```text
Phi.phi22 y  representa phi_2^2(y)
Phi.phi25 y  representa phi_2^5(y)
Phi.phi28 y  representa phi_2^8(y)
```

Lectura matematica esperada, aun documental:

```text
phi_2^m(y) =
  inf { pi_a^*(x_y(a)) :
        a ≡ m (mod 9),
        a in domain_KL,
        window_policy y a = x_y(a) }
```

donde:

```text
m ∈ {2,5,8}
domain_KL incluye 1 <= a y las hipotesis locales necesarias, por ejemplo
  exclusiones de ciclo si se consumen en las filas de arbol.
x_y(a) es una ventana natural derivada de 2^y * a.
```

Para la base unitaria no se necesita la forma completa de las filas EL. Se
necesita solo esta propiedad de realizacion:

```text
si para toda raiz admisible a de la clase m se tiene
  1 <= piStar a (x_y(a)),
entonces
  1 <= Phi.phi_m y.
```

En Lean, esto puede implementarse de dos maneras:

```text
1. Phi concreto como inf/sInf de conteos por clase;
2. una estructura de realizacion semantica que incluya directamente el lema
   lower-envelope-from-pointwise-lower-bound.
```

La opcion 2 parece mas robusta para el primer puente, porque evita adelantar
decisiones pesadas sobre `sInf` de `Real`, no vacuidad del dominio y
completitud condicional. La realizacion concreta exacta puede venir despues.

## Root-count Puntual

M0A ya tiene:

```lean
one_le_piStar_of_one_le_a_le_x :
  1 <= a -> a <= x -> 1 <= piStar a x
```

La idea semantica puntual es inmediata:

```text
si 1 <= a
y la ventana x_y(a) satisface a <= x_y(a),
entonces la raiz a pertenece a piStarFinset a x_y(a)
por la orbita de longitud 0,
por tanto 1 <= piStar a x_y(a).
```

Este argumento no usa:

```text
D1/D2/D3
disyuncion de ramas
entry predecessor
retarded induction
slacks del certificado
ledger de redondeo advanced
```

Tampoco necesita demostrar que `a` no esta en un ciclo: la raiz se cuenta a si
misma por hit de longitud cero. La condicion `NotInCycle` puede seguir siendo
parte del dominio KL para otros usos, pero no es usada por root-count.

## Ventana Natural

El puente debe registrar una politica de ventana por separado. La forma
esperada es:

```text
x_y(a) ≈ 2^y * a
```

con una eleccion Nat como:

```text
x_y(a) = floor(2^y * a)
```

o una variante `ceil`/conservadora si el seam posterior la exige.

Para root-count se requiere solo:

```text
RootInWindow y a x_y(a) : a <= x_y(a)
```

En el segmento base:

```text
0 <= y <= 14
```

esta condicion debe seguir de:

```text
2^y >= 1
1 <= a
```

y de la politica de redondeo elegida. Por ejemplo, con `floor(2^y * a)` la
obligacion real/Nat futura es:

```text
a <= floor(2^y * a)
```

si `0 <= y` y `1 <= a`. Esta obligacion es parte del puente
real-to-Nat/window, no de M0C.

## Mapping De Clases

El bridge por clases debe producir tres instancias paralelas:

```text
class 2 mod 9 -> Phi.phi22
class 5 mod 9 -> Phi.phi25
class 8 mod 9 -> Phi.phi28
```

Para cada `m`, el argumento base es:

```text
forall y, 0 <= y -> y <= 14 ->
  forall admissible a, a % 9 = m ->
    1 <= piStar a (x_y(a))
```

y despues el principio de lower-envelope da:

```text
1 <= Phi.phi_m y.
```

Precaucion: si se define `Phi.phi_m` como un inf concreto sobre raices
admisibles, el modulo futuro debe gestionar explicitamente:

```text
no vacuidad del dominio, o
una definicion de envelope que no produzca resultados espurios en dominios
vacios.
```

Para el primer Lean conviene no meter esta deuda junto con el root-count Nat.

## Separacion De Capas

### Conteo piStar/root-count

Responsabilidad:

```text
1 <= a
a <= x
=> 1 <= piStar a x
```

Ya esta probado en M0A.

### Ventanas Real -> Nat

Responsabilidad:

```text
0 <= y
1 <= a
x = window y a
=> a <= x
```

Pendiente. Aqui entran `floor`/`ceil`, `2^y`, coerciones `Nat -> Real` y
monotonicidad real.

### Mapping de clases

Responsabilidad:

```text
residuo 2/5/8 mod 9
-> componente phi22/phi25/phi28
```

Es administrativo, pero debe estar explicito para no mezclar clases de child
con filas de caller.

### M0C

Responsabilidad ya cerrada:

```text
BaseSegmentUnitLowerBound Phi
=> BaseSegmentWeightedLowerBound Phi
```

M0C no importa `piStar` y debe permanecer abstracto.

### Ledger de redondeos

No se reabre aqui. El base segment widening `[0,14]` y
`DeltaV2 = (20/27)^14 / 2` ya estan fijados. Este scoping solo descarga la
unidad base semantica.

## Siguiente Lean Recomendado

Decision: el siguiente Lean no debe ser todavia el bridge completo
`piStar -> BaseSegmentUnitLowerBound`.

Orden recomendado:

```text
B. lemma root-count por clase / ventana abstracta
```

antes que:

```text
A. modulo semantico abstracto con Phi instanciado por piStar
C. bridge completo piStar -> BaseSegmentUnitLowerBound
```

Motivo:

```text
el lema Nat root-count ya puede compilar contra M0A;
el gap Real->Nat/window queda como hipotesis explicita;
la definicion concreta de Phi como inf/envelope puede elegirse despues sin
contaminar el lema puntual.
```

Forma sugerida del siguiente modulo:

```text
CollatzClassical/KL2003/KL2003BaseSegmentUnitRootCount.lean
```

Contenido minimo:

```lean
structure BaseWindowPolicy where
  window : Real -> Nat -> Nat

def RootInWindow (W : BaseWindowPolicy) : Prop :=
  forall y a, 0 <= y -> y <= 14 -> 1 <= a -> a <= W.window y a

theorem one_le_piStar_base_window
    (hroot : RootInWindow W)
    (hy0 : 0 <= y) (hy14 : y <= 14)
    (ha : 1 <= a) :
    1 <= piStar a (W.window y a)
```

Despues, un modulo posterior puede anadir:

```text
PhiSemanticRealization
RootInWindow
pointwise root-count
=> BaseSegmentUnitLowerBound Phi
```

## Resultado

```text
BASE_SEGMENT_UNIT_BRIDGE_SCOPED = yes
ROOT_COUNT_SEMANTIC_DEBT_ISOLATED = yes
M0C_WEIGHTED_BASE_CONSUMER_READY = yes
NO_RETARDED_INDUCTION = yes
NO_SCALING_LEDGER = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
