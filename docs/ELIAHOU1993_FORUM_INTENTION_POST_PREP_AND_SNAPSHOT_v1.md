# ELIAHOU1993_FORUM_INTENTION_POST_PREP_AND_SNAPSHOT_v1

Fecha snapshot: 2026-07-05 18:53:44 CEST.

Estado: post publico de intencion preparado, no publicado.

## Guardarrailes

- NO_AUDIT_LINK.
- NO_SCOPE_FINDINGS_AS_PUBLIC_VERDICT.
- NO_ISSUE_TO_AUTHOR_YET.
- NO_GLOBAL_COLLATZ_CLAIM.
- No Forum post realizado desde este hilo.
- No POST/PATCH contra CC Challenge.

## Base

Documentos base:
- `docs/CLAUDE_PUBLIC_CONTACT_AND_DATA_LEAN_GATE_VERDICT_2026_07_05_v1.md`
- `docs/ELIAHOU1993_AUDIT_PHASE1_PREP_v1.md`
- `docs/ELIAHOU1993_EXACT_PERIOD_GLUE_RECOMMENDATION_v1.md`

Decision vigente:
- `ELIAHOU_NEXT = FORUM_NOW + MECHANICAL_AUDIT_LOCAL_IN_PARALLEL`.
- Publicar solo anuncio de intencion.
- No publicar todavia hallazgos de scope/glue como veredicto.
- No crear audit link.
- Enviar issue/recomendacion al autor solo cuando el paquete completo este listo.

## Snapshot API refrescado

ELIAHOU1993_API_SNAPSHOT_REFRESHED: yes.

Fuentes consultadas:
- `https://ccchallenge.org/api/papers/Eliahou1993`
- `https://ccchallenge.org/api/papers/Eliahou1993/formalisations`
- `https://ccchallenge.org/api/papers/Eliahou1993/formalisations/6/audit-reports`
- `https://ccchallenge.org/api/papers/Eliahou1993/reviews`
- `https://api.github.com/search/issues?q=%22Eliahou1993%22%20in:title%20org:ccchallenge-org%20is:discussion`

Raw snapshot temporal:
- `/private/tmp/eliahou1993_forum_snapshot_20260705/paper.json`
- `/private/tmp/eliahou1993_forum_snapshot_20260705/formalisations.json`
- `/private/tmp/eliahou1993_forum_snapshot_20260705/audit_reports_f6.json`
- `/private/tmp/eliahou1993_forum_snapshot_20260705/reviews.json`
- `/private/tmp/eliahou1993_forum_snapshot_20260705/github_discussion_search.json`

Paper:
- key: `Eliahou1993`
- title: `The $3x +  1$ problem: New Lower Bounds on Nontrivial Cycle Lengths`
- author: Shalom Eliahou
- year: 1993
- venue: Discrete Math., Vol. 118, pp. 45--56
- DOI: `10.1016/0012-365X(93)90052-U`
- formalisation_status: `waiting_to_be_audited`
- formalisations_count: 1
- reviews_count: 2

Formalisation id 6:
- proof assistant: `lean4`
- repository: `https://github.com/tangentstorm/eliahou-collatz-bounds`
- status: `waiting_to_be_audited`
- user_display_name: `tangentstorm`
- AI-assisted: true
- AI model: `aristotle`
- created_at: `2026-04-10T04:23:03.574880`

Audit reports:
- formalisation id 6 audit reports: `[]`
- count: 0

Reviews:
- review id 333: `https://zbmath.org/0786.11012`, user `oros_34734`
- review id 53: `https://arxiv.org/pdf/math/0309224#page=23`, user `lagarias-bot`
- count: 2

Forum / GitHub Discussion:
- exact public search for title `Eliahou1993` in `ccchallenge-org` discussions: `total_count = 0`
- `incomplete_results = false`
- interpretation: no exact Discussion was found via the same public search pattern used by the site. If posting through the Forum button, expect a new Discussion titled `Eliahou1993` unless the UI finds a discussion by another route.

Snapshot conclusions:
- `waiting_to_be_audited`: confirmed.
- `0 audit reports`: confirmed.
- no exact Discussion found: confirmed by public search.

## Public post constraints

FINDINGS_NOT_DISCLOSED_YET: yes.

The public post must:
- announce intention only;
- avoid reporting private scope/glue findings;
- avoid mentioning:
  - exact-period bridge missing;
  - consequence-only scope;
  - `hk` lemma;
  - any local verdict;
- say statement-fidelity is first;
- say no audit link yet;
- ask if someone is already auditing;
- avoid any global Collatz claim.

## Forum post final draft

FORUM_INTENTION_POST_READY: yes.

Suggested title:

```text
Eliahou1993
```

Suggested body:

````markdown
Hi all,

I intend to audit the Lean 4 formalisation registered for `Eliahou1993`,
formalisation id `6`:

- Paper: Shalom Eliahou, "The 3x+1 problem: New Lower Bounds on Nontrivial Cycle Lengths", Discrete Mathematics 118 (1993), 45--56.
- Formalisation: https://github.com/tangentstorm/eliahou-collatz-bounds
- Current CC Challenge status: `waiting_to_be_audited`
- Registered as AI-assisted: `aristotle`

I will start with a statement-fidelity pass: comparing the paper statements
against the Lean statements and checking the basic conventions around the
compressed Collatz map, cycles, lengths, hypotheses, and the numerical bound.

I previously contacted the repository maintainers through issue #1 on
2026-07-07 to coordinate author-first. If this Forum post is published, it is
because no maintainer response was visible after the recorded response window:
https://github.com/tangentstorm/eliahou-collatz-bounds/issues/1

I have not added an audit report link yet. I plan to keep the first pass local
and report back before adding any audit link.

Please let me know if someone is already auditing this formalisation, if there
is preferred coordination etiquette for this entry, or if maintainers/authors
would like the first pass scoped in a particular way.

I will avoid making any global Collatz claim; this is only an audit of the
registered formalisation against the cited paper.
````

## Publication decision

Current recommendation:
- The post above is ready to publish in Forum, subject to explicit user approval/action.
- Do not include scope/glue findings in the initial Forum post.
- Do not create an audit link yet.
- The author-first GitHub issue already exists; do not open a duplicate issue.
- The mechanical and statement-fidelity audit has already been completed locally.

MECHANICAL_AUDIT_LOCAL_PARALLEL_READY: yes.

## Classifications

- ELIAHOU1993_API_SNAPSHOT_REFRESHED: yes
- FORUM_INTENTION_POST_READY: yes
- AUTHOR_FIRST_CONTACT_ALREADY_SENT: yes
- FINDINGS_NOT_DISCLOSED_YET: yes
- AUDIT_LINK_NOT_CREATED: yes
- MECHANICAL_AUDIT_LOCAL_PARALLEL_READY: yes
- NO_GLOBAL_COLLATZ_CLAIM: yes
