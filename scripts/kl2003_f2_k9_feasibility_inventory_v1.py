#!/usr/bin/env python3
"""Inventory local KL2003 high-k feasibility evidence.

This is an F2 gate script, not a theorem generator.  It reads the local
scoping note, scans local source custody/docs/outputs/Lean/scripts, and emits
an evidence inventory for the fixed high-k checklist.  It deliberately marks
missing or ambiguous evidence instead of reconstructing mathematics from
patterns.
"""

from __future__ import annotations

import csv
import hashlib
import json
import os
import re
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Iterable


RUN_ID = "KL2003_F2_K9_FEASIBILITY_GATE_v1"
REPO_ROOT = Path(__file__).resolve().parents[1]
SCOPING = REPO_ROOT / "docs" / "KL2003_F2_K9_FEASIBILITY_GATE_SCOPING_v1.md"
SOURCE_REVIEW_NOTE = REPO_ROOT / "docs" / "KL2003_F2_HIGH_K_SOURCE_REVIEW_AND_GENERATOR_PATH_v1.md"
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID

KL2003_SOURCE_DIR = Path(
    "/Users/MoiTam/Documents/Codex/2026-07-05/"
    "tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/kl2003_src"
)
KL2003_SOURCE_TAR = KL2003_SOURCE_DIR.parent / "kl2003.tar"

TEXT_SUFFIXES = {
    ".csv",
    ".json",
    ".lean",
    ".md",
    ".py",
    ".tex",
    ".pstex",
    ".pstex_t",
    ".txt",
}


@dataclass(frozen=True)
class PatternHit:
    path: Path
    line: int
    text: str
    kind: str


@dataclass(frozen=True)
class ChecklistItem:
    item_id: str
    description: str
    expected_evidence: str
    strong_patterns: tuple[str, ...]
    weak_patterns: tuple[str, ...] = ()
    source_required: bool = True


CHECKLIST: tuple[ChecklistItem, ...] = (
    ChecklistItem(
        item_id="general_k_Ik_EL",
        description="General-k system definition for I_k/EL",
        expected_evidence=(
            "TeX/source ranges defining splitting/deletion rules "
            "parametrically, not only the k=2 instance."
        ),
        strong_patterns=(r"\bI_k\b", r"\bT_k\b", r"\bL_k\b", r"general[- ]?k", r"for all k"),
        weak_patterns=(r"\bI_2\b", r"\bL_2\b", r"\bEL\b", r"deletion", r"splitting"),
    ),
    ChecklistItem(
        item_id="printed_k9_data",
        description="Printed k=9 row system or certificate data",
        expected_evidence=(
            "Explicit paper/source tables for k=9 rows, weights, endpoints, "
            "or certificate data."
        ),
        strong_patterns=(r"\bk\s*=\s*9\b", r"\bk=9\b", r"\bK9\b", r"\bgamma_?9\b", r"\blambda_?9\b"),
        weak_patterns=(r"\b0\.84\b", r"\b0,84\b", r"\bM3\b", r"certificate", r"Table"),
    ),
    ChecklistItem(
        item_id="printed_k11_084_data",
        description="Printed k=11 / 0.84 row system or certificate data",
        expected_evidence=(
            "Explicit paper/source tables for k=11 rows, weights, endpoints, "
            "or certificate data supporting the 0.84 line."
        ),
        strong_patterns=(r"\bk\s*=\s*11\b", r"\bk=11\b", r"\bK11\b", r"\bgamma_?11\b", r"\blambda_?11\b", r"\b0\.84\b"),
        weak_patterns=(r"\b0\.8417560\b", r"\b1\.7922310\b", r"further computation", r"certificate", r"Table"),
    ),
    ChecklistItem(
        item_id="gamma_k_table",
        description="Table of exponents gamma(k)",
        expected_evidence=(
            "Printed or source-derived values for intermediate k, especially "
            "k=3 through k=11."
        ),
        strong_patterns=(r"gamma\s*\(\s*k\s*\)", r"gamma\(k\)", r"gamma_?k", r"exponents? gamma"),
        weak_patterns=(r"\bgammaK2\b", r"\bgamma\b", r"\bk\s*=\s*9\b", r"\bk\s*=\s*11\b", r"\b0\.84\b"),
    ),
    ChecklistItem(
        item_id="k9_lambda_precision",
        description="k=9 lambda/endpoint precision",
        expected_evidence=(
            "Exact or approximate k=9 lambda/endpoints with enough precision "
            "for rational intervals and slacks."
        ),
        strong_patterns=(r"\blambda_?9\b", r"\bk\s*=\s*9\b.*\blambda\b", r"\blambda\b.*\bk\s*=\s*9\b", r"\b1\.7615320\b"),
        weak_patterns=(r"\blambdaR\b", r"\blambda\b", r"endpoint", r"precision", r"interval"),
    ),
    ChecklistItem(
        item_id="k11_lambda_precision",
        description="k=11 / 0.84 lambda/endpoint precision",
        expected_evidence=(
            "Exact or approximate k=11 lambda/endpoints with enough precision "
            "for rational intervals and slacks."
        ),
        strong_patterns=(r"\blambda_?11\b", r"\bk\s*=\s*11\b.*\blambda\b", r"\blambda\b.*\bk\s*=\s*11\b", r"\b1\.7922310\b"),
        weak_patterns=(r"\blambdaR\b", r"\blambda\b", r"endpoint", r"precision", r"interval", r"\b0\.8417560\b"),
    ),
    ChecklistItem(
        item_id="k9_deletion_tree_sources",
        description="k=9 deletion/tree source material",
        expected_evidence=(
            "Figure overlays, graphical sources, TeX tables, or algorithms "
            "sufficient to reconstruct k=9 member-wise populations."
        ),
        strong_patterns=(r"\bk\s*=\s*9\b.*(deletion|tree|figure)", r"(deletion|tree|figure).*\bk\s*=\s*9\b"),
        weak_patterns=(r"deletion", r"deleted", r"crossed", r"tree", r"pstex", r"Figure"),
    ),
    ChecklistItem(
        item_id="k11_deletion_tree_sources",
        description="k=11 / 0.84 deletion/tree source material",
        expected_evidence=(
            "Figure overlays, graphical sources, TeX tables, or algorithms "
            "sufficient to reconstruct k=11 member-wise populations."
        ),
        strong_patterns=(r"\bk\s*=\s*11\b.*(deletion|tree|figure)", r"(deletion|tree|figure).*\bk\s*=\s*11\b"),
        weak_patterns=(r"deletion", r"deleted", r"crossed", r"tree", r"pstex", r"Figure", r"\b0\.84\b"),
    ),
    ChecklistItem(
        item_id="reusable_lean_assets",
        description="Existing reusable Lean assets",
        expected_evidence=(
            "Hand-maintained table classifying which k=2 modules are genuinely "
            "generic and reusable."
        ),
        strong_patterns=(),
        weak_patterns=(),
        source_required=False,
    ),
    ChecklistItem(
        item_id="k2_cabled_assets",
        description="k=2-cabled assets that must be replaced",
        expected_evidence=(
            "Hand-maintained table marking files/declarations tied to mod 9, "
            "the k=2 certificate, k=2 row labels, or k=2 case trees."
        ),
        strong_patterns=(),
        weak_patterns=(),
        source_required=False,
    ),
)


REUSABLE_ASSETS = [
    {
        "asset_id": "M0A_piStar_semantics",
        "path": "CollatzClassical/KL2003/KL2003M0APiStarSemantics.lean",
        "reuse_status": "REUSABLE_GENERIC",
        "notes": "Computable piStar/reachability semantics is not k=2-specific.",
    },
    {
        "asset_id": "M0B_reachability_api",
        "path": "CollatzClassical/KL2003/KL2003M0BReachabilityAPI.lean",
        "reuse_status": "REUSABLE_GENERIC",
        "notes": "Prop reachability and Bool/Prop bridge are root/window generic.",
    },
    {
        "asset_id": "entry_predecessor_fibers",
        "path": "CollatzClassical/KL2003/KL2003M0BEntryPredecessorDisjointness.lean",
        "reuse_status": "REUSABLE_GENERIC",
        "notes": "First-entry/fiber disjointness is expected to generalize.",
    },
    {
        "asset_id": "two_branch_core_pattern",
        "path": "CollatzClassical/KL2003/KL2003M0BTwoBranchCore.lean",
        "reuse_status": "REUSABLE_PATTERN",
        "notes": "Useful proof pattern, but high-k rows may need generated variants.",
    },
    {
        "asset_id": "real_log_rpow_toolkit",
        "path": "CollatzClassical/KL2003/KL2003K2AlphaBounds.lean",
        "reuse_status": "REUSABLE_TOOLKIT",
        "notes": "Real/log/rpow techniques reusable, constants are k-specific.",
    },
    {
        "asset_id": "arbitrary_x_logb_translation",
        "path": "CollatzClassical/KL2003/KL2003M1Surrogate.lean",
        "reuse_status": "REUSABLE_PATTERN",
        "notes": "The logb arbitrary-x bridge should generalize after high-k Phi is built.",
    },
]


K2_CABLED_ASSETS = [
    {
        "asset_id": "k2_certificate_data",
        "path": "CollatzClassical/KL2003/KL2003K2CertificateData.lean",
        "cabling_reason": "Contains k=2 constants/classes/slacks.",
        "replacement_needed": "high-k certificate data and exact rational verifier.",
    },
    {
        "asset_id": "k2_certificate_verifier",
        "path": "CollatzClassical/KL2003/KL2003K2CertificateVerifier.lean",
        "cabling_reason": "Verifier rows are tied to the k=2 LP skeleton.",
        "replacement_needed": "Generated or data-driven high-k verifier.",
    },
    {
        "asset_id": "k2_concrete_phi_realization",
        "path": "CollatzClassical/KL2003/KL2003ConcretePhiRealization.lean",
        "cabling_reason": "ClassRoots are mod 9 and row22/25/28 case trees are k=2-specific.",
        "replacement_needed": "high-k class envelope and source-faithful row seam.",
    },
    {
        "asset_id": "k2_M0C_rows_V3",
        "path": "CollatzClassical/KL2003/KL2003M0CRetardedInduction.lean",
        "cabling_reason": "Rows V2/V3 and coefficients are k=2-specific.",
        "replacement_needed": "high-k abstract row contract and certificate arithmetic.",
    },
    {
        "asset_id": "k2_row_instantiations",
        "path": "CollatzClassical/KL2003/KL2003M0BD123CoreInstantiations.lean",
        "cabling_reason": "D1/D2/D3 are the k=2 row families only.",
        "replacement_needed": "high-k row family extraction/generation.",
    },
    {
        "asset_id": "k2_figure_A1_outputs",
        "path": "outputs/KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1",
        "cabling_reason": "Figure A1 is the k=2 row28/EL tree custody.",
        "replacement_needed": "high-k deletion/tree source custody if present.",
    },
]


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


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="replace")


def is_text_path(path: Path) -> bool:
    suffixes = path.suffixes
    if suffixes and "".join(suffixes[-2:]) == ".pstex_t":
        return True
    return path.suffix.lower() in TEXT_SUFFIXES


def path_is_under(path: Path, root: Path) -> bool:
    try:
        path.resolve().relative_to(root.resolve())
        return True
    except ValueError:
        return False


def excluded_from_evidence_scan(path: Path) -> bool:
    """Avoid self-evidence from the scoping note, this script, and outputs."""
    resolved = path.resolve()
    if resolved in {SCOPING.resolve(), SOURCE_REVIEW_NOTE.resolve(), Path(__file__).resolve()}:
        return True
    if path_is_under(path, OUT_DIR):
        return True
    if "__pycache__" in path.parts:
        return True
    return False


def iter_candidate_files() -> list[Path]:
    roots = [
        REPO_ROOT / "docs",
        REPO_ROOT / "outputs",
        REPO_ROOT / "scripts",
        REPO_ROOT / "CollatzClassical" / "KL2003",
    ]
    files: list[Path] = []
    for root in roots:
        if root.exists():
            for path in root.rglob("*"):
                if path.is_file() and not excluded_from_evidence_scan(path):
                    files.append(path)
    if KL2003_SOURCE_DIR.exists():
        for path in KL2003_SOURCE_DIR.rglob("*"):
            if path.is_file() and not excluded_from_evidence_scan(path):
                files.append(path)
    if KL2003_SOURCE_TAR.exists():
        files.append(KL2003_SOURCE_TAR)
    return sorted(set(files), key=lambda p: repo_rel(p))


def source_kind(path: Path) -> str:
    if KL2003_SOURCE_DIR.exists() and path.resolve().is_relative_to(KL2003_SOURCE_DIR.resolve()):
        return "SOURCE_CUSTODY"
    if path == KL2003_SOURCE_TAR:
        return "SOURCE_ARCHIVE"
    try:
        rel = path.resolve().relative_to(REPO_ROOT)
    except ValueError:
        return "EXTERNAL"
    first = rel.parts[0] if rel.parts else ""
    if first == "docs":
        return "DOC"
    if first == "outputs":
        return "OUTPUT"
    if first == "scripts":
        return "SCRIPT"
    if first == "CollatzClassical":
        return "LEAN"
    return "REPO_OTHER"


def compile_patterns(patterns: Iterable[str]) -> list[re.Pattern[str]]:
    return [re.compile(p, re.IGNORECASE) for p in patterns]


def line_hits(files: list[Path], patterns: Iterable[str], kind: str, limit: int = 40) -> list[PatternHit]:
    regexes = compile_patterns(patterns)
    if not regexes:
        return []
    hits: list[PatternHit] = []
    for path in files:
        if not is_text_path(path):
            continue
        try:
            lines = read_text(path).splitlines()
        except OSError:
            continue
        for line_no, line in enumerate(lines, start=1):
            if any(r.search(line) for r in regexes):
                hits.append(PatternHit(path=path, line=line_no, text=line.strip(), kind=kind))
                if len(hits) >= limit:
                    return hits
    return hits


def hit_refs(hits: list[PatternHit], max_refs: int = 12) -> list[str]:
    return [f"{repo_rel(h.path)}:{h.line}" for h in hits[:max_refs]]


def hit_paths(hits: list[PatternHit], max_paths: int = 12) -> list[Path]:
    seen: list[Path] = []
    for hit in hits:
        if hit.path not in seen:
            seen.append(hit.path)
        if len(seen) >= max_paths:
            break
    return seen


def sha_field(paths: list[Path]) -> str:
    pairs = []
    for path in paths:
        try:
            pairs.append(f"{repo_rel(path)}={sha256(path)}")
        except OSError:
            pairs.append(f"{repo_rel(path)}=UNREADABLE")
    return ";".join(pairs)


def hit_text_matches(hit: PatternHit, pattern: str) -> bool:
    return re.search(pattern, hit.text, re.IGNORECASE) is not None


def has_explicit_high_k_data_table_hit(hit: PatternHit) -> bool:
    return hit_text_matches(
        hit,
        r"\bk\s*=\s*(9|11)\b|\bk=(9|11)\b|\bK(9|11)\b|\bgamma_?(9|11)\b|\blambda_?(9|11)\b|\b0\.84\b",
    ) and hit_text_matches(
        hit,
        r"\b(rows?|weights?|endpoints?|certificate|slacks?|feasible solution|constraints?|coefficients?|table)\b",
    )


def has_explicit_high_k_lambda_precision_hit(hit: PatternHit) -> bool:
    if hit_text_matches(hit, r"\b1\.7615320\b|\b1\.7922310\b"):
        return True
    precision_near_lambda = (
        r"(\\lambda|\blambda\b|\blambda_?(9|11)\b)[^0-9\n]{0,30}"
        r"(\d+\.\d{4,}|\d+\s*/\s*\d+)|"
        r"(\d+\.\d{4,}|\d+\s*/\s*\d+)[^\n]{0,30}"
        r"(\\lambda|\blambda\b|\blambda_?(9|11)\b)"
    )
    return (
        hit_text_matches(hit, r"\\lambda|\blambda\b|\blambda_?(9|11)\b")
        and hit_text_matches(hit, r"\bk\s*=\s*(9|11)\b|\bk=(9|11)\b|\blambda_?(9|11)\b")
        and hit_text_matches(hit, precision_near_lambda)
    )


def decide_status(item: ChecklistItem, strong: list[PatternHit], weak: list[PatternHit]) -> tuple[str, str]:
    strong_source = [h for h in strong if source_kind(h.path) in {"SOURCE_CUSTODY", "SOURCE_ARCHIVE"}]
    weak_source = [h for h in weak if source_kind(h.path) in {"SOURCE_CUSTODY", "SOURCE_ARCHIVE"}]

    if item.item_id == "reusable_lean_assets":
        return "FOUND_DERIVED", "Hand-maintained reuse table emitted by script; requires human review before high-k GO."
    if item.item_id == "k2_cabled_assets":
        return "FOUND_DERIVED", "Hand-maintained k=2 cabling table emitted by script; replacement required for high-k."

    if item.item_id in {"printed_k9_data", "printed_k11_084_data"}:
        explicit_source = [h for h in strong_source if has_explicit_high_k_data_table_hit(h)]
        explicit_derived = [h for h in strong if has_explicit_high_k_data_table_hit(h)]
        if explicit_source:
            return "FOUND_SOURCE", "Explicit-looking high-k data/table hit found in local KL2003 source custody."
        if explicit_derived:
            return (
                "AMBIGUOUS",
                "Explicit-looking high-k data/table hit found only in derived repo material; primary source data remains unverified.",
            )
        if strong_source:
            return (
                "AMBIGUOUS",
                "Primary source mentions this high-k target, but this scan did not identify explicit printed rows/certificate data.",
            )
        if strong:
            return "AMBIGUOUS", "Derived material mentions this high-k target, but no explicit source table/certificate was identified."

    if item.item_id in {"k9_lambda_precision", "k11_lambda_precision"}:
        explicit_source = [h for h in strong_source + weak_source if has_explicit_high_k_lambda_precision_hit(h)]
        explicit_derived = [h for h in strong + weak if has_explicit_high_k_lambda_precision_hit(h)]
        if explicit_source:
            return "FOUND_SOURCE", "Explicit-looking high-k lambda precision hit found in local KL2003 source custody."
        if explicit_derived:
            return "FOUND_DERIVED", "Explicit-looking high-k lambda precision hit found only in derived repo material."
        if strong_source or weak_source:
            return (
                "AMBIGUOUS",
                "Local source mentions high-k/lambda context, but no precise endpoint interval or certificate precision was identified.",
            )
        if strong or weak:
            return "AMBIGUOUS", "Derived material mentions high-k lambda context, but no precise source value was identified."

    if item.item_id in {"k9_deletion_tree_sources", "k11_deletion_tree_sources"}:
        if strong_source:
            return "FOUND_SOURCE", "High-k-specific deletion/tree hit found in local KL2003 source custody."
        if strong:
            return (
                "AMBIGUOUS",
                "High-k-specific deletion/tree hit appears only in derived material; needs primary-source confirmation.",
            )
        if weak_source:
            return (
                "AMBIGUOUS",
                "Generic deletion/tree/Figure source exists, but no k=9-specific tree source was identified by this scan.",
            )
        if weak:
            return "AMBIGUOUS", "Generic deletion/tree material appears in derived files only; high-k-specific source is still open."

    if strong_source:
        return "FOUND_SOURCE", "Strong checklist pattern found in local KL2003 source custody."
    if strong:
        return "FOUND_DERIVED", "Strong pattern found only in derived repo docs/outputs/scripts/Lean, not primary source."
    if weak_source and item.source_required:
        return "AMBIGUOUS", "Only weak/source-adjacent evidence found; not enough to certify the required high-k item."
    if weak:
        return "AMBIGUOUS", "Only weak derived evidence found; requires human source review."
    return "MISSING", "No local evidence found for this fixed checklist item."


def build_checklist(files: list[Path]) -> list[dict[str, object]]:
    rows: list[dict[str, object]] = []
    for item in CHECKLIST:
        strong = line_hits(files, item.strong_patterns, "strong")
        weak = line_hits(files, item.weak_patterns, "weak")
        status, notes = decide_status(item, strong, weak)
        paths = hit_paths(strong + weak)
        if item.item_id == "reusable_lean_assets":
            paths = [REPO_ROOT / row["path"] for row in REUSABLE_ASSETS]
        elif item.item_id == "k2_cabled_assets":
            paths = [REPO_ROOT / row["path"] for row in K2_CABLED_ASSETS]
        rows.append(
            {
                "item_id": item.item_id,
                "description": item.description,
                "expected_evidence": item.expected_evidence,
                "status": status,
                "source_paths": [repo_rel(p) for p in paths],
                "line_ranges_or_record_ids": hit_refs(strong + weak),
                "sha256": sha_field([p for p in paths if p.exists() and p.is_file()]),
                "notes": notes,
                "strong_hit_count": len(strong),
                "weak_hit_count": len(weak),
                "sample_hits": [
                    {
                        "path": repo_rel(h.path),
                        "line": h.line,
                        "kind": h.kind,
                        "text": h.text[:240],
                    }
                    for h in (strong + weak)[:10]
                ],
            }
        )
    return rows


def candidate_sources(files: list[Path]) -> list[dict[str, object]]:
    patterns = (
        r"\bk\s*=\s*9\b",
        r"\bk\s*=\s*11\b",
        r"\bk=9\b",
        r"\bk=11\b",
        r"\bK9\b",
        r"\bK11\b",
        r"\b0\.84\b",
        r"\b0,84\b",
        r"gamma\s*\(\s*k\s*\)",
        r"\blambda_?9\b",
        r"\blambda_?11\b",
        r"deletion",
        r"pstex",
        r"Table 4",
        r"30apr02",
        r"6561",
        r"59049",
    )
    hits = line_hits(files, patterns, "candidate", limit=500)
    grouped: dict[Path, list[PatternHit]] = {}
    for hit in hits:
        grouped.setdefault(hit.path, []).append(hit)

    rows: list[dict[str, object]] = []
    for path, path_hits in sorted(grouped.items(), key=lambda kv: repo_rel(kv[0])):
        rows.append(
            {
                "path": repo_rel(path),
                "source_kind": source_kind(path),
                "sha256": sha256(path) if path.exists() and path.is_file() else "",
                "hit_count": len(path_hits),
                "line_refs": [f"{h.line}" for h in path_hits[:20]],
                "sample_hits": [
                    {"line": h.line, "text": h.text[:240]}
                    for h in path_hits[:8]
                ],
            }
        )
    return rows


def source_custody_summary(files: list[Path]) -> list[dict[str, object]]:
    rows = []
    for path in files:
        kind = source_kind(path)
        if kind not in {"SOURCE_CUSTODY", "SOURCE_ARCHIVE"}:
            continue
        rows.append(
            {
                "path": repo_rel(path),
                "source_kind": kind,
                "size_bytes": path.stat().st_size,
                "sha256": sha256(path),
                "text_scanned": is_text_path(path),
            }
        )
    return rows


def write_csv(path: Path, rows: list[dict[str, object]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, lineterminator="\n")
        writer.writeheader()
        for row in rows:
            encoded = {}
            for field in fieldnames:
                value = row.get(field, "")
                if isinstance(value, (list, dict)):
                    encoded[field] = json.dumps(value, ensure_ascii=False, sort_keys=True)
                else:
                    encoded[field] = value
            writer.writerow(encoded)


def output_manifest(paths: list[Path]) -> list[dict[str, str]]:
    rows = []
    for path in paths:
        rows.append(
            {
                "path": repo_rel(path),
                "sha256": sha256(path),
            }
        )
    return rows


def main() -> None:
    if not SCOPING.exists():
        raise FileNotFoundError(f"Missing scoping note: {SCOPING}")

    files = iter_candidate_files()
    checklist = build_checklist(files)
    candidates = candidate_sources(files)
    custody = source_custody_summary(files)

    tracked_classes = {
        "formula": "tracked_classes(k) = 3^(k - 1)",
        "k2": 3 ** (2 - 1),
        "k9": 3 ** (9 - 1),
        "k11": 3 ** (11 - 1),
    }
    tracked_classes["scale_factor_k9_from_k2"] = tracked_classes["k9"] // tracked_classes["k2"]
    tracked_classes["scale_factor_k11_from_k2"] = tracked_classes["k11"] // tracked_classes["k2"]

    complexity = {
        "tracked_classes": tracked_classes,
        "row_inequalities": "REQUIRES_SOURCE_INVENTORY",
        "min_max_auxiliary_terms": "REQUIRES_SOURCE_INVENTORY",
        "literal_tree_populations": "REQUIRES_SOURCE_INVENTORY",
        "maximum_elimination_depth": "REQUIRES_SOURCE_INVENTORY",
        "certificate_constants": "REQUIRES_SOURCE_INVENTORY",
        "expected_generated_lean_declarations": "REQUIRES_GENERATOR_DESIGN",
        "manual_transcription_plausibility": "NOT_PLAUSIBLE_AT_SCALE_6561_AND_59049",
    }

    inventory = {
        "run_id": RUN_ID,
        "generated_at_utc": datetime.now(timezone.utc).isoformat(),
        "repo_root": str(REPO_ROOT),
        "scoping_path": repo_rel(SCOPING),
        "scoping_sha256": sha256(SCOPING),
        "source_custody_roots": [
            str(KL2003_SOURCE_DIR),
            str(KL2003_SOURCE_TAR),
        ],
        "tracked_classes": tracked_classes,
        "complexity_metrics": complexity,
        "checklist": checklist,
        "candidate_sources": candidates,
        "source_custody": custody,
        "reusable_assets": REUSABLE_ASSETS,
        "k2_cabled_assets": K2_CABLED_ASSETS,
        "open_questions": [
            "Is there a printed/source k=9 row system, or only an algorithm plus final exponent?",
            "Where are k=9 certificate constants and endpoint precisions printed?",
            "Can k=9 rows be generated source-faithfully with manifests and independent checks?",
            "Is there a printed/source k=11 row system for the 0.84 line, or only an algorithm plus final exponent?",
            "Where are k=11/0.84 certificate constants and endpoint precisions printed?",
            "Can k=11 rows be generated source-faithfully with manifests and independent checks?",
            "What is the smallest rational slack after exact k=9 reconstruction?",
            "What is the smallest rational slack after exact k=11 reconstruction?",
            "Which row families are regular and which are exceptional?",
        ],
        "guardrails": [
            "NO_K9_THEOREM_CLAIM",
            "NO_084_EXPONENT_CLAIM",
            "NO_FULL_M1_THEOREM_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
            "NO_LEAN_K9_MODULE_OPENED",
        ],
    }

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    source_inventory_json = OUT_DIR / "source_inventory.json"
    source_inventory_csv = OUT_DIR / "source_inventory.csv"
    candidates_csv = OUT_DIR / "candidate_sources.csv"
    reusable_csv = OUT_DIR / "reusable_assets.csv"
    cabled_csv = OUT_DIR / "k2_cabled_assets.csv"
    summary_json = OUT_DIR / "summary.json"
    manifest_csv = OUT_DIR / "manifest_sha256.csv"

    source_inventory_json.write_text(
        json.dumps(inventory, indent=2, ensure_ascii=False, sort_keys=True) + "\n",
        encoding="utf-8",
    )

    write_csv(
        source_inventory_csv,
        checklist,
        [
            "item_id",
            "description",
            "expected_evidence",
            "status",
            "source_paths",
            "line_ranges_or_record_ids",
            "sha256",
            "notes",
            "strong_hit_count",
            "weak_hit_count",
            "sample_hits",
        ],
    )
    write_csv(
        candidates_csv,
        candidates,
        ["path", "source_kind", "sha256", "hit_count", "line_refs", "sample_hits"],
    )
    write_csv(
        reusable_csv,
        REUSABLE_ASSETS,
        ["asset_id", "path", "reuse_status", "notes"],
    )
    write_csv(
        cabled_csv,
        K2_CABLED_ASSETS,
        ["asset_id", "path", "cabling_reason", "replacement_needed"],
    )

    summary = {
        "run_id": RUN_ID,
        "tracked_classes": tracked_classes,
        "checklist_status_counts": {
            status: sum(1 for row in checklist if row["status"] == status)
            for status in ["FOUND_SOURCE", "FOUND_DERIVED", "AMBIGUOUS", "MISSING", "NOT_NEEDED"]
        },
        "candidate_source_count": len(candidates),
        "source_custody_file_count": len(custody),
        "output_files": [
            repo_rel(source_inventory_json),
            repo_rel(source_inventory_csv),
            repo_rel(candidates_csv),
            repo_rel(reusable_csv),
            repo_rel(cabled_csv),
            repo_rel(summary_json),
            repo_rel(manifest_csv),
        ],
        "guardrails": inventory["guardrails"],
    }
    summary_json.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n", encoding="utf-8")

    generated = [
        source_inventory_json,
        source_inventory_csv,
        candidates_csv,
        reusable_csv,
        cabled_csv,
        summary_json,
    ]
    write_csv(manifest_csv, output_manifest(generated), ["path", "sha256"])

    print(f"run_id={RUN_ID}")
    print(f"tracked_classes.k2={tracked_classes['k2']}")
    print(f"tracked_classes.k9={tracked_classes['k9']}")
    print(f"tracked_classes.k11={tracked_classes['k11']}")
    print(f"tracked_classes.scale_factor_k9_from_k2={tracked_classes['scale_factor_k9_from_k2']}")
    print(f"tracked_classes.scale_factor_k11_from_k2={tracked_classes['scale_factor_k11_from_k2']}")
    print(f"output_dir={repo_rel(OUT_DIR)}")
    print("no k=9 theorem, no 0.84 theorem, no global Collatz claim")


if __name__ == "__main__":
    main()
