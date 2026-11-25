# Ensamblaje certificado de Terras 88 y Terras 89

Lean 4.21 verifica el reloj abreviado y su contabilidad afín desde el mismo $N$. El prefijo conserva todos los pasos y las salidas impares. La extracción usa índices cronológicos y una selección de mínimos con multiplicidad. Esto permite conservar un último hueco par truncado sin contarlo como bloque completo.

- Terras88.first_descent88 deriva el primer descenso a partir de los insumos explícitos de Terras88.Inputs. Quedan como entradas externas el acuerdo en el rango bajo, el caso de hasta 87 rachas, la exclusión de igualdad, la criba, las cotas de rangos y las dos consultas de Weaver.
- Terras89.first_descent89_from_capacities consume las capacidades de cinco rachas en H92 y H146, la reducción de Q37 y su entrada de rangos. La prueba en papel y los certificados exactos desarrollan esas premisas. Lean comprueba también el transporte de la cota alternativa de Freelan Lab bajo su propia premisa externa.
- Terras89.suffix_crossing_at_descent reutiliza Terras 88 para un segmento físico de como máximo 88 rachas. Si el segmento baja por primera vez de su inicio en el extremo, su primer cruce del coeficiente está en ese mismo extremo. La órbita se compone con el reloj absoluto.

Los tres módulos nuevos y la auditoría separada compilaron con un hilo. Los doce teoremas auditados declaran sólo axiomas estándar. El ensamblaje es condicional a sus insumos, que se documentan aparte de los objetos Lean. La formalización integral de los insumos y el cruce universal siguen abiertos.
