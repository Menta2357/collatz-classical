# ELIAHOU1993_AUTHOR_FIRST_WINDOW_STATUS_CHECK_v1

Fecha de chequeo: 2026-07-10 23:56:47 CEST.

Estado: ventana author-first activa. No Forum post. No audit link. No global Collatz claim.

## Base

Issue upstream:
- `https://github.com/tangentstorm/eliahou-collatz-bounds/issues/1`

Notas base:
- `docs/ELIAHOU1993_AUTHOR_FIRST_CONTACT_SENT_v1.md`
- `STATUS.md`

## GitHub issue status

Consulta:
- GitHub connector, repo `tangentstorm/eliahou-collatz-bounds`, issue `#1`.

Issue:
- URL: `https://github.com/tangentstorm/eliahou-collatz-bounds/issues/1`
- Title: `Pre-audit coordination notes for the Eliahou1993 CC Challenge entry`
- Search result: issue found as open.

Comments:

```json
[]
```

Interpretacion:
- No hay comentarios en el issue.
- No hay respuesta visible de `tangentstorm`/maintainers.

Clasificacion:
- UPSTREAM_RESPONSE_PENDING.
- UPSTREAM_RESPONSE_RECEIVED: no.

## Window timing

Timestamp de contacto:
- `2026-07-06T23:21:44Z`
- `2026-07-07 01:21:44 CEST`

Deadline registrada:
- `2026-07-21 01:21 CEST`

Momento del chequeo:
- `2026-07-10 23:56:47 CEST`

Tiempo restante al deadline:
- `10 days, 1 hour, 24 minutes` aproximadamente.
- `869052` seconds.

Clasificacion:
- AUTHOR_FIRST_WINDOW_ACTIVE.

## Decision actual

Como no hay respuesta y la ventana author-first sigue activa:

- mantener silencio disciplinado;
- no comentar de nuevo en el issue;
- no publicar Forum todavia;
- no crear audit link;
- preparar solo un borrador de Forum de reserva.

Clasificacion:
- FORUM_RESERVE_POST_PREPARED.
- NO_FORUM_POST_YET.
- NO_AUDIT_LINK_YET.
- NO_GLOBAL_COLLATZ_CLAIM.

## Forum reserve draft

Uso previsto:
- Solo despues de `2026-07-21 01:21 CEST` si sigue sin respuesta upstream.
- Solo con aprobacion explicita antes de publicar.
- Debe ser un update/intention post, no un veredicto publico de auditoria.

Suggested title:

```text
Eliahou1993
```

Suggested body:

````markdown
Hi all,

I intend to continue a statement-fidelity and mechanical audit pass for the
Lean 4 formalisation registered for `Eliahou1993`, formalisation id `6`:

- Paper: Shalom Eliahou, "The 3x+1 problem: New Lower Bounds on Nontrivial Cycle Lengths", Discrete Mathematics 118 (1993), 45--56.
- Formalisation: https://github.com/tangentstorm/eliahou-collatz-bounds
- Current contact thread: https://github.com/tangentstorm/eliahou-collatz-bounds/issues/1

Before posting here, I contacted the upstream maintainer first with pre-audit
coordination notes and waited through the author-first response window. I am
posting this as a coordination update, not as an audit verdict.

My next step is to keep the audit scoped around statement fidelity and mechanical
checks, including the relationship between the paper statements and the Lean
statements. I have not created an audit report link yet.

Please let me know if someone is already auditing this formalisation, or if
there is preferred coordination etiquette for this entry before I add any audit
link or public audit report.

I am not making any global Collatz claim; this is only about auditing the
registered formalisation against the cited paper.
````

Notes on reserve draft:
- It mentions prior direct upstream contact without summarizing findings as a public verdict.
- It does not disclose detailed scope/glue conclusions in the Forum body.
- It does not create or imply an official audit link.
- It avoids any global Collatz claim.

## Response contingency

If an upstream response arrives before deadline:

1. Summarize the response before any Forum action.
2. Classify the response as one of:
   - `REQUIRES_TECHNICAL_REPLY`;
   - `REQUIRES_SMALL_PR`;
   - `WAIT_FOR_MAINTAINER`;
   - `SCOPE_CONFIRMED_CONSEQUENCE_ONLY`;
   - `SCOPE_DISPUTED_OR_NEEDS_CLARIFICATION`.
3. Do not publish Forum until the response is reviewed and a new coordination decision is recorded.

## Classifications

- AUTHOR_FIRST_WINDOW_ACTIVE.
- UPSTREAM_RESPONSE_PENDING.
- FORUM_RESERVE_POST_PREPARED.
- NO_FORUM_POST_YET.
- NO_AUDIT_LINK_YET.
- NO_GLOBAL_COLLATZ_CLAIM.

Not active:
- UPSTREAM_RESPONSE_RECEIVED.
