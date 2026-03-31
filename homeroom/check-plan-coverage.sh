#!/usr/bin/env bash
# Validates that plan docs in docs/plans/ cover all significant branch changes.
# Uses an AI agent CLI (configurable via env vars) to compare plan vs diff.
set -euo pipefail

AGENT_CMD="${PLAN_CHECK_AGENT:-claude}"
AGENT_FLAGS="${PLAN_CHECK_AGENT_FLAGS:--p}"

# Detect default branch
if git rev-parse --verify main >/dev/null 2>&1; then
  DEFAULT_BRANCH="main"
elif git rev-parse --verify master >/dev/null 2>&1; then
  DEFAULT_BRANCH="master"
else
  echo "ERROR: Could not detect default branch (tried main, master)"
  exit 1
fi

# Find merge base
MERGE_BASE=$(git merge-base "$DEFAULT_BRANCH" HEAD)

# Collect new plan files
NEW_PLANS=$(git diff --name-only --diff-filter=A "$MERGE_BASE" HEAD -- docs/plans/)

# Read plan contents
PLAN_CONTENTS=""
while IFS= read -r plan_file; do
  [ -z "$plan_file" ] && continue
  PLAN_CONTENTS+="
=== $plan_file ===
$(cat "$plan_file")
"
done <<< "$NEW_PLANS"

# Collect branch diff (excluding docs/plans/ to avoid circularity)
DIFF_CONTENTS=$(git diff "$MERGE_BASE" HEAD -- ':!docs/plans/')

if [ -z "$DIFF_CONTENTS" ]; then
  echo "No non-plan changes in branch. PASS."
  exit 0
fi

# Build the prompt
PROMPT="You are a PR plan reviewer. Compare the plan document(s) below against the branch diff.

Does the plan accurately document all significant changes? Ignore trivial changes
like whitespace, import reordering, or lock file updates.

Reply with EXACTLY one of:
- \"PASS\" on its own line if the plan covers all significant changes
- \"FAIL\" on its own line, followed by a bullet list of gaps (changes not documented in the plan)

--- PLAN ---
$PLAN_CONTENTS

--- DIFF ---
$DIFF_CONTENTS"

# Invoke the agent (timeout after 2 minutes, pipe prompt via stdin for ARG_MAX safety)
AGENT_TIMEOUT="${PLAN_CHECK_AGENT_TIMEOUT:-120}"
echo "Running plan coverage check with $AGENT_CMD..."
AGENT_OUTPUT=$(echo "$PROMPT" | timeout "$AGENT_TIMEOUT" $AGENT_CMD $AGENT_FLAGS 2>&1) || {
  echo "ERROR: Agent command failed (exit $?):"
  echo "$AGENT_OUTPUT"
  exit 1
}

# Check result (strict match: line must be exactly "PASS")
if echo "$AGENT_OUTPUT" | grep -qx "PASS"; then
  echo "Plan coverage check passed."
  exit 0
else
  echo "Plan coverage check FAILED. Agent output:"
  echo ""
  echo "$AGENT_OUTPUT"
  exit 1
fi
