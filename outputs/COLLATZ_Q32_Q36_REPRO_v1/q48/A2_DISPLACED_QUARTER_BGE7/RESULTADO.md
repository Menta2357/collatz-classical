# Q48 Front4b · Auditoría del cuarto desplazado para la salida (1,b), b≥7

**Estado: PAPER probado bajo la guarda; no se compiló Lean.** Se usa sólo la fila

\[
k=428769801+2^{31}(108+128s),\quad
N=110482433359989887+2^{58}k,\quad s\ge0,\ s\equiv7\pmod8,
\]

con el pivote físico fijado

\[
F=T^{60}(N)=71667327748009080469224948461
 +84782316550432407028588866402s.
\]

El libro histórico \(N\to F\) es
\((60,95,B_{60})\), con
\(B_{60}=253163701604367108480427299121\), según el
[resultado previo](../LEGACY/RESULTADO_D2.md). Aquí
\(T(x)=(3x+1)/2^{\nu_2(3x+1)}\) sobre impares positivos y
\((j,S,B)\) significa \(2^S T^j(x)=3^j x+B\).

## Contraste fijado

**TO / propósito.** Auditar sólo la provocación \(w=(F-15)/4\), conservando
\(N\), la historia \(N\to F\) y dos libros independientes. **Primer contraste:**
el primer par físico auxiliar debe ser exactamente \((1,2)\), y el extremo
auxiliar debe satisfacer \(X=4W+15\). **Guarda:** tras agotar \(m\) pares
\((1,2)\) desde \(F\), su extremo \(X\) cumple
\(r=\nu_2(X+5)=3\) y la salida original siguiente es físicamente
\((1,b)\), \(b\ge7\). No se presume que la guarda aparezca para todo \(s\).
**PO:** el cuarto desplazado fue una propuesta de ruta, sin valor probatorio
antes de contrastar las valoraciones y los libros. **SO:** se juzga sólo
después de esas dos comprobaciones; no se abren fuentes alternativas.

**LO / precio.** En esta fila \(F\equiv11\pmod{16}\), así que \(w\) es
entero impar. Para \(s=7+8t\), \(t\ge0\), la resta afín exacta es

\[
N-w=455283598302137122605667839964
 +464260667013249886691173869884t>0.
\]

También \(F>15\), de modo que \(0<w<N\). La congruencia de la fila hace
imposible \(m=0,r=3\), pues \(16\mid F+5\); por tanto \(m\ge1\).

## Los pares son físicos

Sea \(P(x)=(9x+5)/8\), la fórmula de un par \((1,2)\), y
\(F_j=P^j(F)\), \(0\le j\le m\), de modo que \(F_m=X\). La identidad

\[
F_j+5=9^j(F+5)/8^j,
\qquad \nu_2(F_j+5)=3(m-j)+3
\]

se obtiene del par original y de \(r=3\). Para \(j<m\),
\(F_j\equiv59\pmod{64}\). Por tanto
\(w_j=(F_j-15)/4\equiv11\pmod{16}\), y directamente
\(\nu_2(3w_j+1)=1\) y
\(\nu_2(3T(w_j)+1)=2\). Además,

\[
P((x-15)/4)=(P(x)-15)/4.
\]

Así los \(m\) pares auxiliares son físicos y terminan en
\(W=w_m=(X-15)/4\). La identidad racional sola no se emplea como prueba
de las valoraciones.

## Congruencia y mismo terminal

Escribamos \(X+5=8u\), con \(u\) impar. Entonces \(X=8u-5\),
\(W=2u-5\), y la palabra original \((1,b)\) implica

\[
Y=\frac{9u-5}{2^{b-2}},\qquad \nu_2(9u-5)=b-2\ge5.
\]

Como \(9^{-1}\equiv25\pmod{32}\), resulta
\(u\equiv5\cdot25\equiv29\pmod{32}\). En la fuente auxiliar,

\[
3W+1=2(3u-7),\qquad
3u-7\equiv16\pmod{32}.
\]

La primera valoración auxiliar es **exactamente 5** y su primer retorno
es \(Z=(3u-7)/16\), impar. Luego

\[
3Z+1=(9u-5)/16=2^{b-6}Y.
\]

Su segunda valoración es **exactamente \(b-6\ge1\)**. La palabra auxiliar
\((5,b-6)\) y la original \((1,b)\) terminan en el mismo impar \(Y\).

## Libros y costes independientes

El prefijo de \(m\) pares tiene libro
\((2m,3m,5(9^m-8^m))\). Los dos finales y sus composiciones son:

| Ruta | Retornos | Suma de valoraciones | Aditivo \(B\) |
| --- | ---: | ---: | ---: |
| Original \(X\to Y\), \((1,b)\) | 2 | \(b+1\) | 5 |
| Auxiliar \(W\to Y\), \((5,b-6)\) | 2 | \(b-1\) | 35 |
| Original local \(F\to Y\) | \(2m+2\) | \(3m+b+1\) | \(45\cdot9^m-40\cdot8^m\) |
| Auxiliar local \(w\to Y\) | \(2m+2\) | \(3m+b-1\) | \(45\cdot9^m-10\cdot8^m\) |

La diferencia de sumas de valoraciones es 2. Como comprobación cruzada,
\(B_{F\to Y}=4B_{w\to Y}-15\cdot3^{2m+2}\), acorde con
\(F=4w+15\) y con la diferencia de dos en \(S\). El libro **absoluto
original** es

\[
N\to Y:\quad
\left(62+2m,\ 96+3m+b,\
3^{2m+2}B_{60}+2^{95}(45\cdot9^m-40\cdot8^m)\right).
\]

El libro auxiliar empieza en \(w\); no hereda el prefijo \(N\to F\).

## Recibo y límite

**REVALIDATED, test dirigido sin barrido:** la única congruencia
\(F+5\equiv1344\pmod{2048}\) para \(m=1\), \(b\ge7\), se resuelve
en la fila como \(s\equiv599\pmod{1024}\). El representante \(s=599\)
da \(r=3\), \(b=7\), palabras \((1,2,1,7)\) y \((1,2,5,1)\),
\(B=85\) y \(B=325\), y el mismo
\(Y=2011405405399423189520561733293\). Esto muestra que la guarda
no es vacía; la prueba universal es la algebraica anterior.

**GO / alcance.** La provocación pasa esta auditoría PAPER: da captura
desde una fuente positiva menor que el **mismo** \(N\) para las semillas
que satisfacen la guarda. No acredita aparición de la guarda para todo
\(N\), primer cruce, descenso de \(Y\) bajo \(N\), ni una prueba global
de terminación. El siguiente portón es integrar esta hoja en el árbol
exhaustivo sin cambiar su dominio o su nivel de evidencia. Sin nuevos
barridos ni compilaciones en esta auditoría.
