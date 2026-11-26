# Terras 88 · capacidad de cuatro rachas en H=107

Para todo impar positivo \(x\) con \(x+1<2^{107}\), el total \(D_4\) de pasos impares en las cuatro primeras rachas satisface \(D_4\le107(1+\log_2 3)\). Se ejecutó sin cambiar el algoritmo exhaustivo de \(H=66,67\). [Cobertura matemática y podas](TERRAS88_four_runs_66_67.md)

| Resultado en \(D_3>107\) | Valor |
|---|---:|
| Cuádruplas acotadas | 31.925.096 |
| Semillas de la rama \(D_2>107\) | 57 |
| Otras semillas con \(D_3>107\) | 2.743 |
| Mayor \(D_4\) en ambos grupos | 121 |
| Semilla que alcanza ese máximo | 135616355289179437227748033036287 |

El código terminó con salida 0 en 29,330 s con Python optimizado. El caso \(D_3\le107\) se cubre analíticamente por la recurrencia de alturas. Se emplea aritmética entera para imponer \(2^{D_4}\le6^{107}\).

`python3 -O experiments/COLLATZ_ECO_20261125/TERRAS88_four_runs_107_170.py 107`

Aporta el rango \(x_{[5]}\ge2^{107}-1\) para Q1 con \(\Delta=1\). El objetivo del rango 6 se aborda en la unidad de \(H=170\).
