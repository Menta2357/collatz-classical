# F3 — prerregistro corregido del piloto three-lift v2

Fecha de congelación: 2026-07-21.

V2 corrige exclusivamente la contaminación entre módulos documentada en
`F3_THREE_LIFT_BALANCE_PILOT_V1_INVALIDATION.md`.

## 1. Parámetros heredados sin cambios

```text
modulos M             = {36,108}
clases padre mod 9    = {2,8}
D1 child              = 2*(2a-1)/3
D3 child              =   (2a-1)/3
escalas y             = {8,9,10}
freeze margin         = 0.02
freeze grid           = 0.001
utility floor         = 0.200
```

No se añaden tipos rich/thin, módulos, escalas ni excepciones.

## 2. Unidad de holdout

La unidad independiente declarada es la **raíz padre \(a\)**. Una raíz padre
no puede aparecer en ambas fases, aunque tenga representaciones como tipo para
varios módulos.

## 3. Split global corregido

El tamaño de bloque es

\[
H=10368=32\cdot(3\cdot108).
\]

Se fijan intervalos half-open de igual longitud:

```text
calibracion = 1 <= a < 10369
holdout     = 10369 <= a < 20737
```

El holdout está enteramente por encima de todo padre inspeccionado en v1
(máximo 5183). Los intervalos contienen el mismo número de bloques completos
módulo \(3M\) para ambos módulos.

Para cada \((M,r,t)\), se incluyen todas las raíces del intervalo que cumplen

```text
a mod M = r
((a-r)/M) mod 3 = t
r mod 9 in {2,8}
```

## 4. Masa, shares y hooks

Se mantienen literalmente las definiciones v1:

\[
A_{M,r,t}^{(s)}(y)
=\sum_{a\in I_s(M,r,t)}\pi^*(b(a),2^y a-2^{y-1}),
\]

\[
\sigma_{M,r,t}^{(s)}(y)
=A_{M,r,t}^{(s)}(y)/\sum_{u=0}^2A_{M,r,u}^{(s)}(y).
\]

Hooks obligatorios:

```text
parent root in declared global interval
a mod M = r
lift index t exact
3c+1 = 2a
D1/D3 route exact
xAdv <= x
pi*(child,xAdv) <= pi*(a,x)
global calibration/holdout parent-root intersection = empty
```

## 5. Freeze y veredicto sin cambios

\[
\beta_{frozen}
=\lfloor1000\max(0,\min\sigma^{cal}-0.02)\rfloor/1000.
\]

```text
HOLDOUT_BALANCE_PASS iff min holdout share >= beta_frozen
UTILITY_PASS         iff beta_frozen >= 0.200
LOCAL_PROVISIONAL_GO iff hooks + balance + utility
STOP_OR_REDESIGN     otherwise
```

El resultado sigue siendo `PENDING_PUBLIC_CUSTODY` hasta push/PR accesible.

```text
V2_PREREGISTERED_BEFORE_V2_CALIBRATION_RUN
V2_HOLDOUT_PARENT_ROOTS_UNACCESSED
TYPES_UNCHANGED_FROM_V1
THRESHOLDS_UNCHANGED_FROM_V1
NO_LEAN
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

