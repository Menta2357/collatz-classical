# KL2003_M0B_D1_D2_D3_TREE_INEQUALITY_SCOPING_v1

Fecha: 2026-07-07.

Estado: scoping matematico/formal de las desigualdades semanticas D1/D2/D3
del sistema `k=2`. No se crea Lean y no se prueba ninguna fila.

## Clasificacion

```text
M0B_TREE_INEQUALITY_SCOPED
D1_OBJECTS_NAMED
D2_OBJECTS_NAMED
D3_OBJECTS_NAMED
INVERSE_CHILDREN_DISJOINTNESS_LEMMA_IDENTIFIED
BOUNDARY_ARITHMETIC_TARGETS_IDENTIFIED
CYCLE_EXCLUSION_DEPENDENCE_EXPLICIT
NO_LEAN_PROOF
NO_D1_D2_D3_PROVED
NO_M0_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Guardarrailes:

```text
NO_NEW_LEAN
NO_D1_D2_D3_PROOF
NO_RETARDED_INDUCTION_PROOF
NO_M0_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Base

```text
docs/KRASIKOV_M1_FEASIBILITY_RECONSTRUCTION_REPORT_v1.md
docs/KL2003_M0_SEMANTIC_BRIDGE_SCOPING_v1.md
docs/KL2003_M0A_COMPUTABLE_PI_STAR_SEMANTICS_SCOPING_v1.md
docs/KL2003_M0A_PI_STAR_SEMANTICS_LEAN_AND_CROSS_VALIDATION_v1.md
docs/KL2003_M0A_THREE_WAY_PI_STAR_VALIDATION_CUSTODY_v1.md
docs/KL2003_M0A_PISTAR_ZERO_AND_ROOT_BASE_LEMMAS_v1.md
docs/KL2003_M0C_RETARDED_INDUCTION_SCOPING_v1.md
CollatzClassical/KL2003/KL2003M0APiStarSemantics.lean
```

M0A ya fija:

```text
T(n) = n/2              si n es par
T(n) = (3*n + 1)/2      si n es impar
piStarFinset a x
boundedReaches a x n
```

y ya prueba que:

```text
x < a -> piStarFinset a x = empty
1 <= a <= x -> a in piStarFinset a x
```

M0B no debe cambiar esas definiciones.

## Sistema I_2 objetivo

Para `alpha = log_2(3)`, el sistema pequeno original es:

```text
D1, raiz a == 2 mod 9:
phi_2^2(y) >=
  phi_2^8(y-2)
  + min(phi_2^2, phi_2^5, phi_2^8)(y+alpha-2)

D2, raiz a == 5 mod 9:
phi_2^5(y) >=
  phi_2^2(y-2)

D3, raiz a == 8 mod 9:
phi_2^8(y) >=
  phi_2^5(y-2)
  + min(phi_2^2, phi_2^5, phi_2^8)(y+alpha-1)
```

El scoping de M0B debe empezar por desigualdades concretas de `piStar`, para
una raiz positiva `a` que no esta en un ciclo, y despues pasar a infimos
`phi_2^m`.

Convencion local:

```text
X = 2^y * a
```

En Lean este `X` no debe introducirse como real sin plan previo. La primera
formalizacion probablemente usara parametros naturales o enteros para las
ventanas concretas, mas lemmas de frontera separados para conectar con el
parametro real `y`.

## Predecesores inversos

Los predecesores de un nodo `z` bajo `T` son:

```text
2*z                         siempre
(2*z - 1) / 3               si 2*z - 1 es divisible por 3
```

Para raices `a == 2,5,8 mod 9`, el segundo predecesor existe porque
`a == 2 mod 3`.

La prueba de cada fila debe seleccionar subarboles inversos acotados dentro del
arbol inverso de raiz `a`, demostrar que son disjuntos, y comprobar que sus
ventanas caben en `X`.

## D1: raiz 2 mod 9

Hipotesis de fila:

```text
1 <= a
a == 2 mod 9
a not in a cycle
X = 2^y * a
```

### D1_injection

Objeto:

```text
D1_injection
```

Desigualdad concreta esperada:

```text
piStar a X >=
  piStar (4*a) X
  + piStar ((4*a - 2)/3) (X - 2^(y-1))
```

Raiz origen:

```text
a, con a == 2 mod 9
```

Raices destino:

```text
r_ret = 4*a
r_adv = (4*a - 2)/3
```

Residuo:

```text
r_ret == 8 mod 9
r_adv == 2 mod 3, y por tanto cae en una de 2,5,8 mod 9
```

Transformacion de subarbol:

```text
retarded branch:
  a <- 2*a <- 4*a

advanced branch:
  c = (2*a - 1)/3
  r_adv = 2*c = (4*a - 2)/3
  a <- c <- r_adv
```

La inyeccion de nodos es la identidad sobre `n`: si `n` esta en el subarbol
acotado de `r_ret` o `r_adv`, entonces se ve como el mismo entero `n` dentro
del arbol acotado de `a`, anexando la ruta final hasta `a`.

Conservacion de `boundedReaches`:

```text
boundedReaches r_ret X n = true
  -> boundedReaches a X n = true

boundedReaches r_adv (X - 2^(y-1)) n = true
  -> boundedReaches a X n = true
```

En el segundo caso se necesita `X - 2^(y-1) <= X`, y que los nodos de la ruta
`r_adv -> c -> a` esten `<= X`.

### D1_disjointness

Objeto:

```text
D1_disjointness
```

Los dos subarboles seleccionados viven bajo hijos inversos distintos de `a`:

```text
2*a
c = (2*a - 1)/3
```

La prueba debe reducirse al lema generico:

```text
distinct inverse children -> bounded descendant subtrees disjoint
```

Especializacion D1:

```text
subtree rooted at 4*a lies below child 2*a
subtree rooted at (4*a - 2)/3 lies below child (2*a - 1)/3
2*a != (2*a - 1)/3
```

La hipotesis `a not in a cycle` entra aqui. Sin ella, un nodo puede volver a
atravesar la raiz y solapar ramas; el sanity historico ya detecto esta clase
de fallo en el ciclo positivo `1 <-> 2`.

### D1_boundary_bound

Objeto:

```text
D1_boundary_bound
```

Retarded branch:

```text
2^(y-2) * (4*a) = 2^y * a = X
```

Advanced branch:

```text
2^(y+alpha-2) * ((4*a - 2)/3)
  = 2^y*a - 2^(y-1)
```

Justificacion formal esperada:

```text
2^alpha = 3
2^(y+alpha-2) = 2^y * 3 / 4
(3/4) * ((4*a - 2)/3) = a - 1/2
```

Por tanto:

```text
2^y * (a - 1/2) = 2^y*a - 2^(y-1)
```

Esta igualdad es aritmetica de frontera; no pertenece al lema de disyuncion.

## D2: raiz 5 mod 9

Hipotesis de fila:

```text
1 <= a
a == 5 mod 9
a not in a cycle
X = 2^y * a
```

### D2_injection

Objeto:

```text
D2_injection
```

Desigualdad concreta esperada:

```text
piStar a X >=
  piStar (4*a) X
```

Raiz origen:

```text
a, con a == 5 mod 9
```

Raiz destino:

```text
r_ret = 4*a
```

Residuo:

```text
r_ret == 2 mod 9
```

Transformacion de subarbol:

```text
a <- 2*a <- 4*a
```

Conservacion de `boundedReaches`:

```text
boundedReaches (4*a) X n = true
  -> boundedReaches a X n = true
```

La ruta agregada `4*a -> 2*a -> a` queda dentro de `X` cuando la ventana
retardada no es vacia. Si la ventana esta por debajo de la raiz destino, M0A
ya aporta el lema de cero por debajo de la raiz.

### D2_disjointness

Objeto:

```text
D2_disjointness
```

Para la fila D2 original solo se selecciona un subarbol. La disyuncion es por
tanto vacia/singleton:

```text
pairwise disjoint [subtree rooted at 4*a]
```

El otro hijo inverso inmediato existe:

```text
c = (2*a - 1)/3
```

pero para `a == 5 mod 9` se tiene:

```text
c == 0 mod 3
```

y no produce una clase principal `2,5,8 mod 9` del sistema `k=2`. M0B no debe
inventar una segunda contribucion para D2.

### D2_boundary_bound

Objeto:

```text
D2_boundary_bound
```

Unica frontera requerida:

```text
2^(y-2) * (4*a) = 2^y * a = X
```

Esta es una identidad aritmetica pura.

## D3: raiz 8 mod 9

Hipotesis de fila:

```text
1 <= a
a == 8 mod 9
a not in a cycle
X = 2^y * a
```

### D3_injection

Objeto:

```text
D3_injection
```

Desigualdad concreta esperada:

```text
piStar a X >=
  piStar (4*a) X
  + piStar ((2*a - 1)/3) (X - 2^(y-1))
```

Raiz origen:

```text
a, con a == 8 mod 9
```

Raices destino:

```text
r_ret = 4*a
r_adv = (2*a - 1)/3
```

Residuo:

```text
r_ret == 5 mod 9
r_adv == 2 mod 3, y por tanto cae en una de 2,5,8 mod 9
```

Transformacion de subarbol:

```text
retarded branch:
  a <- 2*a <- 4*a

advanced branch:
  a <- r_adv
```

Conservacion de `boundedReaches`:

```text
boundedReaches (4*a) X n = true
  -> boundedReaches a X n = true

boundedReaches r_adv (X - 2^(y-1)) n = true
  -> boundedReaches a X n = true
```

La primera inyeccion anexa `4*a -> 2*a -> a`. La segunda anexa solo
`r_adv -> a`.

### D3_disjointness

Objeto:

```text
D3_disjointness
```

Los subarboles seleccionados quedan bajo hijos inversos distintos de `a`:

```text
2*a
r_adv = (2*a - 1)/3
```

Especializacion del lema generico:

```text
subtree rooted at 4*a lies below child 2*a
subtree rooted at (2*a - 1)/3 is the other child
2*a != (2*a - 1)/3
```

De nuevo, la dependencia en `a not in a cycle` es real y debe quedar explicita
en el statement Lean futuro.

### D3_boundary_bound

Objeto:

```text
D3_boundary_bound
```

Retarded branch:

```text
2^(y-2) * (4*a) = 2^y * a = X
```

Advanced branch:

```text
2^(y+alpha-1) * ((2*a - 1)/3)
  = 2^y*a - 2^(y-1)
```

Justificacion formal esperada:

```text
2^alpha = 3
2^(y+alpha-1) = 2^y * 3 / 2
(3/2) * ((2*a - 1)/3) = a - 1/2
```

Por tanto:

```text
2^y * (a - 1/2) = 2^y*a - 2^(y-1)
```

Esta es la identidad mencionada en la compuerta M0B.

## Lema generico de disyuncion

Primer lema Lean recomendable antes de D1/D2/D3:

```text
inverse_children_disjoint_descendants
```

Forma conceptual:

```text
si
  T c1 = a
  T c2 = a
  c1 != c2
  a not in a cycle
entonces
  los nodos que alcanzan c1 antes de a
  y los nodos que alcanzan c2 antes de a
  son disjuntos.
```

Version con ventanas:

```text
boundedReaches c1 x1 n = true
boundedReaches c2 x2 n = true
same n
T c1 = a
T c2 = a
c1 != c2
a not in a cycle
------------------------------------------------
False
```

Esta forma probablemente requerira un puente Prop desde el Bool computable
`boundedReaches`, porque razonar solo por normalizacion booleana sera fragil.

Definiciones auxiliares probables:

```text
IteratesTo source target steps
FirstHits source target
NotInCycle a
InverseChild a c := T c = a
```

M0B debe decidir si conservar `boundedReaches` como Bool en el statement o
crear una relacion Prop equivalente y luego probar equivalencia con M0A.

## Separacion de obligaciones

### Ya anclado por M0A

```text
T computable
boundedReaches computable con fuel x+1
piStarFinset por Finset.filter
mem_piStarFinset_iff
zero_not_mem_piStarFinset
piStarFinset_eq_empty_of_x_lt_a
piStar_eq_zero_of_x_lt_a
a_mem_piStarFinset_self_window
one_le_piStar_of_one_le_a_le_x
three-way validation: forward orbit = Lean-mirroring = inverse BFS
```

### Puramente aritmetico

```text
residue facts:
  a == 2 mod 9 -> 4*a == 8 mod 9
  a == 5 mod 9 -> 4*a == 2 mod 9
  a == 8 mod 9 -> 4*a == 5 mod 9

integer predecessor facts:
  a == 2 mod 9 -> (2*a - 1)/3 integer and (4*a - 2)/3 integer
  a == 5 mod 9 -> (2*a - 1)/3 integer and divisible by 3
  a == 8 mod 9 -> (2*a - 1)/3 integer

path facts:
  T (2*a) = a
  T (4*a) = 2*a
  D1: T ((4*a - 2)/3) = (2*a - 1)/3, T ((2*a - 1)/3) = a
  D3: T ((2*a - 1)/3) = a

boundary identities:
  2^(y-2) * (4*a) = 2^y*a
  2^(y+alpha-2) * ((4*a - 2)/3) = 2^y*a - 2^(y-1)
  2^(y+alpha-1) * ((2*a - 1)/3) = 2^y*a - 2^(y-1)
```

### Requiere teoria de arbol inverso

```text
identity injection of bounded destination subtree into source subtree;
append path preserves boundedReaches;
selected subtrees under distinct inverse children are disjoint;
translation from concrete piStar inequalities to phi infimum inequalities.
```

### Depende de exclusion de ciclos

```text
inverse_children_disjoint_descendants;
propagacion de "not in a cycle" desde a hacia raices seleccionadas;
evitar solapamientos que atraviesan a y vuelven por el ciclo.
```

La hipotesis `a not in a cycle` no debe borrarse ni reemplazarse por un sanity
finito. El sanity historico mostro que excluir el ciclo `1 <-> 2` cambia la
validez de las filas.

## Ruta Lean futura

Orden recomendado:

```text
1. Definir una relacion Prop para reachability/first-hit, o una API Prop sobre
   boundedReaches.
2. Probar equivalencia suficiente con `piStarFinset`.
3. Probar `inverse_children_disjoint_descendants`.
4. Probar lemmas de inclusion de subarbol para una ruta fija:
   child/grandchild reaches root and window preservation.
5. Probar aritmetica de residuos y fronteras D1/D2/D3.
6. Solo entonces ensamblar `D1_injection + D1_disjointness + D1_boundary_bound`,
   y analogos D2/D3.
```

No crear aun:

```text
CollatzClassical/KL2003/KL2003M0BD1D2D3TreeInequalities.lean
```

## Resultado

```text
M0B_TREE_INEQUALITY_SCOPED = yes
D1_OBJECTS_NAMED = yes
D2_OBJECTS_NAMED = yes
D3_OBJECTS_NAMED = yes
INVERSE_CHILDREN_DISJOINTNESS_LEMMA_IDENTIFIED = yes
BOUNDARY_ARITHMETIC_TARGETS_IDENTIFIED = yes
CYCLE_EXCLUSION_DEPENDENCE_EXPLICIT = yes
NO_LEAN_PROOF = yes
NO_D1_D2_D3_PROVED = yes
NO_M0_PROOF = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
