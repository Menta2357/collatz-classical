# KL2003_CONCRETE_PHI_ROWS_V2_CHAIN_EMPIRICAL_v1

Fecha: 2026-07-13.

Estado: test empirico ejecutado para validar las cadenas discretas row22,
row25 y row28 previstas por el scoping de `I2ELAbstractRowsV2 concretePhi`.
No se abre Lean, no se prueba `K2RetardedInductionInputsV2 concretePhi`, y no
se declara ningun M1.

## Clasificacion

```text
ROWS_V2_CHAIN_EMPIRICAL_COMPLETED
ROW22_PARITY_LIFT_EMPIRICALLY_VALIDATED
ROW25_RETARDED_CHAIN_EMPIRICALLY_VALIDATED
ROW28_CHAIN_CASES_EMPIRICALLY_VALIDATED
SEAM_LEAN_READY
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Guardarrailes:

```text
NO_LEAN
NO_K2_INPUTS_V2_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
NO_COLLATZ_CLOSURE
NO_ALMOST_ALL
```

## Artefactos

Script:

```text
scripts/kl2003_concrete_phi_rows_v2_chain_empirical_v1.py
```

Outputs:

```text
outputs/KL2003_CONCRETE_PHI_ROWS_V2_CHAIN_EMPIRICAL_v1/summary.json
outputs/KL2003_CONCRETE_PHI_ROWS_V2_CHAIN_EMPIRICAL_v1/grid.csv
outputs/KL2003_CONCRETE_PHI_ROWS_V2_CHAIN_EMPIRICAL_v1/mismatch.csv
outputs/KL2003_CONCRETE_PHI_ROWS_V2_CHAIN_EMPIRICAL_v1/row22_parity_lift_cases.csv
outputs/KL2003_CONCRETE_PHI_ROWS_V2_CHAIN_EMPIRICAL_v1/manifest_sha256.csv
```

Manifest principal:

```text
script sha256      = f01f525939e116ae20ae6201404135a5cc1ecb6ed7dc17c630e1e6ba19395c8d
summary sha256     = 0e3b843f1e80f54f3dd45903f9da484cffd75df19294a2f64250368818ed5e21
grid sha256        = 2dc2812c19c8722fd9b65cbbe1e86a8a051bc90f963c5eaabf70cc157cebfeb1
mismatch sha256    = 9b0ea781637ede24b6ca29db877045677b47f91f6d6ee0e1d481f8ed5c997de7
row22 cases sha256 = 286946a78fd34ecce13e927c50aef1d2d043d96420966fcb3022a8f6a873b1c3
```

## Grid

Rango ejecutado:

```text
a in [1, 500]
a % 9 in {2, 5, 8}
x in [a, min(10000, 32*a)]
```

Filas:

```text
total_rows = 1109082
grid.csv lines = 1109083 including header
mismatch.csv lines = 1 header only
row22_parity_lift_cases.csv lines = 57 including header
```

El script usa la semantica M0A por arbol inverso acotado con `path_max`: un
nodo cuenta para `piStar(root,x)` si el maximo de la ruta inversa desde `root`
hasta ese nodo es `<= x`.

## Resultado Global

Resumen:

```text
status = PASS
mismatch_count = 0
known_cycle_skipped_rows = 63
grid_digest_sha256 = 0f2754642beb46044d6caf5c874dac7401f5fdad44391e01b500c8c0f3231106
```

Las 63 filas saltadas corresponden al root `a = 2`, que pasa las identidades
sintacticas de cadena pero queda fuera de las hipotesis formales por
`NotInCycle`.

Conteos por fila:

```text
row22 rows = 369684
row25 rows = 372876
row28 rows = 366522
```

Core Nat:

```text
row22 core_ok = 369621
row25 core_ok = 372876
row28 core_ok = 366522
core_fail_counts = {}
```

Rutas:

```text
row22 route_ok = 369684
row25 route_ok = 372876
row28 route_ok = 366522
route_fail_counts = {}
```

## Row25

Cadena validada:

```text
4a -> 2a -> a
```

Para `a % 9 = 5`, el test confirma:

```text
(4*a) % 9 = 2
xRet = x
piStar(4a, xRet) <= piStar(a, x)
```

Resultado:

```text
retarded_exact_window_failures = 0
single_branch_failures = 0
advanced_branch_consumed = false
```

Esto preserva la correccion seam-v2: row25/D2 es single-branch y no paga
redondeo advanced.

## Row22

Cadena validada:

```text
c = (2a - 1)/3
2c -> c -> a
```

El test confirma para cada raiz `a % 9 = 2`:

```text
c % 3 = 1
2c % 9 in {2, 5, 8}
T(2c) = c
T(c) = a
```

Tambien confirma la contabilidad de shift:

```text
3*c/(2*a) = 3*(2c)/(4*a) = (2*a - 1)/(2*a)
```

Es decir, el advanced directo `alpha - 1` seguido del salto par `-1` da el
shift consumido por row22:

```text
alpha - 2
```

Resultado:

```text
row22 parity lift root cases = 56
parity_lift_ok_roots = 56
parity_lift_fail_roots = 0
lift_count_le_direct_child_count_failures = 0
```

Reparto de `2c % 9` en el grid:

```text
2 mod 9: 123156
5 mod 9: 126441
8 mod 9: 120087
```

## Row28

Cadena validada:

```text
c = (2a - 1)/3
c -> a
```

Para `a = 9t + 8`, el test confirma:

```text
c = 6t + 5
t % 3 = 0 -> c % 9 = 5
t % 3 = 1 -> c % 9 = 2
t % 3 = 2 -> c % 9 = 8
```

Reparto de clases del child en el grid:

```text
c % 9 = 2: 119085
c % 9 = 5: 125346
c % 9 = 8: 122091
```

Mapeo hacia `row28EL`:

```text
phi22_outer_arm                  = 119085
M1V2_nested_class25_elimination  = 125346
phi28_plus_M1V2_outer_arm        = 122091
```

No hay fallos de ruta ni de desigualdad Nat para row28 en el grid.

## Verificacion Ejecutada

Comandos:

```text
python3 -m py_compile scripts/kl2003_concrete_phi_rows_v2_chain_empirical_v1.py
python3 scripts/kl2003_concrete_phi_rows_v2_chain_empirical_v1.py
```

Resultado:

```text
py_compile PASS
script PASS
mismatch_count = 0
```

## Alcance

Este test deja el seam listo para atacar en Lean a nivel de plan empirico:

```text
ROW22_PARITY_LIFT_EMPIRICALLY_VALIDATED = yes
ROW25_RETARDED_CHAIN_EMPIRICALLY_VALIDATED = yes
ROW28_CHAIN_CASES_EMPIRICALLY_VALIDATED = yes
SEAM_LEAN_READY = yes
```

Pero siguen abiertas las obligaciones formales:

```text
concretePhi monotonicity
piStar window monotonicity
ciInf transfer lemmas
NotInCycle closure for transformed roots
pad_absorbs_floor
I2ELAbstractRowsV2 concretePhi
K2RetardedInductionInputsV2 concretePhi
```

No se declara M1, no se declara cierre global de Collatz y no se usa este
resultado como prueba formal del seam.
