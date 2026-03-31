@~/.emacs.spacemacs/straight/repos/meta-agent-shell/agent-overview.md
@~/.emacs.spacemacs/straight/repos/meta-agent-shell/shared-tools.md

## Search Tool Preferences

- Always prefer `rg` over `grep` for plain-text search.
- Always prefer `rg --files` over `find` for file enumeration.
- Prefer `ast-grep` for syntax-aware searches in supported languages.
- For Rails code exploration, use `ast-grep` or `rg` first; avoid raw `grep` unless those tools are unavailable or clearly unsuitable.
- Use `ast-grep` for Rails DSL and structural queries such as `belongs_to`, `has_many`, `has_one`, `scope`, `validates`, and callback declarations.
- Use `rg` for broad text search across models, schema, migrations, configs, and docs.

## HTTP Tool Preferences

- Prefer `httpie` (`http` command) over `curl` when writing HTTP request examples or commands.
- When writing commands that involve credentials or sensitive data, always reference them via env vars — never use placeholders like `YOUR_KEY`. Example: `Bb-Api-Subscription-Key:$BB_SUBSCRIPTION_KEY` not `Bb-Api-Subscription-Key:YOUR_KEY`.
