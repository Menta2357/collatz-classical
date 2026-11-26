# Front4b · Captura tras la ruptura 2 y la continuación \((3,e)\)

**Papel.** Se conserva el [origen de Front4b y el pivote físico F](../../q47/TRANSFERENCIA_MAHLER_FRONT4B.md). En la fila \(k=428769801+2^{31}(108+128s)\), \(F=T^{60}(N)\) tiene libro \((60,95,253163701604367108480427299121)\). Supóngase \(s\equiv7\pmod8\) y que, después de agotar \(m\ge1\) pares \((1,2)\), la primera ruptura desde el estado X tiene valoración 2. Se toma la misma fuente impar positiva \(w=(F-5)/2<N\).

## Dos historias, dos divisiones de diferencia

Desde \(w\) se realizan \(m-1\) pares \((1,2)\). El terminal intermedio W cumple \(W+5=4(X+5)/9\) y \(\nu_2(W+5)=3\), porque la ruptura 2 original fuerza \(X\equiv1\pmod8\). El siguiente 1 es físico, y \(3T(W)+1=2(X-5)\) tiene valoración 3. Tras \((1,3)\), la fuente alcanza \(z=(X-5)/4\), mientras que el original en una arista llega a \(Y=(3X+1)/4=3z+4\).

Si \(z\equiv3\pmod{64}\), las dos aristas siguientes se organizan así:

| Historia | Palabra desde su punto de control | Terminal intermedio |
|---|---|---|
| Original desde Y | \((3)\) | \(A=(9z+13)/8\) |
| Auxiliar desde z | \((1,4)\) | \(B=(9z+5)/32\) |

Se cumple \(A=4B+1\). Los residuos son exactos: \(9z+13\equiv8\pmod{16}\) y \(9z+5\equiv32\pmod{64}\), y el primer exponente auxiliar 1 viene de \(z\equiv3\pmod4\). Como \(3A+1=4(3B+1)\), la valoración real \(e=\nu_2(3A+1)\ge3\) queda libre y la auxiliar es \(e-2\). Los dos retornos coinciden en E. La llegada a 1 se deduce bajo la hipótesis de inducción sobre w.

El libro de la continuación original desde F y el libro completo desde w son

| Palabra | Retornos | Divisiones | Aditivo |
|---|---:|---:|---:|
| \((1,2)^m,2,3,e\) | \(2m+3\) | \(3m+5+e\) | \(135\cdot9^m-82\cdot8^m\) |
| \((1,2)^{m-1},1,3,1,4,e-2\) | \(2m+3\) | \(3m+4+e\) | \(135\cdot9^m-41\cdot8^m\) |

El original compone el aditivo de los pares \(5(9^m-8^m)\) con el aditivo 53 de \((2,3,e)\). Para formar su libro absoluto, se añaden el reloj histórico y el aditivo preexistente en F. El libro auxiliar corresponde a su palabra propia. La igualdad física y \(F=2w+5\) verifican las dos identidades afines del encuentro.

## Realización no vacía para cada m

Fijados \(m\ge1\) y \(e\ge3\), se resuelven

\[
\begin{aligned}
27z+47 &\equiv 2^{e+3}\pmod{2^{e+4}},\\
9^m q &\equiv 2z+5\pmod{2^{e+5}},\\
F+5 &\equiv 2^{3m+1}q\pmod{2^{3m+e+6}}.
\end{aligned}
\]

El primer residuo fuerza \(z\equiv3\pmod{64}\) y el segundo fuerza q impar. En el tercero se divide por 2 y se invierte la pendiente impar \(F_1/2=3^{60}\) para seleccionar s módulo \(2^{3m+e+5}\). La solución conserva \(s\equiv7\pmod8\). La divisibilidad exacta de \(F+5\) fija el agotamiento en m pares y las fórmulas anteriores certifican la ruptura 2 y la valoración final exacta e. La realización existe para cada m y e especificados. No certifica aparición obligatoria de esta guarda para cada semilla fija.

Para \(e=3\), \(m\ge20\) y \(F>N\), se tiene \(E>(27/256)(9/8)^mF>N\). Los retornos desde F que pasan por X, Y y A siguen todos por encima de N. La captura entonces aporta pago en un terminal que todavía no ha descendido respecto del origen en este tramo.

El [comprobador dirigido](check_d2.py) verifica afínmente \(m=20,e=3\) en toda la progresión \(s=139581699374937238967+2^{68}t\). El libro original es \((103,163,144375641895299492745808192946463063141940260556171)\) y el auxiliar \((43,67,1594015055283804662119)\). Son libros distintos de los de Q47, aunque coinciden sus dos relojes numéricos.

## Alcance del empalme más corto

De Bono comparó cambiar de fuente con conservar w y mover el terminal. Para esta segunda opción, una coincidencia afín uniforme desde Y y z exige que la palabra auxiliar tenga un retorno más y la misma suma de valoraciones, por \(Y=3z+4\). Con un único retorno original y dos auxiliares, el término constante exigiría \(3+2^b=13\), imposible. Con dos retornos originales, siendo a la primera valoración, una palabra auxiliar de tres retornos exige \(2^b(3+2^c)=30+2^a\). Si \(a=1\), el factor impar excluye la igualdad. Si \(a\ge2\), se obtiene \(b=1\) y \(2^c=12+2^{a-1}\), cuya única solución es \(a=3,c=4\). La última valoración auxiliar debe ser \(e-2\). Así, el empalme demostrado es la única opción de ese horizonte afín uniforme. Las demás salidas tras la ruptura 2 requieren un terminal posterior, otra fuente o un cruce. No se aplicó un barrido de órbitas ni se compiló Lean.
