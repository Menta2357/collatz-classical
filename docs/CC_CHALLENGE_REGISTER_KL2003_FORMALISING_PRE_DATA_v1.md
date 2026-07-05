# CC_CHALLENGE_REGISTER_KL2003_FORMALISING_PRE_DATA_v1

Fecha: 2026-07-05.

Estado: preparacion de registro, sin POST ejecutado.

## Base

- Repo: <https://github.com/Menta2357/collatz-classical>
- `docs/CLAUDE_PUBLIC_CONTACT_AND_DATA_LEAN_GATE_VERDICT_2026_07_05_v1.md`
- `docs/KL2003_K2_CERTIFICATE_TO_LEAN_SPEC_BRIDGE_v1.md`
- `docs/KL2003_K2_LAMBDA_POWER_INTERVAL_CERTIFICATION_v1.md`

## Snapshot API

Endpoints consultados:

```text
https://ccchallenge.org/api/papers/KrasikovLagarias2003
https://ccchallenge.org/api/papers/KrasikovLagarias2003/formalisations
```

Resultado:

```text
bibtex_key = KrasikovLagarias2003
title = Bounds for the $3x+1$ problem using difference inequalities
authors = Ilia Krasikov and J. C. Lagarias
year = 2003
formalisation_status = not_started
formalisations_count = 0
reviews_count = 2
formalisations = []
```

Clasificacion:

```text
KL2003_STATUS_REFRESHED
```

## Payload preparado

Payload previsto para `Add formalisation` en CC Challenge:

```json
{
  "proof_assistant": "lean4",
  "repository_url": "https://github.com/Menta2357/collatz-classical",
  "ai_assisted": true,
  "ai_models": "Codex / GPT-5-based agents; Claude Fable reviewer"
}
```

Notas:

- El repo ya es publico.
- La declaracion AI-assisted debe mantenerse: el proyecto usa hilos Codex y
  revision externa de Claude Fable.
- No registrar `Krasikov1989` sin fuente primaria.

Clasificacion:

```text
REGISTRATION_PAYLOAD_READY
AI_ASSISTANCE_DISCLOSED
```

## Scope breve recomendado

Texto recomendado para descripcion/forum/nota de coordinacion si el Challenge
requiere aclarar alcance:

```text
I intend to formalise KrasikovLagarias2003 in Lean 4, starting with the k=2
certificate-data layer and M1-surrogate infrastructure extracted from KL2003.
The current repository contains specification documents, exact rational
certificate scripts, integer/rational witnesses, and no claimed KL2003 theorem
yet. The first Lean file will be data-only: constants and arithmetic witnesses,
with no M0 proof or global Collatz claim.
```

## Gate humano

No se ejecuto ningun `POST`, `PATCH`, ni cambio en CC Challenge.

Antes de registrar, se requiere aprobacion humana explicita.

Clasificacion:

```text
HUMAN_APPROVAL_REQUIRED_BEFORE_POST
NO_LEAN_DATA_FILE_YET
```

## Resultado

```text
KL2003_STATUS_REFRESHED = yes
REGISTRATION_PAYLOAD_READY = yes
AI_ASSISTANCE_DISCLOSED = yes
HUMAN_APPROVAL_REQUIRED_BEFORE_POST = yes
NO_LEAN_DATA_FILE_YET = yes
```
