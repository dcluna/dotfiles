---
name: review-digest
description: Summarize GitHub PR review comments into themed groups with ranked fix options. Use when user wants to understand PR feedback, triage code review comments, or decide how to address reviewer requests. Trigger on PR URLs or "review digest".
---

# Review Digest

Summarize PR code review comments, group by theme, and present fix options. **Do not write any code until the user explicitly asks.**

## Input

User provides a GitHub PR URL (e.g., `https://github.com/org/repo/pull/123`).

## Workflow

### 1. Fetch PR data

```bash
# Get all review comments (inline + general)
gh pr view <number> --repo <owner/repo> --json reviews,comments,title,body
gh api repos/<owner/repo>/pulls/<number>/comments
gh api repos/<owner/repo>/pulls/<number>/reviews
```

Extract from the PR URL:
- `owner/repo` from the domain path
- PR number from the trailing segment

### 2. Classify comments

For each comment, determine:
- **Status**: resolved vs unresolved (use `gh api` to check if inline comments are resolved/outdated)
- **Theme**: group into categories like naming, performance, logic, style, security, testing, architecture, documentation, error-handling, readability
- A comment can belong to multiple themes — pick the primary one

### 3. Present summary

Output format:

```
## PR #123: <title>

### <Theme> (N comments, M unresolved)

**[file:line] <one-line summary>** — @reviewer
> Original comment quoted briefly

Status: unresolved | resolved | outdated

<2-3 sentence explanation of what the reviewer wants and why>

Fix options:
A. <quick approach> — tradeoff: <what you gain/lose>
B. <thorough approach> — tradeoff: <what you gain/lose>
C. <alternative> — tradeoff: <what you gain/lose>

---
(repeat per comment in theme)
```

Rules for the summary:
- Unresolved comments get full treatment (explanation + fix options)
- Resolved comments get one-line summary only, grouped at the end of their theme
- If a resolved comment looks like it was addressed poorly (e.g., reviewer approved but the diff doesn't match the ask), flag it with `[needs-review]`

### 4. Ask the user

After presenting the summary, ask:

> Which comments need attention? You can:
> - Pick specific comments to fix (e.g., "fix A2, B1")
> - Say "fix all unresolved"
> - Ask me to explain any comment further
> - Disagree with a reviewer and draft a reply

### 5. When user says to fix

Only then write code. For each selected comment:
1. Read the relevant file(s)
2. Apply the fix option the user chose (or ask which option if not specified)
3. Show the diff before committing
4. Commit with message referencing the review comment

## Edge cases

- **No comments**: Report "No review comments on this PR" and exit
- **All resolved**: Show one-line summaries, ask if any look under-addressed
- **Stale diff**: If comment references lines that no longer exist, note this and suggest manual review
