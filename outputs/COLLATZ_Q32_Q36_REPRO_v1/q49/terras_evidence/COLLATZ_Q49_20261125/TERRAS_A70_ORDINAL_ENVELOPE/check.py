#!/usr/bin/env python3
"""One integer contrast of a symbolic envelope: no orbital search."""
from hashlib import sha256
import json
from pathlib import Path
from time import perf_counter

HERE = Path(__file__).resolve().parent
EXPERIMENTS = HERE.parents[1]
PINS = {
    "COLLATZ_Q37_20261125/TERRAS89_PAPER/RESULTADO.md":
        "0a05ccf474ef53154ed9fc74d2e65791ccdc23313f6ea073549a834f8aa5390b",
    "COLLATZ_Q44_20261125/TERRAS89_D3_HIGH/PODA_COMPLEMENTO.md":
        "941fdf9b3a67f36619b59fa0a211305a66d52e6d26398a56fd1ac0a9f9362eef",
    "COLLATZ_Q49_20261125/TERRAS/A71_HIGH_GAPS/RECIBO_UNION.json":
        "af39a42368204b9b0d8e96d20d7bd58e97acd9ce7139d3d489e9f0ca5035c776",
}


def require(condition, context):
    if not condition:
        raise ArithmeticError(context)


def main():
    started = perf_counter()
    for name, expected in PINS.items():
        require(sha256((EXPERIMENTS / name).read_bytes()).hexdigest() == expected,
                ("pinned scope SHA256", name))
    threshold = 6**92
    product_three = (3**70 + 1) * (3**21 + 1)
    fifth_envelope = 2**90 * product_three * (3**143 + 1)
    old_d4_envelope = 2**92 * 3**92
    old_d5_envelope = 2**92 * 3**237
    require(2**237 <= threshold < 2**238, "target D5<=237")
    require(2**144 < product_three < 2**145, "a4<=143 from y3<product/2")
    require(2**460 < fifth_envelope < 2**461, "new D5<=460")
    require(2**237 < old_d4_envelope < 2**238, "old D4<=237")
    require(2**467 < old_d5_envelope < 2**468, "old scalar D5<=467")

    # This is NOT a physical trajectory, nor a claimed source.
    # It is an admissible tuple of the relaxed inequalities being audited.
    rises = (70, 1, 21, 143, 3)
    totals = []
    total = 0
    for rise in rises:
        total += rise
        totals.append(total)
    require(totals == [70, 71, 92, 235, 238], "abstract tuple clocks")
    require(totals[2] <= 92 < totals[3] and 2**totals[-1] > threshold,
            "abstract tuple passes domain lengths but violates target")
    prefix_product = 1
    prefix_checks = []
    for j in range(1, 5):
        prefix_product *= 3**rises[j - 1] + 1
        left = 2**(totals[j] + j)
        right = 2**92 * prefix_product
        require(left < right, ("relaxed physical-envelope inequality", j))
        prefix_checks.append({
            "j": j, "D_next": totals[j],
            "lhs": left, "rhs": right, "strict_inequality": True})
    require(max(threshold, product_three, fifth_envelope,
                old_d5_envelope, *(x["rhs"] for x in prefix_checks)).bit_length() < 1024,
            "fixed arithmetic budget")

    print(json.dumps({
        "status": "PASS_PAPER_ENVELOPE_WITH_EXACT_ARITHMETIC",
        "band_closure": "STOP_ENVELOPE_INSUFFICIENT",
        "scope": {"H": 92, "a1": 70, "residual": "D3<=92<D4"},
        "target_D5_upper": 237,
        "derived_a4_upper": 143,
        "derived_D4_upper": 235,
        "derived_D5_upper": 460,
        "old_scalar_D5_upper": 467,
        "product_three": product_three,
        "strict_upper_for_2_power_D5": fifth_envelope,
        "abstract_only_rises": rises,
        "abstract_only_totals": totals,
        "abstract_prefix_checks": prefix_checks,
        "abstract_tuple_is_physical_witness": False,
        "physical_sources_replayed": 0,
        "congruence_projections": 0,
        "orbital_sweeps": 0,
        "A71_executed": False,
        "H146_executed": False,
        "lean_executed": False,
        "source_changes_to_parents": False,
        "parent_scope_sha256": PINS,
        "verifier_sha256": sha256(Path(__file__).read_bytes()).hexdigest(),
        "preregistration_sha256": sha256((HERE / "PREREGISTRO.md").read_bytes()).hexdigest(),
        "elapsed_seconds": round(perf_counter() - started, 6),
    }, indent=2))


if __name__ == "__main__":
    main()
