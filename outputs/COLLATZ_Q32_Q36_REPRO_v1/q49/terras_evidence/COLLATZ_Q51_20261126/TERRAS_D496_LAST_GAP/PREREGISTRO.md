# Q51 — D4=96, precio del último hueco y divisibilidad física

## Gate congelado

N>0 impar, N+1<2^92, 3≤a1≤69, D3≤92, D4=96.
Mapa abreviado S; ai y bi son longitudes máximas reales de rachas impares y huecos pares. D_j=sum ai, B_j=sum bi, k_j=D_j+B_j.

Objetivo único: D5≤237, equivalente aquí a 2^D5≤6^92.
PASS requiere prueba de reducción exhaustiva y exclusión física de todos sus casos, dos revisiones complementarias y constantes exactas.
STOP ante primer defecto, hash distinto o superviviente no excluido. No reparar después del contraste.

No se ejecuta a1≤2, A70/A71, H146, ninguna proyección de semillas ni Lean.

## De Bono breve

FOCUS=PROBLEM. Subconjunto AGO/CAF/APC/FIP, con revisión WHITE/BLACK/BLUE; no se declara PASS completo del protocolo.
- AGO: decidir D4=96 dentro del único dominio autorizado.
- CAF: origen N, k=D+B, valoración física del cuarto bloque, cofactor positivo y aditivo completo.
- Patrón cambiado: pasar de productos de cuatro pérdidas a precio por último hueco. Mantener el aditivo como suma de cuatro inyecciones propagadas.
- APC: dos alternativas. Extender la clasificación de todos los huecos, retenida sin ejecutar; pagar directamente el último hueco y retroceder una sola arista, elegida.
- RED: un terminal impuesto por una desigualdad no es una órbita.
- BLACK: no exigir que el multiplicador terminal sea impar ni que el cofactor sea coprimo con 3.
- YELLOW: si funciona, se retira D4=96 de todas las bandas del dominio sin familia por familia.
- GREEN: el cambio empezó como PO; no se usa en pruebas hasta fijar identidades y revisión.
- BLUE: un único contraste de constantes y tres congruencias, sin ampliación.

## Candidato congelado antes de ejecutar

Poner yi=xi+1. En cada bloque:

    yi=qi*y_(i−1)+δi,
    qi=3^ai/2^(ai+bi),
    δi=1−2^(-bi).

Composición exacta:

    y4=3^96(N+1)/2^(96+B4)+R4,
    R4=sum_(i=1..4) δi product_(j=i+1..4) qj.

A partir de a1≥3, cada producto es a lo sumo (3/2)^93<2^93; por tanto 0<R4<2^95. Como B4≥b4+3:

    y4<3^96/2^(b4+7)+2^95.

Negar D5≤237 fuerza a5≥142 y y4=t·2^142 con t entero positivo, no necesariamente impar. De 3^96<9·2^149:

    t<9/2^b4+2^(-47).

Luego b4∈{1,2,3} y t≤4,2,1, respectivamente. Los huecos b4≥4 quedan excluidos por tamaño, sin truncar la cola.

La arista física final exige:

    3^a4 u4=2^b4(t·2^142−1)+1.

D3≤92 fuerza a4≥4. Por tanto el miembro derecho debe ser divisible por 81. Las tres soluciones modulares previstas para t son 56,3,17 módulo 81, todas mayores que sus techos.

## Única ejecución y presupuesto

- Verificar hashes del resultado y recibo D4=95, sólo como referencia del contraste.
- Verificar 2^237≤6^92<2^238 y 3^94<2^149.
- Verificar las cuatro cotas racionales: tres intervalos y exclusión de b≥4.
- Verificar 2^142 mod81=34, los tres inversos y sus residuos.
- Guardar los resultados de las tres filas, sin enumerar t ni fuentes N.

Presupuesto: una ejecución; menos de 24 comprobaciones principales; enteros menores de 1024 bits. Cero órbitas, barridos, proyecciones, Lean o reintentos. Dos revisiones independientes complementarias: reducción/toda la cola y corte modular.

## Libros conservados

2^k_j x_j=3^D_j N+C_j,
C_next=3^a C+2^k(3^a−2^a).

2^k_j(x_j+1)=3^D_j(N+1)+E_j,
E_next=3^a E+2^(k+a)(2^b−1),
E_j=C_j+2^k_j−3^D_j.

R4=E4/2^k4. No hay reinicio ni fuente auxiliar.

NO_CLAIMS: H92 completo, H146, Q0 Δ=1 completo, primer cruce universal, Collatz global, densidad, almost-all, rho, prioridad bibliográfica ni PASS Lean. El cierre sólo retira D4=96 del dominio fijado; no abre D4=97.
