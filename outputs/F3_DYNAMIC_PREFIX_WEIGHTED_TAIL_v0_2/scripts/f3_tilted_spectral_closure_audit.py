#!/usr/bin/env python3
"""Audit the predeclared spectral tilt grid for the frozen split core.

The published edge weights are evaluated at rho_star=9/5.  For a channel with
shift h, the same rule-derived edge at rho' has weight
    weight(rho_star) * (rho'/rho_star)**h.
Sterile c=0 rows are Q and are not core transitions.
"""

from __future__ import annotations

import csv
import json
import math
from pathlib import Path

import numpy as np


ROOT = Path(__file__).resolve().parents[1]
RESULTS = ROOT / "results" / "F3_RETURN_EXCURSION_SPLIT_EDGE_v1"
OUT = RESULTS / "tilted_spectral_closure_audit.json"
RHO_STAR = 9.0 / 5.0
DELTA = 1.0 / 100.0
GRID = (1.9, 2.0, 2.05, 2.1, 2.2, 2.35, 2.5)
CHANNEL_SHIFTS = {
    "retarded": -2.0,
    "advanced_direct_c2": math.log2(3.0) - 1.0,
    "advanced_parity_lift_c1": math.log2(3.0) - 2.0,
}


def main() -> None:
    state_ids: list[int] = []
    weights: dict[int, float] = {}
    with (RESULTS / "frozen_w_split_core.csv").open(newline="") as handle:
        for row in csv.DictReader(handle):
            state_id = int(row["state_id"])
            state_ids.append(state_id)
            weights[state_id] = float(row["rational_weight_decimal"])
    index = {state_id: i for i, state_id in enumerate(state_ids)}

    edges: list[tuple[int, int, float, float]] = []
    with (RESULTS / "split_edges.csv").open(newline="") as handle:
        for row in csv.DictReader(handle):
            channel = row["channel"]
            if channel not in CHANNEL_SHIFTS:
                continue
            source = int(row["source_id"])
            target = int(row["target_id"])
            if source not in index or target not in index:
                continue
            edges.append(
                (
                    index[source],
                    index[target],
                    float(row["weight_decimal"]),
                    CHANNEL_SHIFTS[channel],
                )
            )

    def matrix_at(rho: float) -> np.ndarray:
        matrix = np.zeros((len(state_ids), len(state_ids)), dtype=float)
        for source, target, frozen_weight, shift in edges:
            matrix[source, target] += frozen_weight * (rho / RHO_STAR) ** shift
        return matrix

    def perron(matrix: np.ndarray) -> float:
        return float(np.max(np.abs(np.linalg.eigvals(matrix))))

    rho_star_reconstruction = perron(matrix_at(RHO_STAR))
    rows = []
    for rho in GRID:
        value = perron(matrix_at(rho))
        rows.append(
            {
                "rho_prime": rho,
                "theta": math.log(rho / RHO_STAR),
                "perron": value,
                "gamma": 1.0 - value,
                "below_one": value < 1.0,
            }
        )
    best = min(rows, key=lambda row: float(row["perron"]))
    effective_survival_factor = (1.0 + DELTA) * float(best["perron"])
    effective_gamma = 1.0 - effective_survival_factor
    c_vector_min = min(weights.values())
    payload = {
        "definition": "M(rho') edge = M(rho_star) edge * (rho'/rho_star)^h",
        "rho_star": RHO_STAR,
        "delta": DELTA,
        "rho_grid": list(GRID),
        "step_alphabet": CHANNEL_SHIFTS,
        "core_state_count": len(state_ids),
        "edge_count_core": len(edges),
        "rho_star_reconstruction_perron": rho_star_reconstruction,
        "curve": rows,
        "best_grid_point": best,
        "theta_best": best["theta"],
        "gamma_best": best["gamma"],
        "effective_survival_factor_best": effective_survival_factor,
        "effective_gamma_best": effective_gamma,
        "C_vector_min": c_vector_min,
        "C_status": "vector-minimum proxy; base constant C is not yet proved",
        "frozen_w_sha256": "580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40",
        "pass_condition": "(1+delta)*min_grid_perron < 1",
        "spectral_valley_pass": float(best["perron"]) < 1.0,
        "growth_adjusted_pass": effective_survival_factor < 1.0,
        "local_verdict": "PASS_TILT_VALLEY_GROWTH_ADJUSTED" if effective_survival_factor < 1.0 else "STOP_TILT_GATE",
        "status": "DIAGNOSTIC_INPUT_TO_LEMMA_B",
        "non_claims": ["NO_FORMAL_RHO_CERTIFICATE", "NO_DENSITY_THEOREM", "NO_LEAN_OPERATOR"],
    }
    OUT.write_text(json.dumps(payload, indent=2) + "\n")
    print(json.dumps(payload, indent=2))


if __name__ == "__main__":
    main()
