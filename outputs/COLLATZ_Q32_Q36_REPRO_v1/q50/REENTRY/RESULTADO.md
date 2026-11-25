# Front4b · Rachas alternas desde el residual s=29 módulo 32

**Prueba en papel.** El origen es el mismo \(N\) de Q49 y el pivote es \(V=T^{62}(N)\), con \(s=29+32u\) y \(u\ge0\) par. De Bono comparó renovar la fuente en la reentrada con transportar su órbita desde \(V\). El contraste fue la primera racha variable de pares tras la ruptura débil. [Dominio Q49](../../q49/BALANCE_Q49.md)

## Fuente inicial y pérdida de precio

Se tiene \(V\equiv7\pmod8\), \(V<2N+1\) y
\[
5V-6N=22353527237975256080252922593+24504888169540223592778743924u>0.
\]
Sea \(r=\nu_2(V+1)-1\ge2\), y \(b\ge2\) la valoración real tras esos \(r\) unos. La fuente \(w=(V-1)/2\) es impar positiva menor que \(N\). Hace exactamente \(r-1\) unos hasta \(Z\), mientras el original termina sus unos en \(Q=3Z+2\). **Para todo \(b\ge3\)**, \(Z\equiv1\pmod8\), por lo que la fuente hace un retorno de valoración 2 a \((3Z+1)/4\), cuyo numerador siguiente es \((3Q+1)/4\). Las palabras \((1^r,b)\) desde \(V\) y \((1^{r-1},2,b-2)\) desde \(w\) comparten terminal. Es una nueva instancia del [consumidor Q17](../../lean/A2HalfAdaptive.lean). La llegada a uno usa la convergencia inductiva de \(w\).

Si \(b=2\), el terminal original es \(Y=(9Z+7)/4\). La identidad
\[
Y+\tfrac12=\tfrac34(\tfrac32)^r(V+1)\ge\tfrac{27}{16}(V+1)
             >\tfrac{81}{40}N+\tfrac{27}{16}
\]
da **\(Y>2N+1\)**. La nueva media \((Y-1)/2\) supera \(N\). Como \(Y\equiv1\pmod3\), esa media es múltiplo de tres y, cuando es impar, carece de predecesores físicos a cualquier profundidad positiva. Las dos propiedades persisten en los extremos de los pares \((1,2)\) y de las rachas \((1^r,2)\) siguientes, que crecen y terminan en la clase \(1\pmod3\).

Toda fuente pagada que llegue a este primer \(Y\) necesita al menos \(r+2\) retornos. Para una fuente impar \(a<N\) a profundidad \(d\), la última valoración es par y al menos dos, pues \(Y\equiv1\pmod3\). La cota de crecimiento da
\[
Y+\tfrac12\le \tfrac34(\tfrac32)^{d-1}(a+1)
<\tfrac34(\tfrac32)^r(V+1)=Y+\tfrac12
\]
si \(1\le d\le r+1\). A profundidad cero, \(Y>N\).

## Calendario conjunto después de la ruptura débil

Supóngase que \(Y\) empieza con al menos un par \((1,2)\). Como \(Y+5=9(Z+3)/4\), resulta \(\nu_2(Z+3)\ge6\). La fuente histórica hace exactamente un retorno de valoración 3 de \(Z\) a \(A=(3Z+1)/8\), con \(Y+5=6(A+1)\).

Escribamos \(Y+5=2^{3m+j}\,3t\), con \(m\ge1\), \(j\in\{1,2,3\}\) y \(t\) impar positivo. El original realiza exactamente \(m\) pares y acaba en \(X+5=2^j3^{2m+1}t\). La fuente desde \(A\) realiza exactamente \(h=3m+j-2\) unos y acaba en \(B+1=2\cdot3^h t\).

En este tramo, los extremos de los pares originales tienen residuo uno módulo tres. Los estados auxiliares tras al menos un uno desde \(A\) tienen residuo dos. En el punto medio original \(L\) de cualquier par se tiene \(\nu_3(L+1)=1\), ya que el extremo inmediatamente anterior tiene residuo uno y \(L+1=3(x+1)/2\) desde ese extremo \(x\). En el auxiliar, tras al menos dos unos, la valoración de estado más uno es al menos dos. Tampoco hay encuentro con \(A\) ni con su primer sucesor, ambos menores que \(Y\). Los estados precedentes de esa fuente son a lo sumo \(Z<Y\). Esto excluye un encuentro de ambos tramos con relojes independientes.

El original inicia otra racha de al menos dos unos en \(X\) exactamente cuando \(j=2\). Póngase \(J=3^{2m+1}t\) en esa fase. La siguiente longitud original es \(R=1+\nu_2(J-1)\). La siguiente ruptura de la fuente, después de sus \(3m\) unos, tiene valoración
\[
e=1+\nu_2(3^mJ-1).
\]
Si \(\lambda=\nu_2(3^m-1)\), la identidad \(3^mJ-1=3^m(J-1)+(3^m-1)\) da \(e=R\) si \(R-1<\lambda\), \(e=1+\lambda\) si \(R-1>\lambda\), y \(e\ge2+\lambda\) en la igualdad. Para \(m\) impar, \(\lambda=1\). Este calendario enlaza las dos salidas físicas y deja abierta su coalescencia posterior.

### Condición necesaria para un encuentro en las dos salidas

En la fase \(j=2\), escribamos \(J=1+2^{R-1}v=3^{2m+1}t\), con \(v\) impar. Para la ruptura real \(b'\ge2\) tras los \(R\) unos originales, los dos terminales que se comparan son
\[
O=\frac{3^{R+1}v-1}{2^{b'-1}}=T^{64+r+2m+R}(N),\qquad
P=\frac{3^mJ-1}{2^{e-1}}=T^{r+3m+1}(w).
\]
Si \(O=P\) y \(k=\min(R+1,3m+1)\), los numeradores son ambos \(-1\) módulo \(3^k\), porque \(3^mJ=3^{3m+1}t\). Por ello \(2^{|b'-e|}\equiv1\pmod{3^k}\). El orden de 2 módulo \(3^k\) es \(2\cdot3^{k-1}\). En efecto, el exponente debe ser par módulo tres y \(\nu_3(4^\ell-1)=1+\nu_3(\ell)\) para \(\ell\ge1\), por factorización. Cada elevación al cubo añade un factor tres, mientras que un exponente coprimo con tres conserva la valoración.

La igualdad \(b'=e\) es imposible. Daría \((3^{R+1}-3^m2^{R-1})v=3^m\). Como \(3\nmid v\) por \(J\equiv0\pmod3\), resulta \(v=1\) y \(J=1+2^{R-1}\) sería una potencia de tres divisible por 27. Para \(R=2,3\) se obtienen 3 y 5. Para \(R\ge4\), \(J\equiv1\pmod8\) fuerza exponente par. Si \(J=3^{2h}\), los factores \(3^h-1\) y \(3^h+1\) de \(J-1\) son potencias de dos que difieren en dos. Deben ser 2 y 4, lo que da \(J=9\), también imposible.

Tampoco puede cumplirse \(b'<e\). Si \(R-1\ne\lambda\), entonces \(e=\min(R,\lambda+1)\le k\), pues \(2^\lambda\le3^m-1<2^{2m}\). La diferencia positiva \(e-b'\) queda por debajo del orden de 2. Si \(R-1=\lambda\), pongamos \(A_0=2^{R-1}\le M-1\), \(M=3^m\) y \(n=e-b'\). Un encuentro daría
\[
\bigl(3^{R+1}2^n-MA_0\bigr)v=2^n+M-1,\qquad
2^n=\frac{MA_0v+M-1}{3^{R+1}v-1}\le\frac{M(A_0+1)}{3^{R+1}-1}\le M.
\]
El coeficiente positivo entero de \(v\) en la primera ecuación implica \(v\le2M-1\). En cambio, \(J\ge3M^2\) da \(v\ge(3M^2-1)/(M-1)>3M\).

Así, un encuentro en estos **dos terminales** exige \(b'-e\ge2\cdot3^{k-1}\). Además, volviendo a la ecuación del encuentro con \(n=b'-e>0\), su coeficiente positivo impone \(2^{n+R-1}<3^{R+1-m}\). Si \(R\le3m\), se tiene \(k=R+1\) y \(2^n\ge2^{2\cdot3^R}>3^{R+1}\), contradicción. En particular, quedan excluidas todas las segundas rupturas originales \(b'=2\) en esos dos terminales y cualquier encuentro allí con \(R\le3m\). Siguen sin decidirse los encuentros en otras profundidades y los casos fuertes que superan ambas cotas.

## Libros y realización

Sea \(B_{62}=2417122598839266567112547605177\). Para cualquier primera ruptura \(b\), el libro original es
\[
(63+r,\ 98+r+b,\ B_Y),\qquad
B_Y=3^{r+1}B_{62}+2^{98}(3^{r+1}-2^{r+1}).
\]
Cuando \(b\ge3\), se encuentra con el libro auxiliar \((r+1,r+b-1,3^{r+1}-2^r)\). Cuando \(b=2\), el libro original hasta \(X\) es \((63+r+2m,100+r+3m,9^mB_Y+2^{100+r}5(9^m-8^m))\). El libro auxiliar hasta \(A\) es \((r,r+2,3^r-2^r)\). Al añadir los \(h\) unos a este último se suman \(h\) a ambos relojes y el aditivo pasa a \(3^h(3^r-2^r)+2^{r+2}(3^h-2^h)\).

Toda lista finita de bloques \((1^{r_i},2)(1,2)^{m_i}\) con \(r_i\ge2,m_i\ge1\), seguida por \((1,1)\), se realiza en una progresión de \(u\) par. Para la palabra completa de longitud \(L\), suma \(S\) y aditivo \(C\), la ecuación física equivale a \(3^L V+C\equiv2^S\pmod{2^{S+1}}\), por reconstrucción inversa de los retornos impares. El residuo inicial exige \(V\equiv7\pmod8\). Como la pendiente de \(V\) tiene valoración dos y el intercepto vale siete módulo ocho, se obtiene una clase de \(u\) par módulo \(2^{S-1}\). Las rachas y los pares son máximos porque el bloque siguiente empieza con dos unos.

El contraste exacto en \(u=141218+524288z\) realiza \((1^2,2)(1,2)(1^3,2)(1,2)^2(1,1)\). Se comprobó coeficiente a coeficiente. El primer \(m=1\) seguido por \(R=3\) da la ruptura auxiliar \(e=2\). Cada bloque físico de la lista crece. Repetir infinitamente un mismo bloque o una misma lista fija obligaría a la semilla en ese punto a igualar su punto fijo 2-ádico negativo \(-C/(3^L-2^S)\), por divisibilidad de la diferencia por \(2^{nS}\) para todo \(n\). Esto excluye un calendario eventualmente periódico de estos bloques en una semilla positiva. La realización finita no excluye un calendario aperiódico infinito en una semilla fija, ni aporta una captura exterior. La primera obligación pendiente es producir un encuentro posterior a una de las dos salidas o un recurso que siga decreciendo en esos cambios de longitud.
