# F3 no-Claude continuation v1

Date: 2026-07-21.

## Reason

Claude is unavailable because the coordinating account has no remaining
credits. The project therefore cannot honestly record a coordinated external
verdict in this round.

## Replacement discipline

The missing external verdict is replaced by a stricter local rule:

```text
CLAUDE_UNAVAILABLE
NO_FORMAL_COORDINATED_VERDICT
LOCAL_CONTINUATION_ONLY
NO_LEAN
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
```

## Authorized continuation

The only authorized continuation is the paper object already required by the
v0.2 contract:

```text
write F3 dynamic prefix weighted-tail page v0.3
define F_K
define Q_K
define route maps
define W_K denominator
define hook schema
```

No computation is authorized merely because Claude is unavailable. A script
may be written only after v0.3 exposes an auditable finite contract.

## Ledger update

The public-custody status remains valid:

```text
repo   = https://github.com/Menta2357/collatz-classical
branch = codex/f3-density-capture-gate
latest public addendum commit = 868ea84
PR     = https://github.com/Menta2357/collatz-classical/pull/1
```

The next public update must explicitly say that the formal coordinated verdict
was skipped because Claude was unavailable, not because it was passed.

