# F3 dynamic prefix visible-residue correction v0.4

Date: 2026-07-21.

## Correction

The v0.3 visible family was too narrow:

```text
visible residues r == 2 mod 3 only
```

That was appropriate for selecting parent roots with an integral advanced
branch, but it was not appropriate for the state space. The advanced child
`c(a)` can land in any residue class modulo 3. If those images are routed to
tail merely because they are not `2 mod 3`, the tail is artificial.

## Corrected visible family

For the dynamic state:

```text
visible residues r mod 3^d = all residues
advanced branch exists only when r == 2 mod 3
```

A visible type remains:

```text
u = (d, r, p, b)
```

but `r == 2 mod 3` is now a transition flag, not a visibility condition.

## Immediate consequence

The `advanced_tail_phase_*` bucket from the first PHASE_A/PHASE_B pilot is not
structural. It measures an overly narrow visible alphabet.

The corrected pilot should charge to `Q_K` only:

```text
finite atoms
advanced phase loss
depth-zero prefix loss
explicit window/denominator failures
```

not ordinary advanced children in residues `0` or `1 mod 3`.

## Status

```text
PHASE_A remains stopped because its phase loss alone is too large.
PHASE_B becomes the live candidate under all-residue visibility.
```

