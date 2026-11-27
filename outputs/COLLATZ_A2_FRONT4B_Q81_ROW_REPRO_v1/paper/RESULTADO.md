# Front4b. Cierre de las salidas fuertes de la fila \(u\equiv2\pmod8\)

## Dominio y resultado

Se conserva la fila de Front4b \(s=29+32u\) y se fija \(u=2+8t\),
con \(t\ge0\). Antes de seguir se fijan la semilla \(N\), el pivote \(V\) y
el libro absoluto.

\[
\begin{aligned}
N&=1156359581173680383779426258047+2^{100}u,\\
V&=1392102202856011511751362094175+4\cdot3^{62}u,\\
V&=T^{62}(N),\qquad 2^{98}V=3^{62}N+B_{62},\\
B_{62}&=2417122598839266567112547605177.
\end{aligned}
\]

El prefijo físico es **Front4bS29Landing.history62** y cumple
\(N<V<5N/4\). El verificador independiente reconstruye además todas
sus 62 aristas como identidades afines. [Prefijo Lean](../lean/Front4bS29Landing.lean)

En esta fila, todo \(u\equiv26\pmod{32}\), \(u\equiv106\pmod{128}\) y
\(u\equiv42\pmod{256}\) tiene descenso físico bajo \(N\) en \(T^{66}\),
\(T^{67}\) y \(T^{68}\), respectivamente. Cada una de esas tres
subfilas queda íntegramente cubierta. Cuando \(c=3,5,7\), el certificado
también cubre la primera valoración \(e\ge3\) que sigue a los doses
forzados y a un retorno de valoración uno. Para \(c=7\), la transición
de rango menor ya se produce antes de observar \(e\).

## Prueba por la reserva de la ruptura

La entrada \(u\equiv2\pmod8\) da exactamente \((1,1,2)\) desde \(V\). Con
\(G=T^2(V)=(9V+5)/4\), se escribe \(G-1=2^c A\), con \(A>0\) impar
y \(c\ge3\). El tercer retorno original llega a
\(Y=(27V+19)/16=1+3\cdot2^{c-2}A\).

La valoración exacta dos se aplica siempre que \(\nu_2(x-1)\ge3\).
En ese caso \(T(x)-1=3(x-1)/4\), así que cada paso consume dos unidades
de la reserva. Si la reserva termina en dos, el siguiente numerador
es divisible por ocho. Si termina en uno, el siguiente retorno tiene
valoración uno. Así se fijan los prefijos siguientes y se deja libre
la valoración donde basta una cota inferior.

| Residuo de \(u\) | Reserva \(c\) | Palabra desde \(V\) | Libro local \((h,S,B)\) | Resultado sobre \(N\) |
|---|---:|---|---|---|
| \(26\bmod32\) | 4 | \((1,1,2,e)\), \(e\ge3\) | \(4,4+e,73\) | \(T^{66}(N)<N\) |
| \(106\bmod128\) | 6 | \((1,1,2,2,e)\), \(e\ge3\) | \(5,6+e,283\) | \(T^{67}(N)<N\) |
| \(298\bmod512\) | 8 | \((1,1,2,2,2,e)\), \(e\ge3\) | \(6,8+e,1105\) | \(T^{68}(N)<N\) |
| \(42\bmod512\) | \(\ge9\) | \((1,1,2,2,2,2)\) | \(6,10,1105\) | \(T^{68}(N)<N\) |
| \(66\bmod128\) | 3 | \((1,1,2,1,3)\) | \(5,8,251\) | \(w<N\), \(T(w)=T^{67}(N)>N\) |
| \(2\bmod128\) | 3 | \((1,1,2,1,e)\), \(e\ge4\) | \(5,5+e,251\) | \(T^{67}(N)<N\) |
| \(74\bmod256\) | 5 | \((1,1,2,2,1,e)\), \(e\ge3\) | \(6,7+e,977\) | \(T^{68}(N)<N\) |
| \(426\bmod1024\) | 7 | \((1,1,2,2,2,1,e)\), \(e\ge3\) | \(7,9+e,3827\) | \(T^{69}(N)<N\) |

Para cada descenso se verifica el margen entero
\(2^{S_{\min}}N-3^hV-B>0\) con \(u=2+8t\). Su intercepto es positivo
y su pendiente es positiva en los siete casos. El exponente real es
al menos \(S_{\min}\), lo que preserva la desigualdad. El libro absoluto
del terminal es exactamente
\((62+h,\ 98+S,\ 3^h B_{62}+2^{98}B)\), usando la valoración \(e\) real.

Para la captura, con \(Z=T^{67}(N)\), se tiene
\(256Z=243V+251\) y \(Z\equiv2\pmod3\). Así
\[
w=(2Z-1)/3=(81V+41)/128
\]
es impar positivo, cumple \(w<N\) por comparación de interceptos y
pendientes, y \(3w+1=2Z\) da un retorno físico de valoración uno. El
original y la fuente tienen libros independientes
\((67,106,666905866682263170752267194195355)\) y \((1,1,1)\).
La inducción sobre menores convierte el encuentro en llegada a
1. El verificador comprueba por separado que el encuentro satisface \(Z>N\).

## Complemento exacto y primera transición de rango

En \(u=2+8t\), los pagos de la tabla dejan estas seis clases.
Otras guardas pueden cubrir subclases de estas progresiones. Las dos
clases con \(c=7\) disponen de una transición de rango menor.

| \(c\) | \(e\) | Clase de \(u\) |
|---:|---:|---|
| 3 | 1 | \(18\bmod32\) |
| 3 | 2 | \(34\bmod64\) |
| 5 | 1 | \(10\bmod128\) |
| 5 | 2 | \(202\bmod256\) |
| 7 | 1 | \(170\bmod512\) |
| 7 | 2 | \(938\bmod1024\) |

Los pagos cubren 65 de los 128 residuos de la fila módulo 1024.
Para \(c=7\), antes de observar \(e\), el prefijo físico \((1,1,2,2,2)\)
ya termina en \(X=(243V+283)/256\). Los cuatro estados anteriores
después de \(V\) son mayores que \(V\), y los márgenes afines verifican
\(N<X<V\). Es el primer cruce bajo \(V\), con libro local \((5,8,283)\)
y libro absoluto \((67,106,677047071484089005964240819838363)\).
El consumidor de A2 desde ese cruce da pago o una readmisión con
\(N\le x\le X<V\), junto con su libro absoluto y la guarda de admisión.
La obligación de producir una segunda transición sigue abierta.
Quedan **cuatro clases** sin pago o transición de rango menor en este
certificado, las dos de \(c=3\) y las dos de \(c=5\).
[Consumidor de primer cruce](../lean/A2FirstCrossingFusion.lean)

## Compresión exacta del complemento débil

En \(c=3,5\), se pone \(p=(c+1)/2\). Tras los doses forzados y el
primer uno, el original está en \(H=3^p A+2\). Se escribe
\(3^{p-1}A+1=2^m Q\), con \(Q\) impar. Si el retorno desde \(H\)
tiene valoración uno, \(m\ge2\). Cada uno multiplica \(x+1\) por
\(3/2\) y reduce la reserva \(\nu_2(x+1)\) en una unidad. La racha
máxima consta exactamente de \(m-1\) unos y termina en \(R=2\cdot3^mQ-1\).
La ruptura tiene valoración exacta \(e_\star=1+\nu_2(3^{m+1}Q-1)\).
El segmento físico completo desde \(H\) tiene libro local
\[
(m,\ m-1+e_\star,\ 3^m-2^m).
\]

En cada clase fija de \(c\), \(A\) es afín en el parámetro restante con
pendiente \(2\cdot3^{64}\). Para cualquier \(m\ge2\), resolver
\(3^{p-1}A+1\equiv2^m Q_0\pmod{2^{m+2}}\) fija una clase a partir
del inverso de la pendiente impar tras dividir por dos. Se puede
escoger cualquier \(Q_0\in\{1,3\}\), incluido aquel con
\(3^{m+1}Q_0\equiv3\pmod4\). En ese caso \(e_\star=2\) y
\(3^m>2^{m+1}\) fuerza que el extremo de la ruptura supere \(H\).
Para \(c=3\), todo el prefijo hasta \(H\) queda sobre \(N\).
Así existen semillas de la fila con tantos retornos sobre \(N\)
como se prescriba. Esto excluye un horizonte uniforme de descenso de
la fila y muestra que la ruptura débil comprimida puede expandir.
Las órbitas individuales y sus libros permanecen separados.

## Control De Bono y verificación

El foco fue la fila física completa antes de subdividir sus salidas.
El contraste inicial de fuentes de profundidad hasta diez en el
prefijo afín común no encontró una fuente uniforme. Se cambió a
la reserva de \(Y-1\), que convierte la rama de doses en una regla
exacta y determina qué terminal merece una búsqueda de fuente.
En las ramas débiles restantes, la reserva de \(H+1\) comprime la
racha arbitraria de unos y conserva el coste de la ruptura real.

Los comandos **python3 -B verificar.py** y **python3 -BO verificar.py**
devuelven **PASS**. Comprueban las identidades afines, la partición de
un período completo de residuos, los márgenes y seis casos dirigidos
de ruptura débil exacta. Las pruebas de este documento son aritméticas.
[Verificador](verificar.py)
