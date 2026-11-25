# Terras 89 · Banda completa \(a_1=71\) en \(H=92\)

Para toda fuente impar positiva \(x\) con \(x+1<2^{92}\) y \(\nu_2(x+1)=71\), se cumple \(2^{D_5(x)}\le6^{92}\). La parte \(D_3\le92<D_4\) se cubre con los dos fragmentos disjuntos \(1\le b_1\le4\) y \(b_1\ge5\), según el primer hueco par físico. El segundo fragmento conserva la proyección única de la cola \(b_1\ge21\). Las partes \(D_4\le92\) y \(D_3>92\) se cubren por la recurrencia y el certificado Q44, respectivamente. [Prerregistro](PREREGISTRO.md) · [Primer fragmento](../RESULTADO.md) · [Certificado Q44](../../../COLLATZ_Q44_20261125/TERRAS89_D3_HIGH/RESULTADO.md)

| Primer hueco par | Congruencias | Fuentes retenidas con \(D_3\le92<D_4\) | Máximo \(D_5\) en esas fuentes |
| --- | ---: | ---: | ---: |
| \(1\le b_1\le4\) | 14.297 | 103 | 102 |
| \(b_1\ge5\) | 6.415 | 4 | 100 |
| Unión | 20.712 | 107 | 102 |

La única ejecución nueva tardó 0,040331 s. Las cuatro fuentes retenidas tienen primer hueco \(6,6,7,9\). Se comprobaron las cinco rachas máximas y sus huecos por iteración literal, con el libro \(2^kT^k(x)=3^d x+C\) en cada paso desde la misma fuente. El máximo del segundo fragmento se obtiene para \(x=3223985570870762570438934527\), con \((D_3,D_4,D_5)=(86,99,100)\) y pares físicos \(((71,7),(1,1),(14,6),(13,1),(1,1))\). [Verificador del fragmento](check.py) · [Recibo](RECIBO.json)

El cotejo de la unión verifica los recibos y sus huellas sin repetir proyecciones:

    python3 -B q49/terras_evidence/COLLATZ_Q49_20261125/TERRAS/A71_HIGH_GAPS/check_union.py

El dominio que queda fuera de esta unión en \(H=92\) es \(a_1\le70,\ D_3\le92<D_4\). El segundo fragmento no ejecutó \(a_1=70\). La ventana \(H=146\) o una cota equivalente del rango 11 sigue pendiente. [Recibo de la unión](RECIBO_UNION.json) · [Recibo de la reducción de Terras 89](../../../COLLATZ_Q37_20261125/TERRAS89_PAPER/RECIBO.json)
