# Q44 · Precio inverso después de la segunda reserva

## Bloqueo exacto en una fuente, no en un rango

Fijamos **la misma semilla original** de Q43,
\[
k=428769801,\qquad N=123584481135207023644232831.
\]
El primer pivote de la segunda fase es (X=T^{50}(N)=1174213323959791844505582247). Sus dos unos y ruptura 2 llevan a
\(V'=T^{53}(N)=1981484984182148737603170043\). La segunda fuente mitad es
\(w_2=(X-1)/2=587106661979895922252791123>N\). Su ruptura 3 acaba en
\(W'=330247497363691456267195007\), con
\(W'+1=2^7u\), \(u=2580058573153839502087461\) impar. Así, \(D'=7=3\cdot2+1\): trabajamos en \(s'=1,m'=2\).

Los libros de las **dos fuentes distintas** se mantienen separados. La primera fuente de Q43 es
\(w_1=91631949682580921259999711<N\); su tramo hasta su primera ruptura 3 tiene libro
\((5,7,211)\), y los tres unos que agotan su reserva 4 tienen libro \((3,3,19)\). Su libro compuesto es \((8,10,8129)\). La segunda fuente \(w_2\) realiza \((1,3)\) hasta \(W'\), libro \((2,4,5)\), y después seis unos, libro \((6,6,665)\); su libro compuesto es \((8,10,14285)\). Estos libros no se suman ni sustituyen el del original. En particular, \(w_2>N\), de modo que esta mitad no paga una inducción sobre \(N\).

En el original, desde \(X\) hasta los dos unos de salida de la segunda reserva, la palabra física es
\((1,1,2,1,2,1,2,1,1)\). Su libro local es \((9,12,31211)\). El terminal es
\[
J'=T^{59}(N)=5642588099487446991065277197=3^7u-10.
\]
El libro absoluto del original es \((59,88,84284738864848587803900839355)\). Todo retorno de este tramo está sobre \(N\).

**Resultado:** ninguna fuente impar positiva \(w<N\) alcanza \(J'\) mediante entre uno y quince retornos acelerados físicos. Por tanto un conector adaptativo que pague **en este terminal** necesita al menos dieciséis retornos. La cota anterior de Q43 comenzaba en \(2m'+5=9\); aquí se descartan también las profundidades 9 a 15 para esta semilla.

## Certificado de precio y valoración

Sea una cadena inversa física de longitud \(r\) desde \(J'\), con valoraciones \(a_i\ge1\), suma \(A=\sum a_i\) y extremo \(w\). La composición afín exacta da
\[
w=\frac{2^A J'-B}{3^r},\qquad
\frac{B}{2^A}=\sum_{j=1}^r\frac{3^{j-1}}{2^{a_1+\cdots+a_j}}
\le\sum_{j=1}^r\frac{3^{j-1}}{2^j}.
\]
En consecuencia,
\[
w\ge 2^A\frac{J'+1}{3^r}-2^{A-r}.
\tag{*}
\]
Para \(r\le9\), la cota de todos unos es decreciente en \(r\) y en \(r=9\) excede \(N\) en más de \(23192184359766956918964949\).

Para una inversa que sobreviva hasta profundidad 10, \(A-r\ge4\). En efecto, mientras el presupuesto extra sea a lo sumo 3, las valoraciones mínimas obligadas por los residuos módulo 3 son
\[
(1,1,2,1,2,1,2,1,1,2),
\]
que ya consumen cuatro extras en la décima arista. Las únicas desviaciones más baratas antes de esa arista son \(a=3\) en las posiciones 1, 2 o 4, o \(a=4\) en la posición 3. La primera y la última dejan inmediatamente un múltiplo de 3; las otras dos lo dejan tras dos unos, y por ello no tienen continuación inversa. Cualquier otra desviación supera el presupuesto 3. Estas afirmaciones se comprueban sustituyendo \(J'=3^7u-10\) en \((2^a y-1)/3\); no dependen de un barrido de órbitas.

Para \(10\le r\le15\), aplicamos \((*)\) con \(A\ge r+4\). La cota menor ocurre en \(r=15\):
\[
w\ge16\left(\left(\frac23\right)^{15}(J'+1)-1\right)
>N,
\]
con margen mayor que \(82587405650600049190766505\). Las comparaciones son racionales enteras exactas.

## Alcance

Esto es una **prueba exacta** para la fuente de \(k=428769801\), con \(D'=7\), el mismo \(N\) y el terminal fijo \(J'\). El cálculo de la palabra y de los libros es comprobación aritmética directa; no se ha ensayado una familia de semillas ni se afirma un descenso posterior. Queda abierta la existencia de una fuente \(w<N\) de profundidad \(r\ge16\) que alcance \(J'\), o de un conector que pague en un terminal ulterior. En términos de De Bono: cambiar la fuente sólo ayuda cuando se demuestra a la vez la conexión física y su precio frente al origen; la nueva reserva bruta 7 no paga por sí sola.

La banda \(a_1=74\) queda también certificada. El complemento actual de
\(H=92\) es \(a_1\le73,\ D_3\le92<D_4\).
[Recibo de la banda](TERRAS89_D5_H92_A74.json)

## Resultados al integrar los hilos

- **Descenso certificado en Lean.** Para \(k=428769801+2^{31}(44+128t)\),
  el terminal \(T^{60}(N)\) baja estrictamente de \(N\); la valoración
  real final \(b\ge8\) queda libre. El libro original es
  \((60,88+b,253163701604367108480427299121)\).
  [Certificación Front4b](Front4bT60_LEAN.json)
- **Readmisión en papel, \(7\to1\).** En \(k=3805769794057+2^{44}t\),
  el conector con valoración final 7 llega en T60 a \(F\) con
  \(N<F<P=T^{42}(N)\). Desde \(F\) se realizan \((1,1,2)\) y desde
  su mitad \((F-1)/2<N\) se realizan \((1,3)\). El nuevo libro original
  termina en \((63,99,7588087487203423136110204604459)\).
  La nueva pareja realiza reserva 1. El paso reduce el rango del pivote
  con una readmisión física; falta consumir las salidas siguientes.
- **Captura en papel, \(D'=29\).** En
  \(k=365634215903753+288230376151711744t\), nueve pares y la salida
  \((1,7)\) llevan a \(T^{73}(N)>N\). La fuente menor \(w=(A-3)/4\),
  con \(A=9^9 (W'+1)/2^{29}\), llega al mismo terminal con tres unos.
  Los libros son \((73,115,411443494169899340644307646523772515)\)
  y \((3,3,19)\). La regla de tres unos ya está certificada; la instancia
  afín de esta segunda renovación se verificó por separado.

El verificador comprueba las dos progresiones de papel, con sus costes
y realizaciones físicas exactas para todos los parámetros.
[Verificador](verify_second_renewal.py) · [Recibo](SEGUNDA_RENOVACION.json)
