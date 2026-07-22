# F3 M0-b Real — subgate de instancia exacta v1

Estado: `OPEN_EXACT_OPERATOR_INSTANCE`.

Base: `1c460a4d76ab22944fae9498f5ad48a271d3db58`.

## Alcance

Representar en Lean, sin convertir aproximaciones decimales en igualdades,

```text
M_split : Fin 243 → Fin 243 → ℝ
w_core  : Fin 243 → ℝ
```

usando los 729 edges core congelados y los pesos exactos de canal con
`rho★ = 9/5` y `alpha = log 3 / log 2`. El subgate incluye solo la definición,
conteo, finitud y no-negatividad. La desigualdad member-wise numérica queda
como obligación explícita si no se puede derivar de una entrada exacta.

## Presupuesto

```text
OPERATOR_INSTANCE_BUDGET_SECONDS = 600
MAX_SINGLE_COMMAND_SECONDS = 300
RATIONAL_M0A_BUDGET_TOUCHED = false
FAILURE_POLICY = STOP_AND_RECORD
```

Un `PASS` no es un certificado de `rho`; solo demuestra que la matriz y el
vector están definidos desde datos congelados y pueden alimentar el puente
Real. Un `STOP` conserva los artefactos anteriores.

## No-claims

```text
NO_RHO_CERTIFICATE = true
NO_DENSITY_THEOREM = true
NO_GLOBAL_COLLATZ_CLAIM = true
NO_F3_THEOREM = true
```
