# F3 boundary-to-renewal leakage — informe v1

Estado: `ABSTRACT_BOUNDARY_BUDGET_TO_LEAKAGE_PASS_F3_INSTANTIATION_OPEN`.

El módulo prueba en `Real` la interfaz exacta:

```text
boundary ≤ ε · root
root − boundary ≤ retained
(1−q)Lq^n ≤ (1−ε) · root
retained ≤ stopped(n+1) − stopped(n)
------------------------------------------------
(1−q)Lq^n ≤ stopped(n+1) − stopped(n)
```

La especialización `qStar` alimenta directamente el
`LeakageCertificate` y por tanto la cota renewal `L(1-qStar^n) ≤ stopped(n)`.
Los denominadores aparecen explícitamente; no hay descuento agregado oculto.

## Límite

El teorema sigue siendo abstracto: falta demostrar las cuatro hipótesis para
las fibras concretas de los caminos F3, incluyendo la cota de frontera. No
declara certificado de `rho`, densidad ni resultado global.
