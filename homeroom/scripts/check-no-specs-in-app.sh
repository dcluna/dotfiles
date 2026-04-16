#!/usr/bin/env bash
# Checks for _spec.rb files under app/ - these belong in spec/, not app/
set -euo pipefail

# Use git root if in a git repo, otherwise current directory
if git rev-parse --show-toplevel &>/dev/null; then
  root="$(git rev-parse --show-toplevel)"
else
  root="."
fi

app_dir="$root/app"

if [ ! -d "$app_dir" ]; then
  # No app/ directory, nothing to check
  exit 0
fi

# SPECS_IN_APP_IGNORE: colon-separated list of paths (relative to repo root) to ignore
# e.g. SPECS_IN_APP_IGNORE="app/models/legacy_spec.rb:app/services/old_spec.rb"
IFS=':' read -ra ignore_list <<< "${SPECS_IN_APP_IGNORE:-}"

spec_files=$(find "$app_dir" -name '*_spec.rb' -type f 2>/dev/null || true)

# Filter out ignored files
if [ ${#ignore_list[@]} -gt 0 ]; then
  for ignore in "${ignore_list[@]}"; do
    [ -z "$ignore" ] && continue
    spec_files=$(echo "$spec_files" | grep -vF "$root/$ignore" || true)
  done
fi

if [ -n "$spec_files" ]; then
  echo "ERROR: Found _spec.rb files under app/ - these should be in spec/ instead:"
  echo "$spec_files" | sed "s|^$root/||"
  exit 1
fi

exit 0
