#!/usr/bin/env python3
"""Validate the KL2003 F2 k=3 certificate JSON schema.

This is a format checker only.  It does not verify KL2003 mathematics, does
not solve an LP, does not generate k=3 rows, and does not open Lean.
"""

from __future__ import annotations

import csv
import hashlib
import json
import re
import sys
import argparse
from dataclasses import dataclass
from datetime import datetime, timezone
from math import gcd
from pathlib import Path
from typing import Any


RUN_ID = "KL2003_F2_K3_CERTIFICATE_SCHEMA_VALIDATION_v1"
SCHEMA_V2 = "KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2"
SCHEMA_V21 = "KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2_1"
SUPPORTED_SCHEMA_VERSIONS = {SCHEMA_V2, SCHEMA_V21}
REPO_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_INPUT = (
    REPO_ROOT
    / "outputs"
    / "KL2003_F2_K3_CERTIFICATE_FIXTURE_v1"
    / "kl2003_k3_certificate.fixture.json"
)
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID

RATIONAL_RE = re.compile(r"^-?(0|[1-9][0-9]*)(/([1-9][0-9]*))?$")

TOP_LEVEL_REQUIRED = [
    "metadata",
    "tracked_classes",
    "rows",
    "inverse_words",
    "deletion_marks",
    "rational_certificate",
    "slacks",
    "verification_targets",
]

METADATA_FLAGS_REQUIRED = [
    "schema_version",
    "k",
    "tracked_class_count",
    "pre_reduction_class_count",
    "artifact_links",
]

ROW_REQUIRED = [
    "row_id",
    "source_class",
    "row_kind",
    "children",
    "deletion_policy",
    "coefficient_terms",
    "target_bound",
    "slack_id",
]

CHILD_REQUIRED = [
    "child_id",
    "inverse_word",
    "target_class",
    "shift",
    "window_policy",
    "fiber_parent",
    "deleted",
    "reason",
]

RATIONAL_KEY_TOKENS = {
    "value",
    "target_bound",
    "lo",
    "hi",
    "lhs",
    "rhs",
    "slack",
    "shift",
    "k",
    "modulus",
    "representative",
    "pre_reduction_class_count",
    "tracked_class_count",
    "denominator_bits",
    "numerator_bits",
    "depth",
}

V21_TOP_LEVEL_REQUIRED = [
    "nodes",
    "nested_blocks",
    "post_deletion_edges",
    "sibling_disjointness_groups",
    "overlap_guards",
    "source_refs",
    "termination_policy",
]

V21_NODE_STATUSES = {"counted", "deleted", "terminal", "expanded"}
V21_BLOCK_KINDS = {"min", "sum", "row", "auxiliary"}


@dataclass
class ValidationIssue:
    severity: str
    path: str
    code: str
    message: str


def repo_rel(path: Path) -> str:
    try:
        return str(path.resolve().relative_to(REPO_ROOT))
    except ValueError:
        return str(path)


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def add_issue(
    issues: list[ValidationIssue],
    severity: str,
    path: str,
    code: str,
    message: str,
) -> None:
    issues.append(ValidationIssue(severity=severity, path=path, code=code, message=message))


def count_floats(obj: Any) -> int:
    if isinstance(obj, float):
        return 1
    if isinstance(obj, dict):
        return sum(count_floats(value) for value in obj.values())
    if isinstance(obj, list):
        return sum(count_floats(value) for value in obj)
    return 0


def rational_string_ok(value: str) -> bool:
    if not RATIONAL_RE.fullmatch(value):
        return False
    if value == "-0":
        return False
    if "/" not in value:
        return True
    numerator_text, denominator_text = value.split("/", 1)
    numerator = int(numerator_text)
    denominator = int(denominator_text)
    if denominator <= 0:
        return False
    if numerator == 0:
        return False
    if denominator == 1:
        return False
    return gcd(abs(numerator), denominator) == 1


def check_required_fields(
    obj: Any,
    fields: list[str],
    prefix: str,
    issues: list[ValidationIssue],
) -> None:
    if not isinstance(obj, dict):
        add_issue(issues, "error", prefix, "TYPE_NOT_OBJECT", "Expected object.")
        return
    for field in fields:
        if field not in obj:
            add_issue(issues, "error", f"{prefix}.{field}", "MISSING_REQUIRED_FIELD", "Required field is missing.")


def parse_canonical_nonnegative_int(value: Any) -> int | None:
    if not isinstance(value, str):
        return None
    if not rational_string_ok(value):
        return None
    if "/" in value or value.startswith("-"):
        return None
    return int(value)


def check_metadata_version_and_counts(metadata: Any, issues: list[ValidationIssue]) -> None:
    if not isinstance(metadata, dict):
        return
    schema_version = metadata.get("schema_version")
    if schema_version not in SUPPORTED_SCHEMA_VERSIONS:
        add_issue(
            issues,
            "error",
            "$.metadata.schema_version",
            "SCHEMA_VERSION_UNSUPPORTED",
            f"Expected one of {sorted(SUPPORTED_SCHEMA_VERSIONS)}.",
        )

    k = parse_canonical_nonnegative_int(metadata.get("k"))
    tracked = parse_canonical_nonnegative_int(metadata.get("tracked_class_count"))
    pre_reduction = parse_canonical_nonnegative_int(metadata.get("pre_reduction_class_count"))
    if k is None or k < 1:
        add_issue(issues, "error", "$.metadata.k", "K_INVALID", "Expected positive canonical integer string.")
        return
    if tracked is None:
        add_issue(
            issues,
            "error",
            "$.metadata.tracked_class_count",
            "TRACKED_CLASS_COUNT_INVALID",
            "Expected canonical integer string.",
        )
    elif tracked != 3 ** (k - 1):
        add_issue(
            issues,
            "error",
            "$.metadata.tracked_class_count",
            "TRACKED_CLASS_COUNT_MISMATCH",
            f"Expected 3^(k-1) = {3 ** (k - 1)} for k={k}.",
        )
    if pre_reduction is None:
        add_issue(
            issues,
            "error",
            "$.metadata.pre_reduction_class_count",
            "PRE_REDUCTION_CLASS_COUNT_INVALID",
            "Expected canonical integer string.",
        )
    elif pre_reduction != 3**k:
        add_issue(
            issues,
            "error",
            "$.metadata.pre_reduction_class_count",
            "PRE_REDUCTION_CLASS_COUNT_MISMATCH",
            f"Expected 3^k = {3**k} for k={k}.",
        )


def check_artifact_links(metadata: Any, issues: list[ValidationIssue]) -> None:
    if not isinstance(metadata, dict):
        return
    links = metadata.get("artifact_links")
    if not isinstance(links, dict):
        add_issue(issues, "error", "$.metadata.artifact_links", "ARTIFACT_LINKS_INVALID", "Expected object.")
        return
    required = [
        "json_artifact",
        "lean_data_artifact",
        "json_to_lean_generator",
        "json_sha256",
        "lean_data_sha256",
        "json_to_lean_generator_sha256",
    ]
    for key in required:
        if key not in links:
            add_issue(
                issues,
                "error",
                f"$.metadata.artifact_links.{key}",
                "MISSING_ARTIFACT_LINK_FIELD",
                "Required artifact-link field is missing.",
            )


def check_rational_strings(obj: Any, issues: list[ValidationIssue], path: str = "$") -> None:
    if isinstance(obj, dict):
        for key, value in obj.items():
            child_path = f"{path}.{key}"
            if key in RATIONAL_KEY_TOKENS:
                symbolic_constant_allowed = (
                    key == "value"
                    and isinstance(value, str)
                    and isinstance(obj.get("kind"), str)
                    and obj.get("kind") in {"exponent", "base_constant"}
                    and not rational_string_ok(value)
                )
                symbolic_shift_allowed = (
                    key == "shift"
                    and isinstance(value, str)
                    and ("alpha" in value or value.startswith("shift"))
                )
                if symbolic_constant_allowed or symbolic_shift_allowed:
                    check_rational_strings(value, issues, child_path)
                    continue
                if not isinstance(value, str):
                    add_issue(
                        issues,
                        "error",
                        child_path,
                        "RATIONAL_NOT_STRING",
                        "Rational-like field must be encoded as a string.",
                    )
                elif not rational_string_ok(value):
                    add_issue(
                        issues,
                        "error",
                        child_path,
                        "RATIONAL_BAD_FORMAT",
                        "Expected integer string or num/den with nonzero denominator.",
                    )
            check_rational_strings(value, issues, child_path)
    elif isinstance(obj, list):
        for idx, value in enumerate(obj):
            check_rational_strings(value, issues, f"{path}[{idx}]")


def collect_ids(items: Any, id_key: str, prefix: str, issues: list[ValidationIssue]) -> dict[str, str]:
    ids: dict[str, str] = {}
    if not isinstance(items, list):
        add_issue(issues, "error", prefix, "TYPE_NOT_ARRAY", "Expected array.")
        return ids
    for idx, item in enumerate(items):
        path = f"{prefix}[{idx}]"
        if not isinstance(item, dict):
            add_issue(issues, "error", path, "TYPE_NOT_OBJECT", "Expected object.")
            continue
        value = item.get(id_key)
        if not isinstance(value, str) or not value:
            add_issue(issues, "error", f"{path}.{id_key}", "MISSING_ID", f"Missing string id field `{id_key}`.")
            continue
        if value in ids:
            add_issue(issues, "error", f"{path}.{id_key}", "DUPLICATE_ID", f"Duplicate id `{value}`.")
        else:
            ids[value] = path
    return ids


def child_signature(child: dict[str, Any]) -> tuple[Any, ...]:
    return tuple((key, json.dumps(child.get(key), sort_keys=True)) for key in CHILD_REQUIRED)


def artifact_hash_fields(data: Any) -> dict[str, Any]:
    if not isinstance(data, dict):
        return {}
    metadata = data.get("metadata")
    if not isinstance(metadata, dict):
        return {}
    links = metadata.get("artifact_links")
    if not isinstance(links, dict):
        return {}
    keys = [
        "json_artifact",
        "lean_data_artifact",
        "json_to_lean_generator",
        "json_sha256",
        "lean_data_sha256",
        "json_to_lean_generator_sha256",
    ]
    return {key: links.get(key) for key in keys if key in links}


def classify_input(data: Any, input_path: Path) -> str:
    if input_path.name.endswith(".fixture.json"):
        return "fixture"
    if isinstance(data, dict):
        metadata = data.get("metadata")
        if isinstance(metadata, dict):
            if metadata.get("schema_version") == SCHEMA_V21:
                if metadata.get("proposal_only") is True:
                    return "row28_nested_v21_proposal"
                return "nested_v21_generated_or_fixture"
            if (
                metadata.get("k") == "2"
                and metadata.get("generator_mode") == "k2_regression"
                and metadata.get("mathematical_content") == "baseline_reemission_only"
            ):
                return "generated_k2_regression"
    return "generated_or_unknown"


def check_fixture_flags(metadata: Any, issues: list[ValidationIssue]) -> None:
    check_required_fields(
        metadata,
        ["fixture_only", "mathematical_content", "not_for_lean_import"],
        "$.metadata",
        issues,
    )
    if not isinstance(metadata, dict):
        return
    if metadata.get("fixture_only") is not True:
        add_issue(issues, "error", "$.metadata.fixture_only", "FIXTURE_FLAG_INVALID", "Fixture file requires fixture_only=true.")
    if metadata.get("mathematical_content") is not False:
        add_issue(
            issues,
            "error",
            "$.metadata.mathematical_content",
            "FIXTURE_FLAG_INVALID",
            "Fixture file requires mathematical_content=false.",
        )
    if metadata.get("not_for_lean_import") is not True:
        add_issue(
            issues,
            "error",
            "$.metadata.not_for_lean_import",
            "FIXTURE_FLAG_INVALID",
            "Fixture file requires not_for_lean_import=true.",
        )


def check_generated_k2_regression(data: dict[str, Any], issues: list[ValidationIssue]) -> None:
    metadata = data.get("metadata")
    if not isinstance(metadata, dict):
        return

    expected_metadata = {
        "schema_version": SCHEMA_V2,
        "k": "2",
        "tracked_class_count": "3",
        "pre_reduction_class_count": "9",
        "generator_mode": "k2_regression",
        "mathematical_content": "baseline_reemission_only",
    }
    for key, expected in expected_metadata.items():
        if metadata.get(key) != expected:
            add_issue(
                issues,
                "error",
                f"$.metadata.{key}",
                "GENERATED_K2_METADATA_MISMATCH",
                f"Expected `{expected}` for generated k2 regression input.",
            )

    links = metadata.get("artifact_links")
    if isinstance(links, dict):
        for key in ["json_sha256", "lean_data_sha256", "json_to_lean_generator_sha256"]:
            value = links.get(key)
            if not isinstance(value, str) or not value:
                add_issue(
                    issues,
                    "error",
                    f"$.metadata.artifact_links.{key}",
                    "GENERATED_K2_CROSS_HASH_FIELD_MISSING",
                    "Generated k2 regression artifact must report cross-hash fields.",
                )

    rows = data.get("rows")
    if not isinstance(rows, list) or not rows:
        add_issue(issues, "error", "$.rows", "GENERATED_K2_ROWS_MISSING", "Generated k2 regression artifact requires rows.")
    else:
        row_ids = [row.get("row_id") for row in rows if isinstance(row, dict)]
        for row_id in ["row22", "row25", "row28", "M1V3"]:
            if row_id not in row_ids:
                add_issue(
                    issues,
                    "error",
                    "$.rows",
                    "GENERATED_K2_ROW_ID_MISSING",
                    f"Generated k2 regression artifact must include `{row_id}`.",
                )
        m1_rows = [row for row in rows if isinstance(row, dict) and row.get("row_id") == "M1V3"]
        if not m1_rows:
            add_issue(issues, "error", "$.rows", "M1V3_ROW_MISSING", "M1V3 row is required.")
        else:
            expected_shape = str(m1_rows[0].get("baseline", {}).get("expected_shape", ""))
            if "phi25" not in expected_shape:
                add_issue(
                    issues,
                    "error",
                    "$.rows[row_id=M1V3].baseline.expected_shape",
                    "M1V3_PHI25_NOT_RECORDED",
                    "M1V3 must record phi25 as the source-faithful second arm.",
                )
            if "phi22" in expected_shape:
                add_issue(
                    issues,
                    "error",
                    "$.rows[row_id=M1V3].baseline.expected_shape",
                    "M1V3_REPLACED_BY_PHI22",
                    "M1V3 expected shape must not replace phi25 with phi22.",
                )

    rational_certificate = data.get("rational_certificate")
    constants = []
    if isinstance(rational_certificate, dict):
        constants = rational_certificate.get("coefficient_intervals", [])
    if not isinstance(constants, list) or not constants:
        add_issue(
            issues,
            "error",
            "$.rational_certificate.coefficient_intervals",
            "GENERATED_K2_CONSTANTS_MISSING",
            "Generated k2 regression artifact requires baseline constants.",
        )
    else:
        constant_ids = [constant.get("coefficient_id") for constant in constants if isinstance(constant, dict)]
        for constant_id in [
            "lambda",
            "gammaK2",
            "DeltaV2",
            "c22",
            "c25",
            "c28",
            "L2NT_D1_slack",
            "L2NT_D2_slack",
            "L2NT_D3_slack",
        ]:
            if constant_id not in constant_ids:
                add_issue(
                    issues,
                    "error",
                    "$.rational_certificate.coefficient_intervals",
                    "GENERATED_K2_CONSTANT_MISSING",
                    f"Missing baseline constant `{constant_id}`.",
                )
        for constant in constants:
            if not isinstance(constant, dict):
                continue
            if constant.get("kind") in {"lambda", "row_coefficient", "slack"}:
                value = constant.get("value")
                if not isinstance(value, str) or not rational_string_ok(value):
                    add_issue(
                        issues,
                        "error",
                        "$.rational_certificate.coefficient_intervals.value",
                        "GENERATED_K2_RATIONAL_CONSTANT_NOT_CANONICAL",
                        f"Constant `{constant.get('coefficient_id')}` must be a canonical rational string.",
                    )


def schema_version(data: Any) -> str | None:
    if not isinstance(data, dict):
        return None
    metadata = data.get("metadata")
    if not isinstance(metadata, dict):
        return None
    value = metadata.get("schema_version")
    return value if isinstance(value, str) else None


def nested_children(block: dict[str, Any]) -> list[dict[str, Any]]:
    children = block.get("children", block.get("operands", []))
    return children if isinstance(children, list) else []


def operand_block_refs(obj: Any) -> list[str]:
    refs: list[str] = []
    if isinstance(obj, dict):
        ref = obj.get("block_ref")
        if isinstance(ref, str):
            refs.append(ref)
        for value in obj.values():
            refs.extend(operand_block_refs(value))
    elif isinstance(obj, list):
        for value in obj:
            refs.extend(operand_block_refs(value))
    return refs


def operand_node_refs(obj: Any) -> list[str]:
    refs: list[str] = []
    if isinstance(obj, dict):
        ref = obj.get("node_ref")
        if isinstance(ref, str):
            refs.append(ref)
        for value in obj.values():
            refs.extend(operand_node_refs(value))
    elif isinstance(obj, list):
        for value in obj:
            refs.extend(operand_node_refs(value))
    return refs


def collect_v21_nodes(data: dict[str, Any], issues: list[ValidationIssue]) -> dict[str, dict[str, Any]]:
    nodes = data.get("nodes", [])
    result: dict[str, dict[str, Any]] = {}
    if not isinstance(nodes, list):
        add_issue(issues, "error", "$.nodes", "V21_NODES_NOT_ARRAY", "v2.1 requires nodes as an array.")
        return result
    for idx, node in enumerate(nodes):
        path = f"$.nodes[{idx}]"
        if not isinstance(node, dict):
            add_issue(issues, "error", path, "V21_NODE_NOT_OBJECT", "Node must be an object.")
            continue
        node_id = node.get("node_id")
        if not isinstance(node_id, str) or not node_id:
            add_issue(issues, "error", f"{path}.node_id", "V21_NODE_ID_MISSING", "Node requires a node_id.")
            continue
        if node_id in result:
            add_issue(issues, "error", f"{path}.node_id", "V21_DUPLICATE_NODE_ID", f"Duplicate node_id `{node_id}`.")
        result[node_id] = node
        status = node.get("node_status")
        if status not in V21_NODE_STATUSES:
            add_issue(
                issues,
                "error",
                f"{path}.node_status",
                "V21_NODE_STATUS_INVALID",
                f"Expected one of {sorted(V21_NODE_STATUSES)}.",
            )
        if status == "deleted" and node.get("contributes_to_cardinality") is True:
            add_issue(
                issues,
                "error",
                f"{path}.contributes_to_cardinality",
                "V21_DELETED_NODE_CONTRIBUTES",
                "Deleted nodes must not contribute directly to cardinality.",
            )
    return result


def collect_v21_blocks(data: dict[str, Any], issues: list[ValidationIssue]) -> dict[str, dict[str, Any]]:
    blocks = data.get("nested_blocks", [])
    result: dict[str, dict[str, Any]] = {}
    if not isinstance(blocks, list):
        add_issue(issues, "error", "$.nested_blocks", "V21_NESTED_BLOCKS_NOT_ARRAY", "v2.1 requires nested_blocks as an array.")
        return result
    for idx, block in enumerate(blocks):
        path = f"$.nested_blocks[{idx}]"
        if not isinstance(block, dict):
            add_issue(issues, "error", path, "V21_BLOCK_NOT_OBJECT", "Nested block must be an object.")
            continue
        block_id = block.get("block_id")
        if not isinstance(block_id, str) or not block_id:
            add_issue(issues, "error", f"{path}.block_id", "V21_BLOCK_ID_MISSING", "Nested block requires block_id.")
            continue
        if block_id in result:
            add_issue(issues, "error", f"{path}.block_id", "V21_DUPLICATE_BLOCK_ID", f"Duplicate block_id `{block_id}`.")
        result[block_id] = block
        kind = block.get("block_kind", block.get("operator"))
        if kind not in V21_BLOCK_KINDS:
            add_issue(
                issues,
                "error",
                f"{path}.block_kind",
                "V21_BLOCK_KIND_INVALID",
                f"Expected one of {sorted(V21_BLOCK_KINDS)}.",
            )
        if not nested_children(block):
            add_issue(issues, "error", f"{path}.children", "V21_BLOCK_CHILDREN_MISSING", "Nested block requires children/operands.")
    return result


def check_v21_block_refs(blocks: dict[str, dict[str, Any]], issues: list[ValidationIssue]) -> None:
    for block_id, block in blocks.items():
        for ref in operand_block_refs(nested_children(block)):
            if ref not in blocks:
                add_issue(
                    issues,
                    "error",
                    f"$.nested_blocks[block_id={block_id}]",
                    "V21_UNRESOLVED_BLOCK_REF",
                    f"block_ref `{ref}` does not resolve.",
                )


def check_v21_block_acyclic(blocks: dict[str, dict[str, Any]], issues: list[ValidationIssue]) -> None:
    visiting: set[str] = set()
    visited: set[str] = set()

    def visit(block_id: str, stack: list[str]) -> None:
        if block_id in visiting:
            add_issue(
                issues,
                "error",
                "$.nested_blocks",
                "V21_BLOCK_GRAPH_CYCLE",
                "Cycle detected in block graph: " + " -> ".join(stack + [block_id]),
            )
            return
        if block_id in visited or block_id not in blocks:
            return
        visiting.add(block_id)
        for ref in operand_block_refs(nested_children(blocks[block_id])):
            visit(ref, stack + [block_id])
        visiting.remove(block_id)
        visited.add(block_id)

    for block_id in blocks:
        visit(block_id, [])


def check_v21_m1v3_m2v3(
    blocks: dict[str, dict[str, Any]],
    issues: list[ValidationIssue],
    k: int | None,
) -> None:
    # M1V3/M2V3 are the source-fidelity guard for the k=2 row28 tree.
    # Higher-k EL trees have generated block names and must not be forced into
    # the k=2 nesting shape.
    if k != 2:
        return
    m1 = blocks.get("M1V3")
    if not isinstance(m1, dict):
        add_issue(issues, "error", "$.nested_blocks", "V21_M1V3_BLOCK_MISSING", "M1V3 block is required for row28 nested EL.")
    else:
        children = nested_children(m1)
        if len(children) < 2 or not isinstance(children[1], dict):
            add_issue(issues, "error", "$.nested_blocks[M1V3].children", "V21_M1V3_SECOND_ARM_MISSING", "M1V3 requires a second arm.")
        else:
            second = children[1]
            if second.get("component") == "phi22":
                add_issue(
                    issues,
                    "error",
                    "$.nested_blocks[M1V3].children[1]",
                    "V21_M1V3_SECOND_ARM_NOT_PHI25",
                    "M1V3 second arm must be phi25; phi22 is the historical V2 arm.",
                )
            elif second.get("component") != "phi25":
                add_issue(
                    issues,
                    "error",
                    "$.nested_blocks[M1V3].children[1]",
                    "V21_M1V3_SECOND_ARM_NOT_PHI25",
                    "M1V3 second arm must be phi25.",
                )
    m2 = blocks.get("M2V3")
    if not isinstance(m2, dict):
        add_issue(issues, "error", "$.nested_blocks", "V21_M2V3_BLOCK_MISSING", "M2V3 block is required for row28 nested EL.")


def node_ancestors(node_id: str, parent_map: dict[str, str]) -> set[str]:
    ancestors: set[str] = set()
    current = parent_map.get(node_id)
    while isinstance(current, str) and current and current not in ancestors:
        ancestors.add(current)
        current = parent_map.get(current)
    return ancestors


def collect_v21_sibling_groups(
    data: dict[str, Any],
    nodes: dict[str, dict[str, Any]],
    issues: list[ValidationIssue],
) -> dict[str, dict[str, Any]]:
    groups = data.get("sibling_disjointness_groups", [])
    result: dict[str, dict[str, Any]] = {}
    if not isinstance(groups, list):
        add_issue(
            issues,
            "error",
            "$.sibling_disjointness_groups",
            "V21_SIBLING_GROUPS_NOT_ARRAY",
            "sibling_disjointness_groups must be an array.",
        )
        return result
    for idx, group in enumerate(groups):
        path = f"$.sibling_disjointness_groups[{idx}]"
        if not isinstance(group, dict):
            add_issue(issues, "error", path, "V21_SIBLING_GROUP_NOT_OBJECT", "Sibling group must be an object.")
            continue
        group_id = group.get("group_id")
        if not isinstance(group_id, str) or not group_id:
            add_issue(issues, "error", f"{path}.group_id", "V21_SIBLING_GROUP_ID_MISSING", "Sibling group requires group_id.")
            continue
        if group_id in result:
            add_issue(issues, "error", f"{path}.group_id", "V21_DUPLICATE_SIBLING_GROUP_ID", f"Duplicate group_id `{group_id}`.")
        result[group_id] = group
        members = group.get("member_node_ids")
        if not isinstance(members, list) or not members or not all(isinstance(member, str) and member for member in members):
            add_issue(
                issues,
                "error",
                f"{path}.member_node_ids",
                "V21_SIBLING_GROUP_MEMBERS_INVALID",
                "Sibling group requires a non-empty member_node_ids array.",
            )
            continue
        for member in members:
            if member not in nodes:
                add_issue(
                    issues,
                    "error",
                    f"{path}.member_node_ids",
                    "V21_UNRESOLVED_NODE_REF",
                    f"Sibling-group member `{member}` does not resolve.",
                )
        parent_fiber = group.get("parent_fiber")
        if not isinstance(parent_fiber, str) or not parent_fiber:
            add_issue(
                issues,
                "error",
                f"{path}.parent_fiber",
                "V21_SIBLING_GROUP_PARENT_MISSING",
                "Sibling group requires parent_fiber.",
            )
    return result


def check_v21_overlap_guards(data: dict[str, Any], issues: list[ValidationIssue]) -> None:
    guards = data.get("overlap_guards", [])
    if not isinstance(guards, list):
        add_issue(issues, "error", "$.overlap_guards", "V21_OVERLAP_GUARDS_NOT_ARRAY", "overlap_guards must be an array.")
        return
    kinds = {
        guard.get("guard_kind")
        for guard in guards
        if isinstance(guard, dict) and isinstance(guard.get("guard_kind"), str)
    }
    if "no_parent_descendant_sum" not in kinds:
        add_issue(
            issues,
            "error",
            "$.overlap_guards",
            "V21_PARENT_DESCENDANT_GUARD_MISSING",
            "Nested EL schema requires a no_parent_descendant_sum guard.",
        )


def check_v21_deleted_and_overlap(
    blocks: dict[str, dict[str, Any]],
    nodes: dict[str, dict[str, Any]],
    sibling_groups: dict[str, dict[str, Any]],
    issues: list[ValidationIssue],
) -> None:
    parent_map = {
        node_id: parent
        for node_id, node in nodes.items()
        if isinstance((parent := node.get("parent_node_id")), str) and parent
    }

    for block_id, block in blocks.items():
        children = nested_children(block)
        node_refs = operand_node_refs(children)
        for node_ref in node_refs:
            node = nodes.get(node_ref)
            if not isinstance(node, dict):
                add_issue(
                    issues,
                    "error",
                    f"$.nested_blocks[block_id={block_id}]",
                    "V21_UNRESOLVED_NODE_REF",
                    f"node_ref `{node_ref}` does not resolve.",
                )
                continue
            if node.get("node_status") == "deleted":
                add_issue(
                    issues,
                    "error",
                    f"$.nested_blocks[block_id={block_id}]",
                    "V21_DELETED_NODE_CONTRIBUTES",
                    f"Deleted node `{node_ref}` appears as a block operand.",
                )
        kind = block.get("block_kind", block.get("operator"))
        if kind == "sum":
            refs = [ref for ref in node_refs if ref in nodes]
            if refs and block.get("parent_descendant_overlap_forbidden") is not True:
                add_issue(
                    issues,
                    "error",
                    f"$.nested_blocks[block_id={block_id}].parent_descendant_overlap_forbidden",
                    "V21_PARENT_DESCENDANT_GUARD_NOT_ENABLED",
                    "A node-level sum must enable parent_descendant_overlap_forbidden.",
                )
            for ref in refs:
                ancestors = node_ancestors(ref, parent_map)
                overlap = ancestors.intersection(refs)
                if overlap:
                    add_issue(
                        issues,
                        "error",
                        f"$.nested_blocks[block_id={block_id}]",
                        "V21_PARENT_DESCENDANT_SUM",
                        f"Sum block contains node `{ref}` and ancestor(s) {sorted(overlap)}.",
                    )
            if block.get("claims_disjointness") is True:
                group = block.get("sibling_disjointness_group")
                if not isinstance(group, str) or not group:
                    add_issue(
                        issues,
                        "error",
                        f"$.nested_blocks[block_id={block_id}].sibling_disjointness_group",
                        "V21_SUM_DISJOINTNESS_GROUP_MISSING",
                        "A sum claiming disjointness must name a sibling_disjointness_group.",
                    )
                elif group not in sibling_groups:
                    add_issue(
                        issues,
                        "error",
                        f"$.nested_blocks[block_id={block_id}].sibling_disjointness_group",
                        "V21_SUM_DISJOINTNESS_GROUP_UNRESOLVED",
                        f"Sibling group `{group}` does not resolve.",
                    )
                else:
                    members = sibling_groups[group].get("member_node_ids", [])
                    if not set(refs).issubset(set(members)):
                        add_issue(
                            issues,
                            "error",
                            f"$.nested_blocks[block_id={block_id}]",
                            "V21_SUM_OPERANDS_NOT_IN_SIBLING_GROUP",
                            "Every node operand of a disjoint sum must belong to its sibling group.",
                        )


def check_v21_post_deletion_edges(data: dict[str, Any], nodes: dict[str, dict[str, Any]], issues: list[ValidationIssue]) -> None:
    edges = data.get("post_deletion_edges", [])
    if not isinstance(edges, list):
        add_issue(issues, "error", "$.post_deletion_edges", "V21_POST_DELETION_EDGES_NOT_ARRAY", "post_deletion_edges must be an array.")
        return
    for idx, edge in enumerate(edges):
        path = f"$.post_deletion_edges[{idx}]"
        if not isinstance(edge, dict):
            add_issue(issues, "error", path, "V21_POST_DELETION_EDGE_NOT_OBJECT", "post_deletion edge must be an object.")
            continue
        deleted_node_id = edge.get("deleted_node_id")
        node = nodes.get(deleted_node_id) if isinstance(deleted_node_id, str) else None
        if not isinstance(node, dict):
            add_issue(issues, "error", f"{path}.deleted_node_id", "V21_POST_DELETION_SOURCE_INVALID", "deleted_node_id must resolve.")
        elif node.get("node_status") not in {"deleted", "expanded"}:
            add_issue(
                issues,
                "error",
                f"{path}.deleted_node_id",
                "V21_POST_DELETION_SOURCE_INVALID",
                "post_deletion_edges must start from deleted or expanded nodes.",
            )
        replacements = edge.get("replacement_child_ids", [])
        if not isinstance(replacements, list) or not replacements:
            add_issue(issues, "error", f"{path}.replacement_child_ids", "V21_POST_DELETION_REPLACEMENTS_MISSING", "replacement_child_ids required.")
        else:
            for replacement in replacements:
                if replacement not in nodes:
                    add_issue(
                        issues,
                        "error",
                        f"{path}.replacement_child_ids",
                        "V21_UNRESOLVED_NODE_REF",
                        f"replacement child `{replacement}` does not resolve.",
                    )


def check_v21_source_refs(
    data: dict[str, Any],
    issues: list[ValidationIssue],
    *,
    require_figure_a1: bool,
) -> set[str]:
    refs = data.get("source_refs", [])
    if not isinstance(refs, list):
        add_issue(issues, "error", "$.source_refs", "V21_SOURCE_REFS_NOT_ARRAY", "source_refs must be an array.")
        return set()
    saw_figure_oracle = False
    source_ref_ids: set[str] = set()
    for idx, ref in enumerate(refs):
        path = f"$.source_refs[{idx}]"
        if not isinstance(ref, dict):
            add_issue(issues, "error", path, "V21_SOURCE_REF_NOT_OBJECT", "source_ref must be an object.")
            continue
        source_ref_id = ref.get("source_ref_id")
        if not isinstance(source_ref_id, str) or not source_ref_id:
            add_issue(issues, "error", f"{path}.source_ref_id", "V21_SOURCE_REF_ID_MISSING", "source_ref requires source_ref_id.")
        elif source_ref_id in source_ref_ids:
            add_issue(issues, "error", f"{path}.source_ref_id", "V21_DUPLICATE_SOURCE_REF_ID", f"Duplicate source_ref_id `{source_ref_id}`.")
        else:
            source_ref_ids.add(source_ref_id)
        if ref.get("source_kind") == "figure_a1":
            if ref.get("trust_role") != "regression_oracle":
                add_issue(
                    issues,
                    "error",
                    f"{path}.trust_role",
                    "V21_FIGURE_A1_USED_AS_GENERATOR_SOURCE",
                    "Figure A1/root_paths may be a regression oracle, not the generator source.",
                )
            else:
                saw_figure_oracle = True
    if require_figure_a1 and not saw_figure_oracle:
        add_issue(
            issues,
            "error",
            "$.source_refs",
            "V21_FIGURE_A1_ORACLE_REF_MISSING",
            "Row28 nested artifact must record Figure A1/root_paths as a regression oracle.",
        )
    return source_ref_ids


def normalized_source_ref(value: Any) -> str | None:
    if not isinstance(value, str) or not value:
        return None
    return value.removeprefix("source_refs.")


def check_v21_termination_policy(
    data: dict[str, Any],
    source_ref_ids: set[str],
    issues: list[ValidationIssue],
) -> None:
    policy = data.get("termination_policy")
    if not isinstance(policy, dict):
        add_issue(issues, "error", "$.termination_policy", "V21_TERMINATION_POLICY_INVALID", "termination_policy must be an object.")
        return
    if policy.get("kind") != "expand_until_deletion_saturation":
        add_issue(
            issues,
            "error",
            "$.termination_policy.kind",
            "V21_TERMINATION_POLICY_KIND_INVALID",
            "Expected expand_until_deletion_saturation for row28 nested check.",
        )
    allowed_statuses = {
        "hypothesis_untested",
        "source_theorem_run_witness_unverified_in_lean",
    }
    if policy.get("status") not in allowed_statuses:
        add_issue(
            issues,
            "error",
            "$.termination_policy.status",
            "V21_TERMINATION_POLICY_STATUS_INVALID",
            f"Expected one of {sorted(allowed_statuses)}; neither status is a Lean proof claim.",
        )
    source_ref = normalized_source_ref(policy.get("termination_rule_ref", policy.get("source_ref")))
    if source_ref not in source_ref_ids:
        add_issue(
            issues,
            "error",
            "$.termination_policy.termination_rule_ref",
            "V21_TERMINATION_SOURCE_REF_UNRESOLVED",
            "termination_policy must reference a declared termination-rule source.",
        )


def check_v21_nested_schema(data: dict[str, Any], issues: list[ValidationIssue]) -> None:
    for field in V21_TOP_LEVEL_REQUIRED:
        if field not in data:
            add_issue(issues, "error", f"$.{field}", "V21_MISSING_REQUIRED_FIELD", "v2.1 nested EL field is missing.")

    nodes = collect_v21_nodes(data, issues)
    blocks = collect_v21_blocks(data, issues)
    metadata = data.get("metadata", {})
    k = parse_canonical_nonnegative_int(metadata.get("k")) if isinstance(metadata, dict) else None
    sibling_groups = collect_v21_sibling_groups(data, nodes, issues)
    check_v21_block_refs(blocks, issues)
    check_v21_block_acyclic(blocks, issues)
    check_v21_m1v3_m2v3(blocks, issues, k)
    check_v21_overlap_guards(data, issues)
    check_v21_deleted_and_overlap(blocks, nodes, sibling_groups, issues)
    check_v21_post_deletion_edges(data, nodes, issues)
    source_ref_ids = check_v21_source_refs(data, issues, require_figure_a1=k == 2)
    check_v21_termination_policy(data, source_ref_ids, issues)


def validate_data(data: Any, input_path: Path) -> tuple[list[ValidationIssue], dict[str, int | bool | str]]:
    issues: list[ValidationIssue] = []
    input_kind = classify_input(data, input_path)
    if not isinstance(data, dict):
        add_issue(issues, "error", "$", "TOP_LEVEL_NOT_OBJECT", "Top-level JSON value must be an object.")
        return issues, {
            "float_count": count_floats(data),
            "row_count": 0,
            "child_count": 0,
            "slack_count": 0,
            "constant_count": 0,
            "is_fixture": input_path.name.endswith(".fixture.json"),
            "input_kind": input_kind,
        }

    check_required_fields(data, TOP_LEVEL_REQUIRED, "$", issues)

    metadata = data.get("metadata", {})
    check_required_fields(metadata, METADATA_FLAGS_REQUIRED, "$.metadata", issues)
    check_metadata_version_and_counts(metadata, issues)
    check_artifact_links(metadata, issues)

    is_fixture = input_kind == "fixture"
    if is_fixture:
        check_fixture_flags(metadata, issues)
    if input_kind == "generated_k2_regression":
        check_generated_k2_regression(data, issues)
    if schema_version(data) == SCHEMA_V21 and isinstance(data, dict):
        check_v21_nested_schema(data, issues)

    rows = data.get("rows", [])
    if isinstance(rows, list):
        for idx, row in enumerate(rows):
            row_path = f"$.rows[{idx}]"
            check_required_fields(row, ROW_REQUIRED, row_path, issues)
            if isinstance(row, dict):
                children = row.get("children", [])
                if not isinstance(children, list):
                    add_issue(issues, "error", f"{row_path}.children", "TYPE_NOT_ARRAY", "Expected children array.")
                else:
                    for child_idx, child in enumerate(children):
                        check_required_fields(child, CHILD_REQUIRED, f"{row_path}.children[{child_idx}]", issues)
    else:
        add_issue(issues, "error", "$.rows", "TYPE_NOT_ARRAY", "Expected rows array.")

    inverse_words = data.get("inverse_words", [])
    if isinstance(inverse_words, list):
        for idx, child in enumerate(inverse_words):
            check_required_fields(child, CHILD_REQUIRED, f"$.inverse_words[{idx}]", issues)
    else:
        add_issue(issues, "error", "$.inverse_words", "TYPE_NOT_ARRAY", "Expected inverse_words array.")

    check_rational_strings(data, issues)

    float_count = count_floats(data)
    if float_count:
        add_issue(issues, "error", "$", "FLOAT_VALUES_PRESENT", f"JSON contains {float_count} float value(s).")

    slack_ids = collect_ids(data.get("slacks", []), "slack_id", "$.slacks", issues)
    child_ids = collect_ids(data.get("inverse_words", []), "child_id", "$.inverse_words", issues)
    row_ids = collect_ids(data.get("rows", []), "row_id", "$.rows", issues)

    if isinstance(rows, list):
        for idx, row in enumerate(rows):
            if not isinstance(row, dict):
                continue
            row_path = f"$.rows[{idx}]"
            row_id = row.get("row_id")
            if isinstance(row_id, str) and row_ids.get(row_id) != row_path:
                pass
            slack_id = row.get("slack_id")
            if isinstance(slack_id, str) and slack_id not in slack_ids:
                add_issue(issues, "error", f"{row_path}.slack_id", "MISSING_SLACK_REF", f"Unknown slack_id `{slack_id}`.")
            children = row.get("children", [])
            if isinstance(children, list):
                for child_idx, child in enumerate(children):
                    child_path = f"{row_path}.children[{child_idx}]"
                    if not isinstance(child, dict):
                        continue
                    child_id = child.get("child_id")
                    if not isinstance(child_id, str):
                        continue
                    if child_id not in child_ids:
                        add_issue(
                            issues,
                            "error",
                            f"{child_path}.child_id",
                            "MISSING_CHILD_REF",
                            f"Inline child `{child_id}` does not appear in inverse_words.",
                        )
                    else:
                        inverse_child = next(
                            (
                                item
                                for item in data.get("inverse_words", [])
                                if isinstance(item, dict) and item.get("child_id") == child_id
                            ),
                            None,
                        )
                        if isinstance(inverse_child, dict) and child_signature(child) != child_signature(inverse_child):
                            add_issue(
                                issues,
                                "error",
                                child_path,
                                "INLINE_CHILD_MISMATCH",
                                f"Inline child `{child_id}` is not consistent with inverse_words entry.",
                            )

    manifest_candidate = input_path.parent / "manifest_sha256.csv"
    if manifest_candidate.exists():
        add_issue(
            issues,
            "warning",
            repo_rel(manifest_candidate),
            "EXTERNAL_MANIFEST_PRESENT_NOT_VALIDATED",
            "External artifact manifest exists but this schema validator only reports its presence.",
        )
    else:
        add_issue(
            issues,
            "warning",
            repo_rel(manifest_candidate),
            "EXTERNAL_MANIFEST_NOT_FOUND",
            "No sibling artifact manifest found to report.",
        )

    row_count = len(rows) if isinstance(rows, list) else 0
    child_count = len(inverse_words) if isinstance(inverse_words, list) else 0
    slack_count = len(data.get("slacks", [])) if isinstance(data.get("slacks", []), list) else 0
    rational_certificate = data.get("rational_certificate", {})
    constants = rational_certificate.get("coefficient_intervals", []) if isinstance(rational_certificate, dict) else []
    constant_count = len(constants) if isinstance(constants, list) else 0
    return issues, {
        "float_count": float_count,
        "row_count": row_count,
        "child_count": child_count,
        "slack_count": slack_count,
        "constant_count": constant_count,
        "is_fixture": is_fixture,
        "input_kind": input_kind,
    }


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def write_errors(path: Path, issues: list[ValidationIssue]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=["severity", "path", "code", "message"], lineterminator="\n")
        writer.writeheader()
        for issue in issues:
            writer.writerow(
                {
                    "severity": issue.severity,
                    "path": issue.path,
                    "code": issue.code,
                    "message": issue.message,
                }
            )


def write_manifest(paths: list[Path], manifest_path: Path) -> None:
    manifest_path.parent.mkdir(parents=True, exist_ok=True)
    with manifest_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=["path", "sha256"], lineterminator="\n")
        writer.writeheader()
        for path in paths:
            writer.writerow({"path": repo_rel(path), "sha256": sha256(path)})


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input_path", nargs="?", default=str(DEFAULT_INPUT), help="certificate JSON path to validate")
    parser.add_argument("--out-dir", default=str(OUT_DIR), help="output directory for validation artifacts")
    return parser.parse_args(argv[1:])


def main(argv: list[str]) -> int:
    args = parse_args(argv)
    input_path = Path(args.input_path).expanduser()
    if not input_path.is_absolute():
        input_path = (REPO_ROOT / input_path).resolve()
    out_dir = Path(args.out_dir).expanduser()
    if not out_dir.is_absolute():
        out_dir = (REPO_ROOT / out_dir).resolve()
    summary_path = out_dir / "schema_validation_summary.json"
    errors_path = out_dir / "schema_validation_errors.csv"
    manifest_path = out_dir / "manifest_sha256.csv"

    out_dir.mkdir(parents=True, exist_ok=True)
    issues: list[ValidationIssue] = []
    data: Any = None
    parse_ok = False

    try:
        data = json.loads(input_path.read_text(encoding="utf-8"))
        parse_ok = True
    except FileNotFoundError:
        add_issue(issues, "error", str(input_path), "INPUT_NOT_FOUND", "Input JSON file does not exist.")
    except json.JSONDecodeError as exc:
        add_issue(issues, "error", str(input_path), "JSON_PARSE_ERROR", f"{exc.msg} at line {exc.lineno} column {exc.colno}.")

    stats: dict[str, Any] = {
        "float_count": 0,
        "row_count": 0,
        "child_count": 0,
        "slack_count": 0,
        "constant_count": 0,
        "is_fixture": input_path.name.endswith(".fixture.json"),
        "input_kind": "fixture" if input_path.name.endswith(".fixture.json") else "generated_or_unknown",
    }
    if parse_ok:
        validation_issues, stats = validate_data(data, input_path)
        issues.extend(validation_issues)

    error_count = sum(1 for issue in issues if issue.severity == "error")
    warning_count = sum(1 for issue in issues if issue.severity == "warning")
    warning_records = [
        {
            "code": issue.code,
            "path": issue.path,
            "message": issue.message,
            "disposition": (
                "ACCEPTED_NAMED_WARNING"
                if issue.code == "EXTERNAL_MANIFEST_PRESENT_NOT_VALIDATED"
                else "REVIEW_REQUIRED"
            ),
        }
        for issue in issues
        if issue.severity == "warning"
    ]
    schema_ok = parse_ok and error_count == 0
    input_kind = str(stats["input_kind"])
    if schema_ok and input_kind == "generated_k2_regression":
        verdict = "GENERATED_K2_REGRESSION_SCHEMA_PASS"
    elif schema_ok:
        verdict = "FORMAT_CHECK_ONLY"
    else:
        verdict = "FORMAT_CHECK_FAILED"

    summary = {
        "run_id": RUN_ID,
        "created_at": datetime.now(timezone.utc).isoformat(),
        "input_path": repo_rel(input_path),
        "input_kind": input_kind,
        "input_sha256": sha256(input_path) if input_path.exists() and input_path.is_file() else None,
        "json_parseable": parse_ok,
        "supported_schema_versions": sorted(SUPPORTED_SCHEMA_VERSIONS),
        "schema_version": schema_version(data) if parse_ok else None,
        "schema_ok": schema_ok,
        "is_fixture": stats["is_fixture"],
        "float_count": stats["float_count"],
        "error_count": error_count,
        "warning_count": warning_count,
        "warning_codes": sorted({record["code"] for record in warning_records}),
        "warnings": warning_records,
        "known_warning_policy": {
            "EXTERNAL_MANIFEST_PRESENT_NOT_VALIDATED": (
                "Accepted for schema validation v1: the validator reports sibling manifest presence "
                "but does not yet verify external artifact manifests."
            )
        },
        "row_count": stats["row_count"],
        "child_count": stats["child_count"],
        "slack_count": stats["slack_count"],
        "constant_count": stats["constant_count"],
        "reported_artifact_hash_fields": artifact_hash_fields(data) if parse_ok else {},
        "verdict": verdict,
        "guardrails": [
            "NO_MATHEMATICAL_VERIFICATION",
            "NO_K3_ROWS_GENERATED",
            "NO_LP_SOLVED",
            "NO_LEAN_OPENED",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
        "classifications": [
            "K3_CERTIFICATE_SCHEMA_VALIDATOR_CREATED",
            "SCHEMA_VALIDATOR_UPDATED",
            "SCHEMA_VALIDATOR_ACCEPTS_GENERATED_ARTIFACTS",
            "SCHEMA_VALIDATOR_ACCEPTS_V2_AND_V21",
            "K_PARAMETRIC_CERTIFICATE_SCHEMA_DEFINED",
            "JSON_LEAN_TWIN_ARTIFACT_POLICY_DEFINED",
            "CANONICAL_RATIONAL_FORMAT_DEFINED",
            "FIXTURE_SCHEMA_VALIDATED" if schema_ok and stats["is_fixture"] else "SCHEMA_VALIDATION_ATTEMPTED",
            "K2_REGRESSION_GENERATED_JSON_SCHEMA_VALIDATED"
            if schema_ok and input_kind == "generated_k2_regression"
            else "K2_REGRESSION_GENERATED_JSON_NOT_VALIDATED_IN_THIS_RUN",
            "FORMAT_WARNING_NAMED_OR_RESOLVED",
            "FORMAT_CHECK_ONLY",
            "NO_MATHEMATICAL_VERIFICATION",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }

    write_json(summary_path, summary)
    write_errors(errors_path, issues)
    write_manifest([summary_path, errors_path], manifest_path)

    print(f"run_id={RUN_ID}")
    print(f"input_path={repo_rel(input_path)}")
    print(f"schema_ok={str(schema_ok).lower()}")
    print(f"error_count={error_count}")
    print(f"warning_count={warning_count}")
    print(f"verdict={summary['verdict']}")
    return 0 if schema_ok else 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
