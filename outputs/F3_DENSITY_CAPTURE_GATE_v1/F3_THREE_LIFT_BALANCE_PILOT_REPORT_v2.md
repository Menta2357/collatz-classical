# F3 — informe del piloto de balance entre tres lifts v2

Fecha: 2026-07-21.

## Estado

```text
V1_HOLDOUT_INVALIDATED
V2_GLOBAL_PARENT_SPLIT_VALID
V2_CALIBRATION_HOOKS_PASS
V2_HOLDOUT_HOOKS_PASS
UNIFORM_USEFUL_LIFT_BALANCE_STOP
DYNAMIC_PREFIX_WITH_CERTIFIED_TAIL_REMAINS_OPEN
FORMAL_COORDINATED_VERDICT_PENDING_PUBLIC_CUSTODY
NO_LEAN
```

## 1. Disciplina de holdout

V1 usó cocientes separados por módulo y contaminó 192 raíces padre entre
calibración y holdout. La corrida se conserva, pero su veredicto fue anulado
antes de diseñar V2.

V2 mantuvo tipos, escalas y umbrales; solo reemplazó el split por intervalos
globales disjuntos de la raíz padre:

```text
calibration = 1 <= a < 10369
holdout     = 10369 <= a < 20737
global parent-root intersection = 0
```

## 2. Contrato V2

```text
M = {36,108}
parent classes = {2,8}
y = {8,9,10}
freeze = floor_0.001(max(0, min_calibration_share - 0.02))
utility floor = 0.200
```

Hash del contrato congelado antes de holdout:

```text
8b61fb8c07c990f27005f6ba1e4962213d9df54fd0aeb755715fc49fa27ecb21
```

## 3. Calibración

```text
unique parent roots       = 2,304
member-wise rows          = 13,824
hook mismatches           = 0
minimum advanced share    = 0.0536199288054
frozen beta               = 0.033
utility beta >= 0.200     = FAIL
```

La utilidad ya fallaba, pero el holdout se ejecutó sin modificar el contrato.

## 4. Holdout válido

```text
unique parent roots       = 2,304
member-wise rows          = 13,824
hook mismatches           = 0
minimum advanced share    = 0.0899611736754
minimum location          = M=108, class=2, residue=74, lift=2, y=8
minimum >= frozen beta    = PASS
utility beta >= 0.200     = FAIL
local verdict             = STOP_OR_REDESIGN
formal verdict            = PENDING_PUBLIC_CUSTODY
```

## 5. Distribución, no selección

No se eliminó ningún tipo después de mirar los datos.

| fase | tipos/escala | mínimo | mediana | `<0.10` | `<0.20` |
|---|---:|---:|---:|---:|---:|
| calibración | 96 | 0.05362 | 0.13771 | 33 | 67 |
| holdout | 96 | 0.08996 | 0.15609 | 15 | 86 |

Las sumas gruesas sobre todos los residuos pueden parecer balanceadas aunque
los tipos individuales no lo estén. En holdout, las cuotas agregadas por
\((M,\text{clase},y)\) quedaron aproximadamente entre 0.281 y 0.388, mientras
86 de 96 grupos tenían algún lift por debajo de 0.20. Esta es una realización
empírica directa del problema “suma buena / refinamiento malo”.

## 6. Exploración de cola posterior al veredicto

Esta sección es análisis exploratorio, no parte del gate prerregistrado.

Si se llama “thin” a un componente con share menor que 0.20 y se descarta toda
su masa advanced, la fracción descartada es:

```text
calibration aggregate exploratory tail = 0.09896
holdout aggregate exploratory tail     = 0.12814
holdout range by state                 = 0.10251 .. 0.16712
```

La cuenta no es un operador espectral y no debe compararse como teorema con
\(1-\lambda_{11}/2\). Sí muestra que “descartar toda la cola thin” no es una
continuación prudente: la arquitectura dinámica deberá recuperar, reponderar
o telescopar parte de esa masa.

## 7. Decisión matemática

El primero de los dos objetos nombrados queda detenido en su versión natural:

```text
NO_GO: uniform useful lower balance for every fixed type/lift
```

Sobrevive únicamente:

```text
dynamic 3-adic prefix + certified weighted tail
```

Su futura página de papel debe incluir un potencial o peso que permita que
tipos flacos existan sin exigirles una cota uniforme individual. No se
autoriza un nuevo barrido hasta especificar ese potencial y su ledger.

## 8. Límites

```text
FINITE_WINDOWS_ONLY
TWO_FIXED_MODULI_ONLY
THREE_SCALES_ONLY
NO_UNIFORM_BALANCE_LEMMA
NO_TAIL_BOUND
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_LEAN
```

