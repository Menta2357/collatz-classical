#!/usr/bin/env bash
set -euo pipefail

# Prevent an ambient cache override from leaking into F0 or the build phases;
# T0 introduces the one contract-authorized value explicitly.
unset MATHLIB_CACHE_DIR

# The v4 contract freezes wall-clock ceilings only.  It specifies no heartbeat
# override, so these exact commands deliberately add none.

custody_root='/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/custody-repo'
reconstruction_root='/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion/reconstruction-publication-gate2-ef1a5a7'
coordination_root='/Users/MoiTam/Documents/New project/coordinated/hilo1-fusion'
cache_dir="$coordination_root/.rhin-v4-mathlib-cache"
lock_path="$coordination_root/.rhin-v4-executor.lock"
log_root="$custody_root/artifacts/mazur-rhin-anchored-ca3/rhin-v4-logs"
run_report="$log_root/RHIN_V4_RUN_REPORT_v1.md"

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
process_matcher_id='rhin-v4-process-matcher-v3'
expected_addendum='867ce88268c552d50c09695e26474e284f9c9d8ff7171fdc65b00c879efa0d1f'

# The pre-run report is the complete message of an annotated tag named from
# the already-created execution commit.  The tag is an external Git object, so
# it can bind that commit and every SHA-256 without a self-referential commit.
pre_run_receipt_content=''

phase_logs='F0_preflight.full.log T0_cache_get.full.log D1a_fusion_parametric.full.log D1b_rhin_unconditional.full.log P1_target_build.full.log A1_axiom_audit.full.log'
process_logs='Q0_before_F0_process_audit.full.log Q1_before_T0_process_audit.full.log Q2_before_D1a_process_audit.full.log Q3_before_D1b_process_audit.full.log Q4_before_P1_process_audit.full.log Q5_before_A1_process_audit.full.log'

f0_invocations=0
t0_invocations=0
d1a_invocations=0
d1b_invocations=0
p1_invocations=0
a1_invocations=0
last_phase='PRE_EXECUTOR'
last_exit='NOT_RUN'
final_verdict='NOT_RUN'
lock_acquired='false'
terminal_report_written='false'

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

require_snapshot_block_pre_executor() {
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
  ' || pre_executor_stop 'PRE_RUN_PROCESS_SNAPSHOT_STOP'
}

pre_executor_stop() {
  printf '%s\n' "$1" >&2
  exit 1
}

require_receipt_value_pre_executor() {
  local key="$1"
  local expected="$2"
  local actual
  if ! actual=$(receipt_value "$key"); then
    pre_executor_stop "PRE_RUN_RECEIPT_FIELD_STOP=$key"
  fi
  if [[ "$actual" != "$expected" ]]; then
    pre_executor_stop "PRE_RUN_RECEIPT_VALUE_STOP=$key"
  fi
}

hash_binding_matches() {
  local key="$1"
  local path="$2"
  local expected
  local actual
  expected=$(receipt_value "$key") || return 1
  [[ "$expected" =~ ^[0-9a-f]{64}$ ]] || return 1
  actual=$(sha256_file "$path") || return 1
  [[ "$actual" = "$expected" ]]
}

tracked_state() {
  local root="$1"
  if git -C "$root" diff --quiet && git -C "$root" diff --cached --quiet; then
    printf '%s' 'CLEAN'
  else
    printf '%s' 'DIRTY'
  fi
}

path_state() {
  if [[ -s "$1" ]]; then
    printf '%s' 'PRESENT_NONEMPTY'
  elif [[ -e "$1" ]]; then
    printf '%s' 'PRESENT_EMPTY'
  else
    printf '%s' 'ABSENT'
  fi
}

append_evidence_inventory() {
  local evidence
  local bytes
  local digest
  for evidence in $process_logs $phase_logs; do
    if [[ -e "$log_root/$evidence" ]]; then
      bytes=$(wc -c < "$log_root/$evidence" | tr -d '[:space:]')
      digest=$(sha256_file "$log_root/$evidence")
      printf '%s\n' \
        "EVIDENCE_FILE=$evidence" \
        "EVIDENCE_BYTES=$bytes" \
        "EVIDENCE_SHA256=$digest"
    fi
  done
}

append_last_progress() {
  local last_log=''
  case "$last_phase" in
    F0) last_log="$log_root/F0_preflight.full.log" ;;
    T0) last_log="$log_root/T0_cache_get.full.log" ;;
    D1a) last_log="$log_root/D1a_fusion_parametric.full.log" ;;
    D1b) last_log="$log_root/D1b_rhin_unconditional.full.log" ;;
    P1) last_log="$log_root/P1_target_build.full.log" ;;
    A1) last_log="$log_root/A1_axiom_audit.full.log" ;;
    PROCESS_AUDIT_BEFORE_*) last_log='' ;;
  esac
  if [[ -s "$last_log" ]]; then
    printf '%s\n' 'LAST_PHASE_LOG_TAIL_BEGIN'
    tail -n 20 "$last_log"
    printf '%s\n' 'LAST_PHASE_LOG_TAIL_END'
  fi
}

package_worktrees_state() {
  local package_dir
  local package_toplevel
  local git_package_count=0
  [[ -d "$reconstruction_root/.lake/packages" ]] || {
    printf '%s' 'ABSENT'
    return
  }
  for package_dir in "$reconstruction_root"/.lake/packages/*; do
    [[ -d "$package_dir" ]] || continue
    if package_toplevel=$(git -C "$package_dir" rev-parse --show-toplevel 2>/dev/null); then
      [[ "$package_toplevel" = "$package_dir" ]] || continue
      git_package_count=$((git_package_count + 1))
      if ! git -C "$package_dir" diff --quiet || ! git -C "$package_dir" diff --cached --quiet; then
        printf '%s' 'DIRTY'
        return
      fi
    fi
  done
  if [[ "$git_package_count" -eq 0 ]]; then
    printf '%s' 'NO_GIT_PACKAGE_WORKTREES'
    return
  fi
  printf '%s' 'CLEAN'
}

write_terminal_report() {
  local report_tmp="$run_report.tmp.$$"
  local execution_head
  local reconstruction_head
  local custody_state
  local reconstruction_state
  local package_state
  local contract_hash='ABSENT'
  local addendum_hash='ABSENT'
  local executor_hash='ABSENT'
  local preflight_hash='ABSENT'
  local static_review_hash='ABSENT'
  local custody_theorem_hash='ABSENT'
  local custody_audit_hash='ABSENT'
  local theorem_hash='ABSENT'
  local audit_hash='ABSENT'
  local manifest_hash='ABSENT'

  execution_head=$(git -C "$custody_root" rev-parse HEAD 2>/dev/null || printf '%s' 'UNKNOWN')
  reconstruction_head=$(git -C "$reconstruction_root" rev-parse HEAD 2>/dev/null || printf '%s' 'UNKNOWN')
  custody_state=$(tracked_state "$custody_root")
  reconstruction_state=$(tracked_state "$reconstruction_root")
  package_state=$(package_worktrees_state)
  if [[ -f "$contract_path" ]]; then contract_hash=$(sha256_file "$contract_path"); fi
  if [[ -f "$addendum_path" ]]; then addendum_hash=$(sha256_file "$addendum_path"); fi
  if [[ -f "$executor_path" ]]; then executor_hash=$(sha256_file "$executor_path"); fi
  if [[ -f "$preflight_path" ]]; then preflight_hash=$(sha256_file "$preflight_path"); fi
  if [[ -f "$static_review_path" ]]; then static_review_hash=$(sha256_file "$static_review_path"); fi
  if [[ -f "$custody_theorem" ]]; then custody_theorem_hash=$(sha256_file "$custody_theorem"); fi
  if [[ -f "$custody_audit" ]]; then custody_audit_hash=$(sha256_file "$custody_audit"); fi
  if [[ -f "$reconstruction_theorem" ]]; then theorem_hash=$(sha256_file "$reconstruction_theorem"); fi
  if [[ -f "$reconstruction_audit" ]]; then audit_hash=$(sha256_file "$reconstruction_audit"); fi
  if [[ -f "$manifest_path" ]]; then manifest_hash=$(sha256_file "$manifest_path"); fi

  {
    printf '%s\n' \
      '# Rhin-anchored H1 cold gate v4 terminal run report' \
      '' \
      'This report was generated by the frozen single executor.  It is not' \
      'claimable until committed and publicly verified on the exact v4 ref.' \
      '' \
      '```text' \
      "FINAL_VERDICT=$final_verdict" \
      "LAST_PHASE=$last_phase" \
      "LAST_EXIT=$last_exit" \
      "V4_EXECUTION_HEAD=$execution_head" \
      "V4_CONTRACT_CUSTODY_COMMIT=$expected_contract_commit" \
      "V4_RECONSTRUCTION_HEAD=$reconstruction_head" \
      "V4_PRE_RUN_TAG_NAME=${expected_tag_name:-UNKNOWN}" \
      "V4_PRE_RUN_TAG_OBJECT=${local_tag_object:-UNKNOWN}" \
      "F0_INVOCATIONS=$f0_invocations" \
      "T0_INVOCATIONS=$t0_invocations" \
      "D1a_INVOCATIONS=$d1a_invocations" \
      "D1b_INVOCATIONS=$d1b_invocations" \
      "P1_INVOCATIONS=$p1_invocations" \
      "A1_INVOCATIONS=$a1_invocations" \
      'STOP_AT_FIRST_FAILURE=true' \
      'NO_RETRY=true' \
      'PHASE_WALL_BUDGET_SECONDS=7620' \
      'HEARTBEAT_OVERRIDE=NONE_CONTRACT_SPECIFIED' \
      "LOCK_PATH=$lock_path" \
      "LOCK_ACQUIRED=$lock_acquired" \
      "DEDICATED_CACHE_DIR=$cache_dir" \
      "POST_CUSTODY_TRACKED_WORKTREE=$custody_state" \
      "POST_RECONSTRUCTION_TRACKED_WORKTREE=$reconstruction_state" \
      "POST_PACKAGE_TRACKED_WORKTREES=$package_state" \
      "POST_CONTRACT_SHA256=$contract_hash" \
      "POST_CONTRACT_ADDENDUM_SHA256=$addendum_hash" \
      "POST_EXECUTOR_SHA256=$executor_hash" \
      "POST_PREFLIGHT_SHA256=$preflight_hash" \
      "POST_STATIC_REVIEW_SHA256=$static_review_hash" \
      "POST_CUSTODY_CANDIDATE_SHA256=$custody_theorem_hash" \
      "POST_CUSTODY_AUDIT_SHA256=$custody_audit_hash" \
      "POST_RECONSTRUCTION_CANDIDATE_SHA256=$theorem_hash" \
      "POST_RECONSTRUCTION_AUDIT_SHA256=$audit_hash" \
      "POST_MANIFEST_SHA256=$manifest_hash" \
      "FUSION_PARAMETRIC_OLEAN=$(path_state "$reconstruction_root/.lake/build/lib/lean/Erdos1135/ND/FusionParametric.olean")" \
      "FUSION_PARAMETRIC_ILEAN=$(path_state "$reconstruction_root/.lake/build/lib/lean/Erdos1135/ND/FusionParametric.ilean")" \
      "RHIN_UNCONDITIONAL_OLEAN=$(path_state "$reconstruction_root/.lake/build/lib/lean/Erdos1135/ND/RhinUnconditional.olean")" \
      "RHIN_UNCONDITIONAL_ILEAN=$(path_state "$reconstruction_root/.lake/build/lib/lean/Erdos1135/ND/RhinUnconditional.ilean")" \
      "FUSION_RHIN_ANCHORED_OLEAN=$(path_state "$reconstruction_root/.lake/build/lib/lean/Erdos1135/ND/FusionRhinAnchored.olean")" \
      "FUSION_RHIN_ANCHORED_ILEAN=$(path_state "$reconstruction_root/.lake/build/lib/lean/Erdos1135/ND/FusionRhinAnchored.ilean")" \
      'TERMINAL_PUBLIC_CUSTODY=PENDING_COMMIT_AND_PUSH'
    append_evidence_inventory
    append_last_progress
    printf '%s\n' '```'
  } > "$report_tmp"
  mv "$report_tmp" "$run_report"
  terminal_report_written='true'
}

unexpected_exit_report() {
  local status="$?"
  if [[ "$status" -ne 0 && "$lock_acquired" = 'true' && "$terminal_report_written" = 'false' ]]; then
    set +e
    final_verdict='UNEXPECTED_EXECUTOR_STOP'
    last_exit="$status"
    write_terminal_report >/dev/null 2>&1
  fi
}

trap unexpected_exit_report EXIT

stop_run() {
  final_verdict="$1"
  last_phase="$2"
  last_exit="$3"
  write_terminal_report
  printf '%s\n' "FINAL_VERDICT=$final_verdict" >&2
  exit 1
}

verify_frozen_inputs() {
  [[ "$(git -C "$custody_root" branch --show-current)" = "$expected_public_branch" ]] || return 1
  [[ "$(git -C "$custody_root" rev-parse HEAD)" = "$execution_head" ]] || return 1
  git -C "$custody_root" merge-base --is-ancestor "$expected_contract_commit" HEAD || return 1
  git -C "$custody_root" diff --quiet || return 1
  git -C "$custody_root" diff --cached --quiet || return 1
  [[ "$(git -C "$reconstruction_root" rev-parse HEAD)" = "$expected_reconstruction" ]] || return 1
  git -C "$reconstruction_root" diff --quiet || return 1
  git -C "$reconstruction_root" diff --cached --quiet || return 1
  [[ "$(sha256_file "$custody_theorem")" = "$expected_theorem" ]] || return 1
  [[ "$(sha256_file "$custody_audit")" = "$expected_audit" ]] || return 1
  [[ "$(sha256_file "$reconstruction_theorem")" = "$expected_theorem" ]] || return 1
  [[ "$(sha256_file "$reconstruction_audit")" = "$expected_audit" ]] || return 1
  [[ "$(sha256_file "$manifest_path")" = "$expected_manifest" ]] || return 1
  [[ "$(sha256_file "$contract_path")" = "$expected_contract" ]] || return 1
  [[ "$(sha256_file "$addendum_path")" = "$expected_addendum" ]] || return 1
  cmp -s "$reconstruction_theorem" "$custody_theorem" || return 1
  cmp -s "$reconstruction_audit" "$custody_audit" || return 1
  hash_binding_matches 'V4_CONTRACT_SHA256' "$contract_path" || return 1
  hash_binding_matches 'V4_CONTRACT_ADDENDUM_SHA256' "$addendum_path" || return 1
  hash_binding_matches 'V4_EXECUTOR_SHA256' "$executor_path" || return 1
  hash_binding_matches 'V4_PREFLIGHT_SHA256' "$preflight_path" || return 1
  hash_binding_matches 'V4_STATIC_REVIEW_SHA256' "$static_review_path" || return 1
  if [[ -e "$reconstruction_root/.lake" ]]; then
    verify_package_worktrees || return 1
  fi
}

process_audit() {
  local stage="$1"
  local audit_log="$2"
  local snapshot_tmp="$log_root/.process_snapshot.$$.tmp"
  local matches_tmp="$log_root/.process_matches.$$.tmp"
  local ancestry=''
  local cursor="$$"
  local parent
  local match_count

  while [[ "$cursor" =~ ^[0-9]+$ && "$cursor" -gt 0 ]]; do
    ancestry="$ancestry $cursor"
    parent=$(ps -p "$cursor" -o ppid= 2>/dev/null | tr -d '[:space:]' || true)
    if [[ -z "$parent" || "$parent" = "$cursor" ]]; then break; fi
    cursor="$parent"
  done

  # Do not capture arbitrary command-line arguments: these receipts are later
  # public, and unrelated processes may carry secrets in argv.  `comm` is the
  # actual executable identity needed by this matcher.
  ps -axo pid=,ppid=,comm= > "$snapshot_tmp"
  awk -v excluded=" $ancestry " '
    {
      pid = $1
      executable = $0
      sub(/^[[:space:]]*[0-9]+[[:space:]]+[0-9]+[[:space:]]+/, "", executable)
      sub(/^.*\//, "", executable)
      is_excluded = index(excluded, " " pid " ") != 0
      is_lean_family = (executable == "lean" || executable == "lake" || executable == "leanc")
      is_mathlib_cache = (executable == "cache" || executable == "Mathlib.Cache" || executable == "mathlib-cache")
      if (!is_excluded && (is_lean_family || is_mathlib_cache)) print $0
    }
  ' "$snapshot_tmp" > "$matches_tmp"
  match_count=$(awk 'END { print NR + 0 }' "$matches_tmp")

  {
    printf '%s\n' \
      "PROCESS_AUDIT_STAGE=$stage" \
      "PROCESS_AUDIT_EXECUTOR_PID=$$" \
      "PROCESS_AUDIT_ANCESTRY=$ancestry" \
      "PROCESS_AUDIT_MATCHER_ID=$process_matcher_id" \
      'PROCESS_AUDIT_MATCHER=ps comm executable basename in {lean,lake,leanc,cache,Mathlib.Cache,mathlib-cache}; executor ancestry excluded; argv not recorded' \
      'PROCESS_SNAPSHOT_BEGIN'
    sed -n '1,$p' "$snapshot_tmp"
    printf '%s\n' 'PROCESS_SNAPSHOT_END' 'PROCESS_MATCHES_BEGIN'
    sed -n '1,$p' "$matches_tmp"
    printf '%s\n' 'PROCESS_MATCHES_END' "PROCESS_AUDIT_MATCH_COUNT=$match_count"
    if [[ "$match_count" -eq 0 ]]; then
      printf '%s\n' 'PROCESS_AUDIT=PASS'
    else
      printf '%s\n' 'PROCESS_AUDIT=STOP'
    fi
  } > "$audit_log"

  rm -f "$snapshot_tmp" "$matches_tmp"
  if [[ "$match_count" -ne 0 ]]; then
    stop_run 'CONCURRENT_BUILD_STOP' "PROCESS_AUDIT_BEFORE_$stage" '1'
  fi
}

verify_package_worktrees() {
  local package_dir
  local package_toplevel
  local git_package_count=0
  test -d "$reconstruction_root/.lake/packages" || return 1
  for package_dir in "$reconstruction_root"/.lake/packages/*; do
    [[ -d "$package_dir" ]] || continue
    if package_toplevel=$(git -C "$package_dir" rev-parse --show-toplevel 2>/dev/null); then
      [[ "$package_toplevel" = "$package_dir" ]] || continue
      git_package_count=$((git_package_count + 1))
      git -C "$package_dir" diff --quiet || return 1
      git -C "$package_dir" diff --cached --quiet || return 1
    fi
  done
  [[ "$git_package_count" -gt 0 ]] || return 1
  [[ "$(git -C "$reconstruction_root/.lake/packages/mathlib" rev-parse --show-toplevel)" = "$reconstruction_root/.lake/packages/mathlib" ]] || return 1
  [[ "$(git -C "$reconstruction_root/.lake/packages/mathlib" rev-parse HEAD)" = "$expected_mathlib" ]] || return 1
}

# PRE-EXECUTOR HASH GATE.  Nothing below this point may run if the annotated
# pre-run receipt, its exact execution HEAD, or any frozen file is absent or
# mismatched locally or publicly.
[[ -f "$contract_path" ]] || pre_executor_stop 'PRE_RUN_CONTRACT_MISSING_STOP'
[[ -f "$addendum_path" ]] || pre_executor_stop 'PRE_RUN_ADDENDUM_MISSING_STOP'
[[ -f "$executor_path" ]] || pre_executor_stop 'PRE_RUN_EXECUTOR_MISSING_STOP'
[[ -f "$preflight_path" ]] || pre_executor_stop 'PRE_RUN_PREFLIGHT_MISSING_STOP'
[[ -f "$static_review_path" ]] || pre_executor_stop 'PRE_RUN_STATIC_REVIEW_MISSING_STOP'

execution_head=$(git -C "$custody_root" rev-parse HEAD)
[[ "$execution_head" =~ ^[0-9a-f]{40}$ ]] || pre_executor_stop 'PRE_RUN_HEAD_SHAPE_STOP'
[[ "$(git -C "$custody_root" branch --show-current)" = "$expected_public_branch" ]] || pre_executor_stop 'PRE_RUN_BRANCH_STOP'
[[ "$(git -C "$custody_root" remote get-url origin)" = "$expected_origin" ]] || pre_executor_stop 'PRE_RUN_ORIGIN_STOP'
git -C "$custody_root" merge-base --is-ancestor "$expected_contract_commit" "$execution_head" || pre_executor_stop 'PRE_RUN_CONTRACT_ANCESTRY_STOP'

expected_tag_name="rhin-v4-prerun-$execution_head"
expected_tag_ref="refs/tags/$expected_tag_name"
expected_tag_peeled_ref="$expected_tag_ref^{}"
[[ "$(git -C "$custody_root" cat-file -t "$expected_tag_ref" 2>/dev/null || true)" = 'tag' ]] || pre_executor_stop 'PRE_RUN_LOCAL_ANNOTATED_TAG_TYPE_STOP'
local_tag_object=$(git -C "$custody_root" rev-parse "$expected_tag_ref")
local_tag_peeled=$(git -C "$custody_root" rev-parse "$expected_tag_peeled_ref")
[[ "$local_tag_peeled" = "$execution_head" ]] || pre_executor_stop 'PRE_RUN_LOCAL_ANNOTATED_TAG_TARGET_STOP'
pre_run_receipt_content=$(git -C "$custody_root" for-each-ref --format='%(contents)' "$expected_tag_ref")
[[ -n "$pre_run_receipt_content" ]] || pre_executor_stop 'PRE_RUN_LOCAL_ANNOTATED_TAG_MESSAGE_STOP'

if ! remote_branch_receipt=$(
  GIT_TERMINAL_PROMPT=0 git -C "$custody_root" ls-remote \
    --exit-code --refs origin "$expected_public_ref"
); then
  pre_executor_stop 'PRE_RUN_PUBLIC_BRANCH_QUERY_STOP'
fi
remote_branch_line_count=$(printf '%s\n' "$remote_branch_receipt" | awk 'END { print NR }')
[[ "$remote_branch_line_count" -eq 1 ]] || pre_executor_stop 'PRE_RUN_PUBLIC_BRANCH_SHAPE_STOP'
if ! IFS=$'\t' read -r remote_branch_sha remote_branch_ref remote_branch_extra <<< "$remote_branch_receipt"; then
  pre_executor_stop 'PRE_RUN_PUBLIC_BRANCH_SHAPE_STOP'
fi
[[ -z "${remote_branch_extra:-}" && "$remote_branch_ref" = "$expected_public_ref" && "$remote_branch_sha" = "$execution_head" ]] || pre_executor_stop 'PRE_RUN_PUBLIC_BRANCH_MISMATCH_STOP'

if ! remote_tag_receipt=$(
  GIT_TERMINAL_PROMPT=0 git -C "$custody_root" ls-remote \
    --exit-code origin "$expected_tag_ref" "$expected_tag_peeled_ref"
); then
  pre_executor_stop 'PRE_RUN_PUBLIC_TAG_QUERY_STOP'
fi
remote_tag_object=''
remote_tag_peeled=''
remote_tag_line_count=0
while IFS=$'\t' read -r tag_sha tag_ref tag_extra; do
  remote_tag_line_count=$((remote_tag_line_count + 1))
  [[ -z "${tag_extra:-}" ]] || pre_executor_stop 'PRE_RUN_PUBLIC_TAG_SHAPE_STOP'
  case "$tag_ref" in
    "$expected_tag_ref") remote_tag_object="$tag_sha" ;;
    "$expected_tag_peeled_ref") remote_tag_peeled="$tag_sha" ;;
    *) pre_executor_stop 'PRE_RUN_PUBLIC_TAG_SHAPE_STOP' ;;
  esac
done <<< "$remote_tag_receipt"
[[ "$remote_tag_line_count" -eq 2 ]] || pre_executor_stop 'PRE_RUN_PUBLIC_TAG_SHAPE_STOP'
[[ "$remote_tag_object" = "$local_tag_object" && "$remote_tag_peeled" = "$execution_head" ]] || pre_executor_stop 'PRE_RUN_PUBLIC_TAG_MISMATCH_STOP'

require_receipt_value_pre_executor 'V4_FROZEN_EXECUTION_COMMIT' "$execution_head"
require_receipt_value_pre_executor 'V4_PRE_RUN_TAG_NAME' "$expected_tag_name"
require_receipt_value_pre_executor 'V4_PRE_RUN_TAG_TARGET' "$execution_head"
require_receipt_value_pre_executor 'V4_CONTRACT_CUSTODY_COMMIT' "$expected_contract_commit"
require_receipt_value_pre_executor 'V4_PUBLIC_REF' "$expected_public_ref"
require_receipt_value_pre_executor 'V4_PUBLIC_HEAD' "$execution_head"
require_receipt_value_pre_executor 'V4_PUBLIC_TAG_REF' "$expected_tag_ref"
require_receipt_value_pre_executor 'V4_PUBLIC_TAG_PEELED_REF' "$expected_tag_peeled_ref"
require_receipt_value_pre_executor 'V4_PUBLIC_BRANCH_RECEIPT' 'REQUIRED_AT_EXECUTION'
require_receipt_value_pre_executor 'V4_PUBLIC_TAG_RECEIPT' 'REQUIRED_AT_EXECUTION'
require_receipt_value_pre_executor 'V4_RECONSTRUCTION_COMMIT' "$expected_reconstruction"
require_receipt_value_pre_executor 'V4_CANDIDATE_SHA256' "$expected_theorem"
require_receipt_value_pre_executor 'V4_AUDIT_SHA256' "$expected_audit"
require_receipt_value_pre_executor 'V4_MANIFEST_SHA256' "$expected_manifest"
require_receipt_value_pre_executor 'V4_CACHE_DIR' "$cache_dir"
require_receipt_value_pre_executor 'V4_LOCK_PATH' "$lock_path"
require_receipt_value_pre_executor 'V4_PROCESS_MATCHER_ID' "$process_matcher_id"
require_receipt_value_pre_executor 'V4_PRE_RUN_RECONSTRUCTION_LAKE' 'ABSENT'
require_receipt_value_pre_executor 'V4_PRE_RUN_PHASE_LOGS' 'ABSENT'
require_receipt_value_pre_executor 'V4_PRE_RUN_PROCESS_MATCH_COUNT' '0'
require_receipt_value_pre_executor 'V4_PRE_RUN_PROCESS_AUDIT' 'PASS'
require_receipt_value_pre_executor 'V4_CONTRACT_CLARIFICATION' 'ADDENDUM_V1_REQUIRED_AT_EXECUTION_ACCEPTED'
require_receipt_value_pre_executor 'F0_INVOCATIONS' '0'
require_receipt_value_pre_executor 'T0_INVOCATIONS' '0'
require_receipt_value_pre_executor 'D1a_INVOCATIONS' '0'
require_receipt_value_pre_executor 'D1b_INVOCATIONS' '0'
require_receipt_value_pre_executor 'P1_INVOCATIONS' '0'
require_receipt_value_pre_executor 'A1_INVOCATIONS' '0'
if ! pre_run_available_kb=$(receipt_value 'V4_PRE_RUN_AVAILABLE_KB'); then
  pre_executor_stop 'PRE_RUN_DISK_RECEIPT_STOP'
fi
[[ "$pre_run_available_kb" =~ ^[0-9]+$ && "$pre_run_available_kb" -ge 20971520 ]] || pre_executor_stop 'PRE_RUN_DISK_RECEIPT_STOP'
require_snapshot_block_pre_executor
verify_frozen_inputs || pre_executor_stop 'PRE_RUN_HASH_GATE_STOP'

# PRE-EXECUTOR EVIDENCE GATE.  The six phase logs are the contract's exact
# mandatory absence set; process-audit receipts and the terminal report are
# additionally protected from overwrite.
mkdir -p "$log_root"
for evidence in $phase_logs $process_logs RHIN_V4_RUN_REPORT_v1.md; do
  [[ ! -e "$log_root/$evidence" ]] || pre_executor_stop 'PRE_EXECUTOR_PRIOR_V4_EVIDENCE_STOP'
done

# Atomic and persistent: the lock is intentionally not removed after PASS or
# STOP, so no second launcher can reuse the one-attempt contract.
if ! mkdir "$lock_path" 2>/dev/null; then
  pre_executor_stop 'EXECUTOR_EXCLUSIVITY_STOP'
fi
lock_acquired='true'
printf '%s\n' "$$" > "$lock_path/owner_pid"
printf '%s\n' "$execution_head" > "$lock_path/execution_head"

export RHIN_V4_EXECUTOR_PID="$$"
export RHIN_V4_LOCK_PATH="$lock_path"

cd "$reconstruction_root"

# F0 — exact 120-second command.
process_audit 'F0' "$log_root/Q0_before_F0_process_audit.full.log"
export RHIN_V4_PROCESS_AUDIT_RECEIPT="$log_root/Q0_before_F0_process_audit.full.log"
f0_invocations=1
last_phase='F0'
set +e
env LC_ALL=C LANG=C /usr/bin/time -p /opt/homebrew/bin/gtimeout 120 bash "$preflight_path" > "$log_root/F0_preflight.full.log" 2>&1
phase_exit=$?
set -e
last_exit="$phase_exit"
if [[ "$phase_exit" -ne 0 ]]; then
  stop_run 'F0_STOP' 'F0' "$phase_exit"
fi
grep -Fxq 'F0_PREFLIGHT=PASS' "$log_root/F0_preflight.full.log" || stop_run 'F0_RECEIPT_STOP' 'F0' '0'
[[ ! -e "$reconstruction_root/.lake" ]] || stop_run 'F0_LEFT_WARM_TREE_STOP' 'F0' '0'

# T0 — exact 3600-second command and dedicated cache.
process_audit 'T0' "$log_root/Q1_before_T0_process_audit.full.log"
t0_invocations=1
last_phase='T0'
set +e
env LC_ALL=C LANG=C MATHLIB_CACHE_DIR="$cache_dir" /usr/bin/time -p /opt/homebrew/bin/gtimeout 3600 lake exe cache get > "$log_root/T0_cache_get.full.log" 2>&1
phase_exit=$?
set -e
last_exit="$phase_exit"
if [[ "$phase_exit" -ne 0 ]]; then
  stop_run 'CACHE_GET_STOP' 'T0' "$phase_exit"
fi
[[ -d "$cache_dir" ]] || stop_run 'CACHE_GET_POSTCONDITION_STOP' 'T0' '0'
verify_package_worktrees || stop_run 'CACHE_GET_POSTCONDITION_STOP' 'T0' '0'
verify_frozen_inputs || stop_run 'POST_T0_INPUT_MISMATCH_STOP' 'T0' '0'

# D1a — exact 900-second command.
process_audit 'D1a' "$log_root/Q2_before_D1a_process_audit.full.log"
d1a_invocations=1
last_phase='D1a'
set +e
env LC_ALL=C LANG=C /usr/bin/time -p /opt/homebrew/bin/gtimeout 900 lake build Erdos1135.ND.FusionParametric > "$log_root/D1a_fusion_parametric.full.log" 2>&1
phase_exit=$?
set -e
last_exit="$phase_exit"
if [[ "$phase_exit" -ne 0 ]]; then
  stop_run 'FUSION_PARAMETRIC_STOP' 'D1a' "$phase_exit"
fi
[[ -s "$reconstruction_root/.lake/build/lib/lean/Erdos1135/ND/FusionParametric.olean" ]] || stop_run 'FUSION_PARAMETRIC_ARTIFACT_STOP' 'D1a' '0'
[[ -s "$reconstruction_root/.lake/build/lib/lean/Erdos1135/ND/FusionParametric.ilean" ]] || stop_run 'FUSION_PARAMETRIC_ARTIFACT_STOP' 'D1a' '0'
verify_frozen_inputs || stop_run 'POST_D1a_INPUT_MISMATCH_STOP' 'D1a' '0'

# D1b — exact 2400-second command.
process_audit 'D1b' "$log_root/Q3_before_D1b_process_audit.full.log"
d1b_invocations=1
last_phase='D1b'
set +e
env LC_ALL=C LANG=C /usr/bin/time -p /opt/homebrew/bin/gtimeout 2400 lake build Erdos1135.ND.RhinUnconditional > "$log_root/D1b_rhin_unconditional.full.log" 2>&1
phase_exit=$?
set -e
last_exit="$phase_exit"
if [[ "$phase_exit" -ne 0 ]]; then
  stop_run 'RHIN_UNCONDITIONAL_STOP' 'D1b' "$phase_exit"
fi
[[ -s "$reconstruction_root/.lake/build/lib/lean/Erdos1135/ND/RhinUnconditional.olean" ]] || stop_run 'RHIN_UNCONDITIONAL_ARTIFACT_STOP' 'D1b' '0'
[[ -s "$reconstruction_root/.lake/build/lib/lean/Erdos1135/ND/RhinUnconditional.ilean" ]] || stop_run 'RHIN_UNCONDITIONAL_ARTIFACT_STOP' 'D1b' '0'
verify_frozen_inputs || stop_run 'POST_D1b_INPUT_MISMATCH_STOP' 'D1b' '0'

# P1 — exact 300-second command.
process_audit 'P1' "$log_root/Q4_before_P1_process_audit.full.log"
p1_invocations=1
last_phase='P1'
set +e
env LC_ALL=C LANG=C /usr/bin/time -p /opt/homebrew/bin/gtimeout 300 lake build Erdos1135.ND.FusionRhinAnchored > "$log_root/P1_target_build.full.log" 2>&1
phase_exit=$?
set -e
last_exit="$phase_exit"
if [[ "$phase_exit" -ne 0 ]]; then
  stop_run 'TARGET_ELABORATION_STOP' 'P1' "$phase_exit"
fi
[[ -s "$reconstruction_root/.lake/build/lib/lean/Erdos1135/ND/FusionRhinAnchored.olean" ]] || stop_run 'TARGET_ARTIFACT_STOP' 'P1' '0'
[[ -s "$reconstruction_root/.lake/build/lib/lean/Erdos1135/ND/FusionRhinAnchored.ilean" ]] || stop_run 'TARGET_ARTIFACT_STOP' 'P1' '0'
verify_frozen_inputs || stop_run 'POST_P1_INPUT_MISMATCH_STOP' 'P1' '0'

# A1 — exact 300-second command.
process_audit 'A1' "$log_root/Q5_before_A1_process_audit.full.log"
a1_invocations=1
last_phase='A1'
set +e
env LC_ALL=C LANG=C /usr/bin/time -p /opt/homebrew/bin/gtimeout 300 lake env lean FusionRhinAnchoredAxiomAudit.lean > "$log_root/A1_axiom_audit.full.log" 2>&1
phase_exit=$?
set -e
last_exit="$phase_exit"
if [[ "$phase_exit" -ne 0 ]]; then
  stop_run 'AUDIT_STOP' 'A1' "$phase_exit"
fi

producer_profile="'Erdos1135.ND.ndRhinRate_sameD_6993_200000' depends on axioms: [propext, Classical.choice, Quot.sound]"
consumer_profile="'Erdos1135.ND.fusion_of_rhin_6993_200000_of_finiteBaseVerified' depends on axioms: [propext, Classical.choice, Quot.sound]"
producer_count=$(grep -Fxc "$producer_profile" "$log_root/A1_axiom_audit.full.log" || true)
consumer_count=$(grep -Fxc "$consumer_profile" "$log_root/A1_axiom_audit.full.log" || true)
profile_count=$(grep -Fc 'depends on axioms:' "$log_root/A1_axiom_audit.full.log" || true)
if [[ "$producer_count" -ne 1 || "$consumer_count" -ne 1 || "$profile_count" -ne 2 ]]; then
  stop_run 'AUDIT_STOP' 'A1' '0'
fi
verify_frozen_inputs || stop_run 'POST_A1_INPUT_MISMATCH_STOP' 'A1' '0'

final_verdict='F0_T0_D1a_D1b_P1_A1_PASS'
last_phase='A1'
last_exit='0'
write_terminal_report
printf '%s\n' \
  'FINAL_VERDICT=F0_T0_D1a_D1b_P1_A1_PASS' \
  'TERMINAL_PUBLIC_CUSTODY=PENDING_COMMIT_AND_PUSH'
