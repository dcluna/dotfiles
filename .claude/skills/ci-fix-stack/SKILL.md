---
name: ci-fix-stack
description: Find failing CircleCI runs across a stack of PRs and dispatch subagents to investigate and fix each. Use when user says "fix CI for my stack", "check CI across branches", or wants to automate fixing failures across stacked PRs.
---

# CI Fix Stack

Fan out CI failure investigation across a stack of branches. Each failing branch gets its own subagent working in an isolated worktree.

## When to Use

- User has stacked PRs with CI failures
- User wants to fix CI across multiple branches at once
- User says "fix CI for my stack" or "check my stack"

## Workflow

### 1. Identify failing branches

Run the ci-check-stack script:

```bash
~/ghq/github.com/dcluna/dotfiles/homeroom/scripts/ci-check-stack.sh --failing-only base..tip
```

Or with explicit branches:

```bash
~/ghq/github.com/dcluna/dotfiles/homeroom/scripts/ci-check-stack.sh --failing-only branch1 branch2 branch3
```

Parse the JSON output. Each entry has `{branch, pr, status, failing_checks: [{name, link}]}`.

### 2. Present summary to user

Before dispatching, show:

```
## CI Stack Status

| Branch | PR | Failing Checks |
|--------|-----|----------------|
| feature-a | #123 | ci/test, ci/lint |
| feature-b | #456 | ci/test |

Dispatch agents to fix these? (emacs subagents / claude subagents / manual)
```

Wait for user approval.

### 3a. Dispatch via Emacs subagents

For each failing branch, use `agent-shell-spawn`:

```bash
agent-shell-spawn "CI-Fix-${branch}" "You are fixing CI failures on branch '${branch}' (PR #${pr}).

Failing checks: ${failing_checks}

Steps:
1. cd to the project repo and checkout branch '${branch}'
2. Use the CircleCI MCP tools (get_build_failure_logs) or gh pr checks to get failure details
3. Read the failure logs and identify root causes
4. Fix the issues
5. Run the failing tests locally to verify
6. Commit the fix with a descriptive message
7. Push the fix

Reply with results using: agent-shell-send \"$(agent-shell-whoami)\" \"DONE: ${branch} - <summary>\""
```

Follow the dispatching-emacs-subagents skill protocol: verify delivery after 15-20s, re-send on failure, monitor every 30-60s.

### 3b. Dispatch via Claude Code subagents

For each failing branch, use the Agent tool with `isolation: "worktree"`:

```
Use the Agent tool with:
  - subagent_type: "general-purpose"
  - isolation: "worktree"
  - prompt: the ci-fix-worker skill instructions (see below)
```

The prompt should include:
- Branch name and PR number
- List of failing check names and links
- Instruction to invoke the `ci-fix-worker` skill
- The project repo path

### 4. Collect results

After all agents complete, synthesize:

```
## CI Fix Results

| Branch | PR | Status | Summary |
|--------|-----|--------|---------|
| feature-a | #123 | Fixed | Missing import in test_helper |
| feature-b | #456 | Needs human | Flaky integration test, couldn't reproduce |
```

### 5. Stack hygiene

If fixes were committed on child branches, remind user to rebase dependents:

> Fixes committed on feature-a. Branches stacked on top (feature-b, feature-c) may need rebase.

## Notes

- The script uses `gh pr checks` which shows the latest check run per PR
- CircleCI MCP `get_build_failure_logs` can get detailed logs if `gh` output insufficient
- Each subagent works independently — no coordination needed between them
- Worktree isolation prevents branch conflicts
