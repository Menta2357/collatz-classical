#!/usr/bin/env python3
"""KL2003 k=2 interior rational LP certificate skeleton.

This script deliberately uses exact rational arithmetic for the LP skeleton.
It does not prove the transcendental bounds for lambda^(alpha-2) and
lambda^(alpha-1); those intervals are emitted as explicit placeholders so the
formal certificate remains blocked until they are certified independently.
"""

from __future__ import annotations

import json
from dataclasses import dataclass
from fractions import Fraction
from pathlib import Path
from typing import Any


REPO_ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = REPO_ROOT / "outputs" / "KL2003_K2_INTERIOR_RATIONAL_CERTIFICATE_v1"
OUT_FILE = OUT_DIR / "certificate.json"


def fraction_decimal(q: Fraction, places: int = 18) -> str:
    sign = "-" if q < 0 else ""
    q = abs(q)
    whole = q.numerator // q.denominator
    rem = q.numerator % q.denominator
    digits = []
    for _ in range(places):
        rem *= 10
        digits.append(str(rem // q.denominator))
        rem %= q.denominator
    return f"{sign}{whole}.{''.join(digits)}"


def fraction_json(q: Fraction) -> dict[str, Any]:
    return {
        "num": q.numerator,
        "den": q.denominator,
        "decimal": fraction_decimal(q),
    }


@dataclass(frozen=True)
class Interval:
    lo: Fraction
    hi: Fraction
    certification: str
    certified: bool

    def to_json(self) -> dict[str, Any]:
        return {
            "lo": fraction_json(self.lo),
            "hi": fraction_json(self.hi),
            "certification": self.certification,
            "certified": self.certified,
        }


def contains_float(value: Any) -> bool:
    if isinstance(value, float):
        return True
    if isinstance(value, dict):
        return any(contains_float(v) for v in value.values())
    if isinstance(value, list):
        return any(contains_float(v) for v in value)
    return False


def positive_slack_row(name: str, direction: str, slack: Fraction) -> dict[str, Any]:
    status = "PASS_POSITIVE_RATIONAL_SLACK" if slack > 0 else "FAIL_NONPOSITIVE_SLACK"
    return {
        "name": name,
        "direction": direction,
        "slack": fraction_json(slack),
        "status": status,
    }


def build_certificate() -> dict[str, Any]:
    frontier = Fraction(1353400093558369, 10**15)
    lam = Fraction(27, 20)
    if not lam < frontier:
        raise ValueError("lambda must stay below the reported k=2 frontier")

    coeffs = {
        "A_lambda_minus_2": Interval(
            lo=lam ** -2,
            hi=lam ** -2,
            certification="exact rational: lambda is rational and exponent is -2",
            certified=True,
        ),
        "B_lambda_alpha_minus_2": Interval(
            lo=Fraction(22, 25),
            hi=Fraction(89, 100),
            certification=(
                "SPEC placeholder only: intended interval for "
                "lambda^(alpha-2), alpha=log_2(3); not certified here"
            ),
            certified=False,
        ),
        "D_lambda_alpha_minus_1": Interval(
            lo=Fraction(119, 100),
            hi=Fraction(6, 5),
            certification=(
                "SPEC placeholder only: intended interval for "
                "lambda^(alpha-1), alpha=log_2(3); not certified here"
            ),
            certified=False,
        ),
    }

    variables = {
        "c_2_2": Fraction(73, 40),
        "c_2_5": Fraction(1001, 1000),
        "c_2_8": Fraction(69, 40),
        "c_1_2": Fraction(1, 1),
        "C_2_max": Fraction(2, 1),
    }

    A = coeffs["A_lambda_minus_2"].lo
    B = coeffs["B_lambda_alpha_minus_2"].lo
    D = coeffs["D_lambda_alpha_minus_1"].lo
    c22 = variables["c_2_2"]
    c25 = variables["c_2_5"]
    c28 = variables["c_2_8"]
    c12 = variables["c_1_2"]
    cmax = variables["C_2_max"]

    rows = [
        positive_slack_row("lower_c_2_2", "1 <= c_2^2", c22 - 1),
        positive_slack_row("upper_c_2_2", "c_2^2 <= C_2^max", cmax - c22),
        positive_slack_row("lower_c_2_5", "1 <= c_2^5", c25 - 1),
        positive_slack_row("upper_c_2_5", "c_2^5 <= C_2^max", cmax - c25),
        positive_slack_row("lower_c_2_8", "1 <= c_2^8", c28 - 1),
        positive_slack_row("upper_c_2_8", "c_2^8 <= C_2^max", cmax - c28),
        positive_slack_row(
            "L2NT_D1",
            "c_2^2 <= A*c_2^8 + B*c_1^2, checked with lower(A), lower(B)",
            A * c28 + B * c12 - c22,
        ),
        positive_slack_row(
            "L2NT_D2",
            "c_2^5 <= A*c_2^2, checked with exact A",
            A * c22 - c25,
        ),
        positive_slack_row(
            "L2NT_D3",
            "c_2^8 <= A*c_2^5 + D*c_1^2, checked with lower(A), lower(D)",
            A * c25 + D * c12 - c28,
        ),
        positive_slack_row("aux_c_1_2_le_c_2_2", "c_1^2 <= c_2^2", c22 - c12),
        positive_slack_row("aux_c_1_2_le_c_2_5", "c_1^2 <= c_2^5", c25 - c12),
        positive_slack_row("aux_c_1_2_le_c_2_8", "c_1^2 <= c_2^8", c28 - c12),
        positive_slack_row("domain_c_1_2_positive", "0 < c_1^2", c12),
    ]

    missing_intervals = [
        key for key in ("A_lambda_minus_2", "B_lambda_alpha_minus_2", "D_lambda_alpha_minus_1")
        if key not in coeffs
    ]
    nonpositive_slacks = [row["name"] for row in rows if row["status"] != "PASS_POSITIVE_RATIONAL_SLACK"]
    uncertified_coefficients = [key for key, interval in coeffs.items() if not interval.certified]

    base_segment_placeholder = {
        "name": "BaseSegmentLowerBound_phi_I2ELSystem_Y0",
        "status": "SPEC_PLACEHOLDER_PRESENT_NOT_PROVED",
        "intended_content": "future explicit initial segment lower bound, e.g. phi_k^m(y) >= 1 on the required base segment",
    }

    internal_report = {
        "float_evidence_detected": False,
        "missing_coefficient_intervals": missing_intervals,
        "nonpositive_slacks": nonpositive_slacks,
        "base_segment_placeholder_present": True,
        "uncertified_transcendental_intervals": uncertified_coefficients,
    }

    rational_skeleton_status = (
        "PASS_RATIONAL_SKELETON"
        if not missing_intervals and not nonpositive_slacks
        else "FAIL_RATIONAL_SKELETON"
    )
    formal_certificate_status = (
        "BLOCKED_ON_RATIONAL_INTERVALS_FOR_LAMBDA_BETA"
        if uncertified_coefficients
        else rational_skeleton_status
    )

    certificate = {
        "schema": "KL2003_K2_INTERIOR_RATIONAL_CERTIFICATE_v1",
        "guardrails": [
            "NO_LEAN_THEOREM",
            "NO_M0_PROOF",
            "NO_TARGET_REGISTRATION",
            "NO_FLOAT_ONLY_CERTIFICATE",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
        "system": "L_2^NT",
        "lambda": {
            "value": fraction_json(lam),
            "reported_frontier_upper_bound_decimal": "1.353400093558369",
            "frontier_check": "PASS: lambda = 27/20 is strictly below the reported frontier",
        },
        "coefficient_intervals": {key: interval.to_json() for key, interval in coeffs.items()},
        "variables": {key: fraction_json(value) for key, value in variables.items()},
        "rows": rows,
        "base_segment_placeholder": base_segment_placeholder,
        "rational_interval_policy": {
            "row_check_rule": (
                "for nonnegative variables, verify lhs using exact/upper coefficients "
                "and rhs using lower coefficient endpoints, with positive rational slack"
            ),
            "exact_interval_keys": ["A_lambda_minus_2"],
            "transcendental_placeholder_keys": [
                "B_lambda_alpha_minus_2",
                "D_lambda_alpha_minus_1",
            ],
            "gap": (
                "the script does not certify lambda^(alpha-2) or lambda^(alpha-1); "
                "a future verifier must replace placeholders by audited rational intervals"
            ),
        },
        "verifier_report": internal_report,
        "rational_skeleton_status": rational_skeleton_status,
        "formal_certificate_status": formal_certificate_status,
    }

    if contains_float(certificate):
        raise ValueError("float evidence detected in certificate JSON payload")
    return certificate


def main() -> None:
    certificate = build_certificate()
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    OUT_FILE.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")

    report = certificate["verifier_report"]
    if report["missing_coefficient_intervals"]:
        raise SystemExit("FAIL_MISSING_COEFFICIENT_INTERVAL")
    if report["nonpositive_slacks"]:
        raise SystemExit("FAIL_NONPOSITIVE_SLACK")
    if not report["base_segment_placeholder_present"]:
        raise SystemExit("FAIL_MISSING_BASE_SEGMENT_PLACEHOLDER")
    if report["float_evidence_detected"]:
        raise SystemExit("FAIL_FLOAT_ONLY")

    print(f"wrote {OUT_FILE}")
    print(f"rational_skeleton_status={certificate['rational_skeleton_status']}")
    print(f"formal_certificate_status={certificate['formal_certificate_status']}")
    print("positive rational slacks verified for the LP skeleton")
    print("transcendental interval placeholders remain uncertified")


if __name__ == "__main__":
    main()
