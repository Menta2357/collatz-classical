# KL2003_FORMALIZATION_FEASIBILITY_AUDIT_v1

Blanco: I. Krasikov, J. C. Lagarias, *Bounds for the 3x+1 problem using
difference inequalities*, Acta Arith. 109 (2003) 237–258 (arXiv:math/0205002).

Enunciado: existe c > 0 tal que el número de enteros n ≤ x cuya órbita 3x+1
alcanza 1 es ≥ c·x^0.84 para todo x suficientemente grande.

Estado en CC Challenge: sin formalización activa (verificado julio 2026).
Verificar de nuevo antes de anunciar el proyecto.

## Por qué este blanco

Es un teorema incondicional publicado cuya prueba es del tipo
"cómputo finito certificado + propagación de desigualdades exactas".
Ese es exactamente el perfil de nuestra infraestructura: aritmética racional
exacta en Lean, contadores auditados, disciplina de axiom audit.
No contiene el muro analítico del programa anterior: no requiere cotas
uniformes de la distribución de Syracuse, porque cuenta el árbol INVERSO
(preimágenes de 1), no excursiones forward.

## Anatomía de la prueba (tres capas, riesgo creciente)

### Capa A — Desigualdades en diferencias del árbol inverso

La dinámica inversa: desde m se llega a 2m siempre, y a (2m−1)/3 cuando
m ≡ 2 (mod 3). Clasificando por residuos mod 3^k, las funciones de conteo
n_a(x) = #{n ≤ x : n ≡ a (mod 3^k), n alcanza 1} satisfacen un sistema de
desigualdades en diferencias (cada clase recibe de las clases que la
alcanzan por un paso inverso).

- Naturaleza: combinatoria entera + congruencias. RIESGO BAJO.
- Reuso de nuestra base: disciplina de contadores exactos y semántica de
  traza. ATENCIÓN: nuestra semántica actual es forward-window; el árbol
  inverso es semántica NUEVA. El reuso es arquitectónico, no verbatim.
  Presupuestar la construcción del módulo `InverseTree` desde cero.

### Capa B — Del sistema a la cota x^γ (certificado del exponente)

El paso central: toda solución del sistema de desigualdades crece al menos
como x^γ, donde γ sale de un problema de optimización no lineal sobre el
sistema (KL lo resuelven por programación no lineal asistida; para
mod 3^9 obtienen γ = 0.84).

- Punto clave para Lean: NO hay que formalizar la optimización. Basta un
  TESTIGO racional (el vector de exponentes/pesos factible) y verificar
  finitas desigualdades polinomiales en racionales exactos. Verificar un
  certificado es nuestro oficio; encontrarlo ya lo hicieron KL.
- RIESGO MEDIO: tamaño del certificado a k=9 (3^9 = 19683 clases antes de
  reducciones; KL reducen dimensión — cuantificar el tamaño real del
  sistema reducido es la tarea F2 de abajo).
- Las potencias reales x^γ se manejan con γ racional (0.84 = 21/25) y
  desigualdades del tipo a^25 ≥ b^21 en enteros — sin análisis real.

### Capa C — Asintótica ("para x suficientemente grande")

La inducción sobre x que propaga las desigualdades necesita casos base y
un x₀ explícito.

- RIESGO MEDIO: trabajo de contabilidad, no de ideas. Formalizar la versión
  EFECTIVA (con x₀ concreto) es más fuerte que el paper y más natural en
  Lean. El caso base hasta x₀ es un cómputo certificado — nuestro terreno.

## Escalera de de-risking (no atacar 0.84 de frente)

Cada peldaño es un teorema publicado por sí mismo. Si el peldaño 1 cierra,
el 3 es escalar el certificado, no inventar método.

```
M0  Framework: InverseTree + sistema de desigualdades genérico mod 3^k
    + teorema "certificado factible ⇒ cota x^γ" (γ racional simbólico).
M1  Krasikov 1989: x^(3/7). Sistema pequeño (mod 3^2). Primer teorema
    real formalizado. GO/NO-GO principal del proyecto.
M2  Applegate–Lagarias 1995b (Krasikov inequalities, exponente intermedio).
    Prueba de que el framework escala en k.
M3  KL2003: γ = 0.84 con el certificado a k = 9.
```

## Tareas del feasibility audit (antes de escribir Lean)

```
F1  Conseguir el paper (arXiv:math/0205002) y reconstruir el sistema
    exacto de desigualdades para k = 2 (peldaño M1) a mano.
F2  Cuantificar el certificado de KL a k = 9: dimensión real del sistema
    reducido, tamaño de los racionales. Decide si M3 es factible o si el
    techo honesto del proyecto es M2.
F3  Inventario mathlib: qué existe de densidad natural / conteo asintótico
    / desigualdades de potencias racionales. Lo que falte se construye,
    pero hay que saberlo antes de presupuestar.
F4  Redactar los enunciados Lean objetivo de M0 y M1 (solo signatures,
    sin prueba) y validar que el enunciado formal captura el teorema del
    paper sin debilitarlo. Revisión cruzada con el checklist de audits/.
F5  Contactar al CC Challenge: registrar KL2003 como "being formalised"
    ANTES de invertir, para no repetir el escenario Terras en reverso.
```

## Criterios GO / NO-GO

- GO si: F1 reproduce el sistema k=2 sin ambigüedad, F3 no revela un hueco
  de mathlib de meses, y F4 produce signatures que ambos hilos aceptan
  como fieles al paper.
- NO-GO (o rebaja a M1-only) si: F2 muestra un certificado k=9
  computacionalmente inabordable en Lean, o el paper requiere en la Capa B
  análisis real no eliminable por testigos racionales.
- En NO-GO, el proyecto M0+M1 sigue siendo un entregable honesto:
  primera formalización de Krasikov 1989.

## Clasificación inicial

```
KL2003_TARGET            = FEASIBILITY_AUDIT_IN_PROGRESS
M1_KRASIKOV_1989         = PRIMARY_MILESTONE
REUSE_FROM_PRIOR_PROGRAM = ARCHITECTURAL_NOT_VERBATIM
COLLATZ_FULL             = NOT_CLAIMED (y no se reclamará)
```
