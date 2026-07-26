# F3 R3 v6 — auditoría adversarial post-escritura del intento 02

Fecha: `2026-07-26`

## Veredicto

```text
VERDICT = PASS
P1_RESIDUAL = 0
P2_RESIDUAL = 0
CLASSIFICATION = PASS_ATOMIC_ADOPTION_TEXTUAL_7_OF_7
AUDIT_MODE = INDEPENDENT_READ_ONLY
```

El veredicto cubre únicamente la transacción textual de siete targets. No
certifica elaboración Lean, build Lake, ejecución BFS, ejecución de generador
ni ningún teorema matemático.

## Identidad auditada

```text
ATTEMPT_ID = 02
EXTERNAL_BRANCH = codex/hilo2-f3-r3-reverse-first-hit-v1
EXTERNAL_HEAD = 8765d7083906e7b3e3b03951da6331fcf1427e1b
EXECUTOR_SHA256 = e5074646beb56292fee62cd51589be92aad2113f9f712519619178997fbff18b
EXECUTION_FREEZE_SHA256 = 19bc647b196e1860c711791ee1934da180021b48f6dbc7debd2919153b0eb5ec
HANDOFF_SHA256 = 79929087398c8b56b31f5b96a4c415f1658942f052d625c2c64430fcb6359ba7
PATCH_SHA256 = 4f278d3db6bc37572612c412947e9ae410b94ee928271298c419dd6953d592a9
RECEIPT_MANIFEST_SHA256 = e089cf5c702b42daac6d0415b8a2e82a1a38d899e5b4cee5ffa114b4d9b4d35f
```

## Comprobaciones

- Manifiesto terminal íntegro: `46/46` entradas coinciden en hash, bytes y
  líneas; sus `27` documentos JSON son válidos. El manifiesto no se incluye a
  sí mismo por diseño.
- Freeze de ejecución: `15/15` artefactos exactos. Preflight enlazado:
  `16/16` artefactos exactos, con manifiesto
  `31d633874ff86c87d597a486133d8862148e535715693c5842db58e59e3c82df`.
- CAS prewrite: las capturas initial/final son byte-idénticas para status,
  targets, ignores, parents, huella no-target, contexto Git, dry-run y
  `git diff --check`. Los censos son capturas independientes y ambos tienen
  cero líneas sin parsear y cero coincidencias activas.
- Mutación: existe un único call-site de `git apply`; los otros tres usos son
  `--check`. El apply fue invocado, retornó, terminó con código `0` y no produjo
  salida ni error.
- Postimágenes: `7/7` archivos regulares, no symlink, con hashes y líneas
  exactos; pins `14/14`; ausencias protegidas `10/10 + 7/7 + 1/1`.
- Status: `499 -> 503`, sin eliminaciones ni duplicados; el delta consta solo
  de los cuatro targets antes ausentes. SHA post:
  `efc75b83fffdd494c77782a8b6e82ad9b2d590114bdd0ab66db4a4b02ff86e33`.
- No-target: `1748` entradas, SHA
  `59d37053198c0a82d20aec2331c13762e8041d8fbb9692b799a580adc4c87f83`,
  idéntico en initial/final/post y en el estado vivo auditado.
- Parent estructural: exactamente uno,
  `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/templates`, pasó de ausente a
  directorio real.
- Reverse check: exit `0`, salida vacía. Forward check tras la adopción: exit
  `1` limpio, stderr SHA
  `6dfe57df997e652bb655e87349e0fd6373160911b5158d6cc29d21e3a36891cd`.
  `git diff --check`: exit `0`, salida vacía.
- Branch y HEAD vivos permanecieron idénticos a los fijados; locks Git: cero.

La evidencia `unexpected_custody_paths_written = 0` se apoya en el target-set
exacto 7/7, el delta de status exacto y la huella no-target estable. El censo
nominal de procesos es defensa adicional de alcance declarado, no una prueba
universal de ausencia de escritores.

## NO-claims

```text
LEAN_EXECUTED = NO
LAKE_EXECUTED = NO
BFS_EXECUTED = NO
GENERATOR_EXECUTED = NO
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
```
