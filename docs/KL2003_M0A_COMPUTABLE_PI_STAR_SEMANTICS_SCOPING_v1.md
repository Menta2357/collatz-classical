# KL2003_M0A_COMPUTABLE_PI_STAR_SEMANTICS_SCOPING_v1

Fecha: 2026-07-07.

Estado: scoping documental de la semantica computable de `piStar`.
No se crea Lean nuevo en esta tarea.

## Clasificacion

```text
M0A_PI_STAR_SEMANTICS_SCOPED
COMPUTABLE_FINSET_DESIGN_READY
ORBIT_WITH_FUEL_DESIGN_READY
CROSS_VALIDATION_PLAN_READY
CYCLE_HANDLING_EXPLICIT
NO_D1_D2_D3_YET
NO_M0_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Guardarrailes:

```text
NO_NEW_LEAN_UNLESS_EXPLICITLY_REQUESTED
NO_D1_D2_D3
NO_M0_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Base

```text
docs/KL2003_M0_SEMANTIC_BRIDGE_SCOPING_v1.md
docs/KRASIKOV_M1_FEASIBILITY_RECONSTRUCTION_REPORT_v1.md
CollatzClassical/KL2003/KL2003K2CertificateData.lean
CollatzClassical/KL2003/KL2003K2CertificateVerifier.lean
CollatzClassical/KL2003/KL2003K2AlphaBounds.lean
CollatzClassical/KL2003/KL2003K2TranscendentalEndpoints.lean
```

La torre numerica k=2 ya existe. Esta nota no toca esa torre. Solo fija la
semantica computable de conteo que debe existir antes de D1/D2/D3.

## Mapa conceptual

KL2003 usa:

```text
T(n) = n/2              si n es par
T(n) = (3*n + 1)/2      si n es impar
```

`pi_a^*(x)` cuenta enteros positivos `n <= x` que alcanzan `a` por iteracion
forward de `T`, con la condicion adicional de que el prefijo orbital hasta
alcanzar `a` permanece dentro de la ventana `<= x`.

La definicion Lean futura debe ser computable:

```text
Finset.filter over Finset.range (x+1)
```

No se usara `Set.ncard` como definicion primaria.

## Definicion futura de T

Modulo futuro:

```text
CollatzClassical/KL2003/KL2003M0APiStarSemantics.lean
```

Pseudocodigo Lean:

```lean
def T (n : Nat) : Nat :=
  if n % 2 = 0 then
    n / 2
  else
    (3 * n + 1) / 2
```

Notas:

```text
T 0 = 0.
Si n es positivo, T n es positivo.
Si n es impar, 3*n+1 es par, asi que la division por 2 es exacta.
```

No se intenta en M0a probar propiedades profundas de `T`; solo se fija la
funcion computable.

## orbitWithFuel

Diseno:

```lean
def orbitWithFuel : Nat -> Nat -> List Nat
| 0, n => [n]
| fuel + 1, n => n :: orbitWithFuel fuel (T n)
```

Convencion:

```text
fuel = numero maximo de pasos forward permitidos.
orbitWithFuel fuel n contiene fuel+1 estados.
El primer elemento siempre es n.
```

Ejemplo conceptual:

```text
orbitWithFuel 3 n = [n, T n, T^2 n, T^3 n]
```

Esta lista es util para `#eval`, debugging y comparacion con Python. La
definicion booleana de reachability puede implementarse directamente por
recursion sin construir la lista completa.

## boundedReaches

La version recomendada es booleana y con fuel explicito:

```lean
def boundedReachesWithFuel : Nat -> Nat -> Nat -> Nat -> Bool
| 0, a, x, n =>
    decide (n <= x) && decide (n = a)
| fuel + 1, a, x, n =>
    decide (n <= x) &&
      (decide (n = a) || boundedReachesWithFuel fuel a x (T n))
```

Luego:

```lean
def boundedReaches (a x n : Nat) : Bool :=
  boundedReachesWithFuel (x + 1) a x n
```

Semantica fijada:

```text
boundedReaches a x n = true
```

significa que existe un prefijo orbital:

```text
n, T n, ..., T^j n = a
```

con:

```text
j <= x+1
cada estado comprobado antes del hit permanece <= x
```

La comprobacion `n <= x` se hace antes de aceptar `n = a`. Por tanto si
`a > x`, no se acepta ningun hit en `a`.

## piStarFinset

Decision primaria, usando `Finset.filter` con predicado `Prop` decidible:

```lean
def piStarFinset (a x : Nat) : Finset Nat :=
  (Finset.range (x + 1)).filter
    (fun n => 1 <= n ∧ boundedReaches a x n = true)
```

Si conviene inspeccionar miembros como booleanos en `#eval`, se puede agregar
un helper separado, pero no usarlo como definicion primaria del `Finset`:

```lean
def piStarMember (a x n : Nat) : Bool :=
  decide (1 <= n) && boundedReaches a x n
```

Cardinal:

```lean
def piStar (a x : Nat) : Nat :=
  (piStarFinset a x).card
```

Semantica:

```text
Finset.range (x+1) = {0, 1, ..., x}
el filtro 1 <= n elimina n = 0
por tanto se cuentan exactamente n positivos con n <= x
```

Esta decision sigue la definicion KL2003 de `pi_a(x)` sobre enteros positivos.

## Fuel inicial x+1

Motivo:

```text
Si una orbita positiva permanece en [1,x] y alcanza a por primera vez,
entonces antes del primer hit no repite estados.
Hay solo x estados positivos posibles.
```

Por tanto un hit acotado real aparece con longitud `<= x-1` si se cuenta desde
un `n != a`, y con longitud `0` si `n = a`.

Usar:

```text
fuel = x + 1
```

es deliberadamente holgado, evita un off-by-one temprano y mantiene la
definicion simple. La validacion cruzada debe confirmar que el fuel no cambia
el conteo frente a una version con deteccion explicita de ciclos.

## Casos delicados

### Ciclos antes de alcanzar a

Si la orbita entra en un ciclo que no contiene `a`, la recursion con fuel
termina y devuelve `false`.

```text
No se intenta detectar ciclos en la definicion primaria.
El fuel finito implementa una busqueda acotada total.
```

### Si a esta en el ciclo

Si `a` esta en el ciclo y el prefijo desde `n` alcanza `a` antes de agotar
fuel, entonces `boundedReaches` devuelve `true`, siempre que todos los estados
del prefijo esten `<= x`.

Esto es intencional para la semantica computable de `piStar`. Las desigualdades
D1/D2/D3 no deben borrar la hipotesis posterior:

```text
a is not in a cycle
```

Esa hipotesis permanece para M0b.

### n = 0

`T 0 = 0`, pero `n = 0` no se cuenta en `piStarFinset`, porque el filtro exige:

```text
1 <= n
```

Esto evita que el ciclo artificial `0 -> 0` contamine los conteos KL2003.

### x = 0

```text
Finset.range (0+1) = {0}
```

Despues del filtro `1 <= n`, queda el conjunto vacio:

```text
piStarFinset a 0 = empty
piStar a 0 = 0
```

### a = 0

`a = 0` no es una raiz KL2003 valida para las fases M0b/M0d. Con la definicion
primaria:

```text
piStarFinset 0 x = empty
```

porque `n = 0` queda excluido y ningun positivo alcanza `0` bajo `T`.

### Off-by-one de Finset.range

Lean:

```text
n in Finset.range (x+1)  <=>  n < x+1
```

Para `Nat`, esto representa:

```text
n <= x
```

El filtro adicional:

```text
1 <= n
```

da exactamente:

```text
1 <= n <= x
```

## Validacion cruzada

Antes de escribir D1/D2/D3 se debe crear una validacion externa.

Script Python propuesto:

```text
scripts/kl2003_m0a_pi_star_cross_validation_v1.py
```

Referencia Python:

```python
def T(n: int) -> int:
    return n // 2 if n % 2 == 0 else (3*n + 1) // 2

def bounded_reaches(a: int, x: int, n: int) -> bool:
    if n < 1 or n > x:
        return False
    cur = n
    for _ in range(x + 2):
        if cur > x:
            return False
        if cur == a:
            return True
        cur = T(cur)
    return False

def pi_star_members(a: int, x: int) -> list[int]:
    return [n for n in range(1, x + 1) if bounded_reaches(a, x, n)]
```

Tabla propuesta:

```text
outputs/KL2003_M0A_PI_STAR_CROSS_VALIDATION_v1/pi_star_grid.csv
```

Columnas:

```text
a
x
count
members_space_separated
members_sha256
fuel
```

Rango inicial recomendado:

```text
1 <= a <= 100
0 <= x <= 500
```

Si esto es demasiado grande para revision visual, empezar con:

```text
1 <= a <= 30
0 <= x <= 200
```

pero conservar el diseno para escalar.

## #eval Lean posterior

El modulo Lean futuro debe incluir, en un archivo de test o nota separada, una
tabla `#eval` pequeña:

```lean
#eval (piStarFinset 1 20).toList
#eval (piStarFinset 2 20).toList
#eval (piStarFinset 5 50).toList
#eval (List.range 31).map (fun a => (a, piStar a 100))
```

Comparacion:

```text
Lean members list == Python members list
Lean card == Python count
```

No basta comparar solo cardinales para el primer test; los miembros deben
coincidir al menos en la rejilla pequena.

## Siguiente modulo Lean

Nombre:

```text
CollatzClassical/KL2003/KL2003M0APiStarSemantics.lean
```

Contenido permitido:

```text
T
orbitWithFuel
boundedReachesWithFuel
boundedReaches
piStarFinset
piStar
lemas computables basicos sobre x=0, n=0, a=0
#eval o ejemplos pequenos en archivo separado
```

Imports probables:

```lean
import Mathlib.Data.Nat.Basic
import Mathlib.Data.Finset.Range
import Mathlib.Data.List.Basic
import Mathlib.Tactic.NormNum
```

Evitar:

```text
Real
log
rpow
D1/D2/D3
retarded induction
phi semantics
M0 theorem
M1 theorem
global Collatz claim
native_decide
```

## No hacer todavia

```text
No probar D1/D2/D3.
No hacer induccion retardada.
No ensamblar M0.
No nombrar M1 theorem.
No introducir lower bound.
No reclamar KL2003 completo.
No hacer claim global sobre Collatz.
```

## Resultado

```text
M0A_PI_STAR_SEMANTICS_SCOPED = yes
COMPUTABLE_FINSET_DESIGN_READY = yes
ORBIT_WITH_FUEL_DESIGN_READY = yes
CROSS_VALIDATION_PLAN_READY = yes
CYCLE_HANDLING_EXPLICIT = yes
NO_D1_D2_D3_YET = yes
NO_M0_PROOF = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
