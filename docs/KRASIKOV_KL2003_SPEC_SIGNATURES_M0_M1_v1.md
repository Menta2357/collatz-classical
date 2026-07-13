# KRASIKOV_KL2003_SPEC_SIGNATURES_M0_M1_v1

Fecha: 2026-07-05.

Estado: SPEC-only. No contiene pruebas matematicas, no abre Lean, no registra
target y no reclama formalizacion.

Base:

- `docs/COORDINATED_VERDICT_2026_07_05_v1.md`
- `docs/KRASIKOV_M1_FEASIBILITY_RECONSTRUCTION_REPORT_v1.md`
- `docs/KL2003_FEASIBILITY_AUDIT_v1.md`

## Clasificacion

```text
SPEC_SIGNATURES_OPENED
NO_MATHEMATICAL_PROOF_CLAIMED
RATIONAL_INTERVAL_POLICY_SCOPED
INTERIOR_RATIONAL_LP_POINT_REQUIRED
KL2003_ERRATA_TABLE_SCOPED
REGISTER_KL2003_BEFORE_FIRST_M0_PROOF
```

## Regla de lectura

Todo nombre de esta nota es una firma de especificacion. Una firma `SPEC` fija
la forma esperada de un futuro objeto formal, ledger o verificador, pero no
afirma que el objeto exista todavia ni que satisfaga sus propiedades.

Convenciones:

- `NatPos`: entero positivo.
- `RatPos`: racional positivo.
- `ResidueMod q`: clase de residuos modulo `q`.
- `FiniteSet A`: conjunto finito de elementos de tipo `A`.
- `Count S`: cardinal finito de `S`.
- `SPEC theorem`: enunciado objetivo futuro, sin prueba en esta fase.
- `SPEC verifier`: contrato de un verificador futuro, no implementacion.

## M0/M1 scope

M0 define el marco: arbol inverso, conteos, residuos, filas de desigualdad,
LP retarded y puente certificado -> cota inferior.

M1 instancia el marco en el caso pequeno `k=2` reconstruido desde KL2003 como
`M1 surrogate`. No se cita Krasikov1989 como fuente primaria.

## SPEC: dinamica e inverse tree semantics

```text
SPEC signature T : NatPos -> NatPos
```

Contrato: `T(n) = n/2` si `n` es par, y `T(n) = (3n+1)/2` si `n` es impar.

```text
SPEC signature inversePredecessors : NatPos -> FiniteSet NatPos
```

Contrato esperado:

```text
inversePredecessors(z) =
  {2*z} union
  { (2*z - 1)/3 : 3 divides (2*z - 1) and (2*z - 1)/3 >= 1 }.
```

```text
SPEC signature boundedInverseTree : root:NatPos -> bound:NatPos -> FiniteSet NatPos
```

Contrato: nodos `n <= bound` que alcanzan `root` por iteracion forward de `T`
sin salir del intervalo `[1, bound]` antes de llegar a `root`.

```text
SPEC signature reachesWithinBound :
  n:NatPos -> root:NatPos -> bound:NatPos -> Prop
```

Contrato: existe `j >= 0` tal que `T^j(n) = root`, y para todo `0 <= i <= j`,
`T^i(n) <= bound`.

```text
SPEC theorem boundedInverseTree_sound_complete :
  n in boundedInverseTree(root,bound)
  <-> reachesWithinBound(n,root,bound)
```

Estado: SPEC theorem, sin prueba.

## SPEC: pi_a y pi_a_star

```text
SPEC signature pi_a : a:NatPos -> x:NatPos -> Nat
```

Contrato: cantidad de `n` con `1 <= n <= x` y algun iterado forward `T^j(n)=a`.

```text
SPEC signature pi_a_star : a:NatPos -> x:NatPos -> Nat
```

Contrato: cantidad de `n` con `1 <= n <= x`, algun iterado `T^j(n)=a`, y todos
los iterados intermedios `<= x`.

```text
SPEC theorem pi_star_as_tree_count :
  pi_a_star(a,x) = Count(boundedInverseTree(a,x))
```

Estado: SPEC theorem, sin prueba.

```text
SPEC theorem pi_star_le_pi :
  pi_a_star(a,x) <= pi_a(a,x)
```

Estado: SPEC theorem, sin prueba.

## SPEC: clases residuales k=2

```text
SPEC constant k2Modulus : Nat = 9
SPEC constant k1Modulus : Nat = 3
```

```text
SPEC signature IsK2PrincipalResidue : ResidueMod 9 -> Prop
```

Contrato:

```text
IsK2PrincipalResidue(r) <-> r in {2,5,8} modulo 9.
```

```text
SPEC signature K2Residue : finite enumeration of ResidueMod 9
```

Contrato de enumeracion exacta:

```text
K2Residue = [2 mod 9, 5 mod 9, 8 mod 9].
```

```text
SPEC signature liftK1ToK2 :
  ResidueMod 3 -> FiniteSet (ResidueMod 9)
```

Contrato minimo M1:

```text
liftK1ToK2(2 mod 3) = {2 mod 9, 5 mod 9, 8 mod 9}.
```

## SPEC: phi_k^m

```text
SPEC signature NotInCycle : NatPos -> Prop
```

Contrato: predicado usado por KL2003 para excluir raices ciclicas en el infimo.
Para M1 no se debe reemplazar por una caracterizacion global no probada.

```text
SPEC signature phi :
  k:Nat -> residue:ResidueMod(3^k) -> y:RealNonnegative -> RealNonnegative
```

Contrato KL2003:

```text
phi(k,m,y) =
  inf { pi_a_star(a, 2^y * a) :
        a congruent m modulo 3^k,
        NotInCycle(a) }.
```

Estado: SPEC. La futura formalizacion puede introducir una version efectiva o
discreta antes de abrir analisis real; esa decision no pertenece a esta fase.

## SPEC: sistema I_2

```text
SPEC constant alpha : Real = log_2(3)
```

Firmas de filas:

```text
SPEC signature I2_D1_row :
  phi_2^2(y) >=
    phi_2^8(y-2)
    + min(phi_2^2(y+alpha-2),
          phi_2^5(y+alpha-2),
          phi_2^8(y+alpha-2))
```

```text
SPEC signature I2_D2_row :
  phi_2^5(y) >= phi_2^2(y-2)
```

```text
SPEC signature I2_D3_row :
  phi_2^8(y) >=
    phi_2^5(y-2)
    + min(phi_2^2(y+alpha-1),
          phi_2^5(y+alpha-1),
          phi_2^8(y+alpha-1))
```

```text
SPEC signature I2System :
  rows = [I2_D1_row, I2_D2_row, I2_D3_row]
```

Estado: SPEC signatures. No se prueba que `phi` satisfaga estas filas.

## SPEC: EL para k=2

```text
SPEC signature ELNodeLabel :
  residue:ResidueMod 9 -> shift:ShiftExpr -> Label
```

`ShiftExpr` debe representar expresiones de la forma:

```text
q0 + q1 * alpha, con q0,q1 racionales.
```

```text
SPEC signature K2ELTreeFor8 :
  rooted labelled tree for the normalized I_2^8(EL) row
```

Fila normalizada provisional:

```text
SPEC signature I2_EL8_row :
  phi_2^8(y) >=
    phi_2^5(y-2)
    + min(
        phi_2^8(y+alpha-3) + M1(y),
        phi_2^2(y+alpha-3)
      )

SPEC signature I2_EL8_M1 :
  M1(y) =
    min(
      phi_2^8(y+2*alpha-5) + M2(y),
      phi_2^5(y+2*alpha-5)
    )

SPEC signature I2_EL8_M2 :
  M2(y) =
    min(
      phi_2^2(y+3*alpha-5),
      phi_2^5(y+3*alpha-5),
      phi_2^8(y+3*alpha-5)
    )
```

```text
SPEC signature I2ELSystem :
  rows = [I2_D1_row, I2_D2_row, I2_EL8_row]
```

Retarded-only target:

```text
SPEC verifier all_EL_shifts_retarded :
  each leaf shift beta in I2ELSystem satisfies beta < 0
```

Estado: SPEC verifier, sin implementacion.

## SPEC: LP feasibility M1

Variables principales:

```text
SPEC signature K2PrincipalVariables =
  {c_2^2, c_2^5, c_2^8}
```

Variable auxiliar:

```text
SPEC signature K2AuxVariables = {c_1^2}
```

Variable objetivo/gauge:

```text
SPEC signature K2GaugeVariable = C_2^max
```

Coeficientes:

```text
SPEC coefficient A = lambda^(-2)
SPEC coefficient B = lambda^(alpha-2)
SPEC coefficient D = lambda^(alpha-1)
```

Sistema LP no truncado `L_2^NT`:

```text
SPEC signature L2NT_rows :
  1 <= c_2^2 <= C_2^max
  1 <= c_2^5 <= C_2^max
  1 <= c_2^8 <= C_2^max

  c_2^2 <= A*c_2^8 + B*c_1^2
  c_2^5 <= A*c_2^2
  c_2^8 <= A*c_2^5 + D*c_1^2

  c_1^2 <= c_2^2
  c_1^2 <= c_2^5
  c_1^2 <= c_2^8
```

```text
SPEC signature L2NTCertificate :
  lambda_interval: RationalInterval
  coefficient_intervals: Map CoefficientKey RationalInterval
  variables: Map Variable RatPos
  row_slacks: Map Row RatPos
```

```text
SPEC verifier verify_L2NT_certificate :
  L2NTCertificate -> Bool
```

Estado: SPEC verifier. La salida `true` no debe interpretarse como resultado
matematico hasta que el verificador y sus axiomas esten auditados.

## SPEC: puente theorem bridge

El puente M0 futuro debe ser parametrico en un sistema retarded y un certificado
LP factible con holgura. Firma de objetivo:

```text
SPEC theorem feasible_retarded_LP_certificate_to_lower_bound :
  RetardedDifferenceSystem S ->
  PositiveMonotoneSolution Phi S ->
  BaseSegmentLowerBound Phi S Y0 ->
  InteriorRationalLPCertificate S lambda gamma ->
  gamma = log_2(lambda) ->
  exists Delta > 0,
    for all principal residue m and all y >= 0,
      Phi_m(y) >= Delta * c_m * lambda^y
```

`BaseSegmentLowerBound Phi S Y0` es una hipotesis explicita de anclaje para
la induccion retardada. En el caso `pi_a_star` esperado, el candidato natural
es la cota trivial de raiz:

```text
phi_k^m(y) >= 1
```

en el segmento inicial necesario, porque la raiz cuenta en su propio arbol
inverso acotado. Esta hipotesis debe permanecer visible en la signature:
sin un segmento base, el `Delta` del puente no se construye.

Especializacion M1:

```text
SPEC theorem M1_surrogate_KL2003_k2_lower_bound_signature :
  BaseSegmentLowerBound phi I2ELSystem Y0 ->
  InteriorRationalLPCertificate I2ELSystem lambda gamma ->
  exists Delta > 0,
    for all m in {2,5,8} and all y >= 0,
      phi_2^m(y) >= Delta * c_2^m * lambda^y
```

Estado: SPEC theorem. No se prueba en esta fase.

## Politica de intervalos racionales para lambda^beta

Problema: los coeficientes `lambda^beta` no son racionales cuando
`beta = q0 + q1*alpha` y `alpha = log_2(3)`.

Representacion requerida:

```text
SPEC structure ShiftExpr:
  q0 : Rat
  q1 : Rat
  denotes q0 + q1*alpha

SPEC structure PowKey:
  lambda_id : Identifier
  beta : ShiftExpr

SPEC structure RationalInterval:
  lo : Rat
  hi : Rat
  proof_obligation : lo <= lambda^beta <= hi
```

Regla de verificacion segura para una fila:

```text
sum_i lhsCoeff_i * lhsVar_i <= sum_j rhsCoeff_j * rhsVar_j
```

El verificador debe comprobar una desigualdad pesimista:

```text
sum_i upper(lhsCoeff_i) * lhsVar_i + slack
  <=
sum_j lower(rhsCoeff_j) * rhsVar_j
```

donde `slack` es racional positivo registrado por fila. Para variables no
negativas, esta regla evita depender de redondeos favorables.

Requisitos:

- `lambda` debe estar fijado por dato racional o intervalo racional certificado.
- cada `PowKey` usado por una fila debe aparecer exactamente una vez en el
  ledger de coeficientes;
- los intervalos deben ser suficientemente estrechos para preservar holgura;
- ninguna fila puede depender de floats como evidencia final;
- las rutinas que produzcan intervalos son generadores, no verificadores.

## Requisito de punto interior racional

No se acepta el punto optimo de frontera ni el valor redondeado de KL2003 como
certificado final.

```text
SPEC structure InteriorRationalLPCertificate:
  lambda_lower : Rat
  lambda_upper : Rat
  gamma_lower : Rat optional
  variables : Map Variable RatPos
  coefficient_intervals : Map PowKey RationalInterval
  row_slacks : Map Row RatPos
  gauge : GaugePolicy
```

Condiciones:

- todas las variables LP son racionales positivas;
- cada desigualdad estructural tiene holgura racional positiva, salvo filas
  declaradas explicitamente como gauge/normalizacion;
- si se usa normalizacion `min c = 1`, esa igualdad debe separarse del
  conjunto de factibilidad interior;
- para obtener interior real, se permite bajar `lambda` por debajo del valor de
  tabla KL2003;
- el certificado debe venir acompanado de un ledger de filas que permita
  recomputar cada slack con aritmetica racional.

Firma de verificador:

```text
SPEC verifier verify_interior_rational_point :
  InteriorRationalLPCertificate -> VerificationReport
```

El reporte futuro debe distinguir:

```text
PASS_INTERVAL_ARITHMETIC
PASS_ROW_SLACKS
PASS_GAUGE
FAIL_MISSING_COEFFICIENT_INTERVAL
FAIL_NONPOSITIVE_SLACK
FAIL_FLOAT_ONLY
```

## Apendice: erratas KL2003 scoped

Esta tabla es de alcance SPEC. Las normalizaciones son candidatas de trabajo
para M0/M1 y deben auditarse contra fuente publicada o autores antes de claims
M3/KL2003 completos.

| ubicacion | original KL2003/arXiv TeX | normalizada SPEC | justificacion |
|---|---|---|---|
| Seccion 6, statement de `pi_a` | `T^{(j}(n)` | `T^{(j)}(n)` | Errata de llave; la notacion de iterado se usa asi en todo el paper. |
| Theorem 2.2 TeX | `Then for and all m ...` | `Then for all m ...` | Errata gramatical del TeX; el cuantificador esperado es claro por la formula (2.16). |
| Seccion 3, formula (3.1) | tercera hoja repetida como `m' + 3^{k-1}` | tercera hoja `m' + 2*3^{k-1}` | Consistencia con la regla de minimizacion (2.6)/(2.14): las tres elevaciones modulo `3^k`. |
| Appendix `k=2` intro | `I_k(EM)` y `L_k^{EM}` | `I_k(EL)` y `L_k^{EL}` | El resto de KL2003 usa `EL` para eliminated/retarded system; `EM` no se desarrolla como objeto separado. |
| Appendix `k=2`, formula de `M_1` | segundo termino `phi_2^5(y+2 alpha-5)` | sin cambio: conservar `phi_2^5(y+2 alpha-5)` | Meta-errata 2026-07-13: la normalizacion provisional `phi_2^5 -> phi_2^2` queda revocada por Figure A1 + deletion rule + hook member-wise. |
| Tabla 4, fila `T_2^8(EL)` | `lambda^(2 lambda - 3)` | `lambda^(2 alpha - 3)` | Errata tipografica dimensional: el exponente debe ser un shift en `alpha`, no en `lambda`. |

## Registro pre-M0

Antes de la primera prueba M0:

```text
REGISTER target = KrasikovLagarias2003
DO_NOT_REGISTER target = Krasikov1989 unless primary text is located
```

La fase actual no registra target porque solo abre signatures SPEC.

## Cierre de fase

Este documento abre la fase spec/signatures-only M0/M1 y deja fijadas las
interfaces minimas. El siguiente paso permitido es revisar estas firmas; el
siguiente paso no permitido todavia es comenzar pruebas matematicas.
