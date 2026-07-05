# CC_CHALLENGE_AUDIT_ENTRY_PHASE0_v2

Fecha de corte: 2026-07-05, Europe/Madrid.

Estado final: AUDIT_ENTRY_READY, WAITING_ON_COORDINATION_REVIEW.

Guardarrailes aplicados:
- NO_LEAN: no se ejecuto Lean, Lake ni builds de formalizaciones.
- NO_DUPLICATE_TERRAS: Terras1976 ya tiene una formalizacion registrada; no se propone duplicarla sin coordinacion.
- NO_TARGET_REGISTRATION_YET: no se hizo ningun POST/PATCH, no se registro target propio ni audit link.
- NO_GLOBAL_COLLATZ_CLAIM: no se afirma ningun resultado global de Collatz.

## Fuentes inspeccionadas

- Sitio vivo: https://ccchallenge.org/
- Guia "Contribute": https://ccchallenge.org/contribute
- Guia "Method": https://ccchallenge.org/method
- Pagina "Story" y maintainers: https://ccchallenge.org/story
- Repositorio publico de la app: https://github.com/ccchallenge-org/ccchallenge
- Commit local clonado para inspeccion de codigo: `a2f0ac5520628e85bc01edd21ce0f10bc09ea9f3`, 2026-05-18.
- API publica consultada con GET:
  - `https://ccchallenge.org/api/papers?status=waiting_to_be_audited`
  - `https://ccchallenge.org/api/papers/{bibtex_key}`
  - `https://ccchallenge.org/api/papers/{bibtex_key}/formalisations`
  - `https://ccchallenge.org/api/papers/{bibtex_key}/formalisations/{id}/audit-reports`
- Busqueda publica de GitHub Discussions via:
  - `https://api.github.com/search/issues?q="<bibtex_key>" in:title org:ccchallenge-org is:discussion`

## Guias reales leidas

### Metodo del challenge

Cada paper pasa por tres etapas:
1. Formalisation: una o mas personas formalizan resultados del paper en un proof assistant; el codigo debe estar en un repositorio publico; si se usa AI debe declararse.
2. Audit: una o mas personas comprueban si la formalizacion captura fielmente el contenido del paper y escriben un audit report recomendando aceptar o rechazar, con justificacion argumentada. Los auditores deben ser distintos de los autores de la formalizacion salvo que la formalizacion haya sido hecha por AI. Los humanos autores del reporte son responsables del contenido.
3. Acceptance: admins siguen las recomendaciones del audit report, salvo si no se cumple el criterio de accountability humana. Formalizaciones aceptadas cuentan para el goal; rechazadas vuelven a stage 1.

### Contribucion

Acciones reconocidas por la guia:
- Escribir una formalizacion.
- Escribir un audit report.
- Escribir una review informal y linkearla.
- Votar wishlists.
- Agregar paper.
- Editar metadata.
- Linkear formalizaciones y reviews existentes.
- Sugerir exclusion.
- Coordinar en GitHub Discussions y Discord.

Q&A relevante:
- AI esta permitida, pero debe declararse en formalizaciones.
- AI puede asistir audit reports, pero humanos deben ser 100% accountable.
- Formalizaciones parciales son aceptadas.
- El proyecto es proof-assistant agnostic.
- Diferentes formalizaciones de un mismo paper pueden coexistir, incluso en distintos proof assistants.

Maintainers publicos listados:
- Tristan Sterin (cosmo): https://github.com/tcosmo/
- Olivier Rozier: https://www.ipgp.fr/~rozier/

## Formalizaciones ready to audit

Snapshot API: 4 formalizaciones listas para auditar.

| Paper | Estado paper | Formalizacion(es) | Reviews | Audit reports registrados |
|---|---:|---:|---:|---:|
| BernsteinLagarias1996 - The $3x+1$ Conjugacy Map | waiting_to_be_audited | 1 | 2 | 0 |
| Eliahou1993 - The $3x + 1$ problem: New Lower Bounds on Nontrivial Cycle Lengths | waiting_to_be_audited | 1 | 2 | 0 |
| EliahouVergerGaugry2025 - The number system in rational base $3/2$ and the $3x+1$ problem | waiting_to_be_audited | 1 | 1 | 0 |
| RozierTerracol2025 - Paradoxical behavior in Collatz sequences | waiting_to_be_audited | 2 | 0 | 0 |

Detalles por formalizacion:

| Paper | Formalisation id | Proof assistant | Status | Repository | Autor visible | AI |
|---|---:|---|---|---|---|---|
| BernsteinLagarias1996 | 8 | lean4 | waiting_to_be_audited | https://github.com/rwst/lean-code/tree/main/BL | drdisentangle | Opus 4.8 |
| Eliahou1993 | 6 | lean4 | waiting_to_be_audited | http://github.com/tangentstorm/eliahou-collatz-bounds | tangentstorm | aristotle |
| EliahouVergerGaugry2025 | 5 | lean4 | waiting_to_be_audited | https://rwst.github.io/Collatz-Map-Basics/ | rwst | Opus 4.6 |
| RozierTerracol2025 | 7 | lean4 | waiting_to_be_audited | https://github.com/rwst/lean-code/tree/main/RT | drdisentangle | Opus 4.8 |
| RozierTerracol2025 | 4 | lean4 | formalising | https://rwst.github.io/Collatz-Map-Basics/ | cosmo | no |

## Candidata inicial seleccionada

READY_TO_AUDIT_TARGET_SELECTED:

Seleccion preliminar para revision de coordinacion: `Eliahou1993`, formalisation id `6`, repositorio `http://github.com/tangentstorm/eliahou-collatz-bounds`.

Razon:
- Esta en estado `waiting_to_be_audited`.
- Tiene una sola formalizacion registrada y 0 audit reports.
- No es Terras1976 y no pisa ningun target propio.
- Es un paper clasico y acotado sobre lower bounds de ciclos no triviales.
- Tiene 2 reviews ya enlazadas en el catalogo, lo que puede ayudar al auditor.
- El repo publico existe y se presenta como formalizacion Lean 4 de resultados de Eliahou. No se ejecuto build.

Nota de sincronizacion:
- Esta seleccion no es GO.
- No se debe anunciar ni agregar audit link hasta que este hilo y el Hilo B sean revisados en el hilo de coordinacion.

## Estado Terras1976

TERRAS_STATUS_VERIFIED:

`Terras1976` existe en el catalogo y esta en estado `formalising`.

Datos API:
- Paper: `Terras1976`
- Titulo: "A stopping time problem on the positive integers"
- Estado: `formalising`
- Formalizaciones: 1
- Reviews: 1
- Audit reports en formalisation id 9: 0

Formalizacion registrada:
- id: 9
- proof assistant: lean4
- status: formalising
- repository: https://github.com/lechmazur/terras_density_one
- autor visible: lechmazur
- AI assisted: true
- AI models: GPT-5.5

Conclusion Terras:
- NO_DUPLICATE_TERRAS. No registrar ni empezar Terras sin coordinar primero con `lechmazur` y/o maintainers.
- Si se quiere contribuir a Terras, la ruta correcta es coordinacion sobre la formalizacion existente, no registrar una formalizacion paralela como primer movimiento.

## Estado de targets propios

OWN_TARGETS_CATALOG_STATUS_VERIFIED:

Todos los targets propios aparecen en el catalogo y no tienen formalizaciones registradas en el snapshot vivo. Todos estan en estado `not_started` segun API.

| Target | Estado | Formalizaciones | Reviews | Titulo |
|---|---:|---:|---:|---|
| Krasikov1989 | not_started | 0 | 1 | How many numbers satisfy the $3x + 1$ Conjecture? |
| ApplegateLagarias1995a | not_started | 0 | 2 | Density Bounds for the $3x+1$ Problem I. Tree-Search Method |
| ApplegateLagarias1995b | not_started | 0 | 2 | Density Bounds for the $3x+1$ Problem II. Krasikov Inequalities |
| ApplegateLagarias1995c | not_started | 0 | 2 | The distribution of $3x+1$ trees |
| KrasikovLagarias2003 | not_started | 0 | 2 | Bounds for the $3x+1$ problem using difference inequalities |

Conclusion targets propios:
- No hay duplicacion registrada en el catalogo para estos targets.
- Aun asi, por regla de sincronizacion, NO_TARGET_REGISTRATION_YET: no registrar ninguno hasta revision conjunta con Hilo B y coordinacion.

## Discussions publicas localizadas

Busqueda exacta por `bibtex_key` en GitHub Discussions de `ccchallenge-org`:

| Key | Resultado |
|---|---:|
| Eliahou1993 | 0 exact matches |
| Terras1976 | 0 exact matches |
| Krasikov1989 | 0 exact matches |
| ApplegateLagarias1995a | 0 exact matches |
| ApplegateLagarias1995b | 0 exact matches |
| ApplegateLagarias1995c | 0 exact matches |
| KrasikovLagarias2003 | 0 exact matches |

Interpretacion:
- No se localizo hilo publico exacto por `bibtex_key` mediante la misma clase de busqueda que usa la web.
- Esto no descarta coordinacion informal en Discord u otros canales.

## Mecanismo de registro y coordinacion

REGISTRATION_MECHANISM_UNDERSTOOD:

### Marcar "being formalised"

1. El usuario debe iniciar sesion.
2. En un paper, usar `Add formalisation`.
3. La UI envia `POST /api/papers/{bibtex_key}/formalisations`.
4. Payload esencial:
   - `proof_assistant`
   - `repository_url`
   - `ai_assisted`
   - `ai_models` si `ai_assisted = true`
5. El modelo `Formalisation` tiene default `status = formalising`, por lo que agregar una formalizacion marca el paper como being formalised.
6. La app notifica "Formalisation added".

### Marcar "ready to be audited"

1. Owner de la formalizacion, admin o maintainer puede usar `Mark as Ready to be Audited`.
2. La UI envia `PATCH /api/papers/{bibtex_key}/formalisations/{formalisation_id}/status`.
3. Payload: `{ "status": "waiting_to_be_audited" }`.
4. Un owner no privilegiado solo puede alternar entre `formalising` y `waiting_to_be_audited`.
5. Maintainers/admins pueden fijar cualquier status.

### Agregar audit report

1. Usuario logueado abre `+ Add Audit Link`.
2. Debe proporcionar `external_url`.
3. La UI exige confirmar: "Humans among the authors of this report are accountable for its content".
4. La app envia `POST /api/papers/{bibtex_key}/formalisations/{formalisation_id}/audit-reports`.
5. Si la formalizacion esta `formalising` o `waiting_to_be_audited`, agregar audit report la transiciona automaticamente a `auditing`.

### Acceptance

1. Solo admin/maintainer puede aceptar audit.
2. En status `auditing`, `Accept Audit` envia status `audited`.
3. El metodo publico dice que admins siguen recomendaciones del audit report salvo falla del criterio de accountability humana.

### Anunciar intencion y coordinar

Mecanismos visibles:
- GitHub Discussions general: https://github.com/orgs/ccchallenge-org/discussions
- Por paper: el boton `Forum` busca un Discussion con titulo exacto `bibtex_key` en `ccchallenge-org`; si no existe, abre una nueva discussion en categoria `papers` con ese titulo prellenado.
- Discord publico: https://discord.gg/NJYYYMFBjA
- Maintainers listados: Tristan Sterin (cosmo) y Olivier Rozier.

Accion recomendada despues de revision de coordinacion:
- Abrir o usar el Forum del paper seleccionado (`Eliahou1993`) para anunciar intencion de auditoria.
- Indicar que se auditara formalisation id 6 y que no se esta registrando target propio.
- Esperar confirmacion/no objecion de maintainers si el hilo de coordinacion lo requiere.

## Clasificaciones

- CC_GUIDES_READ: yes
- READY_TO_AUDIT_TARGET_SELECTED: yes, `Eliahou1993` formalisation id 6, pending coordination review
- TERRAS_STATUS_VERIFIED: yes, `Terras1976` is already `formalising`
- OWN_TARGETS_CATALOG_STATUS_VERIFIED: yes, all five listed own targets are `not_started` with 0 formalisations
- REGISTRATION_MECHANISM_UNDERSTOOD: yes
- AUDIT_ENTRY_READY: yes
- WAITING_ON_COORDINATION_REVIEW: yes

## Decision operacional

No declarar GO.

No registrar target propio.

No crear audit link todavia.

Esperar revision conjunta de este hilo y Hilo B en el hilo de coordinacion. La candidata inicial propuesta para auditoria, si coordinacion aprueba, es `Eliahou1993` formalisation id 6.
