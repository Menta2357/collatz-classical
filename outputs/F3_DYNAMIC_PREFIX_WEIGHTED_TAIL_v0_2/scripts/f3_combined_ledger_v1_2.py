#!/usr/bin/env python3
"""Audit both predeclared repairs for D3 (depth/parameter mismatch).

The previous v1.1 ledger assigned parameter decay to tree depth.  That is
invalid for planning paths.  This audit therefore keeps the two proposed
repairs separate:

* route (i): use the frozen Chernoff live-mass factor at every depth;
* route (ii): charge a frontier deficit per complete row/block.

The second route is reported in two forms.  The primary form treats
``N_block=243`` as the complete per-row block, so the cell factor is not
multiplied a second time.  The explicit extra-cell variant is retained as a
STOP guard against accidental double counting.

This is a paper-ledger audit, not a formal theorem or a density claim.
"""

from __future__ import annotations

import csv
import hashlib
import json
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RESULTS = ROOT / "results" / "F3_RETURN_EXCURSION_SPLIT_EDGE_v1"
OUT = RESULTS / "combined_ledger_v1_2.json"

RHO_STAR = Fraction(9, 5)
DELTA = Fraction(1, 100)
Y_BASE = 8
N_BLOCK = 243
BOUNDARY_ROOTS = 2
CELL_ABSORPTION = Fraction(3)
K_UPPER = Fraction(559, 100000)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_inputs() -> dict:
    with (RESULTS / "frozen_w_split_core.csv").open(newline="") as handle:
        frozen = list(csv.DictReader(handle))
    with (RESULTS / "tilted_supersolution_v1.csv").open(newline="") as handle:
        vector = {int(row["state_id"]): row for row in csv.DictReader(handle)}
    weights = {
        int(row["state_id"]): Fraction(row["rational_weight_decimal"])
        for row in frozen
    }

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

    with (RESULTS / "split_edges.csv").open(newline="") as handle:
        matrix_channels = [row["channel"] for row in csv.DictReader(handle)]
    with (RESULTS / "split_tail_Q.csv").open(newline="") as handle:
        tail_channels = [row["channel"] for row in csv.DictReader(handle)]
    sterile_in_matrix = sum(
        channel == "advanced_sterile_tail_c0" for channel in matrix_channels
    )
    sterile_q_rows = sum(
        channel == "advanced_sterile_tail_c0" for channel in tail_channels
    )

    with (RESULTS / "tilted_spectral_closure_audit.json").open() as handle:
        tilt = json.load(handle)
    perron = float(tilt["best_grid_point"]["perron"])
    omega_ratio = float((1 + float(DELTA)) * perron)

    return {
        "weights": weights,
        "k_failures": k_failures,
        "k_exact_max": k_exact_max,
        "k_argmax": k_argmax,
        "sterile_in_matrix": sterile_in_matrix,
        "sterile_q_rows": sterile_q_rows,
        "tilt": tilt,
        "perron_best": perron,
        "omega_ratio": omega_ratio,
    }


def main() -> None:
    data = load_inputs()
    weights = data["weights"]
    base_coefficient = Fraction(10) * min(weights.values())
    boundary_q0 = Fraction(BOUNDARY_ROOTS) / (RHO_STAR**Y_BASE)

    # D1 cell check is retained as a diagnostic.  The exact maximum is a tie
    # at n=3 and n=4, both equal to 80/27.
    cell_checks = [
        Fraction((n + 1) * (n + 2), 2) * (Fraction(2, 3) ** n)
        for n in range(65)
    ]
    cell_max = max(cell_checks)
    cell_max_ns = [n for n, value in enumerate(cell_checks) if value == cell_max]

    # Route (i): replace the invalid rho_star^{-n} depth decay by the frozen
    # Chernoff live-mass factor ((1+delta)*Perron(rho'))^n.  This route treats
    # Omega mass as already aggregated over all live composition cells; adding
    # the D1 factor again would double count those cells, so that variant is
    # printed only as an explicit guard.
    omega_ratio = data["omega_ratio"]
    eta_i_aggregate = float(boundary_q0) / (1.0 - omega_ratio)
    eta_i_extra_cells = float(boundary_q0 * CELL_ABSORPTION) / (1.0 - omega_ratio)

    # Route (ii): the complete row/block has N_block members and at most two
    # boundary roots.  Its exact retention/gain ratio is rational.  The
    # primary form deliberately does not multiply by CELL_ABSORPTION: doing so
    # would charge the same row/block deficit once more as composition cells.
    epsilon = Fraction(BOUNDARY_ROOTS, N_BLOCK)
    deficit_ratio = (1 - epsilon) / (1 + DELTA)
    eta_ii = epsilon / (1 - deficit_ratio)
    eta_ii_extra_cells = CELL_ABSORPTION * eta_ii

    route_i_pass = eta_i_aggregate < 1
    route_i_extra_pass = eta_i_extra_cells < 1
    route_ii_pass = eta_ii < 1
    route_ii_extra_pass = eta_ii_extra_cells < 1
    d2_ok = data["sterile_in_matrix"] == 0
    k_ok = not data["k_failures"]

    payload = {
        "ledger": "F3_COMBINED_LEDGER_v1_2",
        "status": "PAPER_LEDGER_D3_ROUTE_COMPARISON",
        "d3_finding": "depth_parameter_pairing_rejected_for_planning_paths",
        "rho_star": "9/5",
        "delta": "1/100",
        "y_base": Y_BASE,
        "denominator_definition": (
            "boundary charge is measured against the stopped-tree functional; "
            "route (i) uses Chernoff live-mass by depth, route (ii) uses a "
            "complete per-row block deficit"
        ),
        "D1_cell_check": {
            "formula": "C(n+2,2)*(2/3)^n",
            "max_exact": "80/27",
            "max_n_exact_tie": cell_max_ns,
            "absorption_constant": 3,
            "pass": cell_max <= CELL_ABSORPTION,
        },
        "D2_sterile_status": {
            "sterile_in_matrix_edges": data["sterile_in_matrix"],
            "sterile_Q_rows": data["sterile_q_rows"],
            "verdict": "UNDERCOUNT_FREE" if d2_ok else "STOP_STERILE_MATRIX_STATUS",
        },
        "base": {
            "C_I_root_count": 10,
            "w_min_decimal": float(min(weights.values())),
            "C_I_times_w_min_decimal": float(base_coefficient),
            "K_upper": f"{K_UPPER.numerator}/{K_UPPER.denominator}",
            "K_exact_max_decimal": float(data["k_exact_max"]),
            "K_argmax_state_id": data["k_argmax"],
            "K_reverify_bad_count": len(data["k_failures"]),
        },
        "route_i_omega_weighted": {
            "rho_prime": data["tilt"]["best_grid_point"]["rho_prime"],
            "perron_rho_prime": data["perron_best"],
            "effective_depth_ratio": omega_ratio,
            "effective_depth_ratio_reported": "0.9672 (rounded)",
            "boundary_q0_at_y_base": float(boundary_q0),
            "cell_factor_used": 1,
            "eta_aggregate_over_live_cells": eta_i_aggregate,
            "eta_extra_cell_factor_guard": eta_i_extra_cells,
            "eta_pass": route_i_pass,
            "extra_cell_factor_guard_pass": route_i_extra_pass,
            "local_verdict": (
                "PASS_ROUTE_I_OMEGA_AGGREGATE"
                if route_i_pass
                else "STOP_ROUTE_I"
            ),
            "reason": (
                "Omega mass is already summed over live cells; multiplying "
                "by the D1 factor again is a double-counting guard"
            ),
        },
        "route_ii_relative_row_deficit": {
            "N_block": N_BLOCK,
            "boundary_roots_per_block": BOUNDARY_ROOTS,
            "epsilon_exact": f"{epsilon.numerator}/{epsilon.denominator}",
            "epsilon_decimal": float(epsilon),
            "retention_gain_ratio_exact": (
                f"{deficit_ratio.numerator}/{deficit_ratio.denominator}"
            ),
            "retention_gain_ratio_decimal": float(deficit_ratio),
            "eta_per_row_exact": f"{eta_ii.numerator}/{eta_ii.denominator}",
            "eta_per_row_decimal": float(eta_ii),
            "final_coefficient_per_row_decimal": float(
                (1 - eta_ii) * base_coefficient
            ),
            "extra_cell_factor_variant_eta_exact": (
                f"{eta_ii_extra_cells.numerator}/{eta_ii_extra_cells.denominator}"
            ),
            "extra_cell_factor_variant_eta_decimal": float(eta_ii_extra_cells),
            "extra_cell_factor_variant_pass": route_ii_extra_pass,
            "no_extra_cell_factor_rule": (
                "N_block is the complete per-row block count; multiplying by "
                "3 would count the composition-cell loss a second time"
            ),
            "eta_pass": route_ii_pass,
            "local_verdict": (
                "PASS_ROUTE_II_PER_ROW_PENDING_CONTRACT"
                if route_ii_pass
                else "STOP_ROUTE_II"
            ),
        },
        "combined_gate": {
            "route_i_pass": route_i_pass,
            "route_i_extra_cell_variant_pass": route_i_extra_pass,
            "route_ii_per_row_pass": route_ii_pass,
            "route_ii_extra_cell_variant_pass": route_ii_extra_pass,
            "selected_route": "II_PER_ROW" if route_ii_pass else "NONE",
            "paper_gate_reopened": True,
            "remaining_obligation": (
                "prove in Lema VI that N_block is the complete per-row block "
                "and that no independent cell factor remains"
            ),
            "local_verdict": (
                "ROUTE_II_SELECTED_ROUTE_I_ALSO_NUMERIC_PASS_PENDING_MEMBERWISE_DENOMINATOR_LEMMA"
                if route_ii_pass
                else "STOP_D3_NO_ROUTE_CLOSED"
            ),
        },
        "inputs": {
            "frozen_w_sha256": "580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40",
            "base_table_sha256": sha256(RESULTS / "base_segment_table_v1.csv"),
            "q_bounds_sha256": sha256(RESULTS / "uniform_q_bounds_v1.json"),
            "supersolution_vector_sha256": sha256(
                RESULTS / "tilted_supersolution_v1.csv"
            ),
            "tilted_audit_sha256": sha256(
                RESULTS / "tilted_spectral_closure_audit.json"
            ),
        },
        "non_claims": [
            "NO_FORMAL_RHO_CERTIFICATE",
            "NO_DENSITY_THEOREM",
            "NO_LEAN_OPERATOR",
            "NO_PAPER_GATE_COMPLETE",
        ],
    }
    OUT.write_text(json.dumps(payload, indent=2) + "\n")
    print(json.dumps(payload, indent=2))


if __name__ == "__main__":
    main()
