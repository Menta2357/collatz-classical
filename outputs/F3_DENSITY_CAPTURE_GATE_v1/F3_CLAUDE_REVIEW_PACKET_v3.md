# F3 — paquete de revisión coordinada v3

Estado: revisión provisional para custodia pública. Este documento no es un
certificado formal y no autoriza Lean.

## Veredictos provisionales

```text
V1_INVALIDATION = ACCEPT
V2_HOLDOUT_INTEGRITY = ACCEPT
UNIFORM_LIFT_BALANCE_ROUTE = STOP
DYNAMIC_PREFIX_WEIGHTED_TAIL = CONTINUE
N_BLOCK_ROUTE_II = READY_FOR_FINAL_REVIEW
FORMAL_VERDICT = PENDING_PUBLIC_CUSTODY
```

## Base auditada

V1 queda invalidado por solapamiento de 192 raíces padre entre fases. La
corrida se conserva como histórico y no se usa como evidencia de holdout.

V2 reemplazó el split por intervalos globales disjuntos y usó la raíz padre
como unidad. Tuvo 2304 raíces padre en calibración, 2304 en holdout, intersección
cero y 13824 filas por fase. La integridad del holdout pasa; el piso de utilidad
uniforme 0.200 falla y por eso la ruta de balance útil fijo queda detenida.

La continuación permitida es únicamente el prefijo 3-ádico dinámico con cola
ponderada certificable en papel. La etiqueta es `OPEN_PAPER_ONLY`, no un
resultado uniforme ni una certificación de tasa.

## N-block y split-edge

La ruta II usa el bloque completo `N_block = 3^6*(1/3) = 3^5 = 243`.
La enumeración frozen-state contiene 243 estados, 81 grupos de residuos y
tres estados de retícula por grupo; el audit miembro-a-miembro está listo para
revisión final.

El holdout split-edge ya consumido cubrió 13824 raíces padre, con cero
mismatches, `q_boundary = 0.015625`, presupuesto `0.0295828177` y razón
ponderada `1.0296185828 > 1`. Estos datos son validación empírica congelada;
el rango no se vuelve a ejecutar.

## Límites de reclamación

```text
NO_LEAN
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
```

El paper consolidado debe mantener separadas la evidencia empírica, las
desigualdades propuestas en papel y cualquier futura prueba formal. El
siguiente gate es la revisión final del paper; no es todavía una fase Lean.

## Fuentes

- `outputs/F3_DENSITY_CAPTURE_GATE_v1/F3_CURRENT_STATUS_v1.json`
- `outputs/F3_DENSITY_CAPTURE_GATE_v1/F3_AUDIT_FINDINGS_v1_1.md`
- `outputs/F3_DENSITY_CAPTURE_GATE_v1/F3_THREE_LIFT_BALANCE_PILOT_REPORT_v2.md`
- `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_COMBINED_LEDGER_v1_2_REPORT.md`
- `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_NBLOCK_MEMBERWISE_LEMMA_v1_REPORT.md`
- `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_RETURN_EXCURSION_SPLIT_EDGE_HOLDOUT_v1_REPORT.md`
