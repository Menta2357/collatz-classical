#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  printf '%s\n' 'usage: phase-executor R0|S0|C0|A1|K1' >&2
  exit 2
fi

phase=$1
repo_root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3'
output_root="$repo_root/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2"
script_dir="$output_root/scripts"
result_dir="$output_root/results/F3_CORE_ARITHMETIC_CODEC_FULL_CORE_IDENTITY_v1"

r0_log="$result_dir/v1_guard_regression_raw.txt"
s0_log="$result_dir/v1_overlay_stage_raw.txt"
c0_log="$result_dir/v1_compile_raw.txt"
a1_log="$result_dir/v1_axiom_audit_raw.txt"
k1_log="$result_dir/v1_axiom_log_checker.txt"
r0_good_log="$output_root/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V6_OVERLAY_AUDIT_v1/v6_axiom_audit_raw.txt"
r0_good_log_hash='76493a39a7e90e1eb833ba4c59112b9061204c66dcee8babee7f659ddde47ace'

unique_value() {
  local key=$1
  local file=$2
  awk -F '=' -v key="$key" '
    $1 == key { count += 1; value = substr($0, index($0, "=") + 1) }
    END { if (count != 1) exit 1; print value }
  ' "$file"
}

expect_value() {
  local key=$1
  local file=$2
  local expected=$3
  local actual
  actual=$(unique_value "$key" "$file") || return 1
  test "$actual" = "$expected"
}

phase_precheck() {
  case "$phase" in
    R0)
      test -f "$r0_good_log" || return 1
      test ! -L "$r0_good_log" || return 1
      test "$(shasum -a 256 "$r0_good_log" | awk '{print $1}')" = "$r0_good_log_hash" || return 1
      ;;
    S0)
      expect_value V2_GUARD_REGRESSION "$r0_log" PASS || return 1
      expect_value V2_V6_GOOD_LOG "$r0_log" PASS || return 1
      expect_value V2_WRAPPED_FORBIDDEN_FIXTURE "$r0_log" REJECTED || return 1
      expect_value V2_NAMESPACE_DECLARATIONS "$r0_log" 640 || return 1
      expect_value V2_AXIOM_PROFILES "$r0_log" 640 || return 1
      expect_value V2_UNIQUE_PROFILE_NAMES "$r0_log" 640 || return 1
      expect_value V2_FULL_LOG_FORBIDDEN_AXIOMS "$r0_log" ABSENT || return 1
      expect_value FULL_CORE_IDENTITY_R0_WRAPPER_EXIT_STATUS "$r0_log" 0 || return 1
      ;;
    C0)
      expect_value FULL_CORE_IDENTITY_OVERLAY_STAGE "$s0_log" PASS || return 1
      expect_value FULL_CORE_IDENTITY_S0_WRAPPER_EXIT_STATUS "$s0_log" 0 || return 1
      ;;
    A1)
      expect_value FULL_CORE_IDENTITY_C0 "$c0_log" PASS || return 1
      expect_value FULL_CORE_IDENTITY_C0_LEAN_EXIT_STATUS "$c0_log" 0 || return 1
      expect_value FULL_CORE_IDENTITY_C0_WRAPPER_EXIT_STATUS "$c0_log" 0 || return 1
      ;;
    K1)
      expect_value FULL_CORE_IDENTITY_A1 "$a1_log" PASS || return 1
      expect_value FULL_CORE_IDENTITY_A1_LEAN_EXIT_STATUS "$a1_log" 0 || return 1
      expect_value FULL_CORE_IDENTITY_A1_WRAPPER_EXIT_STATUS "$a1_log" 0 || return 1
      ;;
  esac
}

case "$phase" in
  R0)
    cap=60
    log_path=$r0_log
    command=(/usr/bin/time -p bash "$script_dir/f3_axiom_audit_log_guard_v2_regression.sh")
    ;;
  S0)
    cap=120
    log_path=$s0_log
    command=(/usr/bin/time -p bash "$script_dir/f3_full_core_identity_overlay_stage_v1.sh")
    ;;
  C0)
    cap=600
    log_path=$c0_log
    command=(bash "$script_dir/f3_full_core_identity_compile_phase_v1.sh")
    ;;
  A1)
    cap=450
    log_path=$a1_log
    command=(bash "$script_dir/f3_full_core_identity_audit_phase_v1.sh")
    ;;
  K1)
    cap=60
    log_path=$k1_log
    command=(/usr/bin/time -p bash "$script_dir/f3_full_core_identity_inventory_check_v1.sh" --c0-log "$c0_log" --audit-log "$a1_log")
    ;;
  *)
    printf 'unknown phase: %s\n' "$phase" >&2
    exit 2
    ;;
esac

test -d "$result_dir"
test ! -e "$log_path"
(set -o noclobber; : > "$log_path") 2>/dev/null

set +e
phase_precheck >> "$log_path" 2>&1
precheck_status=$?
set -e
printf 'FULL_CORE_IDENTITY_%s_PRECHECK_STATUS=%s\n' \
  "$phase" "$precheck_status" >> "$log_path"
if [[ "$precheck_status" -ne 0 ]]; then
  printf 'FULL_CORE_IDENTITY_%s_WRAPPER_EXIT_STATUS=%s\n' \
    "$phase" "$precheck_status" >> "$log_path"
  exit "$precheck_status"
fi

set +e
/opt/homebrew/bin/gtimeout --kill-after=5 "$cap" "${command[@]}" >> "$log_path" 2>&1
phase_status=$?
set -e

printf 'FULL_CORE_IDENTITY_%s_WRAPPER_EXIT_STATUS=%s\n' \
  "$phase" "$phase_status" >> "$log_path"
exit "$phase_status"
