#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 || "$1" != '--audit-log' ]]; then
  printf '%s\n' 'usage: f3_axiom_audit_log_guard_v2.sh --audit-log PATH' >&2
  exit 2
fi

audit_log=$2
test -r "$audit_log"

read -r count_line_count namespace_count profile_count unique_profile_count < <(
  awk -F '\t' '
    /NAMESPACE_DECLARATION_COUNT=[0-9]+/ {
      count_lines += 1
      value = $0
      sub(/^.*NAMESPACE_DECLARATION_COUNT=/, "", value)
      sub(/[^0-9].*$/, "", value)
      namespace_count = value + 0
    }
    /^AXIOM_PROFILE[[:space:]]/ {
      profiles += 1
      if (!seen[$2]++) unique_profiles += 1
    }
    END {
      print count_lines + 0, namespace_count + 0,
        profiles + 0, unique_profiles + 0
    }
  ' "$audit_log"
)

test "$count_line_count" -eq 1
test "$namespace_count" -gt 0
test "$profile_count" -eq "$namespace_count"
test "$unique_profile_count" -eq "$namespace_count"

# This scan intentionally covers continuation lines as well as AXIOM_PROFILE
# headers.  V1 inspected only the header line and could miss a wrapped axiom.
if grep -Eq 'Lean\.ofReduceBool|sorryAx' "$audit_log"; then
  exit 1
fi

printf '%s\n' \
  "V2_NAMESPACE_DECLARATIONS=$namespace_count" \
  "V2_AXIOM_PROFILES=$profile_count" \
  "V2_UNIQUE_PROFILE_NAMES=$unique_profile_count" \
  'V2_FULL_LOG_FORBIDDEN_AXIOMS=ABSENT' \
  'V2_AXIOM_AUDIT_LOG_GUARD=PASS'
