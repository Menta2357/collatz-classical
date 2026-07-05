# ELIAHOU1993_AUDIT_PHASE1_PREP_v1

Fecha de corte: 2026-07-05, Europe/Madrid.

Estado: preparado para anuncio controlado en Forum; audit link no creado.

## Base de sincronizacion

Documentos base leidos:
- `/Users/MoiTam/Documents/Codex/collatz-classical/docs/COORDINATED_VERDICT_2026_07_05_v1.md`
- `/Users/MoiTam/Documents/Codex/collatz-classical/docs/CC_CHALLENGE_AUDIT_ENTRY_PHASE0_REPORT_v1.md`
- `/Users/MoiTam/Documents/Codex/collatz-classical/audits/ADVERSARIAL_AUDIT_CHECKLIST_v1.md`

Veredicto coordinado aplicable:
- `AUDIT_ENTRY_READY (Hilo A) = FIRMADO`.
- Autorizado para Hilo A:
  1. Resumir las 2 reviews existentes de `Eliahou1993`.
  2. Anunciar en Forum la intencion de auditar formalisation id 6.
  3. Iniciar Fase 1 con checklist, empezando por fidelidad de statement.
- Condicion especifica: por estar la formalizacion marcada como AI-assisted, comenzar por `paper statement vs Lean statement`.
- Mantener `NO_GLOBAL_COLLATZ_CLAIM`.

## Estado vivo verificado

Fuente API:
- `https://ccchallenge.org/api/papers/Eliahou1993`
- `https://ccchallenge.org/api/papers/Eliahou1993/formalisations`
- `https://ccchallenge.org/api/papers/Eliahou1993/formalisations/6/audit-reports`
- `https://ccchallenge.org/api/papers/Eliahou1993/reviews`

Paper:
- key: `Eliahou1993`
- titulo: `The $3x +  1$ problem: New Lower Bounds on Nontrivial Cycle Lengths`
- autor: Shalom Eliahou
- venue: Discrete Math., Vol. 118, pp. 45--56
- DOI: `10.1016/0012-365X(93)90052-U`
- estado: `waiting_to_be_audited`
- formalizaciones: 1
- reviews: 2

Formalizacion objetivo:
- id: 6
- proof assistant: `lean4`
- repository: `http://github.com/tangentstorm/eliahou-collatz-bounds`
- status: `waiting_to_be_audited`
- autor visible: `tangentstorm`
- AI-assisted: true
- AI model: `aristotle`
- audit reports registrados: 0

GitHub Discussions:
- busqueda exacta publica por titulo `Eliahou1993` en `ccchallenge-org`: 0 resultados.
- Interpretacion: si se usa el boton Forum, probablemente abrira una nueva discussion en categoria `papers` con titulo `Eliahou1993`. Esto no descarta coordinacion informal en Discord.

Repositorio inspeccionado solo como texto:
- `https://github.com/tangentstorm/eliahou-collatz-bounds`
- commit clonado: `fdb0b2e1ac0d774f4e288ffa2106785efd351563`
- fecha commit: 2026-04-09 20:43:12 -0400
- commit message: `removed unused/unproven 'precise' reformulation`

No se ejecuto Lean, Lake ni `lake exe cache get`.

## Reviews existentes resumidas

ELIAHOU1993_REVIEWS_SUMMARIZED: yes.

### Review 1: Lagarias annotated bibliography

Catalog record:
- review id: 53
- external URL: `https://arxiv.org/pdf/math/0309224#page=23`
- comment: Entry #53 in J. C. Lagarias, "The 3x+1 problem: An annotated bibliography (1963-1999)", arXiv:math/0309224
- user: `lagarias-bot`

Resumen:
- Lagarias identifica el resultado principal como una restriccion fuerte sobre ciclos no triviales de la funcion `T(x)`.
- Para cualquier ciclo no trivial en los positivos, el periodo se expresa como
  `p = 301994 A + 17087915 B + 85137581 C`,
  con `A, B, C` enteros no negativos, `B >= 1`, y al menos uno de `A` o `C` igual a cero.
- De esa forma lineal se obtiene que la longitud minima posible del periodo es al menos `17087915`.
- La prueba usa la expansion en fracciones continuas de `log_2 3`.
- Tambien usa la verificacion de la conjetura `3x+1` para todos los `n < 2^40`.
- El paper incluye una tabla de cocientes parciales y convergentes de la fraccion continua de `log_2 3`.

Relevancia para auditoria:
- La review fija dos niveles de statement a comparar:
  1. statement fuerte/preciso: forma lineal del periodo;
  2. consecuencia minima: cota inferior `17087915`.
- La formalizacion id 6 parece apuntar a la consecuencia minima, no a la forma lineal completa.

### Review 2: zbMATH entry

Catalog record:
- review id: 333
- external URL: `https://zbmath.org/0786.11012`
- comment: null
- user: `oros_34734`

Resultado de lectura:
- La URL responde, pero desde esta sesion devuelve una pagina de challenge Cloudflare ("Just a moment...") y no expone texto matematico ni metadata util.
- Por tanto, no se debe usar como fuente matematica sustantiva hasta abrirla manualmente en navegador o conseguir una exportacion accesible.

Resumen operativo:
- Es una referencia bibliografica externa a zbMATH/Zbl `0786.11012` para el mismo paper.
- No aporta, desde esta sesion, detalles adicionales auditables mas alla de confirmar que existe una ficha bibliografica enlazada.

## Enunciado del paper a usar como ancla

Fuente primaria textual inspeccionada:
- PDF incluido en el repo de formalizacion: `work/eliahou-collatz-bounds/eliahou-collatz.pdf`
- 12 paginas.

Abstract:
- `T : N -> N` se define por `T(n) = n/2` si `n` es par y `T(n) = (3n+1)/2` si `n` es impar.
- El paper muestra, entre otras cosas, que cualquier orbita ciclica no trivial bajo iteracion de `T` debe contener al menos `17 087 915` elementos.

Theorem 1.1, forma OCR-normalizada:
- Sea `Omega` un ciclo no trivial de `T`.
- Si `min Omega > 2^40`, entonces
  `Card Omega = 301994 a + 17087915 b + 85137581 c`,
  donde `a, b, c` son enteros no negativos, `b > 0`, y `a c = 0`.
- En particular, los primeros valores admisibles de `Card Omega` son `17087915`, `17389909`, `17691903`, ...

Theorem 2.1, ancla secundaria:
- Para un ciclo `Omega` de `T`, y `Omega_1` el subconjunto de elementos impares,
  `log_2(3 + 1/M) < Card Omega / Card Omega_1 <= log_2(3 + 1/m)`,
  con `M = max Omega`, `m = min Omega`.
- El paper tambien da una desigualdad derecha mas fina usando el promedio de `n^-1` sobre `Omega_1`.

Lemma 2.2, ancla secundaria:
- Para `Omega_1` los impares de un ciclo y `k = Card Omega`,
  el producto sobre `n in Omega_1` de `(3 + n^-1)` es `2^k`.

Corollary 2.3:
- El paper define funciones `K(m)` y `L(m)` a partir del intervalo de aproximacion de `log_2(3)` y deduce cotas inferiores para `Card Omega` y `Card Omega_1`.

## Enunciado Lean visible

Archivo principal:
- `Collatz/ContinuedFractions.lean`

Definiciones visibles:
- `collatzComp (n : Nat) : Nat := if n % 2 = 0 then n / 2 else (3 * n + 1) / 2`
- `CollatzCycle L`: estructura con `hL : 0 < L`, `seq : Fin L -> Nat`, positividad, y paso `collatzComp (seq i) = seq (i.succMod hL)`.
- `CollatzCycle.minElem`, `maxElem`, `numOdd`.
- `CollatzCycle.isNontrivial c := 2 < c.minElem`.

Statement central visible:

```lean
theorem eliahou_bound {L : Nat} (c : CollatzCycle L)
    (hmin : (2 : Nat) ^ 40 < c.minElem)
    (hk : 0 < c.numOdd) :
    17087915 <= L
```

Claims auxiliares visibles:
- `eliahou_product_formula`: formula de producto.
- `eliahou_product_formula_real`: producto real `prod (3 + 1 / x_i) = 2^L`.
- `eliahou_sandwich`: sandwich no estricto en ambos lados:
  `logb 2 (3 + 1 / maxElem) <= L / numOdd` y
  `L / numOdd <= logb 2 (3 + 1 / minElem)`.
- `log2_three_lt_ratio`: `logb 2 3 < L / numOdd`.
- `rational_approx_bound`: si `m > 2^40` y `L/k1` cae en el intervalo, entonces `17087915 <= L`.

Observaciones preliminares para Fase 1:
- El statement Lean `eliahou_bound` formaliza la consecuencia de cota inferior, no la forma lineal completa de Theorem 1.1.
- README/summary mencionan `eliahou_precise` como forma lineal no formalizada/removida o con "sorry" historico. En el codigo actual no aparece `eliahou_precise`.
- Hay usos de `native_decide` en hechos numericos de `ContinuedFractions.lean`; esto queda para cierre mecanico posterior, no para esta fase de fidelidad de statement.

## Borrador de mensaje Forum

FORUM_ANNOUNCEMENT_DRAFTED: yes.

Titulo sugerido:

```text
Eliahou1993
```

Cuerpo sugerido:

```markdown
Hi all,

I intend to start an audit of the Lean 4 formalisation registered for `Eliahou1993`, formalisation id `6`:

- Paper: Shalom Eliahou, "The 3x+1 problem: New Lower Bounds on Nontrivial Cycle Lengths", Discrete Mathematics 118 (1993), 45--56.
- Formalisation: https://github.com/tangentstorm/eliahou-collatz-bounds
- CC Challenge status: `waiting_to_be_audited`
- Registered as AI-assisted: `aristotle`

I will not add an audit report link immediately. First I plan to do a Phase 1 statement-fidelity pass and report back here:

1. Compare the paper statements against the Lean statements, especially Theorem 1.1, Theorem 2.1, Lemma 2.2, and Corollary 2.3.
2. Check whether the formalisation is intentionally proving only the lower-bound consequence `17087915 <= L`, rather than the full linear form
   `Card Omega = 301994 a + 17087915 b + 85137581 c`.
3. Check domain and cycle conventions: positive integers vs `Nat`, compressed map `T`, definition of cycle length, nontrivial cycle/minimum assumptions, and the role of the `n < 2^40` computational verification.
4. Only after that, if there is no coordination objection, proceed to mechanical checks such as `lake build`, axiom/sorry audit, and review of `native_decide`-backed numerical facts.

Please let me know if someone is already auditing this formalisation, if there is preferred coordination etiquette, or if maintainers/authors would like the first pass scoped differently.

I will avoid making any global Collatz claim; this is only an audit of the registered formalisation against the paper.
```

Accion pendiente:
- Publicar o adaptar este mensaje en Forum solo despues de aprobacion humana.
- No crear audit link hasta que haya respuesta/no objecion o coordinacion explicita.

## Plan de auditoria Fase 1

STATEMENT_FIDELITY_FIRST: yes.

### Fase 1.0 - Congelar evidencia

- Guardar snapshot de:
  - API paper `Eliahou1993`.
  - API formalisation id 6.
  - API reviews.
  - API audit reports, actualmente `[]`.
  - commit exacto del repo auditado.
- No modificar el repo auditado.
- No ejecutar Lean todavia.

### Fase 1.1 - Tabla paper statement vs Lean statement

Crear una tabla con columnas:
- fuente paper;
- statement informal normalizado;
- archivo Lean;
- declaracion Lean;
- direccion de implicacion;
- verdict `MATCH / WEAKENING / STRENGTHENING / AMBIGUOUS / GAP`.

Filas iniciales:
- Definicion de `T`.
- Definicion de ciclo y longitud `Card Omega`.
- Definicion de ciclo no trivial.
- Theorem 1.1 forma lineal.
- Consecuencia `Card Omega >= 17087915`.
- Theorem 2.1 sandwich.
- Lemma 2.2 formula de producto.
- Corollary 2.3 funciones `K(m)`/`L(m)`.
- Uso de verificacion computacional hasta `2^40`.

### Fase 1.2 - Preguntas adversariales de fidelidad

- Dominio: el paper usa `N = {1,2,...}`; Lean usa `Nat` con `collatzComp 0 = 0` fuera del dominio. Verificar que `CollatzCycle.pos` elimina `0`.
- Ciclo: el paper define una trayectoria como conjunto/orbita; Lean usa una secuencia indexada por `Fin L`. Verificar si permite repeticiones internas que inflen `L` o si hay lemmas que fuerzan periodicidad simple/cardinalidad real.
- Longitud: paper `Card Omega`; Lean concluye sobre el parametro `L`. Verificar que `L` coincide semanticamente con cardinalidad del ciclo, no solo con periodo parametrizado de una secuencia.
- No trivialidad: paper "nontrivial cycle"; Lean theorem usa `2^40 < c.minElem`, no `isNontrivial`. Verificar si esto es intencional y suficiente dada la verificacion computacional externa.
- Hipotesis `min Omega > 2^40`: paper la usa en Theorem 1.1; la consecuencia incondicional depende de la verificacion computacional previa. Lean statement no incorpora formalmente la verificacion de todos los `n < 2^40`.
- Forma lineal: paper prueba forma exacta con `a,b,c`; Lean central visible solo prueba cota inferior. Clasificarlo como formalizacion parcial si no hay theorem lineal.
- Desigualdades: paper tiene una desigualdad izquierda estricta en Theorem 2.1; Lean `eliahou_sandwich` usa `<=` a la izquierda, pero `log2_three_lt_ratio` recupera `log_2 3 < L/k1`. Verificar si la version usada basta para el bound.
- Elementos impares: paper usa `Omega_1` como subconjunto de impares; Lean usa indices impares `oddIndices`. Verificar que producto/contadores no dependen de duplicaciones.
- Numerica: `native_decide` se usa para grandes desigualdades exponenciales. En Fase 1 solo registrar que la prueba depende de estos hechos; la politica de confianza va a cierre mecanico posterior.

### Fase 1.3 - Primer veredicto local

Entregar un reporte corto con:
- statement strongest supported by Lean as written;
- statement from paper not covered;
- hypotheses added/removed;
- whether a public audit should proceed to mechanical phase;
- questions for `tangentstorm`/maintainers before adding audit link.

### Fase 1.4 - Gate antes de audit link

No crear audit link si ocurre cualquiera de estos casos:
- hay ambiguedad no resuelta sobre `L = Card Omega`;
- la formalizacion reclama Theorem 1.1 completo pero solo contiene la consecuencia de cota;
- aparece coordinacion externa que ya esta auditando id 6;
- el Forum/maintainers piden esperar.

Si Fase 1 no encuentra bloqueo de statement:
- publicar update en Forum;
- entonces preparar Fase 2 mecanica: `lake build`, axiom audit, `sorry` audit, revision de `native_decide`.

## Guardarrailes activos

- No crear audit link todavia.
- No ejecutar Lean todavia.
- No registrar ningun target propio en esta tarea.
- No tocar Terras1976.
- No hacer claim global sobre Collatz.
- No presentar el draft de Forum como publicado.

## Clasificaciones

- ELIAHOU1993_REVIEWS_SUMMARIZED: yes
- FORUM_ANNOUNCEMENT_DRAFTED: yes
- STATEMENT_FIDELITY_FIRST: yes
- AUDIT_LINK_NOT_CREATED: yes
- WAITING_ON_FORUM_COORDINATION: yes, pending human approval/posting of Forum announcement
