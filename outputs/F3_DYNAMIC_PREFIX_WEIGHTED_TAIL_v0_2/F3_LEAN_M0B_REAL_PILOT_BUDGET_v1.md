# F3 M0-b Real pilot — presupuesto separado v1

Estado: `REAL_RENEWAL_INTERFACE_PASS_PATH_LEAKAGE_OPEN`; no reutiliza el
presupuesto racional M0-a.

Base congelada:

```text
515221dbf60dfff3a13da85fec423eb88fc028a8
```

## Alcance

El piloto intenta formalizar en `ℝ` la primera pieza de la conversión renewal:

1. la identidad geométrica finita para la masa viva;
2. la desigualdad de primera pasada
   `stopped(n+1) ≥ stopped(n) + (1-q)·L·q^n`;
3. la conclusión `stopped(n) ≥ L·(1-q^n)`;
4. el paso de cola `q^n → 0` para `0 ≤ q < 1`.

No se añaden filas del operador, no se reabre el checker racional y no se
formalizan todavía Doob, Chernoff, caminos del árbol ni la interpretación de
`rho★` como crecimiento de `piStar`. Esta fase mide exclusivamente el lema
analítico en `Real`.

El piloto inicial pasó y ahora está encapsulado por
`F3ReturnExcursionRenewalInterface.lean`: la conversión queda demostrada
cuando se entrega un `LeakageCertificate`. La producción de ese certificado
desde caminos F3 permanece abierta; esta separación evita convertir una
hipótesis de fuga en un resultado sobre el operador.

## Presupuesto y gate

```text
REAL_PILOT_BUDGET_SECONDS = 900
MAX_SINGLE_COMMAND_SECONDS = 300
RATIONAL_M0A_BUDGET_TOUCHED = false
FAILURE_POLICY = STOP_AND_RECORD
```

`PASS` significa únicamente que la pieza aislada en `Real` compila y pasa su
auditoría de axiomas. `FAIL` o timeout quema este piloto, conserva el checker
racional y exige una causa escrita antes de cualquier reformulación.

## Claims prohibidos

```text
NO_RHO_CERTIFICATE = true
NO_DENSITY_THEOREM = true
NO_GLOBAL_COLLATZ_CLAIM = true
NO_RENEWAL_CONVERSION_THEOREM = true
```

El resultado esperado, incluso con `PASS`, es `REAL_RENEWAL_LEMMA_PILOT` y
no un teorema F3.
