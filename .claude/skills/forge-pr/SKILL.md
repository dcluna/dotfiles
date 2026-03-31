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

### 2. Check for plan docs

Plan docs may still exist on disk, or may have been `git rm`'d after implementation. Check both cases:

```bash
MERGE_BASE=$(git merge-base <base-branch> HEAD)

# Case 1: plan docs still exist in working tree
LIVE_PLANS=$(git diff --name-only --diff-filter=A "$MERGE_BASE" HEAD -- docs/plans/)

# Case 2: plan docs were added then deleted in this branch
# Look for files that were added (A) at some point but are now deleted (D)
DELETED_PLANS=$(git log --diff-filter=A --name-only --pretty=format: "$MERGE_BASE"..HEAD -- docs/plans/ | sort -u)
```

For **live plans**, read them directly with `cat`.

For **deleted plans**, find the last commit where each file existed and read it from that commit:

```bash
# For each deleted plan file, find the commit just before deletion
LAST_COMMIT=$(git log --diff-filter=D -1 --format="%H" -- "docs/plans/<filename>")
git show "$LAST_COMMIT^:docs/plans/<filename>"
```

If plan docs are found (live or deleted), read their contents — they contain the author's intent and should inform the PR description. Reference them in the description using permalink URLs so reviewers can find the full context even after the files are removed from the branch.

### 3. Draft the PR description

Write the PR content to a temp file. Use this structure:

```markdown
## Summary

<1-3 sentence overview of what this PR does and why>

## Plan

<If plan docs exist, link them. Use relative links for live files, or
GitHub blob permalinks for deleted files, e.g.:>
- [Plan doc title](docs/plans/filename.md)
- [Plan doc title](https://github.com/<owner>/<repo>/blob/<commit-sha>/docs/plans/filename.md) *(removed from branch)*

## Changes

<Bulleted list of notable changes, grouped logically>

## Testing

<How to test these changes, or note if tests are included>
```

Omit the Plan section if no plan docs are found. Adapt the structure to the project's PR conventions if visible in git log or existing PRs.

#### Writing style

- **Summarize, don't enumerate** — describe the intent and scope of changes rather than listing every file or line modified. Group related changes into concise bullet points.
- **Reference PRs by number** — when commit messages include PR numbers (e.g. `(#3744)`), include them in the description as `#3744` so GitHub auto-links them. Extract PR numbers from `git log` output.
- **Reference ticket numbers** — include ticket references like `[T10092]` when present in commit messages.
- **Keep it scannable** — a reviewer should understand the PR's scope in 30 seconds. Use bold for feature names, one-line bullets for smaller fixes.

### 4. Insert into the Emacs buffer

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

### 5. Do NOT submit

Never call `forge-post-submit` or any equivalent. The user reviews and submits manually.

## Key rules

- **Always review the full diff** before writing — don't guess at changes
- **Never submit the PR** — only fill in the description
- **Use a temp file** for the PR body — never pass long text as elisp string arguments
- **Ask about base branch** if it's ambiguous — don't assume `main`
- **Match project conventions** — if existing PRs follow a specific format, follow it
- **Tell the user** when the buffer has been filled so they can review it in Emacs
