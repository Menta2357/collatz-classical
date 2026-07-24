#!/usr/bin/env bash
set -euo pipefail

export LC_ALL=C
export LANG=C

if [[ $# -ne 0 ]]; then
  printf '%s\n' 'usage: f3_forward_right_certificate_v5_audit_only_executor.sh' >&2
  exit 2
fi

repo='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3'
output_root="$repo/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2"
script_dir="$output_root/scripts"
result_dir="$output_root/results/F3_FORWARD_RIGHT_CERTIFICATE_V5_AUDIT_ONLY"
log_path="$result_dir/v5_audit_only_raw.txt"
branch='codex/hilo2-f3-forward-right-certificate-v5-audit-only'
terminal_v4='bc27af64cbeff07f2430bd71390e7aa2cf1dc1ac'
public_v4='public/codex/hilo2-f3-forward-right-certificate-v4'

check_tracked_hash() {
  local absolute=$1
  local expected=$2
  local relative=${absolute#"$repo/"}
  git -C "$repo" ls-files --error-unmatch "$relative" >/dev/null
  test "$(shasum -a 256 "$absolute" | awk '{print $1}')" = "$expected"
}

unique_value() {
  local key=$1
  local file=$2
  awk -F '=' -v key="$key" '
    $1 == key { count += 1; value = substr($0, index($0, "=") + 1) }
    END { if (count != 1) exit 1; print value }
  ' "$file"
}

precheck() {
  test "$(git -C "$repo" branch --show-current)" = "$branch"
  git -C "$repo" diff --quiet
  git -C "$repo" diff --cached --quiet
  test "$(git -C "$repo" rev-parse HEAD)" = \
    "$(git -C "$repo" rev-parse "public/$branch")"
  test "$(git -C "$repo" rev-parse "$public_v4")" = "$terminal_v4"
  git -C "$repo" merge-base --is-ancestor "$terminal_v4" HEAD

  check_tracked_hash "$script_dir/f3_forward_right_certificate_v5_audit_only.sh" \
    5c3c6b2fd113f2bf996a9edb5197e2b7616b667aee438baadc256cd939a8581e
  check_tracked_hash "$script_dir/f3_forward_right_certificate_v5_unsafe_codegen_probe.lean" \
    4efe62b76345aba575a880c23033ae28f7add1a54812e4f7827f3976d73afc72
  check_tracked_hash "$script_dir/f3_forward_right_certificate_v4_common.sh" \
    5e3d1cd4094dfb5bbd5c42c13a31ed22987fb9cafe65696b97c37c3d7ce66e4e
  check_tracked_hash "$output_root/results/F3_FORWARD_RIGHT_CERTIFICATE_V4/F3_FORWARD_RIGHT_CERTIFICATE_V4_TERMINAL_REPORT.md" \
    91c9b48f076b890cf24db3aa332bf1a592721b10432229ee7d8523c24b428507
  check_tracked_hash "$output_root/results/F3_FORWARD_RIGHT_CERTIFICATE_V4/v4_compile_raw.txt" \
    ea398caeb54181bc601d6b638755f0e703cdf7f40e5fdfef07f2d0db8248b431
  check_tracked_hash "$output_root/results/F3_FORWARD_RIGHT_CERTIFICATE_V4/v4_audit_raw.txt" \
    43a34ed395e89ac837adcc3df2cecfeb8efb017cb7ad82bce1d21805878e51f1
  check_tracked_hash "$output_root/results/F3_FORWARD_RIGHT_CERTIFICATE_V4/v4_k1_raw.txt" \
    0e82877bc975f99f535096d2eb6c01c884c03b9f9b2bb7fcb9b4122b08a56d38
  git -C "$repo" ls-files --error-unmatch \
    "${script_dir#"$repo/"}/f3_forward_right_certificate_v5_audit_only_executor.sh" \
    "${output_root#"$repo/"}/F3_FORWARD_RIGHT_CERTIFICATE_V5_AUDIT_ONLY_CONTRACT.md" \
    "${result_dir#"$repo/"}/F3_FORWARD_RIGHT_CERTIFICATE_V5_AUDIT_ONLY_PRE_RUN_REPORT.md" \
    >/dev/null
  test "$(shasum -a 256 /opt/homebrew/bin/gtimeout | awk '{print $1}')" = \
    1ce578c938781a82c5bf7fd3fb2a1b9515f4f2486eb3c6511d0b2b4ec822bb1e
  test "$(shasum -a 256 /opt/homebrew/bin/gsort | awk '{print $1}')" = \
    3e2705341516948679e48b245297318a2e79086639d02f8878404e3a9cb30b97
  test -d "$repo/.lake/f3-forward-right-certificate-v4-overlay"
}

test -d "$result_dir"
test ! -e "$log_path"
(set -o noclobber; : > "$log_path") 2>/dev/null

set +e
(set -e; precheck) >> "$log_path" 2>&1
precheck_status=$?
set -e
printf 'F3_FORWARD_V5_A0_PRECHECK_STATUS=%s\n' "$precheck_status" >> "$log_path"
if [[ "$precheck_status" -ne 0 ]]; then
  printf 'F3_FORWARD_V5_A0_WRAPPER_EXIT_STATUS=%s\n' \
    "$precheck_status" >> "$log_path"
  exit "$precheck_status"
fi

set +e
/opt/homebrew/bin/gtimeout --signal=TERM --kill-after=5 600 \
  /usr/bin/time -p bash "$script_dir/f3_forward_right_certificate_v5_audit_only.sh" \
  >> "$log_path" 2>&1
phase_status=$?
set -e

if [[ "$phase_status" -eq 0 ]]; then
  set +e
  (
    test "$(unique_value F3_FORWARD_V5_AUDIT_ONLY "$log_path")" = \
      'PASS_WITH_EXPLICIT_CODEGEN_SPEC_EXCEPTIONS'
    test "$(unique_value F3_FORWARD_V5_STABLE_DECLARATIONS "$log_path")" = '21'
    test "$(unique_value F3_FORWARD_V5_GENERATED_DECLARATIONS "$log_path")" = '108'
    test "$(unique_value F3_FORWARD_V5_NAMESPACE_PROFILES "$log_path")" = '129'
    test "$(unique_value F3_FORWARD_V5_EXACT_UNSAFE_SPEC_AXIOMS "$log_path")" = '3'
    test "$(unique_value F3_FORWARD_V5_EXACT_UNSAFE_CODEGEN_OWNERS "$log_path")" = '2'
    test "$(unique_value F3_FORWARD_V5_LCPROOF_OCCURRENCES "$log_path")" = '3'
    test "$(unique_value F3_FORWARD_V5_STABLE_CODEGEN_AXIOMS "$log_path")" = '0'
    test "$(unique_value F3_FORWARD_V5_FORBIDDEN_AXIOMS "$log_path")" = 'ABSENT'
    test "$(unique_value F3_FORWARD_V5_OBJECTS_UNCHANGED "$log_path")" = 'PASS'
    test "$(unique_value F3_FORWARD_V5_STABLE_NAMES "$log_path")" = '21'
    test "$(unique_value F3_FORWARD_V5_STABLE_ALLOWED_AXIOM_SET_ONLY "$log_path")" = 'PASS'
    test "$(unique_value F3_FORWARD_V5_STABLE_SPECIAL_AXIOMS "$log_path")" = '0'
    test "$(unique_value F3_FORWARD_V5_UNSAFE_CODEGEN_PROBE "$log_path")" = 'PASS'
    test "$(grep -c '^F3_FORWARD_V5_UNSAFE_AXIOM=' "$log_path")" = '3'
    test "$(grep -c '^F3_FORWARD_V5_UNSAFE_OWNER=' "$log_path")" = '2'
    if grep -Eq 'Lean[.]ofReduceBool|sorryAx|native_decide' "$log_path"; then
      exit 1
    fi
  )
  postcheck_status=$?
  set -e
  if [[ "$postcheck_status" -ne 0 ]]; then
    phase_status=$postcheck_status
  fi
fi

printf 'F3_FORWARD_V5_A0_WRAPPER_EXIT_STATUS=%s\n' \
  "$phase_status" >> "$log_path"
exit "$phase_status"
