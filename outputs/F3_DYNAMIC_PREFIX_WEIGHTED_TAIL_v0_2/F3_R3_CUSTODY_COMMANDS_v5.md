# F3 R3 two-commit custody commands v5

Date: 2026-07-25.

Status:

```text
RUNBOOK_ONLY
V4_SUPERSEDED_HOLD_NOT_EXECUTABLE
COMMANDS_NOT_EXECUTED
NO_GIT_INDEX_CHANGE
NO_COMMIT
NO_PUSH
NO_LEAN_EXECUTION
TWO_COMMITS_EXACTLY_A_THEN_D
BATCH_A_EXACTLY_ELEVEN_COMPILED_SOURCES
BATCH_D_EXACTLY_FOUR_CANONICAL_DOCUMENTS
SELF_DOCUMENT_HASHES_SUPPLIED_BY_EXPLICIT_AUTHORIZATION
SELF_DOCUMENT_AUTHORIZATION_VARIABLES_READONLY
SPLIT_TO_COMMANDS_HASH_LINK_REQUIRED
UNIQUE_EXPECTED_FETCH_AND_PUSH_URLS_REQUIRED
STATUS_SAFE_LIVE_LS_REMOTE_REQUIRED
LIVE_REMOTE_GATE_IMMEDIATELY_BEFORE_EACH_STAGE_AND_FINAL_PUSH
NO_MERGE_REBASE_CHERRY_PICK_OR_SEQUENCER_STATE
EACH_COMMIT_EXACTLY_ONE_PARENT
CLIENT_GIT_HOOKS_NEUTRALIZED
COMMIT_GPG_SIGNING_DISABLED
GIT_REPLACE_OBJECTS_DISABLED
FROZEN_FINAL_COMMIT_SHA_PUSH_ONLY
ABSENCE_CAS_LEASE_ONLY_NO_OVERWRITE
BATCH_B_LEAN_AND_NONCANONICAL_OUTPUTS_FORBIDDEN
```

## 1. Succession, exact scope and non-circular document hashes

This is the executable successor to
`F3_R3_CUSTODY_COMMANDS_v4.md`, SHA-256

```text
daa564d028a6de724825d200d3b1d268b7b08140b3d4b1bdaf944c28d4e5e52c
```

V4 remains unchanged as an immutable HOLD artifact and must not be executed.
V5 preserves every v4 allowlist, byte, parent, remote and operation-state
gate, and closes the two adversarial publication gaps found after v4:
client hooks are neutralized, and the destination creation is guarded by an
atomic absence lease rather than only a pre-push observation.

Exactly two commits are authorized:

1. **A** adds exactly eleven stable Lean sources at frozen hashes.  Their
   corresponding local `.olean` receipts are checked but never staged.
2. **D** adds exactly four canonical governance documents: Registry v9,
   Contract v5, Commands v5 and Split v5.

Commands v5 and Split v5 cannot embed their own ordinary file SHA-256 without
a self-reference cycle.  Their exact SHA-256 values are therefore mandatory
inputs to the later explicit execution authorization.  The runbook fails
unless the authorization exports both values, the working files match them,
and the same bytes survive index, commit and public verification.  This is an
external freeze, not a mutable or post-hoc hash choice.

If any command fails, stop and report.  V5 supplies no reset, restore,
unstage, delete, amend, merge, rebase, cherry-pick, revert, unconditional
force-push or cleanup command.

## 2. One-session setup and mandatory authorization inputs

Run later, only after an independent audit and explicit authorization naming
the two exact self-document SHA-256 values, in one fresh `/bin/bash` session:

```bash
set -euo pipefail

custody_repo='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3'
custody_branch='codex/hilo2-f3-r3-reverse-first-hit-v1'
custody_base='8765d7083906e7b3e3b03951da6331fcf1427e1b'
custody_public_base_branch='codex/hilo2-f3-r3-active-carrier-v1'
custody_public_remote='public'
custody_public_url='https://github.com/Menta2357/collatz-classical.git'
custody_origin_remote='origin'
custody_origin_url='/Users/MoiTam/Documents/Codex/2026-07-21/f3-density-update'

: "${F3_CUSTODY_COMMANDS_V5_SHA256:?explicit authorization must export F3_CUSTODY_COMMANDS_V5_SHA256}"
: "${F3_CUSTODY_SPLIT_V5_SHA256:?explicit authorization must export F3_CUSTODY_SPLIT_V5_SHA256}"
test "${#F3_CUSTODY_COMMANDS_V5_SHA256}" -eq 64
test "${#F3_CUSTODY_SPLIT_V5_SHA256}" -eq 64
printf '%s\n' "$F3_CUSTODY_COMMANDS_V5_SHA256" | /usr/bin/grep -Eq '^[0-9a-f]{64}$'
printf '%s\n' "$F3_CUSTODY_SPLIT_V5_SHA256" | /usr/bin/grep -Eq '^[0-9a-f]{64}$'

cd "$custody_repo"
```

The authorization variables are immutable for the session:

```bash
custody_authorized_commands_v5_sha="$F3_CUSTODY_COMMANDS_V5_SHA256"
custody_authorized_split_v5_sha="$F3_CUSTODY_SPLIT_V5_SHA256"
unset F3_CUSTODY_COMMANDS_V5_SHA256 F3_CUSTODY_SPLIT_V5_SHA256
readonly custody_authorized_commands_v5_sha custody_authorized_split_v5_sha

export GIT_NO_REPLACE_OBJECTS=1
readonly GIT_NO_REPLACE_OBJECTS
```

## 3. Exact Batch A source/object ledger

```bash
batch_a_paths=(
  'CollatzClassical/KL2003/F3ReturnExcursionBlock0ActiveChannelIntervals.lean'
  'CollatzClassical/KL2003/F3ReturnExcursionBlock0ReversePredecessor.lean'
  'CollatzClassical/KL2003/F3ReturnExcursionBlock0OrderedFirstHit.lean'
  'CollatzClassical/KL2003/F3ReturnExcursionBlock0OrderedFirstHitBool.lean'
  'CollatzClassical/KL2003/F3ReturnExcursionBlock0R3OrderedInterfaceAxiomAudit.lean'
  'CollatzClassical/KL2003/F3ReturnExcursionBlock0ActiveStaticPreconditions.lean'
  'CollatzClassical/KL2003/F3ReturnExcursionBlock0ActiveStaticPreconditionsAxiomAudit.lean'
  'CollatzClassical/KL2003/F3ReturnExcursionBlock0MassAtoms.lean'
  'CollatzClassical/KL2003/F3ReturnExcursionBlock0MassAtomsAxiomAudit.lean'
  'CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSData.lean'
  'CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSVerifier.lean'
)

batch_a_shas=(
  'c112a67f71818da6c9738bfb9cad57bdb4d3e9ff86265e8f1cee47cef9734623'
  '3dc3a02c118e8d300c96947421da8bce0244b03257c10b65912e73d2b0912ffe'
  'a84a79389401e4d837cd6085d93864600dd1fc78549c51c44b440311ccac2d01'
  'c91ca09930ff5c79513fef27dd10276c8c13c135155e5c79093d7634c29ab455'
  'ad0cf8c449c8ae96676ec96e55f748b094fe04a4c605177c86f0eb43bd7af613'
  '41a536464e339b9dbdd2380c90963798739d21df9c797193ed73f0c737c9518d'
  '4b76a030e3fd2f462848f0675a55c620131696daf8436b4314e79901dd871e85'
  '5389c6b8302561fe82504b02f7fc0539d30a9519d9a2f5f825c53a5a3ead34d6'
  '5023dd93d4f32b630844bb984b647df32ba759b0d1ea5d85cf8008a414887ac8'
  '02275794ecd3acd5bd17e2b542401f1db43922386c188b6c0ccc5c28eac2d256'
  'dcedbd42da9887d3a47d4877582cabe1fde8af995454048443c6ce2faaa899e3'
)

batch_a_olean_paths=(
  '.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionBlock0ActiveChannelIntervals.olean'
  '.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionBlock0ReversePredecessor.olean'
  '.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionBlock0OrderedFirstHit.olean'
  '.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionBlock0OrderedFirstHitBool.olean'
  '.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionBlock0R3OrderedInterfaceAxiomAudit.olean'
  '.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionBlock0ActiveStaticPreconditions.olean'
  '.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionBlock0ActiveStaticPreconditionsAxiomAudit.olean'
  '.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionBlock0MassAtoms.olean'
  '.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionBlock0MassAtomsAxiomAudit.olean'
  '.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSData.olean'
  '.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSVerifier.olean'
)

batch_a_olean_shas=(
  'dfcbf1f0270e396770196e5800a16b136aad8d4743bde0e7e85ec6bd15fd4851'
  'af2cb1275b8124ce8722f95f2a175cefb8b51077cf4a047aa0a3002165cbf692'
  'fbf7679d8696fb76c2c59fb8241f06d6505796706732b2a27d6d005d14b94e2d'
  '9d21376ad356f8cf64112e978599f85389370c7f7b1eb12e83defb487bc21ce8'
  '0c59efdc2b653ebb79609baf6b6b14f64409b9a8ee6ccb945c864ba1605bbc9b'
  'd67190896ef2dd102e380f023744c6bfab19bb465569a5a3090232306ca7bf09'
  'd913510925fc77285fad2c75333e2af1abc2e7b41253eb1f5aa8a4ffac31c96b'
  '235cf28825a82b284d06798ecb5472ac2fea09109ff137c89ba698ddb57941a5'
  '885124e52931c220fcff8e41a39a911e0a247cfdf3f7bbd09d4d682bea1d0c0b'
  'f796bb7ceb2b76a4752609afa81e891165b11b100e18bd0c1fce3eec2b74870e'
  'fa4521a0890e041842f402475e74633a813acea25546f2c0f52e0efa22e9fc7a'
)

test "${#batch_a_paths[@]}" -eq 11
test "${#batch_a_shas[@]}" -eq 11
test "${#batch_a_olean_paths[@]}" -eq 11
test "${#batch_a_olean_shas[@]}" -eq 11
```

## 4. Exact Batch D canonical-document ledger

```bash
batch_d_paths=(
  'outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_R3_EXECUTION_REGISTRY_v9.md'
  'outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_R3_REVERSE_BFS_PILOT_CONTRACT_v5.md'
  'outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_R3_CUSTODY_COMMANDS_v5.md'
  'outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_R3_CUSTODY_SPLIT_v5.md'
)

batch_d_shas=(
  'c71d45a85e2f2e307abb026824f2b226ff6e7783f8bbc222a79d303aabaccef5'
  '7e2616e2a9d7be82e445cae30b8465cc39cff11bdee08ce45d117cb79c864369'
  "$custody_authorized_commands_v5_sha"
  "$custody_authorized_split_v5_sha"
)

test "${#batch_d_paths[@]}" -eq 4
test "${#batch_d_shas[@]}" -eq 4
```

No Registry v7/v8, Contract v1--v4, Commands v1--v4, Split v1--v4, result,
script, payload or other output path is admitted by Batch D.

## 5. Fail-hard shared safety functions

```bash
refuse_active_git_operation () {
  custody_marker=''
  for custody_marker in MERGE_HEAD CHERRY_PICK_HEAD REVERT_HEAD REBASE_HEAD; do
    test ! -e "$(git rev-parse --git-path "$custody_marker")"
  done
  test ! -d "$(git rev-parse --git-path rebase-apply)"
  test ! -d "$(git rev-parse --git-path rebase-merge)"
  test ! -d "$(git rev-parse --git-path sequencer)"
}

require_exact_remote_urls () {
  custody_remote="$1"
  custody_expected_fetch="$2"
  custody_expected_push="$3"

  custody_fetch_text=''
  if ! custody_fetch_text="$(git remote get-url --all "$custody_remote")"; then
    echo "REFUSE_FETCH_URL_LOOKUP_FAILURE $custody_remote" >&2
    exit 1
  fi
  test "$custody_fetch_text" = "$custody_expected_fetch"

  custody_push_text=''
  if ! custody_push_text="$(git remote get-url --push --all "$custody_remote")"; then
    echo "REFUSE_PUSH_URL_LOOKUP_FAILURE $custody_remote" >&2
    exit 1
  fi
  test "$custody_push_text" = "$custody_expected_push"
}

require_live_public_destination_absent () {
  custody_base_output=''
  if ! custody_base_output="$(git ls-remote --heads "$custody_public_remote" "refs/heads/$custody_public_base_branch")"; then
    echo 'REFUSE_LS_REMOTE_BASE_TRANSPORT_FAILURE' >&2
    exit 1
  fi
  custody_expected_base_row="${custody_base}"$'\t'"refs/heads/${custody_public_base_branch}"
  test "$custody_base_output" = "$custody_expected_base_row"

  custody_destination_output=''
  if ! custody_destination_output="$(git ls-remote --heads "$custody_public_remote" "refs/heads/$custody_branch")"; then
    echo 'REFUSE_LS_REMOTE_DESTINATION_TRANSPORT_FAILURE' >&2
    exit 1
  fi
  test -z "$custody_destination_output"
}

check_custody_sha () {
  custody_expected_sha="$1"
  custody_file="$2"
  custody_actual_sha="$(/usr/bin/shasum -a 256 "$custody_file" | /usr/bin/awk '{print $1}')"
  test "$custody_actual_sha" = "$custody_expected_sha"
}

require_split_commands_hash_link () {
  custody_split_path='outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_R3_CUSTODY_SPLIT_v5.md'
  custody_link_count="$(/usr/bin/grep -Fxc "$custody_authorized_commands_v5_sha" "$custody_split_path")"
  test "$custody_link_count" = '1'
}

check_staged_entry () {
  custody_expected_sha="$1"
  custody_path="$2"
  custody_expected_status="$(printf 'A\t%s' "$custody_path")"
  custody_actual_status="$(git diff --cached --name-status -- "$custody_path")"
  test "$custody_actual_status" = "$custody_expected_status"

  custody_index_line="$(git ls-files --stage -- "$custody_path")"
  custody_index_mode="$(printf '%s\n' "$custody_index_line" | /usr/bin/awk '{print $1}')"
  custody_index_stage="$(printf '%s\n' "$custody_index_line" | /usr/bin/awk '{print $3}')"
  test "$custody_index_mode" = '100644'
  test "$custody_index_stage" = '0'

  custody_staged_sha="$(git show ":$custody_path" | /usr/bin/shasum -a 256 | /usr/bin/awk '{print $1}')"
  test "$custody_staged_sha" = "$custody_expected_sha"
}

check_committed_entry () {
  custody_expected_sha="$1"
  custody_commit="$2"
  custody_path="$3"
  custody_tree_line="$(git ls-tree "$custody_commit" -- "$custody_path")"
  custody_tree_mode="$(printf '%s\n' "$custody_tree_line" | /usr/bin/awk '{print $1}')"
  custody_tree_type="$(printf '%s\n' "$custody_tree_line" | /usr/bin/awk '{print $2}')"
  test "$custody_tree_mode" = '100644'
  test "$custody_tree_type" = 'blob'

  custody_committed_sha="$(git show "$custody_commit:$custody_path" | /usr/bin/shasum -a 256 | /usr/bin/awk '{print $1}')"
  test "$custody_committed_sha" = "$custody_expected_sha"
}
```

Raw `ls-remote` status is evaluated before output.  DNS, authentication or
transport failure cannot masquerade as an absent destination.  Exact
whole-output equality rejects an empty, duplicate or unexpected base row.

## 6. Read-only preflight for both batches

```bash
test "$(git branch --show-current)" = "$custody_branch"
test "$(git rev-parse HEAD)" = "$custody_base"
test "$(git rev-parse "refs/heads/$custody_branch")" = "$custody_base"
refuse_active_git_operation
require_exact_remote_urls "$custody_public_remote" "$custody_public_url" "$custody_public_url"
require_exact_remote_urls "$custody_origin_remote" "$custody_origin_url" "$custody_origin_url"

git diff --quiet
git diff --cached --quiet
git diff --check
test "$(git rev-parse "$custody_public_remote/$custody_public_base_branch")" = "$custody_base"

for custody_index in "${!batch_a_paths[@]}"; do
  custody_path="${batch_a_paths[$custody_index]}"
  custody_object="${batch_a_olean_paths[$custody_index]}"
  test -f "$custody_path"
  test -f "$custody_object"
  if git ls-files --error-unmatch -- "$custody_path" >/dev/null 2>&1; then
    echo "REFUSE_ALREADY_TRACKED_BATCH_A $custody_path" >&2
    exit 1
  fi
  check_custody_sha "${batch_a_shas[$custody_index]}" "$custody_path"
  check_custody_sha "${batch_a_olean_shas[$custody_index]}" "$custody_object"
  test "$custody_object" -nt "$custody_path"
done

for custody_index in "${!batch_d_paths[@]}"; do
  custody_path="${batch_d_paths[$custody_index]}"
  test -f "$custody_path"
  if git ls-files --error-unmatch -- "$custody_path" >/dev/null 2>&1; then
    echo "REFUSE_ALREADY_TRACKED_BATCH_D $custody_path" >&2
    exit 1
  fi
  check_custody_sha "${batch_d_shas[$custody_index]}" "$custody_path"
done
require_split_commands_hash_link

test "$(git ls-files --others --exclude-standard -- "${batch_a_paths[@]}" | /usr/bin/wc -l | /usr/bin/tr -d ' ')" = '11'
test "$(git ls-files --others --exclude-standard -- "${batch_d_paths[@]}" | /usr/bin/wc -l | /usr/bin/tr -d ' ')" = '4'
git status --short --branch
```

This runs no Lean.  Other untracked work may remain present, but exact path
staging and complete staged/commit-tree equality prevent its inclusion.

## 7. Commit A — immediate gate, exact stage and audit

The following block must be contiguous.  The live remote gate is the last
read-only operation before the sole Batch A index mutation:

```bash
test "$(git branch --show-current)" = "$custody_branch"
test "$(git rev-parse HEAD)" = "$custody_base"
refuse_active_git_operation
git diff --quiet
git diff --cached --quiet
for custody_index in "${!batch_a_paths[@]}"; do
  check_custody_sha "${batch_a_shas[$custody_index]}" "${batch_a_paths[$custody_index]}"
  check_custody_sha "${batch_a_olean_shas[$custody_index]}" "${batch_a_olean_paths[$custody_index]}"
  test "${batch_a_olean_paths[$custody_index]}" -nt "${batch_a_paths[$custody_index]}"
done
require_exact_remote_urls "$custody_public_remote" "$custody_public_url" "$custody_public_url"
require_exact_remote_urls "$custody_origin_remote" "$custody_origin_url" "$custody_origin_url"
require_live_public_destination_absent
git add -- "${batch_a_paths[@]}"
```

No command may be inserted between the live gate and `git add`.

```bash
batch_a_expected_paths="$(printf '%s\n' "${batch_a_paths[@]}" | LC_ALL=C /usr/bin/sort)"
batch_a_expected_name_status="$(for custody_path in "${batch_a_paths[@]}"; do printf 'A\t%s\n' "$custody_path"; done | LC_ALL=C /usr/bin/sort)"
batch_a_staged_paths="$(git diff --cached --name-only | LC_ALL=C /usr/bin/sort)"
batch_a_staged_name_status="$(git diff --cached --name-status | LC_ALL=C /usr/bin/sort)"

test "$batch_a_staged_paths" = "$batch_a_expected_paths"
test "$batch_a_staged_name_status" = "$batch_a_expected_name_status"
test "$(git diff --cached --name-only | /usr/bin/wc -l | /usr/bin/tr -d ' ')" = '11'

for custody_index in "${!batch_a_paths[@]}"; do
  check_staged_entry "${batch_a_shas[$custody_index]}" "${batch_a_paths[$custody_index]}"
done

if printf '%s\n' "$batch_a_staged_paths" | /usr/bin/grep -E '(^|/)\.lake/|\.olean$|^outputs/'; then
  echo 'REFUSE_FORBIDDEN_BATCH_A_STAGED_PATH' >&2
  exit 1
fi
if printf '%s\n' "$batch_a_staged_paths" | /usr/bin/grep -E 'MassDemandProfile|ReverseBFSMassIntegration|ReverseBFSAxiomAudit|SemanticChildBaseHit|ReverseBFSCompleteness|SameParentDisjoint|FirstHitAllocation|DemandOneClosed|ResidualCertificateAllocation'; then
  echo 'REFUSE_BATCH_B_LEAN_IN_COMMIT_A' >&2
  exit 1
fi

git diff --cached --check
git diff --cached --name-status
git diff --cached --stat
```

Commit once and require exactly one parent:

```bash
refuse_active_git_operation
git -c core.hooksPath=/dev/null -c commit.gpgSign=false commit \
  -m 'Custody F3 R3 stable reverse-first-hit prefix' \
  -m 'Commit A only: eleven exact sources. Ordered interface 55/55, static 2/2 and MassAtoms 11/11 are historical audit receipts; Data/Verifier remain build-only pending audit42.'

custody_commit_a="$(git rev-parse HEAD)"
custody_commit_a_parents="$(git show -s --format='%P' "$custody_commit_a")"
test "$custody_commit_a_parents" = "$custody_base"
test "$(printf '%s\n' "$custody_commit_a_parents" | /usr/bin/awk '{print NF}')" = '1'

batch_a_committed_paths="$(git diff-tree --no-commit-id --name-only -r "$custody_commit_a" | LC_ALL=C /usr/bin/sort)"
batch_a_committed_name_status="$(git diff-tree --no-commit-id --name-status -r "$custody_commit_a" | LC_ALL=C /usr/bin/sort)"
test "$batch_a_committed_paths" = "$batch_a_expected_paths"
test "$batch_a_committed_name_status" = "$batch_a_expected_name_status"
test "$(git diff-tree --no-commit-id --name-only -r "$custody_commit_a" | /usr/bin/wc -l | /usr/bin/tr -d ' ')" = '11'

for custody_index in "${!batch_a_paths[@]}"; do
  check_committed_entry "${batch_a_shas[$custody_index]}" "$custody_commit_a" "${batch_a_paths[$custody_index]}"
done

if printf '%s\n' "$batch_a_committed_paths" | /usr/bin/grep -E '(^|/)\.lake/|\.olean$|^outputs/'; then
  echo 'REFUSE_FORBIDDEN_BATCH_A_COMMITTED_PATH' >&2
  exit 1
fi

refuse_active_git_operation
git diff --quiet
git diff --cached --quiet
```

## 8. Commit D — immediate gate, exact stage and audit

Commit D must start from the already audited Commit A.  Recheck all four
authorized document bytes before the immediate remote gate:

```bash
test "$(git branch --show-current)" = "$custody_branch"
test "$(git rev-parse HEAD)" = "$custody_commit_a"
test "$(git show -s --format='%P' "$custody_commit_a")" = "$custody_base"
refuse_active_git_operation
git diff --quiet
git diff --cached --quiet
for custody_index in "${!batch_d_paths[@]}"; do
  check_custody_sha "${batch_d_shas[$custody_index]}" "${batch_d_paths[$custody_index]}"
done
require_split_commands_hash_link
require_exact_remote_urls "$custody_public_remote" "$custody_public_url" "$custody_public_url"
require_exact_remote_urls "$custody_origin_remote" "$custody_origin_url" "$custody_origin_url"
require_live_public_destination_absent
git add -- "${batch_d_paths[@]}"
```

No command may be inserted between the live gate and `git add`.

```bash
batch_d_expected_paths="$(printf '%s\n' "${batch_d_paths[@]}" | LC_ALL=C /usr/bin/sort)"
batch_d_expected_name_status="$(for custody_path in "${batch_d_paths[@]}"; do printf 'A\t%s\n' "$custody_path"; done | LC_ALL=C /usr/bin/sort)"
batch_d_staged_paths="$(git diff --cached --name-only | LC_ALL=C /usr/bin/sort)"
batch_d_staged_name_status="$(git diff --cached --name-status | LC_ALL=C /usr/bin/sort)"

test "$batch_d_staged_paths" = "$batch_d_expected_paths"
test "$batch_d_staged_name_status" = "$batch_d_expected_name_status"
test "$(git diff --cached --name-only | /usr/bin/wc -l | /usr/bin/tr -d ' ')" = '4'

for custody_index in "${!batch_d_paths[@]}"; do
  check_staged_entry "${batch_d_shas[$custody_index]}" "${batch_d_paths[$custody_index]}"
done

if printf '%s\n' "$batch_d_staged_paths" | /usr/bin/grep -Ev '^outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/(F3_R3_EXECUTION_REGISTRY_v9|F3_R3_REVERSE_BFS_PILOT_CONTRACT_v5|F3_R3_CUSTODY_COMMANDS_v5|F3_R3_CUSTODY_SPLIT_v5)\.md$'; then
  echo 'REFUSE_NONCANONICAL_BATCH_D_PATH' >&2
  exit 1
fi
if printf '%s\n' "$batch_d_staged_paths" | /usr/bin/grep -E '\.lean$|\.olean$|/results/|/scripts/|Payload'; then
  echo 'REFUSE_BATCH_B_OR_EXECUTABLE_IN_COMMIT_D' >&2
  exit 1
fi

git diff --cached --check
git diff --cached --name-status
git diff --cached --stat
```

Commit once and require exactly one parent, Commit A:

```bash
refuse_active_git_operation
git -c core.hooksPath=/dev/null -c commit.gpgSign=false commit \
  -m 'Custody F3 R3 canonical governance' \
  -m 'Commit D only: Registry v9, pilot Contract v5, and the audited two-commit custody successors. No Batch B Lean source, result, script or execution claim.'

custody_commit_d="$(git rev-parse HEAD)"
custody_commit_d_parents="$(git show -s --format='%P' "$custody_commit_d")"
test "$custody_commit_d_parents" = "$custody_commit_a"
test "$(printf '%s\n' "$custody_commit_d_parents" | /usr/bin/awk '{print NF}')" = '1'

batch_d_committed_paths="$(git diff-tree --no-commit-id --name-only -r "$custody_commit_d" | LC_ALL=C /usr/bin/sort)"
batch_d_committed_name_status="$(git diff-tree --no-commit-id --name-status -r "$custody_commit_d" | LC_ALL=C /usr/bin/sort)"
test "$batch_d_committed_paths" = "$batch_d_expected_paths"
test "$batch_d_committed_name_status" = "$batch_d_expected_name_status"
test "$(git diff-tree --no-commit-id --name-only -r "$custody_commit_d" | /usr/bin/wc -l | /usr/bin/tr -d ' ')" = '4'

for custody_index in "${!batch_d_paths[@]}"; do
  check_committed_entry "${batch_d_shas[$custody_index]}" "$custody_commit_d" "${batch_d_paths[$custody_index]}"
done

if printf '%s\n' "$batch_d_committed_paths" | /usr/bin/grep -Ev '^outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/(F3_R3_EXECUTION_REGISTRY_v9|F3_R3_REVERSE_BFS_PILOT_CONTRACT_v5|F3_R3_CUSTODY_COMMANDS_v5|F3_R3_CUSTODY_SPLIT_v5)\.md$'; then
  echo 'REFUSE_NONCANONICAL_BATCH_D_COMMITTED_PATH' >&2
  exit 1
fi

refuse_active_git_operation
git diff --quiet
git diff --cached --quiet
```

## 9. Immediate final pre-push gate and atomic absent-to-SHA push

The following block must be contiguous.  The status-safe live remote gate is
the last operation before the only network mutation:

```bash
test "$(git branch --show-current)" = "$custody_branch"
test "$(git rev-parse HEAD)" = "$custody_commit_d"
test "$(git rev-parse "refs/heads/$custody_branch")" = "$custody_commit_d"
test "$(git show -s --format='%P' "$custody_commit_d")" = "$custody_commit_a"
test "$(git show -s --format='%P' "$custody_commit_a")" = "$custody_base"
test "$(printf '%s\n' "$(git show -s --format='%P' "$custody_commit_d")" | /usr/bin/awk '{print NF}')" = '1'
test "$(printf '%s\n' "$(git show -s --format='%P' "$custody_commit_a")" | /usr/bin/awk '{print NF}')" = '1'
refuse_active_git_operation
git diff --quiet
git diff --cached --quiet
for custody_index in "${!batch_d_paths[@]}"; do
  check_custody_sha "${batch_d_shas[$custody_index]}" "${batch_d_paths[$custody_index]}"
done
require_split_commands_hash_link
require_exact_remote_urls "$custody_public_remote" "$custody_public_url" "$custody_public_url"
require_exact_remote_urls "$custody_origin_remote" "$custody_origin_url" "$custody_origin_url"
require_live_public_destination_absent
git -c core.hooksPath=/dev/null push \
  --force-with-lease="refs/heads/$custody_branch:" \
  "$custody_public_remote" "$custody_commit_d:refs/heads/$custody_branch"
```

No command may be inserted between the live gate and `git push`.  The sole
force-class option is the empty expected-value lease above: it encodes
`old = zero`, so creation succeeds only while the destination is absent and
cannot overwrite any existing ref.  No unconditional force, deletion,
wildcard, tag, `origin` destination or mutable source ref is authorized.

## 10. Read-only public verification

```bash
require_exact_remote_urls "$custody_public_remote" "$custody_public_url" "$custody_public_url"

custody_remote_output=''
if ! custody_remote_output="$(git ls-remote --heads "$custody_public_remote" "refs/heads/$custody_branch")"; then
  echo 'REFUSE_POST_PUSH_LS_REMOTE_TRANSPORT_FAILURE' >&2
  exit 1
fi
custody_expected_remote_row="${custody_commit_d}"$'\t'"refs/heads/${custody_branch}"
test "$custody_remote_output" = "$custody_expected_remote_row"

test "$(git rev-parse HEAD)" = "$custody_commit_d"
test "$(git show -s --format='%P' "$custody_commit_d")" = "$custody_commit_a"
test "$(git show -s --format='%P' "$custody_commit_a")" = "$custody_base"

test "$(git diff-tree --no-commit-id --name-only -r "$custody_commit_a" | LC_ALL=C /usr/bin/sort)" = "$batch_a_expected_paths"
test "$(git diff-tree --no-commit-id --name-status -r "$custody_commit_a" | LC_ALL=C /usr/bin/sort)" = "$batch_a_expected_name_status"
test "$(git diff-tree --no-commit-id --name-only -r "$custody_commit_d" | LC_ALL=C /usr/bin/sort)" = "$batch_d_expected_paths"
test "$(git diff-tree --no-commit-id --name-status -r "$custody_commit_d" | LC_ALL=C /usr/bin/sort)" = "$batch_d_expected_name_status"

for custody_index in "${!batch_a_paths[@]}"; do
  check_committed_entry "${batch_a_shas[$custody_index]}" "$custody_commit_a" "${batch_a_paths[$custody_index]}"
done
for custody_index in "${!batch_d_paths[@]}"; do
  check_committed_entry "${batch_d_shas[$custody_index]}" "$custody_commit_d" "${batch_d_paths[$custody_index]}"
done

refuse_active_git_operation
git diff --quiet
git diff --cached --quiet
git status --short --branch
git show --no-patch --format='commit=%H%nparents=%P%nsubject=%s' "$custody_commit_a"
git show --no-patch --format='commit=%H%nparents=%P%nsubject=%s' "$custody_commit_d"
```

This proves public custody of exactly eleven source additions followed by
exactly four canonical-document additions at two single-parent commits.  The
single ref update is an absence-CAS: a concurrently created destination makes
the lease fail instead of being fast-forwarded or overwritten.  It
does not set an upstream, publish any Batch B Lean source, run Lean, authorize
the residual 452, prove the `202/443` boundary hypothesis, set pilot readiness
or prove an F3 exponent, density or Collatz result.
