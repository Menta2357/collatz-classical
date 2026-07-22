# F3 Real operator-to-functional bridge — informe v1

Estado: `REAL_OPERATOR_ROW_MASS_BRIDGE_PASS_INSTANTIATION_OPEN`.

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

## Límite

El teorema está parametrizado por `M` y `w`; todavía no instancia la matriz
real de 243 estados a partir del CSV ni prueba la conversión global de
`piStar`. El siguiente paso es conectar esta interfaz con el inventario
semántico y una representación exacta de las entradas congeladas.

No se declara certificado de `rho`, densidad ni Collatz global.
