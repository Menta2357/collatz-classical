# Front4b · Captura en T103 con la regla de Mahler

**Papel y comprobación afín.** Se aplica el teorema 4(1) de Cassian
Mahler a un pivote físico del proyecto y se prueba su precio frente
al mismo origen. La regla de coalescencia es de Mahler y la realización
en la fila Front4b es la aportación de esta ronda.
[Manuscrito, §5.1](https://rstation.ai/problems/collatz/papers/148)

## Dominio y guarda

Se fija \(k=428769801+2^{31}(108+128s)\),
\(N=110482433359989887+2^{58}k\), \(s\ge0\), con pivote
\(F=T^{60}(N)=F_0+F_1s\) donde

    F0 = 71667327748009080469224948461
    F1 = 84782316550432407028588866402.

En la rama \(s\equiv7\pmod8\), \(N<F<2N+1\) y empieza un
par físico \((1,2)\). Si el pivote realiza \((1,2)^m(d)\) con
\(m\ge1\) y \(d\ge5\), Mahler construye
\(w=(F-5)/2\), de palabra \((1,2)^{m-1}(1,5,d-4)\),
hasta el mismo terminal. \(F\equiv11\pmod{16}\) hace a \(w\)
positivo impar y \(F<2N+1\) da \(w<N\).

Tras \(m\) pares el estado es \(X=9^m(F+5)/2^{3m}-5\). Para
\(m=21,d=5\), la congruencia

    3·9^21(F+5) ≡ (14+2^5)2^63 mod 2^69

implica que \(F+5\) tiene valoración \(64\) y que \(3X+1\)
tiene valoración exactamente \(5\). Se resuelve dividiendo
la congruencia afín por \(2\) e invirtiendo el coeficiente impar
\(F_1/2\), con resultado

    s = 6995726345149836727 + 2^68 t,    t ≥ 0.

## Verificación y alcance

El verificador reconstruye la órbita hasta \(Y=T^{103}(N)\) sobre
la **progresión entera** mediante interceptos y pendientes y coteja
el segundo camino hasta el mismo \(Y\). Los 103 retornos impares
originales son mayores que \(N\). En particular \(Y>F>N\), mientras
\(0<w<N\), así que el caso se paga por captura. Para concluir llegada
a \(1\), se usa la convergencia de la fuente menor como hipótesis
inductiva.

| Libro | Retornos | Divisiones | Aditivo |
| --- | ---: | ---: | ---: |
| Original \(N\to Y\) | 103 | 163 | 143005484110301771259992238415791547811012823797131 |
| Fuente \(w\to Y\) | 43 | 67 | 1576721232714701957479 |

La revisión independiente reconstruyó el prefijo de 60 retornos y
los dos libros. Tras veinte pares, los pivotes \(A,B\) cumplen
\(B=(A-5)/2\). Las colas \((1,2,5)\) y \((1,5,1)\) comparten
terminal porque \(2^8Y=27A+23=2(27B+79)\).

La rama de ruptura débil sigue abierta. Para \(d=2,3,4\), la
rigidez del manuscrito tiene un horizonte referido al pivote y a
la longitud de su palabra, por lo que no excluye fuentes más
profundas ni un terminal ulterior. También quedan las salidas que
empiezan con un \(1\) sin completar el par. Esta transferencia
acredita aparición en una progresión, sin probar aparición de la
guarda para todo \(N\) fijo admitido.
[Comprobador](check_transfers.py) · [Recibo](RECIBO_TRANSFERENCIAS.json)
