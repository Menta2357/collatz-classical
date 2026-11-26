# Q43 · Captura pagada tras agotar la demora con \(D\equiv0\pmod3\)

**Papel.** Se conserva el origen impar \(N\), el pivote físico \(P=T^p(N)\) y su libro \((p,S_P,B_P)\). Se trabaja en una fila variable de Q41 con \(N<P<2N+1\), por ejemplo \(k=7177+8192t\), donde \(p=43\). Se fija la ruptura original 2 después de \(R\ge2\) unos desde P. Se usa la notación \(P+1=2^{R+1}v\), \(h=2\), \(W=(3^Rv-1)/4\), \(V+5=6(W+1)\) de [Q42](../q42/FRONTERA_Q42.md). La fuente inicial de esta demora es \(w_0=(P-1)/2<N\).

Sean \(D=\nu_2(W+1)=3m\), \(m\ge1\), y \(W+1=2^{3m}u\), con \(u\) impar. El original agota \(m\) parejas \((1,2)\) en A, y la fuente inicial agota \(3m-1\) unos en B. Las coordenadas quedan

\[
A=2\cdot3^{2m+1}u-5,\qquad B=2\cdot3^{3m-1}u-1.
\]

Las pendientes reflejan relojes impares distintos. De Bono propone conservar el reloj y cambiar el terminal una arista más para tasar una fuente alternativa. Se coteja también el límite de un empalme afín uniforme que mantenga la fuente inicial.

## Captura después de una primera ruptura débil

Supóngase que A realiza una valoración 2 hasta Y y que la valoración real siguiente es \(e\ge1\). Entonces

\[
Y=(3^{2m+2}u-7)/2,\qquad 3Y+1=(3^{2m+3}u-19)/2.
\]

Para cualquier \(s\ge1\), si \(e\ge2s+1\) y \(Y<4^sN\), hay captura en \(K=T(Y)\) desde

\[
\omega=\frac{Y-(4^s-1)/3}{4^s},\qquad 0<\omega<N.
\]

En efecto, \(3Y+1\) es múltiplo de \(2\cdot4^s\), y \(3\omega+1=(3Y+1)/4^s=2^{e-2s}K\). La divisibilidad por \(4^s\), la integridad de \((4^s-1)/3\) y la coprimalidad con 3 dan \(\omega\) entero. El último cociente es impar, la valoración auxiliar exacta es \(e-2s\ge1\), y \(3\omega+1\ge2\) da \(\omega>0\). El precio estricto sigue de \(Y<4^sN\). La llegada a 1 usa la inducción para \(\omega\). La fuente es distinta de \(w_0\).

## Libros físicos

Sea \(C_A=9^m(3^{R+1}-2^{R+1})+5\cdot2^{R+2}(9^m-8^m)\). El original desde P realiza \((1^R,2,(1,2)^m,2,e)\) hasta K, con libro

\[
(R+2m+3,\ R+3m+4+e,\ 9C_A+7\cdot2^{R+2+3m}).
\]

En particular, hasta A el libro local es \((R+2m+1,R+2+3m,C_A)\). Se obtiene de \(8^m A=9^m V+5(9^m-8^m)\). Cada arista posterior actualiza el aditivo por \(C'=3C+2^S\). Para obtener el libro absoluto desde N, se compone cualquier fila local \((q,S,C)\) con \((p,S_P,B_P)\) mediante \((p+q,S_P+S,3^qB_P+2^{S_P}C)\).

El libro pagado de \(\omega\) es \((1,e-2s,1)\). Por separado, el libro de la fuente inicial \(w_0\) hasta B tiene \(R+3m-1\) retornos, \(R+3m+1\) divisiones y aditivo

\[
3^{3m-1}(3^R-2^R)+2^{R+2}(3^{3m-1}-2^{3m-1}).
\]

## Realización y demoras arbitrariamente largas con pago

Sea \(z=u/3=(3^{R-1}v+1)/2^{3m+2}\). Es impar y \(3\nmid z\), por \(R\ge2\). Para cada \(R,m,e\), se puede fijar la siguiente congruencia de z y después la de v:

\[
3^{2m+4}z\equiv19+2^{e+1}\pmod{2^{e+2}},\qquad
3^{R-1}v+1\equiv 2^{3m+2}z\pmod{2^{3m+e+4}}.
\]

Ambas son resolubles por coeficientes impares. La segunda conserva \(h=2\), pues \(3^Rv-1=3(3^{R-1}v+1)-4\equiv4\pmod8\). Esto da \(3^{R+1}v\equiv3\pmod4\), fuerza \(b=2\) y fija \(D=3m\). En la primera, la reducción módulo 4 fuerza \(3^{2m+2}u\equiv1\pmod4\), así que la valoración desde A es exactamente 2. La congruencia completa da la valoración real e desde Y. En una fila variable de Q41, \((P+1)/2^{R_{\min}+1}=L_0+L_1t\), con \(L_1\) impar. Se fija el v anterior haciendo \(L_0+L_1t\equiv2^{R-R_{\min}}v\) en el módulo de v aumentado en \(R-R_{\min}\) bits. El t queda en una progresión infinita del mismo origen físico.

Para mostrar pago arbitrariamente tarde que termina por encima de N, fijemos R y una fila variable, con cociente de pendientes \(\lambda=P_1/N_1\). Al crecer t en cada progresión realizada, se obtiene

\[
Y/N\longrightarrow c_m=(9/16)(3/2)^R(9/8)^m\lambda.
\]

Para cada s suficientemente grande, elíjase el primer \(m\ge1\) con \(c_m\ge(3/4)4^s\). Al multiplicarse por \(9/8\) a cada macro, \(c_m<(27/32)4^s\), y estos m crecen sin cota. Fijando \(e=2s+1\) y tomando un t suficientemente grande de la progresión anterior, se obtienen las desigualdades estrictas \((2/3)4^sN<Y<4^sN\). Entonces \(\omega<N<K\). Cada realización usa una semilla propia y mantiene fijo ese mismo N en la comparación.

**Testigo dirigido.** En \(k=7177+8192t\), se fijaron \(R=10\), \(m=14\), \(D=42\), \(e=9\), \(s=4\). La congruencia para t da \(t=1952084323634960330\) módulo \(2^{63}\). Se comprobaron físicamente las palabras desde N, desde \(w_0\) hasta B y desde \(\omega\). En el encuentro se obtiene

\[
\omega=3378570456151832752928158264839702707619
<N=4609228790834498929354637771913861516415
<K=5067855684227749129392237397259554061429.
\]

Hubo 14 macros expansivos en el original y 41 unos después de W en la ruta de \(w_0\). Todos los estados originales anteriores al encuentro superan N. Los libros absolutos del encuentro son \((84,133,75637140072369360789220722879257315726353)\) y \((1,1,1)\).

## Dos límites de empalme de la fuente inicial

Si dos palabras uniformes desde A y B, de longitudes respectivas \(q_A,q_B\), encontraran el mismo terminal como afines de u en una progresión infinita con m fijo, comparar pendientes exigiría

\[
q_A-q_B=m-2,\qquad S_A=S_B,\qquad C_A^*-C_B^*=5\cdot3^{q_A}-3^{q_B},
\]

donde asterisco denota el aditivo de la cola posterior al agotamiento. En particular, el mismo molde de longitud posterior acotada no cubre m arbitrario. Esto no excluye coincidencias puntuales ni palabras de longitud dependiente de m.

La primera ruptura de A ofrece otro contraste. Con valoración fija \(a\ge2\), el sucesor es \((3^{2m+2}u-7)/2^{a-1}\). Un predecesor físico obtenido por una palabra inversa fija sólo podría tener \(\nu_3(x+1)\) creciendo con m si esa palabra, aplicada hacia delante al término constante \(-1\), produjera \(-7/2^{a-1}\). El motivo es que el coeficiente de u ya es múltiplo de \(3^{2m+2}\), y un término constante no nulo fija la valoración ternaria al crecer m. En el mapa afín de términos constantes, la magnitud positiva de una constante negativa evoluciona como \(z\mapsto(3z-1)/2^d\). Desde 1, mientras permanece positiva sólo puede ser una potencia de dos: se queda en 1, baja a \(1/2\), o llega a \(z\le1/4\) y sale del semieje positivo en la arista siguiente. No puede ser \(7/2^{a-1}\). El molde que intenta recuperar una racha arbitraria de inversas de uno inmediatamente después de la ruptura queda así cerrado. El contraejemplo de molde no limita las fuentes alternativas con otro término constante.

**Alcance.** La captura se activa bajo una guarda realizable de la segunda valoración y su precio. En particular no depende de que la primera salida de A sea fuerte. Queda abierta la continuación que evita el umbral posterior, y no se prueba que cada semilla fija lo active. Se hizo una sustitución dirigida del testigo, sin barrido ni Lean.
