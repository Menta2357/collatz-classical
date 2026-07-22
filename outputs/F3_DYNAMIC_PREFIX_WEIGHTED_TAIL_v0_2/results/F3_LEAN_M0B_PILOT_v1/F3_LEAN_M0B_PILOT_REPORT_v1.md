# F3 Lean M0-b — informe de piloto v1

Estado: `PASS_PILOT_ONLY`; M0-b completo permanece no autorizado.

## Base y presupuesto

```text
base_commit = 98d073a07e6be26d9748049f353605579847b0e4
authorized_pilot_budget_seconds = 600
measured_compile_seconds = 8.15
measured_axiom_audit_exit = 0
failure_policy = STOP_AND_RECORD
```

## Pieza aislada

El piloto formaliza únicamente el telescopado racional básico:

```text
q = 24100/24543
epsilon = 2/243
eta_row = epsilon/(1-q) = 202/443
(1-r) * sum_{k<n} r^k = 1-r^n
```

La identidad geométrica se prueba para todo `r : ℚ` y `n : Nat`; las dos
constantes del ledger se re-verifican por `norm_num`. La auditoría de axiomas
queda dentro del perfil `[propext, Classical.choice, Quot.sound]`.

## Ledger de ejecución

Dos intentos iniciales se detuvieron por la orientación final de `pow_succ` en
la prueba del telescopado (3.34 s y 2.29 s). No afectaron los datos ni las
constantes. La versión corregida terminó en 8.15 s y pasó la auditoría.

## Límite explícito

Este piloto no contiene Chernoff de operador, parada de caminos, Lema B,
uniformidad en `y`, ni ensamblaje del funcional `V_y`. Por tanto no abre M0-b
completo y no cambia ninguna de las etiquetas `NO_RHO_CERTIFICATE`,
`NO_DENSITY_THEOREM` o `NO_GLOBAL_COLLATZ_CLAIM`.
