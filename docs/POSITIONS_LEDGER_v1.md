# POSITIONS_LEDGER_v1

Registro de posiciones al momento del giro de rumbo (julio 2026).

## Acordado por ambos hilos + Claude

- ccchallenge.org verificado: 1/362 formalizados, 4 ready-to-audit,
  0 auditando. Terras1976 en curso por tercero.
- Cuello de botella del challenge = auditoria. Nuestro oficio = auditoria.
- No duplicar Terras sin contacto previo con su autor.
- Giro: de "cruzar el muro global" a "formalizar clasicos publicados".
- Carril 1 (entrada como auditores) es la primera accion.
- KL2003 es mejor blanco propio que Terras.

## Matiz de Claude aceptado como riesgo a medir

- KL2003 tiene tres capas (arbol inverso / certificado del exponente /
  asintotica). Solo la primera es conteo puro. El reuso de nuestra base
  es arquitectonico, no verbatim: la semantica inversa es nueva.
- De-risking por escalera: M1 = Krasikov 1989 (x^(3/7)) como GO/NO-GO
  antes de comprometer el 0.84.

## Actualizacion 2026-07-14: KL2003 k=2 M1-surrogate cerrado

- HEAD final registrado: `71add7c`.
- Teorema tecnico:
  `kl2003_k2_m1_surrogate_ceil_window_lower_bound`.
- Archivo Lean:
  `CollatzClassical/KL2003/KL2003M1Surrogate.lean`.
- Nota final:
  `docs/KL2003_M1_SURROGATE_FINAL_REVIEW_AND_PACKAGE_v1.md`.
- Clasificacion de estado:
  `KL2003_K2_M1_SURROGATE_WINDOW_THEOREM_COMPLETE`,
  `FINAL_REVIEW_PACKAGE_PUBLISHED`,
  `CC_CHALLENGE_REGISTERED_FORMALISING`,
  `READY_FOR_INTERNAL_AUDIT_PACKAGE`.
- Alcance calibrado: resultado `k=2` M1-surrogate sobre la ventana concreta
  `ceil`; no es M1 completo, no es un teorema de ventana arbitraria y no es
  un claim global de Collatz.

## Cerrado del programa anterior (residuo defendible, sin cambios)

- Input local de optional stopping: drift <= -13/10 y momento exponencial
  < 4.9, estables y axiom-clean sobre ventanas dyadicas [20M, 640M].
- Masa por residuo estable; cola profunda por residuo no resuelta
  (subpotenciada por Poisson, estructuralmente).
- Muro identificado: cota de decaimiento uniforme de Syracuse.
  ALL_K / MEASURE_TRANSFER / SUPERMARTINGALE / COLLATZ = OPEN, NOT_CLAIMED.

## Pendiente de decision (se resuelve con datos, no ahora)

- Asignacion de tiempo tras Fase 1 del carril 1 (segunda auditoria vs
  KL2003 vs contribucion a Terras).
- Techo del carril 2: M3 (0.84) o M2, segun tarea F2 del feasibility.
