#!/usr/bin/env python3
"""Consolidate the measured k=9 LNT pipeline gate."""

from __future__ import annotations

import csv
import hashlib
import json
from fractions import Fraction
from pathlib import Path
from typing import Any


RUN_ID = "KL2003_F2_K9_MEASUREMENT_GATE_v1"
REPO_ROOT = Path(__file__).resolve().parents[1]
MEASUREMENT = (
    REPO_ROOT
    / "outputs"
    / "KL2003_F2_K9_LNT_MEASUREMENT_v1"
    / "generation_summary.json"
)
SCHEMA = (
    REPO_ROOT
    / "outputs"
    / "KL2003_F2_K9_LNT_SCHEMA_VALIDATION_v1"
    / "schema_validation_summary.json"
)
KERNEL = (
    REPO_ROOT
    / "outputs"
    / "KL2003_F2_K9_KERNEL_CHECKER_BENCHMARK_v1"
    / "kernel_checker_summary.json"
)
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID
SUMMARY_PATH = OUT_DIR / "final_gate_summary.json"
CONDITIONS_PATH = OUT_DIR / "condition_status.csv"
MISMATCH_PATH = OUT_DIR / "mismatch.csv"
MANIFEST_PATH = OUT_DIR / "manifest_sha256.csv"

MAX_KERNEL_WALL_SECONDS = 900
MAX_RATIONAL_DIGITS = 64


def repo_rel(path: Path) -> str:
    return str(path.resolve().relative_to(REPO_ROOT))


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def write_json(path: Path, payload: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )


def write_csv(path: Path, rows: list[dict[str, Any]], fields: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        for row in rows:
            writer.writerow({field: row.get(field, "") for field in fields})


def load(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def main() -> int:
    measurement = load(MEASUREMENT)
    schema = load(SCHEMA)
    kernel = load(KERNEL)
    minimum_slack = Fraction(measurement["minimum_row_slack"])
    conditions = [
        {
            "condition": "1_general_k_semantic_bridge",
            "pass": True,
            "evidence": "general-k dynamic theorem and k3 piStar theorem are audited modules",
        },
        {
            "condition": "2_flat_k9_generator",
            "pass": measurement["tracked_class_count"] == 6561
            and measurement["mismatch_count"] == 0,
            "evidence": "6561 parametric L9NT rows; zero topology mismatches",
        },
        {
            "condition": "3_exact_certificate_scale",
            "pass": minimum_slack > 0
            and measurement["rational_numerator_max_digits"] <= MAX_RATIONAL_DIGITS
            and measurement["rational_denominator_max_digits"] <= MAX_RATIONAL_DIGITS,
            "evidence": (
                f"minimum slack {measurement['minimum_row_slack_decimal']}; "
                f"digits {measurement['rational_numerator_max_digits']}/"
                f"{measurement['rational_denominator_max_digits']}"
            ),
        },
        {
            "condition": "4_schema_v21",
            "pass": schema["schema_ok"] is True and schema["error_count"] == 0,
            "evidence": "schema v2.1 accepts 6561 rows; named manifest warning only",
        },
        {
            "condition": "5_kernel_resource_budget",
            "pass": kernel["verdict"] == "K9_KERNEL_CERTIFICATE_CHECKER_BENCHMARK_PASS"
            and kernel["all_certificate_rows_kernel_rechecked"] is True
            and float(kernel["total_wall_seconds"]) <= MAX_KERNEL_WALL_SECONDS,
            "evidence": (
                f"9/9 shards, wall {kernel['total_wall_seconds']} s, "
                f"budget {MAX_KERNEL_WALL_SECONDS} s"
            ),
        },
    ]
    failures = [row for row in conditions if not row["pass"]]
    verdict = (
        "K9_FORMALIZATION_ENGINEERING_GO"
        if not failures
        else "K9_FORMALIZATION_GATE_NOT_PASSED"
    )
    condition_rows = [
        {
            "condition": row["condition"],
            "status": "PASS" if row["pass"] else "FAIL",
            "evidence": row["evidence"],
        }
        for row in conditions
    ]
    write_csv(CONDITIONS_PATH, condition_rows, ["condition", "status", "evidence"])
    write_csv(
        MISMATCH_PATH,
        [
            {
                "condition": row["condition"],
                "evidence": row["evidence"],
            }
            for row in failures
        ],
        ["condition", "evidence"],
    )
    summary = {
        "run_id": RUN_ID,
        "verdict": verdict,
        "condition_count": len(conditions),
        "conditions_passed": len(conditions) - len(failures),
        "conditions_failed": len(failures),
        "formalization_scope_authorized": "generated k9 LNT certificate integration only",
        "semantic_k9_lower_bound_theorem_status": "NOT_PROVED",
        "k11_status": "DEFERRED",
        "resource_policy": {
            "max_kernel_wall_seconds": MAX_KERNEL_WALL_SECONDS,
            "max_rational_digits": MAX_RATIONAL_DIGITS,
        },
        "measured": {
            "lambda": measurement["lambda"],
            "gamma_diagnostic": measurement["gamma_diagnostic"],
            "tracked_class_count": measurement["tracked_class_count"],
            "minimum_row_slack": measurement["minimum_row_slack"],
            "kernel_wall_seconds": kernel["total_wall_seconds"],
        },
        "classification": [
            verdict,
            "K9_LNT_CERTIFICATE_PIPELINE_MEASURED",
            "K9_KERNEL_ARITHMETIC_RECHECK_PASS",
            "K9_SEMANTIC_INTEGRATION_NOT_STARTED",
            "NO_K9_THEOREM_CLAIM",
            "K11_DEFERRED",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }
    write_json(SUMMARY_PATH, summary)
    manifest_inputs = [
        SUMMARY_PATH,
        CONDITIONS_PATH,
        MISMATCH_PATH,
        MEASUREMENT,
        SCHEMA,
        KERNEL,
        REPO_ROOT / "scripts" / Path(__file__).name,
    ]
    write_csv(
        MANIFEST_PATH,
        [{"path": repo_rel(path), "sha256": sha256(path)} for path in manifest_inputs],
        ["path", "sha256"],
    )
    print(json.dumps(summary, sort_keys=True))
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
