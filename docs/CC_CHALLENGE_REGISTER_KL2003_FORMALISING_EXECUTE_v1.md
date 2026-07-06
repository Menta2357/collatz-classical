# CC_CHALLENGE_REGISTER_KL2003_FORMALISING_EXECUTE_v1

Fecha: 2026-07-07.

Estado: aprobacion humana explicita recibida; endpoint verificado; POST
intentado; registro bloqueado por autenticacion CC Challenge (`401
Unauthorized`).

## Clasificacion

```text
KL2003_STATUS_REFRESHED
REGISTRATION_STILL_AVAILABLE
REGISTRATION_ENDPOINT_VERIFIED
KL2003_REGISTRATION_ATTEMPTED
KL2003_REGISTRATION_BLOCKED_ON_CC_AUTH
DATA_ONLY_LEAN_GATE_REMAINS_CLOSED
DATA_ONLY_LEAN_ALREADY_EXISTS_AS_PUBLIC_GITHUB_DRAFT
NO_GLOBAL_COLLATZ_CLAIM
```

Las clasificaciones siguientes no se declaran porque el POST no quedo
autenticado/aceptado:

```text
KL2003_REGISTRATION_EXECUTED
KL2003_FORMALISING_CONFIRMED_BY_GET
DATA_ONLY_LEAN_GATE_OPENED
```

## Base

```text
docs/KL2003_REGISTRATION_DECISION_HOLD_OR_EXECUTE_v1.md
docs/CC_CHALLENGE_REGISTER_KL2003_FORMALISING_PRE_DATA_v1.md
docs/KL2003_K2_DATA_LEAN_DRY_RUN_DESIGN_v1.md
```

Regla de ejecucion de esta tarea:

```text
Ejecutar POST si y solo si hay aprobacion humana explicita en este hilo.
Frase requerida: "Apruebo registrar KrasikovLagarias2003 ahora."
```

La aprobacion humana explicita fue emitida el 2026-07-07:

```text
Apruebo registrar KrasikovLagarias2003 ahora.
```

Por tanto el POST quedo autorizado por el usuario.

## Refresco API

Endpoints consultados mediante GET:

```text
https://ccchallenge.org/api/papers/KrasikovLagarias2003
https://ccchallenge.org/api/papers/KrasikovLagarias2003/formalisations
```

Snapshot obtenido:

```text
id = 166
bibtex_key = KrasikovLagarias2003
title = Bounds for the $3x+1$ problem using difference inequalities
authors = Ilia Krasikov and J. C. Lagarias
year = 2003
journal = Acta Arithmetica
volume = 109
number = 3
pages = 237--258
url = https://eudml.org/doc/278462
formalisation_status = not_started
formalisations_count = 0
reviews_count = 2
formalisations = []
```

Confirmacion:

```text
formalisation_status = not_started
formalisations_count = 0
registration slot still appears available
```

## Contrato de API verificado

Se clono el repo publico de CC Challenge para confirmar el endpoint y los
campos, en vez de adivinar el POST.

Archivo fuente:

```text
backend/routers/formalisations.py
```

Contrato relevante:

```text
router = APIRouter(prefix="/papers/{bibtex_key}/formalisations", tags=["formalisations"])
@router.post("", status_code=201)
```

Por tanto, el endpoint correcto bajo prefijo `/api` es:

```text
POST https://ccchallenge.org/api/papers/KrasikovLagarias2003/formalisations
```

Schema verificado en:

```text
backend/schemas.py
```

Campos:

```text
proof_assistant: ProofAssistant
repository_url: str
ai_assisted: bool = False
ai_models: str | None = None
```

El router depende de:

```text
user: User = Depends(current_active_user)
```

Por tanto requiere sesion/autenticacion activa en CC Challenge.

## Payload preparado, no enviado

Payload previsto:

```json
{
  "proof_assistant": "lean4",
  "repository_url": "https://github.com/Menta2357/collatz-classical",
  "ai_assisted": true,
  "ai_models": "Codex / GPT-5-based agents; Claude Fable reviewer"
}
```

Estado previo:

```text
POST authorized = yes
AI assistance disclosed in prepared payload = yes
formalisation GET after POST = attempted after unauthorized POST not applicable
```

## POST intentado

Comando:

```bash
curl -i -X POST https://ccchallenge.org/api/papers/KrasikovLagarias2003/formalisations \
  -H 'Content-Type: application/json' \
  --data '{"proof_assistant":"lean4","repository_url":"https://github.com/Menta2357/collatz-classical","ai_assisted":true,"ai_models":"Codex / GPT-5-based agents; Claude Fable reviewer"}'
```

Resultado:

```text
HTTP/2 401
{"detail":"Unauthorized"}
```

Por tanto:

```text
POST attempted = yes
POST accepted = no
KL2003 registration executed = no
blocking reason = CC Challenge authentication required
```

## Estado operativo

El gate publico no queda abierto todavia:

```text
DATA_ONLY_LEAN_GATE_OPENED = no
```

Motivo:

```text
La aprobacion humana existe, pero falta una sesion CC Challenge autenticada
para que el servidor acepte el POST.
```

Siguientes opciones:

```text
1. Login manual en ccchallenge.org y registrar via UI.
2. Login manual en ccchallenge.org y proporcionar un mecanismo autorizado de
   sesion/cookie para repetir el POST.
3. Mantener el estado actual: GitHub publico con data-only Lean draft, pero CC
   Challenge aun not_started.
```

## Resultado

```text
KL2003_STATUS_REFRESHED = yes
REGISTRATION_STILL_AVAILABLE = yes
REGISTRATION_ENDPOINT_VERIFIED = yes
KL2003_REGISTRATION_ATTEMPTED = yes
KL2003_REGISTRATION_EXECUTED = no
KL2003_REGISTRATION_BLOCKED_ON_CC_AUTH = yes
KL2003_FORMALISING_CONFIRMED_BY_GET = no
AI_ASSISTANCE_DISCLOSED = prepared_payload_only / attempted POST payload
DATA_ONLY_LEAN_GATE_OPENED = no
DATA_ONLY_LEAN_ALREADY_EXISTS_AS_PUBLIC_GITHUB_DRAFT = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
