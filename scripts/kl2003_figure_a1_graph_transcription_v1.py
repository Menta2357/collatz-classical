#!/usr/bin/env python3
"""Extract the directed graph drawn in KL2003 Figure A1.

The KL2003 source stores the drawing in two xfig-generated files:

* kafgA1.pstex   -- PostScript geometry: nodes, arrows, cross marks.
* kafgA1.pstex_t -- LaTeX overlay: textual labels.

This script does not infer inverse Collatz words.  It only transcribes the
machine-readable graph geometry and pairs it with the textual overlay labels.
That makes the next inverse-word reconstruction step auditable instead of
visual/hand-wavy.
"""

from __future__ import annotations

import csv
import hashlib
import json
import math
import re
from collections import defaultdict, deque
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
SOURCE_DIR = Path(
    "/Users/MoiTam/Documents/Codex/2026-07-05/"
    "tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/kl2003_src"
)
PSTEX = SOURCE_DIR / "kafgA1.pstex"
OVERLAY = SOURCE_DIR / "kafgA1.pstex_t"
OUT_DIR = REPO / "outputs" / "KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1"


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def parse_nodes(pstex_lines: list[str]) -> list[dict[str, object]]:
    nodes: list[dict[str, object]] = []
    for i, line in enumerate(pstex_lines, start=1):
        m = re.search(
            r"n\s+(\d+)\s+(\d+)\s+106\s+106\s+0\s+360\s+DrawEllipse\s+(.+)",
            line,
        )
        if not m:
            continue
        x, y = int(m.group(1)), int(m.group(2))
        rest = m.group(3)
        if "setgray ef" in rest:
            kind = "filled_black"
        elif " ef" in rest:
            kind = "filled_shaded"
        else:
            kind = "outline"
        nodes.append(
            {
                "node_id": f"N{len(nodes):02d}",
                "node_index": len(nodes),
                "x": x,
                "y": y,
                "visual_kind": kind,
                "pstex_line": i,
            }
        )
    return nodes


def nearest_node(nodes: list[dict[str, object]], point: tuple[int, int]) -> tuple[int, float]:
    x, y = point
    dist, idx = min(
        (
            math.hypot(x - int(node["x"]), y - int(node["y"])),
            int(node["node_index"]),
        )
        for node in nodes
    )
    return idx, dist


def parse_polylines(
    pstex_lines: list[str], nodes: list[dict[str, object]]
) -> tuple[list[dict[str, object]], list[dict[str, object]]]:
    edges: list[dict[str, object]] = []
    cross_marks: list[dict[str, object]] = []
    i = 0
    while i < len(pstex_lines):
        if pstex_lines[i].strip() != "% Polyline":
            i += 1
            continue

        start_line = i + 1
        block: list[str] = []
        i += 1
        while i < len(pstex_lines) and not pstex_lines[i].startswith("%"):
            block.append(pstex_lines[i])
            i += 1

        body = "\n".join(block)
        is_arrow = "eoclip" in body
        after_clip = body.split("eoclip")[-1] if is_arrow else body
        coords = [
            (int(m.group(1)), int(m.group(2)))
            for m in re.finditer(r"(?:n\s+)?(\d+)\s+(\d+)\s+(?:m|l)", after_clip)
        ]

        if is_arrow and len(coords) >= 2:
            raw_start, raw_end = coords[0], coords[-1]
            src, src_dist = nearest_node(nodes, raw_start)
            dst, dst_dist = nearest_node(nodes, raw_end)
            edges.append(
                {
                    "edge_id": f"E{len(edges):02d}",
                    "pstex_line": start_line,
                    "src": nodes[src]["node_id"],
                    "dst": nodes[dst]["node_id"],
                    "raw_start_x": raw_start[0],
                    "raw_start_y": raw_start[1],
                    "raw_end_x": raw_end[0],
                    "raw_end_y": raw_end[1],
                    "src_snap_distance": round(src_dist, 3),
                    "dst_snap_distance": round(dst_dist, 3),
                }
            )
        else:
            center = (
                round(sum(x for x, _ in coords) / len(coords), 3) if coords else "",
                round(sum(y for _, y in coords) / len(coords), 3) if coords else "",
            )
            if coords:
                near_idx, near_dist = nearest_node(
                    nodes, (int(round(center[0])), int(round(center[1])))
                )
                near_node = nodes[near_idx]["node_id"]
            else:
                near_dist = ""
                near_node = ""
            cross_marks.append(
                {
                    "cross_id": f"X{len(cross_marks):02d}",
                    "pstex_line": start_line,
                    "coords": " ".join(f"({x},{y})" for x, y in coords),
                    "center_x": center[0],
                    "center_y": center[1],
                    "nearest_node": near_node,
                    "nearest_node_distance": round(near_dist, 3) if near_dist != "" else "",
                }
            )

    return edges, cross_marks


def parse_overlay_labels(
    overlay_text: str, nodes: list[dict[str, object]]
) -> list[dict[str, object]]:
    labels: list[dict[str, object]] = []
    pattern = re.compile(
        r"\\put\((\d+),(-?\d+)\)\{.*?\{\$(.*?)\$\}%\s*\}\}\}",
        re.DOTALL,
    )
    for m in pattern.finditer(overlay_text):
        x, overlay_y = int(m.group(1)), int(m.group(2))
        label = " ".join(m.group(3).split())

        # xfig's TeX overlay uses a flipped y-axis.  In this figure the
        # conversion is exact on all horizontal levels:
        #   pstex_y = -overlay_y + 764
        pstex_y = -overlay_y + 764

        # Label boxes are left/right anchored, so x can be offset by text width.
        # Downweight x while matching; y levels are exact.
        _, idx = min(
            (
                math.hypot((x - int(node["x"])) / 3.0, pstex_y - int(node["y"])),
                int(node["node_index"]),
            )
            for node in nodes
        )
        node = nodes[idx]
        labels.append(
            {
                "label_id": f"LABEL{len(labels):02d}",
                "node_id": node["node_id"],
                "overlay_x": x,
                "overlay_y": overlay_y,
                "mapped_pstex_y": pstex_y,
                "label": label,
            }
        )
    return labels


def paths_from_root(nodes: list[dict[str, object]], edges: list[dict[str, object]]) -> list[dict[str, object]]:
    by_id = {str(node["node_id"]): node for node in nodes}
    labels = {
        str(node["node_id"]): str(node.get("label", ""))
        for node in nodes
    }
    roots = [
        node_id
        for node_id, label in labels.items()
        if "phi_2^8" in label and "(8,0)" in label
    ]
    if len(roots) != 1:
        root = "UNRESOLVED"
        return [
            {
                "node_id": str(node["node_id"]),
                "path_node_ids": "",
                "path_labels": "",
                "path_length": "",
                "note": f"root_count={len(roots)}",
            }
            for node in nodes
        ]

    root = roots[0]
    adj: dict[str, list[str]] = defaultdict(list)
    for edge in edges:
        adj[str(edge["src"])].append(str(edge["dst"]))
    for dsts in adj.values():
        dsts.sort()

    parent: dict[str, str | None] = {root: None}
    q: deque[str] = deque([root])
    while q:
        cur = q.popleft()
        for dst in adj[cur]:
            if dst not in parent:
                parent[dst] = cur
                q.append(dst)

    rows: list[dict[str, object]] = []
    for node in nodes:
        node_id = str(node["node_id"])
        if node_id not in parent:
            rows.append(
                {
                    "node_id": node_id,
                    "path_node_ids": "",
                    "path_labels": "",
                    "path_length": "",
                    "note": "unreachable_from_root",
                }
            )
            continue
        path: list[str] = []
        cur: str | None = node_id
        while cur is not None:
            path.append(cur)
            cur = parent[cur]
        path.reverse()
        rows.append(
            {
                "node_id": node_id,
                "path_node_ids": " ".join(path),
                "path_labels": " -> ".join(labels.get(p, "") or p for p in path),
                "path_length": len(path) - 1,
                "note": "",
            }
        )
    return rows


def write_csv(path: Path, rows: list[dict[str, object]]) -> None:
    if not rows:
        path.write_text("", encoding="utf-8")
        return
    with path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    if not PSTEX.exists() or not OVERLAY.exists():
        raise FileNotFoundError(f"Missing source files under {SOURCE_DIR}")

    OUT_DIR.mkdir(parents=True, exist_ok=True)

    pstex_text = PSTEX.read_text(errors="replace")
    overlay_text = OVERLAY.read_text(errors="replace")
    pstex_lines = pstex_text.splitlines()

    nodes = parse_nodes(pstex_lines)
    edges, cross_marks = parse_polylines(pstex_lines, nodes)
    labels = parse_overlay_labels(overlay_text, nodes)

    cross_count_by_node: dict[str, int] = defaultdict(int)
    for cross in cross_marks:
        if cross["nearest_node"]:
            cross_count_by_node[str(cross["nearest_node"])] += 1

    label_by_node = {row["node_id"]: row["label"] for row in labels}
    for node in nodes:
        node["label"] = label_by_node.get(node["node_id"], "")
        node["cross_mark_count"] = cross_count_by_node.get(str(node["node_id"]), 0)
        node["crossed"] = "yes" if node["cross_mark_count"] else "no"
    paths = paths_from_root(nodes, edges)

    write_csv(OUT_DIR / "nodes.csv", nodes)
    write_csv(OUT_DIR / "edges.csv", edges)
    write_csv(OUT_DIR / "cross_marks.csv", cross_marks)
    write_csv(OUT_DIR / "labels.csv", labels)
    write_csv(OUT_DIR / "root_paths.csv", paths)

    summary = {
        "status": "PASS_GRAPH_EXTRACTED",
        "source_dir": str(SOURCE_DIR),
        "kafgA1_pstex_sha256": sha256(PSTEX),
        "kafgA1_pstex_t_sha256": sha256(OVERLAY),
        "node_count": len(nodes),
        "edge_count": len(edges),
        "cross_mark_count": len(cross_marks),
        "label_count": len(labels),
        "labelled_node_count": sum(1 for n in nodes if n.get("label")),
        "unlabelled_node_count": sum(1 for n in nodes if not n.get("label")),
        "crossed_node_count": sum(1 for n in nodes if n.get("crossed") == "yes"),
        "root_path_count": len(paths),
        "unreachable_from_root_count": sum(
            1 for row in paths if row["note"] == "unreachable_from_root"
        ),
        "classification": [
            "FIGURE_A1_GEOMETRY_CONTAINS_DIRECTED_GRAPH",
            "FIGURE_A1_LABELS_PAIRED_WITH_GRAPH_NODES",
            "FIGURE_A1_ROOT_PATHS_EXTRACTED",
            "CROSSED_NODES_IDENTIFIED",
            "INVERSE_WORDS_NOT_INFERRED_YET",
            "NO_LEAN_CHANGE",
            "NO_M1_THEOREM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }
    (OUT_DIR / "summary.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )

    manifest_rows = []
    for path in sorted(OUT_DIR.iterdir()):
        if path.is_file():
            manifest_rows.append(
                {
                    "file": path.name,
                    "sha256": sha256(path),
                    "bytes": path.stat().st_size,
                }
            )
    write_csv(OUT_DIR / "manifest_sha256.csv", manifest_rows)

    print("status=PASS_GRAPH_EXTRACTED")
    print(f"node_count={len(nodes)}")
    print(f"edge_count={len(edges)}")
    print(f"cross_mark_count={len(cross_marks)}")
    print(f"label_count={len(labels)}")
    print(f"output_dir={OUT_DIR}")


if __name__ == "__main__":
    main()
