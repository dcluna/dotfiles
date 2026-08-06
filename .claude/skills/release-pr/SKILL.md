---
name: release-pr
description: Write release PR descriptions that summarize merged PRs and commits. Use when creating a release PR, merging develop/staging into master/main, or writing a release changelog. TRIGGER when user mentions release PR, release branch, release notes, or deploying a batch of PRs.
---

# Release PR — Summarize a Release Branch

Generate a release PR description listing all PRs and commits being merged, with a summary of changes.

## When to trigger

- User asks to write a release PR description
- User is merging a release/staging/develop branch into master/main
- User mentions summarizing what's in a release

## Required information

1. **Release branch or worktree path** — where the release code lives
2. **Base branch** — what it's being merged into (usually `origin/master` or `origin/main`). Ask if unclear.

## Flow

### 1. Gather commits

```bash
cd <release-path>
git log --oneline <base-branch>..HEAD
```

### 2. Identify PRs

Extract PR numbers from commit messages (merge commits and squash-merge references like `(#1234)`):

```bash
# Merge commits
git log --oneline --merges <base-branch>..HEAD

# Squash-merge PR references in non-merge commits
git log --oneline --no-merges <base-branch>..HEAD | rg '#\d+'
```

For each PR number found, fetch its title and URL:

```bash
gh pr view <number> --json title,url,author --jq '"\(.url) \(.title) (@\(.author.login))"'
```

### 3. Match orphan commits to PRs

Commits without a PR reference are "orphans." Try to match them:

1. **Check if commit is part of a PR's merge** — look at parent merge commits in the log. If the commit sits between two merge commits, it likely belongs to the earlier merge PR.
2. **Search by commit message keywords** — use `gh pr list --search "<keywords>" --state merged` to find matching PRs.
3. **Search by branch name** — if the commit message has a conventional prefix (e.g., `fix(gq2):`), search for PRs from branches containing that prefix.

If a match is found, group the commit under that PR. If not, keep it as an orphan for detailed description.

### 4. Draft the PR description

Use this template:

```markdown
## Summary

Release <date> — <N> PRs, <M> additional commits.

<1-2 sentence high-level overview of the release themes.>

## PRs Included

| PR | Title | Author |
|----|-------|--------|
| #1234 | Feature description | @author |
| #5678 | Bug fix description | @author |

## Changes

<Group changes by theme/area under bold headers.
For changes with a matching PR, keep the summary brief (1 line) and reference the PR number.
For orphan commits without a PR, provide a more detailed explanation of what changed and why.>

**Area Name**
- Brief change summary (#1234)
- Detailed explanation of orphan commit changes — what was modified, why, and any context from the commit message

## Commits

<details>
<summary>Full commit list (<N> commits)</summary>

| SHA | Message |
|-----|---------|
| abc1234 | commit message |

</details>

## Testing

<Note any testing considerations for the release.>
```

#### Writing style

- **PRs get brief summaries** — the PR itself has the details, just reference it.
- **Orphan commits get detailed summaries** — no PR to link to, so explain the change inline.
- **Group by theme** — cluster related PRs and commits under area headers (e.g., "Veracross Integration", "GQ2 Aggregates", "Infrastructure").
- **Reference PR numbers** as `#1234` so GitHub auto-links them.
- **Collapsible commit list** — full list in `<details>` to keep the description scannable.

### 5. Output

Write the description to `/tmp/claude-release-pr-body.md`.

If the user has a Forge buffer open, insert it using the same mechanism as forge-pr (temp file + emacsclient). Otherwise, print it to the conversation for review.

## Key rules

- **Always review the full commit log** before writing
- **Try hard to find matching PRs** — orphan commits should be the exception
- **Never submit the PR** — only produce the description
- **Date in summary** — use the release date from the branch name or current date
