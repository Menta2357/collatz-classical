# KL2003_M0A_PI_STAR_SEMANTICS_LEAN_AND_CROSS_VALIDATION_v1

Fecha: 2026-07-07.

Estado: implementacion computable M0a de `piStar` y validacion cruzada
inicial contra una referencia Python. No se toca D1/D2/D3.

## Clasificacion

```text
M0A_PI_STAR_SEMANTICS_LEAN_CREATED
T_FUNCTION_DEFINED
ORBIT_WITH_FUEL_DEFINED
BOUNDED_REACHES_DEFINED
PISTAR_FINSET_DEFINED
PISTAR_BASIC_LEMMAS_PROVED
PYTHON_REFERENCE_CREATED
CROSS_VALIDATION_GRID_CREATED
LEAN_BUILD_PASS
AXIOM_AUDIT_PASS
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
NO_NATIVE_DECIDE
NO_TRUSTCOMPILER
```

## Artefactos creados

```text
CollatzClassical/KL2003/KL2003M0APiStarSemantics.lean
CollatzClassical/KL2003/KL2003M0APiStarSemanticsAxiomAudit.lean
CollatzClassical/KL2003/KL2003M0APiStarSemanticsExamples.lean
scripts/kl2003_m0a_pi_star_cross_validation_v1.py
outputs/KL2003_M0A_PI_STAR_CROSS_VALIDATION_v1/pi_star_grid.csv
```

## Lean semantics

El modulo principal define:

```lean
def T (n : Nat) : Nat
def orbitWithFuel : Nat -> Nat -> List Nat
def boundedReachesWithFuel : Nat -> Nat -> Nat -> Nat -> Bool
def boundedReaches (a x n : Nat) : Bool
def piStarMember (a x n : Nat) : Bool
def piStarFinset (a x : Nat) : Finset Nat
def piStarList (a x : Nat) : List Nat
def piStar (a x : Nat) : Nat
```

`piStarFinset` es la definicion primaria:

```lean
(Finset.range (x + 1)).filter
  (fun n => 1 <= n ∧ boundedReaches a x n = true)
```

`piStarList` se agrego como enumerador computable para `#eval`, porque
`Finset.toList` es `noncomputable` en esta configuracion. No reemplaza la
definicion primaria por `Finset`.

Lemas basicos probados:

```lean
T_zero
orbitWithFuel_zero
mem_piStarFinset_iff
mem_piStarList_iff
zero_not_mem_piStarFinset
piStar_zero_x
```

## Build y audit

Comando:

```text
lake build CollatzClassical.KL2003.KL2003M0APiStarSemantics
```

Resultado:

```text
Build completed successfully.
```

Comando:

```text
lake env lean CollatzClassical/KL2003/KL2003M0APiStarSemanticsAxiomAudit.lean
```

Salida relevante:

```text
'CollatzClassical.KL2003.T_zero' depends on axioms: [propext]
'CollatzClassical.KL2003.orbitWithFuel_zero' does not depend on any axioms
'CollatzClassical.KL2003.mem_piStarFinset_iff' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.mem_piStarList_iff' depends on axioms: [propext, Quot.sound]
'CollatzClassical.KL2003.zero_not_mem_piStarFinset' depends on axioms: [propext, Classical.choice, Quot.sound]
'CollatzClassical.KL2003.piStar_zero_x' depends on axioms: [propext, Classical.choice, Quot.sound]
```

No aparece `Lean.trustCompiler` ni `Lean.ofReduceBool` en el audit de estos
lemas. No se usa `native_decide`.

## Ejemplos Lean

Comando:

```text
lake env lean CollatzClassical/KL2003/KL2003M0APiStarSemanticsExamples.lean
```

Salida:

```text
[1, 2, 3, 4, 5, 6, 8, 10, 12, 13, 16, 20]
[1, 2, 3, 4, 5, 6, 8, 10, 12, 13, 16, 20]
[3, 5, 6, 7, 9, 10, 11, 12, 13, 14, 17, 18, 19, 20, 22, 24, 25, 26, 28, 29, 33, 34, 36, 38, 40, 44, 48, 50]
[(1, 69), (2, 69), (3, 6), (4, 67), (5, 59), (6, 5), (7, 16), (8, 66), (9, 4), (10, 52), (11, 30), (12, 4), (13, 38),
  (14, 15), (15, 3), (16, 6), (17, 35), (18, 3), (19, 8), (20, 51), (21, 3), (22, 13), (23, 7), (24, 3), (25, 5),
  (26, 37), (27, 2), (28, 10), (29, 10), (30, 2)]
```

## Referencia Python

Comando:

```text
python3 scripts/kl2003_m0a_pi_star_cross_validation_v1.py
```

Salida:

```text
wrote outputs/KL2003_M0A_PI_STAR_CROSS_VALIDATION_v1/pi_star_grid.csv
piStarFinset 1 20 = [1, 2, 3, 4, 5, 6, 8, 10, 12, 13, 16, 20]
piStarFinset 2 20 = [1, 2, 3, 4, 5, 6, 8, 10, 12, 13, 16, 20]
piStarFinset 5 50 = [3, 5, 6, 7, 9, 10, 11, 12, 13, 14, 17, 18, 19, 20, 22, 24, 25, 26, 28, 29, 33, 34, 36, 38, 40, 44, 48, 50]
[(a, piStar a 100) for 1 <= a <= 30] = [(1, 69), (2, 69), (3, 6), (4, 67), (5, 59), (6, 5), (7, 16), (8, 66), (9, 4), (10, 52), (11, 30), (12, 4), (13, 38), (14, 15), (15, 3), (16, 6), (17, 35), (18, 3), (19, 8), (20, 51), (21, 3), (22, 13), (23, 7), (24, 3), (25, 5), (26, 37), (27, 2), (28, 10), (29, 10), (30, 2)]
```

Los tres listados de miembros y la lista de conteos `1 <= a <= 30` coinciden
con los `#eval` Lean.

## CSV generado

Archivo:

```text
outputs/KL2003_M0A_PI_STAR_CROSS_VALIDATION_v1/pi_star_grid.csv
```

Columnas:

```text
a
x
count
members_space_separated
members_sha256
fuel
```

Rango:

```text
1 <= a <= 30
0 <= x <= 200
```

Conteo de lineas:

```text
6031
```

Esto corresponde a cabecera + `30 * 201` filas.

Primeras filas:

```text
a,x,count,members_space_separated,members_sha256,fuel
1,0,0,,e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855,1
1,1,1,1,6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b,2
1,2,2,1 2,f71998fe363b9c29116c80b5eecf33a2fedca3b6159724384485804b71651029,3
```

Ultimas filas:

```text
30,195,3,30 60 120,08d19a15c4efd8aa3d265e7f297a89757c252e876ba16b92ed0c9b13d2c783db,196
30,196,3,30 60 120,08d19a15c4efd8aa3d265e7f297a89757c252e876ba16b92ed0c9b13d2c783db,197
30,197,3,30 60 120,08d19a15c4efd8aa3d265e7f297a89757c252e876ba16b92ed0c9b13d2c783db,198
30,198,3,30 60 120,08d19a15c4efd8aa3d265e7f297a89757c252e876ba16b92ed0c9b13d2c783db,199
30,199,3,30 60 120,08d19a15c4efd8aa3d265e7f297a89757c252e876ba16b92ed0c9b13d2c783db,200
30,200,3,30 60 120,08d19a15c4efd8aa3d265e7f297a89757c252e876ba16b92ed0c9b13d2c783db,201
```

Hashes:

```text
f40961424096ecb8ad01f663c2dd6963b12410421c973a587e2e3ff9ca94e228  outputs/KL2003_M0A_PI_STAR_CROSS_VALIDATION_v1/pi_star_grid.csv
40dc1fa972c7222316fbf97441fbf7c38ea17976c796875574ab13eab4d44457  CollatzClassical/KL2003/KL2003M0APiStarSemantics.lean
29db318d29c752385bad0d42e8f37f044383881d6af7029815a259dbbacb0134  scripts/kl2003_m0a_pi_star_cross_validation_v1.py
```

## Limites de esta fase

Esto solo fija y valida la semantica computable local de `piStar`.

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
M0A_PI_STAR_SEMANTICS_LEAN_CREATED = yes
T_FUNCTION_DEFINED = yes
ORBIT_WITH_FUEL_DEFINED = yes
BOUNDED_REACHES_DEFINED = yes
PISTAR_FINSET_DEFINED = yes
PISTAR_BASIC_LEMMAS_PROVED = yes
PYTHON_REFERENCE_CREATED = yes
CROSS_VALIDATION_GRID_CREATED = yes
LEAN_BUILD_PASS = yes
AXIOM_AUDIT_PASS = yes
NO_D1_D2_D3_YET = yes
NO_M0_PROOF = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
