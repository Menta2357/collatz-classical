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
| 2 | KL2003: k=2 surrogate plus k=3 and k=9 piStar bounds | `docs/KL2003_AUDIT_READY_FIDELITY_PACKAGE_v1.md` | K9 THEOREM COMPLETE |
| 3 | Auditoria bibliografica Liu 2025, arXiv:2512.13760 | `docs/LIU2025_COUNTING_COLLATZ_NUMBERS_SOURCE_AUDIT_v1.md` | SOURCE AUDIT COMPLETE |
| 4 | Terras 1976 / Everett 1977 / Terras 1979 | (solo colaborar/auditar; no duplicar) | EN ESPERA |

## Estado KL2003

El carril KL2003 alcanzo primero su meta tecnica k=2 calibrada en `71add7c`:

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
Esto no es el M1 completo, no cubre `x` pequeno bajo umbral y no es un claim
global de Collatz.

La cadena general-k ya tiene tambien su primer consumidor semantico k=3. El
teorema `exists_k3_piStar_arbitrary_x_lower_bound`, en
`CollatzClassical/KL2003/KL2003K3LNTCertificate.lean`, prueba que existe
`Delta > 0` tal que, para las nueve clases trackeadas modulo 27, cada raiz
admisible `a` y todo `x >= a`,

```text
Delta * (x/a)^gammaK3 <= piStar a x,
```

con `gammaK3 > 3/5`.

F2 midio la ruta plana `L_9^NT` sin materializar arboles EL. El generador
produce 6561 filas y un candidato racional exacto con
`lambda = 70461/40000`. Nueve shards Lean recomprueban las 6561 filas y 2187
grupos auxiliares. La cadena general-k consume ese certificado y cierra:

```lean
exists_k9_piStar_arbitrary_x_lower_bound
```

El teorema usa `gammaK9 = logb 2 (70461/40000)` y Lean prueba las cotas
exactas `gammaK9 > 81/100` y `gammaK9 > 49/60`. El build estable del paquete
completo midio 343.02 segundos, dentro del presupuesto previo de 1320
segundos. k=11 requiere un gate separado y no se reclama aqui.

## Panorama bibliografico actual

El preprint `arXiv:2512.13760v1`, enviado el `2025-12-15`, reclamo una cota
`x^0.946`. La version `v2`, enviada el `2025-12-17`, la reemplazo por
`x^0.3227`. La auditoria reproducible del repositorio
encuentra blockers independientes en la demostracion v2 y, por tanto, no
trata `0.3227` como una cota validada ni el `0.946` retirado como estado del
arte. Esto no prueba que el teorema v2 sea falso.

Para este proyecto, `gamma_11 = 0.8417560` sigue siendo el extremo de la tabla
computada de KL2003; no se presenta como una imposibilidad para `k > 11` ni
como un techo matematico global.

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
- No afirma que el resultado KL2003 actual sea el M1 completo, ni un teorema
  k=11/`0.8418`, ni una cota k=2 para `x` pequeno bajo umbral. Si afirma los
  teoremas calibrados k=2, k=3 y k=9 descritos arriba.
- Los objetivos son formalizaciones de teoremas publicados
  (Krasikov 1989, Applegate–Lagarias 1995, Krasikov–Lagarias 2003)
  y auditorías con crédito explícito a los autores originales.
