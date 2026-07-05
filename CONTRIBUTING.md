# CONTRIBUTING

## Estructura de trabajo

- **Hilo A** (ejecutor): entrada al CC Challenge, catalogo, auditoria.
- **Hilo B** (ejecutor): feasibility matematica Krasikov/KL.
- **Coordinacion**: revision conjunta, decisiones GO/NO-GO.
- **Revisor externo** (Claude): critica de claims, fidelidad a fuentes,
  deteccion de duplicacion y de reutilizacion inflada.

Maximo dos hilos ejecutores activos. La dispersion es un modo de fallo
conocido de este equipo.

## Reglas no negociables

1. **Regla de sincronizacion**: ningun hilo declara GO, escribe Lean o
   registra un target en el challenge hasta que ambos reportes de fase
   esten revisados juntos en coordinacion.
2. **Etiquetas calibradas**: CLOSED / CONDITIONAL / OPEN / NOT_CLAIMED.
   Un `∀` instanciado por enumeracion es finito, se llame como se llame.
3. **Fuentes**: statement transcrito, no parafraseado. Si la fuente
   primaria no es localizable, el sustituto se etiqueta como surrogate.
4. **Sin seleccion a posteriori**: constantes y criterios se declaran
   antes de mirar los datos que deben acotar; las elecciones (p. ej. que
   formalizacion auditar primero) se reportan con el criterio que domino.
5. **Todo entregable pasa el checklist**: `audits/ADVERSARIAL_AUDIT_CHECKLIST_v1.md`
   se aplica a nuestro propio trabajo antes que al ajeno.

## Formato de entregables

Notas en `docs/` con nombre `TAREA_vN.md`, clasificacion final en bloque
de codigo, y hash sha256 si el contenido respalda una decision GO/NO-GO.

## Licencia

Apache 2.0 (compatibilidad con el ecosistema mathlib). Al contribuir
aceptas licenciar tu aportacion bajo esos terminos.
