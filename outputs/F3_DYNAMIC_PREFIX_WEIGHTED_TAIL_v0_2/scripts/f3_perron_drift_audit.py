#!/usr/bin/env python3
"""Audit the Perron/Doob drift of the frozen split-edge core.

The matrix is read from the published split-edge rows and the frozen rational
left weight vector.  Sterile c=0 rows are excluded because they are Q rows.
The result is a numerical audit of the frozen finite object, not a theorem.
"""

from __future__ import annotations

import csv
import json
import math
from pathlib import Path

import numpy as np


ROOT = Path(__file__).resolve().parents[1]
RESULTS = ROOT / "results" / "F3_RETURN_EXCURSION_SPLIT_EDGE_v1"
OUT = RESULTS / "perron_drift_audit.json"
CHANNELS = {
    "retarded": -2.0,
    "advanced_direct_c2": math.log2(3.0) - 1.0,
    "advanced_parity_lift_c1": math.log2(3.0) - 2.0,
}


def main() -> None:
    state_ids: list[int] = []
    weights: dict[int, float] = {}
    frozen_rows: dict[int, dict[str, str]] = {}
    with (RESULTS / "frozen_w_split_core.csv").open(newline="") as handle:
        for row in csv.DictReader(handle):
            state_id = int(row["state_id"])
            state_ids.append(state_id)
            weights[state_id] = float(row["rational_weight_decimal"])
            frozen_rows[state_id] = row

    index = {state_id: i for i, state_id in enumerate(state_ids)}
    n = len(state_ids)
    weighted_matrix = np.zeros((n, n), dtype=float)
    weighted_shift = np.zeros((n, n), dtype=float)
    channel_mass = {channel: np.zeros(n, dtype=float) for channel in CHANNELS}

    with (RESULTS / "split_edges.csv").open(newline="") as handle:
        for row in csv.DictReader(handle):
            channel = row["channel"]
            if channel not in CHANNELS:
                continue  # sterile c=0 is Q, not a core transition
            source = int(row["source_id"])
            target = int(row["target_id"])
            if source not in index or target not in index:
                continue
            contribution = float(row["weight_decimal"]) * weights[target]
            i, j = index[source], index[target]
            weighted_matrix[i, j] += contribution
            weighted_shift[i, j] += contribution * CHANNELS[channel]
            channel_mass[channel][i] += contribution

    row_denominator = weighted_matrix.sum(axis=1)
    if np.any(row_denominator <= 0):
        raise RuntimeError("nonpositive Doob denominator in frozen core")
    q = weighted_matrix / row_denominator[:, None]

    # The core is finite and communicating; power iteration gives the unique
    # stationary distribution of the row-stochastic Doob chain.
    stationary = np.full(n, 1.0 / n)
    for _ in range(10000):
        updated = stationary @ q
        if float(np.max(np.abs(updated - stationary))) < 1e-16:
            stationary = updated
            break
        stationary = updated
    else:
        raise RuntimeError("stationary distribution did not converge")

    local_drift = weighted_shift.sum(axis=1) / row_denominator
    mu = float(stationary @ local_drift)
    stationary_residual = float(np.max(np.abs(stationary @ q - stationary)))
    channel_shares = {
        channel: float(np.sum(stationary * channel_mass[channel] / row_denominator))
        for channel in CHANNELS
    }

    # One-step uniform drift is not available if even one row has nonnegative
    # local drift.  Search the predeclared finite block horizons for the first
    # T whose expected cumulative drift is negative from every starting state.
    cumulative = np.zeros(n, dtype=float)
    transition_power = np.eye(n, dtype=float)
    uniform_T = None
    uniform_cumulative_max = None
    for T in range(1, 65):
        cumulative += transition_power @ local_drift
        if float(np.max(cumulative)) < 0:
            uniform_T = T
            uniform_cumulative_max = float(np.max(cumulative))
            break
        transition_power = transition_power @ q

    row_ratios = {
        state_id: float(frozen_rows[state_id]["lhs_wM_decimal"])
        / weights[state_id]
        for state_id in state_ids
    }
    r_max_state = max(row_ratios, key=row_ratios.get)
    r_max = row_ratios[r_max_state]
    if uniform_T is None:
        closure_lhs = None
        closure_rhs = None
        closure_pass = False
    else:
        block_drift_gap = -uniform_cumulative_max
        block_increment_bound = 2.0 * uniform_T
        closure_lhs = block_drift_gap**2 / (2.0 * block_increment_bound**2)
        closure_rhs = uniform_T * math.log(r_max)
        closure_pass = closure_lhs > closure_rhs

    channel_mu_terms = {
        channel: channel_shares[channel] * CHANNELS[channel]
        for channel in CHANNELS
    }
    payload = {
        "definition": "q(s,t)=M_split(s,t)*w_t / sum_u M_split(s,u)*w_u; mu=sum_s pi(s) sum_t q(s,t) h(channel)",
        "core_state_count": n,
        "step_alphabet": {
            "retarded": -2.0,
            "advanced_direct_c2": "log2(3)-1",
            "advanced_parity_lift_c1": "log2(3)-2",
        },
        "mu_decimal": mu,
        "channel_stationary_shares": channel_shares,
        "mu_channel_terms": channel_mu_terms,
        "mu_decomposition": "pi_R*(-2) + pi_D*(log2(3)-1) + pi_L*(log2(3)-2)",
        "local_drift_min": float(np.min(local_drift)),
        "local_drift_max": float(np.max(local_drift)),
        "local_drift_argmax_state_id": int(state_ids[int(np.argmax(local_drift))]),
        "stationary_residual": stationary_residual,
        "stationary_min": float(np.min(stationary)),
        "R_max": r_max,
        "R_max_argmax_state_id": int(r_max_state),
        "uniform_T_first_negative": uniform_T,
        "uniform_cumulative_drift_max": uniform_cumulative_max,
        "closure_definition": "block_drift_gap^2/(2*block_increment_bound^2) > T*log(R_max), with block_increment_bound=2T",
        "closure_lhs": closure_lhs,
        "closure_rhs": closure_rhs,
        "closure_pass": closure_pass,
        "frozen_w_sha256": "580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40",
        "stop_condition": "STOP_CLOSURE_GATE if uniform drift or Azuma closure fails",
        "local_verdict": "PASS_CLOSURE_GATE" if closure_pass else "STOP_CLOSURE_GATE",
        "status": "DIAGNOSTIC_INPUT_TO_LEMMA_B",
        "non_claims": ["NO_FORMAL_RHO_CERTIFICATE", "NO_DENSITY_THEOREM", "NO_LEAN_OPERATOR"],
    }
    OUT.write_text(json.dumps(payload, indent=2) + "\n")
    print(json.dumps(payload, indent=2))


if __name__ == "__main__":
    main()
