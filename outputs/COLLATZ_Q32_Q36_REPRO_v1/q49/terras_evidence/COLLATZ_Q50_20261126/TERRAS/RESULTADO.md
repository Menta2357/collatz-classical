# Terras 89 · Banda completa \(a_1=70\) en altura 92

Para todo impar positivo \(x\) con \(x+1<2^{92}\) y primera racha impar \(a_1=70\), se cumple \(2^{D_5(x)}\le6^{92}\). Se usa Q44 para \(D_3>92\), el corolario de Q49 para \(D_4\le94\) y los dos fragmentos Q50 para el residual \(D_3\le92,\ D_4\ge95\). [Prerregistro](PREREGISTRO.md) · [Corolario Q49](../../COLLATZ_Q49_20261125/TERRAS_A70_ORDINAL_ENVELOPE/COTEJO_COROLARIO_94.md) · [Recibo de la unión](RECIBO_UNION.json)

El cuarto ascenso del residual debe medir al menos \(95-D_3\). La cota de altura del cuarto valle y su congruencia usan esa longitud mínima. Las proyecciones de saturación del cofactor se conservan y se comprueban con el hueco físico y el corte ordinal. Los relojes siguen contando rachas máximas del mapa abreviado desde el mismo \(x\).

| Primer hueco par | Congruencias | Fuentes del residual | Máximo \(D_5\) en el residual | Tiempo |
| --- | ---: | ---: | ---: | ---: |
| \(1\le b_1\le3\) | 14.817 | 28 | 101 | 0,031456 s |
| \(b_1\ge4\) | 11.919 | 9 | 100 | 0,028078 s |
| Unión | 26.736 | 37 | 101 | |

Se verificaron las cinco rachas físicas y el libro \(2^kT^k(x)=3^d x+C\) de cada fuente por iteración literal. La nueva criba conserva las mismas 26.736 congruencias previstas del árbol. Su filtro ordinal limita las fuentes en que se calcula la quinta racha. Una fuente que alcanza el máximo residual es \(x=774117467479268743889027071\), con \((D_3,D_4,D_5)=(83,96,101)\) y pares físicos \(((70,1),(5,2),(8,2),(13,1),(5,1))\). [Recibo del tramo bajo](RECIBO_LOW.json) · [Recibo del tramo alto](RECIBO_HIGH.json) · [Verificador](check.py)

Para cotejar la unión sin repetir proyecciones:

    python3 -B experiments/COLLATZ_Q50_20261126/TERRAS/check_union.py

En \(H=92\) restan \(a_1\le2,\ D_3\le92<D_4\) y \(3\le a_1\le69,\ D_3\le92,\ D_4\ge95\). \(H=146\), o un suelo equivalente del rango 11, sigue como obligación separada. Terras 89 continúa abierto en Q0 con \(T^\tau(N)=N+1\). [Reducción global](../../COLLATZ_Q37_20261125/TERRAS89_PAPER/RESULTADO.md)
