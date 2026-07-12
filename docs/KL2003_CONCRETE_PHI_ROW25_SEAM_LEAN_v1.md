# KL2003_CONCRETE_PHI_ROW25_SEAM_LEAN_v1

Fecha: 2026-07-13.

Estado: fila row25 del seam concreto probada en Lean como cadena
single-branch. No se abre row22 parity lift, no se abre row28 nested case
analysis, no se construye `K2RetardedInductionInputsV2 concretePhi`, y no se
declara ningun M1.

## Clasificacion

```text
ROW25_SEAM_SINGLE_BRANCH_PROVED
ROW25_RETARDED_WINDOW_TRANSFER_PROVED
ROW25_CLASS_TRANSFER_PROVED
ROWS_V2_FULL_SEAM_NOT_YET_PROVED
ROW22_PARITY_LIFT_NOT_STARTED
ROW28_NESTED_CASE_ANALYSIS_NOT_STARTED
K2_INPUTS_V2_NOT_YET_PROVED
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Guardarrailes:

```text
NO_ROWS_V2_FULL_SEAM
NO_ROW22_PARITY_LIFT_THIS_PASS
NO_ROW28_NESTED_THIS_PASS
NO_K2_INPUTS_V2_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ
NO_COLLATZ_CLOSURE
NO_ALMOST_ALL
```

## Modulo

Se actualizo:

```text
CollatzClassical/KL2003/KL2003ConcretePhiRealization.lean
CollatzClassical/KL2003/KL2003ConcretePhiRealizationAxiomAudit.lean
```

Se anadio el import:

```lean
import CollatzClassical.KL2003.KL2003M0BD123CoreInstantiations
```

para consumir `d2_single_branch_core_instantiation` como fuente combinatoria
principal.

## Lemas Auxiliares

No-ciclo local para clase 5:

```lean
T_le_two_of_le_two
iterate_two_le_two
notInCycle_five
classRoots_five_nonempty
```

El unico cierre de ciclo transformado probado aqui es local:

```lean
notInCycle_four_mul :
  NotInCycle a -> NotInCycle (4 * a)
```

Esto no es una afirmacion global de Collatz. Solo dice que si `a` no vuelve a
si mismo bajo `T`, entonces tampoco vuelve `4a`, porque `T^[2] (4a) = a`.

Transfer de clase row25:

```lean
row25_retarded_residue_mod_9 :
  a % 9 = 5 -> (4 * a) % 9 = 2

row25_retarded_classRoot :
  ClassRoots 5 -> ClassRoots 2
```

La aritmetica del child avanzado solo se usa para instanciar el core D2,
aunque la rama advanced no se consuma en la fila EL:

```lean
row25_advanced_child_arith :
  a % 9 = 5 ->
  3 * (6 * (a / 9) + 3) + 1 = 2 * a
```

## Ventana

La transferencia retardada exacta queda probada por:

```lean
row25_concreteWindow_retarded :
  concreteWindow (y - 2) (4 * a) = concreteWindow y a
```

La prueba usa:

```text
2^(y-2) * (4a) = 2^y * a
```

y por tanto vale para la `concreteWindow` actual basada en `Nat.ceil`.

## Cota Nat

La cota puntual de conteos es:

```lean
row25_piStar_retarded_le_target :
  0 <= y ->
  a : ClassRoots 5 ->
  (piStar (4 * a.1) (concreteWindow (y - 2) (4 * a.1)) : Real)
    <=
  (piStar a.1 (concreteWindow y a.1) : Real)
```

Esta cota consume:

```lean
d2_single_branch_core_instantiation
```

con:

```text
xRet = concreteWindow y a
x    = concreteWindow y a
c    = 6 * (a / 9) + 3
```

No hay pad advanced en row25.

## Seam Row25

El statement cerrado es:

```lean
concretePhi_row25_seam :
  forall y, 14 <= y ->
    concretePhi.phi22 (y - 2) <= concretePhi.phi25 y
```

La prueba usa:

```text
le_concretePhiComponent_of_forall
concretePhiComponent_le_piStar_of_classRoot
row25_retarded_classRoot
row25_piStar_retarded_le_target
```

Esto coincide exactamente con el campo row25 de `I2ELAbstractRowsV2`, pero no
ensambla el record completo porque row22 y row28 siguen pendientes.

## Auditoria

Se extendio:

```text
CollatzClassical/KL2003/KL2003ConcretePhiRealizationAxiomAudit.lean
```

con `#print axioms` para:

```text
T_le_two_of_le_two
iterate_two_le_two
notInCycle_five
classRoots_five_nonempty
notInCycle_four_mul
row25_retarded_residue_mod_9
row25_retarded_classRoot
row25_advanced_child_arith
row25_concreteWindow_retarded
row25_piStar_retarded_le_target
concretePhi_row25_seam
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

Barrido textual:

```text
no sorry
no admit
no unsafe
no native_decide
```

## Pendiente

```text
row22 parity-lift seam
row28 nested case analysis
I2ELAbstractRowsV2 concretePhi
K2RetardedInductionInputsV2 concretePhi
M1 theorem
global Collatz claim
```
