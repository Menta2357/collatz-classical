# Front4b. Fila 3 con dos doses y ruptura uno tras la salida cuatro

Se fija \(t=116664+2^{20}k\), \(u=18+32t\), y se conserva la semilla original \(N\). Desde el pivote \(V=T^{62}(N)\) se componen el prefijo de entrada E1, los episodios \((3,2),(3,1)\), la valoración 4 y dos valoraciones 2. Se alcanza \(U=T^{78}(N)\), con libro local desde \(V\) \((16,25,82533593)\) y libro absoluto \((78,123,C_U)\). El siguiente retorno tiene valoración uno. Se verifica \(N<V<U<2N+1\), de modo que la fuente mitad de \(U\) es válida para la primera ruptura fuerte de esa racha.

**Toda ruptura fuerte de la racha maximal de unos desde \(U\) paga.** No hay límite para la longitud \(L\ge1\). Si la ruptura tiene valoración \(b\ge3\), la fuente \(w=(U-1)/2<N\) recorre \((1^{L-1},2,b-2)\) y llega al mismo terminal original \((1^L,b)\), con libro propio. Si \(L=1\), el retorno fuerte también desciende directamente en \(T^{80}(N)\). Si el primer rompimiento es exactamente 2, el teorema entrega su longitud real, el factor exacto y el libro original, que se prolonga en las siguientes guardas.

| Continuación desde \(U\) | Resultado certificado |
| --- | --- |
| \((1,2)\) | Pago o resto admitido al aplicar el reductor ambiente en el terminal \(<2N+1\). Este paso no implica descenso del pivote antiguo. |
| \((1,2,a)\) con \(a\ge3\) | Descenso directo bajo \(N\). |
| \((1,2,2)\) | Primer cruce bajo \(U\) con el mismo \(N\), que alimenta el consumidor A2. El cruce está por encima del pivote antiguo \(V\). |
| \((1^3,2,3)\) | Fuente impar \((2Y-1)/3<N\) de un retorno, con \(Y\) el terminal original. |
| \((1^4,2,4)\) | Primer cruce bajo \(V=T^{62}(N)\) en \(T^{84}(N)\), por encima de \(N\), con consumidor A2. |
| \((1^6,2,5)\) | Fuente impar \((2Y-1)/3<N\) de un retorno. |
| \((1^7,2,5)\) | Fuente impar \(4(Y+1)/9-1<N\) de dos unos. |

Los cruces producidos por Lean conservan el primer cruce físico y su historia. La posición concreta del primer cruce en cada palabra se comprueba también por las valoraciones de los prefijos. Todo resultado de rango sigue referido al mismo \(N\). El consumidor de A2 puede dar pago o un pivote ambiente de menor altura que el pivote indicado. Iterar exige un productor aplicable al nuevo estado. En las guardas de captura la llegada a 1 consume la inducción sobre la fuente menor.

Queda abierta la ruptura 2 de las otras longitudes y colas. En particular, para \(L=1\), el conector siguiente 1 tras \((1,2)\) permanece sin pago ni cruce en estos certificados. Se verificaron 33 testigos dirigidos en modo normal y optimizado, incluyendo rachas de longitud 27, ambos pivotes, las fuentes de uno y dos retornos y el libro desde el origen.

[Prueba Lean](../lean/Front4bShortR2Three.lean) · [Recibo](../provenance/source_receipts.json) · [Comprobador](check_row3_r2.py)
