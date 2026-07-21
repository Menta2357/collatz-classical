#!/usr/bin/env python3
"""Combine the declared Q decay lines and K recheck for Lemma B.

The ledger is expressed in the declared rho_star-normalized row units.  The
script keeps the denominator visible: each q-line is divided by rho_star^y,
and the final base coefficient is C_I*w_min.  It is a paper-ledger audit, not
a formal theorem about the underlying real operator.
"""

from __future__ import annotations

import csv
import hashlib
import json
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RESULTS = ROOT / "results" / "F3_RETURN_EXCURSION_SPLIT_EDGE_v1"
OUT = RESULTS / "combined_ledger_v1.json"
RHO = Fraction(9, 5)
Y_BASE = 8
K_UPPER = Fraction(559, 100000)
KAPPA_STERILE = Fraction(3, 2)
KAPPA_BOUNDARY = Fraction(9, 5)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    with (RESULTS / "frozen_w_split_core.csv").open(newline="") as handle:
        frozen = list(csv.DictReader(handle))
    with (RESULTS / "tilted_supersolution_v1.csv").open(newline="") as handle:
        vector = {int(row["state_id"]): row for row in csv.DictReader(handle)}
    weights = {int(row["state_id"]): Fraction(row["rational_weight_decimal"]) for row in frozen}

    k_failures = []
    k_ratios = []
    for state_id, weight in weights.items():
        row = vector[state_id]
        v = Fraction(int(row["v_integer"]), int(row["v_denominator"]))
        ratio = weight / v
        k_ratios.append((ratio, state_id))
        if weight > K_UPPER * v:
            k_failures.append(state_id)
    k_exact_max, k_argmax = max(k_ratios)

    root_count_min = 10
    w_min = min(weights.values())
    base_coefficient = Fraction(root_count_min) * w_min

    # The q-lines use the explicitly declared rho_star^y denominator.
    sterile_q0 = Fraction(Y_BASE + 1) / (RHO**Y_BASE)
    boundary_q0 = Fraction(2) / (RHO**Y_BASE)
    sterile_eta = sterile_q0 / (1 - 1 / KAPPA_STERILE)
    boundary_eta = boundary_q0 / (1 - 1 / KAPPA_BOUNDARY)
    phase_eta = Fraction(0)
    eta = sterile_eta + boundary_eta + phase_eta
    final_coefficient = (1 - eta) * base_coefficient

    payload = {
        "ledger": "F3_COMBINED_LEDGER_v1",
        "rho_star": "9/5",
        "y_base": Y_BASE,
        "denominator_definition": "q_norm_line(y) = Q_line(y) / rho_star^y; final base coefficient = C_I*w_min",
        "C_I_root_count": root_count_min,
        "w_min": f"{w_min.numerator}/{w_min.denominator}",
        "base_coefficient_CI_wmin": float(base_coefficient),
        "K_upper": f"{K_UPPER.numerator}/{K_UPPER.denominator}",
        "K_exact_max_decimal": float(k_exact_max),
        "K_argmax_state_id": k_argmax,
        "K_reverify_bad_count": len(k_failures),
        "sterile": {
            "q0_at_y_base": float(sterile_q0),
            "kappa": "3/2",
            "decay_proof": "(y+2)/(y+1)/rho_star <= 25/27 < 1 for y>=8",
            "eta_line": float(sterile_eta),
        },
        "boundary": {
            "q0_at_y_base": float(boundary_q0),
            "kappa": "9/5",
            "decay_proof": "boundary_roots<=2 per state and denominator grows as rho_star^y",
            "eta_line": float(boundary_eta),
        },
        "phase": {"eta_line": 0.0, "reason": "exact PHASE_B identity"},
        "eta_sterile": float(sterile_eta),
        "eta_boundary": float(boundary_eta),
        "eta_total": float(eta),
        "eta_exact_num": eta.numerator,
        "eta_exact_den": eta.denominator,
        "eta_pass": eta < 1,
        "final_coefficient": float(final_coefficient),
        "final_bound_form": "V_y >= (1-eta)*C_I*w_min*rho_star^(y-y_base)",
        "local_verdict": "PASS_COMBINED_LEDGER" if eta < 1 and not k_failures else "STOP_COMBINED_LEDGER",
        "inputs": {
            "frozen_w_sha256": "580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40",
            "base_table_sha256": sha256(RESULTS / "base_segment_table_v1.csv"),
            "q_bounds_sha256": sha256(RESULTS / "uniform_q_bounds_v1.json"),
            "supersolution_vector_sha256": sha256(RESULTS / "tilted_supersolution_v1.csv"),
        },
        "status": "PAPER_LEDGER_AUDIT",
        "non_claims": ["NO_FORMAL_RHO_CERTIFICATE", "NO_DENSITY_THEOREM", "NO_LEAN_OPERATOR"],
    }
    OUT.write_text(json.dumps(payload, indent=2) + "\n")
    print(json.dumps(payload, indent=2))


if __name__ == "__main__":
    main()
