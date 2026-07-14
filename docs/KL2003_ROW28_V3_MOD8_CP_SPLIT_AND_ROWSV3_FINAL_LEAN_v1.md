# KL2003_ROW28_V3_MOD8_CP_SPLIT_AND_ROWSV3_FINAL_LEAN_v1

Fecha: 2026-07-14.

Estado: cierre Lean de la deuda semantica final de row28 V3 para
`concretePhi`.

## Clasificacion

```text
ROW28_V3_MOD8_CP_SPLIT_PROVED
CONCRETEPHI_ROW28_SEAM_V3_PROVED
CONCRETEPHI_ROWS_V3_PROVED
LAST_SEMANTIC_DEBT_CLOSED
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Archivos

```text
CollatzClassical/KL2003/KL2003ConcretePhiRealization.lean
CollatzClassical/KL2003/KL2003ConcretePhiRealizationAxiomAudit.lean
```

## Ruta anticircular

El caso repetido de clase `8` se cierra sin llamar a:

```lean
concretePhi_row28_seam_v3
concretePhi_rowsV3
```

La prueba introduce el hijo impar anidado:

```lean
def row28CPrime (a : Nat) : Nat :=
  row28AdvancedChild (row28AdvancedChild a)
```

y registra la forma robusta:

```lean
theorem row28_cprime_arith :
  3 * row28CPrime a + 1 = 2 * row28AdvancedChild a
```

cuando el hijo avanzado de la raiz cae otra vez en clase `8`.

## Split de c'

Para el nodo tachado `c` de clase `8`, el hijo impar `c'` se divide por:

```text
c' % 9 in {2,5,8}
```

Los tres subcasos son:

```text
c' ≡ 2:
  el brazo exterior phi22 se paga directamente con c'.

c' ≡ 5:
  el brazo exterior phi22 se paga via 4*c', que cae en clase 2.

c' ≡ 8:
  se paga phi28 + M1V3 con fibras hermanas bajo c:
    - la rama impar c' paga phi28;
    - la rama par 4*c cae en clase 5 y paga M1V3 usando M1V3 <= phi25.
```

El caso `c' ≡ 8` usa solo suma entre hermanos disjuntos por fibras mediante
`d3_core_instantiation`; no cuenta nodos tachados.

## Teoremas cerrados

```lean
row28_outer_block_v3_le_child_mod8_cprime_mod2
row28_outer_block_v3_le_child_mod8_cprime_mod5
row28_outer_block_v3_le_child_mod8_cprime_mod8
row28_outer_block_v3_le_child_mod8
row28_pointwise_seam_v3_mod8
concretePhi_row28_seam_v3
concretePhi_rowsV3 : I2ELAbstractRowsV3 concretePhi
```

La version V3 usa `M1V3`, cuyo segundo brazo operativo es `phi25`, no `phi22`.

## Audit

El audit fue ampliado para imprimir los axiomas de los lemas auxiliares del
split `c'`, de:

```lean
row28_pointwise_seam_v3_mod8
concretePhi_row28_seam_v3
concretePhi_rowsV3
```

La salida de los teoremas finales queda en el perfil ya esperado del modulo:

```text
[propext, Classical.choice, Quot.sound]
```

## Verificacion

Comandos ejecutados:

```text
lake build CollatzClassical.KL2003.KL2003ConcretePhiRealization
lake env lean CollatzClassical/KL2003/KL2003ConcretePhiRealizationAxiomAudit.lean
git diff --check
```

Resultado:

```text
build: PASS
axiom audit: PASS
diff check: PASS
```

Tambien se hizo scan textual de los archivos Lean tocados para los escapes
prohibidos por la tarea.

## No claims

Este cierre no introduce:

```text
M1 theorem
global Collatz claim
tabla L1-L7 como hipotesis operacional
hook equivalente al constructor
```

## Resultado

```text
ROW28_V3_MOD8_CP_SPLIT_PROVED = yes
CONCRETEPHI_ROW28_SEAM_V3_PROVED = yes
CONCRETEPHI_ROWS_V3_PROVED = yes
LAST_SEMANTIC_DEBT_CLOSED = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
