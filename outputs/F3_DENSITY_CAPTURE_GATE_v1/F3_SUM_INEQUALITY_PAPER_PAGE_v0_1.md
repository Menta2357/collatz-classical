# F3 — página de papel para una desigualdad de sumas v0.1

Fecha: 2026-07-21.

Estado: `PAPER_GATE_OPEN`. No es una prueba, no autoriza Lean y no modifica
la prioridad k=11/doblete/hold Eliahou.

## 1. Semántica fijada

Sea

\[
P(a,x)=\{n\in\{1,\ldots,x\}: T^j(n)=a\text{ para algún }j,
\ T^i(n)\le x\text{ para }0\le i\le j\},
\]

y sea \(\pi^*(a,x)=|P(a,x)|\). Esta es la semántica computable ya validada
en el proyecto por órbita forward, implementación con fuel e inversa BFS.

Para \(a\equiv8\pmod9\), escribimos

\[
c(a)=\frac{2a-1}{3},\qquad
x^-_a=x_a-\left\lceil\frac{x_a}{2a}\right\rceil.
\]

## 2. Identidad miembro a miembro que E5 estaba ocultando

Si \(x_a\ge4a\), las ramas son disjuntas y la raíz no pertenece a un ciclo,
la descomposición natural es

\[
P(a,x_a)
=\{a,2a\}\ \dot\cup\ P(4a,x_a)\ \dot\cup\ P(c(a),x_a). \tag{F3.1}
\]

La razón es local:

- los predecesores de \(a\) son \(2a\) y \(c(a)\);
- los predecesores de \(2a\) son \(4a\) y, en principio,
  \((4a-1)/3\);
- para \(a\equiv8\pmod9\), \(4a-1\not\equiv0\pmod3\), de modo que esa
  segunda rama no existe.

La hipótesis de no-ciclo es necesaria para promover esta explicación a una
partición abstracta disjunta. En el experimento finito, disjunción e igualdad
se comprobaron directamente sobre los conjuntos, no se supusieron.

Para una familia finita \(A\) de raíces, definimos

\[
\begin{aligned}
S_A&=\sum_{a\in A}\pi^*(a,x_a),\\
R_A&=\sum_{a\in A}\pi^*(4a,x_a),\\
C_A&=\sum_{a\in A}\pi^*(c(a),x_a),\\
C^-_A&=\sum_{a\in A}\pi^*(c(a),x^-_a),\\
B_A&=C_A-C^-_A\ge0.
\end{aligned}
\]

Sumando (F3.1) se obtiene la identidad exacta

\[
S_A=2|A|+R_A+C^-_A+B_A. \tag{F3.2}
\]

Por tanto el cociente usado en E5 no mide solo fuga de ventana:

\[
\frac{|A|+R_A+C^-_A}{S_A}
=1-\frac{|A|+B_A}{S_A}. \tag{F3.3}
\]

El término \(|A|\) es un átomo determinista omitido por la convención del
numerador. La fuga avanzada real es únicamente \(B_A\).

## 3. Resultado E5 reproducido y descompuesto

Parámetros exactos:

```text
A = {a <= 1200 : a == 8 mod 9}
|A| = 133
x_a = 2^9 a
x^-_a = x_a - ceil(x_a/(2a)) = x_a - 256
```

Resultado miembro a miembro:

```text
sum target                         = 1,155,367
sum [1 + retarded + advanced^-]    = 1,154,227
deficit total                      = 1,140
atomo determinista |A|             = 133
perdida avanzada B_A               = 1,007
cierre E5                          = 99.9013300536%
perdida avanzada / target          = 0.0871584527%
133/133 particiones PASS
133/133 identidades de deficit PASS
0 mismatches
```

La masa de dos ramas que realmente aparece en la desigualdad combinatoria es
\(R_A+C^-_A=1{,}154{,}094\), o 99.8898185598% del target. Su diferencia
respecto del target es \(2|A|+B_A\), no solo \(B_A\).

## 4. Control multiescala

La misma auditoría, sin cambiar la familia de raíces:

| y | cierre E5 | pérdida avanzada / target | pérdida avanzada absoluta |
|---:|---:|---:|---:|
| 7 | 99.876498316% | 0.077874673% | 227 |
| 8 | 99.885852425% | 0.091214603% | 529 |
| 9 | 99.901330054% | 0.087158453% | 1,007 |
| 10 | 99.889628072% | 0.104608494% | 2,414 |
| 11 | 99.886625344% | 0.110492616% | 5,099 |
| 12 | 99.884681204% | 0.113881902% | 10,541 |

Conclusión permitida: la fuga avanzada es pequeña en estas seis escalas.
Conclusión no permitida: que 0.1% sea una cota uniforme o asintótica.

## 5. El cuello exacto de la desigualdad de sumas

Definir solamente

\[
S_m(y;M)=\sum_{\substack{a<M\\a\equiv m\ (9)}}
\pi^*(a,2^y a)
\]

no cierra el sistema. Al sumar la fila miembro a miembro, las fuentes no son
las familias completas de las otras clases:

- \(a\mapsto4a\) aterriza únicamente en raíces divisibles por 4;
- \(a\mapsto c(a)\) aterriza únicamente en raíces impares;
- el residuo de \(c(a)\bmod9\) depende de \(a\bmod27\);
- sustituir una suma sobre una imagen afín por la suma completa de una clase
  tiene la dirección incorrecta para un lower bound.

Este es el problema de redistribución rica/flaca en forma verificable. E3
demuestra crecimiento empírico para familias fijas de raíces al ampliar la
ventana; no demuestra que las imágenes afines \(4a\) y \(c(a)\) retengan una
fracción uniforme de ese crecimiento.

## 6. Enunciado candidato que sí sería suficiente

Se busca una familia finita de tipos \(\mathcal F\), definida antes de medir
los datos, y funcionales no negativos \(V_f(y)\) tales que:

1. cada imagen retarded o advanced de un tipo sea otro tipo, o tenga una
   descomposición finita con multiplicidades explícitas;
2. las filas miembro a miembro produzcan una desigualdad vectorial

   \[
   V(y+1)\ge M V(y)-E(y); \tag{F3.4}
   \]

3. exista un vector racional \(w>0\), un \(\rho>\lambda_{11}\) y un
   \(\varepsilon<1\) certificados de manera que el error se absorba en la
   misma masa:

   \[
   w^T E(y)\le\varepsilon\, w^T M V(y),\qquad
   w^T M\ge\frac{\rho}{1-\varepsilon}w^T; \tag{F3.5}
   \]

4. (F3.4)–(F3.5) sean uniformes a partir de una base finita explícita.

La orientación exacta de \(M\) puede cambiar al incorporar shifts
retarded/advanced. Lo no negociable es que el certificado Perron y el error
usen el mismo vector de estado y el mismo denominador.

Si un operador ya normalizado tuviera tasa ideal 2 y solo se retuviera una
fracción \(1-\varepsilon\), bastaría

\[
\varepsilon<1-\lambda_{11}/2\approx10.39\%.
\]

El presupuesto empírico 5.1% sugeriría condicionalmente
\(\rho=1.898\) y \(\log_2\rho\approx0.92448\). Esto es únicamente una cuenta
de margen; no es válido hasta construir (F3.4) y justificar la composición de
errores.

## 7. Auditoría del alfabeto de tipos

El primer candidato natural refinaba al menos:

```text
residuo modulo 27
paridad
divisibilidad por 4 de la imagen retarded
marca rich/thin fijada por un criterio previo a la validacion
```

La auditoría exacta muestra que ningún refinamiento por un módulo fijo
\(M=2^\ell3^k\) hace determinista la rama advanced. En efecto, si
\(a_t=a+tM\), entonces

\[
c(a_t)=c(a)+\frac{2tM}{3}.
\]

Para \(t=0,1,2\), los tres términos de la derecha dan tres residuos distintos
módulo \(M\). En D1, después del parity lift, el incremento es \(4tM/3\) y
vuelve a tener orden 3 módulo \(M\).

El piloto recorrió

```text
M = 3^k 2^l
k = 2..7
l = 0..5
108 configuraciones clase/modulo
D1/D3: 72/72 no cierran; tres imagenes advanced por cada tipo padre
D2: 36/36 cierran como fila single-branch
0 resultados inesperados
```

Esto descarta un alfabeto **determinista estacionario basado solo en residuos
módulo M**. No descarta un sistema finito ponderado o multivaluado: para tal
sistema hay que controlar cuánta masa cae en cada uno de los tres lifts.
Precisamente esa obligación es el lema de redistribución que falta.

La siguiente arquitectura admisible es un prefijo 3-ádico dinámico truncado,
con cola certificada, o un lema directo de balance entre los tres lifts. Una
proliferación no acotada de tipos sin control de cola es `STOP/REDESIGN`, no
una invitación a ocultar estados.

## 8. Contrato de aceptación estilo D3

`PAPER_GATE_PASS` exige simultáneamente:

1. **Estados predeclarados.** Lista finita de tipos, ventanas, pesos y cutoff.
2. **Hooks miembro a miembro.** Inclusión, disjunción, ruta, ventana y
   multiplicidad para cada transición.
3. **Cierre de imágenes.** Toda fuente cae en un estado declarado; ninguna se
   sustituye por una clase completa sin una desigualdad con dirección probada.
4. **Ledger común.** Átomos, borde avanzado y cola flaca se expresan respecto
   de la misma masa ponderada.
5. **Estabilidad de cola.** La etiqueta flaca se controla después de cada
   transición, no solo en la población inicial.
6. **Cota uniforme.** El error se prueba para todo paso posterior a la base;
   una tabla finita solo calibra o refuta candidatos.
7. **Certificado espectral exacto.** Matriz y vector racionales, con
   \(\rho>1.7922\) comprobado sin floats decisionales.
8. **Base finita separada.** Rango inicial y verificador reproducible.
9. **Holdout.** Cualquier umbral aprendido se congela antes de la validación
   que respalda la claim.
10. **No-claims intactos.** No densidad probada, no casi-todos, no Collatz.

Rechazo automático:

```text
promediar porcentajes con denominadores distintos
sumar 0.1% y 5% sin un ledger comun
usar E3 como sustituto del cierre bajo imagenes afines
declarar uniforme una cota observada en y=9
usar solo agregados sin hooks miembro a miembro
elegir la cola despues de ver el conjunto de validacion
```

## 9. Próximo experimento autorizado

No ampliar el barrido de módulos fijos: el resultado anterior ya prueba la
no-determinación. El próximo piloto debe comparar la masa de los tres lifts

\[
a,\quad a+M,\quad a+2M \pmod{3M}
\]

dentro de cada tipo padre, con criterio rich/thin predeclarado, varias escalas
y una partición calibración/holdout. Su objetivo no es observar equilibrio,
sino decidir si existe una desigualdad unilateral suficientemente fuerte para
cerrar (F3.4). Si no aparece, la ruta F3 queda en `STOP` sin entrar en Lean.

No se autoriza Lean con esta versión v0.1.

```text
F3_E5_EXACT_GAP_IDENTITY_FOUND
E5_99_9013_REPRODUCED
E5_ADVANCED_LEAKAGE_SEPARATED_FROM_ATOM_ACCOUNTING
MULTISCALE_Y7_Y12_PASS_EMPIRICAL
FIXED_MODULUS_D1_D3_NONCLOSURE_CONFIRMED
DYNAMIC_3ADIC_PREFIX_OR_BALANCE_LEMMA_REQUIRED
SUM_SYSTEM_NOT_CLOSED
AFFINE_IMAGE_REDISTRIBUTION_IS_CURRENT_BLOCKER
PAPER_GATE_OPEN
NO_LEAN
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
```
