#!/usr/bin/env bash
# Toggle or display plan-doc mode for the current worktree.
# Usage: plan-doc-mode [enforce|clean]
set -euo pipefail

ensure_worktree_config() {
  local current
  current=$(git config --get extensions.worktreeConfig 2>/dev/null || true)
  if [ "$current" != "true" ]; then
    git config extensions.worktreeConfig true
  fi
}

MODE="${1:-}"

if [ -z "$MODE" ]; then
  current=$(git config plan-doc.mode 2>/dev/null || echo "enforce")
  echo "plan-doc mode: $current"
  exit 0
fi

case "$MODE" in
  enforce|clean)
    ensure_worktree_config
    git config --worktree plan-doc.mode "$MODE"
    echo "plan-doc mode set to: $MODE"
    ;;
  *)
    echo "Usage: plan-doc-mode [enforce|clean]"
    echo "  enforce  — require plan docs exist (default)"
    echo "  clean    — require plan docs are removed from git"
    exit 1
    ;;
esac
