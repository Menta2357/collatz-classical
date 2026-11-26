#!/usr/bin/env python3
"""One constant check of the D4=95 proof; no seed or orbit enumeration."""
from fractions import Fraction as F
from hashlib import sha256
import json
from pathlib import Path
from time import perf_counter

HERE = Path(__file__).resolve().parent
EXPERIMENTS = HERE.parents[1]
PINS = {
    "COLLATZ_Q49_20261125/TERRAS_A70_ORDINAL_ENVELOPE/RESULTADO.md":
        "ed8ca02d87cccae1f3bfc67bef2262ba7f76d095bb085f6a0b455e5711784e4c",
    "COLLATZ_Q49_20261125/TERRAS_A70_ORDINAL_ENVELOPE/RECIBO_COROLARIO94.json":
        "5404e36eff859e47b1cf20a92b853047c0554eb131e5aeb14c2763f2bfcc61fb",
}


def require(condition, context):
    if not condition:
        raise ArithmeticError(context)


def main():
    started = perf_counter()
    for name, pin in PINS.items():
        require(sha256((EXPERIMENTS / name).read_bytes()).hexdigest() == pin,
                ("parent pin", name))
    require(2**237 <= 6**92 < 2**238, "target integer threshold")
    require(3**95 < 2**151, "short-gap height")
    high_left = 252 * (3**90 + 1)
    high_right = 25 * 2**146
    require(high_left < high_right, "long-gap coefficient")
    require(F(1, 3) < F(9, 25) and F(17, 56) < F(9, 25)
            and F(5, 14) < F(9, 25), "single long-gap constants")
    require(F(3, 5)**2 == F(9, 25), "two strong gaps")
    require(F(2, 5) * F(25, 28) == F(5, 14), "a=2 fusion correction")
    geometric = 3 * sum(F(4, 3)**j for j in range(4))
    require(geometric == F(175, 9) and 175 < 9 * 27,
            "short-gap additive bound")

    # Necessary values under a supposed violation when all four b_i=1.
    # No original seed N is constructed or claimed.
    forced_y4 = 2**143
    forced_power = 2 * forced_y4 - 1
    require(pow(2, 144, 81) == 55, "first reverse residue")
    require(forced_power % 27 == 0 and forced_power % 81 != 0,
            "v3(2^144-1)=3")
    forced_u4 = forced_power // 27
    forced_y3 = 8 * forced_u4
    forced_x3 = forced_y3 - 1
    require(forced_u4 % 2 == 1 and forced_x3 % 2 == 1,
            "forced fourth-run valuation")
    required_third_peak_plus_one = 2 * forced_x3 + 1
    require(2**148 - 43 == 27 * required_third_peak_plus_one,
            "same backward edge")
    require((pow(2, 148, 81) - 43) % 81 == 27
            and required_third_peak_plus_one % 3 == 1,
            "third physical block impossible")
    require(max(high_right, forced_y4, 6**92).bit_length() < 1024,
            "fixed arithmetic budget")
    print(json.dumps({
        "status": "PASS_PAPER_D4_EQ_95",
        "scope": {
            "N": "positive odd", "height_guard": "N+1<2^92",
            "a1_minimum": 3, "D3_upper": 92, "D4": 95,
            "a1_upper_implied_by_D3": 90,
        },
        "conclusion": "D5<=237, hence 2^D5<=6^92",
        "coverage_cases": ["B4=4", "B4=5", "B4>=6"],
        "target_D5_upper": 237,
        "high_gap_factor": "9/25",
        "high_gap_comparison": {
            "lhs": high_left, "rhs": high_right,
            "strict_positive_margin": high_right - high_left,
        },
        "short_gap_additive_constant": str(geometric),
        "forced_values_under_negation_only": {
            "y4": forced_y4, "u4": forced_u4, "y3": forced_y3,
            "x3": forced_x3,
            "required_third_peak_plus_one": required_third_peak_plus_one,
            "last_value_mod_3": required_third_peak_plus_one % 3,
            "original_N_constructed": False,
            "physical_witness": False,
        },
        "map": "shortcut S, not accelerated odd-return map",
        "source": "same original N in both affine books",
        "physical_sources_replayed": 0,
        "congruence_projections": 0,
        "orbital_sweeps": 0,
        "A70_batch_executed": False,
        "H146_executed": False,
        "lean_executed": False,
        "parent_sha256": PINS,
        "verifier_sha256": sha256(Path(__file__).read_bytes()).hexdigest(),
        "preregistration_sha256": sha256((HERE / "PREREGISTRO.md").read_bytes()).hexdigest(),
        "elapsed_seconds": round(perf_counter() - started, 6),
    }, indent=2))


if __name__ == "__main__":
    main()
