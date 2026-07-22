# F3 — paquete de veredicto para Claude v2

Fecha: 2026-07-21.

Este paquete sustituye al v1 para el siguiente veredicto coordinado.

## Hechos a revisar

1. E5 fue reproducido y su déficit separado en átomo y fuga advanced.
2. El cierre determinista por módulo fijo falla por la obstrucción de tres
   lifts.
3. El primer holdout de balance fue invalidado: 192 raíces padre aparecieron
   en ambas fases al cambiar de módulo.
4. V2 corrigió únicamente el split, usando intervalos globales disjuntos y la
   raíz padre como unidad.
5. V2 mantuvo tipos, escalas, margen y piso de utilidad de V1.

## Contrato V2

```text
preregistration sha256 = 25cb543a2f240c3e91e02a4a309596e612fde67964dd2352fa0a2218c24ab3b8
driver sha256          = de0d3e5c8497ec3776699d58fb6c26b2a2574c7c1e43b14ff58faf885ab19255
frozen contract sha256 = 8b61fb8c07c990f27005f6ba1e4962213d9df54fd0aeb755715fc49fa27ecb21
```

## Resultado V2

```text
calibration parent roots = 2304
holdout parent roots     = 2304
intersection             = 0
rows per phase           = 13824
mismatches per phase     = 0
calibration min share    = 0.0536199288
frozen beta              = 0.033
holdout min share        = 0.0899611737
holdout balance pass     = yes
utility floor 0.200      = fail
local verdict            = STOP_OR_REDESIGN
```

Interpretación propuesta:

```text
STOP uniform useful balance lemma on every fixed type
CONTINUE only dynamic 3-adic prefix with certified weighted tail
```

## Ataques pedidos

1. ¿La invalidación V1 es necesaria y suficiente?
2. ¿La unidad “raíz padre” hace válido el split global V2, pese a que raíces
   derivadas puedan aparecer en otras funciones de calibración?
3. ¿La regla de freeze y el piso 0.200 se aplicaron literalmente?
4. ¿El fallo de utilidad basta para detener el lema uniforme, o solo esta
   parametrización finita?
5. ¿Qué forma mínima debe tener un potencial de cola ponderada antes de
   autorizar otro experimento?
6. ¿Debe la cola controlar masa advanced absoluta, masa target o ambas bajo
   cada transición?

## Formato de respuesta

```text
V1_INVALIDATION = ACCEPT | REVISE | REJECT
V2_HOLDOUT_INTEGRITY = ACCEPT | REVISE | REJECT
UNIFORM_LIFT_BALANCE_ROUTE = STOP | REVISE | CONTINUE
DYNAMIC_PREFIX_WEIGHTED_TAIL = CONTINUE | STOP
MINIMAL_POTENTIAL_OBLIGATIONS = <lista cerrada>
CLAIMS_TO_DOWNGRADE = <lista cerrada>
FORMAL_VERDICT = <solo despues de custodia publica>
```

## Guardarraíles

```text
PENDING_PUBLIC_CUSTODY
NO_LEAN
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
K11_PRIORITY_UNCHANGED
ELIAHOU_HOLD_UNCHANGED
```

