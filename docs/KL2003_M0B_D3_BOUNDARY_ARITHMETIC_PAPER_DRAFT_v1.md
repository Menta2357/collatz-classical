# KL2003_M0B_D3_BOUNDARY_ARITHMETIC_PAPER_DRAFT_v1

Fecha: 2026-07-08.

Estado: borrador de papel para la inyeccion D3 y su aritmetica de frontera.
No se crea Lean nuevo y no se reclama D3 probado.

## Clasificacion

```text
D3_BOUNDARY_ARITHMETIC_DERIVED_ON_PAPER
D3_INJECTION_ROUTE_SCOPED
NOTINCYCLE_DISJOINTNESS_CONSUMER_READY
ROUNDING_GAP_IDENTIFIED
D3_LEAN_NOT_STARTED
NO_M0_THEOREM
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Hipotesis D3

La fila D3 corresponde a una raiz:

```text
1 <= a
a == 8 mod 9
NotInCycle a
X = 2^y * a
alpha = log_2 3, por tanto 2^alpha = 3
```

El sistema objetivo de papel es:

```text
piStar a X >=
  piStar (4*a) X
  + piStar ((2*a - 1)/3) (X - 2^(y-1))
```

En terminos de la fila `phi_2^8`, esto corresponde a:

```text
phi_2^8(y) >=
  phi_2^5(y-2)
  + min(phi_2^2, phi_2^5, phi_2^8)(y+alpha-1)
```

## Ruta De Inyeccion

Raiz original:

```text
a, con a == 8 mod 9
```

Hijos inversos inmediatos de `a` bajo `T`:

```text
2*a
r_adv = (2*a - 1)/3
```

Para `a == 8 mod 9`, se tiene `2*a - 1 == 15 mod 18`, de modo que
`(2*a - 1)/3` es entero y satisface:

```text
T r_adv = a
```

Rama retardada:

```text
a <- 2*a <- 4*a
```

El subarbol trasladado usa raiz:

```text
r_ret = 4*a
```

y se inyecta en el arbol de `a` anexando la ruta:

```text
4*a -> 2*a -> a
```

Rama avanzada:

```text
a <- r_adv
r_adv = (2*a - 1)/3
```

El subarbol trasladado usa raiz:

```text
r_adv = (2*a - 1)/3
```

y se inyecta en el arbol de `a` anexando la ruta:

```text
r_adv -> a
```

Limite de ventana original:

```text
X = 2^y * a
```

Limites de ventanas trasladadas:

```text
retarded: X
advanced: X - 2^(y-1)
```

La conservacion semantica esperada es:

```text
ReachesWithin (4*a) X n
  -> ReachesWithin a X n

ReachesWithin r_adv (X - 2^(y-1)) n
  -> ReachesWithin a X n
```

La rama avanzada cabe porque `r_adv <= X` y el paso final `r_adv -> a` queda
dentro de la ventana original; la identidad de frontera de abajo explica por
que el parametro natural de la contribucion avanzada es `X - 2^(y-1)`.

## Identidad De Frontera

Objetivo:

```text
2^(y+alpha-1) * (2a-1)/3
=
2^y * a - 2^(y-1)
```

Derivacion:

```text
2^(y+alpha-1) * (2a-1)/3
= 2^y * 2^alpha * 2^(-1) * (2a-1)/3
= 2^y * 3 * (1/2) * (2a-1)/3
= 2^y * (2a-1)/2
= 2^y * (a - 1/2)
= 2^y * a - 2^y * 1/2
= 2^y * a - 2^(y-1)
```

El unico paso trascendental usado es:

```text
2^alpha = 3
```

con `alpha = log_2 3`. El resto es aritmetica de anillos/campos ordenados.

## Por Que Cabe La Rama Avanzada

El termino avanzado de la fila D3 se mide en la escala de la raiz trasladada:

```text
r_adv = (2a-1)/3
```

Con parametro:

```text
y + alpha - 1
```

su frontera continua es:

```text
2^(y+alpha-1) * r_adv
```

Por la identidad anterior:

```text
2^(y+alpha-1) * r_adv = X - 2^(y-1)
```

Asi, cualquier nodo contado en la rama avanzada con ventana trasladada
`X - 2^(y-1)` esta, a nivel continuo, por debajo de `X`. Al anexar el ultimo
paso `r_adv -> a`, la raiz `a` tambien queda dentro de la ventana original
porque `a <= X` en el regimen no vacio de la fila.

La identidad no prueba por si sola la desigualdad discreta completa: solo fija
la frontera continua correcta para la contribucion avanzada.

## Separacion De Responsabilidades

### Aritmetica real/continua

Incluye:

```text
alpha = log_2 3
2^alpha = 3
2^(y+alpha-1) = 2^y * 3 / 2
2^(y+alpha-1) * ((2*a - 1)/3)
  = 2^y*a - 2^(y-1)
```

Esta parte sera futura frontera `Real`/`rpow` si se formaliza literalmente.
Tambien puede separarse en una version algebraica con variables positivas
`P = 2^y` y la hipotesis `2^alpha = 3`.

### Redondeo a conteos enteros

`piStar` esta definido con ventanas naturales. La expresion:

```text
X - 2^(y-1)
```

puede no ser una resta natural literal si `y` todavia es parametro real. La
formalizacion D3 debe elegir una politica explicita:

```text
floor/ceil de X
floor/ceil de X - 2^(y-1)
o una parametrizacion natural directa de la ventana
```

Este es el hueco de redondeo identificado. No debe esconderse dentro del lema
de disyuncion.

### Hipotesis NotInCycle

La disyuncion de ramas requiere:

```text
NotInCycle a
```

Sin esta hipotesis, la disyuncion ingenua de subarboles inversos puede fallar:
una orbita que ya paso por `a` puede volver por un ciclo y tocar otra rama.

### Uso Del Consumidor De Disyuncion

El modulo ya compilado:

```text
CollatzClassical/KL2003/KL2003M0BEntryPredecessorDisjointness.lean
```

aporta el consumidor:

```lean
inverse_children_disjoint_descendants :
  NotInCycle a ->
  c1 != c2 ->
  T c1 = a ->
  T c2 = a ->
  ReachesWithin c1 x n ->
  ReachesWithin c2 x n ->
  a <= x ->
  FirstHitsAt a n k0 ->
  0 < k0 ->
  False
```

Para D3 se instanciara con:

```text
c1 = 2*a
c2 = (2*a - 1)/3
```

La rama retardada `4*a` debe primero descender a `2*a`; la rama avanzada ya
esta directamente bajo `(2*a - 1)/3`.

## Statement Lean Futuro Para D3 Boundary

Una primera version recomendable evita `Real` y `rpow` en el lema de aritmetica
principal, usando un parametro natural/entero `P` que representa `2^y`:

```lean
-- Paper-level algebraic boundary, no Real/rpow yet.
theorem D3_boundary_bound_algebraic
    {P a rAdv : Nat}
    (hrAdv : 3 * rAdv = 2 * a - 1)
    (hEvenP : Even P) :
    P * rAdv * 3 / 2 = P * a - P / 2
```

Esta firma es solo tentativa: el uso de division natural puede ser incomodo si
no se fijan divisibilidad y orden. Una firma mas limpia podria vivir en `Int`
o `Rat`:

```lean
theorem D3_boundary_bound_rat
    {P a : Rat} :
    P * (3 / 2) * ((2 * a - 1) / 3)
      = P * a - P / 2
```

Cuando se abra la capa `Real/rpow`, el statement continuo podria ser:

```lean
theorem D3_boundary_bound_real
    {y alpha a : Real}
    (hpow : (2 : Real) ^ alpha = 3)
    (ha : 0 <= a) :
    (2 : Real) ^ (y + alpha - 1) * ((2*a - 1) / 3)
      = (2 : Real) ^ y * a - (2 : Real) ^ (y - 1)
```

Lemas ya existentes que consumira la futura prueba D3:

```text
boundedReaches_iff
mem_piStarFinset_reachesWithin_iff
exists_firstHitsAt_of_reachesWithin
entry_pred_eq_of_reaches_child
inverse_children_disjoint_descendants
```

El futuro statement D3 completo tambien necesitara:

```text
T (2*a) = a
T ((2*a - 1)/3) = a
2*a != (2*a - 1)/3
conservacion de ventana al anexar rutas
politica de redondeo entero
```

## No Reclamado

```text
D3 no esta probado.
D1/D2 no se tocan salvo comparacion conceptual.
No hay nuevo archivo Lean.
No hay M0 theorem.
No hay M1 theorem.
No hay claim global de Collatz.
```
