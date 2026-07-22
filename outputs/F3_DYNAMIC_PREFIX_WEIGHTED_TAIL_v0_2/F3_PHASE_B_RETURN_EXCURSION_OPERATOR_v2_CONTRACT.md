# F3 PHASE_B return-excursion operator v2 contract

Date: 2026-07-21.

Status:

```text
RETURN_EXCURSION_OPERATOR_V2_CONTRACT
PARITY_LIFT_CHANNEL_INCLUDED
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. Why v1 stops

`F3_PHASE_B_RETURN_OPERATOR_INVENTORY_v1` stopped at:

```text
STOP_REBASING_NOT_MEMBERWISE
```

The stop is now sharpened: the v1 rebasing graph was not merely missing a
member-wise hook. It was also missing a full channel of mass, namely the parity
lift used in the classical row22 seam.

Therefore `REBASE_MEMBERWISE_HOOK_v1` is retired as next object. Even if it
were justified row-wise, it would justify an incomplete graph.

## 2. Formal precedent for the lift channel

The lift channel is already present in the classical k=2 Lean development:

```text
CollatzClassical/KL2003/KL2003ConcretePhiRealization.lean
```

Relevant names:

```text
row22AdvancedChild
row22LiftedChild
row22_advanced_child_arith
row22_advanced_child_mod_three
row22_parity_lift_maps_to_child
row22_advanced_child_maps_to_root
row22_parity_lift_route_to_root
row22_parity_concreteWindow
row22_parity_piStar_transfer_nat
row22_parity_piStar_transfer
row22_min3_le_lifted_child
row22_min3_le_direct_advanced
```

This F3 page does not import or extend Lean. It cites row22 as the formal
precedent for the type of member-wise inequality the new channel must use.

## 3. Three-channel return graph

Fix:

```text
d0 = 5
rho_star = 9/5
lambda_11_official = 71689/40000
state space = all residues modulo 3^d0, with nu2 bucket b in {0,1,2}
```

At fixed `d0`, the residue class modulo `9` determines the advanced child
class modulo `3`. Across the finite advanced sector this gives an exact
one-third enumeration of the three channels. The factor is therefore a finite
residue count, not a fitted statistic.

Channels:

```text
retarded:
  a -> 4a
  weight = rho_star^(-2)

advanced direct:
  c = (2a - 1)/3, c == 2 mod 3
  weight per deep lift = rho_star^(log_2(3)-1) / 3

advanced parity lift:
  c = (2a - 1)/3, c == 1 mod 3
  2c returns to the tracked sector through one parity step
  weight per deep lift = rho_star^(log_2(3)-1) * rho_star^(-1) / 3

sterile tail:
  c = (2a - 1)/3, c == 0 mod 3
  charged to row-wise Q
```

The `1/3` factors are not fitted statistics. They are exact finite residue
enumeration over the advanced sector.

## 4. Scalar check

The sector scalar shadow is:

```text
F_sector(rho)
  = rho^(-2)
    + (1/3) * rho^(log_2(3)-1)
    + (1/3) * rho^(log_2(3)-1) * rho^(-1)
```

At `rho = 2`:

```text
1/4 + 1/2 + 1/4 = 1
```

The lifted channel contributes exactly `1/4` at the critical point.

At `rho_star = 9/5`, the v2 script must report the actual decimal value before
any LP or holdout step.

## 5. Acceptance criteria

Allowed verdicts:

```text
RETURN_EXCURSION_V2_BUILT_DIAGNOSTIC_ONLY
STOP_V2_PERRON_BELOW_ONE
STOP_V2_MEMBERWISE_HOOKS_MISSING
```

Forbidden:

```text
RHO_CERTIFIED
LEAN_READY
DENSITY_THEOREM
ALMOST_ALL
GLOBAL_COLLATZ
```

The next certificate step, if the v2 Perron diagnostic is promising, is a
paper member-wise hook for every channel and a row-wise tail `Q` budget. Only
after that may weights `w` be frozen and tested on holdout.
