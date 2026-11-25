# Q42 · Ruptura 2 de la rama (1,1) de A2

Sean \(N\) el origen impar positivo, \(P=T^p(N)\) el inicio físico de la racha, y \((p,S_P,B_P)\) su libro histórico. Escribimos \(P+1=2^{R+1}v\), con \(v\) impar y \(R\ge2\). La palabra original \((1^R,2)\) termina en \(V=(3^{R+1}v-1)/2\).

## Dos guardas de captura y una de descenso

Cuando \(P<2N+1\), las continuaciones \((6,e)\) y \((1,6,e)\) desde \(V\) dan una captura con la fuente \(w=(P-1)/2<N\) para cualquier valoración final real \(e\ge1\). La prueba construye dos estados \(A\) y \(4A+1\) en las trayectorias original y auxiliar. La identidad \(3(4A+1)+1=4(3A+1)\) hace coincidir sus retornos acelerados y fija la diferencia de dos divisiones. Llegar a 1 a partir de la captura consume la inducción para \(w\). [Prueba y libros separados](RESULTADO_CAPTURA.md)

Para cualquier pivote del dominio, sea \(U=T(V)\) y \(a=\nu_2(3V+1)\). Se cumple
\[
2^{R+2+a}U+2^{R+1}=3^{R+2}(P+1).
\]
La guarda exacta de descenso \(U<N\) es \(2^{R+2+a}(N-1)+2^{R+1}\ge3^{R+2}(P+1)\). La formulación equivalente con desigualdad estricta es \(2^{R+2+a}N+2^{R+1}>3^{R+2}(P+1)\). La cota certificada en Lean permite usar \(D(P+1)\le A N\) y \(A3^{R+2}\le D2^{R+2+a}\), con \(D>0\). El libro desde \(N\) es
\[
(p+R+2,\ S_P+R+2+a,\ 3^{R+2}B_P+2^{S_P}(3^{R+2}-2^{R+1})).
\]

Los dos testigos de captura de Q42 pertenecen a \(k\equiv89097\pmod{131072}\), fuera de la unión anterior de 186 residuos. Cada testigo representa una progresión infinita de módulo más fino. El residuo común conserva salidas abiertas.

## Demora realizable con la misma fuente

Para la ruptura débil escribimos \(3^Rv-1=2^hW\), con \(h\ge2\) y \(W\) impar. Desde \(w\) se realizan \(R-1\) unos y una valoración \(h+1\), hasta \(W\); desde \(P\) se alcanza \(V=1+3\cdot2^{h-1}W\). Ambos libros salen de esas palabras exactas.

Con \(h=2\), \(V+5=6(W+1)\). Para cualquier entero \(L\ge1\) se puede imponer \(W\equiv-1\pmod{2^{3L+3}}\). En una fila variable de Q41, sea \(t\) su parámetro, \(R_{\min}\) la longitud mínima y \(H(t)=(P+1)/2^{R_{\min}+1}\) su afín de pendiente impar. Se resuelve
\[
3^R H(t)\equiv-3\cdot 2^{R-R_{\min}}\pmod {2^{R-R_{\min}+3L+5}}.
\]
La congruencia realiza \(v\) impar, \(h=2\) y \(b=2\) con el mismo origen físico de la fila. En la fila de \(1001\) la pendiente del afín tiene valoración 1; el término constante y el objetivo son impares, de modo que se resuelve después de dividir por 2. Las semillas se toman positivas dentro de la progresión.

Las identidades de aristas del ciclo \(-5\leftrightarrow-7\) y el punto fijo \(-1\) transportan las congruencias perdiendo a lo sumo \(3L\) bits hasta el retorno \(2L\). Las dos trayectorias físicas positivas ocupan residuos distintos módulo 8 en todos los relojes de esos sufijos. El original está en 3 o 1 y el auxiliar en 7. No hay encuentro en esas ventanas, aunque se comparen relojes distintos. El original realiza \((1,2)^L\) y cada macro expande, pues \(T^2(V)+5=(9/8)(V+5)\). El retorno intermedio también sube. Como el primer \(V\) supera \(P>N\), no hay descenso en el tramo.

Para una semilla fija, \(D=\nu_2(W+1)\) es finito. El sufijo original tiene exactamente \(\lfloor D/3\rfloor\) macros \((1,2)\) y el auxiliar tiene exactamente \(D-1\) unos. La obligación pendiente es cobrar el conector posterior a ese agotamiento o construir una fuente distinta. La demora excluye un horizonte uniforme para esta fuente y estos sufijos, incluso fijando \(R\) y la fila.

## Decisión de De Bono

La búsqueda inicial apuntaba al terminal \(V\). Se cambió el terminal a un retorno posterior a una pareja \(A,4A+1\) y se separó la refutación por demora de la búsqueda de fuente. Los certificados usan aristas impares exactas. Para el complemento queda consumir la reserva real \(D\) y controlar su conector. La activación de las dos guardas para cada semilla sigue abierta.

## Progresión nueva cuando la fuente mitad cuesta demasiado

En la fila \(k=425+2048t\), \(P=T^{42}(N)\) y la fuente \((P-1)/2\) supera \(N\). Para \(R=8\) se resuelve \(3^{10}v\equiv257\pmod{512}\) con \(P+1=2^9v\). La condición equivale a \(t\equiv14966\pmod{16384}\) y realiza en toda la progresión
\[
k=30650793+33554432q,\qquad q\ge0,
\]
la palabra \((1^8,2,7)\) desde \(P\) hasta \(U=T^{52}(N)\). Sea \(V=T^{51}(N)\). El plegado certificado por \(\texttt{P5U8Fold.fold\_capture}\) une \(V\) con \(w=(V-21)/64\) por
\[
3V+1=128U=64(3w+1).
\]
Para esta progresión, los dos márgenes exactas son
\[
N-w=965194982576747973746548+1056630704614802332406420q
\]
y
\[
U-N=2969452379245221349881618+3250757221536313200215074q.
\]
Así \(0<w<N<U\) y la fuente realiza una arista física de valoración 1. El libro original hasta \(U\) es \((52,82,34676132573104375947292049)\) y el auxiliar es \((1,1,1)\). La instancia afín se verificó en papel y usa el consumidor de plegado existente. Toda esta progresión pertenece al residuo \(111017\bmod131072\), fuera de la unión previa de 186. Sus otras salidas siguen pendientes.

## Cota inversa para las salidas débiles

Si \(P>N\), cualquier fuente pagada hacia \(V\) requiere al menos \(R+2\) retornos. En efecto, la inversa mínima a \(V\) es el estado \(F\) al final de los \(R\) unos, pues \(V\equiv1\bmod3\) obliga a una valoración inversa par. Cada inversa previa reduce \(x+1\) en un factor de al menos \(2/3\). Con \(R\) inversas previas o menos, \(F+1=(3/2)^R(P+1)\) da una fuente al menos \(P\). Si \(U=T(V)\) con \(a\in\{1,2\}\), su inversa mínima es \(V\) y todas las demás son \(\ge4V+1\). Estas últimas satisfacen \(4V+2=2(3/2)^{R+1}(P+1)\) y tampoco permiten una fuente menor que \(N\) con \(R+1\) inversas previas o menos. El reloj cero queda excluido porque \(U>N\) en este caso. Así la captura de \(U\) requiere al menos \(R+3\) retornos. Estas cotas se auditaron en papel.
