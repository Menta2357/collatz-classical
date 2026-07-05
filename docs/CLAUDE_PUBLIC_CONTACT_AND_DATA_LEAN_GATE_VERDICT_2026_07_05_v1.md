# CLAUDE_PUBLIC_CONTACT_AND_DATA_LEAN_GATE_VERDICT_2026_07_05_v1

Fecha: 2026-07-05.

Base:

- `docs/ELIAHOU1993_EXACT_PERIOD_GLUE_RECOMMENDATION_v1.md`
- `docs/KL2003_K2_CERTIFICATE_TO_LEAN_SPEC_BRIDGE_v1.md`
- revision externa de Claude Fable.

## Veredicto

```text
ELIAHOU_NEXT       = FORUM_NOW + MECHANICAL_AUDIT_LOCAL_IN_PARALLEL
KL_NEXT            = DATA_ONLY_LEAN_GO
REGISTRATION_GATE  = BEFORE_DATA
GAPS_BLOQUEANTES   = ninguno
```

## Hilo A: Forum ahora

La recomendacion anterior de no publicar Forum se refina:

- publicar ahora solo el anuncio de intencion;
- no publicar todavia los hallazgos de glue/scope como veredicto;
- no crear audit link;
- refrescar snapshot API justo antes del post;
- ejecutar mechanical audit local en paralelo;
- enviar issue/recomendacion al autor solo cuando el paquete completo este listo.

Motivo:

```text
anunciar intencion != presentar hallazgos
```

Auditar en silencio durante semanas y aparecer con un veredicto completo seria
peor protocolo social que anunciar la intencion de auditoria desde el inicio.

## Hilo B: primer Lean data-only autorizado

Se autoriza crear el primer modulo Lean real solo con datos y hechos aritmeticos.

Permitido:

- constantes racionales;
- estructuras de datos del certificado;
- hechos enteros/racionales `norm_num`-ready;
- testigos de intervalos;
- `gamma > 3/7` como hecho aritmetico via `27^7 > 8 * 20^7`.

Prohibido:

- `Real`;
- `log`;
- teorema M0;
- semantica de `phi`;
- arboles inversos;
- lower-bound theorem;
- `sorry`;
- imports pesados tipo `import Mathlib` completo.

Nombre recomendado:

```text
KL2003K2CertificateData.lean
```

El header debe decir explicitamente:

```text
data + integer witnesses only; no KL2003 theorem claimed
```

## Registro KL2003

El gate queda reforzado:

```text
registrar KrasikovLagarias2003 antes del primer archivo .lean
```

Motivo:

si existe un `.lean` publico sobre KL2003 en el repo publico, el proyecto esta
de facto formalizando KL2003. El catalogo debe reflejarlo antes de publicar
ese codigo.

Payload debe declarar asistencia AI:

```text
ai_assisted = true
ai_models = Codex / GPT-5-based agents, Claude Fable reviewer
```

## Infraestructura requerida para primer `.lean`

Antes o junto al primer modulo:

- `lean-toolchain` con version concreta;
- script de axiom audit sobre el modulo;
- modulo con cero `sorry`;
- imports minimos.

## Clasificacion

```text
FORUM_INTENTION_POST_APPROVED
MECHANICAL_AUDIT_LOCAL_PARALLEL
DATA_ONLY_LEAN_APPROVED
REGISTER_KL2003_BEFORE_FIRST_LEAN
NO_M0_PROOF_CLAIMED
NO_GLOBAL_COLLATZ_CLAIM
```
