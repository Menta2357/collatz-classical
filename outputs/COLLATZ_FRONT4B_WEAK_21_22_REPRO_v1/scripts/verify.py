#!/usr/bin/env python3
"""Rebuild and audit the certified Front4b weak-tail captures, descents and reentry ranks."""

import argparse
from concurrent.futures import FIRST_COMPLETED, ThreadPoolExecutor, wait
from hashlib import sha256
import json
import os
from pathlib import Path
import re
import subprocess
from tempfile import TemporaryDirectory


PACKAGE = Path(__file__).resolve().parents[1]
TOOLCHAIN = "+leanprover/lean4:v4.21.0"
STANDARD_AXIOMS = {"Classical.choice", "Quot.sound", "propext"}
AXIOM_LINE = re.compile(r"^'([^']+)' (?:depends on axioms: \[(.*)\]|does not depend on any axioms)$")


def require(condition, detail):
    if not condition:
        raise RuntimeError(detail)


def digest(path):
    return sha256(path.read_bytes()).hexdigest()


def sources(row, guards):
    checks = {}
    for line in (PACKAGE / "SHA256SUMS").read_text().splitlines():
        expected, name = line.split("  ", 1)
        relpath = Path(name)
        require(not relpath.is_absolute() and ".." not in relpath.parts and name not in checks,
                f"Invalid package path: {name}")
        require(digest(PACKAGE / relpath) == expected, f"SHA-256 mismatch: {name}")
        checks[name] = expected
    manifest = json.loads((PACKAGE / "provenance/manifest.json").read_text())
    modules = {}
    for spec in manifest["modules"]:
        name = spec["module"]
        path = Path(spec["path"])
        require(path == Path(f"lean/{name}.lean") and name not in modules, f"Invalid module path: {path}")
        origin = spec["origin"]
        origins = {"row_v1": row, "guards_v1": guards, "weak_v1": PACKAGE}
        require(origin in origins, f"Unknown source package: {origin}")
        source = origins[origin] / path
        if origin == "weak_v1":
            require(path.as_posix() in checks, f"Missing source hash: {path}")
        require(digest(source) == spec["sha256"], f"Lean source differs: {name}")
        imports = re.findall(r"^import\s+([\w.]+)", source.read_text(), re.M)
        require(imports == spec["imports"], f"Lean imports differ: {name}")
        modules[name] = (source, set(imports) - {"Std"})
    roots = manifest["roots"]
    require(all(root in modules for root in roots), "Missing audit root")
    require(all(imports <= modules.keys() for _, imports in modules.values()), "Open dependency closure")
    return modules, roots


def run(lean, args, out, env=None):
    result = subprocess.run([lean, TOOLCHAIN, *args], cwd=out, env=env, text=True,
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    require(result.returncode == 0, result.stdout)
    return result.stdout


def rebuild(lean, modules, output, threads):
    env = dict(os.environ, LEAN_PATH=str(output))
    env.pop("LEAN_SRC_PATH", None)
    pending = set(modules)
    built = set()

    def compile_module(name):
        source, _ = modules[name]
        return run(lean, ["-j1", "-s65536", "-DwarningAsError=true", f"--root={source.parent}",
                          "-o", str(output / f"{name}.olean"), str(source)], output, env)

    with ThreadPoolExecutor(max_workers=threads) as pool:
        in_flight = {}
        while pending or in_flight:
            ready = sorted(name for name in pending if modules[name][1] <= built)
            for name in ready[:threads - len(in_flight)]:
                in_flight[pool.submit(compile_module, name)] = name
                pending.remove(name)
            require(in_flight, "Cyclic module graph")
            completed, _ = wait(in_flight, return_when=FIRST_COMPLETED)
            for future in completed:
                future.result()
                name = in_flight.pop(future)
                built.add(name)
                print(f"Built {name}", flush=True)
    return env


def audit(lean, roots, output, env):
    expected = json.loads((PACKAGE / "provenance/axioms_expected.json").read_text())
    require(expected and all(set(axioms) <= STANDARD_AXIOMS for axioms in expected.values()),
            "Invalid expected axiom audit")
    script = output / "Audit.lean"
    script.write_text("".join(f"import {root}\n" for root in roots)
                      + "".join(f"#print axioms {name}\n" for name in expected))
    log = run(lean, ["-j1", "-s65536", "-DwarningAsError=true", str(script)], output, env)
    actual = {}
    log = re.sub(r"\n[ \t]+", " ", log)
    for line in log.splitlines():
        match = AXIOM_LINE.fullmatch(line.strip())
        require(match, f"Unexpected audit output: {line}")
        name, axioms = match.groups()
        actual[name] = sorted(axioms.split(", ")) if axioms else []
    require(actual == expected, f"Axiom audit mismatch:\n{log}")
    print(log, end="")
    return len(actual)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--lean", default="lean")
    parser.add_argument("--row", type=Path, default=PACKAGE.parent / "COLLATZ_A2_FRONT4B_Q81_ROW_REPRO_v1")
    parser.add_argument("--guards", type=Path, default=PACKAGE.parent / "COLLATZ_FRONT4B_GUARDS_REPRO_v1")
    parser.add_argument("--jobs", default=2, type=int, help="Concurrent one-thread Lean builds")
    args = parser.parse_args()
    require(args.jobs > 0, "--jobs must be positive")
    modules, roots = sources(args.row.resolve(), args.guards.resolve())
    with TemporaryDirectory(prefix="a2-front4b-") as folder:
        output = Path(folder).resolve()
        version = run(args.lean, ["--version"], output).strip()
        require(version.startswith("Lean (version 4.21.0,"), "Expected Lean v4.21.0")
        print(version, flush=True)
        environment = rebuild(args.lean, modules, output, args.jobs)
        count = audit(args.lean, roots, output, environment)
    print(f"PASS: {len(modules)} project modules, {count} audited declarations.")


if __name__ == "__main__":
    try:
        main()
    except (OSError, RuntimeError, ValueError) as error:
        raise SystemExit(str(error)) from error
