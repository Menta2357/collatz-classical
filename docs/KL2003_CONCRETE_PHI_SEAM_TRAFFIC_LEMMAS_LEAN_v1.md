# KL2003_CONCRETE_PHI_SEAM_TRAFFIC_LEMMAS_LEAN_v1

Fecha: 2026-07-13.

Estado: lemas de trafico del seam Lean creados y compilados en
`KL2003ConcretePhiRealization.lean`. No se inicia `rowsV2`, no se abre row22
parity lift, no se abre el analisis anidado row28, y no se declara ningun M1.

## Clasificacion

```text
PISTAR_WINDOW_MONOTONICITY_PROVED
CONCRETEPHI_MEMBER_WRAPPER_PROVED
CONCRETEPHI_CLASSROOT_WRAPPER_PROVED
CONCRETEPHI_CIINF_LOWER_WRAPPER_PROVED
CONCRETE_WINDOW_MONOTONICITY_PROVED
CONCRETEPHI_MONOTONICITY_PROVED
ROWS_V2_SEAM_NOT_STARTED
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Nota de ubicacion:

```text
PISTAR_WINDOW_MONOTONICITY_PLACED_IN_M0A = no
```

`piStar_window_mono` se coloco en `KL2003ConcretePhiRealization.lean`, no en
M0A, porque la prueba reutiliza el puente Prop ya cerrado en
`KL2003M0BReachabilityAPI.lean`: `mem_piStarFinset_reachesWithin_iff` y
`reachesWithin_window_mono`. Esto evita duplicar una segunda prueba de fuel en
M0A.

Guardarrailes:

```text
NO_ROWS_V2_THIS_PASS
NO_ROW22_PARITY_LIFT_THIS_PASS
NO_ROW28_NESTED_THIS_PASS
NO_K2_INPUTS_V2_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ
NO_COLLATZ_CLOSURE
NO_ALMOST_ALL
```

## Lemas Probados

Monotonicidad de `piStar`:

```lean
piStarFinset_subset_window :
  x1 <= x2 -> piStarFinset a x1 ⊆ piStarFinset a x2

piStar_window_mono :
  x1 <= x2 -> piStar a x1 <= piStar a x2
```

Monotonicidad de ventana:

```lean
concreteWindow_mono_y :
  y1 <= y2 -> concreteWindow y1 a <= concreteWindow y2 a
```

Wrappers superiores de `concretePhiComponent`:

```lean
concretePhiComponent_le_piStar_of_classRoot :
  0 <= y ->
  a : ClassRoots m ->
  concretePhiComponent m y <=
    (piStar a.1 (concreteWindow y a.1) : Real)

concretePhiComponent_le_of_member :
  0 <= y ->
  a % 9 = m ->
  NotInCycle a ->
  1 <= a ->
  concretePhiComponent m y <=
    (piStar a (concreteWindow y a) : Real)
```

Wrapper inferior de `ciInf`:

```lean
le_concretePhiComponent_of_forall :
  [Nonempty (ClassRoots m)] ->
  0 <= y ->
  (forall a : ClassRoots m,
    b <= (piStar a.1 (concreteWindow y a.1) : Real)) ->
  b <= concretePhiComponent m y
```

La hipotesis `[Nonempty (ClassRoots m)]` es necesaria para el statement
generico. Sin no-vacuidad, la forma sin hipotesis seria falsa para clases
vacias: el cuantificador sobre `ClassRoots m` no daria informacion sobre `b`,
mientras que `concretePhiComponent m y` cae en la rama documental `1`.

No-negatividad y cota inferior del rango:

```lean
concretePhiComponent_nonneg :
  0 <= concretePhiComponent m y

concretePhiComponent_range_bddBelow :
  BddBelow
    (Set.range
      (fun a : ClassRoots m =>
        (piStar a.1 (concreteWindow y a.1) : Real)))
```

Monotonicidad compuesta:

```lean
concretePhiComponent_mono_y :
  y1 <= y2 ->
  concretePhiComponent m y1 <= concretePhiComponent m y2
```

## Prueba De Monotonicidad

La prueba de `concretePhiComponent_mono_y` separa:

```text
y1 < 0:
  concretePhiComponent m y1 = 0
  concretePhiComponent_nonneg descarga el lado derecho.

0 <= y1:
  entonces 0 <= y2.
  Si ClassRoots m no es vacio, se compara el mismo indice a en ambos iInf:
    concreteWindow_mono_y
    piStar_window_mono
    ciInf_le + le_ciInf
  Si ClassRoots m es vacio, ambas ramas valen 1.
```

Esto cierra los tres posibles blockers:

```text
BLOCKED_ON_CONCRETE_WINDOW_MONOTONICITY = no
BLOCKED_ON_CIINF_MONOTONICITY = no
BLOCKED_ON_ZERO_EXTENSION_CASE_SPLIT = no
```

## Auditoria

Se actualizo:

```text
CollatzClassical/KL2003/KL2003ConcretePhiRealizationAxiomAudit.lean
```

con `#print axioms` para todos los lemas nuevos.

No se toco:

```text
CollatzClassical/KL2003/KL2003M0APiStarSemantics.lean
CollatzClassical/KL2003/KL2003M0APiStarSemanticsAxiomAudit.lean
```

## Verificacion

Comandos ejecutados:

```text
lake build CollatzClassical.KL2003.KL2003ConcretePhiRealization
lake env lean CollatzClassical/KL2003/KL2003ConcretePhiRealizationAxiomAudit.lean
```

Resultado:

```text
lake build PASS
axiom audit PASS
```

## Alcance

No se prueba todavia:

```text
I2ELAbstractRowsV2 concretePhi
row22 parity-lift seam
row28 nested case analysis
K2RetardedInductionInputsV2 concretePhi
M1 theorem
global Collatz claim
```

Estos lemas quedan como trafico reutilizable para la siguiente fase del seam.
