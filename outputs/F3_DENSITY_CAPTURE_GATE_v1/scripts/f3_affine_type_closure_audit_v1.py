#!/usr/bin/env python3
"""Audit fixed-modulus closure of the F3 affine child maps.

For a tracked parent a == 2, 5, or 8 (mod 9), the KL row uses

* retarded child 4a;
* D1 (class 2): parity-lifted advanced child 2(2a-1)/3;
* D2 (class 5): no advanced child in the retained EL row;
* D3 (class 8): direct advanced child (2a-1)/3.

The audit asks whether a parent residue modulo a fixed M determines the child
residue modulo the same M.  It enumerates the three lifts modulo 3M.  This is
a finite algebraic type-closure check, not an orbit or density experiment.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
from pathlib import Path


TRACKED_CLASSES = (2, 5, 8)


def file_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def advanced_child(a: int, parent_class: int) -> int | None:
    if parent_class == 5:
        return None
    numerator = 2 * a - 1
    if numerator % 3 != 0:
        raise AssertionError(f"nonintegral advanced child for a={a}")
    direct = numerator // 3
    return 2 * direct if parent_class == 2 else direct


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--min-k", type=int, default=2)
    parser.add_argument("--max-k", type=int, default=7)
    parser.add_argument("--max-l", type=int, default=5)
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=Path("results/F3_AFFINE_TYPE_CLOSURE_AUDIT_v1"),
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    if args.min_k < 2 or args.max_k < args.min_k or args.max_l < 0:
        raise ValueError("expected 2 <= min-k <= max-k and max-l >= 0")

    output_dir: Path = args.output_dir
    output_dir.mkdir(parents=True, exist_ok=True)
    grid_path = output_dir / "grid.csv"
    witnesses_path = output_dir / "nonclosure_witnesses.csv"
    summary_path = output_dir / "summary.json"
    manifest_path = output_dir / "manifest_sha256.csv"

    grid_fields = [
        "k3",
        "l2",
        "modulus",
        "parent_class_mod9",
        "parent_type_count",
        "retarded_deterministic_types",
        "advanced_absent_types",
        "advanced_deterministic_types",
        "advanced_three_image_types",
        "advanced_other_image_types",
        "fixed_modulus_closure",
    ]
    witness_fields = [
        "k3",
        "l2",
        "modulus",
        "parent_class_mod9",
        "parent_residue_mod_M",
        "lift_0",
        "lift_1",
        "lift_2",
        "child_0_mod_M",
        "child_1_mod_M",
        "child_2_mod_M",
        "distinct_child_types",
    ]

    grid_rows: list[dict[str, object]] = []
    witness_rows: list[dict[str, object]] = []
    unexpected_rows = 0

    for k3 in range(args.min_k, args.max_k + 1):
        for l2 in range(args.max_l + 1):
            modulus = (3**k3) * (2**l2)
            for parent_class in TRACKED_CLASSES:
                parent_residues = [
                    residue
                    for residue in range(modulus)
                    if residue % 9 == parent_class
                ]
                retarded_deterministic = 0
                advanced_absent = 0
                advanced_deterministic = 0
                advanced_three_image = 0
                advanced_other_image = 0
                first_witness: dict[str, object] | None = None

                for residue in parent_residues:
                    lifts = [residue + t * modulus for t in range(3)]
                    retarded_images = {(4 * a) % modulus for a in lifts}
                    if len(retarded_images) == 1:
                        retarded_deterministic += 1

                    children = [advanced_child(a, parent_class) for a in lifts]
                    if children == [None, None, None]:
                        advanced_absent += 1
                        continue

                    child_images = {int(child) % modulus for child in children if child is not None}
                    if len(child_images) == 1:
                        advanced_deterministic += 1
                    elif len(child_images) == 3:
                        advanced_three_image += 1
                        if first_witness is None:
                            first_witness = {
                                "k3": k3,
                                "l2": l2,
                                "modulus": modulus,
                                "parent_class_mod9": parent_class,
                                "parent_residue_mod_M": residue,
                                "lift_0": lifts[0],
                                "lift_1": lifts[1],
                                "lift_2": lifts[2],
                                "child_0_mod_M": int(children[0]) % modulus,
                                "child_1_mod_M": int(children[1]) % modulus,
                                "child_2_mod_M": int(children[2]) % modulus,
                                "distinct_child_types": len(child_images),
                            }
                    else:
                        advanced_other_image += 1

                fixed_modulus_closure = (
                    retarded_deterministic == len(parent_residues)
                    and (
                        advanced_absent == len(parent_residues)
                        or advanced_deterministic == len(parent_residues)
                    )
                )
                if parent_class in (2, 8):
                    expected = (
                        retarded_deterministic == len(parent_residues)
                        and advanced_three_image == len(parent_residues)
                        and not fixed_modulus_closure
                        and advanced_other_image == 0
                    )
                else:
                    expected = (
                        retarded_deterministic == len(parent_residues)
                        and advanced_absent == len(parent_residues)
                        and fixed_modulus_closure
                    )
                if not expected:
                    unexpected_rows += 1

                grid_rows.append(
                    {
                        "k3": k3,
                        "l2": l2,
                        "modulus": modulus,
                        "parent_class_mod9": parent_class,
                        "parent_type_count": len(parent_residues),
                        "retarded_deterministic_types": retarded_deterministic,
                        "advanced_absent_types": advanced_absent,
                        "advanced_deterministic_types": advanced_deterministic,
                        "advanced_three_image_types": advanced_three_image,
                        "advanced_other_image_types": advanced_other_image,
                        "fixed_modulus_closure": "yes" if fixed_modulus_closure else "no",
                    }
                )
                if first_witness is not None:
                    witness_rows.append(first_witness)

    with grid_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=grid_fields)
        writer.writeheader()
        writer.writerows(grid_rows)

    with witnesses_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=witness_fields)
        writer.writeheader()
        writer.writerows(witness_rows)

    d1_d3_rows = [row for row in grid_rows if row["parent_class_mod9"] in (2, 8)]
    d2_rows = [row for row in grid_rows if row["parent_class_mod9"] == 5]
    summary = {
        "status": "PASS" if unexpected_rows == 0 else "FAIL",
        "classification": "FIXED_MODULUS_NONCLOSURE_CONFIRMED",
        "parameters": {
            "k3_range": [args.min_k, args.max_k],
            "l2_range": [0, args.max_l],
            "modulus_formula": "3^k3 * 2^l2",
            "tracked_parent_classes_mod9": list(TRACKED_CLASSES),
        },
        "results": {
            "grid_rows": len(grid_rows),
            "unexpected_rows": unexpected_rows,
            "d1_d3_rows": len(d1_d3_rows),
            "d1_d3_nonclosed_rows": sum(
                row["fixed_modulus_closure"] == "no" for row in d1_d3_rows
            ),
            "d1_d3_all_parent_types_have_three_advanced_images": all(
                row["advanced_three_image_types"] == row["parent_type_count"]
                for row in d1_d3_rows
            ),
            "d2_rows": len(d2_rows),
            "d2_closed_single_branch_rows": sum(
                row["fixed_modulus_closure"] == "yes" for row in d2_rows
            ),
            "representative_nonclosure_witnesses": len(witness_rows),
        },
        "algebraic_explanation": {
            "direct_advanced_lift_step": "c(a+tM) = c(a) + 2tM/3",
            "d1_lifted_advanced_step": "2c(a+tM) = 2c(a) + 4tM/3",
            "consequence": "for t=0,1,2 the child residues modulo M are three distinct types",
        },
        "interpretation": {
            "proved_by_finite_audit": "fixed residue modulo M does not determine the D1/D3 advanced child residue modulo M",
            "not_proved": "no finite-state weighted or nondeterministic closure exists",
            "remaining_route": "dynamic 3-adic prefix refinement plus a certified tail/redistribution lemma",
        },
        "outputs": {
            "grid_csv": str(grid_path),
            "nonclosure_witnesses_csv": str(witnesses_path),
            "summary_json": str(summary_path),
            "manifest_sha256_csv": str(manifest_path),
        },
        "no_claims": {
            "no_density_theorem": True,
            "no_asymptotic_claim": True,
            "no_global_collatz_claim": True,
            "no_lean": True,
        },
    }
    summary_path.write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )

    manifest_inputs = [Path(__file__).resolve(), grid_path, witnesses_path, summary_path]
    with manifest_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=["path", "sha256", "bytes"])
        writer.writeheader()
        for path in manifest_inputs:
            writer.writerow(
                {
                    "path": str(path),
                    "sha256": file_sha256(path),
                    "bytes": path.stat().st_size,
                }
            )

    print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
