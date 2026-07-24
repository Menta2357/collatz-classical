# F3 arithmetic-codec pilot repair v5 audit-only static review

Status: `STATIC_PASS / AUDIT_NOT_EXECUTED`

Date: 2026-07-24.

V5 inherits the publicly custodied v4 terminal at `a7a720e`. There is no Lean
source, audit source, inventory or checker edit. The only behavioral delta is
that the audit `LEAN_PATH` now contains the donor project build root which
holds the frozen `F3ReturnExcursionExactCoreMatrix.olean`.

```text
LEAN_SOURCE_DIFF = EMPTY
AUDIT_SOURCE_DIFF = EMPTY
INVENTORY_DIFF = EMPTY
CHECKER_DIFF = EMPTY
COMPILE_AUTHORIZED = false
AUDIT_ATTEMPTS = 1
CHECKER_ATTEMPTS = 1 iff audit PASS
```

The repair `.olean` and `.ilean` from the successful v4 compile and the donor
ExactCoreMatrix `.olean` are present with the recorded hashes. All are ignored
local artifacts; the contract states this reproducibility limitation and
forbids regeneration.

Static inventory coverage remains 151/151/151 with 12/12 designated final
public theorems and no forbidden source syntax. PASS or STOP must be published
to a draft PR stacked on v4.
