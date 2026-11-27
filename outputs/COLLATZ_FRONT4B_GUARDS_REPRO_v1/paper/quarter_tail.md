# Front4b. Captura de cuarto tras una ruptura débil de valoración dos

Se fija una semilla impar original \(N\) y un segmento físico completo hasta \(J\). Supóngase \(J+1=2^{L+1}Q\), con \(L\ge2\), \(Q\) impar y \(J<4N+3\). Desde \(J\) hay \(L\) retornos de valoración uno. La fuente \(w=(J-3)/4=2^{L-1}Q-1\) es impar positiva, cumple \(w<N\) y realiza \(L-2\) unos. Sus terminales de racha cumplen

\[
U=2\cdot3^{L-2}Q-1,\qquad R=9U+8.
\]

Se cubren los tres siguientes conectores. La última valoración \(\gamma\) es la real desde \(Z\); la del último retorno auxiliar es \(\gamma+2\).

| Palabra del original desde \(R\) | Palabra de la fuente desde \(U\) | Fase de \(U\) | Punto \(Z\) antes de \(\gamma\) | Punto auxiliar \(W\) antes de \(\gamma+2\) |
| --- | --- | --- | --- | --- |
| \((2,4,4,\gamma)\) | \((2,2,1,2,1,\gamma+2)\) | \(U=1697+2048t\) | \(403+486t\) | \(1613+1944t\) |
| \((2,5,2,\gamma)\) | \((2,2,1,1,1,\gamma+2)\) | \(U=481+1024t\) | \(229+486t\) | \(917+1944t\) |
| \((2,6,\gamma)\) | \((2,2,1,1,\gamma+2)\) | \(U=97+512t\) | \(31+162t\) | \(125+648t\) |

El libro del original hasta \(Z\) es respectivamente \((3,10,85)\), \((3,9,149)\) y \((2,8,7)\). El libro y la imparidad de \(Z\) fuerzan la fase indicada. A partir de esa fase se certifican todas las aristas auxiliares con sus divisiones exactas. En los tres casos \(W=4Z+1\), luego \(3W+1=4(3Z+1)\). Si \(3Z+1=2^\gamma Y\) con \(Y\) impar, el retorno auxiliar tiene exactamente valoración \(\gamma+2\) y el mismo terminal \(Y\).

| Tramo | Libros después del retorno final \((h,S,B)\) |
| --- | --- |
| Original \((2,4,4,\gamma)\) y fuente | \((4,10+\gamma,1279)\) y \((6,10+\gamma,1927)\) |
| Original \((2,5,2,\gamma)\) y fuente | \((4,9+\gamma,959)\) y \((6,9+\gamma,1607)\) |
| Original \((2,6,\gamma)\) y fuente | \((3,8+\gamma,277)\) y \((5,8+\gamma,493)\) |

Los segmentos de racha y el historial anterior desde \(N\) se componen con los tramos sin mezclar los dos libros. La conclusión de Lean es `PaidMeeting N`, un encuentro físico pagado. La llegada a 1 requiere consumir la inducción sobre semillas menores. Estas guardas suficientes dejan pendiente que cada semilla fija active una de ellas o una alternativa de pago.

La tercera fila amplía el umbral de entrada del certificado previo `QuarterTwoSix` de \(J<2N+1\) a \(J<4N+3\). La primera fila cubre un conector distinto. La segunda traslada la cola de `QuarterTwoFiveTwo` a las guardas E1 con la misma ventana de entrada. [Prueba Lean](../lean/Front4bQuarterTail.lean) · [Huellas](../provenance/source_receipts.json)
