# Q46 · Agotamiento y cambios de etiqueta en la segunda renovación

## Dominio físico y libro

Se conserva la fila A2 \(k=521+4096t\), el original
\(N=110482433359989887+2^{58}k\), y la segunda ruptura de Q44 desde
\(X=T^{50}(N)\), con libro original \((53,80,113817632854000981000472755)\)
en \(V_0=T^{53}(N)\). En una fase \(s=1\) escribimos
\[
D=3m+1,\qquad V+5=36\cdot8^m z,\qquad z>0\text{ impar}.
\]
La etiqueta es \(m\), el número de pares físicos \((1,2)\) antes de
los dos unos obligatorios. Definimos
\[
S_m=3m+4,\quad U_m=2^{S_m},\quad B_m=3^{2m+3},\quad K_m=B_m-U_m .
\]
Si la salida adicional tiene valoración 2 y la nueva reserva sigue en
fase 1 con etiqueta \(b\), los dos cofactores satisfacen
\[
U_b z'=B_a z-1 .
\]
El original realiza \((1,2)^a,(1,1,2)\) desde la entrada con etiqueta
\(a\). Su libro local es
\[
(2a+3,\ S_a,\ 135\cdot9^a-116\cdot8^a).
\]
El término aditivo se obtiene al componer los pares de libro
\((2a,3a,5(9^a-8^a))\) con \((1,1,2)\), de libro \((3,4,19)\).
No se reinicia \(N\) ni se añade la identidad de los cofactores al
libro de una fuente.

La identidad entre cofactores también verifica la física cuando los
parámetros son impares positivos y las aristas anteriores son las de
esa fase. Después de los \(a\) pares, \(X+5=36\cdot9^a z\). Los dos
unos llevan a \(J=3^{2a+4}z-10\), por lo que
\[
3J+1=9 U_b z'-20 .
\]
Esto tiene valoración exacta 2 porque \(S_b\ge4\). Para la mitad
aritmética \(w=(X-1)/2\) se cumple \(w\equiv3\bmod4\) porque
\(X=36\cdot9^a z-5\equiv7\bmod8\). Desde \(w\) dos retornos con palabra
\((1,3)\) tendrían numerador \(9w+5=(9X+1)/2\); se tiene exactamente
\[
9X+1=12(B_a z-1)-32
     =12 U_b z'-32,\qquad
W=(9X+1)/32=3\cdot2^{3b+1}z'-1.
\]
El numerador \((9X+1)/2=16W\), con \(W\) impar positivo, certifica
esa palabra física por el compilador de palabras existente.
Así \(W+1\) tiene valoración \(3b+1\). El precio de esta nueva mitad
sigue siendo una condición independiente.

## Regla exacta para agotar y cambiar una etiqueta

Sea \(\rho_a(z)=\nu_2(K_a z-1)\). \(K_a\ge11\) es impar, de modo que
la valoración está definida y es positiva. Si se repite la etiqueta
\(a\),
\[
U_a(K_a z'-1)=B_a(K_a z-1),\qquad
\rho_a(z')=\rho_a(z)-S_a .
\]
Además, \(\rho_a(z)>S_a\) equivale a
\(\nu_2(B_a z-1)=S_a\), puesto que
\(B_a z-1=(K_a z-1)+U_a z\) y \(z\) es impar. Por tanto el número
exacto de repeticiones \(a\to a\) es
\[
\left\lfloor\frac{\rho_a(z)-1}{S_a}\right\rfloor .
\]
La siguiente salida se decide por el resto de esa reserva. Si
\(\rho_a(z)<S_a\), la próxima etiqueta, cuando existe en este canal,
es menor y satisface \(S_b=\rho_a(z)\). Si \(\rho_a(z)=S_a\),
la valoración de \(B_a z-1\) supera \(S_a\), por lo que la etiqueta
siguiente debe ser mayor o salir del canal.

De manera simétrica, para una transición genuina \(a\ne b\),
\[
K_a U_b(K_b z'-1)
=K_b B_a(K_a z-1)+U_a B_b-U_b B_a.
\]
La valoración del último término es \(\min(S_a,S_b)\). Al ser
\(K_bB_a\) impar y \(K_bz'-1\) par, la cancelación exige exactamente
\[
\rho_a(z)=\min(S_a,S_b).
\]
La identidad describe dónde cambia la etiqueta. La reserva posterior
puede depender de la cancelación a un orden mayor.

## Todos los calendarios finitos son físicamente realizables

Dada una sucesión finita \(a_0,\ldots,a_\ell\) de enteros no negativos,
fijamos \(z_\ell\equiv1\bmod2\) y levantamos desde el final. Si
\(z_{i+1}\equiv r\pmod{2^L}\), se toma
\[
z_i\equiv B_{a_i}^{-1}(1+2^{S_{a_{i+1}}}r)
   \pmod{2^{L+S_{a_{i+1}}}}.
\]
Cada inverso existe. El cociente real es impar y tiene el residuo
requerido en el siguiente estado. Para conectar el primer cofactor al
mismo \(N\), se usa \(256u_0=B+Gt\) de la fila de Q44,
\(B=3384512724039106948104,\ G=3^{47}\).
Con el primer residuo \(z_0\equiv r_0\bmod2^{L_0}\), basta resolver
\[
81(B+Gt)-256\equiv2^{S_{a_0}+8} r_0
  \pmod{2^{S_{a_0}+8+L_0}} .
\]
La pendiente es impar. Tomar parámetros positivos en esa progresión
hace positivos todos los estados. Cada conector completo expande
respecto a su entrada \(V_i\), y los retornos intermedios quedan
por encima de \(V_i>N\). Se comprueba una progresión con etiquetas
\(1,1,0,2,1\) y el mismo libro físico desde \(N\).
[Verificador](check_label_switches.py) · [Recibo](CAMBIOS_ETIQUETA.json)

El resultado impide imponer la disminución de un rango basado sólo
en la etiqueta en todos estos conectores. Una fuente menor que \(N\)
todavía puede pagar alguno de ellos. Los calendarios finitos son
realizados al variar \(N\) dentro de su fila.

La misma reconstrucción da la progresión de etiquetas \(0,0,0\),
con \(k=848200201+2^{33}t\) y \(t\ge0\). En ella se verifica
\(z_0<N<z_2\), pese al consumo exacto de la reserva centrada.
El cofactor \(z_i\) requiere una prueba de encuentro físico antes de
usarse como fuente.

En el cambio de \(1\) a \(2\), la reserva de entrada es \(7\) y
la de salida puede ser cualquier \(H\ge1\). Basta comenzar el mismo
levantamiento hacia atrás con
\(z_1\equiv (1+2^H)K_2^{-1}\pmod{2^{H+1}}\). Como \(K_2=1163\) es
impar, el inverso existe y el cofactor final es impar. El verificador
reconstruye la progresión entera para \(H=32\). Esta recarga arbitraria
varía la semilla con \(H\).

Si una misma semilla mantuviera indefinidamente el canal, su secuencia
de etiquetas tendría que ser aperiódica a partir de cualquier índice.
Una palabra periódica de etiquetas compone un segmento
\(2^S Y=M V+C\) con \(M>2^S\) impar y \(C>0\); el mismo argumento
de agotamiento alrededor de su punto fijo hace decrecer en \(S\)
la valoración de \((M-2^S)V+C\) en cada repetición. Sigue abierta la
activación de una captura, descenso o readmisión pagada cuando las
etiquetas cambian sin periodicidad.
