# F3 Density Capture Gate v1 — paquete de custodia

Este paquete conserva el expediente recibido y añade una primera reducción
auditada de E5. No contiene los cuatro scripts originales de E1–E5, porque no
fueron entregados ni aparecen en el workspace accesible.

Contenido:

- `F3_DENSITY_CAPTURE_GATE_SOURCE_v1.md`: texto fuente custodiado.
- `F3_SUM_INEQUALITY_PAPER_PAGE_v0_1.md`: página-de-papel y contrato de
  aceptación; estado abierto, sin autorización Lean.
- `F3_AUDIT_FINDINGS_v1_1.md`: calibración final de claims E1–E5 y blocker
  estructural actualizado.
- `F3_CLAUDE_REVIEW_PACKET_v1.md`: relevo autocontenido para revisión externa.
- `F3_CLAUDE_REVIEW_PACKET_v2.md`: relevo actualizado con invalidación V1 y
  holdout global V2.
- `F3_THREE_LIFT_BALANCE_PILOT_REPORT_v2.md`: dictamen local del piloto.
- `F3_PUBLIC_CUSTODY_STATUS_v1.md`: bloqueo de publicación y acción requerida.
- `scripts/f3_e5_memberwise_gap_audit_v1.py`: réplica y descomposición exacta
  del cociente E5.
- `scripts/f3_affine_type_closure_audit_v1.py`: auditoría de cierre por tipos;
  confirma la obstrucción de tres lifts para todo módulo fijo ensayado.
- `scripts/f3_three_lift_balance_pilot_v1.py`: corrida preservada e invalidada
  por intersección global entre fases.
- `scripts/f3_three_lift_balance_pilot_v2.py`: split global corregido, contrato
  congelado y holdout válido local.
- `results/`: outputs y manifiestos por escala.

Ejecución de referencia desde esta carpeta:

```bash
python3 scripts/f3_e5_memberwise_gap_audit_v1.py
```

La ejecución por defecto reproduce:

```text
closure_percent = 99.90133005356739
memberwise mismatches = 0
```

Estado de custodia:

```text
SOURCE_DOSSIER_CUSTODIED
ORIGINAL_FOUR_F3_SCRIPTS_NOT_INGESTED
NEW_E5_MEMBERWISE_AUDIT_ADDED
FIXED_MODULUS_TYPE_CLOSURE_AUDIT_ADDED
FIXED_MODULUS_D1_D3_NONCLOSURE_CONFIRMED
PAPER_GATE_OPEN
CLAUDE_REVIEW_PACKET_READY
NO_LEAN
```
