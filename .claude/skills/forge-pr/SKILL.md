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

### 3. Search for Flipper flags

**This step is mandatory.** Scan the diff for any Flipper feature flag references:

```bash
# Search the diff for Flipper usage patterns
git diff <base-branch>...HEAD | rg -i 'Flipper(\[|\.enabled\?|\.enable|\.disable|\.add|\.remove|\.exist)'
```

Also search for flag symbols/strings referenced in the diff:

```bash
# Get changed Ruby files and search them for Flipper patterns
git diff --name-only <base-branch>...HEAD -- '*.rb' | xargs rg 'Flipper' 2>/dev/null
```

If **any Flipper flags are found**, you MUST include a `## Flipper Flags` section in the PR description (see template below). For each flag, document:

1. **Flag name** — the symbol/string (e.g., `:enable_new_billing`)
2. **Purpose** — what problem it solves or what behavior it gates
3. **Scope** — what resource(s) it's scoped to (e.g., `Actor(Site)`, `Actor(User)`, `Group(:beta_testers)`, percentage, or boolean/global)

To determine scope, look at:
- `Flipper.enabled?(:flag, resource)` — the second argument is the actor
- `Flipper[:flag].enable_actor(resource)` — actor enablement
- `Flipper[:flag].enable_group(:name)` — group enablement
- `Flipper[:flag].enable_percentage_of_actors(n)` — percentage
- `Flipper[:flag].enable` with no args — global/boolean

If scope is unclear from the diff, check model methods that wrap the flag (e.g., `site.some_flag?`) and trace the `Flipper.enabled?` call.

If **no Flipper flags are found**, omit the section entirely — do not add an empty one.

### 4. Draft the PR description

Write the PR content to a temp file. Use this structure:

```markdown
## Summary

<1-3 sentence overview of what this PR does and why>

## Architecture / Flow

<ASCII diagram showing the main flows, data paths, or component relationships
introduced or modified by this PR. Use box-drawing characters or simple ASCII art.
Focus on how the pieces connect — not every file, just the key abstractions.>

Example styles (pick whichever fits):

  Component diagram:
    ┌──────────┐     ┌───────────┐     ┌──────────┐
    │ Frontend  │────▶│ API Layer │────▶│ Database  │
    └──────────┘     └───────────┘     └──────────┘

  Flow diagram:
    User request
        │
        ▼
    Auth middleware ──▶ reject 401
        │
        ▼
    Route handler ──▶ response

  Layered:
    ┌─────────────────────────────┐
    │       Public API            │
    ├─────────────────────────────┤
    │    Service Layer            │
    ├─────────────────────────────┤
    │    Data Access              │
    └─────────────────────────────┘

Keep diagrams compact (under 20 lines). Show relationships and data flow,
not just boxes with file names — the diagram should convey something the
bulleted Changes list cannot.

Omit this section ONLY for trivial PRs (single-file typo fix, config bump,
dependency update with no architectural change). If the PR touches 3+ files
or introduces new components, include a diagram.

## Plan

<If plan docs exist, link them. Use relative links for live files, or
GitHub blob permalinks for deleted files, e.g.:>
- [Plan doc title](docs/plans/filename.md)
- [Plan doc title](https://github.com/<owner>/<repo>/blob/<commit-sha>/docs/plans/filename.md) *(removed from branch)*

## Changes

<Group related changes under bold topic headers. Each header names
a logical component or area of change, followed by bullet points
with specifics. Example:

**Auth middleware**
- Replaced session-token storage with encrypted JWT
- Added rate limiting on `/login` endpoint

**User model**
- New `verified_at` timestamp column with migration
- `verified?` / `pending?` scopes

For small PRs (1-2 logical groups), a flat list with bold leads is fine.
For larger PRs, always use the header-then-bullets structure.>

## Flipper Flags

<MANDATORY if any Flipper flags are introduced or modified in this PR.
Omit only if the PR contains zero Flipper flag references.>

| Flag | Purpose | Scope |
|------|---------|-------|
| `:flag_name` | What behavior this gates and why | `Actor(Site)` / `Actor(User)` / `Group(:name)` / `Boolean` / `% of actors` |

<Add a sentence per flag if the table row is too terse to explain the
rollout plan or migration path.>

## Testing

<How to test these changes, or note if tests are included>
```

Omit the Plan section if no plan docs are found. Omit the Architecture / Flow section only for trivial PRs (single-file typo, config bump). The Flipper Flags section is **mandatory** whenever the diff touches Flipper — never skip it. Adapt the structure to the project's PR conventions if visible in git log or existing PRs.

#### Writing style

- **Summarize, don't enumerate** — describe the intent and scope of changes rather than listing every file or line modified.
- **Group under topic headers** — use standalone **bold headers** (not bold-within-bullet) to name each logical component, then bullet the specifics underneath. Do NOT flatten everything into a single-level bullet list with bold leads — that becomes a wall of text on larger PRs.
- **Reference PRs by number** — when commit messages include PR numbers (e.g. `(#3744)`), include them in the description as `#3744` so GitHub auto-links them. Extract PR numbers from `git log` output.
- **Reference ticket numbers** — include ticket references like `[T10092]` when present in commit messages.
- **Keep it scannable** — a reviewer should understand the PR's scope in 30 seconds. Use bold for feature names, one-line bullets for smaller fixes.

### 5. Insert into the Emacs buffer

Write the description to a temp file first (avoids quoting issues):

```bash
cat > /tmp/claude-forge-pr-body.md << 'PREOF'
<PR description here>
PREOF
```

#### New PRs (`new-pullreq` buffer)

The buffer typically has a title line at the top followed by an empty area for the description. Insert directly:

```bash
emacsclient --eval '
(with-current-buffer "new-pullreq"
  (goto-char (point-max))
  (insert (with-temp-buffer
            (insert-file-contents "/tmp/claude-forge-pr-body.md")
            (buffer-string))))'
```

#### Existing PRs (any buffer that is NOT `new-pullreq`)

When editing an existing PR, the buffer already contains a description. **Show a merge diff** so the user can merge changes per-region. If the PR buffer is empty, fall back to direct insert.

Uses `ediff-merge-buffers-writeback` from `ediff-merge-utils.el` — this function runs `ediff-merge-buffers-with-ancestor` and writes the merge result back to the ancestor buffer on quit, but only if all conflicts are resolved.

```bash
emacsclient --eval '
(require (quote ediff-merge-utils))
(let* ((pr-buf-name "<buffer-name>")
       (pr-buf (get-buffer pr-buf-name))
       (old-content (with-current-buffer pr-buf (buffer-string))))
  (if (string-empty-p (string-trim old-content))
      ;; PR buffer empty — insert directly, no diff needed
      (with-current-buffer pr-buf
        (goto-char (point-max))
        (insert (with-temp-buffer
                  (insert-file-contents "/tmp/claude-forge-pr-body.md")
                  (buffer-string))))
    ;; PR buffer has content — 3-way merge
    ;; Kill stale temp buffers from previous runs
    (when (get-buffer "*forge-pr-old*") (kill-buffer "*forge-pr-old*"))
    (when (get-buffer "*forge-pr-new*") (kill-buffer "*forge-pr-new*"))
    (let ((old-buf (generate-new-buffer "*forge-pr-old*"))
          (new-buf (generate-new-buffer "*forge-pr-new*")))
      ;; A = current PR description (snapshot)
      (with-current-buffer old-buf
        (insert old-content)
        (markdown-mode))
      ;; B = proposed new description
      (with-current-buffer new-buf
        (insert-file-contents "/tmp/claude-forge-pr-body.md")
        (markdown-mode))
      ;; Merge A+B with PR buffer as ancestor and writeback target
      (ediff-merge-buffers-writeback old-buf new-buf pr-buf))))'
```

How this works:
- `ediff-merge-buffers-with-ancestor` shows A (old) and B (new) with a merge buffer C
- PR buffer is the ancestor — ediff uses it for 3-way diff context
- User picks `a`/`b` per region, or edits C directly — fully reversible
- **AUTOMATIC WRITEBACK**: on quit (`q`), `ediff-merge-buffers-writeback` automatically writes the merge result into the PR buffer if all conflicts are resolved. No manual copying needed.
- If unresolved conflicts remain, PR buffer is left untouched and user is warned.

After ediff launches, tell the user **exactly this** (do NOT mention manual copying — writeback is automatic):
- **A** = current description, **B** = proposed new, **C** = merge result
- Use `a`/`b` per region to pick old or new, or edit C directly
- **Quit** (`q`) — merge result is **automatically written** to the PR buffer (no manual copy needed)
- Unresolved conflicts → PR buffer unchanged, user warned

**IMPORTANT**: Never tell the user to manually copy content from the merge buffer. The `ediff-merge-buffers-writeback` function handles this automatically on quit.

### 6. Do NOT submit

Never call `forge-post-submit` or any equivalent. The user reviews and submits manually.

## Key rules

- **Always review the full diff** before writing — don't guess at changes
- **Never submit the PR** — only fill in the description
- **Use a temp file** for the PR body — never pass long text as elisp string arguments
- **Ask about base branch** if it's ambiguous — don't assume `main`
- **Match project conventions** — if existing PRs follow a specific format, follow it
- **Tell the user** when the buffer has been filled so they can review it in Emacs
