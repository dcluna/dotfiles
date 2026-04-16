#!/usr/bin/env bash
# Checks that the branch includes at least one new file in docs/plans/
# Only runs in enforce mode (default). Skips in clean mode.
set -euo pipefail

PLAN_DOC_MODE=$(git config plan-doc.mode 2>/dev/null || echo "enforce")
[ "$PLAN_DOC_MODE" != "enforce" ] && exit 0

# Detect default branch from remote HEAD, then fall back to common names
DEFAULT_BRANCH=""
REMOTE_HEAD=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||')
if [ -n "$REMOTE_HEAD" ] && git rev-parse --verify "$REMOTE_HEAD" >/dev/null 2>&1; then
  DEFAULT_BRANCH="$REMOTE_HEAD"
else
  for candidate in main master develop; do
    if git rev-parse --verify "$candidate" >/dev/null 2>&1; then
      DEFAULT_BRANCH="$candidate"
      break
    fi
  done
fi

if [ -z "$DEFAULT_BRANCH" ]; then
  echo "ERROR: Could not detect default branch (tried origin/HEAD, main, master, develop)"
  exit 1
fi

# Find merge base
MERGE_BASE=$(git merge-base "$DEFAULT_BRANCH" HEAD)

# Check for new files in docs/plans/
NEW_PLANS=$(git diff --name-only --diff-filter=A "$MERGE_BASE" HEAD -- docs/plans/)

if [ -z "$NEW_PLANS" ]; then
  cat <<'MSG'
ERROR: No plan document found in docs/plans/

Every feature branch must include a new plan file in docs/plans/
that describes what this PR does and why.

Add a plan file and commit it before pushing.
MSG
  exit 1
fi

echo "Found plan document(s):"
echo "$NEW_PLANS"
