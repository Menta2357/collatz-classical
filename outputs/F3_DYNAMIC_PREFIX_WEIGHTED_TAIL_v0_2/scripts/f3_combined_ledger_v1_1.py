#!/usr/bin/env python3
"""Recompute the combined ledger after the adversarial D1/D2 findings.

D2 is checked against the frozen files: sterile rows occur in split_tail_Q.csv
and zero sterile edges occur in split_edges.csv, so they are an undercount for
the core lower bound, not a deduction from its certified matrix inequality.
D1 is handled by multiplying the boundary line by the exact composition-cell
ceiling C(n+2,2), then absorbing that polynomial into a smaller kappa.
"""

from __future__ import annotations

import csv
import hashlib
import json
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RESULTS = ROOT / "results" / "F3_RETURN_EXCURSION_SPLIT_EDGE_v1"
OUT = RESULTS / "combined_ledger_v1_1.json"
RHO = Fraction(9, 5)
Y_BASE = 8
K_UPPER = Fraction(559, 100000)
KAPPA_CELL = Fraction(6, 5)


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

    # D2: the frozen core matrix has no sterile edge; sterile rows are stored in
    # the separate Q file and are therefore omitted undercount, not a loss.
    with (RESULTS / "split_edges.csv").open(newline="") as handle:
        matrix_channels = [row["channel"] for row in csv.DictReader(handle)]
    with (RESULTS / "split_tail_Q.csv").open(newline="") as handle:
        tail_channels = [row["channel"] for row in csv.DictReader(handle)]
    sterile_in_matrix = sum(channel == "advanced_sterile_tail_c0" for channel in matrix_channels)
    sterile_q_rows = sum(channel == "advanced_sterile_tail_c0" for channel in tail_channels)

    # D1: exact composition ceiling and its conservative exponential absorption.
    cell_constant_checks = [
        Fraction((n + 1) * (n + 2), 2) * (KAPPA_CELL / RHO) ** n for n in range(65)
    ]
    cell_absorption_constant = Fraction(3)
    cell_absorption_pass = max(cell_constant_checks) <= cell_absorption_constant
    cell_max_n = max(range(65), key=lambda n: cell_constant_checks[n])

    root_count_min = 10
    w_min = min(weights.values())
    base_coefficient = Fraction(root_count_min) * w_min
    boundary_q0 = Fraction(2) / (RHO**Y_BASE)
    eta_boundary = boundary_q0 * cell_absorption_constant / (1 - 1 / KAPPA_CELL)
    eta_sterile = Fraction(0)
    eta_phase = Fraction(0)
    eta = eta_boundary
    final_coefficient = (1 - eta) * base_coefficient

    payload = {
        "ledger": "F3_COMBINED_LEDGER_v1_1",
        "rho_star": "9/5",
        "y_base": Y_BASE,
        "D1_cell_count": "C(n+2,2) exact composition ceiling for three shifts",
        "D1_kappa_cell": "6/5",
        "D1_absorption_constant": 3,
        "D1_absorption_max_n_checked": cell_max_n,
        "D1_absorption_max_value_checked": float(max(cell_constant_checks)),
        "D1_absorption_pass": cell_absorption_pass,
        "D2_sterile_in_matrix_edges": sterile_in_matrix,
        "D2_sterile_Q_rows": sterile_q_rows,
        "D2_status": "UNDERCOUNT_FREE" if sterile_in_matrix == 0 else "STOP_STERILE_MATRIX_STATUS",
        "denominator_definition": "boundary q_norm(y) = Q_boundary(y) / rho_star^y; cell multiplicity absorbed before summation",
        "C_I_root_count": root_count_min,
        "w_min": f"{w_min.numerator}/{w_min.denominator}",
        "base_coefficient_CI_wmin": float(base_coefficient),
        "K_upper": f"{K_UPPER.numerator}/{K_UPPER.denominator}",
        "K_exact_max_decimal": float(k_exact_max),
        "K_argmax_state_id": k_argmax,
        "K_reverify_bad_count": len(k_failures),
        "boundary_q0_at_y_base": float(boundary_q0),
        "eta_sterile": float(eta_sterile),
        "eta_boundary_cell_corrected": float(eta_boundary),
        "eta_phase": float(eta_phase),
        "eta_total": float(eta),
        "eta_exact_num": eta.numerator,
        "eta_exact_den": eta.denominator,
        "eta_pass": eta < 1 and cell_absorption_pass and not k_failures and sterile_in_matrix == 0,
        "final_coefficient": float(final_coefficient),
        "final_bound_form": "V_y >= (1-eta)*C_I*w_min*rho_star^(y-y_base)",
        "local_verdict": "PASS_COMBINED_LEDGER_D1_D2_REPAIRED" if eta < 1 and cell_absorption_pass and not k_failures and sterile_in_matrix == 0 else "STOP_COMBINED_LEDGER_D1_D2",
        "inputs": {
            "frozen_w_sha256": "580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40",
            "base_table_sha256": sha256(RESULTS / "base_segment_table_v1.csv"),
            "q_bounds_sha256": sha256(RESULTS / "uniform_q_bounds_v1.json"),
            "supersolution_vector_sha256": sha256(RESULTS / "tilted_supersolution_v1.csv"),
        },
        "status": "PAPER_LEDGER_D1_D2_REPAIR_AUDIT",
        "non_claims": ["NO_FORMAL_RHO_CERTIFICATE", "NO_DENSITY_THEOREM", "NO_LEAN_OPERATOR"],
    }
    OUT.write_text(json.dumps(payload, indent=2) + "\n")
    print(json.dumps(payload, indent=2))


if __name__ == "__main__":
    main()
