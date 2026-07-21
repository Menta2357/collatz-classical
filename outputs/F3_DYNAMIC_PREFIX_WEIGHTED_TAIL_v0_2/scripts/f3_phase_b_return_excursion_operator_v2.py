#!/usr/bin/env python3
"""F3 PHASE_B return-excursion operator v2.

Diagnostic only.  This script adds the row22-style parity-lift channel missing
from v1 and charges c == 0 mod 3 advanced children to row-wise Q.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import math
from collections import defaultdict
from fractions import Fraction
from pathlib import Path
from typing import Any


D0_DEFAULT = 5
RHO_STAR = Fraction(9, 5)
LAMBDA_11_OFFICIAL = Fraction(71689, 40000)
DEFAULT_OUTPUT_DIR = (
    Path(__file__).resolve().parents[1]
    / "results/F3_PHASE_B_RETURN_EXCURSION_OPERATOR_v2"
)


def parity_value(n: int) -> str:
    return "odd" if n % 2 else "even"


def nu2_bucket(n: int) -> int:
    if n % 2:
        return 0
    if n % 4:
        return 1
    return 2


def states_at_depth(d: int) -> list[tuple[int, int, str, int]]:
    return [
        (d, r, "odd" if b == 0 else "even", b)
        for r in range(3**d)
        for b in (0, 1, 2)
    ]


def state_label(state: tuple[int, int, str, int]) -> str:
    d, r, p, b = state
    return f"d{d}:r{r}:p{p}:b{b}"


def representative(state: tuple[int, int, str, int], lift: int = 0) -> int:
    d, r, p, b = state
    modulus = 3**d
    n = r + lift * modulus
    step = 3 * modulus
    while n <= 0 or parity_value(n) != p or nu2_bucket(n) != b:
        n += step
    return n


def retarded_state(state: tuple[int, int, str, int]) -> tuple[int, int, str, int]:
    d, r, _p, _b = state
    return (d, (4 * r) % (3**d), "even", 2)


def target_state_from_value(d0: int, n: int) -> tuple[int, int, str, int]:
    return (d0, n % (3**d0), parity_value(n), nu2_bucket(n))


def power_iteration(
    state_count: int,
    edges: list[tuple[int, int, float]],
    iterations: int = 300,
) -> dict[str, float]:
    vector = [1.0 / state_count] * state_count
    estimate = 0.0
    for _ in range(iterations):
        nxt = [0.0] * state_count
        for source, target, weight in edges:
            nxt[target] += weight * vector[source]
        total = sum(nxt)
        if total == 0.0:
            return {"estimate": 0.0, "min_ratio": 0.0, "max_ratio": 0.0}
        estimate = total / sum(vector)
        vector = [value / total for value in nxt]
    nxt = [0.0] * state_count
    for source, target, weight in edges:
        nxt[target] += weight * vector[source]
    ratios = [
        nxt[index] / vector[index]
        for index in range(state_count)
        if vector[index] > 1e-18
    ]
    return {
        "estimate": estimate,
        "min_ratio": min(ratios),
        "max_ratio": max(ratios),
    }


def write_csv(path: Path, rows: list[dict[str, Any]], fields: list[str]) -> None:
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def file_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--d0", type=int, default=D0_DEFAULT)
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    d0 = args.d0
    output_dir: Path = args.output_dir
    output_dir.mkdir(parents=True, exist_ok=True)

    states = states_at_depth(d0)
    state_index = {state: index for index, state in enumerate(states)}
    alpha = math.log(3, 2)
    rho = float(RHO_STAR)
    lambda_11 = float(LAMBDA_11_OFFICIAL)

    retarded_weight = float(Fraction(RHO_STAR.denominator**2, RHO_STAR.numerator**2))
    advanced_base_weight = rho ** (alpha - 1.0)
    direct_source_weight = advanced_base_weight
    parity_lift_source_weight = advanced_base_weight * (1.0 / rho)
    sterile_tail_source_weight = advanced_base_weight
    scalar_direct_contribution = direct_source_weight / 3.0
    scalar_parity_lift_contribution = parity_lift_source_weight / 3.0
    scalar_F_sector_rho = (
        retarded_weight + scalar_direct_contribution + scalar_parity_lift_contribution
    )
    scalar_F_sector_lambda = (
        lambda_11 ** (-2.0)
        + (lambda_11 ** (alpha - 1.0)) / 3.0
        + (lambda_11 ** (alpha - 1.0)) * (lambda_11 ** (-1.0)) / 3.0
    )

    edge_rows: list[dict[str, Any]] = []
    tail_rows: list[dict[str, Any]] = []
    matrix_edges: list[tuple[int, int, float]] = []
    outgoing: defaultdict[int, float] = defaultdict(float)
    tail_by_source: defaultdict[int, float] = defaultdict(float)
    channel_counts: defaultdict[str, int] = defaultdict(int)

    for source in states:
        source_id = state_index[source]
        r_target = retarded_state(source)
        r_target_id = state_index[r_target]
        outgoing[source_id] += retarded_weight
        matrix_edges.append((source_id, r_target_id, retarded_weight))
        channel_counts["retarded"] += 1
        edge_rows.append(
            {
                "source_id": source_id,
                "source": state_label(source),
                "channel": "retarded",
                "child_mod3": "",
                "target_id": r_target_id,
                "target": state_label(r_target),
                "weight_decimal": f"{retarded_weight:.15f}",
                "weight_formula": "rho_star^(-2)",
                "memberwise_precedent": "retarded core",
            }
        )

        if source[1] % 3 != 2:
            continue

        a = representative(source, 0)
        c = (2 * a - 1) // 3
        child_mod3 = c % 3
        if child_mod3 == 2:
            target = target_state_from_value(d0, c)
            target_id = state_index[target]
            outgoing[source_id] += direct_source_weight
            matrix_edges.append((source_id, target_id, direct_source_weight))
            channel_counts["advanced_direct_c2"] += 1
            edge_rows.append(
                {
                    "source_id": source_id,
                    "source": state_label(source),
                    "channel": "advanced_direct_c2",
                    "child_mod3": child_mod3,
                    "target_id": target_id,
                    "target": state_label(target),
                    "weight_decimal": f"{direct_source_weight:.15f}",
                    "weight_formula": "rho_star^(log_2(3)-1)",
                    "memberwise_precedent": "PHASE_B advanced identity",
                }
            )
        elif child_mod3 == 1:
            lifted = 2 * c
            target = target_state_from_value(d0, lifted)
            target_id = state_index[target]
            outgoing[source_id] += parity_lift_source_weight
            matrix_edges.append((source_id, target_id, parity_lift_source_weight))
            channel_counts["advanced_parity_lift_c1"] += 1
            edge_rows.append(
                {
                    "source_id": source_id,
                    "source": state_label(source),
                    "channel": "advanced_parity_lift_c1",
                    "child_mod3": child_mod3,
                    "target_id": target_id,
                    "target": state_label(target),
                    "weight_decimal": f"{parity_lift_source_weight:.15f}",
                    "weight_formula": "rho_star^(log_2(3)-1)*rho_star^(-1)",
                    "memberwise_precedent": "row22 parity lift",
                }
            )
        else:
            tail_by_source[source_id] += sterile_tail_source_weight
            channel_counts["advanced_sterile_tail_c0"] += 1
            tail_rows.append(
                {
                    "source_id": source_id,
                    "source": state_label(source),
                    "channel": "advanced_sterile_tail_c0",
                    "child_mod3": child_mod3,
                    "tail_weight_decimal": f"{sterile_tail_source_weight:.15f}",
                    "tail_formula": "rho_star^(log_2(3)-1)",
                    "tail_name": "Q",
                }
            )

    power = power_iteration(len(states), matrix_edges)
    outgoing_values = [outgoing[index] for index in range(len(states))]
    tail_values = [tail_by_source[index] for index in range(len(states))]
    summary = {
        "d0": d0,
        "state_count": len(states),
        "edge_count": len(edge_rows),
        "tail_row_count": len(tail_rows),
        "rho_star": "9/5",
        "lambda_11_official": "71689/40000",
        "retarded_weight_decimal": retarded_weight,
        "advanced_base_weight_formula": "rho_star^(log_2(3)-1)",
        "advanced_base_weight_decimal": advanced_base_weight,
        "direct_source_weight_decimal": direct_source_weight,
        "parity_lift_source_weight_decimal": parity_lift_source_weight,
        "sterile_tail_source_weight_decimal": sterile_tail_source_weight,
        "scalar_direct_contribution_decimal": scalar_direct_contribution,
        "scalar_parity_lift_contribution_decimal": scalar_parity_lift_contribution,
        "scalar_F_sector_rho_star": scalar_F_sector_rho,
        "scalar_F_sector_lambda_11": scalar_F_sector_lambda,
        "scalar_margin_rho_star": scalar_F_sector_rho - 1.0,
        "channel_counts": dict(sorted(channel_counts.items())),
        "min_outgoing_weight_excluding_tail": min(outgoing_values),
        "max_outgoing_weight_excluding_tail": max(outgoing_values),
        "max_tail_weight_per_source": max(tail_values),
        "total_tail_weight": sum(tail_values),
        "power_iteration_estimate": power["estimate"],
        "collatz_wielandt_min_ratio": power["min_ratio"],
        "collatz_wielandt_max_ratio": power["max_ratio"],
        "inventory_status": "RETURN_EXCURSION_V2_BUILT_DIAGNOSTIC_ONLY",
        "local_verdict": "STOP_V2_MEMBERWISE_HOOKS_MISSING",
        "non_claims": {
            "no_lean_operator": True,
            "no_rho_certificate": True,
            "no_density_theorem": True,
            "no_almost_all": True,
            "no_global_collatz_claim": True,
        },
    }

    edges_path = output_dir / "return_excursion_edges.csv"
    tail_path = output_dir / "row_tail_Q.csv"
    summary_path = output_dir / "summary.json"
    manifest_path = output_dir / "manifest_sha256.csv"
    write_csv(
        edges_path,
        edge_rows,
        [
            "source_id",
            "source",
            "channel",
            "child_mod3",
            "target_id",
            "target",
            "weight_decimal",
            "weight_formula",
            "memberwise_precedent",
        ],
    )
    write_csv(
        tail_path,
        tail_rows,
        [
            "source_id",
            "source",
            "channel",
            "child_mod3",
            "tail_weight_decimal",
            "tail_formula",
            "tail_name",
        ],
    )
    summary_path.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    write_csv(
        manifest_path,
        [{"path": path.name, "sha256": file_sha256(path)} for path in (edges_path, tail_path, summary_path)],
        ["path", "sha256"],
    )
    print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
