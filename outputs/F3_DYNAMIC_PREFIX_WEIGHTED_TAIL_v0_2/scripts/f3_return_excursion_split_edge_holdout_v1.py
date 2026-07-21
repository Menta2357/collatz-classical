#!/usr/bin/env python3
"""F3 return-excursion split-edge holdout v1.

Phase `calibration` measures the Q_boundary budget.  Phase `holdout` consumes
the fresh one-use holdout range using the frozen split-core vector.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import platform
import sys
import time
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any


BASE = Path(__file__).resolve().parents[1]
DEFAULT_OUTPUT_ROOT = BASE / "results/F3_RETURN_EXCURSION_SPLIT_EDGE_HOLDOUT_v1"
SPLIT_DIR = BASE / "results/F3_RETURN_EXCURSION_SPLIT_EDGE_v1"
EXPECTED_W_SHA256 = "580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40"
D0 = 5
D_FINE = 6
FINE_PERIOD = 4 * (3**D_FINE)
Y_VALUES = (8, 9, 10)
DELTA = 0.01
CALIBRATION_INTERVAL = (1, 10_369)
HOLDOUT_INTERVAL = (41_473, 82_945)
BURNED_RANGES = [(20_737, 41_473)]


def parity(n: int) -> str:
    return "odd" if n % 2 else "even"


def clipped_nu2(n: int) -> int:
    if n % 2:
        return 0
    if n % 4:
        return 1
    return 2


def type_label(n: int, depth: int = D0) -> str:
    return f"d{depth}:r{n % (3**depth)}:p{parity(n)}:b{clipped_nu2(n)}"


def fine_lift_for_root(a: int, source_label: str) -> int:
    r = int(source_label.split(":")[1][1:])
    return ((a % (3**D_FINE)) - r) // (3**D0) % 3


def file_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        return list(csv.DictReader(handle))


def write_csv(path: Path, rows: list[dict[str, Any]], fields: list[str]) -> None:
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def interval_for_phase(phase: str) -> tuple[int, int]:
    if phase == "calibration":
        return CALIBRATION_INTERVAL
    if phase == "holdout":
        return HOLDOUT_INTERVAL
    raise ValueError(phase)


def load_calibration_budget(output_root: Path) -> float:
    path = output_root / "calibration/summary.json"
    if not path.exists():
        raise SystemExit("calibration summary missing; run calibration before holdout")
    summary = json.loads(path.read_text())
    return float(summary["q_boundary_acceptance_budget"])


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--phase", choices=("calibration", "holdout"), required=True)
    parser.add_argument("--output-root", type=Path, default=DEFAULT_OUTPUT_ROOT)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    phase = args.phase
    output_dir = args.output_root / phase
    output_dir.mkdir(parents=True, exist_ok=True)
    started = time.perf_counter()

    frozen_path = SPLIT_DIR / "frozen_w_split_core.csv"
    frozen_sha = file_sha256(frozen_path)
    if frozen_sha != EXPECTED_W_SHA256:
        raise SystemExit(f"frozen split-core hash mismatch: {frozen_sha}")

    frozen_rows = read_csv(frozen_path)
    core_states = {row["state"] for row in frozen_rows}
    lhs_by_state = {row["state"]: float(row["lhs_wM_decimal"]) for row in frozen_rows}
    rhs_by_state = {row["state"]: float(row["rhs_1_plus_delta_w_decimal"]) for row in frozen_rows}
    frozen_ratio_min = min(float(row["ratio_lhs_over_rhs"]) for row in frozen_rows)

    split_edges = read_csv(SPLIT_DIR / "split_edges.csv")
    split_edge_keys = {
        (row["source"], int(row["deep_lift"]), row["channel"], row["target"])
        for row in split_edges
        if row["deep_lift"] != "" and row["source"] in core_states
    }

    lower, upper = interval_for_phase(phase)
    roots = [a for a in range(lower, upper) if a > 2 and a % 3 == 2]
    counts: dict[str, Counter[int]] = defaultdict(Counter)
    channel_counts: Counter[str] = Counter()
    split_mismatches: list[dict[str, Any]] = []
    excluded_roots = 0

    for a in roots:
        source = type_label(a)
        if source not in core_states:
            excluded_roots += 1
            continue
        lift = fine_lift_for_root(a, source)
        c = (2 * a - 1) // 3
        if c % 3 == 2:
            channel = "advanced_direct_c2"
            target = type_label(c)
        elif c % 3 == 1:
            channel = "advanced_parity_lift_c1"
            target = type_label(2 * c)
        else:
            channel = "advanced_sterile_tail_c0"
            target = "Q_boundary_or_sterile"
        counts[source][lift] += 1
        channel_counts[channel] += 1
        if channel != "advanced_sterile_tail_c0":
            key = (source, lift, channel, target)
            if key not in split_edge_keys:
                split_mismatches.append(
                    {
                        "a": a,
                        "source": source,
                        "fine_lift": lift,
                        "channel": channel,
                        "target": target,
                        "reason": "missing_split_edge",
                    }
                )

    state_rows: list[dict[str, Any]] = []
    complete_root_counts: dict[str, int] = {}
    boundary_root_counts: dict[str, int] = {}
    for state in sorted(core_states, key=lambda s: int(next(r["core_local_id"] for r in frozen_rows if r["state"] == s))):
        c0 = counts[state][0]
        c1 = counts[state][1]
        c2 = counts[state][2]
        complete_each = min(c0, c1, c2)
        complete_roots = 3 * complete_each
        boundary_roots = c0 + c1 + c2 - complete_roots
        complete_root_counts[state] = complete_roots
        boundary_root_counts[state] = boundary_roots
        state_rows.append(
            {
                "state": state,
                "count_lift_0": c0,
                "count_lift_1": c1,
                "count_lift_2": c2,
                "complete_each_lift": complete_each,
                "complete_roots": complete_roots,
                "boundary_roots": boundary_roots,
                "complete_core_rows": complete_roots * len(Y_VALUES),
                "boundary_core_rows": boundary_roots * len(Y_VALUES),
            }
        )

    complete_core_rows = sum(complete_root_counts.values()) * len(Y_VALUES)
    boundary_core_rows = sum(boundary_root_counts.values()) * len(Y_VALUES)
    total_core_rows = complete_core_rows + boundary_core_rows
    q_boundary_fraction = (
        boundary_core_rows / total_core_rows if total_core_rows else 0.0
    )

    lhs_total = sum(
        complete_root_counts[state] * len(Y_VALUES) * lhs_by_state[state]
        for state in complete_root_counts
    )
    rhs_total = sum(
        complete_root_counts[state] * len(Y_VALUES) * rhs_by_state[state]
        for state in complete_root_counts
    )
    weighted_ratio = lhs_total / rhs_total if rhs_total else 0.0
    weighted_pass = weighted_ratio >= 1.0

    q_boundary_budget = None
    q_boundary_acceptance_budget = min(
        q_boundary_fraction,
        max(0.0, frozen_ratio_min - 1.0),
    )
    q_boundary_pass = True
    if phase == "holdout":
        q_boundary_budget = load_calibration_budget(args.output_root)
        q_boundary_pass = q_boundary_fraction <= q_boundary_budget

    split_pass = len(split_mismatches) == 0
    if phase == "calibration":
        local_verdict = "Q_BOUNDARY_CALIBRATION_PUBLISHED" if split_pass else "CALIBRATION_SPLIT_MISMATCH"
        holdout_consumed = False
    elif split_pass and q_boundary_pass and weighted_pass:
        local_verdict = "CANDIDATE_CERTIFICATE_EMPIRICAL"
        holdout_consumed = True
    elif not split_pass:
        local_verdict = "HOLDOUT_FAIL_SPLIT_MISMATCH"
        holdout_consumed = True
    elif not q_boundary_pass:
        local_verdict = "HOLDOUT_FAIL_Q_BOUNDARY_BUDGET"
        holdout_consumed = True
    else:
        local_verdict = "HOLDOUT_FAIL_WEIGHTED_INEQUALITY"
        holdout_consumed = True

    summary = {
        "phase": phase,
        "interval_half_open": [lower, upper],
        "unique_parent_roots": len(roots),
        "y_values": list(Y_VALUES),
        "frozen_w_split_core_sha256": frozen_sha,
        "fine_period": FINE_PERIOD,
        "core_state_count": len(core_states),
        "core_roots": sum(sum(counter.values()) for counter in counts.values()),
        "excluded_roots": excluded_roots,
        "complete_core_rows": complete_core_rows,
        "boundary_core_rows": boundary_core_rows,
        "q_boundary_core_row_fraction": q_boundary_fraction,
        "q_boundary_acceptance_budget": (
            q_boundary_acceptance_budget if phase == "calibration" else q_boundary_budget
        ),
        "q_boundary_budget_rule": "min(calibration_q_boundary_core_row_fraction, min_frozen_row_ratio_lhs_over_rhs - 1)",
        "q_boundary_budget_from_calibration": q_boundary_budget,
        "q_boundary_pass": q_boundary_pass,
        "split_mismatch_count": len(split_mismatches),
        "channel_counts_core_roots": dict(sorted(channel_counts.items())),
        "ratio_definition": "lhs_total / rhs_total, where rhs_total = sum_i complete_core_row_count_i * (1+delta) * w_i",
        "lhs_total_decimal": lhs_total,
        "rhs_total_decimal": rhs_total,
        "weighted_ratio_lhs_over_rhs": weighted_ratio,
        "weighted_pass_ratio_ge_1": weighted_pass,
        "min_frozen_row_ratio_lhs_over_rhs": frozen_ratio_min,
        "delta": "1/100",
        "burned_ranges": [list(r) for r in BURNED_RANGES],
        "holdout_consumed": holdout_consumed,
        "elapsed_seconds": time.perf_counter() - started,
        "python": sys.version,
        "platform": platform.platform(),
        "local_verdict": local_verdict,
        "non_claims": {
            "no_rho_certificate": True,
            "no_density_theorem": True,
            "no_almost_all": True,
            "no_global_collatz_claim": True,
            "no_lean_operator": True,
        },
    }
    if phase == "calibration":
        summary["non_claims"]["no_holdout_result"] = True

    state_rows_path = output_dir / "split_state_counts.csv"
    mismatches_path = output_dir / "split_mismatches.csv"
    summary_path = output_dir / "summary.json"
    manifest_path = output_dir / "manifest_sha256.csv"
    write_csv(
        state_rows_path,
        state_rows,
        [
            "state",
            "count_lift_0",
            "count_lift_1",
            "count_lift_2",
            "complete_each_lift",
            "complete_roots",
            "boundary_roots",
            "complete_core_rows",
            "boundary_core_rows",
        ],
    )
    write_csv(
        mismatches_path,
        split_mismatches,
        ["a", "source", "fine_lift", "channel", "target", "reason"],
    )
    summary_path.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    write_csv(
        manifest_path,
        [
            {"path": path.name, "sha256": file_sha256(path)}
            for path in (state_rows_path, mismatches_path, summary_path)
        ],
        ["path", "sha256"],
    )
    print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
