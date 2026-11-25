# Terras 89 · Quinta racha con \(D_3>92\)

Para todo impar positivo \(x\) con \(x+1<2^{92}\) y \(D_3(x)>92\), se cumple \(D_5(x)\le111\). Aquí \(D_j\) cuenta las entradas impares de las primeras \(j\) rachas impares máximas en el mapa abreviado. La cota implica \(2^{D_5(x)}\le6^{92}\) en esta subrama de la ventana requerida por Terras 89.

La cobertura se hereda de la proyección exacta en \(H=92\) de Terras 88, que certificaba \(D_4\le107\) para esta misma subrama. El verificador fija los insumos por SHA-256 y recoge sus fuentes justo después de las guardas físicas. Conserva 39 fuentes con \(D_2>92\) y 2.155 con \(D_2\le92<D_3\). El paso nuevo recorre entonces cinco rachas de cada una de las 2.194 fuentes distintas, aplicando cada paso abreviado por separado y cotejando las cuatro primeras rachas y sus huecos con el cálculo afín anterior. [Certificado de cobertura heredado](../../COLLATZ_ECO_20261125/TERRAS88_CIERRE.md) · [Verificador](check.py) · [Recibo](RECIBO.json)

El máximo \(D_5=111\) se alcanza, por ejemplo, en \(x=2830979310098318154216243199\), con las parejas físicas racha impar y hueco par
\[
((47,2),(13,1),(43,1),(4,3),(4,2)).
\]

    python3 -B experiments/COLLATZ_Q44_20261125/TERRAS89_D3_HIGH/check.py

Las ejecuciones normal y optimizada produjeron el mismo recibo JSON byte a byte. Sus tiempos de pared fueron 1,92 s y 1,47 s. El recibo identifica ambas ramas, la palabra testigo y las huellas del programa, los insumos y el conjunto de registros físicos.

Con la recurrencia que cubre \(D_4\le92\) y las bandas ya acreditadas \(a_1\ge75\), el complemento de esta ventana queda en \(a_1<75\) y \(D_3\le92<D_4\). La poda para ese complemento se deduce por tamaño, y queda pendiente implementarla y medirla. La segunda ventana \(H=146\) y el caso global de Terras 89 siguen pendientes. [Bandas anteriores](../../COLLATZ_Q39_20261125/TERRAS89_D5_H92_A75/RESULTADO.md) · [Poda para el complemento](PODA_COMPLEMENTO.md) · [Reducción de Terras 89](../../COLLATZ_Q37_20261125/TERRAS89_PAPER/RESULTADO.md)
