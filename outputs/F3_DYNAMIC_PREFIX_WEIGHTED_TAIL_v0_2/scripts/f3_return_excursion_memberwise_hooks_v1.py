#!/usr/bin/env python3
"""F3 return-excursion member-wise hooks v1.

Arithmetic/member-wise hook audit for the v2 diagnostic operator.  This is not
a rho certificate and does not consume holdout.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
from collections import Counter
from pathlib import Path
from typing import Any


BASE = Path(__file__).resolve().parents[1]
DEFAULT_OUTPUT_DIR = BASE / "results/F3_RETURN_EXCURSION_MEMBERWISE_HOOKS_v1"
V2_DIR = BASE / "results/F3_PHASE_B_RETURN_EXCURSION_OPERATOR_v2"
PHASE_B_CALIBRATION = (
    BASE
    / "results/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_PHASE_B_ALL_RESIDUES_PILOT_v1/calibration/summary.json"
)
Y_VALUES = [8, 9, 10]


def parity_value(n: int) -> str:
    return "odd" if n % 2 else "even"


def nu2_bucket(n: int) -> int:
    if n % 2:
        return 0
    if n % 4:
        return 1
    return 2


def parse_state(label: str) -> tuple[int, int, str, int]:
    parts = label.split(":")
    return (
        int(parts[0][1:]),
        int(parts[1][1:]),
        parts[2][1:],
        int(parts[3][1:]),
    )


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


def target_state_from_value(d0: int, n: int) -> tuple[int, int, str, int]:
    return (d0, n % (3**d0), parity_value(n), nu2_bucket(n))


def collatz_T(n: int) -> int:
    if n % 2 == 0:
        return n // 2
    return 3 * n + 1


def floor_log2(n: int) -> int:
    if n <= 0:
        raise ValueError("floor_log2 expects positive integer")
    return n.bit_length() - 1


def pure_duplication_tail_count(c: int, y: int) -> int:
    window = 3 * (2 ** (y - 1)) * c
    return floor_log2(window // c) + 1


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        return list(csv.DictReader(handle))


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
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    output_dir: Path = args.output_dir
    output_dir.mkdir(parents=True, exist_ok=True)

    v2_summary = json.loads((V2_DIR / "summary.json").read_text())
    calibration = json.loads(PHASE_B_CALIBRATION.read_text())
    edges = read_csv(V2_DIR / "return_excursion_edges.csv")
    tails = read_csv(V2_DIR / "row_tail_Q.csv")

    d0 = int(v2_summary["d0"])
    modulus = 3**d0
    margin = float(v2_summary["power_iteration_estimate"]) - 1.0
    q_fraction = float(calibration["q_fraction"])
    budget_remaining = margin - q_fraction

    hook_rows: list[dict[str, Any]] = []
    failures: list[dict[str, Any]] = []
    channel_counts = Counter()

    def record(name: str, source: str, passed: bool, detail: str) -> None:
        row = {
            "hook": name,
            "source": source,
            "passed": "yes" if passed else "no",
            "detail": detail,
        }
        hook_rows.append(row)
        if not passed:
            failures.append(row)

    for row in edges:
        channel = row["channel"]
        channel_counts[channel] += 1
        source = parse_state(row["source"])
        target = parse_state(row["target"])
        a = representative(source)

        if channel == "retarded":
            expected = (d0, (4 * source[1]) % modulus, "even", 2)
            record(
                "H1_retarded_target",
                row["source"],
                target == expected,
                f"target={state_label(target)} expected={state_label(expected)}",
            )
            for y in Y_VALUES:
                record(
                    "H1_retarded_window_identity",
                    row["source"],
                    (2 ** (y - 2)) * (4 * a) == (2**y) * a,
                    f"y={y}",
                )
            continue

        c = (2 * a - 1) // 3
        record(
            f"{channel}_advanced_integrality",
            row["source"],
            3 * c + 1 == 2 * a,
            f"3c+1={3*c+1} 2a={2*a}",
        )

        if channel == "advanced_direct_c2":
            expected = target_state_from_value(d0, c)
            record(
                "H2_direct_child_mod3",
                row["source"],
                c % 3 == 2,
                f"c_mod3={c % 3}",
            )
            record(
                "H2_direct_target",
                row["source"],
                target == expected,
                f"target={state_label(target)} expected={state_label(expected)}",
            )
            for y in Y_VALUES:
                record(
                    "H2_direct_window_le_target",
                    row["source"],
                    3 * (2 ** (y - 1)) * c <= (2**y) * a,
                    f"y={y}",
                )
        elif channel == "advanced_parity_lift_c1":
            lifted = 2 * c
            expected = target_state_from_value(d0, lifted)
            record(
                "H3_lift_child_mod3",
                row["source"],
                c % 3 == 1,
                f"c_mod3={c % 3}",
            )
            record(
                "H3_lift_route",
                row["source"],
                collatz_T(lifted) == c,
                f"T(2c)={collatz_T(lifted)} c={c}",
            )
            record(
                "H3_lift_target",
                row["source"],
                target == expected,
                f"target={state_label(target)} expected={state_label(expected)}",
            )
            for y in Y_VALUES:
                record(
                    "H3_lift_parity_window_exact",
                    row["source"],
                    (2 ** (y - 2)) * lifted == (2 ** (y - 1)) * c,
                    f"y={y}",
                )

    for row in tails:
        channel_counts[row["channel"]] += 1
        source = parse_state(row["source"])
        a = representative(source)
        c = (2 * a - 1) // 3
        record(
            "H4_sterile_integrality",
            row["source"],
            3 * c + 1 == 2 * a,
            f"3c+1={3*c+1} 2a={2*a}",
        )
        record(
            "H4_sterile_child_mod3",
            row["source"],
            c % 3 == 0,
            f"c_mod3={c % 3}",
        )
        for y in Y_VALUES:
            record(
                "H4_sterile_Q_exact_count",
                row["source"],
                pure_duplication_tail_count(c, y) == y + 1,
                f"y={y} count={pure_duplication_tail_count(c, y)} expected={y+1}",
            )

    expected_counts = {
        "retarded": 729,
        "advanced_direct_c2": 81,
        "advanced_parity_lift_c1": 81,
        "advanced_sterile_tail_c0": 81,
    }
    for channel, expected in expected_counts.items():
        record(
            "H5_exact_channel_enumeration",
            channel,
            channel_counts[channel] == expected,
            f"count={channel_counts[channel]} expected={expected}",
        )

    hook_failure_count = len(failures)
    budget_pass = budget_remaining > 0
    if hook_failure_count:
        local_verdict = "STOP_HOOK_FAILURE"
    elif not budget_pass:
        local_verdict = "STOP_BUDGET_MARGIN_EXHAUSTED"
    else:
        local_verdict = "EMPIRICAL_CANDIDATE_HOOKS_PASS"

    summary = {
        "d0": d0,
        "rho_star": v2_summary["rho_star"],
        "lambda_11_official": v2_summary["lambda_11_official"],
        "v2_power_iteration_estimate": v2_summary["power_iteration_estimate"],
        "v2_margin": margin,
        "predeclared_loss_q_fraction_calibration": q_fraction,
        "predeclared_phase_loss_fraction_calibration": calibration["phase_loss_fraction"],
        "predeclared_atom_tail_fraction_calibration": calibration["atom_tail_fraction"],
        "budget_remaining_after_q_fraction": budget_remaining,
        "budget_pass": budget_pass,
        "y_values": Y_VALUES,
        "hook_row_count": len(hook_rows),
        "hook_failure_count": hook_failure_count,
        "channel_counts": dict(sorted(channel_counts.items())),
        "local_verdict": local_verdict,
        "holdout_consumed": False,
        "non_claims": {
            "no_lean_operator": True,
            "no_rho_certificate": True,
            "no_density_theorem": True,
            "no_almost_all": True,
            "no_global_collatz_claim": True,
        },
    }

    hooks_path = output_dir / "hook_checks.csv"
    failures_path = output_dir / "hook_failures.csv"
    summary_path = output_dir / "summary.json"
    manifest_path = output_dir / "manifest_sha256.csv"
    write_csv(hooks_path, hook_rows, ["hook", "source", "passed", "detail"])
    write_csv(failures_path, failures, ["hook", "source", "passed", "detail"])
    summary_path.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    write_csv(
        manifest_path,
        [
            {"path": path.name, "sha256": file_sha256(path)}
            for path in (hooks_path, failures_path, summary_path)
        ],
        ["path", "sha256"],
    )
    print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
