# CC_CHALLENGE_AUDIT_ENTRY_PLAN_v1

Objetivo: entrar al Collatz Conjecture Challenge (ccchallenge.org) por el
cuello de botella real del proyecto — la auditoría — y desde dentro evaluar
el estado de la formalización de Terras1976 antes de decidir el Carril 3.

Estado verificado del sitio (julio 2026):

```
1 / 362 papers formalised
3 being formalised        (incluye Terras1976)
4 ready to be audited
0 being audited
```

## Fase 0 — Reconocimiento (1 sesión)

- Leer las guías de contribución del sitio/repositorio del challenge
  (proceso exacto de auditoría, formato esperado, dónde se entregan informes).
  NO asumir el proceso: leerlo. Este plan se actualiza con lo que diga.
- Listar las 4 formalizaciones "ready to be audited": paper, autor de la
  formalización, toolchain (Lean/Isabelle/Coq), tamaño aproximado.
- Criterio de selección de la primera auditoría:
  1. preferir Lean 4 (nuestro toolchain);
  2. preferir el paper cuyo enunciado matemático dominemos sin estudio nuevo;
  3. preferir tamaño mediano (ni trivial ni monstruo) para calibrar coste.

## Fase 1 — Primera auditoría (1–3 sesiones)

Aplicar `audits/ADVERSARIAL_AUDIT_CHECKLIST_v1.md` completo. Entregable:

```
AUDIT_REPORT_<paper>_v1.md
  - veredicto por sección: SOUND / CONDITIONAL / GAP / OVERCLAIM
  - tabla de carga de hipótesis (qué asume cada teorema central)
  - axiom audit reproducido por nosotros, no citado del autor
  - divergencias enunciado-formal vs enunciado-del-paper
  - clasificación final calibrada
```

Tono del informe: el mismo que usamos internamente — técnico, específico,
sin adjetivos. Crédito explícito a lo que está bien hecho.

## Fase 2 — Evaluación de Terras1976 en curso (paralela a Fase 1)

- Localizar la formalización en curso y su repositorio.
- Diagnóstico en tres categorías:
  - `HEALTHY`: avanza y es sólida → ofrecer revisión, no competir.
  - `STALLED`: sin commits recientes / bloqueada → contactar al autor y
    ofrecer colaboración antes de considerar relevo.
  - `WEAK`: compila pero con hipótesis que cargan el peso o enunciado
    debilitado → auditoría formal + oferta de contribución.
- Regla fija: cualquier acción sobre Terras pasa por contacto con el autor
  original de la formalización. No se duplica en silencio.

## Fase 3 — Decisión

Con Fase 1 entregada y Fase 2 diagnosticada, decidir asignación de tiempo
entre: (a) segunda auditoría, (b) Carril 2 (KL2003), (c) contribución a
Terras. Registrar la decisión en este documento como v2.

## Métricas de éxito del carril

- 1 informe de auditoría aceptado/publicado en el challenge.
- Diagnóstico de Terras1976 con evidencia (commits, contenido), no impresión.
- Mapa de las 362 entradas del catálogo relevantes a nuestra maquinaria
  (subproducto de la Fase 0, alimenta el Carril 2).
