# F3 base-segment table v1

Date: 2026-07-22.

Status:

```text
PASS_FINITE_BASE_SEGMENT
DIAGNOSTIC_INPUT_TO_LEMMA_C
NO_FORMAL_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. Declared segment

The finite base segment is the half-open root interval `[3,10369)` with
`y_base=8`.  A root `a` with `a ≡ 2 (mod 3)` is a positive witness because
`a` itself belongs to `piStar(a,2^8*a)`.  The table uses only this explicit
witness; it does not assume a density theorem.

The fixed target state for the finite split-core paths is
`d5:r2:podd:b0`.  Reverse BFS in the 243-state core records a connecting path
from every state to that target.

## 2. Results

```text
core_state_count = 243
root_count_total = 3455
root_count_min = 10
root_count_max = 22
zero_witness_states = 0
unreachable_states = 0
distance_max = 6
weighted_base_mass_min = 0.031
weighted_base_mass_max = 0.122782
weighted_base_mass_min_state = d5:r101:peven:b1
```

The complete table is
`results/F3_RETURN_EXCURSION_SPLIT_EDGE_v1/base_segment_table_v1.csv`,
sha256:

```text
2d5fbf7d0fa6dd61e5444cc5dea4f117497e5642a464d92d7380838c532ee0aa
```

The generator/checker is `scripts/f3_base_segment_table_v1.py`.

## 3. Interpretation

Every core state has a positive root witness in the declared segment and a
finite path to the target base state.  The minimum displayed weighted mass is a
finite base-segment lower-bound input for Lemma C.  It is not yet an all-`y`
statement and does not by itself prove the renewal conversion.

