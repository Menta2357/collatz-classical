# KL2003_CONCRETE_PHI_REALIZATION_LEAN_v1

Fecha: 2026-07-12.

Estado: realizacion directa de `Phi : K2PhiSystem` desde `piStar` usando un
`iInf` condicional sobre clases de raices. Se cierran `zeroExtension` y
`BaseSegmentUnitLowerBound`. La prueba de `rowsV2` queda como el unico blocker
semantico posterior para construir `K2RetardedInductionInputsV2 concretePhi`.

## Clasificacion

```text
CONCRETE_PHI_DEFINED_DIRECTLY
CLASSROOTS_DEFINED
IINF_CLASS_ENVELOPE_DEFINED
ZERO_EXTENSION_PROVED
BASE_SEGMENT_UNIT_LOWER_BOUND_PROVED
WEIGHTED_BASE_FOR_CONCRETE_PHI_PROVED
ROWS_V2_SEAM_BLOCKER_ISOLATED
NO_INTERFACE_WRAPPER
NO_DUPLICATE_K2_INPUTS_V2
K2_INPUTS_V2_NOT_PROVED
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Guardarrailes:

```text
NO_INTERFACE_WRAPPER
NO_SECOND_HOOK_LAYER
NO_K2_INPUTS_V2_PROOF
NO_ROWS_V2_SEAM_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ
NO_COLLATZ_CLOSURE
NO_ALMOST_ALL
```

## Archivos

Reemplazado:

```text
CollatzClassical/KL2003/KL2003ConcretePhiRealization.lean
CollatzClassical/KL2003/KL2003ConcretePhiRealizationAxiomAudit.lean
```

Creado:

```text
docs/KL2003_CONCRETE_PHI_REALIZATION_LEAN_v1.md
```

La nota anterior de interfaz fue retirada para evitar una segunda capa de
wrappers.

## Definiciones

Se definio la clase de raices:

```lean
abbrev ClassRoots (m : Nat) :=
  {a : Nat // a % 9 = m ∧ NotInCycle a ∧ 1 <= a}
```

La ventana concreta inicial es:

```lean
concreteWindow y a := Nat.ceil ((2 : Real) ^ y * (a : Real))
```

El componente concreto usa zero-extension y un `iInf` condicional:

```lean
concretePhiComponent m y =
  if y < 0 then 0
  else if h : Nonempty (ClassRoots m) then
    iInf (fun a : ClassRoots m =>
      (piStar a.1 (concreteWindow y a.1) : Real))
  else
    1
```

El caso vacio devuelve `1` para que la cota base unitaria no dependa de una
prueba de no-vacuidad de clases con `NotInCycle`. Esa no-vacuidad no se usa en
M0C y no debe convertirse aqui en claim global.

Finalmente:

```lean
concretePhi : K2PhiSystem
```

con componentes:

```text
phi22 = concretePhiComponent 2
phi25 = concretePhiComponent 5
phi28 = concretePhiComponent 8
```

## Lemas Cerrados

Root/window para la base:

```lean
one_le_two_rpow_of_nonneg :
  0 <= y -> 1 <= (2 : Real)^y

classRoot_le_concreteWindow :
  0 <= y -> a : ClassRoots m -> a.1 <= concreteWindow y a.1
```

Base unitaria por componente:

```lean
one_le_concretePhiComponent_of_nonneg :
  0 <= y -> 1 <= concretePhiComponent m y
```

Usa:

```lean
root_count_unit_lower_bound_for_window :
  1 <= a -> a <= x -> 1 <= piStar a x
```

y `le_ciInf` sobre el subtipo no vacio.

Deudas faciles cerradas:

```lean
concretePhi_zeroExtension :
  K2PhiZeroExtension concretePhi

concretePhi_baseSegmentUnitLowerBound :
  BaseSegmentUnitLowerBound concretePhi

concretePhi_weightedBase :
  BaseSegmentWeightedLowerBound concretePhi
```

## Blocker Aislado

Queda definido solo como obligacion:

```lean
def concretePhiRowsV2SeamObligation : Prop :=
  I2ELAbstractRowsV2 concretePhi
```

No se prueba en esta pasada. Esta es la deuda semantica posterior:

```text
ROWS_V2_SEAM_PROOF_OPEN
```

## No Cerrado

No se prueba:

```text
K2RetardedInductionInputsV2 concretePhi
I2ELAbstractRowsV2 concretePhi
seam Nat -> rowsV2
M1 theorem
global Collatz claim
```

No se crean:

```text
ConcretePhiRealization wrapper
segunda capa de hooks
duplicado de K2RetardedInductionInputsV2
```

## Verificacion

Ejecutado:

```text
lake build CollatzClassical.KL2003.KL2003ConcretePhiRealization
lake env lean CollatzClassical/KL2003/KL2003ConcretePhiRealizationAxiomAudit.lean
```

Resultado:

```text
LEAN_BUILD_PASS = yes
AXIOM_AUDIT_PASS = yes
```

El audit reporta solo dependencias habituales de Mathlib/Real:

```text
propext
Classical.choice
Quot.sound
```
