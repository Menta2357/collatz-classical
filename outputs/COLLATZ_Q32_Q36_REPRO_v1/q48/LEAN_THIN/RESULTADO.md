# A2 · Inducción en la ventana estrecha

El dominio `ThinAdmitted N x j S B` exige el estado admitido de A2 con su libro físico `Segment N x j S B` y la guarda (11x<12N). Se conserva el origen (N), la imparidad, la racha inicial de unos y la ruptura real de valoración dos.

`next_thin_rank` reutiliza el residual cronológico `RemainingBelow`. Su nuevo pivote (u) satisface (N≤u<x), conserva el libro compuesto desde (N), y por ello (11u<12N) y (u-N<x-N).

`paid_of_total_thin_producer` usa inducción fuerte sobre (x-N). Para cada pivote de esta ventana estrecha, su única hipótesis de producción exige un pago respecto al mismo (N) o un segmento físico desde ese pivote con algún retorno estrictamente inferior a él. El consumidor del primer cruce devuelve el propio pago o el residual de rango menor de la ventana estrecha.

El productor total sobre la ventana estrecha sigue siendo una premisa. Las guardas de descenso directo de Q48 pueden suministrar algunos de sus casos. Las capturas conservan la fuente impar positiva menor que (N), su propio reloj y su aditivo. Para deducir llegada a uno de un pago por captura se usa la convergencia inductiva de esa fuente menor.

[Teoremas](../../lean/A2ThinDomain.lean) · [Auditoría](AUDIT.log) · [Recibo](RECIBO.json)
