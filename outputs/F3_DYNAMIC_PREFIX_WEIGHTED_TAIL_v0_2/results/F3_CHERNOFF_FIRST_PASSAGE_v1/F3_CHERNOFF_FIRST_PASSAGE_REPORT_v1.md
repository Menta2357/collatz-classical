# F3 Chernoff first-passage Real lemma v1

Status: `REAL_LIVE_BOUND_TO_STOPPED_MASS_PASS_OPERATOR_LIVE_BOUND_OPEN`.

This module closes the purely analytic last step of the tilted renewal
argument.  If a ledger has initial mass `A` and live mass bounded by
`C * q^n`, with `0 ≤ q < 1`, then Lean proves

`A - C*q^n ≤ stopped n`,

the lower-bound sequence tends to `A`, and eventually the stopped mass exceeds
`A/2` when `A > 0`.  The result uses no F3 matrix, no empirical data and no
rho/density claim.  The remaining Chernoff obligation is therefore precisely
the path/operator proof of the geometric live bound with `q < 1`.
