#!/usr/bin/env python3
"""Reproduce the source-fidelity audit of arXiv:2512.13760 v1/v2.

The script checks small congruence instances and the numerical exponents used
in the two versions.  It does not prove that the current v2 claim is false;
it records independent failures in the proof as written.
"""

from __future__ import annotations

import csv
import hashlib
import json
import math
import subprocess
from fractions import Fraction
from pathlib import Path
from typing import Any


RUN_ID = "LIU2025_COUNTING_COLLATZ_NUMBERS_SOURCE_AUDIT_v1"
REPO_ROOT = Path(__file__).resolve().parents[1]
SCRIPT_PATH = Path(__file__).resolve()
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID

SUMMARY_PATH = OUT_DIR / "audit_summary.json"
VERSIONS_PATH = OUT_DIR / "version_claims.csv"
FINDINGS_PATH = OUT_DIR / "proof_findings.csv"
COUNTEREXAMPLES_PATH = OUT_DIR / "lemma_counterexamples.csv"
EXPONENTS_PATH = OUT_DIR / "exponent_recheck.csv"
STIRLING_PATH = OUT_DIR / "stirling_remainder_check.csv"
MANIFEST_PATH = OUT_DIR / "manifest_sha256.csv"

V1_URL = "https://arxiv.org/pdf/2512.13760v1"
V2_URL = "https://arxiv.org/pdf/2512.13760v2"
V1_SOURCE_SHA256 = "83ee3067889f9a78aaf8a7c7e3782ab53f417d73ba562c1908358f73dcba1004"
V2_SOURCE_SHA256 = "9d45249899c2f50b5b3b70ba4f822fba0ec449c01d9d7583ec7beee6a6f53faa"


def source_commit() -> str:
    try:
        return subprocess.check_output(
            ["git", "rev-parse", "HEAD"],
            cwd=REPO_ROOT,
            text=True,
            stderr=subprocess.DEVNULL,
        ).strip()
    except (OSError, subprocess.CalledProcessError):
        return "UNKNOWN_UNCOMMITTED"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def binary_entropy(p: float) -> float:
    return -p * math.log2(p) - (1.0 - p) * math.log2(1.0 - p)


def v1_candidates(u: int) -> list[int]:
    return [v for v in range(1, 2 * u + 1) if (v + 1) // 2 == u]


def v2_candidates(u: int) -> list[int]:
    return [v for v in range(1, 6 * u + 1) if (v + 1) // 6 == u - 1]


def level_two_difference(v1: int, v2: int) -> int:
    return 2 ** (v1 + v2) - 2**v2 - 3


def v1_level_two_solutions(u1: int, u2: int) -> list[tuple[int, int]]:
    return [
        (v1, v2)
        for v1 in v1_candidates(u1)
        for v2 in v1_candidates(u2)
        if level_two_difference(v1, v2) % 9 == 0
    ]


def v2_level_two_solutions(u1: int, u2: int) -> list[tuple[int, int]]:
    return [
        (v1, v2)
        for v1 in v2_candidates(u1)
        for v2 in v2_candidates(u2)
        if level_two_difference(v1, v2) % 9 == 0
        and level_two_difference(v1, v2) % 27 != 0
    ]


def exponent_rows() -> list[dict[str, Any]]:
    v1_formula = binary_entropy(1.0 / math.log2(3.0))
    v2_p = 1.0 / (2.0 + (2.0 / 3.0) * math.log(3.0, 4.0))
    v2_formula = binary_entropy(v2_p) / 3.0
    return [
        {
            "version": "v1",
            "formula_value": f"{v1_formula:.12f}",
            "stated_safe_exponent": "0.946",
            "safe_side_check": str(v1_formula > 0.946).lower(),
            "status": "SUPERSEDED_CLAIM_ONLY",
        },
        {
            "version": "v2",
            "formula_value": f"{v2_formula:.12f}",
            "stated_safe_exponent": "0.3227",
            "safe_side_check": str(v2_formula > 0.3227).lower(),
            "status": "NUMERICAL_FORMULA_CHECK_ONLY",
        },
    ]


def stirling_rows() -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for m in (10, 100, 1000, 10000):
        n = 2 * m
        log_binomial = (
            math.lgamma(n + 1) - math.lgamma(m + 1) - math.lgamma(n - m + 1)
        ) / math.log(2.0)
        entropy_main = float(n)
        rows.append(
            {
                "n": n,
                "l": m,
                "log2_binomial": f"{log_binomial:.12f}",
                "n_times_entropy": f"{entropy_main:.12f}",
                "remainder": f"{log_binomial - entropy_main:.12f}",
                "interpretation": "remainder diverges like -0.5*log2(n)",
            }
        )
    return rows


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)

    v1_solutions = v1_level_two_solutions(3, 1)
    v2_solutions = v2_level_two_solutions(2, 2)

    w_rows = []
    for a_mod_3 in (1, 2):
        r = 0 if a_mod_3 == 1 else 1
        residues = [(pow(4, w, 3) * pow(2, r, 3) * a_mod_3) % 3 for w in range(3)]
        w_rows.append((a_mod_3, r, residues))

    base_b = Fraction(2**8 - 1, 3)
    claimed_size_rhs = Fraction(4**6, 192)

    assert v1_solutions == []
    assert v2_solutions == [(8, 6), (8, 8), (10, 5), (10, 7)]
    assert all(residues == [1, 1, 1] for _, _, residues in w_rows)
    assert base_b > claimed_size_rhs

    version_rows = [
        {
            "version": "v1",
            "submitted": "2025-12-15",
            "source_url": V1_URL,
            "source_sha256": V1_SOURCE_SHA256,
            "headline_exponent": "0.946",
            "status": "SUPERSEDED_BY_V2",
        },
        {
            "version": "v2",
            "submitted": "2025-12-17",
            "source_url": V2_URL,
            "source_sha256": V2_SOURCE_SHA256,
            "headline_exponent": "0.3227",
            "status": "CURRENT_VERSION_PROOF_NOT_VALIDATED",
        },
    ]

    counterexample_rows = [
        {
            "check_id": "V1_LEVEL2_EXISTENCE",
            "version": "v1",
            "parameters": "l=2; u=(3,1)",
            "result": repr(v1_solutions),
            "expected_by_statement": "exactly one solution",
            "observed": f"{len(v1_solutions)} solutions",
            "pass": str(len(v1_solutions) == 1).lower(),
        },
        {
            "check_id": "V2_LEVEL2_UNIQUENESS",
            "version": "v2",
            "parameters": "l=2; u=(2,2); each u_j coprime to 3",
            "result": repr(v2_solutions),
            "expected_by_statement": "exactly one solution",
            "observed": f"{len(v2_solutions)} solutions",
            "pass": str(len(v2_solutions) == 1).lower(),
        },
        {
            "check_id": "V2_W_DIGIT_MOD3",
            "version": "v2",
            "parameters": repr(w_rows),
            "result": "all residues are 1 mod 3",
            "expected_by_statement": "a ternary digit w with residue != 1 mod 3",
            "observed": "no such w exists",
            "pass": "false",
        },
        {
            "check_id": "V2_SIZE_BOUND_L1",
            "version": "v2",
            "parameters": "l=1; u1=2; v1=8",
            "result": f"B={base_b}; claimed_rhs={claimed_size_rhs}",
            "expected_by_statement": "B <= claimed_rhs",
            "observed": str(base_b <= claimed_size_rhs).lower(),
            "pass": str(base_b <= claimed_size_rhs).lower(),
        },
    ]

    finding_rows = [
        {
            "finding_id": "F1",
            "severity": "BLOCKER",
            "version": "v1",
            "source_lines": "100-130",
            "finding": "The all-tuples existence claim fails at l=2, u=(3,1).",
            "evidence": "V1_LEVEL2_EXISTENCE",
        },
        {
            "finding_id": "F2",
            "severity": "BLOCKER",
            "version": "v2",
            "source_lines": "182-190",
            "finding": "The stated w_l condition modulo 3 is impossible after the preceding choice of r_l.",
            "evidence": "V2_W_DIGIT_MOD3",
        },
        {
            "finding_id": "F3",
            "severity": "BLOCKER",
            "version": "v2",
            "source_lines": "166-203",
            "finding": "The claimed unique parametrization has four level-2 solutions for u=(2,2).",
            "evidence": "V2_LEVEL2_UNIQUENESS",
        },
        {
            "finding_id": "F4",
            "severity": "BLOCKER",
            "version": "v2",
            "source_lines": "166-169;217-233",
            "finding": "The parametrization assumes every u_j is coprime to 3, while omega counts all positive tuples.",
            "evidence": "source-domain comparison",
        },
        {
            "finding_id": "F5",
            "severity": "BLOCKER",
            "version": "v2",
            "source_lines": "225-233",
            "finding": "The displayed size estimate with 192^(-l) is false already for l=1, u1=2, v1=8.",
            "evidence": "V2_SIZE_BOUND_L1",
        },
        {
            "finding_id": "F6",
            "severity": "BLOCKER",
            "version": "v2",
            "source_lines": "238-247",
            "finding": "The final chain lowers omega's argument and then compares it to a binomial using the larger n.",
            "evidence": "statement-level inequality mismatch",
        },
        {
            "finding_id": "F7",
            "severity": "MAJOR",
            "version": "v2",
            "source_lines": "207-212;238-249",
            "finding": "Stirling gives an O(log n) remainder here, not O(1); the (1+o(1)) multiplicative form is unsupported.",
            "evidence": "stirling_remainder_check.csv",
        },
        {
            "finding_id": "F8",
            "severity": "MAJOR",
            "version": "v2",
            "source_lines": "154;188-200",
            "finding": "Independent index/modulus inconsistencies remain: u1 vs ul, v1 vs vl, level l vs l-1, and 3^l vs 3^(l+1).",
            "evidence": "direct source comparison",
        },
    ]

    write_csv(
        VERSIONS_PATH,
        version_rows,
        ["version", "submitted", "source_url", "source_sha256", "headline_exponent", "status"],
    )
    write_csv(
        COUNTEREXAMPLES_PATH,
        counterexample_rows,
        ["check_id", "version", "parameters", "result", "expected_by_statement", "observed", "pass"],
    )
    write_csv(
        FINDINGS_PATH,
        finding_rows,
        ["finding_id", "severity", "version", "source_lines", "finding", "evidence"],
    )
    write_csv(
        EXPONENTS_PATH,
        exponent_rows(),
        ["version", "formula_value", "stated_safe_exponent", "safe_side_check", "status"],
    )
    write_csv(
        STIRLING_PATH,
        stirling_rows(),
        ["n", "l", "log2_binomial", "n_times_entropy", "remainder", "interpretation"],
    )

    summary = {
        "run_id": RUN_ID,
        "source_commit": source_commit(),
        "v1_claim": "pi(x) >= x^0.946",
        "v1_status": "SUPERSEDED_BY_V2",
        "v2_claim": "pi(x) >= x^0.3227",
        "v2_status": "CURRENT_VERSION_PROOF_NOT_VALIDATED",
        "blocker_count": sum(row["severity"] == "BLOCKER" for row in finding_rows),
        "major_count": sum(row["severity"] == "MAJOR" for row in finding_rows),
        "counterexample_check_count": len(counterexample_rows),
        "counterexample_failure_count": sum(row["pass"] == "false" for row in counterexample_rows),
        "proof_as_written_validated": False,
        "claim_falsity_proved": False,
        "state_of_art_recalibration": "NO_UPWARD_RECALIBRATION_FROM_2512.13760",
        "historical_kl2003_record_displaced": False,
        "verdict": "V1_0946_WITHDRAWN_V2_03227_PROOF_NOT_VALIDATED",
        "guardrails": [
            "NO_CLAIM_THAT_V2_THEOREM_IS_FALSE",
            "NO_NEW_COLLATZ_BOUND_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }
    write_json(SUMMARY_PATH, summary)

    output_paths = [
        SUMMARY_PATH,
        VERSIONS_PATH,
        FINDINGS_PATH,
        COUNTEREXAMPLES_PATH,
        EXPONENTS_PATH,
        STIRLING_PATH,
    ]
    manifest_rows = [
        {"path": str(path.relative_to(REPO_ROOT)), "sha256": sha256(path)}
        for path in output_paths
    ]
    manifest_rows.append(
        {"path": str(SCRIPT_PATH.relative_to(REPO_ROOT)), "sha256": sha256(SCRIPT_PATH)}
    )
    write_csv(MANIFEST_PATH, manifest_rows, ["path", "sha256"])

    print(summary["verdict"])
    print(f"blockers={summary['blocker_count']}")
    print(f"counterexample_failures={summary['counterexample_failure_count']}")


if __name__ == "__main__":
    main()
