# Collatz · Balance Q46

## Certificados Lean

- **A2, clase completa \(k\equiv473\pmod{16384}\).** Para \(k=473+32768t\), el terminal \(T^{46}(N)\) cae por debajo del mismo \(N\) con la valoración real \(a\ge5\). Para \(k=16857+32768t\), \(a=4\) y la fuente impar positiva \(w=(T^{40}(N)-1)/2<N\) alcanza \(T^{46}(N)>N\). El libro de la fuente es \((6,8,697)\). Se promueve a Lean una clase previamente demostrada en papel. [Recibo](A2_473_LEAN/RECIBO.json)
- **Dos guardas en T66.** Para \(k=3805769794057+2^{44}t\), \(t\equiv2\pmod8\) produce descenso y \(t\equiv6\pmod8\) produce encuentro con \(w=(T^{63}(N)-1)/2<N\), con su libro \((3,4,23)\). El resto de la fila requiere sus propias guardas. [Recibo](A2_T66_LEAN/RECIBO.json)
- **Reserva 2-ádica centrada.** Una transición con etiqueta fija \(m\) consume exactamente \(3m+4\) unidades. Si la etiqueta cambia de \(a\) a \(b\), la reserva de entrada vale exactamente \(\min(3a+4,3b+4)\), bajo la relación exacta entre los cofactores impares. [Recibo de etiqueta fija](CENTERED_RECHARGE_LEAN/RECIBO.json) · [Recibo de cambio](RECIBO_CAMBIO.json)

En la captura, la hipótesis inductiva de convergencia para impares positivos menores que \(N\) permite concluir la convergencia de \(N\). Los certificados conservan el origen, los pasos físicos y el aditivo de cada trayectoria por separado.

## De Bono y comprobaciones exactas

Examinamos la reserva alrededor del punto fijo afín y cambiamos el terminal cuando el precio de la fuente era demasiado alto. En la fila de Q44, todo calendario **finito** de etiquetas tiene una realización física al variar la semilla. El cambio de etiqueta de 1 a 2 admite reservas de salida arbitrarias al variar la semilla; también hay pérdida de la condición \(z<N\) aun durante la disminución de la reserva a etiqueta fija. Una permanencia indefinida del mismo \(N\) en este canal tendría que ser aperiódica. El análisis deja abierta la existencia de esa permanencia y la posibilidad de una fuente que pague antes. [Prueba en papel y verificador](CAMBIOS_ETIQUETA.md)

- **B:** en \(k=214912002327049+2^{48}q\), la salida inmediata en T68 desciende exactamente si \(q\equiv0\pmod4\). En esa misma guarda también existe una fuente física menor. La rama B con \(b_{67}=1\) obtiene un descenso distinto en T68 para \(q\equiv2\pmod8\) en su propia parametrización. [Cotejo de B](CHECK_FEEDBACK.json) · [Rama con \(b_{67}=1\)](REENTRADAS_B67_1_PAPER/RESULTADO.md)
- **C:** en una progresión física con \(m=16\) y valoración final \(3\), el pliegue \((E-1)/4\) paga en T88. Una progresión con \(m=17\) demuestra que esa misma forma de fuente puede superar \(N\) aunque la valoración final siga siendo \(3\). [Cotejo de C](CHECK_FEEDBACK.json)
- **Front4b y profundidad:** en la mitad \(s\) par de la rama \(q=108+128s\), la siguiente arista desde T60 desciende bajo el mismo \(N\). La salida con racha de unos y ruptura \(2\) queda abierta. En la fila mayor, una fuente menor que \(N\) que llegue a T59 requiere al menos 17 retornos. Son dos afirmaciones en papel con terminales distintos. [Guardas](CHECK_GUARDAS.json) · [Prueba de profundidad](INFORME_Q46.md)
- **Terras 89:** a altura 92 se cierra la banda \(a_1=72\) mediante dos fragmentos disjuntos que suman 15.830 proyecciones. Quedan el residual \(a_1\le71,\ D_3\le92<D_4\), la altura 146 o una cota equivalente y la obligación Q0 con desplazamiento uno. [Resultado y recibo](TERRAS89_A72_HIGH_GAPS/RESULTADO.md)

## Primera obligación pendiente

Enlazar paquetes de etiquetas diferentes sin renovar el origen. Desde un conector impagado, hace falta demostrar que se activa una captura con fuente física menor que \(N\), un descenso o una readmisión que retenga la deuda y reduzca estrictamente un recurso bien fundado. La reserva centrada y el precio del cofactor por separado no proporcionan esa implicación.
