#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo_root=$(cd -- "$script_dir/../../.." && pwd)

source_file="$repo_root/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.lean"
audit_file="$repo_root/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepairAxiomAudit.lean"
inventory_file="$repo_root/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_DECLARATION_INVENTORY_v1.tsv"
expected_count=151
audit_log_path=''
final_public_theorems=(
  decode_encode
  encode_decode
  coreCode_card
  directTarget_closed_form
  liftTarget_closed_form
  realize_injective
  formulaEdge_card
  pilotFormulaEdge_card
  pilotFrozen_position_normalization
  pilotFrozen_perm_formula
  pilot_frozen_scope
  pilot_matrix_eq_formulaMatrix
)

if [[ $# -ne 0 ]]; then
  if [[ $# -ne 2 || "$1" != '--audit-log' ]]; then
    printf '%s\n' 'usage: checker [--audit-log PATH]' >&2
    exit 2
  fi
  audit_log_path=$2
  test -r "$audit_log_path"
fi

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
grep -Fxq 'import Lean.Meta.Basic' "$audit_file"
grep -Fxq 'import Lean.Util.CollectAxioms' "$audit_file"
grep -Fq 'run_meta do' "$audit_file"
grep -Fq 'env.constants.toList.map Prod.fst |>.filter namespacePrefix.isPrefixOf' \
  "$audit_file"
grep -Fq 'Lean.collectAxioms declaration' "$audit_file"
grep -Fq 'NAMESPACE_DECLARATION_COUNT=' "$audit_file"
grep -Fq 'AXIOM_PROFILE\t' "$audit_file"

for theorem_name in "${final_public_theorems[@]}"; do
  grep -Fxq "#print axioms $theorem_name" "$audit_file"
done

if grep -Eq \
  '^private\b|\b(native_decide|Lean\.ofReduceBool|sorry|admit|find\?|HashMap|Array|CSV)\b|^[[:space:]]*axiom\b' \
  "$source_file"; then
  exit 1
fi

printf '%s\n' \
  'ALL_EXPLICIT_SOURCE_DECLARATIONS=151' \
  'EXPLICIT_INVENTORY_DECLARATIONS=151' \
  'EXPLICIT_AUDIT_COMMANDS=151' \
  'SOURCE_INVENTORY_DIFF=EMPTY' \
  'INVENTORY_AUDIT_DIFF=EMPTY' \
  'DUPLICATES=NONE' \
  'PRIVATE_EXPLICIT_DECLARATIONS=NONE' \
  'FINAL_PUBLIC_THEOREMS_IN_AUDIT=12_OF_12' \
  'ENVIRONMENTAL_NAMESPACE_ENUMERATOR=PRESENT_NOT_EXECUTED' \
  'GENERATED_NAMESPACE_ENUMERATION=DEFERRED_TO_CONDITIONAL_AUDIT' \
  'AUDIT_IMPORT_NAMESPACE=REPAIR_MODULE' \
  'FORBIDDEN_SOURCE_SYNTAX=ABSENT' \
  'STATIC_EXPLICIT_INVENTORY_CHECK=PASS'

if [[ -n "$audit_log_path" ]]; then
  read -r count_line_count namespace_count profile_count forbidden_count < <(
    awk '
      /NAMESPACE_DECLARATION_COUNT=[0-9]+/ {
        count_lines += 1
        value = $0
        sub(/^.*NAMESPACE_DECLARATION_COUNT=/, "", value)
        sub(/[^0-9].*$/, "", value)
        namespace_count = value + 0
      }
      /AXIOM_PROFILE[[:space:]]/ {
        profiles += 1
        if ($0 ~ /(Lean\.ofReduceBool|sorryAx)/) forbidden += 1
      }
      END {
        print count_lines + 0, namespace_count + 0, profiles + 0, forbidden + 0
      }
    ' "$audit_log_path"
  )

  test "$count_line_count" -eq 1
  test "$namespace_count" -gt 0
  test "$profile_count" -eq "$namespace_count"
  test "$forbidden_count" -eq 0

  printf '%s\n' \
    "ENVIRONMENTAL_NAMESPACE_DECLARATIONS=$namespace_count" \
    "ENVIRONMENTAL_AXIOM_PROFILES=$profile_count" \
    'FORBIDDEN_ENVIRONMENTAL_AXIOMS=ABSENT' \
    'ENVIRONMENTAL_NAMESPACE_AUDIT_LOG=PASS'
fi
