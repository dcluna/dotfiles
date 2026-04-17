#!/usr/bin/env bash
# Ensures no new plan docs were added on this branch.
# Only runs in clean mode. Skips in enforce mode (default).
set -euo pipefail

PLAN_DOC_MODE=$(git config plan-doc.mode 2>/dev/null || echo "enforce")
[ "$PLAN_DOC_MODE" != "clean" ] && exit 0

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

# Check for plan docs added on this branch (ignore ones already on base)
BRANCH_PLANS=$(git diff --name-only --diff-filter=A "$MERGE_BASE" HEAD -- docs/)

if [ -n "$BRANCH_PLANS" ]; then
  cat <<MSG
ERROR: Plan documents added on this branch must be removed before pushing (mode: clean)

The following plan docs were added on this branch and must be removed:
$BRANCH_PLANS

Run: git rm $BRANCH_PLANS && git commit -m "Remove plan docs before merge"
MSG
  exit 1
fi

echo "Clean mode: no branch-added plan documents. PASS."
