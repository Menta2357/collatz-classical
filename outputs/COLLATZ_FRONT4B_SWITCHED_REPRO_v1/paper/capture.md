# Front4b. Capturas tras cambiar de pareja débil

## Dominio y notación

Se conserva el mismo \(N\) original y el checkpoint \(J\) de las [dos filas E1](../../COLLATZ_FRONT4B_GUARDS_REPRO_v1/paper/E1.md). Partimos de la palabra física \((1^L,2,b,1^H,2,d)\), con \(L,H\ge2\), \(b\in\{1,2\}\) y \(d=3-b\). El primer par termina en \(Z_1\), el segundo en \(Y\). Los cofactores exactos cumplen
\[
J+1=2^{L+1}Q,\qquad Z_1+1=2^{H+1}Q',\qquad
2^{H+b+2}Q'=3^{L+2}Q+2^{b+1}-1.
\]
Los dos cofactores son positivos e impares. Si \(2^{H+b+2}<3^{L+2}\), se tiene \(Q'>Q\). En particular \(H=L\) realiza crecimiento en ambos sentidos del cambio para cualquier \(L\ge2\).

## Familia de captura con \(L,H\) sin cota fija

Si el original alcanza un estado \(X\) con \(3N<X<4N\) y su siguiente valoración real es 3, su terminal \(P=(3X+1)/8\) satisface \(P>N\). Desde \(w=(X-1)/4\), impar positivo menor que \(N\), una valoración exacta 1 llega al mismo \(P\), porque \(3w+1=2P\). El lema Lean **captureAtThree** compone el retorno de valoración 3 con el historial original y conserva para \(w\) un libro aparte \((1,1,1)\). El pago consume la hipótesis inductiva para \(w\).

Para cada fila y cada \(L,H\ge2\), se puede imponer físicamente en una progresión una continuación \(2^r,3\) desde \(Y\) que active esta guarda. Los cocientes de pendientes de \(J\) y \(N\) son \(j_3=3^{65}/2^{102}\) y \(j_5=3^{66}/2^{104}\). El cociente de pendientes de \(Y\) y \(N\) es, para las dos orientaciones,
\[
A=j_c\,\frac{3^{L+H+4}}{2^{L+H+7}}.
\]
La cota \(A>4\) se comprueba en \(L=H=2\) por enteros y aumenta con \(L+H\). Sea \(r\ge1\) el menor entero con \(A(3/4)^r<4\). Existe por contracción geométrica y, por minimalidad, \(A(3/4)^r\ge3\). La igualdad con 3 exigiría que una potencia positiva de 3 fuese una potencia de 2, por lo que el coeficiente queda estrictamente entre 3 y 4.

Para realizar la palabra completa \(\mathcal W=(1^L,2,b,1^H,2,d,2^r,3)\), sea \((h,s,C)\) su libro local. Impóngase \(3^hJ+C\equiv2^s\bmod2^{s+1}\). Esta congruencia fija un único residuo de \(J\). Es \(7\bmod8\): los primeros dos unos contribuyen \(5\cdot3^{h-2}\), y el coste restante es \(4\) veces un impar, módulo 8. Cada fila E1 tiene \(J\equiv7\bmod8\) y pendiente 8 veces un impar. Dividir la congruencia por 8 da una clase de su parámetro módulo \(2^{s-2}\). Su terminal es impar y positivo para parámetros suficientemente grandes, y el libro con las valoraciones positivas recompone la palabra física exacta. En esa progresión, \(X\) después de los \(r\) doses y antes del 3 tiene el cociente de pendientes calculado. A partir de un parámetro explícitamente acotable por los interceptos, \(3N<X<4N\) se cumple estrictamente.

En esta familia ningún punto original desde \(J\) hasta el encuentro desciende bajo \(N\). Los unos crecen. Cada par débil, después de al menos dos unos, termina por encima de la entrada de esos unos, incluso cuando \(b=2\) o \(d=2\). Los doses finales bajan hacia \(X>3N\), y el encuentro final está sobre \(N\). Los prefijos E1 anteriores a \(J\) también permanecen sobre la semilla. Así, para ambas orientaciones, se obtienen familias de capturas por encima de \(N\) con longitudes arbitrarias y cofactor creciente cuando se satisface la desigualdad indicada. El lema Lean certifica la captura a partir de la guarda. La elección de \(r\), la realización congruencial y la condición de crecimiento se demuestran aquí aritméticamente.

## Traslado de las capturas anteriores en una ventana de altura

En \(b=1,d=2\), se retrocede **un retorno físico** desde \(Z_1\) al terminal \(F=(2Z_1-1)/3\) del primer dos y se usa su libro desde \(N\). El tramo de unos desde \(F\) tiene longitud exacta \(H+1\). Como \(3(F+1)=2(Z_1+1)\), se tiene \(3\mid Q'\) y el cofactor para ese tramo es \(Q'/3\). La fuente es
\[
w=(F-3)/4=(Z_1+1)/6-1,
\]
y hace \(H-1\) unos frente a los \(H\) originales desde \(Z_1\). Las fases desde el final de los unos siguen siendo las de [TAIL22](../../COLLATZ_FRONT4B_WEAK_21_22_REPRO_v1/paper/tail22.md), porque \(3^{H+1}(Q'/3)=3^HQ'\). **oneThenTwo** transporta ambas fases conservando el mismo \(N\).

En \(b=2,d=1\), se usa el propio \(Z_1\) como entrada de [TAIL21](../../COLLATZ_FRONT4B_WEAK_21_22_REPRO_v1/paper/tail21.md). **twoThenOneFixed** compone el libro real de la primera pareja con el certificado de la segunda. Las ventanas siguientes son las que financian estas elecciones de fuente en las dos filas, al comparar interceptos y pendientes. Dentro de ellas, la realización exacta de la fase se hace por congruencia en el cofactor inicial.

| Sentido | Fila | Longitudes \(L\) con la ventana | Longitudes \(H\ge2\) con crecimiento dentro de esas ventanas |
|---|---|---|---|
| \(1\to2\) | \(c=3\) | \(L=2\) | \(H\le3\) |
| \(1\to2\) | \(c=5\) | \(L=2,3\) | \(H\le3\) en \(L=2\); \(H\le4\) en \(L=3\) |
| \(2\to1\) | ambas | \(L=2,3\) | \(H\le2\) en \(L=2\); \(H\le3\) en \(L=3\) |

Las ventanas sólo deciden el precio. Para captura siguen siendo necesarias las fases de los certificados respectivos.

## Historia exacta y obstáculo a un empalme previo

Desde \(J\), cada episodio de longitud \(a\) de unos seguido de \((2,b)\) tiene aditivo \(D_a=3^{a+2}-2^{a+1}\), \(a+2\) retornos y \(a+2+b\) divisiones. El libro local hasta \(Y\) es
\[
(L+H+4,\ L+H+7,\ C_Y),\qquad C_Y=3^{H+2}D_L+2^{L+2+b}D_H.
\]
Tras los \(r\) doses se agrega el libro \((r,2r,4^r-3^r)\) y, después, el libro \((1,3,1)\) del último retorno. La composición con el libro absoluto \((j,S,B)\) de \(J\) transforma cualquier cola \((h,s,C)\) en \((j+h,S+s,3^hB+2^SC)\).

Se aplicó De Bono cambiando el terminal y el origen de la fuente. Hay una barrera exacta para sincronizar inmediatamente tras la primera pareja. En la coordenada \(x+1\), su coste es \(D=2^{b+2}-2\in\{6,14\}\). Si en el inicio de la pareja \(R+1=3^v(U+1)\) para un entero \(v\ge1\), un prefijo auxiliar de \(h\) retornos que produjera uniformemente \(A_1+1=\lambda(Z_1+1)\) por una identidad afín exigiría \(D_{\rm aux}/3^h=D/3^{v+2}\). La valoración 2-ádica de \(D_{\rm aux}\) sería 1. En el coste trasladado de una palabra, la primera arista distinta de uno aporta un sumando de valoración \(1\) más todas las divisiones previas, y las posteriores tienen más valoración. Por tanto, la primera arista de la palabra tendría que ser distinta de uno. Su contribución sola da \(D_{\rm aux}/3^h\ge2/3\), en contradicción con \(14/27<2/3\). La prueba se limita a fuentes de ese tipo y una relación afín uniforme. El terminal posterior elude esa restricción.

Queda abierta la obligación de forzar una ventana pagada o un descenso para cada semilla fija física cuya continuación se sale de estas fases. La construcción congruencial prueba que las guardas existen en las familias indicadas y admite longitudes arbitrarias. Los verificadores normal y optimizado reproducen los dos sentidos del cambio hasta \(L=H=37\), con ambos libros, cofactor creciente y todos los puntos originales del tramo sobre \(N\).

[Código Lean](../lean/Front4bSwitchedCapture.lean) · [Recibo](../provenance/source_receipts.json) · [Verificador exacto](check_capture.py)
