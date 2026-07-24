#!/usr/bin/env bash
set -euo pipefail

export LC_ALL=C
export LANG=C

repo='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3'
source "$repo/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_forward_right_certificate_v4_common.sh"

verify_base_environment 209 0 209
test -z "$(global_new_objects)"

for suffix in olean ilean; do
  test ! -e "$collatz/KL2003/F3ReturnExcursionForwardFormulaRightCertificate.$suffix"
  test ! -e "$collatz/KL2003/F3ReturnExcursionForwardFormulaRightCertificateAxiomAudit.$suffix"
done

printf '%s\n' \
  'import CollatzClassical.KL2003.F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity' \
  'import CollatzClassical.KL2003.F3ReturnExcursionExactCoreMatrixChannelBounds' \
  'import CollatzClassical.KL2003.F3ReturnExcursionRealOperatorBridge' \
  '#check CollatzClassical.KL2003.F3CoreArithmeticCodecFullCoreIdentity.coreMatrix_eq_fullFormulaMatrix' \
  '#check CollatzClassical.KL2003.F3ExactCoreMatrix.exact_channelWeight_one_lower' \
  '#check CollatzClassical.KL2003.F3RealOperatorBridge.weighted_mass_push_lower_bound' |
  env LC_ALL=C LANG=C LEAN_PATH="$lean_path" \
    "$lean_bin" "--root=$repo" --stdin

for suffix in olean ilean; do
  test ! -e "$collatz/KL2003/F3ReturnExcursionForwardFormulaRightCertificate.$suffix"
  test ! -e "$collatz/KL2003/F3ReturnExcursionForwardFormulaRightCertificateAxiomAudit.$suffix"
done
verify_base_environment 209 0 209
test -z "$(global_new_objects)"

printf '%s\n' \
  'F3_FORWARD_V4_IMPORT_PROBE=PASS' \
  'F3_FORWARD_V4_SINGLE_COLLATZ_ROOT=PASS' \
  'F3_FORWARD_V4_TARGET_OBJECTS_AFTER_PROBE=ABSENT'
