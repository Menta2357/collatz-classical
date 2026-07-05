#!/usr/bin/env python3
"""Certify rational intervals for lambda^(alpha-2) and lambda^(alpha-1).

All verifier checks in this script are integer or Fraction comparisons. The
real-power step is recorded as a small lemma ledger:

  alpha = log_2(3), 19/12 < alpha < 8/5
  lambda = 27/20 > 1

so monotonicity of x |-> lambda^x reduces the target power bounds to rational
power inequalities. No floating point values are used as evidence.
"""

from __future__ import annotations

import json
from fractions import Fraction
from pathlib import Path
from typing import Any


REPO_ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = REPO_ROOT / "outputs" / "KL2003_K2_LAMBDA_POWER_INTERVAL_CERTIFICATION_v1"
OUT_FILE = OUT_DIR / "interval_certificate.json"


def fraction_decimal(q: Fraction, places: int = 24) -> str:
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


def int_check(name: str, lhs: int, op: str, rhs: int, explanation: str) -> dict[str, Any]:
    if op == "<":
        ok = lhs < rhs
    elif op == "<=":
        ok = lhs <= rhs
    elif op == ">=":
        ok = lhs >= rhs
    else:
        raise ValueError(f"unsupported op {op}")
    return {
        "name": name,
        "lhs": str(lhs),
        "op": op,
        "rhs": str(rhs),
        "ok": ok,
        "explanation": explanation,
    }


def rat_check(name: str, lhs: Fraction, op: str, rhs: Fraction, explanation: str) -> dict[str, Any]:
    if op == "<=":
        ok = lhs <= rhs
        margin = rhs - lhs
    elif op == ">=":
        ok = lhs >= rhs
        margin = lhs - rhs
    else:
        raise ValueError(f"unsupported op {op}")
    return {
        "name": name,
        "lhs": fraction_json(lhs),
        "op": op,
        "rhs": fraction_json(rhs),
        "margin": fraction_json(margin),
        "ok": ok,
        "explanation": explanation,
    }


def contains_float(value: Any) -> bool:
    if isinstance(value, float):
        return True
    if isinstance(value, dict):
        return any(contains_float(v) for v in value.values())
    if isinstance(value, list):
        return any(contains_float(v) for v in value)
    return False


def build_interval_certificate() -> dict[str, Any]:
    lam = Fraction(27, 20)
    b_target_lo = Fraction(22, 25)
    b_target_hi = Fraction(89, 100)
    d_target_lo = Fraction(119, 100)
    d_target_hi = Fraction(6, 5)

    # Stronger interval for B sufficient to imply both target intervals.
    b_strong_lo = Fraction(119, 135)
    b_strong_hi = Fraction(8, 9)
    d_derived_lo = lam * b_strong_lo
    d_derived_hi = lam * b_strong_hi

    checks = [
        int_check(
            "alpha_lower_19_over_12",
            2**19,
            "<",
            3**12,
            "2^19 < 3^12 implies 19/12 < log_2(3)",
        ),
        int_check(
            "alpha_upper_8_over_5",
            3**5,
            "<",
            2**8,
            "3^5 < 2^8 implies log_2(3) < 8/5",
        ),
    ]

    lower_reduction = b_strong_lo**12 * lam**5
    upper_reduction = b_strong_hi**5 * lam**2
    checks.extend(
        [
            rat_check(
                "B_lower_reduced_rational_power",
                lower_reduction,
                "<=",
                Fraction(1, 1),
                "(119/135)^12 * (27/20)^5 <= 1 implies (27/20)^(-5/12) >= 119/135",
            ),
            rat_check(
                "B_upper_reduced_rational_power",
                upper_reduction,
                ">=",
                Fraction(1, 1),
                "(8/9)^5 * (27/20)^2 >= 1 implies (27/20)^(-2/5) <= 8/9",
            ),
            rat_check(
                "B_strong_implies_target_lower",
                b_strong_lo,
                ">=",
                b_target_lo,
                "stronger B lower endpoint implies the requested B lower endpoint",
            ),
            rat_check(
                "B_strong_implies_target_upper",
                b_strong_hi,
                "<=",
                b_target_hi,
                "stronger B upper endpoint implies the requested B upper endpoint",
            ),
            rat_check(
                "D_derived_target_lower",
                d_derived_lo,
                ">=",
                d_target_lo,
                "D = lambda*B and B >= 119/135 give D >= 119/100",
            ),
            rat_check(
                "D_derived_target_upper",
                d_derived_hi,
                "<=",
                d_target_hi,
                "D = lambda*B and B <= 8/9 give D <= 6/5",
            ),
        ]
    )

    all_checks_pass = all(check["ok"] for check in checks)
    certificate = {
        "schema": "KL2003_K2_LAMBDA_POWER_INTERVAL_CERTIFICATION_v1",
        "guardrails": [
            "NO_LEAN_THEOREM",
            "NO_M0_PROOF",
            "NO_TARGET_REGISTRATION",
            "NO_FLOAT_ONLY_CERTIFICATE",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
        "lambda": fraction_json(lam),
        "alpha_bounds": {
            "lower": {
                "value": fraction_json(Fraction(19, 12)),
                "integer_witness": "2^19 < 3^12",
            },
            "upper": {
                "value": fraction_json(Fraction(8, 5)),
                "integer_witness": "3^5 < 2^8",
            },
        },
        "power_intervals": {
            "B_lambda_alpha_minus_2": {
                "target_interval": {
                    "lo": fraction_json(b_target_lo),
                    "hi": fraction_json(b_target_hi),
                },
                "certified_stronger_interval": {
                    "lo": fraction_json(b_strong_lo),
                    "hi": fraction_json(b_strong_hi),
                },
                "status": "CERTIFIED_BY_RATIONAL_REDUCTION",
            },
            "D_lambda_alpha_minus_1": {
                "target_interval": {
                    "lo": fraction_json(d_target_lo),
                    "hi": fraction_json(d_target_hi),
                },
                "derived_interval_from_lambda_times_B": {
                    "lo": fraction_json(d_derived_lo),
                    "hi": fraction_json(d_derived_hi),
                },
                "status": "CERTIFIED_BY_D_EQUALS_LAMBDA_TIMES_B",
            },
        },
        "lemma_ledger": [
            "If 2^p < 3^q, then p/q < log_2(3).",
            "If 3^q < 2^p, then log_2(3) < p/q.",
            "For lambda > 1, beta1 <= beta2 implies lambda^beta1 <= lambda^beta2.",
            "For positive rationals and positive integer n, x <= y iff x^n <= y^n.",
            "lambda^(alpha-1) = lambda * lambda^(alpha-2).",
        ],
        "checks": checks,
        "float_evidence_detected": False,
        "verifier_status": (
            "PASS_RATIONAL_INTERVAL_VERIFIER" if all_checks_pass else "FAIL_RATIONAL_INTERVAL_VERIFIER"
        ),
        "formal_certificate_update": {
            "recommended_status": (
                "PASS_FORMAL_INTERVAL_SKELETON"
                if all_checks_pass
                else "BLOCKED_ON_TRANSCENDENTAL_INEQUALITY_METHOD"
            ),
            "update_target": "outputs/KL2003_K2_INTERIOR_RATIONAL_CERTIFICATE_v1/certificate.json",
        },
    }
    if contains_float(certificate):
        raise ValueError("float evidence detected in interval certificate")
    return certificate


def main() -> None:
    certificate = build_interval_certificate()
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    OUT_FILE.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    if certificate["verifier_status"] != "PASS_RATIONAL_INTERVAL_VERIFIER":
        raise SystemExit(certificate["verifier_status"])
    print(f"wrote {OUT_FILE}")
    print(f"verifier_status={certificate['verifier_status']}")
    print(f"recommended_status={certificate['formal_certificate_update']['recommended_status']}")
    print("lambda power intervals certified by rational reductions")


if __name__ == "__main__":
    main()
