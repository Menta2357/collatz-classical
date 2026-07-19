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
- La semantica fuente indexada por `TrackedMode k` ya esta definida y auditada.
  P1 y P2 estan probadas bajo no-vacuidad; para `k=3`, las nueve clases modulo
  27 se habitan mediante testigos explicitos que son potencias de dos, por lo
  que P1/P2 quedan incondicionales en el primer banco de integracion.
- P3 ya es una igualdad Lean de infimos derivada de la particion ternaria de
  las poblaciones de raices, no una hipotesis de puente. La instancia de nivel
  2 a nivel 3 queda cerrada con los testigos anteriores. El Modulo 1 sigue
  abierto en la igualdad paritaria fuente (200) y filas D1/D2/D3 generales.
  La transferencia member-wise segura `piStar (2c) <= piStar c` ya se movio a
  M0B y esta auditada; no se promociona a igualdad de infimos sin probar la
  direccion inversa.
- Las tres familias fuente D1/D2/D3 ya estan probadas para nivel general
  `p+1`, con operadores de clase derivados por aritmetica modular y ventanas
  `floor`. El bundle `SatisfiesIk` queda probado bajo no-vacuidad; su instancia
  `k=3` es incondicional y consume los nueve testigos explicitos. La igualdad
  fuente (200) sigue separada, pero no es premisa del bundle ni de sus filas.
- El Modulo 2 ya tiene lenguaje Lean auditado para shifts simbolicos, AST
  nested `sum/min3`, traduccion exacta al `RetardedExpr` generico y testigos de
  deletion basados en ancestros. No se reclama aun terminacion EL, unicidad ni
  preservacion semantica de la deletion rule.
- P3 ya compila D1 y D3 a expresiones enteramente del nivel superior; las tres
  filas top-level tienen evaluacion exacta y desigualdad semantica probadas.
  Esas expresiones son el futuro cuerpo de split EL, sin arbol preconstruido.
- La subetapa split de EL ya esta cerrada semanticamente: cada hoja se
  reemplaza por D1/D2/D3 desplazada y un lema estructural propaga la
  desigualdad a traves de sumas y minimos. Terminacion y deletion siguen
  separadas y abiertas.
- El nucleo algebraico de deletion ya esta cerrado: expresiones EL con
  argumentos no negativos son estrictamente positivas, y un ancestro del
  mismo modo a shift menor contradice cualquier desigualdad critica que
  intente pagar `hoja + subarbol companero positivo` con ese ancestro. Sigue
  abierto construir el contexto de caminos que entrega esas premisas en cada
  deletion, asi como la preservacion global y la terminacion.
- Las asignaciones criticas ya son objetos Lean sobre el AST nested: conservan
  ambos hijos de una suma, eligen un brazo que alcanza cada minimo, existen
  para toda expresion finita y su expresion seleccionada evalua exactamente al
  termino original. La contradiccion de deletion ya consume este objeto real;
  falta el invariante de caminos internos equivalente a la ecuacion (305).
- Una ruta critica ya descompone exactamente el valor seleccionado como
  `hoja + companeros aditivos`; si hay al menos un companero, su valor es
  estrictamente positivo. Bajo la cota de nodo de (305), Lean excluye la hoja
  con testigo de deletion. Falta producir y preservar esa cota para todos los
  nodos principales internos del proceso, no justificar de nuevo la
  contradiccion local.
- El arbol interno de nodos principales ya distingue frontera sin expandir y
  expresion normal totalmente sustituida. Cotas locales en cada nodo implican
  que la normal queda bajo la frontera y que toda asignacion critica bajo un
  nodo expandido satisface la cota (305). Las filas fuente D1/D2/D3 construyen
  este invariante sin datos de Figure A1. En ese punto faltaba preservarlo al
  expandir hojas dentro de arboles existentes y al aplicar deletion.
- La expansion de una hoja terminal dentro de un arbol existente ya preserva
  la frontera completa y todas las cotas de nodos ancestros. La operacion usa
  una ruta estructural, no una busqueda por etiqueta, y adjunta la fila fuente
  parametrica. La deuda semantica restante comienza ahora en la operacion de
  deletion y su preservacion de buena formacion.
- La operacion de deletion ya tiene una representacion no vacia: siete
  patrones retienen exactamente uno, dos o tres brazos, y el tipo no permite
  borrar los tres. Al menos un brazo de cualquier triple real es critico, por
  lo que los tres no pueden ser simultaneamente no criticos. Si cada brazo
  retirado es no critico, la reduccion conserva exactamente frontera, normal
  y cotas de nodos incluso dentro de un arbol anidado. Falta derivar esa
  preservacion en la condicion mas debil de la fuente: no-criticidad total en
  el contexto global, que no implica necesariamente no-minimalidad local.
- La preservacion contextual del valor normal ya esta formalizada con un
  zipper de un hueco. La criticidad del hueco se propaga por cada minimo
  ancestro; si una reduccion no vacia eleva el valor local pero la ocurrencia
  no era globalmente critica, el valor normal de todo el arbol permanece
  exactamente igual. `Min3Path` ya extrae ese contexto y el teorema se aplica
  directamente a `reduceAt`.
- La semantica ya se ha afinado al nivel correcto de la fuente: cada brazo
  eliminado tiene su propio contexto global, y `reduceAt` conserva el valor
  si todos los brazos retirados son totalmente no criticos. Una ruta terminal
  construye su lista real de ancestros expandidos. Bajo `NodeBounds`,
  argumentos no negativos, positividad/monotonia y el invariante estructural
  de que hay un nodo aditivo bajo cada ancestro expandido, Lean deriva
  `HasDeletionWitness -> not HoleCritical` mediante la cadena exacta
  (305)--(307).
- El invariante aditivo ya esta cerrado para los triples advanced D1/D3 y se
  transporta al insertar el split bajo una ruta terminal exterior. Un bundle
  construido alinea las tres rutas terminales con el `Min3Path`; para una
  retencion suministrada, los testigos de todos los brazos eliminados implican
  no-criticidad global y preservacion exacta del valor de `reduceAt`.
- La retencion local ya no es una hipotesis: `witnessRetention` la construye
  desde los tres predicados de testigo, elimina `min 2 witnessCount` ramas y
  conserva al menos una. Lean prueba que todo brazo eliminado tiene testigo y
  que el `reduceAt` canonico conserva exactamente el valor normal. Sigue
  abierto el normalizador iterado que localiza estos pasos por todo el arbol,
  preserva sus invariantes entre pasos y termina.
- La cota universal `NodeBounds` se ha separado de la condicion exacta de la
  fuente: `CriticalNodeBounds` exige (305) solo en ocurrencias expandidas que
  pertenecen a una ruta globalmente critica. `NodeBounds` implica este nuevo
  invariante, cada source split inicial lo satisface y Lean recupera de el la
  cota para cualquier asignacion critica. Falta demostrar que la deletion
  canonica lo preserva entre pasos; esa es ahora la deuda semantica inmediata.
- La infraestructura de transporte de esa deuda ya esta cerrada: igualdad de
  valor normal local implica igualdad despues de enchufar y congruencia de
  `HoleCritical`; una equivalencia estable bajo subcontextos transporta todo
  `CriticalNodeBounds`. La prueba pendiente se reduce a demostrar que cada
  contexto de brazo retenido tras deletion no crea una ruta critica nueva.
- La prueba fuente de terminacion de Theorem 3.1 contiene una inconsistencia
  de signo: despues de `beta_1 > beta_2 > ...` declara
  `delta = beta_2 - beta_1 > 0`, aunque la conclusion de negatividad requiere
  `delta < 0`. La normalizacion negativa queda propuesta y custodiada, pero no
  se promueve a prueba: falta formalizar la correspondencia autosimilar que
  hace constante el incremento y la independencia del orden.

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
