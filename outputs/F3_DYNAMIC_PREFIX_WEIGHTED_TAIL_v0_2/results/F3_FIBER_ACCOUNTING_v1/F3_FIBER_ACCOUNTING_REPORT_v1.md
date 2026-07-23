# F3 finite-fiber accounting — informe v1

Estado: `ABSTRACT_FIBER_DISJOINTNESS_PASS_RENEWAL_LEAKAGE_INSTANTIATION_OPEN`.

El módulo `F3ReturnExcursionFiberAccounting.lean` demuestra dos formas de la
contabilidad necesaria para el lema renewal:

```text
pairwise-disjoint fibers ⊆ root
  ⟹ Σ_i card(fiber_i) ≤ card(root)

injective embeddings with pairwise-disjoint images
  ⟹ Σ_i card(domain_i) ≤ card(root).

Además, la unión de las fibras y su frontera satisfacen la igualdad exacta

```text
Σ_i card(fiber_i) + card(root \ union_i fiber_i) = card(root).
```

Esta es la forma que puede alimentar una línea `Q_boundary` del contrato
renewal sin convertir una cota de frontera en una pérdida agregada oculta.
```

La prueba usa `Finset.card_biUnion` y no contiene datos F3, aproximaciones
numéricas ni hipótesis estadísticas. Es el ladrillo combinatorio que debe
alimentarse con las fibras de caminos detenidos.

## Límite

Todavía no se ha demostrado que las fibras concretas de los caminos F3 sean
disjuntas ni que su déficit produzca la desigualdad de
`LeakageCertificate`. Esa conexión sigue abierta y no se convierte en claim
de crecimiento.
