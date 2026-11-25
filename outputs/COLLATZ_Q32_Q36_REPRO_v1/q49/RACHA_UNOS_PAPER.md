# Q49 · Ruptura adaptativa después de una racha de unos

**Papel.** En la fila \(q=12+64s\), el mismo origen \(N\) llega a
\(F=T^{60}(N)\) con libro \((60,94,B_{60})\), donde
\(B_{60}=253163701604367108480427299121\). Se conserva la cota afín
\(F<13N/6\) y \(N\ge3\). El estado \(F\) es impar.

Si \(s\equiv0\pmod4\), la racha inicial de unos desde \(F\) tiene
longitud exacta \(r=\nu_2(F+1)-1\ge2\). Es finita para cada \(F\).
Sea \(Q=T^r(F)\) su extremo y
\(b=\nu_2(3Q+1)\ge2\) la primera ruptura. La identidad exacta es
\[
Q+1=\frac{3^r}{2^r}(F+1),\qquad
Y=T(Q)=\frac{3(3/2)^r(F+1)-2}{2^b}.
\]
En particular, la guarda adaptativa
\[
b\ \ge\ \lceil 2r/3\rceil+3
\]
da \(Y<N\), para cualquier longitud física \(r\). En efecto,
\(27^r\le32^r\le2^{3(r+\lceil2r/3\rceil)}\), luego
\((3/2)^r\le2^{\lceil2r/3\rceil}\). Entonces
\(Y<3(F+1)/8<(13N+6)/16\le N\) para \(N\ge3\).
El exponente real \(b\) sigue en el libro original
\[
\bigl(61+r,\ 94+r+b,\ 3^{r+1} B_{60}+2^{94}(3^{r+1}-2^{r+1})\bigr).
\]

**Realización.** Escribimos \(F+1=2^{r+1}v\), con \(v\) impar.
Entonces \(3Q+1=2(3^{r+1}v-1)\). Dados \(r\ge2,b\ge2\),
se fija
\[
v\equiv (1+2^{b-1})(3^{r+1})^{-1}\pmod {2^b}.
\]
La congruencia correspondiente para \(F+1\) se toma
módulo \(2^{r+b+1}\). Su pendiente en \(s\) tiene valoración
exactamente uno, y ambos interceptos a igualar son pares. Se
puede resolver dividiendo por dos e invirtiendo el coeficiente
impar. Hay una progresión completa \(s\bmod 2^{r+b}\) que realiza
exactamente esos \(r,b\); además queda en \(s\equiv0\pmod4\).
El verificador muestra \(r=5,b=7\), con descenso en T66 en una
clase que quedaba fuera del corte certificado hasta T64.

Este resultado cubre cualquier longitud con una ruptura que cumple
la desigualdad. Para una semilla fija, la racha termina con alguna
valoración \(b\ge2\). La aparición de una valoración que alcance
el umbral, o de otro pago cuando no lo alcanza, sigue abierta.
[Comprobador](check_run.py) · [Recibo](RECIBO_RACHA.json)

## Captura con ruptura más débil para dos a cuatro unos

El hilo B encontró un pliegue distinto. Si \(2\le r\le4\) y
\(b\ge5\), el impar positivo \(\xi=(Q-5)/16\) satisface
\(3\xi+1=(3Q+1)/16=2^{b-4}Y\) y llega al mismo terminal.
Para fijar el precio basta \(r=4\), donde
\(\xi=(81F-15)/256<N\) por la comparación afín del mismo
origen. Esto no exige \(Y<N\). El libro de la fuente es
\((1,b-4,1)\).

El comprobador reproduce la realización en \(s=40+64t\)
para \(r=2\), \(s=100+128t\) para \(r=3\) y
\(s=12+256t\) para \(r=4\), en las tres con \(b\ge5\).
La primera ya pertenece al corte Lean. Las dos últimas son
guardas adicionales en papel. El mismo pliegue puede fallar por
precio para \(r\ge5\); la guarda adaptativa de descenso anterior
opera con el exponente real y conserva su propio dominio.
