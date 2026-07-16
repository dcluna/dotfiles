#!/usr/bin/env bash
# ci-check-stack: Get CircleCI status for a stack of branches.
#
# Usage:
#   ci-check-stack base..tip          # all branches from base to tip
#   ci-check-stack branch1 branch2    # explicit branch list
#   ci-check-stack --failing-only base..tip  # only print failing branches
#
# Output: JSON array of {branch, pr, status, failing_checks:[{name,link}]}
# Exit codes: 0 = all green, 1 = failures found, 2 = usage error

set -euo pipefail

FAILING_ONLY=false

if [[ "${1:-}" == "--failing-only" ]]; then
  FAILING_ONLY=true
  shift
fi

if [[ $# -lt 1 ]]; then
  echo "Usage: ci-check-stack [--failing-only] base..tip | branch1 branch2 ..." >&2
  exit 2
fi

# Resolve branches: either base..tip syntax or explicit list
branches=()
if [[ "$1" == *".."* ]]; then
  base="${1%%".."*}"
  tip="${1##*".."}"
  # Get branches between base and tip by walking the commit graph
  while IFS= read -r ref; do
    branches+=("$ref")
  done < <(git log --reverse --format='%D' "$base..$tip" | tr ',' '\n' | sed 's/^ *//' | grep -v '^$' | grep -v 'HEAD' | grep -v '^origin/' | sed 's|^origin/||' | sort -u)
  # If no branches found via decoration, fall back: tip itself
  if [[ ${#branches[@]} -eq 0 ]]; then
    branches+=("$tip")
  fi
else
  branches=("$@")
fi

results="[]"

for branch in "${branches[@]}"; do
  # Find PR number for this branch
  pr_number=$(gh pr list --head "$branch" --json number --jq '.[0].number' 2>/dev/null || echo "")

  if [[ -z "$pr_number" ]]; then
    # No PR — skip or note
    results=$(echo "$results" | jq --arg b "$branch" '. + [{"branch": $b, "pr": null, "status": "no-pr", "failing_checks": []}]')
    continue
  fi

  # Get check status
  checks_json=$(gh pr checks "$pr_number" --json name,state,bucket,link 2>/dev/null || echo "[]")

  # Extract failing checks
  failing=$(echo "$checks_json" | jq '[.[] | select(.bucket == "fail") | {name: .name, link: .link}]')
  failing_count=$(echo "$failing" | jq 'length')

  if [[ "$failing_count" -gt 0 ]]; then
    status="failing"
  else
    # Check for pending
    pending_count=$(echo "$checks_json" | jq '[.[] | select(.bucket == "pending")] | length')
    if [[ "$pending_count" -gt 0 ]]; then
      status="pending"
    else
      status="passing"
    fi
  fi

  results=$(echo "$results" | jq \
    --arg b "$branch" \
    --argjson pr "$pr_number" \
    --arg s "$status" \
    --argjson f "$failing" \
    '. + [{"branch": $b, "pr": $pr, "status": $s, "failing_checks": $f}]')
done

if [[ "$FAILING_ONLY" == true ]]; then
  echo "$results" | jq '[.[] | select(.status == "failing")]'
else
  echo "$results" | jq .
fi

# Exit 1 if any failures
has_failures=$(echo "$results" | jq 'any(.[]; .status == "failing")')
if [[ "$has_failures" == "true" ]]; then
  exit 1
fi
