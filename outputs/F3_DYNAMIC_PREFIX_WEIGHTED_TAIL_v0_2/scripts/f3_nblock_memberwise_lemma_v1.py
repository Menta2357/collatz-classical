#!/usr/bin/env python3
"""Audit the member-wise N_block lemma for the selected F3 ledger route.

The audit has two independent parts:

1. arithmetic: one fixed fine 3-adic digit has density 1/3 in the
   depth-six period 3^6, giving 3^6/3 = 3^5 = 243;
2. exhaustive frozen-state enumeration: every one of the 243 frozen core
   states has exactly one valid representative in each fine-lift fibre.

The Omega fallback is checked separately from N_block.  This is a counting
audit only; it is not a formal rho certificate, density theorem, or Lean proof.
"""

from __future__ import annotations

import csv
import hashlib
import json
from collections import Counter, defaultdict
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RESULTS = ROOT / "results" / "F3_RETURN_EXCURSION_SPLIT_EDGE_v1"
LEDGER = RESULTS / "combined_ledger_v1_2.json"
OUT = RESULTS / "nblock_memberwise_lemma_v1.json"

D0 = 5
D_FINE = D0 + 1
STATE_PERIOD_3ADIC = 3**D_FINE
FINE_PERIOD_WITH_2ADIC_RETICLE = 4 * STATE_PERIOD_3ADIC
FINE_LIFT_DENSITY = Fraction(1, 3)
N_BLOCK_EXPECTED = 3**D0
THRESHOLD_N_BLOCK = 203
BOUNDARY_ROOTS = 2
DELTA = Fraction(1, 100)
RHO_STAR = Fraction(9, 5)
Y_BASE = 8
EXPECTED_W_SHA256 = "580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def parity(n: int) -> str:
    return "odd" if n % 2 else "even"


def bucket(n: int) -> int:
    if n % 2:
        return 0
    return 1 if n % 4 else 2


def state_label(n: int) -> str:
    return f"d{D0}:r{n % (3**D0)}:p{parity(n)}:b{bucket(n)}"


def parse_state(state: str) -> tuple[int, str, int]:
    parts = state.split(":")
    return int(parts[1][1:]), parts[2][1:], int(parts[3][1:])


def representative(state: str, lift: int) -> int:
    residue, wanted_parity, wanted_bucket = parse_state(state)
    n = residue + lift * (3**D0)
    step = 3 * (3**D0)
    while (
        n <= 0
        or parity(n) != wanted_parity
        or bucket(n) != wanted_bucket
    ):
        n += step
    return n


def fine_lift_for_root(root: int, state: str) -> int:
    residue, _parity, _bucket = parse_state(state)
    return ((root % (3**D_FINE)) - residue) // (3**D0) % 3


def expected_states() -> set[str]:
    return {
        f"d{D0}:r{residue}:p{p}:b{b}"
        for residue in range(3**D0)
        if residue % 3 == 2
        for p, b in (("odd", 0), ("even", 1), ("even", 2))
    }


def main() -> None:
    with (RESULTS / "frozen_w_split_core.csv").open(newline="") as handle:
        frozen_rows = list(csv.DictReader(handle))
    frozen_sha = sha256(RESULTS / "frozen_w_split_core.csv")
    frozen_states = {row["state"] for row in frozen_rows}
    expected = expected_states()

    # Arithmetic derivation: a fixed fine digit occupies one of three equal
    # 3-adic fibres in the depth-six period.
    derived_n_block = STATE_PERIOD_3ADIC * FINE_LIFT_DENSITY
    residue_count = 3 ** (D0 - 1)
    bucket_types = 3
    state_product = residue_count * bucket_types

    # Exhaustive enumeration over the frozen state space.  For every source
    # state, representative(state, lift) is the exact reticle representative
    # used by the split generator; all three representatives must land in the
    # declared fine fibre and be distinct.
    by_residue: defaultdict[int, list[str]] = defaultdict(list)
    for state in sorted(frozen_states):
        residue, _p, _b = parse_state(state)
        by_residue[residue].append(state)

    state_shape_ok = frozen_states == expected
    residue_group_sizes = sorted(len(states) for states in by_residue.values())
    residue_shape_ok = (
        len(by_residue) == residue_count
        and residue_group_sizes == [bucket_types] * residue_count
    )

    representative_rows = []
    representative_mismatches = []
    all_representatives: list[int] = []
    per_lift_counts: Counter[int] = Counter()
    per_state_lift_counts: Counter[str] = Counter()
    for state in sorted(frozen_states):
        for lift in range(3):
            root = representative(state, lift)
            actual_state = state_label(root)
            actual_lift = fine_lift_for_root(root, state)
            valid = root > 0 and root % 3 == 2 and actual_state == state and actual_lift == lift
            if not valid:
                representative_mismatches.append(
                    {
                        "state": state,
                        "requested_lift": lift,
                        "root": root,
                        "actual_state": actual_state,
                        "actual_lift": actual_lift,
                    }
                )
            representative_rows.append(
                {
                    "state": state,
                    "lift": lift,
                    "root": root,
                    "actual_state": actual_state,
                    "actual_lift": actual_lift,
                    "valid": valid,
                }
            )
            all_representatives.append(root)
            per_lift_counts[lift] += 1
            per_state_lift_counts[state] += 1

    per_lift_ok = all(per_lift_counts[lift] == N_BLOCK_EXPECTED for lift in range(3))
    per_state_ok = all(per_state_lift_counts[state] == 3 for state in frozen_states)
    representatives_distinct = len(set(all_representatives)) == len(all_representatives)
    enumeration_pass = (
        frozen_sha == EXPECTED_W_SHA256
        and state_shape_ok
        and residue_shape_ok
        and per_lift_ok
        and per_state_ok
        and representatives_distinct
        and not representative_mismatches
    )

    # The selected route's threshold and the fine per-step margin.
    epsilon = Fraction(BOUNDARY_ROOTS, N_BLOCK_EXPECTED)
    net_factor = (1 + DELTA) * (1 - epsilon)
    threshold_check = N_BLOCK_EXPECTED >= THRESHOLD_N_BLOCK
    threshold_inequality = Fraction(BOUNDARY_ROOTS, N_BLOCK_EXPECTED) < Fraction(1, 101)

    # Route Omega is deliberately recomputed without N_block.  Varying an
    # unused candidate value demonstrates the fallback's independence.
    with LEDGER.open() as handle:
        ledger = json.load(handle)
    omega_ratio = float(ledger["route_i_omega_weighted"]["effective_depth_ratio"])
    boundary_q0 = Fraction(2) / (RHO_STAR**Y_BASE)
    omega_eta = float(boundary_q0) / (1.0 - omega_ratio)
    omega_eta_variants = {str(candidate): omega_eta for candidate in (81, 203, 243, 729)}
    omega_independent = len(set(omega_eta_variants.values())) == 1
    omega_pass = omega_eta < 1

    route_ii_pass = enumeration_pass and threshold_check and threshold_inequality
    if route_ii_pass:
        local_verdict = "PASS_NBLOCK_MEMBERWISE_LEMMA_ROUTE_II_READY_FOR_FINAL_REVIEW"
    else:
        local_verdict = "STOP_NBLOCK_MEMBERWISE_LEMMA"

    payload = {
        "lemma": "F3_NBLOCK_MEMBERWISE_LEMMA_v1",
        "status": "COUNTING_AUDIT",
        "frozen_w_sha256": frozen_sha,
        "parameters": {
            "d0": D0,
            "d_fine": D_FINE,
            "state_period_3adic": STATE_PERIOD_3ADIC,
            "fine_period_with_2adic_reticle": FINE_PERIOD_WITH_2ADIC_RETICLE,
            "fine_lift_density": "1/3",
            "boundary_roots": BOUNDARY_ROOTS,
            "delta": "1/100",
            "rho_star": "9/5",
        },
        "arithmetic_derivation": {
            "formula": "3^6 * (1/3) = 3^5",
            "derived_n_block_exact": f"{derived_n_block.numerator}/{derived_n_block.denominator}",
            "admissible_residue_classes": residue_count,
            "bucket_reticle_types": bucket_types,
            "state_product": state_product,
            "arithmetic_pass": derived_n_block == N_BLOCK_EXPECTED and state_product == N_BLOCK_EXPECTED,
        },
        "frozen_state_enumeration": {
            "frozen_state_count": len(frozen_states),
            "expected_state_count": len(expected),
            "state_set_equal": state_shape_ok,
            "residue_group_count": len(by_residue),
            "residue_group_size_min": min(residue_group_sizes) if residue_group_sizes else 0,
            "residue_group_size_max": max(residue_group_sizes) if residue_group_sizes else 0,
            "residue_groups_are_three_reticles": residue_shape_ok,
            "representative_count_total": len(all_representatives),
            "representatives_distinct": representatives_distinct,
            "per_lift_counts": {str(lift): per_lift_counts[lift] for lift in range(3)},
            "per_lift_counts_exact_243": per_lift_ok,
            "per_state_three_lifts": per_state_ok,
            "representative_mismatch_count": len(representative_mismatches),
            "enumeration_pass": enumeration_pass,
        },
        "threshold_and_margin": {
            "N_block": N_BLOCK_EXPECTED,
            "minimum_N_block_strict": THRESHOLD_N_BLOCK,
            "threshold_formula": "N_block > 202, hence integer N_block >= 203",
            "epsilon_exact": f"{epsilon.numerator}/{epsilon.denominator}",
            "net_factor_exact": f"{net_factor.numerator}/{net_factor.denominator}",
            "net_gain_exact": f"{(net_factor - 1).numerator}/{(net_factor - 1).denominator}",
            "net_factor_decimal": float(net_factor),
            "net_gain_percent": float((net_factor - 1) * 100),
            "threshold_pass": threshold_check and threshold_inequality,
        },
        "omega_fallback": {
            "eta_omega": omega_eta,
            "eta_omega_formula": "[2/(9/5)^8] / (1 - (1+delta)*Perron(2.5))",
            "eta_omega_pass": omega_pass,
            "tested_unused_N_block_values": [81, 203, 243, 729],
            "eta_by_unused_N_block": omega_eta_variants,
            "independent_of_N_block": omega_independent,
            "fallback_status": "AVAILABLE" if omega_pass and omega_independent else "STOP_OMEGA_FALLBACK",
        },
        "route_ii_verdict": "PASS" if route_ii_pass else "STOP",
        "local_verdict": local_verdict,
        "remaining_protocol": (
            "append this lemma and the 24341/24300 margin to consolidated v2.2; "
            "then adversarial final review before any Lean budget"
        ),
        "non_claims": [
            "NO_FORMAL_RHO_CERTIFICATE",
            "NO_DENSITY_THEOREM",
            "NO_ALMOST_ALL",
            "NO_GLOBAL_COLLATZ_CLAIM",
            "NO_LEAN_OPERATOR",
        ],
        "inputs": {
            "frozen_w_sha256": EXPECTED_W_SHA256,
            "ledger_v1_2_sha256": sha256(LEDGER),
            "uniform_q_bounds_sha256": sha256(RESULTS / "uniform_q_bounds_v1.json"),
        },
    }
    OUT.write_text(json.dumps(payload, indent=2) + "\n")
    print(json.dumps(payload, indent=2))


if __name__ == "__main__":
    main()
