# F3 Real operator-to-functional bridge — informe v1

Estado: `REAL_OPERATOR_ITERATED_MASS_BRIDGE_PASS_ORIENTATION_OPEN`.

El módulo prueba en `ℝ`, para un tipo finito arbitrario de estados, la
identidad de masa tras un push-forward y la implicación:

```text
∀s, (1+δ)·w_s ≤ Σ_t M_s,t·w_t
  ⟹ (1+δ)·Σ_s μ_s w_s
        ≤ Σ_t (Σ_s μ_s M_s,t) w_t.
```

También verifica preservación de no-negatividad para `M`, `μ` y el funcional
ponderado. Esta es la interfaz algebraica que faltaba entre las desigualdades
member-wise y la secuencia de masas usada por el lema renewal.

El módulo separado `F3ReturnExcursionRealIterateBridge.lean` añade la
iteración finita de `push`, prueba que la no-negatividad se conserva en cada
nivel y demuestra, por inducción, la cota

```text
(1+δ)^n · weightedMass(w, μ)
  ≤ weightedMass(w, iteratePush(M, μ, n)).
```

Esta es la parte algebraica del lema de conversión renewal ya conectada con
una secuencia de operadores. La auditoría de axiomas termina limpia y no
introduce ninguna afirmación sobre la matriz F3 concreta.

## Límite

El teorema está parametrizado por `M` y `w`; la representación exacta de 243
estados ya está custodiada, pero la auditoría de orientación mostró que el CSV
congelado usa `w^T M` mientras que la interfaz fuente→destino usa `M w`.
La reparación transpuesta está definida en
`F3ReturnExcursionExactCoreMatrixOrientation.lean`, sin afirmar todavía la
desigualdad numérica. El siguiente paso es fijar esa convención y probar el
certificado member-wise sobre las entradas exactas.

No se declara certificado de `rho`, densidad ni Collatz global.
