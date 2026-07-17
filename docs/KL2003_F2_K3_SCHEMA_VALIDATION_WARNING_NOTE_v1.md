# KL2003 F2 k=3 Schema Validation Warning Note v1

Date: 2026-07-18

Status: `FORMAT_WARNING_NAMED_OR_RESOLVED`

## Purpose

This note names and records the only expected warning produced by the k=3
certificate schema validator after the schema-v2 amendment.

The validator is a format checker only.  It does not verify KL2003
mathematics, does not validate generated Lean data as a theorem, and does not
open Lean.

## Named Warning

```text
EXTERNAL_MANIFEST_PRESENT_NOT_VALIDATED
```

Current message:

```text
External artifact manifest exists but this schema validator only reports its
presence.
```

The warning is emitted for:

```text
outputs/KL2003_F2_K3_CERTIFICATE_FIXTURE_v1/manifest_sha256.csv
```

## Disposition

This warning is acceptable for schema validation v1.

Reason:

- `schema_validator_v1` checks JSON shape, fixture flags, canonical rational
  strings, id references, and declared schema-v2 metadata.
- The sibling manifest belongs to a separate artifact-custody layer.
- Full external-manifest verification will require checking the JSON fixture,
  generated Lean data fixture, JSON-to-Lean generator hash, and manifest
  cross-hashes together.
- That is intentionally not part of the current format-only schema validator.

The warning is no longer anonymous: it is recorded by code in
`schema_validation_summary.json` under:

```text
warning_codes
warnings
known_warning_policy
```

## Guardrails

- No mathematical verification.
- No k=3 real rows generated.
- No LP solved.
- No Lean opened.
- No high-k theorem claim.
- No global Collatz claim.

## Classification

```text
FORMAT_WARNING_NAMED_OR_RESOLVED
FORMAT_CHECK_ONLY
NO_MATHEMATICAL_VERIFICATION
NO_HIGH_K_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
