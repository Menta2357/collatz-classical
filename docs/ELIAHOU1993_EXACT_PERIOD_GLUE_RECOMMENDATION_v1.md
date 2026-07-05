# ELIAHOU1993_EXACT_PERIOD_GLUE_RECOMMENDATION_v1

Fecha: 2026-07-05, Europe/Madrid.

Estado: recomendacion local privada. No publicada en Forum. No convertida en issue. No registrada como audit link.

## Guardarrailes

- NO_FORUM_POST_UNLESS_EXPLICITLY_APPROVED.
- NO_AUDIT_LINK.
- NO_OFFICIAL_CC_CLAIM.
- NO_REPO_EXTERNAL_MODIFICATION.
- NO_GLOBAL_COLLATZ_CLAIM.

## Base

Repo de trabajo:
- `https://github.com/Menta2357/collatz-classical`

Documentos base:
- `docs/ELIAHOU1993_LOCAL_STATEMENT_FIDELITY_AUDIT_v1.md`
- `docs/ELIAHOU1993_L_VS_CARDOMEGA_BRIDGE_AUDIT_v1.md`

Repo formalizacion auditada:
- `https://github.com/tangentstorm/eliahou-collatz-bounds`
- commit auditado: `fdb0b2e1ac0d774f4e288ffa2106785efd351563`

## Alcance honesto actual

CONSEQUENCE_ONLY_SCOPE_RECOMMENDATION_READY: yes.

Lectura justa del estado actual:

- La formalizacion es plausiblemente una formalizacion parcial de la consecuencia de cota inferior:

```lean
17087915 <= L
```

- El theorem central visible aplica a una estructura `CollatzCycle L` con:
  - `hmin : (2 : Nat)^40 < c.minElem`;
  - `hk : 0 < c.numOdd`.
- No es, tal como esta, una formalizacion completa de la forma lineal de Eliahou Theorem 1.1:

```text
Card Omega = 301994 a + 17087915 b + 85137581 c
```

con `a,b,c >= 0`, `b > 0`, y `a c = 0`.

- Falta el puente exact-period / cardinalidad:
  - el paper habla de `Card Omega`;
  - Lean concluye sobre el parametro `L` de una secuencia periodica indexada;
  - `CollatzCycle L` no exige `Nodup`, inyectividad ni periodo minimo.

- Falta descargar internamente `hk : 0 < c.numOdd`.
  - Matematicamente parece derivable para cualquier ciclo positivo de la funcion comprimida.
  - El lemma no aparece en el repo auditado.

Conclusion de scope:

```text
Partial formalization of the lower-bound consequence of Eliahou1993,
pending exact-period/cardinality glue and numOdd positivity glue.
```

Esto no es un rechazo. El CC Challenge acepta formalizaciones parciales. La recomendacion es alinear la descripcion y agregar glue semantico para que el statement publico no sobrelea lo formalizado.

## Tres mejoras concretas recomendadas

EXACT_PERIOD_GLUE_RECOMMENDATION_READY: yes.

### A. README / metadata clarification

PARTIAL_FORMALIZATION_ACCEPTABLE_IF_SCOPED: yes.

Recomendacion:
- Cambiar el framing de "formalization of the main results" / "Theorem 1.1" a una frase mas precisa:

```text
This repository formalizes the lower-bound consequence of Eliahou's Theorem 1.1:
any compressed Collatz cycle satisfying the stated hypotheses has length at least 17,087,915.
It does not currently formalize the full linear-form conclusion
Card Omega = 301994 a + 17087915 b + 85137581 c.
```

Opcionalmente anadir:

```text
The current theorem is stated for indexed periodic cycles `CollatzCycle L`.
Relating this `L` to the paper's `Card Omega` requires an exact-period/no-duplicate
cycle bridge.
```

Por que es justo:
- Reconoce el valor de la formalizacion parcial.
- Evita que una auditoria externa la evalue contra el Theorem 1.1 lineal completo.
- Hace explicito el boundary antes del audit mecanico.

### B. Lemma `CollatzCycle.numOdd_pos`

HK_NUMODD_POS_LEMMA_RECOMMENDED: yes.

Recomendacion:

```lean
theorem CollatzCycle.exists_odd_index {L : Nat} (c : CollatzCycle L) :
    exists i : Fin L, c.seq i % 2 = 1

theorem CollatzCycle.numOdd_pos {L : Nat} (c : CollatzCycle L) :
    0 < c.numOdd
```

Prueba matematica esperada:
- Si todos los elementos fueran pares, tomar un indice donde se alcanza `minElem`.
- Para un positivo par `m`, `collatzComp m = m / 2 < m`.
- Por `step`, el sucesor estaria en el ciclo y seria menor que `minElem`, contradiccion.

Uso esperado:
- El theorem central podria quedar sin hipotesis externa `hk`, o al menos descargarla localmente:

```lean
theorem eliahou_bound_no_hk {L : Nat} (c : CollatzCycle L)
    (hmin : (2 : Nat)^40 < c.minElem) :
    17087915 <= L :=
  eliahou_bound c hmin c.numOdd_pos
```

Esto reduce la distancia entre el paper y Lean.

### C. Exact-period / cardinality glue

Hay tres rutas razonables. La recomendacion practica es empezar por C3, porque es la menor intervencion.

#### C1. `ExactCollatzCycle`

Agregar un wrapper:

```lean
structure ExactCollatzCycle (L : Nat) extends CollatzCycle L where
  injective_seq : Function.Injective toCollatzCycle.seq
```

Luego probar:

```lean
theorem ExactCollatzCycle.card_image_eq {L : Nat} (c : ExactCollatzCycle L) :
    (Finset.univ.image c.seq).card = L
```

Ventaja:
- Hace explicito el significado `L = cardinalidad de la orbita enumerada`.

Costo:
- Introduce una segunda nocion de ciclo y puede requerir versiones exactas de varios lemmas.

#### C2. `PaperCycle.exists_exact_collatzCycle`

Introducir una representacion de ciclo-paper como conjunto/orbita finita y probar:

```lean
theorem PaperCycle.exists_exact_collatzCycle
    (Omega : PaperCycle) :
    exists c : CollatzCycle Omega.card,
      Function.Injective c.seq
      and Finset.univ.image c.seq = Omega.carrier
```

Ventaja:
- Es el puente mas fiel al paper.

Costo:
- Es mas trabajo: hay que disenar `PaperCycle`, cardinalidad, primera vuelta, y enumeracion por iteradas.

#### C3. Theorem con hipotesis `hexact`

Agregar una variante exacta del theorem actual:

```lean
theorem eliahou_bound_exact {L : Nat} (c : CollatzCycle L)
    (hexact : Function.Injective c.seq)
    (hmin : (2 : Nat)^40 < c.minElem) :
    17087915 <= (Finset.univ.image c.seq).card := by
  have hcard : (Finset.univ.image c.seq).card = L := by
    -- from `hexact`
    ...
  simpa [hcard] using eliahou_bound c hmin c.numOdd_pos
```

Ventaja:
- Menor cambio.
- Mantiene `CollatzCycle` general.
- Da un statement directamente en terminos de cardinalidad de la imagen.

Costo:
- Todavia no modela por completo `PaperCycle`, pero deja claro que para hablar de cardinalidad se requiere exactitud/injectividad.

Recomendacion preferida:

```text
Start with B + C3.
Then consider C1 or C2 only if maintainers want a fuller paper-level interface.
```

## Borrador respetuoso para tangentstorm/maintainers

Este borrador no debe publicarse ni enviarse sin aprobacion explicita.

````markdown
Hi,

I have been doing a private statement-fidelity pass on the CC Challenge entry
for `Eliahou1993` formalisation id 6. I have not added an audit link or posted
an official audit report.

First, thanks for putting this formalisation together. The current Lean code
seems to capture a useful lower-bound consequence of Eliahou's argument:

```lean
17087915 <= L
```

for an indexed compressed-Collatz cycle `c : CollatzCycle L` under the
`minElem > 2^40` hypothesis.

The main scope question I found is whether the intended registered scope is
"the lower-bound consequence of Theorem 1.1" rather than the full linear-form
statement of Theorem 1.1. I do not see a current theorem for the full conclusion

```text
Card Omega = 301994 a + 17087915 b + 85137581 c
```

with the conditions on `a,b,c`; the current theorem appears to prove the
`17087915` lower-bound consequence.

There is also a small statement-glue issue around cycle length. In the paper,
the length is `Card Omega`, the cardinality/exact period of the orbit. In Lean,
`CollatzCycle L` is an indexed periodic sequence, and I do not see a `Nodup`,
`Function.Injective`, or minimal-period condition tying `L` to the cardinality
of the orbit set. So a repeated traversal of the same cycle would still fit the
current structure with a larger `L`.

This seems fixable without changing the mathematical core. Three possible
small clarifications/glue lemmas would help:

1. README wording saying that the repo formalizes the lower-bound consequence
   of Eliahou1993, not currently the full linear-form Theorem 1.1.
2. A lemma deriving `0 < c.numOdd` for every positive `CollatzCycle`.
3. An exact-period/cardinality bridge, for example either an `ExactCollatzCycle`
   wrapper with `Function.Injective c.seq`, or a variant theorem with
   `hexact : Function.Injective c.seq` concluding the bound for
   `(Finset.univ.image c.seq).card`.

I am treating this as a partial-formalisation scope clarification, not as a
rejection. Partial formalisations are useful and accepted by the challenge; I
just want to avoid over-reading the current statement during audit.

Would you prefer this entry to be audited as "lower-bound consequence only"?
And would a small exact-period/cardinality glue lemma be welcome before a
mechanical build/axiom/native_decide audit?
````

## Comunicacion recomendada

FORUM_OR_ISSUE_DECISION_SCOPED: yes.

### Opcion 1: publicar Forum ahora

No recomendado todavia.

Motivo:
- La decision de coordinacion vigente dice `FORUM_ANNOUNCEMENT_DEFERRED`.
- El hallazgo es de statement scope y puede resolverse mejor de forma privada/issue antes de presentarlo como audit publico.
- Publicar ahora podria sonar como veredicto oficial aunque todavia no se hizo audit mecanico.

### Opcion 2: abrir GitHub issue en repo externo

Recomendado solo si el usuario aprueba explicitamente contacto publico.

Ventaja:
- Es el canal mas accionable para author/maintainers.
- Permite discutir README wording y glue lemmas sin crear un audit report CC.

Riesgo:
- Sigue siendo publico.
- Hay que cuidar el tono para no parecer rechazo o acusacion.

### Opcion 3: mantener privado hasta mechanical audit

Recomendacion actual: si no hay aprobacion explicita para contacto, mantener privado por ahora.

Motivo:
- Preserva `NO_OFFICIAL_CC_CLAIM`.
- Permite completar mechanical audit y llegar con un paquete mas completo:
  - statement scope;
  - build status;
  - axiom/sorry status;
  - native_decide trust notes;
  - concrete glue recommendations.

Decision recomendada:

```text
Do not post Forum now.
Do not create audit link.
Do not open GitHub issue unless explicitly approved.
Next best step: run/prepare mechanical audit locally, then decide whether to open
a respectful GitHub issue or Forum coordination note with the full context.
```

## Clasificaciones

- CONSEQUENCE_ONLY_SCOPE_RECOMMENDATION_READY: yes
- EXACT_PERIOD_GLUE_RECOMMENDATION_READY: yes
- HK_NUMODD_POS_LEMMA_RECOMMENDED: yes
- PARTIAL_FORMALIZATION_ACCEPTABLE_IF_SCOPED: yes
- FORUM_OR_ISSUE_DECISION_SCOPED: yes
- AUDIT_LINK_NOT_CREATED: yes
- NO_GLOBAL_COLLATZ_CLAIM: yes
