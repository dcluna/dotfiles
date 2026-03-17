---
name: forge-pr
description: Write or update PR descriptions in Emacs Forge buffers. TRIGGER when user mentions writing a PR, filling in a PR description, Forge, new-pullreq buffer, or editing a pull request in Emacs. DO NOT TRIGGER for GitHub CLI PR operations or non-Emacs PR workflows.
---

# Forge PR — Write Pull Request Descriptions via Emacs

When the user wants to create or update a pull request description using Emacs Forge, use this skill to review the branch changes and fill in the PR buffer.

## When to trigger

- User mentions a `new-pullreq` buffer or a PR number buffer in Emacs
- User asks you to write/fill in a PR description for Forge
- User mentions creating or editing a PR in Emacs/Forge

## Required information

Before starting, determine:

1. **Buffer name**: The Emacs buffer where the PR is open (e.g., `new-pullreq` for new PRs, or a PR number like `#123` for edits). Ask the user if not provided.
2. **Base branch**: The branch to compare against (e.g., `develop`, `main`, `master`). Ask the user if not obvious from context — check the repo's default branch or most recent target.

## Flow

### 1. Gather the diff

```bash
# Get the base branch (ask user if unclear)
git log --oneline <base-branch>..HEAD
git diff <base-branch>...HEAD --stat
git diff <base-branch>...HEAD
```

Review the commits and diff to understand what changed and why.

### 2. Draft the PR description

Write the PR content to a temp file. Use this structure:

```markdown
## Summary

<1-3 sentence overview of what this PR does and why>

## Changes

<Bulleted list of notable changes, grouped logically>

## Testing

<How to test these changes, or note if tests are included>
```

Adapt the structure to the project's PR conventions if visible in git log or existing PRs. Keep it concise but informative.

### 3. Insert into the Emacs buffer

Write the description to a temp file, then use `emacsclient` to insert it into the Forge buffer:

```bash
# Write PR body to temp file (avoids quoting issues)
cat > /tmp/claude-forge-pr-body.md << 'PREOF'
<PR description here>
PREOF

# Insert into the Forge buffer
emacsclient --eval '
(with-current-buffer "<buffer-name>"
  (goto-char (point-max))
  (insert (with-temp-buffer
            (insert-file-contents "/tmp/claude-forge-pr-body.md")
            (buffer-string))))'
```

For **new PRs** (`new-pullreq` buffer): The buffer typically has a title line at the top followed by an empty area for the description. Position the cursor after any existing content and insert.

For **existing PRs** (editing): The buffer contains the current description. Replace or append as appropriate based on user instructions.

### 4. Do NOT submit

Never call `forge-post-submit` or any equivalent. The user reviews and submits manually.

## Key rules

- **Always review the full diff** before writing — don't guess at changes
- **Never submit the PR** — only fill in the description
- **Use a temp file** for the PR body — never pass long text as elisp string arguments
- **Ask about base branch** if it's ambiguous — don't assume `main`
- **Match project conventions** — if existing PRs follow a specific format, follow it
- **Tell the user** when the buffer has been filled so they can review it in Emacs
