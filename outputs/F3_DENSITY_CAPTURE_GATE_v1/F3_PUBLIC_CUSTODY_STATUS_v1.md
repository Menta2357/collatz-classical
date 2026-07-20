# F3 — estado de custodia pública v1

Fecha: 2026-07-21.

## Repositorio objetivo

```text
local checkout = /Users/MoiTam/Documents/Codex/collatz-classical
origin         = https://github.com/Menta2357/collatz-classical.git
base branch    = master
planned branch = codex/f3-density-capture-gate
```

## Bloqueo actual

`gh` está instalado, pero `gh auth status` informa que el token activo de
`Menta2357` es inválido.

Por el contrato de publicación no se ha ejecutado:

```text
git branch creation
git add
git commit
git push
PR creation
```

El worktree contiene cambios k=11 no relacionados. Permanecen intactos y no se
incluirán en el commit F3.

## Acción humana necesaria

```bash
gh auth login -h github.com
gh auth status
```

Después de reautenticar, la publicación debe:

1. crear una rama aislada `codex/f3-density-capture-gate`;
2. añadir solo documentos, scripts, outputs y manifiestos F3;
3. verificar el paquete de nuevo;
4. hacer commit y push;
5. abrir PR draft;
6. entregar URL pública a Claude antes del veredicto formal.

```text
LOCAL_CUSTODY_COMPLETE
PUBLIC_CUSTODY_BLOCKED_ON_GITHUB_AUTH
FORMAL_COORDINATED_VERDICT_WITHHELD
```

