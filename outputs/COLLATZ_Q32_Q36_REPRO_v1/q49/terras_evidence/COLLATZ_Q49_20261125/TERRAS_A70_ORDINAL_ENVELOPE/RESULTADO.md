# Q49 — sobre multiplicativo del quinto valle

## Resultado y grados de evidencia

1. PAPER con auditoría independiente y contraste entero: en H92, a1=70 y D3≤92, se tiene a4≤143, D4≤235 y D5≤460. Frente a aplicar dos veces la recurrencia escalar, el techo baja de 467 a 460. No son máximos observados en órbitas.
2. Corolario algebraico del mismo lema, obtenido al redactar tras el contraste: para 3≤a1≤89 y D4≤94, se tiene D5≤237, por tanto 2^D5≤6^92. Su prueba exacta está abajo. No se añadió ni ejecutó otro test: el integrador debe revisar este corolario antes de incorporarlo al estado certificado.
3. Para el encargo a1=70, el corolario cubre D4=93,94 del residual D3≤92<D4. Queda D4≥95. No se afirma realización física ni cardinalidad de las subclases cubiertas.
4. LEAN=NOT_RUN. TERRAS89_Q0_DELTA1=OPEN. No se abrió H146 ni otra enumeración.

El recibo JSON conserva exactamente la salida de la única ejecución predeclarada. Su STOP se refiere al cierre completo por el techo 460, no niega el corolario de guarda 94.

## Convenciones y libros, sin cambio de origen

S es el mapa abreviado, no el retorno impar acelerado. Sea x0=N>0 impar, y_j=x_j+1. La racha i parte de x_(i−1), con

    a_i=nu2(x_(i−1)+1)≥1,
    u_i=(x_(i−1)+1)/2^a_i impar,
    P_i=3^a_i u_i−1 par,
    b_i=nu2(P_i)≥1,
    x_i=P_i/2^b_i impar.

D_j=sum a_i cuenta entradas impares y k_j=sum(a_i+b_i) cuenta pasos de S.

Libro original:

    2^k_j x_j = 3^D_j N + C_j,
    C_0=0,
    C_(j+1)=3^a C_j + 2^k_j(3^a−2^a).

Libro desplazado de la misma órbita:

    2^k_j y_j = 3^D_j(N+1)+E_j,
    E_0=0,
    E_j=C_j+2^k_j−3^D_j,
    E_(j+1)=3^a E_j+2^(k_j+a)(2^b−1).

No se construyó una fuente auxiliar ni un segundo origen. Ambos libros son identidades del mismo N; no son una captura ni autorizan inducción sobre otra semilla.

## 1. Lema de contracción por bloque físico

Para a,b,u exactos como arriba,

    y_next = (3^a u+2^b−1)/2^b,
    y=2^a u.

Como b≥1,

    y_next ≤ (3^a u+1)/2.

Y u≥1 da

    y_next/y ≤ (3^a+1)/2^(a+1).

Multiplicando j bloques y usando N+1<2^92:

    y_j < 2^(92−D_j−j) · product_(i=1..j)(3^a_i+1).

Además 2^a_(j+1)≤y_j, pues su cofactor es un entero positivo. Por tanto:

    2^D_(j+1) < 2^(92−j) · product_(i=1..j)(3^a_i+1).       (★)

Se mantienen todas las valoraciones físicas; la desigualdad sólo olvida parte de esa información para obtener un sobre.

## 2. Fusión algebraica de longitudes

Para p,q≥1,

    4(3^(p+q−1)+1) − (3^p+1)(3^q+1)
      = 3(3^(p−1)−1)(3^(q−1)−1) ≥ 0.                    (F)

Es una desigualdad universal, no una afirmación de que las longitudes extremas puedan realizarse en una órbita.

## 3. Contraste predeclarado a1=70

Sea c=D3. Entonces 72≤c≤92. Fusionando a2,a3 en (★):

    y3 < 2^(91−c)(3^70+1)(3^(c−71)+1).

El factor 2^(−c)(3^(c−71)+1) es creciente en c≥72: poniendo t=3^(c−71)>1, su razón consecutiva es (3t+1)/(2t+2)>1. Así:

    y3 < ((3^70+1)(3^21+1))/2 < 2^144.

El último contraste entero fue verificado una vez; de aquí a4≤143 y D4≤235.

Aplicando (★) a j=4, (F) a a2,a3, y a4≤143:

    2^D5 < 2^90(3^70+1)(3^21+1)(3^143+1) < 2^461.

Luego D5≤460. El revisor /root/q49_ordinal_valley_audit confirmó en papel el lema, fusión, monotonía, índices y ambos libros. El script sólo contrastó las constantes con enteros; no sustituyó la demostración universal.

El techo 460 no alcanza 237. La tupla abstracta (70,1,21,143,3), con totales (70,71,92,235,238), satisface las desigualdades del sobre y viola D5≤237. Fue el control predeclarado de insuficiencia. No es una órbita ni un contraejemplo físico.

## 4. Corolario: ampliar el umbral D4≤92 a D4≤94

Este corolario usa sólo (★), (F) y aritmética entera explícita. Se obtuvo después del contraste predeclarado; no se modifica ese recibo ni se afirma una auditoría independiente específica del nuevo corolario.

Sea A=a1 y 3≤A≤89. Fusionar las otras tres longitudes de los primeros cuatro bloques da:

    product_(i=2..4)(3^a_i+1) ≤ 16(3^(D4−A−2)+1).

Por (★), si D4≤94:

    2^D5 < 2^92(3^A+1)(3^(D4−A−2)+1)
          ≤2^92(3^A+1)(3^(92−A)+1).

Ambos exponentes A y 92−A son al menos 3. Por ello:

    (3^A+1)(3^(92−A)+1)
      ≤ (28/27)^2 · 3^92
      = 63504 · (3^41)^2
      < 65536 · 2^130
      = 2^146.

Las comparaciones exactas usadas son:

    3^41 = 36472996377170786403
      < 36893488147419103232 = 2^65,
    63504 = 28^2·81 < 65536 = 2^16.

Por tanto 2^D5<2^238, es decir D5≤237. El contraste ya guardado da 2^237≤6^92.

Conclusión en papel:

    N impar positivo, N+1<2^92,
    3≤a1≤89, D4≤94
      ⇒ D5≤237
      ⇒ 2^D5≤6^92.

En el complemento activo a1≤70,D3≤92<D4, elimina conjuntamente D4=93,94 para 3≤a1≤70, sin recorrer bandas. No cambia la propiedad del trabajo a1=71 del integrador ni reabre sus certificados.

Pendiente, si el integrador acepta el corolario:

    (a1≤2, D3≤92<D4)
      o
    (3≤a1≤70, D3≤92, D4≥95).

Para esta entrega a1=70, el primer rango todavía abierto es D4=95.

## 5. Primer bloqueo: el mismo sobre permite 95

La tupla abstracta

    (a1,a2,a3,a4,a5)=(70,1,21,3,143),
    (D3,D4,D5)=(92,95,238)

no queda excluida por (★). Los dos primeros prefijos son los del control guardado. El tercero tiene un D4 menor y por tanto sigue satisfaciendo su desigualdad. Para el cuarto:

    2^88 product_(i=1..4)(3^a_i+1)
      =2^90·28·(3^70+1)(3^21+1)
      >2^90·28·2^144
      >2^238.

Se usó la comparación inferior del mismo producto guardada en el recibo. No se realizó una segunda ejecución ni se afirma que esa tupla tenga una fuente física.

STOP preciso: para bajar de D4≥95 al objetivo hace falta información que este sobre olvida, como la compatibilidad de valoraciones y cofactores del mismo N. La tupla sólo refuta la suficiencia de estas desigualdades, no la capacidad real buscada.

## Ejecución, De Bono y no-claims

- Una ejecución, exit_code=0; tiempo interno 0,007758 s.
- Fuentes físicas recorridas: 0. Congruencias proyectadas: 0. Barridos: 0.
- Sin Lean, reintentos, cambios en padres, H146 ni ejecución de a1=71.
- Verificador SHA256: 7b5653c68595a0c3462a1f3ddf22339e5b45da879568e7d1eb5973b5099aaa69.
- Prerregistro SHA256: 7658dc04d362380021a5b705647bd84ffa704cb5a9476cac0b63e9aa9a6e6a13.

De Bono condujo al cambio de representación de semillas a pérdidas multiplicativas. La revisión estrecha conserva el STOP y no se presenta como PASS de todo el protocolo.

No se afirma cierre de A70, de H92, Terras89, primer cruce universal, convergencia global, densidad, almost-all, rho, prioridad bibliográfica ni porcentaje de cobertura. No se abrió otra tarea. Siguiente acción recomendada al principal: revisar el corolario D4≤94 antes de integrarlo; no aumentar ventanas.
