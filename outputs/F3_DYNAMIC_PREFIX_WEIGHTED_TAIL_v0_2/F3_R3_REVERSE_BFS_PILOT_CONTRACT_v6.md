# F3 R3 reverse-BFS six-row pilot contract v6

Date: 2026-07-26

## 0. Status and authority boundary

```text
DOCUMENT_CLASS = ADOPTION_CANDIDATE_BYTES
CANONICAL_TARGET = F3_R3_REVERSE_BFS_PILOT_CONTRACT_v6.md
ADOPTION_TRANSACTION_ROLE = POSTIMAGE_CANDIDATE
EXTERNAL_ADOPTION = NOT_EFFECTIVE_UNTIL_POSTWRITE_FREEZE
COORDINATED_FREEZE = REQUIRED_AFTER_7_OF_7_READBACK
EXECUTION_AUTHORITY = NONE
GO_FOR_P0 = NO
LEAN_EXECUTION = NONE
BFS_EXECUTION = NONE
EXTERNAL_WORKTREE_MUTATION = NONE

GENERIC_BRANCH_COMPLETE_PILOT = KERNEL_CHECKED_ISOLATED
TYPED_BRANCH_COMPLETE_ADOPTION = PENDING
EXACT_CARDINAL_COMPLETENESS_6_OF_6 = REQUIRED_PREREQUISITE
ROW_SELECTION_CLASSIFICATION = SIX_FIXED_PREDECLARED_ROWS
FINITE_MAXIMUM_SELECTION_CERTIFIED = NO
```

Estos bytes candidatos se derivan únicamente del contrato coordinado v5 y de
los diseños y pilotos aislados locales. No reemplazan v5, no modifican el
carril coordinado y no autorizan `B0`, `R0`, `P0`, ninguna generación ni
ninguna búsqueda reverse-BFS. Solo adquieren autoridad operativa mediante
adopción explícita, revisión y freeze dentro del carril coordinado.

## 1. Sucesión y alcance exacto

El futuro v6 debe suceder estrechamente a
`F3_R3_REVERSE_BFS_PILOT_CONTRACT_v5.md` y preservar de v5:

- la semántica owner-preserving de masa retenida y frontera;
- la precedencia terminal `INVALID > STOP acotado o PASS de seis filas`;
- los tres tokens terminales machine-facing ya existentes;
- la prohibición de promover seis filas a 452 o 1620 owners;
- las reglas de custodia, recibos, recursos e intentos;
- la máquina de estados completa.

La máquina normal permanece:

```text
B0 -> R0 -> P0 -> G01 -> G02 -> G03 -> G04 -> G05 -> G06
   -> S0 -> P1 -> V0 -> A0 -> F0
```

El primer estado `INVALID` sigue cerrando todas las fases normales aún no
iniciadas y solo permite el sucesor de custodia `C0` ya definido por el
contrato anterior.

V6 debe introducir únicamente estas tres correcciones de interfaz:

1. aceptación branch-complete: todo certificado aceptado queda clasificado
   como saturado o deficiente, nunca como error de elaboración por ser
   deficiente;
2. calibración de selección: las filas son seis filas fijas predeclaradas,
   sin inferencia de maximalidad o de control;
3. completitud cardinal: la precondición de `Completeness` pasa a ser un
   inventario público y auditado de `6/6` declaraciones.

## 2. Significado matemático inmutable de cada fila

Para un owner seleccionado `p`, se fija:

```text
D(p) = massDemand p
m(p) = card (orderedFirstHitFiber0 p)
Q(p) = activeContribution p
```

Un certificado válido tiene exactamente una de dos ramas.

### 2.1 Rama saturada

```text
cert.kind = saturated
D(p) <= m(p)
```

La rama prueba capacidad suficiente solo para ese owner congelado.

### 2.2 Rama deficiente

```text
cert.kind = deficient
orderedFirstHitFiber0 p = (nodeValues cert.nodes).toFinset
m(p) = cert.nodes.length
m(p) < D(p)
```

Esta rama es un resultado matemático válido y custodiable, no un fallo de
Lean, del checker ni del protocolo. Conserva exactamente

```text
m(p) * Q(p) / D(p)
```

y entrega a la futura contabilidad de frontera

```text
(D(p) - m(p)) * Q(p) / D(p).
```

En particular, `D(p)=2` y `m(p)=1` conserva un átomo y carga `Q(p)/2` a la
frontera. V6 no autoriza ejecutar ni agregar esa contabilidad posterior.

## 3. Aceptación branch-complete obligatoria

El futuro `F3ReturnExcursionBlock0ReverseBFSPilotV3.lean` debe exponer una
interfaz tipada equivalente a:

```lean
inductive VerifiedTypedReverseBFSOutcome
    (p : Active0Occurrence) (cert : ReverseBFSCertificate) : Prop
  | saturated
      (hkind : cert.kind = .saturated)
      (hcapacity :
        massDemand p <= (orderedFirstHitFiber0 p).card)
  | deficient
      (hkind : cert.kind = .deficient)
      (hfiber :
        orderedFirstHitFiber0 p =
          (nodeValues cert.nodes).toFinset)
      (hcard :
        (orderedFirstHitFiber0 p).card = cert.nodes.length)
      (hshort :
        (orderedFirstHitFiber0 p).card < massDemand p)

theorem verifiedTypedReverseBFSOutcome_of_check
    {p : Active0Occurrence} {cert : ReverseBFSCertificate}
    (hcheck : verifyTypedReverseBFSCertificate p cert = true) :
    VerifiedTypedReverseBFSOutcome p cert
```

Para cada fila fija deben existir y quedar auditadas las parejas:

```text
fixedRow01_check ... fixedRow06_check
fixedRow01_outcome ... fixedRow06_outcome
```

La rama saturada debe derivarse del teorema tipado de capacidad. La rama
deficiente debe convertir el check tipado al checker genérico y consumir los
tres hechos exactos: igualdad de fibra, igualdad cardinal-longitud y déficit
estricto.

El piloto genérico aislado ya muestra que esta partición es coherente, pero
no sustituye el wrapper tipado ni su audit en el carril coordinado.

## 4. Clasificación terminal branch-complete

Los tokens machine-facing permanecen:

```text
INVALID_R3_REVERSE_BFS_PILOT_V3
STOP_R3_REVERSE_CAPACITY_COUNTEREXAMPLE_V3
PASS_R3_REVERSE_BFS_PILOT_V3_6_OF_6
```

Su significado obligatorio en v6 es:

```text
INVALID_R3_REVERSE_BFS_PILOT_V3
  = NON_MATHEMATICAL_INVALID

STOP_R3_REVERSE_CAPACITY_COUNTEREXAMPLE_V3
  = AT_LEAST_ONE_CHECKER_ACCEPTED_DEFICIENT_ROW
  = SIX_ROW_SATURATION_STOP
  = FULL_CAPACITY_SUBROUTE_STOP
  = NO_F3_STOP

PASS_R3_REVERSE_BFS_PILOT_V3_6_OF_6
  = SIX_CHECKER_ACCEPTED_SATURATED_ROWS
  = SIX_OWNER_SATURATION_PASS
```

Un certificado deficiente válido no puede producir
`NON_MATHEMATICAL_INVALID`. `INVALID` queda reservado a drift, checker
rechazado, manifiesto o recibo inválido, error, timeout, memoria, audit
incompleto o certificado mal formado.

Los rótulos desnudos `MATHEMATICAL_STOP`, `CAPACITY_COUNTEREXAMPLE` y
`F3_STOP` están prohibidos para describir una deficiencia válida. El STOP
histórico solo es legal junto a los tres calificadores acotados anteriores.

## 5. Downgrade obligatorio de la selección

Hasta que exista un teorema Lean específico de maximalidad y desempate:

```text
ROW_SELECTION_CLASSIFICATION = SIX_FIXED_PREDECLARED_ROWS
FINITE_MAXIMUM_SELECTION_CERTIFIED = NO
NO_EXTREMALITY_INFERENCE_FROM_LEGACY_ROW_ID
```

Las seis filas y su orden quedan congelados:

| Orden | ID canónico | Demanda | Hijo | Ventana | ID histórico solamente |
|---:|---|---:|---:|---:|---|
| 1 | `FIXED_ROW_01_RET_D2` | 2 | 308 | 19712 | `RET_D2_MAX` |
| 2 | `FIXED_ROW_02_RET_D1` | 1 | 152 | 9728 | `RET_D1_CONTROL` |
| 3 | `FIXED_ROW_03_DIRECT_D2` | 2 | 107 | 41088 | `DIRECT_D2_MAX` |
| 4 | `FIXED_ROW_04_DIRECT_D1` | 1 | 155 | 59520 | `DIRECT_D1_CONTROL` |
| 5 | `FIXED_ROW_05_LIFT_D2` | 2 | 182 | 34944 | `LIFT_D2_MAX` |
| 6 | `FIXED_ROW_06_LIFT_D1` | 1 | 902 | 173184 | `LIFT_D1_CONTROL` |

Los identificadores históricos pueden preservarse solo como
`legacyRowId`. No justifican “máximo”, “control más cercano”, “peor caso” ni
representatividad estadística.

## 6. Prerrequisito cardinal exacto 6/6

Antes de crear o congelar cualquier fuente PilotV3, el carril coordinado
debe adoptar la transacción cardinal exacta en:

```text
F3ReturnExcursionBlock0ReverseBFSCompleteness.lean
F3ReturnExcursionBlock0ReverseBFSCompletenessAxiomAudit.lean
```

La aceptación exige simultáneamente:

```text
COMPLETENESS_PUBLIC_ROOTS = 6/6
EXACT_FIBER_CARDINAL_EQUALITY = PRESENT
EXACT_NODE_LENGTH_EQUALITY = PRESENT
LEAN_BUILD = PASS
AXIOM_AUDIT = PASS_6_OF_6
sorryAx = ABSENT
Lean.ofReduceBool = ABSENT
```

Las únicas dependencias axiomáticas permitidas son las explícitamente
admitidas por el perfil coordinado. Un piloto aislado o un parche aplicable
no cuentan como adopción ni como audit fresco.

Si el inventario permanece `4/4`, si falta cualquiera de los dos puentes
cardinales, o si el audit no imprime las seis raíces públicas, el veredicto
es:

```text
STOP_BEFORE_P0
NO_MATHEMATICAL_MEANING
```

## 7. Objetos de pre-ejecución requeridos

La preimagen coordinada de
`F3ReturnExcursionBlock0ReverseBFSMassIntegration.lean`, SHA
`acfc297269b3269e62c0178d23f0e660f2bda0af3af8dbcb813dc82dca7c18b0`,
importa directamente `F3ReturnExcursionBlock0MassDemandProfile` (monolítico).
Estos bytes v6 solo pueden adoptarse dentro de la misma transacción atómica
que sustituye ese import por `F3ReturnExcursionBlock0MassDemandProfileSharded`
y produce el postimage SHA
`d1299e61e8074af271f2a4c4eef1baf2eedede950a8c1a6b9a753f504729eb7b`,
85 líneas.

La adopción textual y su readback eliminan el monolito del cono requerido,
pero no prueban compatibilidad semántica. Esa obligación solo se descarga con
un build y audit frescos:

```text
MASS_INTEGRATION_IMPORT_REBASE_IN_SAME_TRANSACTION = REQUIRED
MASS_INTEGRATION_POSTIMAGE_SOURCE_ONLY = d1299e61e8074af271f2a4c4eef1baf2eedede950a8c1a6b9a753f504729eb7b
SHARDED_ROUTE_REQUIRED_OBJECT_COUNT = 8
FRESH_BUILD_AND_AXIOM_AUDIT_REQUIRED = YES
```

Antes de `P0` deben existir, quedar revisados y congelados por ruta, SHA-256
y número de líneas:

1. contratos v1–v6;
2. `F3_R3_EXECUTION_REGISTRY_v10.md`;
3. templates normal e inválido que reproduzcan las dos ramas legales;
4. los siete inputs PilotV3;
5. fuentes, audits y `.olean` frescos de todos los prerrequisitos;
6. recibos y trazas de `B0` y `R0`;
7. comandos, entorno, herramientas y base Git exactos.

Los dos templates y todas las superficies públicas deben contener:

```text
SIX_FIXED_PREDECLARED_ROWS
FINITE_MAXIMUM_SELECTION_CERTIFIED = NO
```

Quedan prohibidos `PENDING` como sustituto de hash, líneas o identidad,
globs, “current registry”, “all templates” o rutas nominales ambiguas dentro
del freeze. `PENDING` sigue siendo legal para describir una adopción o
autoridad aún no realizada. Los artefactos generados se congelan después de
`G01`–`G06` en `S0/P1`, no se anticipan dentro del manifiesto de entrada.

## 8. Secuencia segura y no permutable

```text
1. Adoptar en una transacción atómica los dos targets exact-cardinales, el
   rebase shardeado de `MassIntegration`, contrato v6, registry v10 y ambos
   templates.
2. Leer de vuelta, revisar y congelar los siete postimages, todavía con
   autoridad de ejecución `NONE`.
3. Recompilar y auditar Completeness `6/6`,
   `MassDemandProfileSharded`, `MassIntegration` y los demás prerrequisitos.
4. Crear los siete inputs PilotV3 con aceptación branch-complete.
5. Completar el wrapper tipado y toda la cadena de imports.
6. Auditar fuentes y `.olean` frescos; resolver cero hashes obsoletos.
7. Ejecutar B0 y exigir B0=PASS.
8. Ejecutar R0 y exigir R0=PASS.
9. Abrir P0 solo con el manifiesto cerrado y exacto.
10. Ejecutar secuencialmente G01...G06.
11. Ejecutar S0, P1, V0, A0 y F0 sin saltos.
```

No se autoriza iniciar una fase normal si la anterior no terminó en PASS.
La aplicación del parche cardinal por sí sola no autoriza PilotV3 ni BFS.

## 9. Contrato GO/STOP previo a P0

`GO_FOR_P0` requiere simultáneamente:

- exact-cardinal adoptado y auditado `6/6`;
- aceptación branch-complete tipada implementada y auditada;
- `MassDemandProfile` y wrapper tipado compilados con objetos frescos;
- `MassIntegration` rebasado a la ruta shardeada, rehasheado, compilado y
  auditado;
- seis filas y orden idénticos a la tabla congelada;
- clasificación `SIX_FIXED_PREDECLARED_ROWS` idéntica en fuente, contrato,
  registry y templates;
- registry v10 sin hashes anteriores ni referencias nominales ambiguas;
- dos templates presentes y prehashados;
- siete inputs PilotV3 presentes, estáticamente auditados y congelados;
- base Git, herramientas, comandos, recursos y política de intentos fijados;
- cero `PENDING` en campos de evidencia, globs, drift o proceso pesado
  concurrente;
- `B0=PASS` y `R0=PASS`.

Cualquier ausencia produce:

```text
STOP_BEFORE_P0
NON_MATHEMATICAL_STOP
NO_RETRY_OR_EXPANSION_WITHOUT_NEW_CONTRACT
```

Una vez abierto P0, cualquier ruptura de custodia produce `INVALID`, nunca
un resultado matemático. Solo seis checks aceptados pueden alcanzar PASS o
STOP acotado.

## 10. Límite del resultado y NO-claims

El máximo resultado positivo de este contrato es la saturación de las seis
filas fijas. El máximo resultado negativo es una deficiencia exacta y
checker-aceptada que obstruye únicamente la subruta de saturación completa
de esas seis filas, reteniendo su masa válida.

Ningún resultado v6 prueba o autoriza afirmar:

```text
NO_RESIDUAL_D2_452_RESULT
NO_BLOCK0_FULL_CAPACITY_RESULT
NO_WEIGHTED_BOUNDARY_MARGIN_RESULT
NO_RHO_CERTIFICATE
NO_RHO_2_PROGRESS_CLAIM
NO_F3_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
```

La ejecución de los 452 owners restantes, una agregación de frontera, un
certificado de `rho=9/5`, cualquier paso hacia el punto crítico `rho=2` o una
afirmación de densidad requieren contratos posteriores independientes.

## 11. Veredicto de estos bytes candidatos

```text
DOCUMENT_CLASS = ADOPTION_CANDIDATE_BYTES
V6_ADOPTION_CANDIDATE_CONTENT = READY_FOR_COORDINATED_REVIEW
BRANCH_COMPLETE_ACCEPTANCE = SPECIFIED
ROW_SELECTION_DOWNGRADE = SPECIFIED
EXACT_CARDINAL_6_OF_6_PREREQUISITE = SPECIFIED
PHASE_SEQUENCE = PRESERVED
NO_CLAIMS = PRESERVED

ADOPTION_TRANSACTION_ROLE = POSTIMAGE_CANDIDATE
EXTERNAL_ADOPTION = NOT_EFFECTIVE_UNTIL_POSTWRITE_FREEZE
COORDINATED_FREEZE = REQUIRED_AFTER_7_OF_7_READBACK
EXECUTION_AUTHORITY = NONE
GO_FOR_P0 = NO
LEAN_EXECUTION = NONE
BFS_EXECUTION = NONE
```

La revisión coordinada debe comprobar que este texto no contradice la
máquina de estados, recibos, recursos ni política de intentos de v4/v5 antes
de promoverlo a un contrato v6 autoritativo.
