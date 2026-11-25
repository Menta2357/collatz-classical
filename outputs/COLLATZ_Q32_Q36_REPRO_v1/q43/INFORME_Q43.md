# Q43 · Salidas tras agotar la reserva de la ruptura 2

## Paso certificado para cualquier reserva

Sea \(P\) el comienzo físico de \(R\) unos desde el mismo impar \(N\), con libro previo en \(P\). Con \(P+1=2^{R+1}v\), la ruptura 2 acaba en \(V\). Cuando la fuente mitad realiza una ruptura 3, alcanza \(W=(3^Rv-1)/4\) y \(V+5=6(W+1)\). Escribimos \(W+1=2^D u\), \(u\) impar, \(D=3m+s\).

El original realiza \(m\) pares \((1,2)\) y llega a \(X=6\cdot2^s9^m u-5\). El auxiliar, desde \(W\), realiza \(D-1\) unos. Lean certifica esos segmentos y sus libros, y compone cada uno con su propio prefijo. Los aditivos locales son \(5(9^m-8^m)\) y \(3^{D-1}-2^{D-1}\), respectivamente. [Prueba y tabla de las tres salidas](RESERVA.md)

## Pagos posteriores

Sea \(z=9^m u\). Estas guardas usan siempre \(w<N\) respecto al origen. La deducción de llegada a 1 consume la inducción sobre esa fuente.

| Reserva y palabra real desde \(X\) | Trayectoria que alcanza el mismo terminal | Evidencia |
| --- | --- | --- |
| \(s=1,m=0\), \((1,1,8,e)\) | La fuente mitad, a partir de \(W\), realiza \((2,1,3,1,e+2)\) | Lean, con \(e\) libre |
| \(s=1,m=1\), \((1,1,8,e)\) | La fuente mitad, a partir de \(W\), realiza \((1,1,1,3,3,1,e+2)\) | Lean, con \(e\) libre |
| \(s=2\), \((1,7)\) | \(w=(z+1)/4-1\) realiza tres unos, si \(z+1<4(N+1)\) | Lean, para cualquier \(m\) bajo la guarda |
| \(s=0\), \((2,e)\) | Si \(Y=T(X)<4^\ell N\) y \(e\ge2\ell+1\), \(w=(Y-(4^\ell-1)/3)/4^\ell\) realiza una arista real de valoración \(e-2\ell\) | Aplicación en papel del plegado Lean existente |

Para \(s=1\), la arista de valoración 8 deja \(256A=81z-29\). Las palabras auxiliares hasta \(B=4A+1\) tienen libros \((4,7,151)\) y \((6,10,1289)\). A continuación \(3B+1=4(3A+1)\) conserva la valoración final exacta con dos divisiones adicionales. El libro desde \(X\) hasta el encuentro es \((4,10+e,1081)\). Los dos libros desde \(W\) son \((5,9+e,581)\) y \((7,12+e,4891)\).

Para \(s=2\), la palabra \((1,7)\) deja \(32Y=27z-5\) con \(Y\) impar. De aquí \(z\equiv-1\bmod64\) y \(8Y=27w+19\). El libro original desde \(X\) es \((2,8,5)\), y el de la nueva fuente es \((3,3,19)\). Para la fila de media, cuando \(m=0\) y \(R\le10\), se verifica el precio a partir de
\[
w+1=\frac{(3/2)^R(P+1)}{128}+\frac{19}{64},
\qquad P+1\le2N.
\]
La pendiente máxima de \(P+1\) es \((3/2)^{10}/128<1/2\), así que \(w+1<N+1\).

Para \(s=0\) también se verificó una captura directa en la primera salida, con tres macros y valoración 5. En \(k=125120985+134217728j\) termina en T53, con libro \((53,84,111326109530627345129294003)\). Usa la fuente mínima \((2E-1)/3\) de un retorno al terminal \(E\), factible porque la valoración original es impar y \(2E<3N+1\). El margen entre esa fuente y \(N\), y el margen entre \(E\) y \(N\), son positivos en toda la progresión. Una valoración original par da una fuente mínima \((4E-1)/3\), demasiado alta si \(E>N\).

El verificador afín comprueba **cinco progresiones completas**, incluida una con **14 macros** y una captura posterior a la salida débil 2. En cada progresión todo el prefijo original no inicial queda por encima de \(N\), y la fuente menor alcanza su terminal. Las progresiones refinan \(k\equiv78297,89097\pmod{131072}\), fuera de los 186 residuos totalmente cubiertos por Q41. Las cinco palabras de Q43 se distinguen físicamente de las guardas nuevas de Q42. Los dos residuos siguen parcialmente cubiertos. [Verificador](verify_capture_families.py) · [Libros y familias](FAMILIAS.json) · [Prueba con 14 macros](A2_D0_POST_DELAY_PAPER.md)

## El agotamiento deja una reserva nueva

En \(s=1\) se cumple \(X+1=4(3^{2m+1}u-1)\). Por tanto la racha siguiente tiene longitud exacta
\[
L=1+\nu_2(3^{2m+1}u-1)\ge2 .
\]
Incluso fijando \(R\) y \(m\ge1\), cualquier \(L\ge2\) se realiza en una fila de pendiente impar de Q41. Basta elegir
\[
3^{2m+1}u\equiv1+2^{L-1}\pmod{2^L},
\quad
3^Rv\equiv 2^{D+2}u-3\pmod{2^{D+L+2}}.
\]
La segunda igualdad fija \(h=2\), \(D\) y el cofactor módulo \(2^L\). La congruencia de \(v\) se traduce a la de la fila por su pendiente impar. Como \(X\ge V>P>N\), todos esos retornos posteriores aumentan respecto al origen fijo. El tiempo hasta un descenso a partir de \(X\) carece de cota en función sólo de \(R\) y \(D\). Una fuente alternativa aún puede pagar antes.

Este es el límite relevante para la siguiente decisión de De Bono. Cambiar el terminal a través de \(A,4A+1\) produce las nuevas capturas y cambiar la fuente permite pagar la salida \((1,7)\). En el complemento, la reserva agotada no controla la que aparece después. La obligación pendiente es una comparación estricta que sobreviva al conector completo, o una fuente menor cuya activación se demuestre para cada semilla fija.

## Precio de una nueva fuente mitad

En las trece filas Q41, **todo agotamiento con \(m\ge1\) produce \(X>2N+1\)**. Por tanto la nueva fuente \((X-1)/2\) es estrictamente mayor que \(N\). La identidad que conserva el origen es
\[
X+5=\left(\frac98\right)^m
  \left[\frac34\left(\frac32\right)^R(P+1)+\frac92\right].
\]
Cuando \(R\ge3\), \(P>N\) basta, pues el coeficiente de \(P+1\) es al menos \(729/256>2\) y el término constante después de restar 5 es al menos \(1/16\). Si \(R=2\) en una fila alta, ya se tiene \(P>2N+1\) y \(X>P\). Las dos filas de media restantes son 7177 y 1881. Sus márgenes afines \(9(P+1)-10N\) tienen interceptos 19861549189181474586 y 5206240991242401658, y pendiente común 22669238058443520664 para sus respectivos parámetros. Por tanto \(X>(135/64)N>2N+1\) allí también.

Para \(s=1\), incluso si \(m=0\), el primer uno del conector da \(T(X)>2N+1\) mediante \(X\ge V\) y \(V+1\ge(27/16)(P+1)+1/2\). Queda abierta una readmisión con otra fuente o con un rango que incluya el precio histórico. Esta cota se obtuvo en papel usando las guardas afines de Q41.


## Profundidad inversa en la fase \(s=1\)

Tras los dos unos obligatorios, el terminal es \(J=3^{2m+3}u-10\) y la reserva ternaria de \(J+10\) vale exactamente \(2m+4\), pues \(\nu_3(u)=1\) en la rama \(h=2\). Para las inversas hasta esa profundidad, escribimos el estado como \(2^A(J+10)/3^i-q\). El defecto entero positivo empieza en 10 y se transforma por \(q\mapsto(2^a q+1)/3\). Permanece al menos 5 y, en dos inversas físicas de exponentes \(a,b\), satisface \(q''\le 2^{a+b}q/8\). La última desigualdad sigue de \(q\ge10\) o de las valoraciones mínimas de los únicos defectos menores que 10 que admiten una arista, 5 y 7.

La escalera que invierte \((1,1)\) y luego los pares alcanza simultáneamente la menor altura posible por profundidad hasta esa reserva. Con \(2m+2\) inversas da \(V\). Con \(2m+3\) da \((4V-1)/3\), y con \(2m+4\), \((8V-5)/9\). Este último coincide con el estado anterior a la última pareja original \((1,2)\) al llegar a \(V\); lo preceden \(R-1\) unos desde \(P>N\). Por tanto una fuente pagada directamente en \(J\) requiere **al menos \(2m+5\) retornos** en este dominio. Las nuevas capturas aprovechan un terminal posterior. Esta cota se comprobó en papel.
