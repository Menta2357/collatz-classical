#!/usr/bin/env bash
set -euo pipefail

export LC_ALL=C
export LANG=C

if [[ $# -ne 1 ]]; then
  printf '%s\n' 'usage: f3_forward_right_certificate_v3_executor.sh S0|D0|C0|A1|K1' >&2
  exit 2
fi

phase=$1
repo='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3'
output_root="$repo/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2"
script_dir="$output_root/scripts"
result_dir="$output_root/results/F3_FORWARD_RIGHT_CERTIFICATE_V3"
stage_log="$result_dir/v3_stage_raw.txt"
probe_log="$result_dir/v3_probe_raw.txt"
compile_log="$result_dir/v3_compile_raw.txt"
audit_log="$result_dir/v3_audit_raw.txt"
k1_log="$result_dir/v3_k1_raw.txt"
g0_report="$result_dir/F3_FORWARD_RIGHT_CERTIFICATE_V3_G0_REPORT.md"
g0_relative=${g0_report#"$repo/"}
branch='codex/hilo2-f3-forward-right-certificate-v3'

check_tracked_hash() {
  local absolute=$1
  local expected=$2
  local relative=${absolute#"$repo/"}
  git -C "$repo" ls-files --error-unmatch "$relative" >/dev/null
  test "$(shasum -a 256 "$absolute" | awk '{print $1}')" = "$expected"
}

verify_public_freeze() {
  check_tracked_hash "$script_dir/f3_forward_right_certificate_v3_common.sh" \
    8f36d9c732d72a6dda198453e83b82967b771779ec35f90668fab91ba6efd6e0
  check_tracked_hash "$script_dir/f3_forward_right_certificate_v3_stage.sh" \
    44c020e272f0f4f4433186bf5e6c8a5a436c0aefd4ff35585cce625b98a81f86
  check_tracked_hash "$script_dir/f3_forward_right_certificate_v3_probe.sh" \
    3231ce136b1bfd274e235f4dbd5a50faaba561032a10c016d6b41f3901082960
  check_tracked_hash "$script_dir/f3_forward_right_certificate_v3_compile.sh" \
    50ce7e52636e3c6b0d19be1650fc1b1b3ee0b79e51d933303ba3031aa5c14ebe
  check_tracked_hash "$script_dir/f3_forward_right_certificate_v3_audit.sh" \
    adc677d113b578412eb5dc7cda2e4ec78c58ce4c9068b9c0cadcbd45047d096c
  check_tracked_hash "$script_dir/f3_forward_right_certificate_v3_k1.sh" \
    5d352266b266e608416df0b24fd8593d2aa74bb93bcd0c4b6fbbfb03c1ad13a8
  check_tracked_hash "$result_dir/F3_FORWARD_RIGHT_CERTIFICATE_V3_DONOR_OLEAN_MANIFEST.sha256" \
    854f95f26e69ed5fa6aace21e165ef6f49d58798fe966969d449436a43f33e48
  check_tracked_hash "$result_dir/F3_FORWARD_RIGHT_CERTIFICATE_V3_EXPECTED_STAGE_MANIFEST.sha256" \
    38b665480af7b7596b53fedc1621343f30913b6f636e8ae6daf17654e094c5bf
  git -C "$repo" ls-files --error-unmatch \
    "${script_dir#"$repo/"}/f3_forward_right_certificate_v3_executor.sh" \
    "${output_root#"$repo/"}/F3_FORWARD_RIGHT_CERTIFICATE_V3_DIRECT_LEAN_CONTRACT.md" \
    "${result_dir#"$repo/"}/F3_FORWARD_RIGHT_CERTIFICATE_V3_PRE_RUN_REPORT.md" \
    >/dev/null
  test "$(shasum -a 256 /opt/homebrew/bin/gtimeout | awk '{print $1}')" = \
    1ce578c938781a82c5bf7fd3fb2a1b9515f4f2486eb3c6511d0b2b4ec822bb1e
  test "$(shasum -a 256 /opt/homebrew/bin/gsort | awk '{print $1}')" = \
    3e2705341516948679e48b245297318a2e79086639d02f8878404e3a9cb30b97
  test "$(git -C "$repo" rev-parse HEAD)" = \
    "$(git -C "$repo" rev-parse "public/$branch")"
}

unique_value() {
  local key=$1
  local file=$2
  awk -F '=' -v key="$key" '
    $1 == key { count += 1; value = substr($0, index($0, "=") + 1) }
    END { if (count != 1) exit 1; print value }
  ' "$file"
}

phase_precheck() {
  test "$(git -C "$repo" branch --show-current)" = "$branch"
  git -C "$repo" diff --quiet
  git -C "$repo" diff --cached --quiet
  verify_public_freeze
  case "$phase" in
    S0)
      test ! -e "$repo/.lake/f3-forward-right-certificate-v3-overlay"
      ;;
    D0)
      test "$(unique_value F3_FORWARD_V3_STAGE "$stage_log")" = 'PASS'
      test "$(unique_value F3_FORWARD_V3_S0_WRAPPER_EXIT_STATUS "$stage_log")" = '0'
      ;;
    C0)
      test "$(unique_value F3_FORWARD_V3_IMPORT_PROBE "$probe_log")" = 'PASS'
      test "$(unique_value F3_FORWARD_V3_D0_WRAPPER_EXIT_STATUS "$probe_log")" = '0'
      test -f "$g0_report"
      test "$(unique_value F3_FORWARD_V3_G0 "$g0_report")" = 'PASS'
      test "$(unique_value F3_FORWARD_V3_S0_LOG_SHA256 "$g0_report")" = \
        "$(shasum -a 256 "$stage_log" | awk '{print $1}')"
      test "$(unique_value F3_FORWARD_V3_D0_LOG_SHA256 "$g0_report")" = \
        "$(shasum -a 256 "$probe_log" | awk '{print $1}')"
      git -C "$repo" ls-files --error-unmatch "$g0_relative" >/dev/null
      test "$(git -C "$repo" rev-parse HEAD)" = \
        "$(git -C "$repo" rev-parse "public/$branch")"
      ;;
    A1)
      test "$(unique_value F3_FORWARD_V3_C0 "$compile_log")" = 'PASS'
      test "$(unique_value F3_FORWARD_V3_C0_WRAPPER_EXIT_STATUS "$compile_log")" = '0'
      ;;
    K1)
      test "$(unique_value F3_FORWARD_V3_A1 "$audit_log")" = 'PASS'
      test "$(unique_value F3_FORWARD_V3_A1_WRAPPER_EXIT_STATUS "$audit_log")" = '0'
      ;;
    *) return 1 ;;
  esac
}

case "$phase" in
  S0)
    cap=600
    log_path=$stage_log
    command=(/usr/bin/time -p bash "$script_dir/f3_forward_right_certificate_v3_stage.sh")
    ;;
  D0)
    cap=600
    log_path=$probe_log
    command=(/usr/bin/time -p bash "$script_dir/f3_forward_right_certificate_v3_probe.sh")
    ;;
  C0)
    cap=1800
    log_path=$compile_log
    command=(bash "$script_dir/f3_forward_right_certificate_v3_compile.sh")
    ;;
  A1)
    cap=1200
    log_path=$audit_log
    command=(bash "$script_dir/f3_forward_right_certificate_v3_audit.sh")
    ;;
  K1)
    cap=120
    log_path=$k1_log
    command=(/usr/bin/time -p bash "$script_dir/f3_forward_right_certificate_v3_k1.sh")
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
(set -e; phase_precheck) >> "$log_path" 2>&1
precheck_status=$?
set -e
printf 'F3_FORWARD_V3_%s_PRECHECK_STATUS=%s\n' \
  "$phase" "$precheck_status" >> "$log_path"
if [[ "$precheck_status" -ne 0 ]]; then
  printf 'F3_FORWARD_V3_%s_WRAPPER_EXIT_STATUS=%s\n' \
    "$phase" "$precheck_status" >> "$log_path"
  exit "$precheck_status"
fi

set +e
/opt/homebrew/bin/gtimeout --signal=TERM --kill-after=5 "$cap" \
  "${command[@]}" >> "$log_path" 2>&1
phase_status=$?
set -e

printf 'F3_FORWARD_V3_%s_WRAPPER_EXIT_STATUS=%s\n' \
  "$phase" "$phase_status" >> "$log_path"
exit "$phase_status"
