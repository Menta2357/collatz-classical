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
  cota para cualquier asignacion critica.
- La infraestructura de transporte de esa deuda ya esta cerrada: igualdad de
  valor normal local implica igualdad despues de enchufar y congruencia de
  `HoleCritical`; una equivalencia estable bajo subcontextos transporta todo
  `CriticalNodeBounds`. Ademas, una relacion dirigida sobre ocurrencias reales
  compone bajo zippers y transporta el invariante sin exigir equivalencia para
  reemplazos hipoteticos.
- Esa dominancia dirigida y su consumidor ya estan cerrados. Cada brazo
  retenido critico tras reducir el minimo era critico en el `min3` original;
  el transporte por zipper preserva `CriticalNodeBounds`. La politica
  contextual `criticalWitnessRetention` usa la retencion maximal no vacia en
  objetivos criticos y `keepAll` fuera de la ruta critica. Lean prueba para
  esa politica igualdad exacta del valor y preservacion de (305). El blocker
  inmediato pasa a ser el normalizador iterado: localizar el siguiente paso,
  transportar las hipotesis estructurales y terminar.
- El primer paso del normalizador general-k ya esta construido sin una nueva
  interfaz asumida. Un zipper tipado localiza deterministicamente el siguiente
  split advanced, levanta sus rutas y su `AdvancedMinConfiguration` por el
  contexto exterior, y aplica la politica canonica ya auditada. Lean prueba
  igualdad exacta del valor normal y preservacion de `CriticalNodeBounds`.
  La frontera de iteracion queda aislada: el paso actual consume `NodeBounds`,
  mientras su salida conserva la version source-faithful `CriticalNodeBounds`;
  falta fortalecer el consumidor a esa premisa antes de iterar.
- Ese fortalecimiento y la iteracion finita ya estan cerrados. La contradiccion
  de testigo ahora consume `CriticalNodeBounds` en un contexto exterior, los
  pasos preservan tambien argumentos no negativos, y una busqueda separada
  elige solo ocurrencias criticas con al menos un testigo. Cada paso accionable
  reduce estrictamente `nodeCount`; por ello el normalizador de deletion sobre
  cualquier arbol finito ya expandido termina, conserva valor y cotas, y deja
  cero ocurrencias accionables. Esto no es aun Theorem 3.1: falta alternar con
  expansion de hojas, probar terminacion general-k de ese proceso y definir el
  contrato `SatisfiesEL`.
- La prueba fuente de terminacion de Theorem 3.1 contiene una inconsistencia
  de signo: despues de `beta_1 > beta_2 > ...` declara
  `delta = beta_2 - beta_1 > 0`, aunque la conclusion de negatividad requiere
  `delta < 0`. La normalizacion negativa queda propuesta y custodiada, pero no
  se promueve a prueba: falta formalizar la correspondencia autosimilar que
  hace constante el incremento y la independencia del orden.
- El nucleo finito y aritmetico de esa prueba ya esta en Lean. Toda secuencia
  infinita de `TrackedMode k` tiene un modo con ocurrencias arbitrariamente
  lejanas; `beta_2 < beta_1` fuerza el signo corregido
  `delta = beta_2 - beta_1 < 0`; y una sucesion con incremento fijo negativo
  no puede permanecer no negativa. Esto no prueba aun terminacion: sigue
  faltando la correspondencia autosimilar que convierte subarboles recurrentes
  en un unico incremento fijo, ademas de la unicidad respecto del orden.
- La parte local de esa correspondencia tambien esta cerrada. Una traslacion
  simbolica conserva modos, se suma a todos los shifts y conmuta exactamente
  con `frontierExpr`, `normalExpr`, `splitTopExpr` y `sourceSplitTree`; la
  evaluacion trasladada en `y` coincide con la original en `y + delta`. Falta
  iterar esta equivariancia sobre el subarbol completamente expandido y enlazar
  las copias recurrentes extraidas por la subsecuencia finita.
- La iteracion finita raw ya no es una deuda. Una ruta terminal dependiente se
  transporta por cualquier contexto del arbol, `splitAt` conmuta con la
  traslacion y la clausura reflexivo-transitiva de splits localizados conserva
  exactamente la forma trasladada. La geometria de deletion si transporta:
  `Min3Path` y
  `reduceAt` con retencion fija conmutan con la traslacion. La politica por
  testigos tambien se conserva entre configuraciones traducidas cuando sus
  tests de elegibilidad son equivalentes, incluido el caso en que ambas hojas
  son negativas, y D2 conmuta por completo. El descenso
  dependiente por un split exterior y los cuatro paths canonicos de las
  configuraciones advanced D1/D3 ya se identifican con sus traducciones.
  Bajo equivalencia de elegibilidad para las tres ramas, tambien conmutan
  `witnessRetention`, la reduccion y `sourceStep`; D2 no requiere ese contrato.
  A nivel del arbol, la equivalencia terminal global transporta exactamente el
  selector determinista izquierda-a-derecha, y junto con la equivalencia local
  de ramas transporta un `sourceScheduledStep`. La deuda mecanica del scheduler
  queda cerrada condicionalmente. El blocker recurrente es demostrar esos
  contratos de elegibilidad para las traslaciones de Theorem 3.1, o sustituir
  la correspondencia por un descenso bien fundado; no se reclama conmutacion
  incondicional.
- La auditoria primaria de esa correspondencia ya muestra que los contratos no
  son automaticos. Para una hoja terminal de shift cero, una traslacion
  negativa cambia exactamente la elegibilidad; ademas, la misma hoja puede no
  tener testigo de deletion como arbol desnudo y adquirirlo bajo un ancestro
  exterior del mismo modo. Lean formaliza ambos contraejemplos y tambien la
  direccion monotona util: una traslacion no positiva no crea hojas
  expandibles en un arbol ya terminal. Esto no refuta Theorem 3.1, pero impide
  deducir identidad de subarboles recurrentes solo de modo y traslacion.
- La misma relectura detecta una segunda inconsistencia de desigualdad. La
  deletion rule impresa exige que el shift del ancestro sea estrictamente
  menor, mientras la prueba afirma despues que tambien se borraria en
  igualdad. Lean confirma que una hoja elegible bajo un ancestro del mismo
  modo y mismo shift no tiene testigo. Por tanto deletion sola da no-aumento;
  cualquier descenso estricto debe excluir aparte ciclos de peso cero.
- El nucleo aritmetico dispone ahora de una salida mas debil que la identidad
  exacta de subarboles. Si toda repeticion posterior de un modo pierde al menos
  un `epsilon > 0` uniforme, alguna shift recurrente se vuelve negativa. Queda
  abierta la parte matematica real: derivar ese margen uniforme de un grafo
  finito de transiciones y ciclos simples admisibles, respetando el contexto de
  deletion. No se reclama aun terminacion ni independencia de orden.
- La ruta alternativa queda ahora disenada como cuatro modulos: grafo finito
  de acciones source, exclusion de peso cero mediante irracionalidad de
  `logb 2 3` o certificado kernel-checked, descomposicion en ciclos simples y
  extraccion de una caminata superviviente desde la no terminacion. El grafo
  bruto tiene ciclos positivos, incluido el auto-bucle D3 de clase 8 en k=2;
  deletion los excluye solo en ramas supervivientes. Por eso el contrato no
  afirma negatividad del grafo bruto: combina no-aumento contextual, ausencia
  de peso cero y finitud para producir el margen uniforme.
- El primer modulo de esa ruta ya esta en Lean. `SourceAction mode` es un tipo
  finito cuya validez impide construir ramas D1/D3 fuera de sus residuos; sus
  destinos y pesos coinciden con los child labels source existentes. Las
  caminatas dependientes concatenan con longitud y peso aditivos, todo
  coeficiente de alpha acumulado es no negativo y toda caminata no vacia tiene
  coeficiente constante estrictamente negativo. El shift final coincide
  exactamente con el inicial mas el peso.
- El segundo modulo de la ruta de ciclos tambien esta cerrado. Lean prueba
  elementalmente que `alpha = logb 2 3` es irracional: una representacion
  racional, elevada a su denominador positivo, igualaria una potencia natural
  par de 2 con una potencia impar de 3. Por ello todo camino source no vacio
  tiene peso evaluado distinto de cero; combinado con una futura cota
  contextual no positiva, el peso es estrictamente negativo. Quedan abiertos
  la extraccion de esa no-positividad desde deletion, la descomposicion en
  ciclos simples y el margen uniforme finito.
- El scheduler sintactico source-faithful ya esta formalizado. Un zipper
  terminal dependiente localiza de izquierda a derecha la primera hoja con
  shift no negativo; `none` equivale exactamente a que todos los shifts
  terminales sean negativos. El paso aplica D1/D2/D3 segun el residuo
  trackeado modulo 9 y, en D1/D3, desciende la configuracion del nuevo minimo
  advanced por el contexto exterior y aplica la retencion maximal por
  testigos, sin consultar `Phi`. El split conserva frontera y `NodeBounds`, y
  cada rama borrada lleva testigo sintactico. El punto semantico decisivo ya
  esta cerrado sin convertirlo en hipotesis: si el minimo objetivo es critico,
  aplica el transporte dirigido existente; si no lo es, toda retencion eleva
  su valor pero sigue bloqueada por el primer minimo exterior no critico, y
  `NodeBounds` paga los nodos retenidos y hermanos. Lean concluye que el paso
  source-faithful D1/D2/D3 preserva `CriticalNodeBounds` sin asumir criticidad
  del objetivo. Quedan la terminacion expansion-deletion, la independencia de
  orden, la forma normal canonica y `SatisfiesEL`.

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
