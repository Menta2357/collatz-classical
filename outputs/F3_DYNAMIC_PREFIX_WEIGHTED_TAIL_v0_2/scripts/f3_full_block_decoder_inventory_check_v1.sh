#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo_root=$(cd -- "$script_dir/../../.." && pwd)

source_file="$repo_root/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.lean"
audit_file="$repo_root/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoderAxiomAudit.lean"
inventory_file="$repo_root/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_CORE_ARITHMETIC_CODEC_FULL_BLOCK_DECODER_DECLARATION_INVENTORY_v1.tsv"
guard="$script_dir/f3_axiom_audit_log_guard_v2.sh"
expected_count=30
audit_log_path=''
final_public_theorems=(
  liftPilotEdge_edgeBlock_edgeLocal
  frozenPos_liftPilotEdge
  frozenPos_eq_joinPosition
  corePositionUnrank_frozenPos
  corePositionToRank_frozenPos
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
  END { if (expected != 30) exit 1 }
' "$inventory_file"

test -z "$(source_names | sort | uniq -d)"
test -z "$(inventory_names | sort | uniq -d)"
test -z "$(audit_names | sort | uniq -d)"

diff -u <(source_names) <(inventory_names)
diff -u <(inventory_names) <(audit_names)

grep -Fxq \
  'import CollatzClassical.KL2003.F3ReturnExcursionCoreArithmeticCodecPilotRepair' \
  "$source_file"
grep -Fxq \
  'import CollatzClassical.KL2003.F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder' \
  "$audit_file"
grep -Fq 'env.constants.toList.map Prod.fst |>.filter namespacePrefix.isPrefixOf' \
  "$audit_file"

for theorem_name in "${final_public_theorems[@]}"; do
  grep -Fxq "#print axioms $theorem_name" "$audit_file"
done

if grep -Eq \
  '^private\b|\b(native_decide|Lean\.ofReduceBool|sorry|admit|find\?|HashMap|Array|CSV|fin_cases)\b|^[[:space:]]*axiom\b' \
  "$source_file"; then
  exit 1
fi

printf '%s\n' \
  'FULL_BLOCK_SOURCE_DECLARATIONS=30' \
  'FULL_BLOCK_INVENTORY_DECLARATIONS=30' \
  'FULL_BLOCK_AUDIT_COMMANDS=30' \
  'FULL_BLOCK_SOURCE_INVENTORY_DIFF=EMPTY' \
  'FULL_BLOCK_INVENTORY_AUDIT_DIFF=EMPTY' \
  'FULL_BLOCK_DUPLICATES=NONE' \
  'FULL_BLOCK_FINAL_PUBLIC_THEOREMS=5_OF_5' \
  'FULL_BLOCK_FORBIDDEN_SOURCE_SYNTAX=ABSENT' \
  'FULL_BLOCK_STATIC_INVENTORY_CHECK=PASS'

if [[ -n "$audit_log_path" ]]; then
  bash "$guard" --audit-log "$audit_log_path"
  printf '%s\n' 'FULL_BLOCK_CONDITIONAL_AUDIT_LOG_CHECK=PASS'
fi
