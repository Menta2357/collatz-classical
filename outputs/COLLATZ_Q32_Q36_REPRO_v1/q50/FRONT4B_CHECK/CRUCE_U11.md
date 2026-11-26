# Front4b · Cruce estricto para toda la clase u≡11 mod 16

**Demostración en papel con cotejo afín exacto.** En $s=29+32u$, $u=11+16t$, la continuación desde $V=T^{62}(N)$ es exactamente $(1,2,2)$. Los dos primeros retornos superan $V$. El tercero, $Q=T^{65}(N)$, verifica $N<Q<V<5N/4$. El libro local es $(3,5,23)$ y el original $(65,103,72551301119972516370644828770691)$.

El consumidor certificado de primer cruce se aplica a este cruce estricto y conserva el libro desde el mismo $N$. Devuelve un pago o un estado admitido $x<V$ en el dominio acotado. Equivalentemente, se puede reducir desde $Q$ con el reductor de ventana y, en la rama residual, obtener $x\le Q<V$. Por eso **toda** la clase $u\equiv11\bmod16$ satisface este primer paso decreciente. El terminal $Q$ puede perder la etiqueta de entrada; el reductor devuelve un estado posterior con su propia prueba de admisión.

La subclase $u\equiv27\bmod128$ permite identificar directamente $x=Q$ como estado admisible. En la clase general, un segundo pago o cruce desde el estado residual sigue pendiente. Este primer cruce no aumenta el recuento de pagos certificados. [Cotejo afín de la progresión completa](RECIBO_CRUCE_U11.json)
