#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo_root=$(cd -- "$script_dir/../../.." && pwd)
guard="$script_dir/f3_axiom_audit_log_guard_v2.sh"
good_log="$repo_root/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V6_OVERLAY_AUDIT_v1/v6_axiom_audit_raw.txt"
wrapped_bad="$repo_root/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/fixtures/F3_AXIOM_AUDIT_MULTILINE_FORBIDDEN_v1.txt"

test -x "$guard"
test -r "$good_log"
test -r "$wrapped_bad"

bash "$guard" --audit-log "$good_log"

if bash "$guard" --audit-log "$wrapped_bad" >/dev/null 2>&1; then
  printf '%s\n' 'V2_WRAPPED_FORBIDDEN_FIXTURE=FALSE_PASS' >&2
  exit 1
fi

printf '%s\n' \
  'V2_V6_GOOD_LOG=PASS' \
  'V2_WRAPPED_FORBIDDEN_FIXTURE=REJECTED' \
  'V2_GUARD_REGRESSION=PASS'
