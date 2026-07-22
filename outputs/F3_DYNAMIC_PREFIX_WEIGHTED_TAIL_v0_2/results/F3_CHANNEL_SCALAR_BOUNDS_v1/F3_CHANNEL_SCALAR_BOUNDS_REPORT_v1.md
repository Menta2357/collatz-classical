# F3 scalar channel bounds — informe v1

Estado: `SCALAR_CHANNEL_BOUNDS_PASS_EXACT_DEFINITION_COMPATIBILITY_PASS_MATRIX_REDUCTION_OPEN`.

El módulo Lean `F3ReturnExcursionChannelBounds.lean` prueba, para
`rho★ = 9/5` y `alpha = log(3)/log(2)`:

```text
channelWeight 0 = 25/81
channelWeight 1 >= 469/1000
channelWeight 2 = channelWeight 1 / rho★
channelWeight 2 >= 13/50
```

La prueba usa únicamente desigualdades logarítmicas enteras y monotonía de
`Real.rpow`; no usa datos del CSV ni una aproximación decimal como igualdad.
El módulo compiló en 19.22 s. Una compilación combinada con los seis `#print
axioms` terminó con código 0 y mostró únicamente `[propext, Classical.choice,
Quot.sound]`; no aparece `sorryAx`.

## Límite

Estas cotas escalares todavía no se han conectado formalmente con las listas
de aristas de la matriz de 243 estados. El siguiente lema debe demostrar que
la acción izquierda congelada se reduce exactamente a las tres clases de
entrada (retarded, direct y lift). Hasta entonces el certificado
`leftCertificate` sigue abierto y no hay certificado de `rho` ni teorema de
densidad.

La compatibilidad nominal con las definiciones exactas sí está ahora
verificada por `F3ReturnExcursionExactCoreMatrixChannelBounds.lean`: las tres
cotas se reexpresan sobre `channelWeight`, `rhoStar` y `alpha` del módulo de
la matriz exacta. El módulo no afirma ninguna desigualdad de fila ni suma
sobre las 243 entradas; por eso esta conexión no cierra aún la reducción
combinatoria ni cambia el estado de `leftCertificate`.

La auditoría de axiomas del módulo de compatibilidad termina con código 0 y
solo `[propext, Classical.choice, Quot.sound]`; no aparece `sorryAx`.

No se declara resultado global de Collatz ni claim “almost all”.
