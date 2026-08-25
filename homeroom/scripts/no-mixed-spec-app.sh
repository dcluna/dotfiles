#!/usr/bin/env bash
set -euo pipefail

staged=$(git diff --cached --name-only --diff-filter=ACM -- '*.rb')

if [ -z "$staged" ]; then
  exit 0
fi

has_spec=$(echo "$staged" | grep -E '(^spec/|_spec\.rb$)' || true)
has_app=$(echo "$staged" | grep -vE '(^spec/|_spec\.rb$)' | grep -v '^$' || true)

if [ -n "$has_spec" ] && [ -n "$has_app" ]; then
  echo "Spec and app files mixed in same commit."
  echo ""
  echo "Spec files:"
  echo "$has_spec" | sed 's/^/  /'
  echo ""
  echo "App files:"
  echo "$has_app" | sed 's/^/  /'
  echo ""
  echo "Commit them separately."
  exit 1
fi
