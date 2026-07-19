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

## Actualizacion 2026-07-19: F2 y auditoria de arXiv:2512.13760

- F2 cerro el piloto generador-verificador k=3 y dejo la ruta high-k como:
  `NO_GO_EXPLICIT_EL_ENUMERATION_TO_K9_OR_K11`,
  `CONDITIONAL_GO_TO_K9_LNT_CERTIFICATE_PIPELINE`,
  `K11_DEFERRED_UNTIL_K9_PIPELINE_PASS`.
- La generalizacion semantica no se clasifica como un unico lema: requiere
  una cadena de modulos general-k antes de poder cerrar un teorema `piStar`
  para k=3 o autorizar k=9.
- La auditoria primaria de `arXiv:2512.13760` establece que `x^0.946` solo
  aparecio en v1 y fue retirado en v2. La version actual reclama `x^0.3227`.
- El proof audit v2 encontro contraejemplos pequenos y blockers independientes;
  clasificacion: `V2_PROOF_AS_WRITTEN_NOT_VALIDATED`, sin afirmar que el
  teorema v2 sea falso.
- Consecuencia bibliografica: el preprint no desplaza el benchmark historico
  `0.84` citado por su propia v2. `gamma_11 = 0.8417560` se describe solo como
  extremo de la tabla KL2003, no como techo global ni imposibilidad para k>11.
- El carril A conserva una unica fecha operativa absoluta:
  `2026-07-21 01:21 CEST`.
- El doblete de escritura queda completo como borrador interno:
  `docs/ELIAHOU1993_CC_CHALLENGE_AUDIT_REPORT_DRAFT_v1.md` y
  `docs/KL2003_AUDITABLE_GENERATOR_VERIFIER_METHOD_PAPER_DRAFT_v1.md`.
  El primero no se publica antes de resolver el protocolo author-first; el
  segundo no se presenta como paper enviado.
- La cadena semantica general-k queda disenada como cinco modulos separados:
  semantica/filas originales, eliminacion EL, transferencia de factibilidad,
  induccion retardada generica y composicion concreta. Contrato completo en
  `docs/KL2003_GENERAL_K_SEMANTIC_CHAIN_SCOPING_v1.md`.
- La nueva cadena usa una ventana `Nat.floor` fiel al enunciado fuente. Su
  trafico base, retarded, parity, advanced D1/D3 y logb-self ya esta probado y
  auditado en `KL2003GeneralKFloorWindow.lean`. Esto no modifica el teorema
  k=2 existente sobre `Nat.ceil` ni prueba todavia las filas general-k.
- El certificado k=3 sigue clasificado como verificado sin teorema `piStar`.
  k=3 sera el primer consumidor de la cadena; solo despues se medira k=9.
- El nucleo k-independiente de la induccion retardada (Teorema 5.1) ya esta
  probado y auditado sobre un AST generico `leaf/add/min`. La formula concreta
  de Delta y las filas EL siguen perteneciendo a los modulos consumidores.

## Cerrado del programa anterior (residuo defendible, sin cambios)

- Input local de optional stopping: drift <= -13/10 y momento exponencial
  < 4.9, estables y axiom-clean sobre ventanas dyadicas [20M, 640M].
- Masa por residuo estable; cola profunda por residuo no resuelta
  (subpotenciada por Poisson, estructuralmente).
- Muro identificado: cota de decaimiento uniforme de Syracuse.
  ALL_K / MEASURE_TRANSFER / SUPERMARTINGALE / COLLATZ = OPEN, NOT_CLAIMED.

## Pendiente de decision

- Asignacion de tiempo tras Fase 1 del carril 1 (segunda auditoria vs
  KL2003 vs contribucion a Terras).
- F2 ya resolvio que k=9 solo avanza bajo `CONDITIONAL_GO`: primero debe
  formalizarse y validarse la cadena general-k usando k=3 como banco de
  integracion. k=11 permanece diferido hasta que la ruta k=9 pase sus
  mediciones de certificado y presupuesto de kernel.
