# ELIAHOU1993_L_VS_CARDOMEGA_BRIDGE_AUDIT_v1

Fecha: 2026-07-05, Europe/Madrid.

Estado: auditoria local privada del puente semantico `Card Omega` vs `L`. No publicada en Forum. No registrada como audit link.

## Guardarrailes

- No Forum post.
- No audit link.
- No claim oficial CC.
- No claim global Collatz.
- No modificacion del repo externo.
- No build pesado: no se ejecuto `lake build`, `lake env`, ni `lake exe cache get`.

## Base y commit auditado

Repo de trabajo:
- `https://github.com/Menta2357/collatz-classical`

Documentos base:
- `docs/ELIAHOU1993_LOCAL_STATEMENT_FIDELITY_AUDIT_v1.md`
- `docs/ELIAHOU1993_AUDIT_PHASE1_PREP_v1.md`

Repo formalizacion:
- `https://github.com/tangentstorm/eliahou-collatz-bounds`
- path local inspeccionado: `/Users/MoiTam/Documents/Codex/2026-07-05/tarea-cc-challenge-audit-entry-phase0/work/eliahou-collatz-bounds`
- commit: `fdb0b2e1ac0d774f4e288ffa2106785efd351563`
- fecha: `2026-04-09 20:43:12 -0400`
- subject: `removed unused/unproven 'precise' reformulation`

Archivos inspeccionados:
- `Collatz/Defs.lean`
- `Collatz/ProductFormula.lean`
- `Collatz/Sandwich.lean`
- `Collatz/ContinuedFractions.lean`
- `Collatz/README.md`
- `ARISTOTLE_SUMMARY.md`

## Pregunta auditada

El paper usa un ciclo `Omega` como orbita/conjunto finito y su longitud es `Card Omega`. La formalizacion usa:

```lean
structure CollatzCycle (L : Nat) where
  hL : 0 < L
  seq : Fin L -> Nat
  pos : forall i, 0 < seq i
  step : forall i : Fin L, collatzComp (seq i) = seq (i.succMod hL)
```

Pregunta: el parametro `L` esta forzado a ser `Card Omega` / periodo exacto, o puede ser un periodo inflado?

## Busqueda de nociones exactas

Se busco en todo el repo por vocabulario asociado:

- `exact`
- `period`
- `minimal`
- `minPeriod`
- `minimalPeriod`
- `Nodup` / `nodup`
- `Injective` / `injective`
- `Pairwise`
- `Distinct` / `distinct`
- `orbit` / `Orbit`
- `trajectory`
- `Set`
- `Fintype`
- `card` / `Card`

Resultado:

| Nocion | Encontrada? | Evidencia |
|---|---:|---|
| exact period | no | No hay definicion ni theorem de periodo exacto/minimo. |
| no duplicate cycle | no | No hay `Nodup`, `Pairwise`, ni condicion equivalente sobre `seq`. |
| injective sequence | no | No hay `Function.Injective c.seq` ni campo similar. |
| orbit set cardinality | no | `minElem/maxElem` usan `Finset.univ.image c.seq`, pero no hay theorem que relacione su cardinalidad con `L`. |
| minimal period | no | No aparece una nocion que descarte recorridos repetidos. |
| bridge paper cycle -> Lean cycle exacto | no | No hay tipo de ciclo como conjunto/orbita ni theorem hacia `CollatzCycle (Card Omega)`. |

Conclusion:

`EXACT_PERIOD_BRIDGE_FOUND: no`.

`EXACT_PERIOD_BRIDGE_MISSING: yes`.

## Inflacion de `L`

L_INFLATION_CONFIRMED: yes.

### Motivo estructural

`CollatzCycle L` solo exige una secuencia periodica indexada por `Fin L`. La condicion `step` dice que cada entrada avanza a la siguiente modulo `L`, pero no exige que las entradas sean distintas ni que `L` sea el primer retorno.

Por tanto, si una secuencia de longitud `p` satisface la estructura, repetirla `r` veces produce una secuencia de longitud `r*p` que tambien satisface la estructura.

### Testigo concreto

El repo define:

```lean
def trivialCycle : CollatzCycle 2 where
  seq := ![1, 2]
```

La misma orbita trivial admite una representacion inflada de longitud 4:

```lean
-- sketch, not added to external repo and not build-checked in this phase
def trivialCycle4 : CollatzCycle 4 where
  hL := by omega
  seq := ![1, 2, 1, 2]
  pos := by intro i; fin_cases i <;> simp
  step := by
    intro i
    fin_cases i <;> simp [Fin.succMod, collatzComp]
```

Semantica:
- La orbita del paper es `{1,2}`.
- `Card Omega = 2`.
- Pero la estructura Lean tambien permite `L = 4` para el recorrido `1,2,1,2`.

Este ejemplo no usa una orbita no trivial, pero demuestra la propiedad del tipo. El mismo patron aplicaria a cualquier ciclo exacto hipotetico: recorrerlo dos o mas veces preserva `pos` y `step`.

### Consecuencia para `eliahou_bound`

`eliahou_bound` concluye:

```lean
17087915 <= L
```

Si `L` es un periodo inflado, esa conclusion no implica automaticamente:

```text
17087915 <= Card Omega
```

Para obtener el enunciado del paper, hay que aplicar `eliahou_bound` a una instancia exacta con `L = Card Omega`, no a una instancia arbitraria de recorrido repetido.

## Hay lemmas que impidan inflacion?

No se encontro ningun lemma que impida inflacion. En particular, no aparecen:

```lean
Function.Injective c.seq
c.seq.Injective
List.Nodup
Finset.card (Finset.univ.image c.seq) = L
minimal_period c = L
```

Los lemmas existentes sobre `CollatzCycle` son:
- particion impar/par de indices;
- `numOdd + numEven = L`;
- positividad de `minElem`;
- cotas `minElem <= seq i` y `seq i <= maxElem`;
- formulas de producto sobre indices;
- desigualdades sandwich sobre `L / numOdd`.

Todos estos son compatibles con una secuencia repetida. Por ejemplo, en una repeticion doble, `numOdd`, `numEven`, los productos y el exponente `2^L` se duplican de forma coherente sobre indices; no fuerzan minimalidad.

## Puente necesario

La forma minima del puente es:

```text
paper cycle Omega with Card Omega = p
  ->
exists c : CollatzCycle p,
  image(c.seq) = Omega
  and c.seq is injective
  and c.minElem = min Omega
  and c.maxElem = max Omega
  and c.numOdd = Card Omega_1
```

### Opcion A: fortalecer la estructura Lean

Definir un wrapper de ciclo exacto:

```lean
structure ExactCollatzCycle (L : Nat) extends CollatzCycle L where
  nodup_seq : Function.Injective toCollatzCycle.seq
```

Con `Function.Injective c.seq`, la imagen de `Fin L` tiene cardinalidad `L`. Entonces el parametro `L` representa la cardinalidad del orbit set enumerado.

Lemmas necesarios:

```lean
theorem ExactCollatzCycle.card_image_eq
    {L : Nat} (c : ExactCollatzCycle L) :
    (Finset.univ.image c.seq).card = L

theorem ExactCollatzCycle.numOdd_eq_card_odd_image
    {L : Nat} (c : ExactCollatzCycle L) :
    c.numOdd = (Finset.univ.filter (fun i => c.seq i % 2 = 1)).card
```

La segunda igualdad ya es definicional sobre indices; para identificarla con `Card Omega_1`, hace falta pasar por la inyectividad de `seq`.

### Opcion B: dejar `CollatzCycle` general y agregar puente externo

Introducir un tipo de ciclo-paper como conjunto finito:

```lean
structure PaperCycle where
  carrier : Finset Nat
  nonempty : carrier.Nonempty
  pos : forall n in carrier, 0 < n
  closed : forall n in carrier, collatzComp n in carrier
  cyclic : exists x in carrier,
    carrier = Finset.image (fun i : Fin (carrier.card) => iterate collatzComp i x) Finset.univ
  first_return : ...
```

Luego probar:

```lean
theorem PaperCycle.exists_exact_collatzCycle
    (Omega : PaperCycle) :
    exists c : CollatzCycle Omega.carrier.card,
      Function.Injective c.seq
      and Finset.univ.image c.seq = Omega.carrier
```

Esta opcion preserva `CollatzCycle` como objeto general, pero deja explicita la conversion cuando se quiere hablar de `Card Omega`.

### Opcion C: theorem central con hipotesis de exactitud

Agregar una version del theorem con hipotesis de inyectividad:

```lean
theorem eliahou_bound_exact {L : Nat} (c : CollatzCycle L)
    (hexact : Function.Injective c.seq)
    (hmin : (2 : Nat) ^ 40 < c.minElem)
    (hk : 0 < c.numOdd) :
    17087915 <= (Finset.univ.image c.seq).card
```

Como `hexact` da `(Finset.univ.image c.seq).card = L`, esta version conecta directamente con cardinalidad de la imagen.

Esta opcion no formaliza paper cycles completos, pero reduce el riesgo de sobreleer `L`.

## `hk : 0 < c.numOdd`

HK_NUMODD_POS_FOUND: no.

HK_NUMODD_POS_MISSING_BUT_DERIVABLE: yes.

### Busqueda

Se busco `numOdd`, `oddIndices`, `numOdd_pos`, `odd`, `isNontrivial` y lemmas relacionados. Solo se encontro:

```lean
noncomputable def CollatzCycle.numOdd {L : Nat} (c : CollatzCycle L) : Nat :=
  c.oddIndices.card

theorem CollatzCycle.numOdd_add_numEven {L : Nat} (c : CollatzCycle L) :
    c.numOdd + c.numEven = L
```

No se encontro theorem que derive `0 < c.numOdd`.

### Statement recomendado

```lean
theorem CollatzCycle.numOdd_pos {L : Nat} (c : CollatzCycle L) :
    0 < c.numOdd
```

o, si se prefiere evitar un theorem global mientras se prueba:

```lean
theorem CollatzCycle.exists_odd_index {L : Nat} (c : CollatzCycle L) :
    exists i : Fin L, c.seq i % 2 = 1
```

De `exists_odd_index` se obtiene `0 < c.numOdd` por cardinalidad positiva del filtro.

### Prueba matematica

1. Como `L > 0`, existe un indice `j` donde `c.seq j = c.minElem`.
2. Supongamos que no hay indices impares; entonces todo `c.seq i` es par.
3. En particular `c.seq j` es par y positivo.
4. Para un positivo par `m`, `collatzComp m = m / 2 < m`.
5. Por `step`, `collatzComp (c.seq j) = c.seq (j.succMod c.hL)`.
6. Entonces el sucesor tiene valor menor que `minElem`, contradiciendo `minElem_le`.

Este lemma no depende de no-duplicacion ni de periodo exacto; vale para cualquier `CollatzCycle L` positivo.

### Impacto

La hipotesis `hk` es una hipotesis agregada respecto del paper, pero probablemente benignamente derivable. En el estado actual del repo sigue siendo una pequena brecha de statement: el theorem central podria no pedir `hk` si ese lemma existiera.

## Consequence-only scope refinado

CONSEQUENCE_ONLY_PARTIAL_SCOPE_REFINED: yes.

La formalizacion puede leerse en tres niveles:

1. Como theorem sobre secuencias periodicas indexadas:
   - soportado por el statement Lean visible;
   - no depende de `Card Omega`.

2. Como corolario de cota inferior para ciclos-paper:
   - plausible;
   - requiere puente exacto `Card Omega -> CollatzCycle (Card Omega)`;
   - requiere eliminar o descargar `hk`.

3. Como formalizacion completa de Theorem 1.1:
   - no soportado;
   - falta la forma lineal `301994 a + 17087915 b + 85137581 c`;
   - falta Corollary 2.3 en su forma de funciones `K(m)`/`L(m)`.

Por tanto, la clasificacion honesta sigue siendo:

```text
partial formalization of the lower-bound consequence, pending exact-period bridge.
```

No es un rechazo automatico: el CC Challenge permite formalizaciones parciales. Pero cualquier mensaje publico debe evitar presentar id 6 como formalizacion completa del paper o del Theorem 1.1 lineal.

## Checklist de acciones recomendadas antes de Forum/audit link

1. Pedir confirmacion de scope a author/maintainers:
   - "Should id 6 be audited as a lower-bound consequence only?"
2. Proponer README clarification:
   - cambiar "main results" / "Theorem 1.1" por "lower-bound consequence of Theorem 1.1" si ese es el scope.
3. Proponer o auditar lemma:
   - `CollatzCycle.numOdd_pos`.
4. Proponer o auditar puente exacto:
   - `ExactCollatzCycle`, o
   - `PaperCycle.exists_exact_collatzCycle`, o
   - theorem con `hexact : Function.Injective c.seq`.
5. Solo despues pasar a build/axiom/native_decide audit.

## Clasificaciones

- L_INFLATION_CONFIRMED: yes
- EXACT_PERIOD_BRIDGE_FOUND: no
- EXACT_PERIOD_BRIDGE_MISSING: yes
- HK_NUMODD_POS_FOUND: no
- HK_NUMODD_POS_MISSING_BUT_DERIVABLE: yes
- CONSEQUENCE_ONLY_PARTIAL_SCOPE_REFINED: yes
- FORUM_ANNOUNCEMENT_DEFERRED: yes
- AUDIT_LINK_NOT_CREATED: yes
