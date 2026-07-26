# F3 R3 v6 — auditoría semántica post-escritura del intento 02

Fecha: `2026-07-26`

## Veredicto

```text
VERDICT = PASS
P1_RESIDUAL = 0
P2_RESIDUAL = 0
CLASSIFICATION = PASS_ATOMIC_ADOPTION_TEXTUAL_7_OF_7
AUDIT_MODE = INDEPENDENT_READ_ONLY
```

La clasificación significa adopción textual/source-only. No implica
elaboración Lean, build Lake, ejecución BFS/generador, autoridad de ejecución
posterior ni teorema.

## Evidencia semántica de la transacción

```text
RECEIPT_MANIFEST_SHA256 = e089cf5c702b42daac6d0415b8a2e82a1a38d899e5b4cee5ffa114b4d9b4d35f
PREWRITE_STATUS_RECORDS = 499
PREWRITE_STATUS_SHA256 = 00a7fb9879dc1232bb4da91bf11fe7070268f4e79b2e27480bbbb958199ffd38
POSTWRITE_STATUS_RECORDS = 503
POSTWRITE_STATUS_SHA256 = efc75b83fffdd494c77782a8b6e82ad9b2d590114bdd0ab66db4a4b02ff86e33
NON_TARGET_COUNT = 1748
NON_TARGET_SHA256 = 59d37053198c0a82d20aec2331c13762e8041d8fbb9692b799a580adc4c87f83
```

- El manifiesto del recibo fue verificado `46/46`.
- `apply_invoked`, `apply_returned` y `apply_success` son verdaderos; exit
  `0`, sin excepción y con logs vacíos.
- Las siete postimágenes actuales coinciden `7/7` en SHA-256 y líneas con el
  manifiesto de staging.
- El cambio `499 -> 503` es exactamente la aparición de los cuatro targets
  que estaban ausentes; el estado vivo es byte-idéntico al postwrite.
- La huella de las `1748` entradas no-target coincide en initial, final,
  postwrite y en el estado vivo.
- Los cinco artefactos G11 legítimos preexistentes conservan exactamente tipo,
  modo, bytes y SHA-256 en todas las capturas.
- El directorio `templates` pasó de ausente a directorio real, nunca symlink;
  fue el único parent estructural creado.
- Freeze `19bc647b...`, executor `e5074646...`, patch `4f278d3d...` y handoff
  `79929087...` son exactos; los rechecks pasan y los `15/15` artefactos del
  freeze coinciden.
- Pins `14/14` y ausencias protegidas `10/10 + 7/7 + 1/1` siguen intactos.
- La rama y el HEAD permanecen en
  `codex/hilo2-f3-r3-reverse-first-hit-v1` y
  `8765d7083906e7b3e3b03951da6331fcf1427e1b`.

## Separación de alcance

```text
TEXTUAL_ADOPTION = PASS_7_OF_7
LEAN_VALIDATION = NOT_RUN
LAKE_BUILD = NOT_RUN
REVERSE_BFS = NOT_RUN
GENERATOR = NOT_RUN
EXECUTION_AUTHORITY_AFTER_TRANSACTION = NONE
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
```
