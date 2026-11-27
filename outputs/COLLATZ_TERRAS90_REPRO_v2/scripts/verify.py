"""Rebuild the Terras 90 Lean closure and check its theorem axiom reports."""

import argparse
from concurrent.futures import ThreadPoolExecutor, FIRST_COMPLETED, wait
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
from tempfile import TemporaryDirectory


PACKAGE = Path(__file__).resolve().parents[1]
AXIOM_LINE = re.compile(r"^'([^']+)' (?:depends on axioms: \[(.*)\]|does not depend on any axioms)$")
STANDARD_AXIOMS = {"Classical.choice", "Quot.sound", "propext"}


def run(args, env=None, *, cwd=PACKAGE):
    process = subprocess.run(args, cwd=cwd, env=env, text=True, stdout=subprocess.PIPE,
                             stderr=subprocess.STDOUT)
    if process.returncode:
        raise RuntimeError(f"{' '.join(map(str, args))} failed\n{process.stdout}")
    return process.stdout


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify_sources():
    known_paths = set()
    for line in (PACKAGE / "SHA256SUMS").read_text().splitlines():
        expected, name = line.split("  ", 1)
        relpath = Path(name)
        if relpath.is_absolute() or ".." in relpath.parts or name in known_paths:
            raise RuntimeError(f"Invalid path in SHA256SUMS: {name}")
        if sha(PACKAGE / relpath) != expected:
            raise RuntimeError(f"SHA-256 mismatch: {name}")
        known_paths.add(name)

    manifest = json.loads((PACKAGE / "provenance/lean_sources.json").read_text())
    modules = {}
    for spec in manifest["modules"]:
        name = spec["module"]
        if name in modules or spec["path"] != f"lean/{name}.lean":
            raise RuntimeError(f"Invalid module in source manifest: {name}")
        if spec["path"] not in known_paths or sha(PACKAGE / spec["path"]) != spec["sha256"]:
            raise RuntimeError(f"Source manifest mismatch: {spec['path']}")
        modules[name] = spec
    actual = {source.relative_to(PACKAGE).as_posix() for source in (PACKAGE / "lean").glob("*.lean")}
    expected = {spec["path"] for spec in modules.values()}
    if actual != expected or expected != {name for name in known_paths if name.startswith("lean/")}:
        raise RuntimeError("Bundled Lean files and manifests disagree.")
    if not all(root in modules for root in manifest["roots"]):
        raise RuntimeError("A root is missing from the Lean closure.")
    return manifest["roots"], modules


def dependency_paths(packages):
    lock = json.loads((PACKAGE / "lake-manifest.json").read_text())
    paths = []
    for spec in lock["packages"]:
        library = packages / spec["name"]
        head = run(["git", "-C", str(library), "rev-parse", "HEAD"]).strip()
        if head != spec["rev"]:
            raise RuntimeError(f"Wrong dependency revision for {spec['name']}: {head}")
        lib = library / ".lake/build/lib/lean"
        if lib.is_dir():
            paths.append(lib)
    if not (packages / "mathlib/.lake/build/lib/lean/Mathlib.olean").is_file():
        raise RuntimeError("Mathlib cache is missing. Run `lake exe cache get`.")
    return paths


def rebuild(lean, modules, out, paths, jobs):
    env = os.environ.copy()
    # Start with our empty output and use only the pinned dependency libraries.
    env["LEAN_PATH"] = os.pathsep.join(str(path) for path in (out, *paths))
    env.pop("LEAN_SRC_PATH", None)
    deps = {name: set(spec["imports"]) & modules.keys() for name, spec in modules.items()}
    pending = set(modules)
    completed = set()

    def compile_module(name):
        return run([lean, "-j1", "-s65536", "-DwarningAsError=true", "-o",
                    str(out / f"{name}.olean"), modules[name]["path"]], env)

    with ThreadPoolExecutor(max_workers=jobs) as pool:
        running = {}
        while pending or running:
            ready = sorted(name for name in pending if deps[name] <= completed)
            for name in ready[:jobs - len(running)]:
                running[pool.submit(compile_module, name)] = name
                pending.remove(name)
            if not running:
                raise RuntimeError(f"Cyclic or incomplete import graph: {sorted(pending)}")
            done, _ = wait(running, return_when=FIRST_COMPLETED)
            for future in done:
                name = running.pop(future)
                future.result()
                completed.add(name)
                print(f"Built {name}", flush=True)
    return env


def audit(lean, roots, out, env):
    expected = json.loads((PACKAGE / "provenance/axioms_expected.json").read_text())
    if not expected or any(not set(axioms) <= STANDARD_AXIOMS for axioms in expected.values()):
        raise RuntimeError("Invalid axiom expectations.")
    script = out / "Audit.lean"
    script.write_text("".join(f"import {root}\n" for root in roots)
                      + "\n".join(f"#print axioms {theorem}" for theorem in expected) + "\n")
    output = run([lean, "-j1", "-s65536", "-DwarningAsError=true",
                  f"--root={out}", str(script)], env)
    found = {}
    for line in output.splitlines():
        match = AXIOM_LINE.fullmatch(line.strip())
        if match:
            theorem, axioms = match.groups()
            found[theorem] = sorted(axioms.split(", ")) if axioms else []
    if found != expected:
        raise RuntimeError(f"Unexpected Lean axiom report\n{output}")
    print(output, end="")


def main():
    cli = argparse.ArgumentParser(description=__doc__)
    cli.add_argument("--lean", default="lean")
    cli.add_argument("--packages", type=Path, default=PACKAGE / ".lake/packages",
                     help="Optional cache directory prepared from the pinned dependency revisions")
    cli.add_argument("--jobs", type=int, default=2)
    cli.add_argument("--keep-build", type=Path, help="Keep newly built modules in an empty directory")
    args = cli.parse_args()
    if args.jobs < 1:
        cli.error("--jobs must be positive")

    version = run([args.lean, "--version"]).strip()
    if not version.startswith("Lean (version 4.21.0,"):
        cli.error(f"Expected Lean v4.21.0; found {version}")
    print(version, flush=True)
    roots, modules = verify_sources()
    paths = dependency_paths(args.packages.resolve())

    def verify(out):
        env = rebuild(args.lean, modules, out, paths, args.jobs)
        audit(args.lean, roots, out, env)

    if args.keep_build:
        output = args.keep_build.resolve()
        output.mkdir(parents=True, exist_ok=True)
        if list(output.iterdir()):
            cli.error("--keep-build must be empty")
        verify(output)
    else:
        with TemporaryDirectory(prefix="terras90-lean-") as work:
            verify(Path(work).resolve())
    print(f"Verified {len(modules)} sources and the theorem axiom reports.", flush=True)


if __name__ == "__main__":
    try:
        main()
    except (OSError, RuntimeError, ValueError) as error:
        raise SystemExit(str(error)) from error
