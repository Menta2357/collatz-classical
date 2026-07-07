# KL2003_M0B_REACHABILITY_PROP_API_SCOPING_v1

Fecha: 2026-07-07.

Estado: scoping documental de una API `Prop` para razonamiento de alcance en
M0B. No se crea Lean y no se prueban D1/D2/D3.

## Clasificacion

```text
M0B_REACHABILITY_PROP_API_SCOPED
REACHES_WITHIN_FUNCTION_ITERATE_DESIGNED
BOOL_FUEL_BRIDGE_SCOPED
PISTAR_PROP_FINSET_BRIDGE_SCOPED
INVERSE_CHILDREN_DISJOINTNESS_CONSUMER_READY
D1_D2_D3_PROP_API_CONSUMERS_MAPPED
NO_NEW_LEAN
NO_D1_D2_D3_PROOF
NO_M0_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Guardarrailes:

```text
NO_NEW_LEAN
NO_D1_D2_D3_PROOF
NO_TREE_INEQUALITY_PROOF
NO_RETARDED_INDUCTION_PROOF
NO_M0_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Base

```text
CollatzClassical/KL2003/KL2003M0APiStarSemantics.lean
docs/KL2003_M0B_D1_D2_D3_TREE_INEQUALITY_SCOPING_v1.md
docs/KL2003_M0A_PI_STAR_SEMANTICS_LEAN_AND_CROSS_VALIDATION_v1.md
docs/KL2003_M0A_THREE_WAY_PI_STAR_VALIDATION_CUSTODY_v1.md
```

M0A conserva la semantica computable:

```lean
def boundedReaches (a x n : Nat) : Bool :=
  boundedReachesWithFuel (x + 1) a x n

def piStarFinset (a x : Nat) : Finset Nat :=
  (Finset.range (x + 1)).filter
    (fun n => 1 <= n ∧ boundedReaches a x n = true)
```

M0B no debe reemplazar estas definiciones. La API `Prop` es una capa de
razonamiento para evitar pruebas fragiles por normalizacion booleana/fuel.

## Definicion principal

Definicion futura:

```lean
def ReachesWithin (a x n : Nat) : Prop :=
  ∃ k,
    (∀ j, j <= k -> Function.iterate T j n <= x) ∧
    Function.iterate T k n = a
```

Lectura:

```text
n alcanza a en algun tiempo k,
y todos los estados desde j=0 hasta j=k permanecen <= x.
```

Notas:

```text
No usa orbitWithFuel.
No menciona x+1.
No exige 1 <= n; esa positividad pertenece al filtro piStar.
No exige primer hit; para disyuncion de ramas basta combinarlo con
determinismo y NotInCycle.
```

## Predicados auxiliares

Para que D1/D2/D3 no dependan de detalles booleanos:

```lean
def InverseChild (a c : Nat) : Prop :=
  T c = a

def NotInCycle (a : Nat) : Prop :=
  ∀ q, 0 < q -> Function.iterate T q a ≠ a

def PathWithin (src dst x len : Nat) : Prop :=
  (∀ j, j <= len -> Function.iterate T j src <= x) ∧
  Function.iterate T len src = dst
```

`PathWithin` es la herramienta para anexar rutas fijas como:

```text
4*a -> 2*a -> a
(4*a - 2)/3 -> (2*a - 1)/3 -> a
(2*a - 1)/3 -> a
```

Si despues conviene razonar con primer hit, anadirlo como API secundaria, no
como definicion primaria:

```lean
def FirstReachesWithin (a x n : Nat) : Prop :=
  ∃ k,
    (∀ j, j <= k -> Function.iterate T j n <= x) ∧
    Function.iterate T k n = a ∧
    (∀ j, j < k -> Function.iterate T j n ≠ a)
```

Pero `inverse_children_disjoint_descendants` no deberia necesitar
`FirstReachesWithin` si `NotInCycle a` esta disponible.

## API de composicion

Lemas recomendados antes de D1/D2/D3:

```lean
theorem reachesWithin_window_mono
    (h : ReachesWithin a x n) (hx : x <= X) :
    ReachesWithin a X n

theorem reachesWithin_append_path
    (h : ReachesWithin src x n)
    (hx : x <= X)
    (hp : PathWithin src dst X len) :
    ReachesWithin dst X n

theorem reachesWithin_self
    (hax : a <= x) :
    ReachesWithin a x a
```

`reachesWithin_append_path` sera el motor de las inyecciones D1/D2/D3: se
toma el mismo entero `n` y se anexa una ruta final desde la raiz destino hasta
la raiz origen.

## Bridge con M0A Bool/fuel

M0A ya usa `boundedReaches`; M0B necesita un puente, no una redefinicion.

Lemas de puente:

```lean
theorem boundedReaches_sound
    (h : boundedReaches a x n = true) :
    ReachesWithin a x n

theorem boundedReaches_complete_of_pos
    (hn : 1 <= n)
    (h : ReachesWithin a x n) :
    boundedReaches a x n = true

theorem boundedReaches_iff_reachesWithin_of_pos
    (hn : 1 <= n) :
    boundedReaches a x n = true ↔ ReachesWithin a x n
```

`boundedReaches_sound` es estructural por recursion sobre fuel.

`boundedReaches_complete_of_pos` requiere un argumento finito:

```text
si una orbita positiva alcanza a mientras permanece en [1,x],
antes del primer hit no repite estados;
por tanto el primer hit ocurre en <= x pasos,
y el fuel x+1 de M0A lo detecta.
```

Este lema es el unico punto donde aparece el diseno `fuel = x + 1`. Despues de
este puente, M0B debe trabajar con `ReachesWithin`.

## Bridge con piStarFinset

Se recomienda introducir un finset Prop auxiliar:

```lean
def piStarPropFinset (a x : Nat) : Finset Nat :=
  (Finset.range (x + 1)).filter
    (fun n => 1 <= n ∧ ReachesWithin a x n)
```

Bridge esperado:

```lean
theorem mem_piStarPropFinset_iff :
    n ∈ piStarPropFinset a x ↔
      n <= x ∧ 1 <= n ∧ ReachesWithin a x n

theorem piStarPropFinset_eq_piStarFinset :
    piStarPropFinset a x = piStarFinset a x
```

La igualdad final consume `boundedReaches_iff_reachesWithin_of_pos`. Luego las
pruebas de cardinalidad de M0B pueden formularse sobre `piStarPropFinset` y
transferirse a `piStarFinset`.

## Consumidor principal

Primer lema consumidor:

```lean
theorem inverse_children_disjoint_descendants
    (hcycle : NotInCycle a)
    (hc1 : InverseChild a c1)
    (hc2 : InverseChild a c2)
    (hne : c1 ≠ c2)
    (h1 : ReachesWithin c1 x1 n)
    (h2 : ReachesWithin c2 x2 n) :
    False
```

Idea formal:

```text
De h1 hay k1 con T^k1 n = c1.
De h2 hay k2 con T^k2 n = c2.

Si k1 = k2, entonces c1 = c2, contradiccion.

Si k1 < k2:
  T^(k1+1) n = a.
  T^(k2+1) n = a.
  La parte de la orbita desde a hasta el segundo a da un ciclo positivo de a.

Si k2 < k1, simetrico.
```

Las ventanas `x1`, `x2` no son importantes para la contradiccion, salvo porque
dan los witnesses de reachability. La disyuncion es realmente determinismo de
`T` + exclusion de ciclos.

## Consumidores D1/D2/D3

### D1_injection

Necesita:

```lean
D1_ret_path :
  PathWithin (4*a) a X 2

D1_adv_path :
  PathWithin ((4*a - 2)/3) a X 2
```

Uso:

```text
ReachesWithin (4*a) X n
  -> ReachesWithin a X n

ReachesWithin ((4*a - 2)/3) (X - 2^(y-1)) n
  -> ReachesWithin a X n
```

por `reachesWithin_append_path`, `window_mono`, y la aritmetica de frontera.

### D1_disjointness

Necesita primero bajar cada subarbol al hijo inmediato:

```text
4*a reaches 2*a
(4*a - 2)/3 reaches (2*a - 1)/3
```

Luego:

```lean
inverse_children_disjoint_descendants
  (a := a)
  (c1 := 2*a)
  (c2 := (2*a - 1)/3)
```

Hipotesis aritmeticas:

```text
T (2*a) = a
T ((2*a - 1)/3) = a
2*a != (2*a - 1)/3
a not in a cycle
```

### D1_boundary_bound

No usa la API de reachability salvo para alimentar `PathWithin`.

Targets:

```text
2^(y-2) * (4*a) = 2^y * a
2^(y+alpha-2) * ((4*a - 2)/3) = 2^y*a - 2^(y-1)
```

### D2_injection

Necesita:

```lean
D2_ret_path :
  PathWithin (4*a) a X 2
```

Uso:

```text
ReachesWithin (4*a) X n -> ReachesWithin a X n
```

### D2_disjointness

Singleton/vacia:

```text
no hay suma de dos subarboles en D2;
la obligacion de disyuncion es trivial para la familia singleton.
```

No debe usarse para inventar una segunda rama.

### D2_boundary_bound

Target:

```text
2^(y-2) * (4*a) = 2^y*a
```

### D3_injection

Necesita:

```lean
D3_ret_path :
  PathWithin (4*a) a X 2

D3_adv_path :
  PathWithin ((2*a - 1)/3) a X 1
```

Uso:

```text
ReachesWithin (4*a) X n
  -> ReachesWithin a X n

ReachesWithin ((2*a - 1)/3) (X - 2^(y-1)) n
  -> ReachesWithin a X n
```

### D3_disjointness

Usa:

```lean
inverse_children_disjoint_descendants
  (a := a)
  (c1 := 2*a)
  (c2 := (2*a - 1)/3)
```

con:

```text
subtree rooted at 4*a lies below child 2*a
subtree rooted at (2*a - 1)/3 is exactly the other child
```

### D3_boundary_bound

Targets:

```text
2^(y-2) * (4*a) = 2^y*a
2^(y+alpha-1) * ((2*a - 1)/3) = 2^y*a - 2^(y-1)
```

## Minimal Lean module futuro

Nombre recomendado, pero no crear todavia:

```text
CollatzClassical/KL2003/KL2003M0BReachabilityAPI.lean
```

Imports probables:

```lean
import CollatzClassical.KL2003.KL2003M0APiStarSemantics
import Mathlib.Logic.Function.Iterate
import Mathlib.Data.Finset.Card
import Mathlib.Tactic.Omega
```

Contenido permitido:

```text
ReachesWithin
InverseChild
NotInCycle
PathWithin
piStarPropFinset
bridge Bool <-> Prop
reachesWithin_window_mono
reachesWithin_append_path
inverse_children_disjoint_descendants
```

Contenido prohibido:

```text
D1/D2/D3 proofs
boundary arithmetic with Real alpha
retarded induction
M0 theorem
M1 theorem
global Collatz claim
native_decide
```

## Riesgos y decisiones

### ReachesWithin no exige primer hit

Esto mantiene la API pequena. Para disyuncion, `NotInCycle a` basta porque dos
hijos distintos alcanzados por la misma orbita forzarian dos visitas a `a`.

Si la prueba en Lean se vuelve incomoda, introducir `FirstReachesWithin` como
lema auxiliar, no como reemplazo de la API principal.

### Complete bridge no es una simplificacion

`boundedReaches_complete_of_pos` contiene el argumento finito que justifica el
fuel `x+1`. Debe auditarse como parte del puente M0A->M0B, no esconderse en
simp.

### Ventanas distintas

`inverse_children_disjoint_descendants` debe aceptar `x1` y `x2` distintos.
D1/D3 comparan una rama con ventana `X` y otra con ventana `X - 2^(y-1)`.

### Cero y positividad

`ReachesWithin` permite `n=0`; `piStarPropFinset` debe seguir filtrando
`1 <= n`. Esto preserva la exclusion del ciclo artificial `0 -> 0`.

## Resultado

```text
M0B_REACHABILITY_PROP_API_SCOPED = yes
REACHES_WITHIN_FUNCTION_ITERATE_DESIGNED = yes
BOOL_FUEL_BRIDGE_SCOPED = yes
PISTAR_PROP_FINSET_BRIDGE_SCOPED = yes
INVERSE_CHILDREN_DISJOINTNESS_CONSUMER_READY = yes
D1_D2_D3_PROP_API_CONSUMERS_MAPPED = yes
NO_NEW_LEAN = yes
NO_D1_D2_D3_PROOF = yes
NO_M0_PROOF = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
