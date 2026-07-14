# collatz-classical

Formalización en Lean 4 de resultados **clásicos y publicados** del problema 3x+1,
y auditoría adversarial de formalizaciones de terceros (CC Challenge).

Este proyecto sucede a un programa previo de certificación finita de ventanas
dyádicas (drift/colas/momentos, [20M, 640M], axiom-clean). Aquel programa
localizó con precisión un muro analítico (cota de decaimiento uniforme de la
distribución de Syracuse) y se cerró honestamente en su residuo finito.
Este repositorio redirige la infraestructura y el oficio acumulados hacia
teoremas que **sí** son demostrables con matemática existente.

## Carriles

| # | Carril | Documento | Estado |
|---|--------|-----------|--------|
| 1 | Entrada como auditores al CC Challenge | `docs/CC_CHALLENGE_AUDIT_ENTRY_PLAN_v1.md` | ACTIVO |
| 2 | KL2003: k=2 M1-surrogate over concrete ceil window | `docs/KL2003_M1_SURROGATE_FINAL_REVIEW_AND_PACKAGE_v1.md` | THEOREM COMPLETE |
| 3 | Terras 1976 / Everett 1977 / Terras 1979 | (solo colaborar/auditar; no duplicar) | EN ESPERA |

## Estado KL2003

El carril KL2003 alcanzo su meta tecnica calibrada en `71add7c`:

```lean
kl2003_k2_m1_surrogate_ceil_window_lower_bound
```

El enunciado esta en
`CollatzClassical/KL2003/KL2003M1Surrogate.lean` y se empaqueta en
`docs/KL2003_M1_SURROGATE_FINAL_REVIEW_AND_PACKAGE_v1.md`.

Alcance exacto: `k=2` M1-surrogate sobre la ventana concreta
`concreteWindow y a = Nat.ceil ((2 : Real)^y * (a : Real))`, para clases
`2`, `5`, `8` y raices admisibles. Tambien esta cerrado el corolario para
`x` arbitrario grande mediante `y := Real.logb 2 ((x : Real) / (a : Real))`.
Esto no es el M1 completo, no es el resultado KL2003 `k=9`/`0.84`, no cubre
`x` pequeno bajo umbral y no es un claim global de Collatz.

## Principios (heredados del programa anterior)

1. **Build PASS ≠ resultado.** La unidad de cierre es el axiom audit más el
   análisis de carga de hipótesis.
2. **Verificador ≠ generador.** Un `∀ k` cuyo cuerpo se instancia por
   enumeración no es un teorema universal.
3. **Sin selección a posteriori.** Ninguna constante se fija después de ver
   los datos que debe acotar.
4. **Etiquetas calibradas.** CLOSED / CONDITIONAL / OPEN / NOT_CLAIMED,
   sin inflación.

El checklist operativo completo está en
`audits/ADVERSARIAL_AUDIT_CHECKLIST_v1.md`.

## Qué NO afirma este repositorio

- No afirma progreso hacia la conjetura de Collatz completa.
- No afirma supermartingalas globales ni productores all-k.
- No afirma que el resultado KL2003 actual sea el M1 completo, ni el teorema
  KL2003 `k=9`/`0.84`, ni una cota para `x` pequeno bajo umbral; el cierre
  actual es el teorema tecnico `k=2` M1-surrogate sobre `ceil` window y su
  corolario para `x` arbitrario grande.
- Los objetivos son formalizaciones de teoremas publicados
  (Krasikov 1989, Applegate–Lagarias 1995, Krasikov–Lagarias 2003)
  y auditorías con crédito explícito a los autores originales.
