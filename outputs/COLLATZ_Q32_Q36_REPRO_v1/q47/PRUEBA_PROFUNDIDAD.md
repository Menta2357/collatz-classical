# Profundidad necesaria tras renovaciones de etiqueta variable

## Foco de De Bono y comprobación fijada

Objetivo. Decidir si es viable un catálogo de fuentes de profundidad
uniforme en todos los conectores tardíos de la fila A2 de Q46. Se fijan
el mismo N, el tramo físico desde T53 y el libro independiente de una
eventual fuente. Dos provocaciones se mantienen fuera de la prueba.

- **PO 1, invertir la pregunta.** Identificar qué profundidad no puede
  pagar en el terminal original, aun antes de resolver sus congruencias
  inversas.
- **PO 2, cambiar el terminal.** Una vez que la cota excluya un
  catálogo uniforme, buscar encuentros cerca de la entrada del bloque
  o generar la profundidad a partir de la altura real.

Comprobación preseleccionada. Cotejar únicamente los cinco checkpoints
T53, T58, T63, T66 y T73 del cilindro publicado de Q46, con enteros
afines. Comparar el máximo número de retornos que excluye la desigualdad
de altura en esos puntos. Un fallo detiene la promoción y no se cambia
el cilindro. Se conserva la cronología y el aditivo sin barrer órbitas.

## Lema en papel

Sea T el mapa acelerado entre impares. Partimos de un impar positivo N
del dominio físico de Q46. Supongamos que después de T53 se han
completado j conectores con etiquetas m_0,…,m_(j−1), y sea
M_j=∑m_i. Escribimos V_j para el checkpoint de la trayectoria original.
Para j=0, usamos su libro Q46:

    2^80 V_0 = 3^53 N + 113817632854000981000472755.

El conector i tiene la palabra (1,2)^m_i,(1,1,2) y el libro

    2^(3m_i+4) V_(i+1) = 3^(2m_i+3) V_i + C_i,
    C_i = 135·9^m_i − 116·8^m_i > 0.

Cada bloque completo eleva el estado y todos sus retornos intermedios
son mayores que su propia entrada. Para verlo, el primer retorno de
un par (1,2) eleva x y el par termina en (9x+5)/8>x.
Los tres puntos de (1,1,2) son (3x+1)/2, (9x+5)/4 y (27x+19)/16,
todos mayores que x. Por tanto el resultado también vale en un punto
Y≥V_j del siguiente conector físico, si ese conector existe.

Si un impar positivo w<N llega físicamente a Y en d retornos, el
libro de la fuente es independiente. Para cada uno de sus retornos,
con valoración exacta a≥1, se cumple

    T(x)+1 = (3x+1)/2^a + 1 ≤ (3/2)(x+1).

Como w y N son impares, w+1≤N−1. En consecuencia

    (3/2)^d(N−1) ≥ Y+1
                 > [3^53/2^80] (27/16)^j (9/8)^M_j N.

Pongamos q=3/2 y r=9/8. Se tienen 27/16=q r,
3^53/2^80>q^6 y r^7>q^2, por las comparaciones enteras
3^47>2^74 y 3^12>2^19. Resulta

    q^(d−6−j) > r^(j+M_j),   luego   7d > 42 + 9j + 2M_j.

Así, cualquier fuente pagada exige al menos
⌊(42+9j+2M_j)/7⌋+1 retornos. La desigualdad anterior con
3^53/2^80, o el libro exacto del terminal Y, pueden exigir más.

## Alcance

La cota usa el lema elemental de altura ya empleado en F3. La aplicación
nueva lo combina con la composición Q46 y vale para cualquier lista de
etiquetas de conectores realizados, aunque cambien sin periodicidad.
Para cada profundidad fija existen prefijos físicos arbitrariamente
largos en la fila Q46, al variar N, con terminales que excluyen toda
fuente de esa profundidad o menor. La cota vale asimismo, de manera
condicional, a lo largo de las renovaciones que realice un N fijo.

Esto deja abierta la existencia de fuentes más profundas, capturas en
terminales anteriores y la permanencia indefinida de una semilla fija.
La obligación siguiente es producir profundidad adaptativa y un
encuentro físico con w<N, o probar una reentrada de rango menor.

## Segundo corte, T62 para todo cambio físico 1→2

En el cambio \(1\to2\) de Q46, los dos pares reales posteriores a
\(V_1=T^{58}(N)=2304z_1-5\) llevan a \(X=T^{62}(N)=2916z_1-5\).
Su libro original, para todo \(H\) realizable, es
\((62,93,2281529478911289758877502905017)\).

Toda inversa física de al menos cinco retornos desde \(X\) gasta
un exceso de al menos tres sobre una división por arista. En el
camino inverso mínimo, las valoraciones \(2,1,2,1\) llevan a
\(V_1\equiv1\pmod3\), donde otra arista cuesta al menos \(2\).
Si la primera desviación es anterior, la paridad de la valoración
añade por lo menos dos unidades al mínimo, además de la que exige
la primera valoración \(2\). Si una arista no existe, la rama no
aporta un encuentro.

El lema Lean F3 existente **height_monotone** da para una fuente impar
\(w<N\) de \(5\le d\le14\) con ese exceso
\(2^{17}(X+1)\le3^{14}(w+8)\le3^{14}(N+6)\).
Al multiplicar la desigualdad contraria por \(2^{93}\), el margen
tiene pendiente \(2638414422956195978798485212364800\) y término
constante \(16133322149977989796133198902722560\). La cota de
altura sin exceso ya excluye \(d\le4\). Quedan excluidas las
profundidades **0 a 14** para cada \(H\) realizable. Revisión
independiente conforme. Es una aplicación nueva en papel del lema
F3 ya certificado.
[Recibo de cotejo](RECIBO_TRANSFERENCIAS.json)
