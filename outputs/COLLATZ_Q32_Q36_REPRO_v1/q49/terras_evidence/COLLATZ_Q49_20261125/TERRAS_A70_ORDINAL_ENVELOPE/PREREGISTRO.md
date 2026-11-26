# Q49 — contraste ordinal H92/A70

## Propósito y alcance congelados

FOCUS=IMPROVEMENT. Mejorar una cota del quinto valle, o registrar el primer bloqueo para la capacidad 2^D5≤6^92, en fuentes impares positivas N con N+1<2^92, a1=70 y D3≤92<D4.

No se ejecuta a1=71 (propiedad del integrador), otra banda, H146, barrido de órbitas, enumeración de congruencias ni Lean. No se reabren certificados.

## De Bono breve

Subconjunto AGO/CAF/APC/FIP, con revisión WHITE/BLACK/BLUE; no se declara PASS completo del protocolo.
- AGO: decidir si la pérdida multiplicativa de cada hueco par cierra la banda.
- CAF: mismo N, mapa abreviado, longitudes máximas reales, reloj total separado del número de entradas impares, constantes aditivas conservadas.
- Patrón interrumpido: enumerar cofactores de otra banda. Cambio de representación: producto de pérdidas de tamaño por bloque, manteniendo sus transiciones físicas.
- Dos alternativas, cuota cerrada: (1) repetir proyección de semillas, no elegida; (2) sobre multiplicativo común, elegida como único contraste.
- FIP: probar una identidad general y evaluar sólo sus constantes extremas. Ninguna aproximación logarítmica flotante entra en la prueba.
- RED: el ahorro podría ser pequeño; no es evidencia.
- YELLOW: incluso un STOP distingue falta de control físico de un límite de cálculo.
- GREEN: la idea del producto comienza como PO, sin padres de prueba; sólo la prueba algebraica y revisión permiten promoverla.

## Candidato

Para cada bloque físico de longitud impar a≥1 y hueco par b≥1, con y=x+1 y cofactor impar u=y/2^a≥1:

    y_next/y ≤ (3^a+1)/2^(a+1).

Para rachas a,b≥1:

    (3^a+1)(3^b+1) ≤ 4(3^(a+b-1)+1).

Usar a2+a3≤22 para acotar a4≤143 y después D5≤460, conservando por separado la cota que se pretende demostrar (D5≤237).

## Ejecución única predeclarada

Un script de enteros exactos, sin entradas dinámicas:
1. Verificar SHA de tres referencias de alcance/coordinación; no ejecutarlas.
2. Contrastar 2^237≤6^92<2^238.
3. Contrastar 2^144<(3^70+1)(3^21+1)<2^145.
4. Contrastar 2^460<2^90(3^70+1)(3^21+1)(3^143+1)<2^461.
5. Registrar, como control de insuficiencia del sobre, la tupla abstracta (70,1,21,143,3). Verificar sus desigualdades de prefijo y D5=238>237. Nunca llamarla órbita, semilla ni contraejemplo a Collatz.
6. Registrar la cota escalar anterior 467 sólo como comparación algebraica.

Presupuesto: una ejecución, como máximo 32 comparaciones principales de enteros de menos de 1024 bits; cero fuentes físicas recorridas y cero compilaciones. Sin reintentos ni ampliaciones. Auditoría independiente en papel del mismo contraste, sin nuevas rutas.

PASS del lema: identidades, monotonía y cotas auditadas y contrastes exactos verdaderos.
STOP de cierre de banda: las nuevas desigualdades permiten la tupla abstracta con D5=238.
ERROR: hash distinto, contradicción algebraica o comparación fallida; registrar sin reparar.

## Libros e índices

x0=N. La racha i parte de x_(i−1), tiene ai=nu2(x_(i−1)+1), termina en un pico par; bi es su valoración exacta y xi el siguiente valle impar.
D_j=sum(ai), k_j=sum(ai+bi). No se confunden.

Libro original: 2^k_j x_j=3^D_j N+C_j.
Libro desplazado del mismo N: 2^k_j(x_j+1)=3^D_j(N+1)+E_j.
No hay fuente auxiliar nueva; el segundo libro no es una transferencia a otro origen.

## No-claims y final

PAPER y LEAN se reportan separados. No se afirma realización física de extremos, optimalidad sobre órbitas, cobertura de la banda, Terras89 completo, existencia universal del primer cruce, densidad, almost-all, rho ni Collatz global.
Tras entregar: ninguna nueva banda sin decisión del principal.
