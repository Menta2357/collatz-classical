# KL2003_M0A_THREE_WAY_PI_STAR_VALIDATION_CUSTODY_v1

Fecha: 2026-07-07.

Estado: validacion three-way de la semantica computable M0a de `piStar` y
custodia del sanity historico usado en la reconstruccion M1. No se toca
D1/D2/D3.

## Clasificacion

```text
M0A_THREE_WAY_VALIDATION_ADDED
FORWARD_ORBIT_EQUALS_INVERSE_TREE_CONFIRMED
HISTORICAL_M1_SANITY_SCRIPT_CUSTODIED
ZERO_MISMATCHES_REPORTED
M0A_SEMANTICS_ANCHORED
NO_D1_D2_D3_YET
NO_M0_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Guardarrailes:

```text
NO_D1_D2_D3
NO_RETARDED_INDUCTION
NO_M0_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Artefactos

Script actualizado:

```text
scripts/kl2003_m0a_pi_star_cross_validation_v1.py
```

Script historico copiado:

```text
scripts/krasikov_m1_sanity.py
```

Outputs three-way:

```text
outputs/KL2003_M0A_PI_STAR_THREE_WAY_VALIDATION_v1/summary.json
outputs/KL2003_M0A_PI_STAR_THREE_WAY_VALIDATION_v1/three_way_grid.csv
outputs/KL2003_M0A_PI_STAR_THREE_WAY_VALIDATION_v1/mismatch.csv
outputs/KL2003_M0A_PI_STAR_THREE_WAY_VALIDATION_v1/hash_certificate.json
```

El script mantiene ademas el CSV legado:

```text
outputs/KL2003_M0A_PI_STAR_CROSS_VALIDATION_v1/pi_star_grid.csv
```

## Tres definiciones comparadas

1. Forward orbit reference:

```text
Para cada n en [1,x], iterar T forward.
Aceptar si alcanza a antes de salir de <= x.
Rechazar si sale de la ventana o repite estado antes del hit.
```

2. Lean-mirroring reference:

```text
Usa bounded_reaches_with_fuel(x+1, a, x, n).
Esta es la traduccion directa del modulo Lean M0a.
```

3. Inverse-tree BFS reference:

```text
Partir de a.
Explorar predecesores:
  2*z
  (2*z - 1)/3 cuando es entero valido.
Conservar solo p con 1 <= p <= x y T(p) = z.
Usar seen para evitar ciclos/repeticiones.
```

La comparacion es miembro a miembro, no solo por cardinalidad.

## Ejecucion M0a

Comando:

```text
python3 scripts/kl2003_m0a_pi_star_cross_validation_v1.py
```

Salida relevante:

```text
wrote outputs/KL2003_M0A_PI_STAR_CROSS_VALIDATION_v1/pi_star_grid.csv
wrote outputs/KL2003_M0A_PI_STAR_THREE_WAY_VALIDATION_v1/three_way_grid.csv
wrote outputs/KL2003_M0A_PI_STAR_THREE_WAY_VALIDATION_v1/summary.json
three_way_status=PASS
three_way_mismatch_count=0
piStarFinset 1 20 = [1, 2, 3, 4, 5, 6, 8, 10, 12, 13, 16, 20]
piStarFinset 2 20 = [1, 2, 3, 4, 5, 6, 8, 10, 12, 13, 16, 20]
piStarFinset 5 50 = [3, 5, 6, 7, 9, 10, 11, 12, 13, 14, 17, 18, 19, 20, 22, 24, 25, 26, 28, 29, 33, 34, 36, 38, 40, 44, 48, 50]
[(a, piStar a 100) for 1 <= a <= 30] = [(1, 69), (2, 69), (3, 6), (4, 67), (5, 59), (6, 5), (7, 16), (8, 66), (9, 4), (10, 52), (11, 30), (12, 4), (13, 38), (14, 15), (15, 3), (16, 6), (17, 35), (18, 3), (19, 8), (20, 51), (21, 3), (22, 13), (23, 7), (24, 3), (25, 5), (26, 37), (27, 2), (28, 10), (29, 10), (30, 2)]
```

## Summary JSON

```json
{
  "forward_orbit_equals_inverse_tree_bfs": true,
  "forward_orbit_equals_lean_mirroring": true,
  "grid_digest_sha256": "65bbece3f9a78844df4b97b874e844ee4fce8d6cd87246d864357b87db15f610",
  "grid_rows": 6030,
  "lean_mirroring_equals_inverse_tree_bfs": true,
  "max_a": 30,
  "max_x": 200,
  "mismatch_count": 0,
  "status": "PASS"
}
```

`mismatch.csv` tiene solo cabecera:

```text
1 outputs/KL2003_M0A_PI_STAR_THREE_WAY_VALIDATION_v1/mismatch.csv
```

`three_way_grid.csv` tiene cabecera + `30 * 201` filas:

```text
6031 outputs/KL2003_M0A_PI_STAR_THREE_WAY_VALIDATION_v1/three_way_grid.csv
```

## Hash certificate

```text
outputs/KL2003_M0A_PI_STAR_CROSS_VALIDATION_v1/pi_star_grid.csv:
f40961424096ecb8ad01f663c2dd6963b12410421c973a587e2e3ff9ca94e228

outputs/KL2003_M0A_PI_STAR_THREE_WAY_VALIDATION_v1/three_way_grid.csv:
ebbe7fb9c3e645eb0248d00f610afed2b82c7fd0e32f6af908ae89f88d95ea64

outputs/KL2003_M0A_PI_STAR_THREE_WAY_VALIDATION_v1/mismatch.csv:
e969db0d35afea17e8b329a7f76a4d9c60d6d757f3f4bd4881620d082fba16b3

outputs/KL2003_M0A_PI_STAR_THREE_WAY_VALIDATION_v1/summary.json:
179a9220db3d3837a15d410d2deec69313f002c7429fdc92ff000d076ba5e2fc

outputs/KL2003_M0A_PI_STAR_THREE_WAY_VALIDATION_v1/hash_certificate.json:
8f034dcd61075032f27ae1c2727da0d27f96c805bd7a311860be5b5dedceca87
```

## Custodia del sanity historico M1

Origen:

```text
/Users/MoiTam/Documents/Codex/2026-07-05/tarea-krasikov-m1-feasibility-reconstruction-v2/work/scripts/krasikov_m1_sanity.py
```

Destino:

```text
scripts/krasikov_m1_sanity.py
```

Comparacion byte-identical:

```text
cmp -s origin scripts/krasikov_m1_sanity.py
```

Resultado: exit code 0.

Hashes:

```text
6d0c87c506c07663a9759379ed4b6ad7ead60543343d536f804af7953f707b5f  origin/krasikov_m1_sanity.py
6d0c87c506c07663a9759379ed4b6ad7ead60543343d536f804af7953f707b5f  scripts/krasikov_m1_sanity.py
```

Ejecucion:

```text
python3 scripts/krasikov_m1_sanity.py
```

Salida:

```text
N=10000
checked inequalities=1653
residue 2 mod 9: checked=548, equalities=0
residue 5 mod 9: checked=554, equalities=0
residue 8 mod 9: checked=551, equalities=0
failures=0
```

## Limites

Esto ancla la semantica computable local de M0a y custodia un sanity historico.

No se prueba:

```text
D1/D2/D3
retarded induction
M0
M1
lower bound KL2003
global Collatz claim
```

## Resultado

```text
M0A_THREE_WAY_VALIDATION_ADDED = yes
FORWARD_ORBIT_EQUALS_INVERSE_TREE_CONFIRMED = yes
HISTORICAL_M1_SANITY_SCRIPT_CUSTODIED = yes
ZERO_MISMATCHES_REPORTED = yes
M0A_SEMANTICS_ANCHORED = yes
NO_D1_D2_D3_YET = yes
NO_M0_PROOF = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
