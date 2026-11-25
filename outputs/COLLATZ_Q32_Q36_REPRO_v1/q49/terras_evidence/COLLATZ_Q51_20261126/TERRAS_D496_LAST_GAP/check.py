#!/usr/bin/env python3
"""Q51 fixed integer/rational contrasts; no orbit or seed search."""
from fractions import Fraction as F
from hashlib import sha256
import json
from pathlib import Path
from time import perf_counter

HERE = Path(__file__).resolve().parent
EXPERIMENTS = HERE.parents[1]
PINS = {
    "COLLATZ_Q50_20261126/TERRAS_D495_GAPS_ORDINAL/RESULTADO.md":
        "f729bf190e6972d9bed98887abcc8e4a4fc55c965215283a99dae87975b3d427",
    "COLLATZ_Q50_20261126/TERRAS_D495_GAPS_ORDINAL/RECIBO.json":
        "022db4ace4b9efcef3c351f5e52c69932937475057997ed00cb792b081a7cd48",
}


def require(condition, context):
    if not condition:
        raise ArithmeticError(context)


def main():
    started = perf_counter()
    for name, pin in PINS.items():
        require(sha256((EXPERIMENTS / name).read_bytes()).hexdigest() == pin,
                ("contrast source SHA256", name))
    require(2**237 <= 6**92 < 2**238, "D5 integer target")
    require(3**94 < 2**149 and 3**96 < 9 * 2**149, "last-gap price")
    epsilon = F(1, 2**47)
    require(epsilon < F(1, 16) and F(9, 16) + epsilon < 1,
            "entire last-gap tail b>=4 excluded")
    require(pow(2, 142, 81) == 34, "terminal residue")
    rows = []
    for gap, max_t, expected_inverse, expected_residue in (
        (1, 4, 56, 56),
        (2, 2, 28, 3),
        (3, 1, 14, 17),
    ):
        require(F(9, 2**gap) + epsilon < max_t + 1,
                ("integer terminal ceiling", gap))
        coefficient = (2**gap * 34) % 81
        rhs = 2**gap - 1
        inverse = pow(coefficient, -1, 81)
        residue = (rhs * inverse) % 81
        require(inverse == expected_inverse and coefficient * inverse % 81 == 1,
                ("fixed modular inverse", gap))
        require(residue == expected_residue and 0 < max_t < residue < 81,
                ("every positive t in the interval excluded", gap))
        rows.append({
            "b4": gap, "t_minimum": 1, "t_maximum": max_t,
            "coefficient_mod_81": coefficient, "rhs_mod_81": rhs,
            "inverse_mod_81": inverse, "required_t_mod_81": residue,
            "all_positive_t_in_interval_excluded": True,
        })
    require(max(6**92, 9 * 2**149, 2**142).bit_length() < 1024,
            "fixed arithmetic budget")
    print(json.dumps({
        "status": "PASS_PAPER_D4_EQ_96",
        "scope": {
            "N": "positive odd", "height_guard": "N+1<2^92",
            "a1_inclusive": [3, 69], "D3_upper": 92, "D4": 96,
        },
        "conclusion": "D5<=237, hence 2^D5<=6^92",
        "same_source_tail_bound": "0<R4=E4/2^k4<2^95",
        "counterassumption_terminal": "y4=t*2^142; t positive integer, possibly even",
        "last_gap_b_ge_4": "EXCLUDED_BY_SIZE_WITHOUT_TRUNCATION",
        "last_gap_small_cases": rows,
        "exact_constant": {
            "3_power_94": 3**94, "2_power_149": 2**149,
            "strict_positive_margin": 2**149 - 3**94,
        },
        "original_N_constructed": False,
        "physical_counterexample_claimed": False,
        "physical_sources_replayed": 0,
        "congruence_projections_over_seeds": 0,
        "seed_or_orbit_sweeps": 0,
        "A70_A71_executed": False,
        "a1_le_2_executed": False,
        "H146_executed": False,
        "lean_executed": False,
        "parent_contrast_sha256": PINS,
        "verifier_sha256": sha256(Path(__file__).read_bytes()).hexdigest(),
        "preregistration_sha256": sha256((HERE / "PREREGISTRO.md").read_bytes()).hexdigest(),
        "elapsed_seconds": round(perf_counter() - started, 6),
    }, indent=2))


if __name__ == "__main__":
    main()
