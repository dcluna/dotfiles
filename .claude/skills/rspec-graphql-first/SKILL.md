---
name: rspec-graphql-first
description: Use when writing or refactoring RSpec tests in projects that may define a repo-local testing skill, especially when GraphQL helpers should be the default setup and FactoryBot should only be used on explicit user request.
---

# RSpec GraphQL First

Use this skill as the top-level coordinator when RSpec setup rules come from two places:

- a repo-local `.claude/skills/testing/SKILL.md`
- the `rspec-testing` skill from Alexey Matskevich, documented at `https://claude-plugins.dev/skills/%40AlexeyMatskevich/rspec-guide/rspec-testing`

## Priority Order

Apply instructions in this order:

1. Direct user instructions
2. Repo-local `.claude/skills/testing/SKILL.md`, if present
3. Alexey Matskevich's `rspec-testing` skill, if installed
4. The fallback DRY guidance in this wrapper skill

If these sources conflict, the higher-priority source wins.

## Default Behavior

When the current repository contains `.claude/skills/testing/SKILL.md`:

- Load and follow that skill first.
- Use its GraphQL helpers for domain-object setup by default.
- Keep its domain-specific constraints intact.
- If Alexey Matskevich's `rspec-testing` skill is installed, use it only for structure:
  - reduce duplicate setup
  - extract repeated expectations into `shared_examples` or shared contexts
  - tighten `context` hierarchy
  - remove sibling `let` and `before` duplication when that does not change setup semantics
- If that skill is not installed, apply the same DRY rules from this wrapper directly.

Do not let DRY guidance override project setup rules.

## FactoryBot Rule

Do not switch to FactoryBot for domain-object setup unless the user explicitly asks for it.

Explicit requests include instructions such as:

- "use FactoryBot"
- "write this with factories"
- "convert this spec to FactoryBot"

When the user explicitly asks for FactoryBot:

- follow that request
- use factories where appropriate
- still preserve any project-specific helpers that remain useful

## Missing Project Skill

If the current repository does not contain `.claude/skills/testing/SKILL.md`:

- continue with Alexey Matskevich's `rspec-testing` skill if installed
- otherwise continue with the fallback DRY guidance in this wrapper
- do not assume GraphQL helpers exist
- do not invent project-specific helpers
- use the project's existing test setup patterns

## Operating Rules

- Check for `.claude/skills/testing/SKILL.md` in the current repository before choosing setup patterns.
- Treat Alexey Matskevich's `rspec-testing` skill as the intended DRY-spec companion when it is installed.
- Treat GraphQL helpers as the default only when the repo-local skill exists and says to use them.
- Treat FactoryBot as opt-in for domain setup unless the user explicitly directs otherwise.
- Prefer DRYing specs by restructuring examples and extracting shared behavior, not by replacing project-specific setup conventions.
- When unsure whether a factory would violate the repo-local testing skill, stay with the helper-driven setup unless the user said otherwise.
