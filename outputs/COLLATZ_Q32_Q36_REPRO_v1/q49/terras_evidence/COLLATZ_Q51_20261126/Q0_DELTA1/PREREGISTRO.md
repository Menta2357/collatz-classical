# Q51 · Corte de la semilla en Q0 con desplazamiento uno

Objeto fijo: primer cruce finito Q0 de 89 rachas impares máximas, con terminal \(T^k(N)=N+1\). Se mantienen el mismo \(N\), los relojes \(k,d\) del mapa abreviado y el aditivo de toda la trayectoria. La misma consulta Q0 de Weaver puede recibir un precio mejor si se impone un piso mayor \(L\) para la semilla del contraejemplo. Ese piso sólo acota los recíprocos de la trayectoria dada.

Se fija una única prueba aritmética, con rangos \(\ell=7,\ S=11,\ R=12\) y el umbral publicado de Weaver \(U=453027402666008300866\). Se consumen los suelos Q37 disponibles con cuatro rachas. Para un piso candidato \(L\) se comprueba:

    eta(L) = lambda_lower - 1/(L(L+1)) - 5/L
             - sum_(i=11..89) 1/max(L,2^H_i-1).
    eta(L)>0 y U eta(L)≥4.

Se examina el resultado en \(L=B=28\cdot10^{18}\) y \(L=2B\). Si hay transición, se halla por bisección entera el primer \(L\) aceptado y se coteja \(L-1\). Con todas las guardas satisfechas, Q0 con desplazamiento uno queda excluido para \(N\ge L\). Si la plantilla no produce corte, se detiene este contraste.

No se enumeran semillas, órbitas, progresiones, relojes ni intervalos Weaver. No se admiten como premisas las capacidades de cinco rachas pendientes. La exclusión de Weaver se consume de su recibo ya reproducido. [Reducción Q37](../../COLLATZ_Q37_20261125/TERRAS89_PAPER/RESULTADO.md) · [Estado Q50 de las capacidades](../../COLLATZ_Q50_20261126/TERRAS/RESULTADO.md)
