# KL2003 Source Audit: PSTeX Tree Labels v1

Fecha: 2026-07-13.

## Objetivo

Auditar la "via 1.5" propuesta para el bloqueo row28/mod8: revisar si los
overlays de figuras `kafg3.pstex_t` y `kafgA1.pstex_t`, junto con la seccion
de deletion rule en `30apr02.tex`, contienen la tabla constructor-only que falta:

```text
literal -> inverse word -> Nat root formula -> forward route -> deletion/boundary correction
```

## Clasificacion

```text
PSTEX_TREE_LABELS_AUDITED
FIGURE_A1_LABELS_FOUND
DELETION_RULE_SOURCE_LOCATED
LP_TABLE_SOURCE_LOCATED
BLOCKED_ON_MISSING_KL2003_LITERAL_WORD_TABLE_CONFIRMED
NO_LITERAL_INVERSE_WORDS_IN_PSTEX_T
NO_NAT_ROOT_FORMULAS_IN_PSTEX_T
NO_NEW_LEAN
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Fuentes Locales Auditadas

```text
/Users/MoiTam/Documents/Codex/2026-07-05/tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/kl2003_src/30apr02.tex
/Users/MoiTam/Documents/Codex/2026-07-05/tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/kl2003_src/kafg3.pstex_t
/Users/MoiTam/Documents/Codex/2026-07-05/tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/kl2003_src/kafgA1.pstex_t
/Users/MoiTam/Documents/Codex/2026-07-05/tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/kl2003_src/kafg3.pstex
/Users/MoiTam/Documents/Codex/2026-07-05/tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/kl2003_src/kafgA1.pstex
```

Hashes SHA-256:

```text
04fa4d484fe89256f6771f5651338891219385f6e049ffaf41035541016232cd  30apr02.tex
fa8f8ca7d8282a5ba0ec1127a66f1d4df47e85f0208faa13b4b20c077880c1a5  kafg3.pstex_t
a89f731f78050d5891069c54aefe6f052b5faa82fad6bad2ba46c7b9a9330ceb  kafgA1.pstex_t
cb7d6ba27802ae17cb02eaa73bcaf977ec64a4dc77be70570a971214f1f4c3ea  kafg3.pstex
1f4b4218099af1d34588749cdeb5933cb80eeba48cb94f8537a3a6ccdce802b1  kafgA1.pstex
```

## Resultado De `kafg3.pstex_t`

`kafg3.pstex_t` contiene el overlay textual de la figura D3 general. Sus labels
son algebraicos, por ejemplo:

```text
phi_k^m(y) equiv (m,0)
(4m,-2)
((2m-1)/3, alpha-1)
((2m-1)/3 + 3^(k-1), alpha-1)
((2m-1)/3 + 2*3^(k-1), alpha-1)
```

No contiene palabras inversas, formulas Nat para raices literales, rutas forward
ni correcciones literal-specific de deletion.

## Resultado De `kafgA1.pstex_t`

`kafgA1.pstex_t` contiene el overlay textual de la figura `T_2^8(EL)`. Contiene
labels algebraicos para nodos finales y eliminados, incluyendo:

```text
(8,0)
(5,-2)
(8,alpha-3)
(2,alpha-3)
(8,2alpha-5)
(2,2alpha-5)
(2,3alpha-5)
(5,3alpha-5)
(8,3alpha-5)
```

Tambien contiene nodos intermedios/deleted con shifts `alpha-1` y `2alpha-3`.

Esto confirma que la figura codifica el arbol algebraico y sus labels, pero no
la tabla constructor-only requerida para el hook member-wise.

## Resultado De Los `.pstex`

Los archivos `.pstex` contienen la geometria PostScript de las figuras. El grep
textual no encontro labels matematicos adicionales ni palabras inversas; las
etiquetas legibles estan en los overlays `.pstex_t`.

## Resultado De `30apr02.tex`

Referencias relevantes:

```text
lineas 702-779: splitting step y deletion rule general
lineas 1758-1784: inclusion de Figure A1 y definicion algebraica de I_2^8(EL)
lineas 1798-1845: Table 4 / L_2^EL
```

La fuente TeX localiza:

```text
deletion rule general
Figure A1 / T_2^8(EL)
I_2^8(EL) algebraico
Table 4 / L_2^EL
```

No localiza:

```text
literal inverse words L1-L7
Nat root formulas L1-L7
forward routes L1-L7
literal-specific deletion/boundary corrections
```

## Observacion De Errata Ya Registrada

El TeX del apendice y la tabla no estan completamente alineados en la rama
intermedia de `M1`. El proyecto ya normaliza esta discrepancia en los documentos
previos: la capa Lean y M0C usan la version normalizada que ya fue auditada en
el reporte de factibilidad y en los contratos M0C.

## Conclusion

La via 1.5 fue revisada y no proporciona la tabla que falta. Los overlays de
figuras son utiles para custodiar labels y deleted nodes, pero no materializan:

```text
literal -> inverse word -> Nat root formula -> forward route
```

Por tanto, el bloqueo sigue siendo:

```text
BLOCKED_ON_MISSING_KL2003_LITERAL_WORD_TABLE
```

La siguiente decision de fuente queda entre:

```text
1. localizar un generador/output Applegate-KL con palabras inversas;
2. encontrar un artefacto previo de marzo con la tabla constructor-only;
3. autorizar una reconstruccion nueva desde splitting/deletion rules,
   etiquetada como RECONSTRUCTION y validada por hook member-wise.
```

