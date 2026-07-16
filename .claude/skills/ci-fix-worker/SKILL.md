---
name: ci-fix-worker
description: Investigate and fix a CircleCI failure for a single branch. Designed to run as a subagent (Claude Code or Emacs agent-shell) in an isolated worktree. Use when dispatched by ci-fix-stack or when manually fixing a single branch's CI.
---

# CI Fix Worker

Investigate and fix CI failures for a single branch. Runs in a worktree or on a checked-out branch.

## Required Context

You must be given:
- **branch**: the git branch name
- **pr**: the PR number (optional but helpful)
- **failing_checks**: list of failing check names and links

## Workflow

### 1. Get failure details

Use CircleCI MCP tools if available:

```
get_build_failure_logs for the project, targeting this branch's latest pipeline
```

Or fetch from the check link URLs provided. Or use `gh pr checks <pr> --json name,state,link` and follow links.

### 2. Identify failure type

Categorize each failure:

| Type | Signal | Approach |
|------|--------|----------|
| **Test failure** | RSpec/Jest/etc output with file:line | Read test + impl, find root cause |
| **Lint/style** | Rubocop/ESLint violations | Auto-fix with `rubocop -A` or `eslint --fix` |
| **Type error** | TypeScript/Sorbet errors | Read error, fix type annotation |
| **Build failure** | Compilation error, missing dep | Read error, fix import/dep |
| **Flaky/infra** | Timeout, connection refused | Note as infra — can't fix from code |

### 3. Investigate root cause

For test failures:
1. Read the failing test file
2. Read the implementation being tested
3. Check `git log --oneline -5` on relevant files — what changed recently?
4. Run the failing test locally if possible

For lint:
1. Run the linter locally with auto-fix
2. Review what changed

### 4. Fix

Apply the fix. Keep changes minimal — fix CI, nothing else.

For test failures where the test is wrong (testing old behavior), fix the test.
For test failures where the implementation is wrong, fix the implementation.
For lint, auto-fix then review.

### 5. Verify locally

Run the specific failing test/check locally:

```bash
bundle exec rspec spec/path/to/failing_spec.rb  # Ruby
npx jest path/to/failing.test.ts                 # JS/TS
bundle exec rubocop --only Style/Whatever file   # Rubocop
```

### 6. Commit and push

```bash
git add -p  # stage only relevant changes
git commit -m "fix(ci): <description of what was wrong>

Failing check: <check name>
PR: #<number>"
git push
```

### 7. Report back

Summarize:
- What failed
- Root cause
- What was fixed
- Whether local verification passed

If you can't fix it (flaky, infra, needs human judgment), report that clearly:

```
NEEDS-HUMAN: branch feature-x, PR #123
  - ci/integration-tests: Flaky timeout on external API call
  - Couldn't reproduce locally, likely infra/timing issue
```

## Integration with existing skills

- Use **diagnose-test-failures** for complex test failures (but skip the "wait for human approval" gate — you ARE the autonomous worker)
- Use **bisect-failure** if you have JUnit XML and suspect order-dependent failures
- Use **systematic-debugging** for hard-to-trace failures

## Constraints

- Fix CI failures only. Don't refactor, don't clean up, don't improve.
- If unsure whether test or implementation is wrong, prefer fixing the test (safer for stacked PRs).
- Don't rebase or merge other branches — just fix what's broken on this branch.
