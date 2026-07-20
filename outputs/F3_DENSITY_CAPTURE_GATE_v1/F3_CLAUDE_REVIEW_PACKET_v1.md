# F3 — paquete de revisión para Claude v1

Fecha: 2026-07-21.

Rol solicitado: revisor externo adversarial. No ejecutar Lean y no ampliar el
alcance a claims globales.

## Hallazgo que requiere revisión independiente

Para \(a\equiv8\pmod9\), el experimento miembro a miembro da

\[
P(a,x)=\{a,2a\}\dot\cup P(4a,x)\dot\cup P(c,x),
\quad c=(2a-1)/3.
\]

Consecuentemente, con
\(x^- = x-\lceil x/(2a)\rceil\),

\[
\pi^*(a,x)-[1+\pi^*(4a,x)+\pi^*(c,x^-)]
=1+[\pi^*(c,x)-\pi^*(c,x^-)].
\]

En las 133 raíces \(a\equiv8\pmod9\), \(a\le1200\), \(x=512a\):

```text
target = 1,155,367
numerator E5 = 1,154,227
gap = 1,140 = 133 atomos + 1,007 de borde advanced
closure = 99.9013300536%
133/133 hooks completos PASS
```

El control \(y=7,\dots,12\) mantiene la pérdida avanzada por debajo de
0.114% en la muestra, pero no constituye cota uniforme.

## Segundo hallazgo: no-cierre por módulo fijo

Para \(M=2^\ell3^k\), conocer \(a\bmod M\) no determina el hijo advanced
módulo \(M\). Los tres lifts \(a+tM\), \(t=0,1,2\), producen

\[
c(a+tM)=c(a)+2tM/3,
\]

y por tanto tres tipos hijos distintos. El parity lift D1 sustituye 2 por 4
en el numerador y conserva la obstrucción.

El auditor recorrió \(k=2..7\), \(\ell=0..5\): D1/D3 no cerraron en 72/72
configuraciones; D2 cerró como single-branch en 36/36; cero excepciones. Esto
descarta solo el alfabeto determinista por residuo fijo, no todo autómata
ponderado o multivaluado.

## Ataques concretos pedidos

1. Confirmar o refutar la partición y señalar las hipótesis mínimas exactas,
   especialmente el papel de `NotInCycle`.
2. Auditar que la descomposición del gap no confunde pérdida de ventana,
   átomos de raíz y masa descartada al usar solo dos ramas.
3. Atacar el salto E3 → “tasa 2”: las sumas E3 usan raíces fijas, mientras las
   filas envían a subconjuntos afines \(4a\) y \((2a-1)/3\).
4. Confirmar o refutar que la identidad de los tres lifts descarta cualquier
   alfabeto determinista estacionario basado solo en un módulo fijo.
5. Auditar el contrato de aceptación de
   `F3_SUM_INEQUALITY_PAPER_PAGE_v0_1.md`; en particular, si (F3.4)–(F3.5)
   expresan la obligación correcta o requieren un sistema con shifts.
6. Marcar como no sustentada cualquier afirmación bibliográfica del tipo
   “no existe en literatura” salvo búsqueda primaria separada.
7. Decidir entre las dos rutas restantes: prefijo 3-ádico dinámico con cola
   certificada, o lema unilateral de balance entre los tres lifts.

## Formato de respuesta solicitado

```text
VERDICT = PASS_TO_TYPE_TRANSITION_PILOT | REVISE | STOP
PARTITION = ACCEPT | REVISE | REJECT
E5_GAP_LEDGER = ACCEPT | REVISE | REJECT
E3_RATE_INTERPRETATION = ACCEPT | REVISE | REJECT
MINIMAL_STATE_ALPHABET = <propuesta o blocker>
THREE_LIFT_OBSTRUCTION = ACCEPT | REVISE | REJECT
PAPER_GATE_MISSING_OBLIGATIONS = <lista cerrada>
CLAIMS_TO_DOWNGRADE = <lista cerrada>
```

## Guardarraíles

```text
NO_LEAN
NO_DENSITY_PROVED
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
F3_EXPLORATION_LANE_ONLY
K11_PREFLIGHT_PRIORITY_UNCHANGED
ELIAHOU_HOLD_UNCHANGED
```
