#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo_root=$(cd -- "$script_dir/../../.." && pwd)

source_file="$repo_root/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.lean"
audit_file="$repo_root/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.lean"
inventory_file="$repo_root/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_DECLARATION_INVENTORY_v1.tsv"
expected_count=151

source_names() {
  sed -nE \
    's/^(@\[[^]]+\] )?(noncomputable )?(def|theorem|instance|abbrev|inductive) ([A-Za-z0-9_]+).*/\4/p' \
    "$source_file"
}

inventory_names() {
  awk -F '\t' '!/^#/ && $1 ~ /^[0-9]+$/ {print $3}' "$inventory_file"
}

audit_names() {
  sed -nE 's/^#print axioms ([A-Za-z0-9_]+)$/\1/p' "$audit_file"
}

source_count=$(source_names | wc -l | tr -d ' ')
inventory_count=$(inventory_names | wc -l | tr -d ' ')
audit_count=$(audit_names | wc -l | tr -d ' ')

test "$source_count" -eq "$expected_count"
test "$inventory_count" -eq "$expected_count"
test "$audit_count" -eq "$expected_count"

awk -F '\t' '
  !/^#/ && $1 ~ /^[0-9]+$/ {
    expected += 1
    if ($1 != expected) exit 1
  }
  END { if (expected != 151) exit 1 }
' "$inventory_file"

test -z "$(source_names | sort | uniq -d)"
test -z "$(inventory_names | sort | uniq -d)"
test -z "$(audit_names | sort | uniq -d)"

diff -u <(source_names) <(inventory_names)
diff -u <(inventory_names) <(audit_names)

grep -Fxq \
  'import CollatzClassical.KL2003.F3ReturnExcursionCoreArithmeticCodecPilotRepair' \
  "$audit_file"
grep -Fxq \
  'open CollatzClassical.KL2003.F3CoreArithmeticCodecPilotRepair' \
  "$audit_file"

if grep -Eq \
  '^private\b|\b(native_decide|Lean\.ofReduceBool|sorry|admit|find\?|HashMap|Array|CSV)\b|^[[:space:]]*axiom\b' \
  "$source_file"; then
  exit 1
fi

printf '%s\n' \
  'SOURCE_DECLARATIONS=151' \
  'INVENTORY_DECLARATIONS=151' \
  'AUDIT_COMMANDS=151' \
  'SOURCE_INVENTORY_DIFF=EMPTY' \
  'INVENTORY_AUDIT_DIFF=EMPTY' \
  'DUPLICATES=NONE' \
  'PRIVATE_EXPLICIT_DECLARATIONS=NONE' \
  'AUDIT_IMPORT_NAMESPACE=REPAIR_MODULE' \
  'FORBIDDEN_SOURCE_SYNTAX=ABSENT' \
  'STATIC_INVENTORY_CHECK=PASS'
