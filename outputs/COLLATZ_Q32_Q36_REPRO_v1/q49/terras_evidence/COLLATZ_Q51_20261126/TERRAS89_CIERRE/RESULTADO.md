# Terras 89 · Cierre de Q0 con desplazamiento uno

**Teorema probado en papel con certificados exactos.** Para el mapa abreviado de Collatz, sea $k$ el primer reloj con $3^{d_k}<2^k$ desde $N\ge2$. Si $k$ existe y su prefijo tiene a lo sumo **89 rachas impares máximas**, entonces $T^k(N)<N$. Por el libro afín, todo reloj anterior tiene estado al menos $N$. El resultado amplía en una racha Terras 88 con los mismos insumos externos heredados. [Reducción de los siete relojes y dependencias](../../COLLATZ_Q37_20261125/TERRAS89_PAPER/RESULTADO.md)

## Capacidad certificada en las dos ventanas

Sea $x_0=N$ un impar positivo con $x_0+1<2^H$, $x_i$ el inicio del siguiente bloque después de la racha impar $a_i$ y el hueco par $b_i$, y $D_i=\sum_{j\le i}a_j$. Con $y_i=x_i+1$, la identidad física exacta es
\[
y_i=2^{-b_i}(3/2)^{a_i}y_{i-1}+1-2^{-b_i}.
\]
Con $b_i\ge1$ y $a_i\ge1$ se obtiene por inducción, para $i\le4$,
\[
y_i<(2^{H-i}+i)(3/2)^{D_i}.
\]
Esta desigualdad acota el aditivo y conserva todos sus términos en la identidad original. No depende de una cota superior de los huecos pares.

En $D_3\le H$, $2^{D_4}\le2^{D_3}y_3<(2^{H-3}+3)3^H$. Si $D_4\le H$ se tiene directamente $2^{D_5}\le2^{D_4}y_4<(2^{H-4}+4)3^H$, suficiente en ambas ventanas. Para el complemento, llámese $D=D_4$, $b=b_4$ y $F=238$ si $H=92$, $F=378$ si $H=146$. Si $D_5\ge F$, entonces
\[
y_4=t2^{F-D},\quad
0<t<\frac{(2^{H-3}+3)3^D}{2^{F+b}}+2^{D-F},\quad
2^{b+F-D}t\equiv2^b-1\pmod{3^{D-H}}.
\]
El cofactor $t$ es entero y puede ser par. La cota de $D$ asegura $F-D>0$. El último hueco $b$ se enumera sólo mientras la cota estricta admite un $t$ positivo. El lado derecho de la cota decrece con $b$ hacia $2^{D-F}<1$, de modo que el primer hueco descartado agota todos los restantes. En cada par $(D,b)$ el verificador acredita que el intervalo es más corto que el módulo y resuelve la única clase de $t$.

Para invertir desde cada terna, la divisibilidad $3^{a_i}\mid 2^{b_i}x_i+1$ y $x_{i-1}+1=2^{a_i}(2^{b_i}x_i+1)/3^{a_i}$ reconstruyen el bloque. La paridad impar de $x_i$ y del cofactor reconstruido certifica ambos exponentes exactos. Para los tres primeros bloques se usa
\[
2^{b_i}x_i<(2^{H-i+1}+i-1)(3/2)^{D_i}.
\]
Este corte se deriva de la envolvente para $y_{i-1}$ en la misma órbita. Al invertir se conserva $D_i$, se deja al menos una salida impar por cada bloque anterior y se comprueba al final que $D_0=0$ y que la semilla cumple la ventana original. Ninguna terna tiene una fuente admisible.

| Ventana | $D_3\le H$, prueba inversa | $D_3>H$, reproducción física | Capacidad |
|---|---|---|---|
| $H=92$ | 10 ternas y cero fuentes | 2.194 fuentes, máximo 111 | $D_5\le237$ |
| $H=146$ | 24 ternas y cero fuentes | 5.217 fuentes, máximo 166 | $D_5\le377$ |

El caso $D_3>H$ consume la cobertura exacta de cuatro rachas de Terras 88 y reproduce las cinco primeras rachas y sus huecos de cada fuente retenida. Ambas ventanas quedan cubiertas sin depender de la tabla externa de Freelan Lab. [H92 inversión](../H92_TERMINAL_INVERSE/RECIBO.json) · [H92 complemento](../../COLLATZ_Q44_20261125/TERRAS89_D3_HIGH/RECIBO.json) · [H146 inversión](../H146_TERMINAL_INVERSE/RECIBO.json) · [H146 complemento](../H146_D3_HIGH/RECIBO.json)

## Clausura del último caso

La criba exacta de Q37 reduce un eventual fallo con 89 rachas al reloj $(k,d)=(630118245525664765,397560349370386783)$ y al extremo $T^k(N)=N+1$. El origen y su libro físico siguen satisfaciendo $2^k(N+1)=3^dN+C$.

Como $89>4r$ para $r=10,11$, entre los $r$ segmentos de la partición por mínimos hay uno de longitud al menos cinco. Se elige uno de longitud máxima para recibir las demás rachas, dejando una por raíz. Sus incrementos desde la quinta racha dominan los incrementos que se retiran de cualquier otro segmento. Los de longitud 2 y 3 son menores, los saltos a 4 y 5 son nulos y los restantes son potencias crecientes de $\log_2 3$. La cota resultante fuerza los suelos $x_{[10]}\ge2^{92}-1$ y $x_{[11]}\ge2^{146}-1$.

Con esos suelos, el cálculo racional certifica el precio estricto $x_{[6]}<U=453027402666008300866$. Al retirar los seis menores inicios, los 89 inicios dejan una cadena de al menos cinco consecutivos no retirados porque $89>6\cdot5$. Alguno de sus cinco primeros elementos tiene rango al menos 11. Se llega a ese elemento desde el inicio retirado inmediatamente precedente con a lo sumo cinco bloques completos, valles intermedios al menos tan altos como ese inicio y extremo al menos $2^{146}-1$. Coincide con el dominio Q0 de los dos verificadores de Weaver ya reproducidos. Su exclusión elimina el último fallo posible. [Teorema y consulta de Weaver](https://rstation.ai/problems/collatz/papers/143) · [Recibo de reproducción](../../COLLATZ_TERRAS_87_RUNS_20261125/WEAVER_REPLAY_20261125/RECIBO.json)

## Reproducción y alcance

El verificador integrado recalcula la criba, las inclusiones y el margen racional con huellas fijadas. Con la opción de reproducción vuelve a ejecutar los cuatro certificados de capacidad. Las exclusiones de Weaver se consumen por los recibos de la reproducción anterior.

    python3 -B check.py
    python3 -B check.py --replay

Lean comprueba la identidad física y su aditivo, la extracción cronológica y el ensamblaje de Terras 88 y 89 con sus premisas explícitas. Los certificados de altura y las dependencias heredadas todavía no están descargados integralmente dentro de Lean. El enunciado presupone primer cruce finito y un máximo de 89 rachas; la existencia universal de ese cruce queda abierta. [Recibo integrado](RECIBO.json)
