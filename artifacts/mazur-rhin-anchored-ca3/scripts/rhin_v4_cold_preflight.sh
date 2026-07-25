#!/usr/bin/env bash
set -euo pipefail

# This script is check-only.  In particular, F0 must leave the reconstruction
# tree cold and must not create either .lake or the dedicated Mathlib cache.

custody_root='/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo'
reconstruction_root='/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/reconstruction-publication-gate2-ef1a5a7'
coordination_root='/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion'
cache_dir="$coordination_root/.rhin-v4-mathlib-cache"
lock_path="$coordination_root/.rhin-v4-executor.lock"
log_root="$custody_root/artifacts/mazur-rhin-anchored-ca3/rhin-v4-logs"

contract_path="$custody_root/docs/MAZUR_RHIN_ANCHORED_FUSION_GATE_v4_COLD_CONTRACT.md"
addendum_path="$custody_root/docs/MAZUR_RHIN_ANCHORED_FUSION_GATE_v4_PUBLIC_RECEIPT_ADDENDUM_v1.md"
executor_path="$custody_root/artifacts/mazur-rhin-anchored-ca3/scripts/rhin_v4_cold_executor.sh"
preflight_path="$custody_root/artifacts/mazur-rhin-anchored-ca3/scripts/rhin_v4_cold_preflight.sh"
static_review_path="$custody_root/docs/MAZUR_RHIN_ANCHORED_FUSION_GATE_v4_STATIC_REVIEW.md"
custody_theorem="$custody_root/artifacts/mazur-rhin-anchored-ca3/payload/Erdos1135/ND/FusionRhinAnchored.lean"
custody_audit="$custody_root/artifacts/mazur-rhin-anchored-ca3/payload/FusionRhinAnchoredAxiomAudit.lean"
reconstruction_theorem="$reconstruction_root/Erdos1135/ND/FusionRhinAnchored.lean"
reconstruction_audit="$reconstruction_root/FusionRhinAnchoredAxiomAudit.lean"
manifest_path="$reconstruction_root/lake-manifest.json"

expected_public_branch='agent/mazur-rhin-anchored-cold-gate-v4'
expected_public_ref="refs/heads/$expected_public_branch"
expected_origin='https://github.com/Menta2357/collatz-classical.git'
expected_contract_commit='14705133a2169a8539cbcb39cfe7e2ca9fb4f5fd'
expected_reconstruction='b7da87864ced8abd6c3715b65320efc233c0d853'
expected_theorem='a7f3bef1c7184b514c3cc6833da03a3eefd5f41b3bea58bf4062885d7bfab7b1'
expected_audit='4c75fd87933592842a70a4f861f29fa685c73ea81a62ed359437b8170506f688'
expected_manifest='bc45e15b36f7aede2ceed922babf4bbcacb6789a1ec2d85bd571105fcd73926e'
expected_contract='961ee5c327a675e93de2640c3de459956dfd979c36c2fbaa674fa8d3498b2711'
expected_mathlib='c5ea00351c28e24afc9f0f84379aa41082b1188f'
expected_toolchain='leanprover/lean4:v4.30.0'
minimum_available_kb='20971520'
process_matcher_id='rhin-v4-process-matcher-v3'
expected_addendum='867ce88268c552d50c09695e26474e284f9c9d8ff7171fdc65b00c879efa0d1f'

pre_run_receipt_content=''
executor_pid="${RHIN_V4_EXECUTOR_PID:?RHIN_V4_EXECUTOR_PID is required}"
inherited_lock_path="${RHIN_V4_LOCK_PATH:?RHIN_V4_LOCK_PATH is required}"
process_audit_receipt="${RHIN_V4_PROCESS_AUDIT_RECEIPT:?RHIN_V4_PROCESS_AUDIT_RECEIPT is required}"

sha256_file() {
  shasum -a 256 "$1" | awk '{ print $1 }'
}

receipt_value() {
  local key="$1"
  printf '%s\n' "$pre_run_receipt_content" | awk -v prefix="$key=" '
    $0 == "V4_PRE_RUN_FIELDS_BEGIN" {
      if (begin_count != 0 || inside || end_count != 0) bad = 1
      begin_count += 1
      inside = 1
      next
    }
    $0 == "V4_PRE_RUN_FIELDS_END" {
      if (!inside || end_count != 0) bad = 1
      end_count += 1
      inside = 0
      next
    }
    inside && index($0, prefix) == 1 {
      count += 1
      value = substr($0, length(prefix) + 1)
    }
    END {
      if (bad || inside || begin_count != 1 || end_count != 1 || count != 1 || value == "") exit 2
      print value
    }
  '
}

require_snapshot_block() {
  printf '%s\n' "$pre_run_receipt_content" | awk '
    $0 == "V4_PRE_RUN_PROCESS_SNAPSHOT_BEGIN" {
      if (begin_count != 0 || inside || end_count != 0) bad = 1
      begin_count += 1
      inside = 1
      next
    }
    $0 == "V4_PRE_RUN_PROCESS_SNAPSHOT_END" {
      if (!inside || end_count != 0) bad = 1
      end_count += 1
      inside = 0
      next
    }
    inside { row_count += 1 }
    END {
      if (bad || inside || begin_count != 1 || end_count != 1 || row_count < 1) exit 2
    }
  '
}

require_receipt_value() {
  local key="$1"
  local expected="$2"
  local actual
  if ! actual=$(receipt_value "$key"); then
    printf '%s\n' "F0_PRE_RUN_RECEIPT_FIELD_STOP=$key"
    exit 1
  fi
  if [[ "$actual" != "$expected" ]]; then
    printf '%s\n' "F0_PRE_RUN_RECEIPT_VALUE_STOP=$key"
    exit 1
  fi
}

require_hash_binding() {
  local key="$1"
  local path="$2"
  local expected
  local actual
  if ! expected=$(receipt_value "$key"); then
    printf '%s\n' "F0_PRE_RUN_HASH_FIELD_STOP=$key"
    exit 1
  fi
  if [[ ! "$expected" =~ ^[0-9a-f]{64}$ ]]; then
    printf '%s\n' "F0_PRE_RUN_HASH_SHAPE_STOP=$key"
    exit 1
  fi
  actual=$(sha256_file "$path")
  if [[ "$actual" != "$expected" ]]; then
    printf '%s\n' "F0_PRE_RUN_HASH_MISMATCH_STOP=$key"
    exit 1
  fi
}

test -f "$contract_path"
test -f "$addendum_path"
test -f "$executor_path"
test -f "$preflight_path"
test -f "$static_review_path"
test -f "$custody_theorem"
test -f "$custody_audit"
test -f "$reconstruction_theorem"
test -f "$reconstruction_audit"
test -f "$manifest_path"

test "$inherited_lock_path" = "$lock_path"
test -d "$lock_path"
test -f "$lock_path/owner_pid"
test -f "$lock_path/execution_head"
if [[ ! "$executor_pid" =~ ^[0-9]+$ ]]; then
  printf '%s\n' 'F0_EXECUTOR_PID_SHAPE_STOP'
  exit 1
fi
test "$(tr -d '\r\n' < "$lock_path/owner_pid")" = "$executor_pid"
kill -0 "$executor_pid"
test "$process_audit_receipt" = "$log_root/Q0_before_F0_process_audit.full.log"
test -s "$process_audit_receipt"
grep -Fxq 'PROCESS_AUDIT_STAGE=F0' "$process_audit_receipt"
grep -Fxq "PROCESS_AUDIT_EXECUTOR_PID=$executor_pid" "$process_audit_receipt"
grep -Fxq "PROCESS_AUDIT_MATCHER_ID=$process_matcher_id" "$process_audit_receipt"
grep -Fxq 'PROCESS_AUDIT_MATCH_COUNT=0' "$process_audit_receipt"
grep -Fxq 'PROCESS_AUDIT=PASS' "$process_audit_receipt"
grep -Fxq 'PROCESS_SNAPSHOT_BEGIN' "$process_audit_receipt"
grep -Fxq 'PROCESS_SNAPSHOT_END' "$process_audit_receipt"

test "$(git -C "$custody_root" branch --show-current)" = "$expected_public_branch"
test "$(git -C "$custody_root" remote get-url origin)" = "$expected_origin"
git -C "$custody_root" diff --quiet
git -C "$custody_root" diff --cached --quiet

local_head=$(git -C "$custody_root" rev-parse HEAD)
if [[ ! "$local_head" =~ ^[0-9a-f]{40}$ ]]; then
  printf '%s\n' 'F0_LOCAL_HEAD_SHAPE_STOP'
  exit 1
fi
test "$(tr -d '\r\n' < "$lock_path/execution_head")" = "$local_head"
git -C "$custody_root" merge-base --is-ancestor "$expected_contract_commit" "$local_head"
expected_tag_name="rhin-v4-prerun-$local_head"
expected_tag_ref="refs/tags/$expected_tag_name"
expected_tag_peeled_ref="$expected_tag_ref^{}"
if [[ "$(git -C "$custody_root" cat-file -t "$expected_tag_ref" 2>/dev/null || true)" != 'tag' ]]; then
  printf '%s\n' 'F0_LOCAL_ANNOTATED_TAG_TYPE_STOP'
  exit 1
fi
local_tag_object=$(git -C "$custody_root" rev-parse "$expected_tag_ref")
local_tag_peeled=$(git -C "$custody_root" rev-parse "$expected_tag_peeled_ref")
if [[ "$local_tag_peeled" != "$local_head" ]]; then
  printf '%s\n' 'F0_LOCAL_ANNOTATED_TAG_TARGET_STOP'
  exit 1
fi
pre_run_receipt_content=$(git -C "$custody_root" for-each-ref --format='%(contents)' "$expected_tag_ref")
if [[ -z "$pre_run_receipt_content" ]]; then
  printf '%s\n' 'F0_LOCAL_ANNOTATED_TAG_MESSAGE_STOP'
  exit 1
fi
require_receipt_value 'V4_FROZEN_EXECUTION_COMMIT' "$local_head"
require_receipt_value 'V4_PRE_RUN_TAG_NAME' "$expected_tag_name"
require_receipt_value 'V4_PRE_RUN_TAG_TARGET' "$local_head"
require_receipt_value 'V4_CONTRACT_CUSTODY_COMMIT' "$expected_contract_commit"

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

if ! remote_tag_receipt=$(
  GIT_TERMINAL_PROMPT=0 git -C "$custody_root" ls-remote \
    --exit-code origin "$expected_tag_ref" "$expected_tag_peeled_ref"
); then
  printf '%s\n' 'F0_PUBLIC_TAG_QUERY_STOP'
  exit 1
fi
remote_tag_object=''
remote_tag_peeled=''
remote_tag_line_count=0
while IFS=$'\t' read -r tag_sha tag_ref tag_extra; do
  remote_tag_line_count=$((remote_tag_line_count + 1))
  if [[ -n "${tag_extra:-}" ]]; then
    printf '%s\n' 'F0_PUBLIC_TAG_SHAPE_STOP'
    exit 1
  fi
  case "$tag_ref" in
    "$expected_tag_ref") remote_tag_object="$tag_sha" ;;
    "$expected_tag_peeled_ref") remote_tag_peeled="$tag_sha" ;;
    *)
      printf '%s\n' 'F0_PUBLIC_TAG_SHAPE_STOP'
      exit 1
      ;;
  esac
done <<< "$remote_tag_receipt"
if [[ "$remote_tag_line_count" -ne 2 || "$remote_tag_object" != "$local_tag_object" || "$remote_tag_peeled" != "$local_head" ]]; then
  printf '%s\n' 'F0_PUBLIC_TAG_MISMATCH_STOP'
  exit 1
fi

require_receipt_value 'V4_PUBLIC_REF' "$expected_public_ref"
require_receipt_value 'V4_PUBLIC_HEAD' "$local_head"
require_receipt_value 'V4_PUBLIC_TAG_REF' "$expected_tag_ref"
require_receipt_value 'V4_PUBLIC_TAG_PEELED_REF' "$expected_tag_peeled_ref"
require_receipt_value 'V4_PUBLIC_BRANCH_RECEIPT' 'REQUIRED_AT_EXECUTION'
require_receipt_value 'V4_PUBLIC_TAG_RECEIPT' 'REQUIRED_AT_EXECUTION'
require_receipt_value 'V4_RECONSTRUCTION_COMMIT' "$expected_reconstruction"
require_receipt_value 'V4_CANDIDATE_SHA256' "$expected_theorem"
require_receipt_value 'V4_AUDIT_SHA256' "$expected_audit"
require_receipt_value 'V4_MANIFEST_SHA256' "$expected_manifest"
require_receipt_value 'V4_CACHE_DIR' "$cache_dir"
require_receipt_value 'V4_LOCK_PATH' "$lock_path"
require_receipt_value 'V4_PROCESS_MATCHER_ID' "$process_matcher_id"
require_receipt_value 'V4_PRE_RUN_RECONSTRUCTION_LAKE' 'ABSENT'
require_receipt_value 'V4_PRE_RUN_PHASE_LOGS' 'ABSENT'
require_receipt_value 'V4_PRE_RUN_PROCESS_MATCH_COUNT' '0'
require_receipt_value 'V4_PRE_RUN_PROCESS_AUDIT' 'PASS'
require_receipt_value 'V4_CONTRACT_CLARIFICATION' 'ADDENDUM_V1_REQUIRED_AT_EXECUTION_ACCEPTED'
require_receipt_value 'F0_INVOCATIONS' '0'
require_receipt_value 'T0_INVOCATIONS' '0'
require_receipt_value 'D1a_INVOCATIONS' '0'
require_receipt_value 'D1b_INVOCATIONS' '0'
require_receipt_value 'P1_INVOCATIONS' '0'
require_receipt_value 'A1_INVOCATIONS' '0'

require_hash_binding 'V4_CONTRACT_SHA256' "$contract_path"
require_hash_binding 'V4_CONTRACT_ADDENDUM_SHA256' "$addendum_path"
require_hash_binding 'V4_EXECUTOR_SHA256' "$executor_path"
require_hash_binding 'V4_PREFLIGHT_SHA256' "$preflight_path"
require_hash_binding 'V4_STATIC_REVIEW_SHA256' "$static_review_path"

if ! pre_run_available_kb=$(receipt_value 'V4_PRE_RUN_AVAILABLE_KB'); then
  printf '%s\n' 'F0_PRE_RUN_DISK_RECEIPT_STOP'
  exit 1
fi
if [[ ! "$pre_run_available_kb" =~ ^[0-9]+$ || "$pre_run_available_kb" -lt "$minimum_available_kb" ]]; then
  printf '%s\n' 'F0_PRE_RUN_DISK_RECEIPT_STOP'
  exit 1
fi
require_snapshot_block

test "$(git -C "$reconstruction_root" rev-parse HEAD)" = "$expected_reconstruction"
git -C "$reconstruction_root" diff --quiet
git -C "$reconstruction_root" diff --cached --quiet

unexpected_status=$(git -C "$reconstruction_root" status --porcelain | awk '
  $0 == "?? Erdos1135/ND/FusionRhinAnchored.lean" { next }
  $0 == "?? FusionRhinAnchoredAxiomAudit.lean" { next }
  $0 == "?? lake-manifest.json" { next }
  { print }
')
test -z "$unexpected_status"

test ! -e "$reconstruction_root/.lake"
test -d "$coordination_root"
test -w "$coordination_root"
test ! -e "$cache_dir"
test -z "${MATHLIB_CACHE_DIR+x}"

available_kb=$(df -Pk "$reconstruction_root" | awk 'NR == 2 { print $4 }')
if [[ ! "$available_kb" =~ ^[0-9]+$ ]]; then
  printf '%s\n' 'F0_DISK_MEASUREMENT_STOP'
  exit 1
fi
if [[ "$available_kb" -lt "$minimum_available_kb" ]]; then
  printf '%s\n' "F0_AVAILABLE_KB=$available_kb" 'F0_DISK_STOP'
  exit 1
fi

for later_log in \
  T0_cache_get.full.log \
  D1a_fusion_parametric.full.log \
  D1b_rhin_unconditional.full.log \
  P1_target_build.full.log \
  A1_axiom_audit.full.log; do
  test ! -e "$log_root/$later_log"
done

test "$(sha256_file "$custody_theorem")" = "$expected_theorem"
test "$(sha256_file "$custody_audit")" = "$expected_audit"
test "$(sha256_file "$reconstruction_theorem")" = "$expected_theorem"
test "$(sha256_file "$reconstruction_audit")" = "$expected_audit"
test "$(sha256_file "$manifest_path")" = "$expected_manifest"
test "$(sha256_file "$contract_path")" = "$expected_contract"
test "$(sha256_file "$addendum_path")" = "$expected_addendum"
cmp -s "$reconstruction_theorem" "$custody_theorem"
cmp -s "$reconstruction_audit" "$custody_audit"

test "$(tr -d '\r\n' < "$reconstruction_root/lean-toolchain")" = "$expected_toolchain"
grep -Fq "$expected_mathlib" "$manifest_path"

test -x '/usr/bin/time'
test -x '/opt/homebrew/bin/gtimeout'
command -v git >/dev/null
command -v lake >/dev/null
command -v lean >/dev/null
command -v shasum >/dev/null

printf '%s\n' \
  "F0_LOCAL_EXECUTION_HEAD=$local_head" \
  "F0_PUBLIC_BRANCH_HEAD=$remote_sha" \
  "F0_PUBLIC_REF=$remote_ref" \
  'F0_PUBLIC_HEAD_EQUALS_LOCAL=PASS' \
  'F0_PUBLIC_BRANCH_RECEIPT_AT_EXECUTION=EXACT_MATCH' \
  "F0_PUBLIC_TAG_OBJECT=$remote_tag_object" \
  "F0_PUBLIC_TAG_PEELED=$remote_tag_peeled" \
  'F0_PUBLIC_ANNOTATED_TAG=PASS' \
  'F0_PUBLIC_TAG_RECEIPT_AT_EXECUTION=EXACT_MATCH' \
  'F0_PRE_RUN_HASH_BINDINGS=PASS' \
  'F0_CUSTODY_TRACKED_DIFF=EMPTY' \
  'F0_RECONSTRUCTION_COMMIT=PASS' \
  'F0_RECONSTRUCTION_TRACKED_DIFF=EMPTY' \
  'F0_UNTRACKED_SCOPE=EXPECTED_ONLY' \
  'F0_CANDIDATE_HASHES=PASS' \
  'F0_CANDIDATE_BYTE_IDENTITY=PASS' \
  "F0_TOOLCHAIN=$expected_toolchain" \
  "F0_MATHLIB_MANIFEST_REV=$expected_mathlib" \
  'F0_RECONSTRUCTION_LAKE=ABSENT' \
  "F0_DEDICATED_CACHE=$cache_dir" \
  'F0_DEDICATED_CACHE_STATE=ABSENT' \
  'F0_AMBIENT_MATHLIB_CACHE_DIR=UNSET' \
  "F0_AVAILABLE_KB=$available_kb" \
  'F0_DISK_MINIMUM_20_GIB=PASS' \
  "F0_EXECUTOR_LOCK=$lock_path" \
  'F0_EXECUTOR_LOCK_HELD=PASS' \
  "F0_PROCESS_AUDIT_RECEIPT=$process_audit_receipt" \
  'F0_IMMEDIATELY_PRECEDING_PROCESS_AUDIT=PASS' \
  'F0_LATER_PHASE_LOGS=ABSENT' \
  'F0_LEFT_RECONSTRUCTION_COLD=PASS' \
  'F0_PREFLIGHT=PASS'
