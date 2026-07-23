# F3_SEMANTIC_FIRST_ORIENTATION_v1

Status: `INTERFACE_ONLY_OPERATOR_TO_FIBRE_OPEN`

This page fixes the orientation before any numerical certificate is used.
For a source state `s`, target state `t`, and window parameter `z`, the
semantic one-step statement is

```text
B_s(z) ≥ Σ_t M(s,t) · B_t(shift(s,t,z)).
```

The first index of `M` is therefore the source row.  If masses are stored as
a column and pushed by

```text
(M ⋅ μ)_t = Σ_s μ_s · M(s,t),
```

then the compatible certificate is the left inequality

```text
(1 + δ) · w_s ≤ Σ_t M(s,t) · w_t.
```

The transposed transition used by the generic push-forward API is introduced
only at that boundary, as `coreTransition s t = coreMatrix t s`.  This is a
definition, not a silent choice of certificate orientation.

The accompanying Lean module proves only the algebraic interface: a
source-row certificate gives one weighted-mass step, and a semantic row
family retains the source-row orientation through arbitrary shifts.  It does
not prove the semantic inequality for the frozen F3 data, construct the
operator-to-fibre lower bound, or imply a `piStar` theorem.

## Required next lemma (not claimed here)

For the actual F3 windows, instantiate `B`, `shift`, and the finite fibre
maps so that each term on the right is supplied by disjoint sibling fibres.
The needed invariant is over `(state, accumulated shift)` and is inductive
over expansion depth; paths must not be materialized as an unproved finite
enumeration.  Until that instantiation is checked, the status remains open.

Claims intentionally absent: `NO_RHO_CERTIFICATE`, `NO_DENSITY_THEOREM`,
`NO_ALMOST_ALL`, and `NO_GLOBAL_COLLATZ_CLAIM`.
