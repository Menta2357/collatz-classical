#!/usr/bin/env bash
set -euo pipefail

custody_root='/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo'
reconstruction_root='/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/reconstruction-publication-gate2-ef1a5a7'

expected_public_branch='agent/mazur-rhin-anchored-warm-gate-v3'
expected_public_ref="refs/heads/$expected_public_branch"
expected_origin='https://github.com/Menta2357/collatz-classical.git'
expected_reconstruction='b7da87864ced8abd6c3715b65320efc233c0d853'
expected_theorem='a7f3bef1c7184b514c3cc6833da03a3eefd5f41b3bea58bf4062885d7bfab7b1'
expected_audit='4c75fd87933592842a70a4f861f29fa685c73ea81a62ed359437b8170506f688'
expected_manifest='bc45e15b36f7aede2ceed922babf4bbcacb6789a1ec2d85bd571105fcd73926e'

test "$(git -C "$custody_root" branch --show-current)" = "$expected_public_branch"
test "$(git -C "$custody_root" remote get-url origin)" = "$expected_origin"
git -C "$custody_root" diff --quiet
git -C "$custody_root" diff --cached --quiet

local_head=$(git -C "$custody_root" rev-parse HEAD)
if ! remote_receipt=$(
  GIT_TERMINAL_PROMPT=0 git -C "$custody_root" ls-remote \
    --exit-code --refs origin "$expected_public_ref"
); then
  printf '%s\n' 'F0_PUBLIC_REF_QUERY_STOP'
  exit 1
fi

remote_line_count=$(printf '%s\n' "$remote_receipt" | awk 'END { print NR }')
if [[ "$remote_line_count" -ne 1 ]]; then
  printf '%s\n' 'F0_PUBLIC_REF_SHAPE_STOP'
  exit 1
fi
if ! IFS=$'\t' read -r remote_sha remote_ref remote_extra <<< "$remote_receipt"; then
  printf '%s\n' 'F0_PUBLIC_REF_SHAPE_STOP'
  exit 1
fi
if [[ -n "${remote_extra:-}" || "$remote_ref" != "$expected_public_ref" ]]; then
  printf '%s\n' 'F0_PUBLIC_REF_SHAPE_STOP'
  exit 1
fi
if [[ "$remote_sha" != "$local_head" ]]; then
  printf '%s\n' 'F0_PUBLIC_HEAD_MISMATCH_STOP'
  exit 1
fi

printf '%s\n' \
  "F0_LOCAL_EXECUTION_HEAD=$local_head" \
  "F0_PUBLIC_BRANCH_HEAD=$remote_sha" \
  "F0_PUBLIC_REF=$remote_ref" \
  'F0_PUBLIC_HEAD_EQUALS_LOCAL=PASS'

test "$(git -C "$reconstruction_root" rev-parse HEAD)" = "$expected_reconstruction"
git -C "$reconstruction_root" diff --quiet
git -C "$reconstruction_root" diff --cached --quiet

unexpected_status=$(git -C "$reconstruction_root" status --porcelain | grep -Ev '^\?\? (\.lake/|Erdos1135/ND/FusionRhinAnchored\.lean|FusionRhinAnchoredAxiomAudit\.lean|lake-manifest\.json)$' || true)
test -z "$unexpected_status"

test "$(shasum -a 256 "$reconstruction_root/Erdos1135/ND/FusionRhinAnchored.lean" | awk '{print $1}')" = "$expected_theorem"
test "$(shasum -a 256 "$reconstruction_root/FusionRhinAnchoredAxiomAudit.lean" | awk '{print $1}')" = "$expected_audit"
test "$(shasum -a 256 "$reconstruction_root/lake-manifest.json" | awk '{print $1}')" = "$expected_manifest"

cmp -s "$reconstruction_root/Erdos1135/ND/FusionRhinAnchored.lean" "$custody_root/artifacts/mazur-rhin-anchored-ca3/payload/Erdos1135/ND/FusionRhinAnchored.lean"
cmp -s "$reconstruction_root/FusionRhinAnchoredAxiomAudit.lean" "$custody_root/artifacts/mazur-rhin-anchored-ca3/payload/FusionRhinAnchoredAxiomAudit.lean"

test "$(tr -d '\r\n' < "$reconstruction_root/lean-toolchain")" = 'leanprover/lean4:v4.30.0'
grep -Fq 'c5ea00351c28e24afc9f0f84379aa41082b1188f' "$reconstruction_root/lake-manifest.json"
test "$(git -C "$reconstruction_root/.lake/packages/mathlib" rev-parse HEAD)" = 'c5ea00351c28e24afc9f0f84379aa41082b1188f'
git -C "$reconstruction_root/.lake/packages/mathlib" diff --quiet
git -C "$reconstruction_root/.lake/packages/mathlib" diff --cached --quiet

available_kb=$(df -Pk "$reconstruction_root" | awk 'NR == 2 {print $4}')
test "$available_kb" -ge 12582912

test -s "$reconstruction_root/.lake/build/lib/lean/Erdos1135/ND/FusionParametric.olean"
test -s "$reconstruction_root/.lake/build/lib/lean/Erdos1135/ND/FusionParametric.ilean"
test ! -e "$reconstruction_root/.lake/build/lib/lean/Erdos1135/ND/RhinUnconditional.olean"
test ! -e "$reconstruction_root/.lake/build/lib/lean/Erdos1135/ND/RhinUnconditional.ilean"
test ! -e "$reconstruction_root/.lake/build/lib/lean/Erdos1135/ND/FusionRhinAnchored.olean"
test ! -e "$reconstruction_root/.lake/build/lib/lean/Erdos1135/ND/FusionRhinAnchored.ilean"

for log_name in D1_dependency_prepay.full.log P1_target_build.full.log A1_axiom_audit.full.log; do
  test ! -e "$custody_root/artifacts/mazur-rhin-anchored-ca3/rhin-v3-logs/$log_name"
done

printf '%s\n' \
  'F0_CUSTODY_TRACKED_DIFF=EMPTY' \
  'F0_RECONSTRUCTION_COMMIT=PASS' \
  'F0_RECONSTRUCTION_TRACKED_DIFF=EMPTY' \
  'F0_UNTRACKED_SCOPE=EXPECTED_ONLY' \
  'F0_CANDIDATE_HASHES=PASS' \
  'F0_CANDIDATE_BYTE_IDENTITY=PASS' \
  'F0_TOOLCHAIN=leanprover/lean4:v4.30.0' \
  'F0_MATHLIB_REV=c5ea00351c28e24afc9f0f84379aa41082b1188f' \
  'F0_MATHLIB_WORKTREE=TRACKED_CLEAN' \
  "F0_AVAILABLE_KB=$available_kb" \
  'F0_DISK_MINIMUM_12_GIB=PASS' \
  'F0_FUSION_PARAMETRIC_CACHE=PRESENT' \
  'F0_RHIN_AND_TARGET_ARTIFACTS=ABSENT' \
  'F0_LATER_PHASE_LOGS=ABSENT' \
  'F0_PREFLIGHT=PASS'
