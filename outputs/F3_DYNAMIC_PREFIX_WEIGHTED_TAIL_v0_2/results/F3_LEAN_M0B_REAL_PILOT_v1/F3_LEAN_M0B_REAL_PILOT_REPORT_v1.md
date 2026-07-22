# F3 M0-b Real-only — informe de piloto v1

Estado: `REAL_RENEWAL_LEMMA_PILOT_PASS`.

## Base y presupuesto separado

```text
base_commit = 515221dbf60dfff3a13da85fec423eb88fc028a8
real_pilot_budget_seconds = 900
measured_compile_seconds = 9.74
measured_axiom_audit_seconds = 11.94
failure_policy = STOP_AND_RECORD
rational_m0a_budget_touched = false
```

## Resultado formalizado

El módulo trabaja exclusivamente sobre `ℝ` y prueba:

```text
q = 24100/24543, 0 ≤ q < 1
epsilon/(1-q) = 202/443
q = (1-epsilon)/(1+delta), with delta = 1/100
(1-r) * sum_{k<n} r^k = 1-r^n
stopped(n+1) ≥ stopped(n) + (1-q)Lq^n
      ⟹ stopped(n) ≥ L(1-q^n)
q^n → 0 y L(1-q^n) → L
```

La pieza es una conversión renewal finita y una cota de primera pasada en
`Real`; no contiene todavía la cadena de Doob, Chernoff de operador, la
descomposición por caminos del árbol ni el funcional `piStar`.

La interfaz de fuga también está formalizada: si
`(1-q)Lq^n ≤ stopped(n+1)-stopped(n)`, el mismo límite se obtiene sin
reempacar la desigualdad como una hipótesis de paso. Esto deja separado el
lema analítico de conversión de la futura prueba de que el operador y la cola
producen dicha fuga.

## Auditoría y no-claims

La auditoría queda dentro de `[propext, Classical.choice, Quot.sound]` y no
usa `sorryAx`. El estado no sube a certificado de `rho`: permanecen
`NO_RHO_CERTIFICATE`, `NO_DENSITY_THEOREM`, `NO_GLOBAL_COLLATZ_CLAIM` y
`NO_RENEWAL_CONVERSION_THEOREM`.

## Ledger de implementación

La primera compilación falló al faltar los imports topológicos y la declaración
`noncomputable` para `Real`; se corrigió antes de la corrida aceptada. No hubo
fallo de la desigualdad ni de los datos congelados.
