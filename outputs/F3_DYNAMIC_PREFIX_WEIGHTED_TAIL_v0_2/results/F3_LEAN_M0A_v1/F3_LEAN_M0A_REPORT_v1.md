# F3 Lean M0-a — informe de ejecución v1

Estado: `PASS_CERTIFICATE_CHECKER_ONLY`.

## Base y presupuesto

```text
base_commit = 98d073a07e6be26d9748049f353605579847b0e4
authorized_budget_seconds = 1800
measured_certificate_compile_seconds = 16.39
measured_axiom_audit_exit = 0
failure_policy = STOP_AND_RECORD
```

El módulo se generó desde los CSV congelados mediante
`f3_lean_m0_generate_certificate.py`; no se introdujeron filas a mano.

## Comprobaciones exactas

```text
supersolution_rows = 243
supersolution_rows_pass = true
positive_vector_rows = true
split_edges = 1215
split_edges_valid = true
channel_retarded = 729
channel_advanced_direct_c2 = 243
channel_advanced_parity_lift_c1 = 243
channel_sterile_tail = 0
N_block = 3^5 = 243
frozen_vector_hash = 55b2288824dccfe56fcb3a951bdfb47583ac7d4abd00576ed7c273448b2a777a
frozen_weight_hash = 580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40
```

La ausencia de aristas estériles es intencional y coincide con D2: el canal
estéril está fuera de la matriz split-edge y se trata como undercount gratuito
para la cota inferior. No se lo convierte en una carga del certificado.

## Ledger de ejecución

El primer intento del checker alcanzó 17.28 s y se detuvo por dos defectos de
implementación del propio checker: profundidad de recursión insuficiente y una
cuantificación universal sobre una estructura infinita sin instancia
decidible. No hubo mismatch de datos. La reparación reemplazó ambas
cuantificaciones por `List.all` booleano sobre las listas finitas congeladas;
la corrida aceptada posterior tardó 16.39 s y pasó.

## Auditoría de axiomas

La auditoría enumera `propext` solo para la identidad `N_block` basada en
`norm_num`; las comprobaciones finitas de listas y desigualdades no dependen
de axiomas. El perfil permitido para M0-a queda documentado como
`[propext, Classical.choice, Quot.sound]`, sin `sorryAx`.

## Alcance y no-claims

Este resultado es un comprobador finito de certificado (`data + checker`). No
es una prueba de que exista una tasa `rho`, no formaliza la conversión renewal
y no declara teorema de densidad, resultado almost-all ni teorema global de
Collatz.
