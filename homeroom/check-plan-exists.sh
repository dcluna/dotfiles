#!/usr/bin/env bash
# Checks that the branch includes at least one new file in docs/plans/
set -euo pipefail

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
