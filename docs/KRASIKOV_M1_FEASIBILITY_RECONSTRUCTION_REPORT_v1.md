# KRASIKOV_M1_FEASIBILITY_RECONSTRUCTION_v2

Fecha: 2026-07-05  
Estado: informe tecnico, sin Lean, sin registro de target.

## Clasificacion

- PRIMARY_METHOD_RECONSTRUCTED
- M1_STATEMENT_TRANSCRIBED, con alcance: `M1 surrogate` desde KL2003, no cita exacta de Krasikov1989
- COMPLETE_SMALL_INEQUALITY_SYSTEM_EXTRACTED
- NUMERIC_SANITY_CHECK_DONE
- LEAN_REUSE_ARCHITECTURAL_ONLY
- FEASIBILITY_GO_CANDIDATE, solo candidato arquitectonico
- WAITING_ON_COORDINATION_REVIEW

No asignado: FEASIBILITY_NO_GO.

Guardarrailes cumplidos: NO_LEAN_YET, NO_CLAIM_FIRST_FORMALIZATION, NO_DUPLICATE_TERRAS, NO_GLOBAL_COLLATZ_CLAIM.

## Fuentes

Fuente primaria usada:

- Ilia Krasikov and Jeffrey C. Lagarias, "Bounds for the 3x+1 Problem using Difference Inequalities", arXiv:math/0205002; journal reference Acta Arithmetica 109 (2003), 237--258. URL: https://arxiv.org/abs/math/0205002

Fuente secundaria/bibliografica para Krasikov1989:

- Jeffrey C. Lagarias, "The 3x+1 problem: An annotated bibliography (1963--1999)", arXiv:math/0309224. URL: https://arxiv.org/abs/math/0309224

Krasikov1989 no quedo localizado como texto primario fiable durante esta reconstruccion. Por tanto, el escalon minimo se marca como:

> M1 surrogate = el caso `k=2` reconstruido desde KL2003, no una cita exacta del articulo de Krasikov de 1989.

La bibliografia anotada de Lagarias identifica Krasikov1989 como: Ilia Krasikov, "How many numbers satisfy the 3x+1 Conjecture?", Internatl. J. Math. & Math. Sci. 12 (1989), 791--796, MR 91c:11013, y resume que obtiene al menos `x^(3/7)` valores para grandes `x`. Esto no se usa aqui como transcripcion primaria del paper.

## Statement objetivo transcrito

KL2003 define la funcion

```text
T(n) = n/2              si n es par,
T(n) = (3n+1)/2        si n es impar.
```

Para `a not congruent 0 (mod 3)`:

```text
pi_a(x) := #{n : 1 <= n <= x, some T^(j)(n) = a}.
```

El teorema final de KL2003, seccion 6, dice matematicamente:

```text
For each positive a not congruent 0 (mod 3), the function
pi_a(x) satisfies, for all sufficiently large x >= x_0(a),
pi_a(x) >= x^0.84.
```

Nota de transcripcion: el TeX de arXiv tiene una errata menor de llave en `T^{(j}(n)`, que se lee evidentemente como `T^{(j)}(n)`.

Para el escalon pequeno, KL2003 dice en la introduccion que Krasikov1989 uso el sistema `k=2` para obtener un lower bound `x^0.43`; la bibliografia anotada de Lagarias lo precisa como `x^(3/7)`. KL2003, con su LP sin truncacion `L_k^NT`, lista para `k=2`:

```text
gamma_2 = 0.4365880
lambda_2 = 1.3534010
C_2^max = 1.8316920
```

Este ultimo es el statement operacional del `M1 surrogate`: para el sistema KL2003 `k=2`, existe una solucion factible positiva del LP no truncado cerca de `lambda = 1.353401`, lo que da exponente `gamma = log_2(lambda) ~= 0.436588`.

## Semantica del arbol inverso

`pi_a^*(x)` cuenta los `n <= x` que alcanzan `a` por iteracion forward de `T` y cuyos iterados intermedios permanecen `<= x`. Equivale a contar nodos del arbol inverso acotado de raiz `a` dentro de `[1,x]`.

Los predecesores inversos de un nodo `z` bajo `T` son:

```text
2z                         siempre;
(2z-1)/3                   solo si (2z-1) es divisible por 3.
```

KL2003 reescala con `x = 2^y a` y define, para clases `m mod 3^k` con `m not congruent 0 mod 3`,

```text
phi_k^m(y) := inf { pi_a^*(2^y a) :
                    a congruent m (mod 3^k), a not in a cycle }.
```

Luego reduce a las clases `m congruent 2 (mod 3)` mediante

```text
phi_k^m(y) = phi_k^(2m)(y-1)    si m congruent 1 (mod 3).
```

Para `k=2`, las clases principales son exactamente:

```text
[9] = {2, 5, 8} mod 9.
```

La desigualdad de cada residuo sale de seleccionar subarboles inversos disjuntos y seguros dentro de la cota `2^y a`. El factor `alpha = log_2(3)` aparece al cambiar la raiz del subarbol: si la nueva raiz es aproximadamente `(4/3)a` o `(2/3)a`, el parametro `y` cambia por `alpha-2` o `alpha-1`.

## Sistema pequeno completo: I_2 original

Sea

```text
alpha = log_2(3).
Phi_2 = { phi_2^2(y), phi_2^5(y), phi_2^8(y) : y >= 0 }.
```

KL2003 Appendix, `k=2`, da:

```text
phi_2^2(y) >=
  phi_2^8(y-2)
  + min[
      phi_2^2(y+alpha-2),
      phi_2^5(y+alpha-2),
      phi_2^8(y+alpha-2)
    ].

phi_2^5(y) >=
  phi_2^2(y-2).

phi_2^8(y) >=
  phi_2^5(y-2)
  + min[
      phi_2^2(y+alpha-1),
      phi_2^5(y+alpha-1),
      phi_2^8(y+alpha-1)
    ].
```

Terminos por residuo:

| residuo raiz | caso KL | termino retarded | termino min | shifts |
|---:|---|---|---|---|
| 2 mod 9 | D1 | `phi_2^8(y-2)` | `min(phi_2^2, phi_2^5, phi_2^8)(y+alpha-2)` | `-2`, `alpha-2` |
| 5 mod 9 | D2 | `phi_2^2(y-2)` | ninguno | `-2` |
| 8 mod 9 | D3 | `phi_2^5(y-2)` | `min(phi_2^2, phi_2^5, phi_2^8)(y+alpha-1)` | `-2`, `alpha-1` |

Solo el residuo `8 mod 9` contiene variables avanzadas, porque `alpha-1 > 0`.

## Sistema pequeno completo: eliminacion EL para I_2

KL2003 Appendix expande el caso `k=2`.

**Meta-errata 2026-07-13.** La version inicial de este reporte normalizo la
formula de `M_1`, cambiando el segundo termino impreso `phi_2^5(y+2alpha-5)`
por `phi_2^2(y+2alpha-5)`. Esa normalizacion queda revocada. La lectura de
Figure A1 como grafo, la regla de delecion de KL2003 y el hook member-wise del
seam muestran que el TeX original con `phi_2^5` es el brazo correcto. El cambio
`phi_2^5 -> phi_2^2` fue una meta-errata introducida por nuestra
reconstruccion.

Se conserva como errata tipografica real:

- en Tabla 4, `lambda^(2 lambda - 3)` debe ser `lambda^(2 alpha - 3)`.

El sistema `I_2(EL)` conserva las desigualdades de residuos `2` y `5` de `I_2`, y reemplaza la de residuo `8` por:

```text
phi_2^8(y) >=
  phi_2^5(y-2)
  + min[
      phi_2^8(y+alpha-3) + M_1(y),
      phi_2^2(y+alpha-3)
    ],

M_1(y) =
  min[
    phi_2^8(y+2alpha-5) + M_2(y),
    phi_2^5(y+2alpha-5)
  ],

M_2(y) =
  min[
    phi_2^2(y+3alpha-5),
    phi_2^5(y+3alpha-5),
    phi_2^8(y+3alpha-5)
  ].
```

Todos los shifts de esta desigualdad son retardados:

```text
alpha-3   ~= -1.4150374993
2alpha-5  ~= -1.8300749986
3alpha-5  ~= -0.2451124978
```

Por tanto, para `k=2`, la eliminacion avanzada es finita, explicita y pequena: profundidad 3, 8 literales, segun Tabla 1 de KL2003.

## LP pequeno completo: L_2^NT

Variables principales:

```text
c_2^2, c_2^5, c_2^8
```

Variable auxiliar:

```text
c_1^2
```

Variable objetivo:

```text
C_2^max
```

Sistema completo:

```text
1 <= c_2^2 <= C_2^max
1 <= c_2^5 <= C_2^max
1 <= c_2^8 <= C_2^max

c_2^2 <= c_2^8 * lambda^(-2)
         + c_1^2 * lambda^(alpha-2)

c_2^5 <= c_2^2 * lambda^(-2)

c_2^8 <= c_2^5 * lambda^(-2)
         + c_1^2 * lambda^(alpha-1)

c_1^2 <= c_2^2
c_1^2 <= c_2^5
c_1^2 <= c_2^8
```

Nota: KL2003 formula `L4` de forma general; la lectura correcta para `k=2` es la de las tres elevaciones de la unica clase `2 mod 3` a `2,5,8 mod 9`, coherente con la definicion de minimizacion de `phi_1^2`.

Coeficientes numericos usando un valor ligeramente inferior al `lambda` redondeado de KL2003, para evitar falso fallo por redondeo:

```text
lambda = 1.353400093558369
gamma = log_2(lambda) = 0.436588393391306
alpha = log_2(3) = 1.584962500721156

A = lambda^(-2)       = 0.545943369277317
B = lambda^(alpha-2)  = 0.881968750549317
D = lambda^(alpha-1)  = 1.193656589509004
```

Asignacion factible normalizada:

```text
c_2^2 = 1.831691813243802
c_2^5 = 1.000000000000000
c_2^8 = 1.739599958786321
c_1^2 = 1.000000000000000
C_2^max = 1.831691813243802
```

Chequeos:

```text
c_2^2 = A*c_2^8 + B*c_1^2
c_2^5 = A*c_2^2
c_2^8 = A*c_2^5 + D*c_1^2
c_1^2 <= min(c_2^2, c_2^5, c_2^8)
```

Esto reconstruye el pequeno certificado numerico del escalon `k=2` en el formato generator/verifier.

## LP pequeno completo: L_2^EL

La Tabla 4 de KL2003 da el LP asociado a los tres arboles `T_2^m(EL)`. Con las normalizaciones tipograficas mencionadas:

Arbol `T_2^2(EL)`:

```text
c_2^2 <= c_2^8 * lambda^(-2) + a_1' * lambda^(alpha-2)

a_1' * lambda^(alpha-2) <= c_2^2 * lambda^(alpha-2)
a_1' * lambda^(alpha-2) <= c_2^5 * lambda^(alpha-2)
a_1' * lambda^(alpha-2) <= c_2^8 * lambda^(alpha-2)
```

Arbol `T_2^5(EL)`:

```text
c_2^5 <= c_2^2 * lambda^(-2)
```

Arbol `T_2^8(EL)`:

```text
c_2^8 <= c_2^5 * lambda^(-2) + a_1 * lambda^(alpha-1)

a_1 * lambda^(alpha-1) <=
  c_2^8 * lambda^(alpha-3)
  + a_2 * lambda^(2alpha-3)

a_1 * lambda^(alpha-1) <=
  c_2^2 * lambda^(alpha-3)

a_2 * lambda^(2alpha-3) <=
  c_2^8 * lambda^(2alpha-5)
  + a_3 * lambda^(3alpha-5)

a_2 * lambda^(2alpha-3) <=
  c_2^2 * lambda^(2alpha-5)

a_3 * lambda^(3alpha-5) <= c_2^2 * lambda^(3alpha-5)
a_3 * lambda^(3alpha-5) <= c_2^5 * lambda^(3alpha-5)
a_3 * lambda^(3alpha-5) <= c_2^8 * lambda^(3alpha-5)
```

Este sistema es completo para el caso pequeno; no hay "etc." ni residuos implicitos.

## Sanity check numerico hasta 10^4

Script usado:

```text
work/scripts/krasikov_m1_sanity.py
```

Metodo:

1. Construir `pi_star(a,x)` como arbol inverso acotado dentro de `[1,x]`.
2. Revisar todas las desigualdades de ramas para raices `a <= 10000`, `a not divisible by 3`, `a not in {1,2}`, residuos `2,5,8 mod 9`.
3. Usar enteros `y >= 2` tales que `x = 2^y a <= 10000`.
4. Para las ramas con cambio de raiz, usar la cota KL:
   `2^(y+alpha-2)*(4a-2)/3 = 2^y a - 2^(y-1)` y
   `2^(y+alpha-1)*(2a-1)/3 = 2^y a - 2^(y-1)`.

Salida:

```text
N=10000
checked inequalities=1653
residue 2 mod 9: checked=548, equalities=0
residue 5 mod 9: checked=554, equalities=0
residue 8 mod 9: checked=551, equalities=0
failures=0
```

Observacion: antes de excluir `a=2`, aparecian fallos por solapamiento con el ciclo positivo `1 <-> 2`; esto confirma que la condicion de KL2003 "a not in a cycle" no es decorativa.

## Encaje con nuestra infraestructura

Encaja arquitectonicamente:

- Racionales exactos: residuos, transformaciones inversas, cotas enteras `x - 2^(y-1)`, arboles, minimos y desigualdades pueden representarse exactamente. Los coeficientes con `lambda^beta` no son racionales, pero pueden verificarse con intervalos racionales certificados.
- Ledgers: cada fila puede registrar `source residue`, `target residue`, `shift beta`, tipo `sum/min`, origen `D1/D2/D3` o `EL split`, y justificacion de deletion.
- Verifiers: un verificador puede comprobar que el generator produce exactamente las hojas esperadas y que cada desigualdad LP se deduce de la tabla/tree.
- Audits de axiomas: separar axiomas matematicos importados de KL2003 de checks computacionales propios; registrar explicitamente las erratas normalizadas.
- Separacion generator/verifier: el generator enumera arboles y LP rows; el verifier reevalua residuos, shifts, deletion rule, no-advanced condition, y factibilidad numerica por intervalos racionales.

No es todavia una formalizacion Lean, ni debe abrirse Lean antes de la revision coordinada.

## Lo que NO reutiliza directamente

- No reutiliza directamente la semantica forward Raw P1: aqui el objeto natural es el arbol inverso acotado `pi_a^*`, no una trayectoria forward individual como primitiva principal.
- No reutiliza optional stopping: el metodo es combinatorio/LP por desigualdades de diferencias, no martingala ni stopping-time probabilistico.
- No reutiliza ventanas W0-W4: los indices son residuos modulo `3^k`, shifts en `y`, y arboles de minimizacion.
- No reutiliza directamente una infraestructura basada en Terras/parity-vector density; aqui el certificado pequeno es de predecesores inversos y LP.

## Riesgos y puntos de revision

1. Krasikov1989 no esta localizado como fuente primaria. Cualquier statement historico exacto de Krasikov debe esperar al PDF/texto primario.
2. El `M1 surrogate` de KL2003 `L_2^NT` no debe confundirse con el bound original exacto de Krasikov1989. KL2003 parece extraer algo mas del sistema `k=2` que el `x^(3/7)` bibliografico.
3. KL2003 arXiv TeX contiene erratas menores en el apendice `k=2`; las normalizaciones deben ser auditadas por Claude/coordinacion.
4. Para formalizar, el punto delicado no es el caso `k=2` sino el puente general: `I_k` con terminos avanzados -> eliminacion `EL` -> LP retarded -> lower bound.
5. Los coeficientes `lambda^beta` requieren una politica de intervalos racionales; no basta con floats.

## Decision

Resultado: viable como candidato de factibilidad arquitectonica para M1, pendiente de revision conjunta.

No se declara GO. No se abre Lean. No se registra target.  
Siguiente estado: WAITING_ON_COORDINATION_REVIEW con Hilo A y revision externa de Claude.

Mensaje para Claude/coordinacion: aceptamos las cuatro enmiendas; este informe incorpora fuente primaria KL2003, Krasikov1989 solo si localizable, F5/catalog status prospectivo para targets propios, registration mechanism pendiente, y deliverable fuerte con statement, sistema pequeno completo y sanity check numerico.
