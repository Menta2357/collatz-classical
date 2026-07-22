# F3 exact 243-state core matrix — informe v1

Estado: `EXACT_MATRIX_DEFINED_ROW_CERTIFICATE_OPEN`.

## Resultado

Se generó una representación Lean de la matriz finita del núcleo F3 sobre
`Fin 243`. El objeto contiene exactamente:

- 243 estados del núcleo;
- 729 aristas internas, distribuidas en 243 retarded, 243 advanced-direct y
  243 parity-lift;
- un vector de pesos congelado de 243 entradas enteras, interpretado en
  `Real` con denominador `10^6`;
- entradas de matriz definidas por las expresiones exactas
  `rhoStar = 9/5`, `alpha = log(3)/log(2)` y `Real.rpow`, sin promover ningún
  decimal a igualdad;
- no negatividad de los pesos de canal, de la matriz y del vector congelado,
  verificada en Lean;
- conteos 729 y 243 verificados mediante `native_decide`.

La compilación del módulo principal terminó en 220.18 s, dentro del límite
predeclarado de 300 s. El coste se debe a la lista finita completa y al
chequeo nativo de sus conteos; no es una medición de la dificultad del lema
analítico pendiente.

## Obligación que permanece abierta

El módulo define, pero no afirma, la proposición

```text
∀ s, (101/100) · frozenWeight s
     ≤ Σ t, coreMatrix s t · frozenWeight t.
```

Esta desigualdad member-wise todavía debe demostrarse a partir de las
entradas exactas. El CSV contiene valores decimales de auditoría y no se han
convertido en prueba Lean. Por tanto este informe **no** declara certificado
de `rho`, teorema de densidad ni resultado global de Collatz.

## Auditoría

El módulo de auditoría imprime las dependencias axiomáticas de los conteos,
la no negatividad y la interfaz de la obligación. La presencia de
`Real.rpow`, `Classical.choice` o axiomas estándar de Mathlib no se presenta
como ausencia de axiomas: el perfil se conserva en el log de compilación.

Siguiente gate: probar `rowCertificate` o registrar un STOP reproducible. Solo
después puede instanciarse el puente de masa ponderada y comenzar la
conversión renewal completa.
