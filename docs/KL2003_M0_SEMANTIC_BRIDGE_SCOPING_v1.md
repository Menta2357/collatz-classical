# KL2003_M0_SEMANTIC_BRIDGE_SCOPING_v1

Fecha: 2026-07-07.

Estado: scoping documental para el primer puente semantico M0 de KL2003.
No se crea Lean nuevo en esta tarea.

## Clasificacion

```text
M0_SEMANTIC_BRIDGE_SCOPED
NUMERIC_TRANSCENDENTAL_TOWER_CLOSED
M0A_COMPUTABLE_PI_STAR_FIRST
M0C_RETARDED_INDUCTION_BEFORE_TREE_PROOF
M0B_TREE_DIFFERENCE_INEQUALITIES_IDENTIFIED_AS_MAIN_RISK
M0D_M1_SURROGATE_ASSEMBLY_DEFERRED
COMPUTABLE_FINSET_PI_STAR_DESIGN_SELECTED
REAL_Y_INDUCTION_MEASURE_IDENTIFIED
CYCLE_EXCLUSION_RETAINED_AS_HYPOTHESIS
NO_NEW_LEAN
NO_M0_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Contexto cerrado antes de M0

La torre numerica k=2 ya esta cerrada en Lean:

```text
integer witnesses
-> rational certificate data
-> rational certificate verifier
-> alpha bounds
-> transcendental rpow endpoints
```

Modulos cerrados:

```text
KL2003K2CertificateData.lean
KL2003K2CertificateVerifier.lean
KL2003K2AlphaBounds.lean
KL2003K2TranscendentalEndpoints.lean
```

Todos los audits reportan solo:

```text
[propext, Classical.choice, Quot.sound]
```

No hay:

```text
native_decide
Lean.trustCompiler
sorry
M0 proof
M1 theorem
global Collatz claim
```

## Objetivo de M0

M0 no debe probar todavia el teorema final de KL2003. Su objetivo es crear el
puente semantico minimo entre:

```text
certificado numerico k=2
```

y:

```text
desigualdades de diferencia para pi_a^*(x) / phi_2^m(y)
```

El objetivo posterior sera un `M1 surrogate` calibrado:

```text
k=2 KL2003-style lower-bound infrastructure
```

no una formalizacion completa de KL2003 ni un claim global sobre Collatz.

## Orden recomendado

El orden deliberado es:

```text
M0a -> M0c -> M0b -> M0d
```

No es el orden narrativo del paper, sino el orden de riesgo para Lean.

## M0a: semantica computable de pi_star

Primero definir la semantica computable del arbol inverso acotado.

Definicion objetivo:

```text
piStar a x =
  Finset.card
    { n in Finset.range (x+1) :
        n >= 1
        and orbit under T from n reaches a
        and all intermediate states <= x }
```

Principios:

- usar `Finset.filter`, no `Set.ncard`;
- hacer la definicion decidible/computable por diseno;
- usar fuel `x+1` para la busqueda orbital acotada;
- si una orbita sin repeticion permanece en `[1,x]`, su longitud es `<= x`;
- una repeticion antes de alcanzar `a` indica ciclo local y no debe contarse salvo
  que `a` este en ese ciclo.

Validacion cruzada obligatoria:

```text
archivo de tests / #eval
comparar piStar Lean contra script Python existente
para a <= 100 o una ventana equivalente pequena
```

Motivo:

```text
si la semantica Lean diverge del script en un valor,
el error debe detectarse antes de probar D1/D2/D3.
```

## M0c: induccion retardada abstracta

Segundo, antes de las desigualdades del arbol, aislar la induccion mecanica que
consume:

```text
certificado racional/transcendental
base segment lower bound
```

y produce una conclusion abstracta de crecimiento para las funciones `phi`.

Esta parte debe ser independiente de la semantica del arbol.

Razon:

```text
M0c deberia ser mecanico.
M0b es el riesgo matematico.
Cerrar M0c primero deja el riesgo real aislado.
```

### Decision tecnica: induccion sobre y real

Los shifts retardados de KL2003 son reales:

```text
alpha - 3
2*alpha - 5
3*alpha - 5
```

La induccion no puede ser una recursion ingenua sobre `y : Real`.

Decision de scoping:

```text
usar una medida natural tipo
  Nat.ceil (y / delta)
donde
  delta = 5 - 3*alpha > 0
```

El peor shift retardado es:

```text
3*alpha - 5 < 0
```

por lo que avanzar por el sistema reduce estrictamente la medida si el
argumento se formula con el margen correcto.

Este punto debe resolverse en scoping antes de escribir el modulo Lean, no
descubrirse a mitad de una prueba.

## M0b: desigualdades semanticas D1/D2/D3

Tercero, probar las desigualdades semanticas del sistema `I_2`:

```text
D1: residuo 2 mod 9
D2: residuo 5 mod 9
D3: residuo 8 mod 9
```

Este es el riesgo matematico principal.

Contenido esperado:

- subarboles inversos acotados;
- predecesores distintos de la raiz;
- disyuncion de descendencias de hijos distintos;
- contabilidad de frontera;
- traduccion de cambios de raiz a shifts en `y`.

Lema generico prioritario:

```text
children distinct under inverse tree
=> bounded descendant subtrees disjoint
```

La desigualdad aritmetica de frontera que debe aparecer es del tipo:

```text
2^(y+alpha-1) * (2*a-1)/3 = 2^y*a - 2^(y-1)
```

o su version formal equivalente en el sistema normalizado.

### Hipotesis de ciclo

La hipotesis:

```text
a is not in a cycle
```

debe permanecer como hipotesis local.

No se intenta probar que enteros concretos no son ciclicos salvo descargas
finitas necesarias.

Motivo:

```text
el sanity check ya mostro que a=2 puede romper D1 por el ciclo 1 <-> 2.
excluir ciclos no es cosmetico; es una hipotesis portante.
```

## M0d: ensamblaje hacia M1 surrogate

Cuarto, ensamblar:

```text
M0a semantic piStar
+ M0b D1/D2/D3
+ M0c retarded induction
+ k=2 numeric/transcendental certificate
```

para obtener el statement calibrado `M1 surrogate`.

Este modulo no debe llamarse todavia `KL2003 theorem` ni `M1 full theorem`
si no incluye:

- base segment real;
- semantica completa;
- paso asintotico;
- statement bibliografico exacto.

## Decision de definicion computable

Se elige explicitamente:

```text
piStar by Finset.filter
```

No se elige:

```text
piStar by Set.ncard
```

Razon:

- permite `#eval`;
- permite comparacion contra Python;
- permite audit reproducible;
- fuerza a fijar la semantica exacta desde el principio.

## Guardarrailes para la siguiente fase

Antes de crear Lean M0:

```text
NO_M0B_BEFORE_M0A_TESTS
NO_M0D_BEFORE_M0B
NO_GLOBAL_COLLATZ_CLAIM
NO_M1_THEOREM_NAME_UNTIL_ASSEMBLED
NO_NONCOMPUTABLE_PI_STAR_AS_PRIMARY_DEFINITION
NO_CYCLE_EXCLUSION_REMOVAL
```

Hilo A queda en espera:

```text
Eliahou1993 author-first issue abierto
ventana hasta 2026-07-21 01:21 CEST
sin Forum
sin audit link
```

## Siguiente prompt recomendado

```text
KL2003_M0A_COMPUTABLE_PI_STAR_SEMANTICS_SCOPING_v1
```

Objetivo:

```text
disenar la definicion computable de T, orbit-with-fuel, bounded-reaches,
piStarFinset, y el plan de #eval contra Python para a <= 100.
```

No crear todavia M0b/D1-D3.

## Resultado

```text
M0_SEMANTIC_BRIDGE_SCOPED = yes
NUMERIC_TRANSCENDENTAL_TOWER_CLOSED = yes
M0A_COMPUTABLE_PI_STAR_FIRST = yes
M0C_RETARDED_INDUCTION_BEFORE_TREE_PROOF = yes
M0B_TREE_DIFFERENCE_INEQUALITIES_IDENTIFIED_AS_MAIN_RISK = yes
M0D_M1_SURROGATE_ASSEMBLY_DEFERRED = yes
COMPUTABLE_FINSET_PI_STAR_DESIGN_SELECTED = yes
REAL_Y_INDUCTION_MEASURE_IDENTIFIED = yes
CYCLE_EXCLUSION_RETAINED_AS_HYPOTHESIS = yes
NO_NEW_LEAN = yes
NO_M0_PROOF = yes
NO_M1_THEOREM = yes
NO_GLOBAL_COLLATZ_CLAIM = yes
```
