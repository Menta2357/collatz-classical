# Terras 88

Para el mapa abreviado de Collatz y cualquier entero \(N\ge2\), sea \(\tau\) el primer paso con \(3^{d_\tau}<2^\tau\), donde \(d_k\) cuenta entradas impares. Si \(\tau\) existe y su prefijo tiene hasta 88 rachas impares máximas, entonces \(T^\tau(N)<N\) y ese es el primer descenso real. El resultado está demostrado en papel con certificados computacionales exactos. [Demostración y alcance](evidence/experiments/COLLATZ_ECO_20261125/TERRAS88_CIERRE.md)

## Comprobación rápida

Requiere Python 3.10 o posterior y su biblioteca estándar. El directorio se puede copiar y el comando funciona desde cualquier directorio de trabajo. Utiliza Python sin `-O`, para conservar las aserciones de los verificadores heredados.

```sh
python3 -B /ruta/al/paquete/verify.py
```

El lanzador comprueba las huellas de `SHA256SUMS` y vuelve a calcular la criba de los cuatro pares, las desigualdades de rangos, los precios de Q0 y Q1, las ocho ventanas heredadas de dos y tres rachas y las ventanas de cuatro rachas de alturas 66, 67 y 92. El caso \(D_3\le H\) usa la desigualdad analítica \(D_4<H+(\log_2 3)D_3\), que figura en la demostración. La enumeración comprueba el complemento \(D_3>H\).

Para las alturas 107, 146 y 170, la ejecución rápida verifica huellas y consume los recibos. Para las exclusiones de Weaver verifica cuatro resultados retenidos y los 1.759 registros de particiones, sus identidades, sus estadísticas agregadas, los dominios exactos de Q0 y Q1 y la ausencia de testigos en los registros. La ejecución rápida no repite esas búsquedas.

## Reproducciones opcionales

Desde el directorio del paquete, esta orden repite todas las búsquedas de cuatro rachas, usando el algoritmo de cada recibo. Los tiempos archivados suman cerca de tres minutos en un proceso. Los tiempos dependen de la máquina.

```sh
python3 -B verify.py --full-capacities
```

Para repetir los cuatro recorridos de Weaver, indica la ruta al suplemento publicado. El lanzador comprueba la huella del ZIP, los 19 archivos fijados y después ejecuta ambas implementaciones en un directorio temporal con registros nuevos. Compara las estadísticas de cada partición con los registros retenidos. El comando no descarga el suplemento. [Suplemento publicado](https://rstation.ai/api/v1/posts/Wa9D5yUT8FhkA_r3/attachment?revision=7)

```sh
python3 -B verify.py --weaver-archive /ruta/al/suplemento.zip --weaver-workers 5 --weaver-seconds 1800
```

La ejecución archivada tardó unos doce minutos en total, con cinco procesos para Q0 y dos para Q1. Por defecto se usa un proceso y un límite de 3.600 segundos por búsqueda. `--full-capacities` se puede combinar con `--weaver-archive`. El SHA-256 exigido para el suplemento es `588ae3fdaee85aa1f99eb507d2d3203cee202c25a7b138a6ba204fe42ea45331`.

## Procedencia y límites

- El recibo portátil conserva diez huellas de entrada, la huella del recibo original y tres huellas auxiliares sin los antiguos nombres de ruta absolutos. Los tres archivos auxiliares pertenecen a un cotejo redundante de Front4b en \(H=92\), altura que el lanzador vuelve a verificar. [Recibo de Terras 88](evidence/experiments/COLLATZ_ECO_20261125/TERRAS88_CIERRE_RECIBO.json)
- `WEAVER_SHARDS.zip` conserva sin modificaciones los cuatro JSON de resultados y los 1.759 JSON de particiones del archivo original de reproducción. El [recibo de la reproducción](evidence/experiments/COLLATZ_TERRAS_87_RUNS_20261125/WEAVER_REPLAY_20261125/RECIBO.json) fija los cuatro resultados y la huella del archivo original completo. El nuevo manifiesto fija la selección portátil.
- La prueba consume la coincidencia de relojes hasta \(2{,}8\cdot10^{19}\), la cota de Rhin, la exclusión de ciclos de pocos mínimos de Hercher con su corrección y las dos exclusiones de Weaver. Los informes preliminares incluidos registran etapas anteriores a la incorporación de las últimas capacidades. El punto de entrada matemático es `TERRAS88_CIERRE.md`. [Rozier–Terracol, corolario 5.4 y proposición 6.3](https://arxiv.org/pdf/2502.00948v5) · [Hercher y corrección](https://cs.uwaterloo.ca/journals/JIS/VOL26/Hercher/hercher5.html) · [Weaver, teorema 1 y §§5–6](https://rstation.ai/problems/collatz/papers/143)

Quedan pendientes la formalización integral en Lean y la revisión externa de la extensión a 88. La existencia del primer cruce para toda semilla y los prefijos con más de 88 rachas quedan fuera del teorema.
