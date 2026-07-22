# F3_LEAN_M0_v1 — presupuesto y contrato de ejecución

Estado: AUTORIZADO POR EL USUARIO; ejecución acotada y `STOP_AND_RECORD`.

Fecha de congelación: 2026-07-22.

## Base y alcance

La base congelada es el commit completo:

```text
98d073a07e6be26d9748049f353605579847b0e4
```

La ejecución se realiza únicamente en `codex/f3-density-capture-gate`.
No se modifica `master`, no se toca el paquete KL2003 k=11 y no se incorporan
artefactos K9/K11 ajenos a F3.

### M0-a autorizado (completo)

Se intenta el certificado computable del operador F3, en el patrón
`data + checker`:

1. las entradas regla-derivadas del operador split-edge congelado;
2. las 243 desigualdades de la supersolución racional del tilt;
3. la enumeración decidible del lema `N_block = 243`;
4. la re-verificación exacta de las desigualdades racionales congeladas;
5. una auditoría de axiomas del módulo y una separación explícita entre
   certificado del operador y cualquier teorema de densidad.

M0-a no formaliza la conversión renewal completa. Un `PASS` de M0-a no es
un certificado de `rho`, ni un teorema de densidad, ni un resultado de
Collatz.

### M0-b autorizado (piloto limitado)

Solo se intenta un esqueleto piloto de la conversión, con una pieza aislada
del telescopado del Lema V. Quedan fuera del alcance autorizado el desarrollo
completo de Chernoff/renewal, uniformidad no pagada y cualquier reclamación
formal sobre `rho★`.

## Presupuesto congelado

```text
M0A_CERTIFICATE_AUTHORIZED       = true
M0A_BUDGET_SECONDS               = 1800
M0A_MAX_SHARD_SECONDS            = 300
M0A_SHARD_COUNT                   = 9
M0B_PILOT_AUTHORIZED             = true
M0B_PILOT_BUDGET_SECONDS        = 600
M0B_FULL_AUTHORIZED              = false
GLOBAL_PHASE_CAP_SECONDS        = 2400
FAILURE_POLICY                   = STOP_AND_RECORD
```

Los 1800 segundos de M0-a y los 600 del piloto M0-b son compartimentos
independientes dentro del tope global de 2400 segundos. No hay
`cross-subsidy`: una fase que termina antes no autoriza ampliar la otra.

## Gate ambiental obligatorio

Antes del primer comando Lean se registra un precheck de disco, memoria y
toolchain. El mínimo de disco libre exigido es 12 GiB, siguiendo el incidente
documentado de k=11. Si el precheck no permite medir un recurso, o el sistema
rechaza la asignación durante la corrida, se registra `STOP_AND_RECORD`.
La memoria física y la presión observada se consignan como datos del entorno,
no como hipótesis matemática.

## Gates de aceptación

M0-a solo puede etiquetarse `PASS` si compila dentro de su presupuesto,
re-verifica todas las filas declaradas, no usa `sorry`, y su auditoría de
axiomas se conserva junto al resultado. El resultado se etiqueta
`CERTIFICATE_CHECKER_ONLY`.

El piloto M0-b solo puede etiquetarse `PASS_PILOT` si la pieza aislada compila
dentro de 600 segundos y su salida identifica exactamente qué parte se
probó. Un éxito piloto no abre M0-b completo.

Todo timeout, falta de recurso, fallo de compilación, mismatch o expansión de
alcance produce `STOP_AND_RECORD`; no se reintenta silenciosamente ni se
declara un resultado positivo por agregación parcial.

## Perfil de claims prohibidos

```text
NO_RHO_CERTIFICATE    = true
NO_DENSITY_THEOREM    = true
NO_GLOBAL_COLLATZ_CLAIM = true
```

También permanecen vigentes `NO_ALMOST_ALL` y `NO_LEAN` para cualquier parte
no ejecutada. En particular, el Lean autorizado aquí es un experimento
M0 acotado, no la formalización del candidato F3 completo.

## Custodia

Este documento, el precheck, los scripts ejecutados, sus salidas, hashes y
auditorías se guardan en el paquete F3. Los resultados históricos no se
sobrescriben. El commit de cierre será local a la rama hasta que exista una
decisión explícita de publicación.
