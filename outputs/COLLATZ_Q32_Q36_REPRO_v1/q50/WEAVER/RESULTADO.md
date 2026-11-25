# Q50 · Reloj abreviado de Weaver y captura con coeficiente expansivo

**Estado: comparación PAPER exacta; la captura citada ya tiene certificado
Lean local.** No se hizo un barrido ni se recompiló Lean.

## Contrato externo que sí se puede consumir

En el [manuscrito de Weaver, versión 1](https://rstation.ai/problems/collatz/papers/231),
el mapa abreviado es \(C(x)=(3x+1)/2\) para \(x\) impar y \(C(x)=x/2\)
para \(x\) par. Su reloj \(t\) cuenta **todos** esos pasos y \(k\)
cuenta las salidas impares. El Teorema 2 afirma, condicionado a la
completitud de las tablas publicadas de máximos y demoras y a su censo
finito, que hasta \(t=10\,439\,860\,590\) sólo hay 593 segmentos
no decrecientes con coeficiente homogéneo contractivo; sus longitudes
son \(8,27,46,54,65,73,92\). El artículo no aporta por sí solo un
certificado Lean de Q50 ni una reproducción independiente completa de
su censo.

Para el retorno impar físico del proyecto, una arista de valoración
exacta \(a\) ocupa \(a\) pasos abreviados: uno impar y \(a-1\)
divisiones pares. Por tanto un libro físico \((j,S,B)\), definido por
\(2^S R^j(N)=3^jN+B\), corresponde **exactamente** a
\((t,k)=(S,j)\), no a \(t=j\) ni a \(t=S+j\). El reloj ordinario
sería \(S+j\).

En forma de consumidor **externo condicional**, el Teorema 2 permite:

\[
N\ge3,\quad 93\le S\le10\,439\,860\,590,\quad
2^S>3^j,\quad\text{historia física }(j,S,B)
\quad\Longrightarrow\quad R^j(N)<N.
\]

La desigualdad estricta \(2^S>3^j\) es la condición de contracción;
sin ella el teorema no da descenso. Tampoco se usa aquí el Teorema 5
del manuscrito: exige que **todas** las subidas estrictas de un reloj
y grado dados acaben en 1, hipótesis que el propio ejemplo numérico
de Weaver deja abierta. Este contrato se mantiene separado de PAPER y
de Lean locales.

## De Bono breve: cambio de representación y contraste fijado

**TO:** comparar un encuentro desde fuente menor con la condición de
contracción del coeficiente **respecto del mismo \(N\)**.
**LO:** conservar las valoraciones físicas y libros certificados.
**PO:** medir cada punto por \((S,j)\), además del tamaño del estado;
una captura puede preceder al instante \(2^S>3^j\).
**SO / primer contraste:** en la hoja Q50 \(u=6+8t\), separar la
valoración real \(d=3\) de \(d\ge4\) en \(T^{64}(N)\).
No se infiere convergencia de la mera condición de reloj.

Se fija la misma fila original
\(s=29+32u\), \(u=6+8t\), \(t\ge0\),
\(k=428769801+2^{31}(12+64s)\) y
\(N=110482433359989887+2^{58}k\). El
[certificado Q50](../LEAN/RESULTADO.md) conserva \(F=T^{60}(N)\) con
libro \((60,94,253163701604367108480427299121)\) y la palabra
física \((2,2,1,1)\) hasta \(X=T^{64}(N)\). Sus libros son:

| Ruta original | Libro \((j,S,B)\) |
| --- | --- |
| \(N\to F\) | \((60,94,253163701604367108480427299121)\) |
| \(F\to X\) | \((4,6,143)\) |
| \(N\to X\) | \((64,100,23338666639838685855883807453313)\) |

Sea \(H=3X+1\) y \(d=\nu_2(H)\), **exacta**. En la coordenada
\(t\) de esta hoja, \(H\equiv8+8t\pmod{16}\). Así \(t\) par
fuerza exactamente \(d=3\); \(t\) impar da \(d\ge4\).
Los márgenes afines, leídos en la misma fila, son

\[
\begin{aligned}
H-8N&=1104893174198848086085813820320
 +1278773272413617935999372998680t>0,\\
12N+4-H&=33944159555973379084952768140896
 +39286045934889722911895129573352t>0.
\end{aligned}
\]

Para \(t\) par, \(Y=T^{65}(N)=H/8>N\). La fuente
\(w=(2Y-1)/3=(X-1)/4\) es un impar positivo menor que el
**mismo** \(N\), pues \(N-w=(12N+4-H)/12>0\). Además,
\(H\equiv8\pmod{16}\) fuerza \(X\equiv13\pmod{16}\), así que
\((X-1)/4\) es impar. Cumple \(3w+1=2Y\):
su valoración física es exactamente \(1\) y llega al mismo \(Y\)
en un retorno. Los libros permanecen independientes:

| Ruta hasta \(Y\) | Libro \((j,S,B)\) |
| --- | --- |
| Original \(N\to Y\), \(d=3\) | \((65,103,71283650519744286969148125565315)\) |
| Fuente \(w\to Y\) | \((1,1,1)\) |

El contraste de coeficientes es exacto. A lo largo de los controles
mostrados en esta hoja,
\(2^{94}<3^{60}\), \(2^{96}<3^{61}\),
\(2^{98}<3^{62}\), \(2^{99}<3^{63}\),
\(2^{100}<3^{64}\) y \(2^{103}<3^{65}<2^{104}\).
Por eso la captura física de la
subclase \(u\equiv6\pmod{16}\) ocurre con coeficiente **todavía
expansivo** en su libro \(N\to Y\); Weaver no la excluye ni la
construye. Los puntos mostrados desde \(F\) hasta \(Y\) están aún
por encima de \(N\), según los márgenes de Q49/Q50. El pago de la
subclase procede de la fuente menor y del certificado Lean, no de
la autoridad del manuscrito.

Para \(t\) impar, \(d\ge4\), de modo que el libro original en
\(T^{65}\) tiene \((j,S)=(65,100+d)\) y ya
\(2^{100+d}>3^{65}\). El margen directo
\(16N-H>0\) del certificado Q50 da \(T^{65}(N)<N\) para
**todo** \(d\ge4\). Weaver sería aplicable sólo si además
\(100+d\le10\,439\,860\,590\), y en esta hoja no añade cobertura.

**GO / límite:** se puede consumir la exclusión externa como filtro
condicional de un futuro checkpoint físico contractivo con reloj
\(S\) en su intervalo. En el contraste acotado, la captura ya
certificada conserva un coeficiente expansivo en todos los controles
mostrados desde \(T^{60}\) y la rama contractiva ya
desciende por una desigualdad local. No se transfieren las premisas
computacionales de Weaver a Lean ni se promueve su criterio de una
longitud a prueba de terminación de Q50.
