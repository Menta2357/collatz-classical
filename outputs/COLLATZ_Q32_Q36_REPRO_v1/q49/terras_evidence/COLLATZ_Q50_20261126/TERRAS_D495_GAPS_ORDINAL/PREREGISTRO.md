# Q50 — D4=95 mediante huecos físicos

## Gate y criterio congelados

Objeto: N>0 impar, N+1<2^92, a1≥3, D3≤92 y D4=95 en el mapa abreviado. ai son longitudes de rachas impares máximas, bi las longitudes de sus huecos pares máximos. D_j=sum ai, B_j=sum bi, k_j=D_j+B_j. El dominio implica 3≤a1≤90.

PASS en papel: demostrar D5≤237 y 2^D5≤6^92 para todo ese dominio mediante una partición exhaustiva por B4.
STOP: primera condición física no demostrada, constante falsa, hash distinto o error de libro. No reparar después de la ejecución.

La auditoría interna del principal es dueña del lote a1=70. Aquí no se ejecuta ningún lote ni se cuenta su resultado como nuevo. H146 queda separado.

## De Bono breve

FOCUS=IMPROVEMENT; AGO/CAF/APC/FIP y WHITE/BLACK/BLUE, sin PASS completo de protocolo.
- Patrón: producto de cuatro pérdidas que sustituía todos los huecos por uno.
- Representación nueva: conservar B4 y la restricción modular del cofactor cuando un hueco es largo.
- Cuota de alternativas: dos. Proyectar otra banda, descartado; conservar huecos y, sólo si un extremo es único, retroceder aritméticamente, elegido.
- WHITE: libros exactos, maximalidad física y guardas del dominio.
- RED: no tomar un extremo del sobre por una órbita.
- BLACK: probar exhaustividad de B4=4, B4=5, B4≥6; no reiniciar el origen.
- YELLOW: una desigualdad común puede retirar un valor de D4 en todas las bandas pendientes.
- GREEN: la propuesta comenzó como PO sin padres de prueba; no se promueve hasta prueba y revisión.
- BLUE: un solo contraste de constantes, cero enumeración, cierre o STOP.

## Prueba candidata preseleccionada

B4≥6: reducción del producto por factor ≤9/25. Dos huecos ≥2 dan (3/5)^2; un único hueco ≥3 requiere separar a=1, a=2 y a≥3. La excepción a=2 se paga con una fusión más estrecha. El producto residual se acota por 28(3^90+1).

B4≤5: el libro desplazado da E4/3^95≤(175/9)(2/3)^a1<2^a1. Usar N+1≤2^92−2^a1. Si B4=5, la altura termina el argumento. Si B4=4, la negación D5≥238 fuerza x4+1=2^143 y a4=3. Entonces el antecesor necesario en el tercer hueco no es divisible por 3: contradicción.

## Contraste único

Un programa exacto, sin bibliotecas externas:
- verifica las dos huellas Q49;
- verifica 2^237≤6^92<2^238 y 3^95<2^151;
- verifica 252(3^90+1)<25·2^146;
- coteja las constantes racionales 1/3,17/56,5/14 <9/25;
- coteja la suma geométrica 3·sum_(0..3)(4/3)^i=175/9 y 175<243;
- calcula sólo los residuos 2^144 mod81=55 y (2^148−43) mod81=27, y los dos valores forzados bajo la negación. No son una fuente ni una órbita realizada.

Presupuesto: una ejecución, como máximo 24 comprobaciones principales, enteros de menos de 1024 bits; cero fuentes físicas recorridas, cero proyecciones, cero Lean, sin reintentos ni ampliación. Dos revisiones independientes complementarias en papel: huecos cortos y huecos largos.

## Libros y alcance

2^k_j x_j=3^D_j N+C_j, C0=0,
C_next=3^a C+2^k(3^a−2^a).

2^k_j(x_j+1)=3^D_j(N+1)+E_j, E0=0,
E_next=3^a E+2^(k+a)(2^b−1).
E_j=C_j+2^k_j−3^D_j. Ambos libros conservan el mismo N; no hay fuente auxiliar.

NO_CLAIMS: no cierre de H92 o H146, no Terras89 global, no primer cruce universal, no convergencia global, no densidad/almost-all/rho, no prioridad bibliográfica, no PASS Lean. No se interpreta 95 como un tiempo orbital ni como número de semillas.
