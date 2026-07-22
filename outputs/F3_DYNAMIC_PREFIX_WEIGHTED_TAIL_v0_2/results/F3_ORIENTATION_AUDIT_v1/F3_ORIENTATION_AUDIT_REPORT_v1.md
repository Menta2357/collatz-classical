# F3 matrix orientation audit — informe v1

Estado: `ORIENTATION_CONVENTION_REOPENED`.

## Hallazgo

La matriz generada por las aristas fuente→destino usa la convención
`M[source,target]`. Con esa convención, el puente Lean de masa ponderada y la
ecuación de la página requieren la acción derecha `M*w`:

```text
(1+delta) w_s <= sum_t M[s,t] w_t.
```

El CSV de congelamiento, en cambio, fue calculado con `w^T*M` (acción
izquierda). La diferencia no es notacional: al evaluar ambas acciones sobre
los mismos 243 estados se obtiene:

```text
right M*w:  min ratio = 0.2006213084, 135 fallos
left  w^T*M: min ratio = 1.0295828177, 0 fallos
```

La identidad algebraica de la reparación es exacta:
`(Mᵀ)*w = wᵀ*M`. Por tanto hay dos convenciones legítimas, pero el documento,
el checker y el módulo Lean deben elegir la misma antes de llamar a cualquier
certificado. No se reutiliza el PASS izquierdo como si fuera el PASS derecho.

El módulo `F3ReturnExcursionExactCoreMatrixOrientation.lean` deja ambas
convenciones explícitas: `coreTransition s t := coreMatrix t s`, y demuestra
por reducción definicional que el certificado izquierdo equivale al certificado
derecho del operador transpuesto. Sigue sin afirmar ninguna de las dos
desigualdades.

Además, el módulo compila la interfaz `exact_core_weighted_mass_step`: dado el
certificado izquierdo como hipótesis, el puente Real entrega el crecimiento de
masa para `coreTransition`. La hipótesis sigue siendo explícita; no se ha
convertido el resultado numérico en una prueba.

## Veredicto

`STOP_ORIENTATION_CONVENTION`.

El objeto finito sigue estando definido y compilado, pero la instancia del
puente de masa queda abierta hasta que se haga una de estas reparaciones y se
reverifique todo:

1. conservar la dinámica fuente→destino y transponer explícitamente la matriz
   en el funcional/puente; o
2. redefinir `M` con filas destino y columnas fuente, actualizar el contrato y
   demostrar la desigualdad en esa convención.

La reparación no puede consistir en copiar los decimales del CSV: la tabla es
una auditoría numérica, no una prueba Lean. Se conservan ambos resultados para
que el cambio sea trazable.

No se declara certificado de `rho`, teorema de densidad, claim “almost all” ni
resultado global de Collatz.
