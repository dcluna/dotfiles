@~/.emacs.spacemacs/straight/repos/meta-agent-shell/agent-overview.md
@~/.emacs.spacemacs/straight/repos/meta-agent-shell/shared-tools.md

## Search Tool Preferences

- Always prefer `rg` over `grep` for plain-text search.
- Always prefer `rg --files` over `find` for file enumeration.
- Prefer `ast-grep` for syntax-aware searches in supported languages.
- For Rails code exploration, use `ast-grep` or `rg` first; avoid raw `grep` unless those tools are unavailable or clearly unsuitable.
- Use `ast-grep` for Rails DSL and structural queries such as `belongs_to`, `has_many`, `has_one`, `scope`, `validates`, and callback declarations.
- Use `rg` for broad text search across models, schema, migrations, configs, and docs.

### ast-grep for React/TypeScript projects

- Use `--lang tsx` for both `.tsx` and `.jsx` files (ast-grep's TSX parser handles JSX).
- Use `--lang typescript` for plain `.ts` files.
- Common React patterns:

```bash
# Find all useState calls
ast-grep run --pattern 'useState($INIT)' --lang tsx path/to/src/

# Find useEffect with dependencies
ast-grep run --pattern 'useEffect($CALLBACK, [$$$DEPS])' --lang tsx path/to/src/

# Find useEffect with NO dependency array (runs every render)
ast-grep run --pattern 'useEffect($CALLBACK)' --lang tsx path/to/src/

# Find specific hook usage
ast-grep run --pattern 'useQuery($$$ARGS)' --lang tsx path/to/src/
ast-grep run --pattern 'useMutation($$$ARGS)' --lang tsx path/to/src/

# Find JSX self-closing elements
ast-grep run --pattern '<$TAG $$$ATTRS />' --lang tsx path/to/src/

# Find component definitions (function declarations)
ast-grep run --pattern 'function $NAME($$$PARAMS): $RET { $$$BODY }' --lang tsx path/to/src/

# Find arrow function components with React.FC
ast-grep run --pattern 'const $NAME: React.FC<$PROPS> = $$$BODY' --lang tsx path/to/src/

# Find imports from a specific package
ast-grep run --pattern 'import $$$IMPORTS from "react-router"' --lang tsx path/to/src/

# Find styled-components definitions
ast-grep run --pattern 'styled.$TAG`$$$CSS`' --lang tsx path/to/src/

# Find inline style objects (potential performance issue)
ast-grep run --pattern '<$TAG style={{$$$STYLES}} $$$REST>' --lang tsx path/to/src/
```

- Use `$$$` (multi-matcher) for variable-length argument lists, children, or attributes.
- Use `$NAME` (single-matcher) for a single node (identifier, expression, etc.).
- Prefer ast-grep over `rg` when searching for structural patterns (component props, hook arguments, JSX nesting) where regex would be fragile.

## Commit Discipline

- Commit your work proactively in logical chunks as you go — do not wait for the user to ask.
- Each commit should be a single coherent change: one feature, one fix, one refactor, one migration — not a grab bag of unrelated edits.
- If a task naturally breaks into multiple logical steps (e.g., add model, add controller, add tests), commit after each step rather than bundling them into one commit at the end.
- Write commit messages that explain **why**, not just what changed.
- Never combine unrelated changes in a single commit just because they happened in the same session.

## HTTP Tool Preferences

- Prefer `httpie` (`http` command) over `curl` when writing HTTP request examples or commands.
- When writing commands that involve credentials or sensitive data, always reference them via env vars — never use placeholders like `YOUR_KEY`. Example: `Bb-Api-Subscription-Key:$BB_SUBSCRIPTION_KEY` not `Bb-Api-Subscription-Key:YOUR_KEY`.

## Agent skills

### Issue tracker

Issues tracked as local markdown files under `.scratch/`. See `docs/agents/issue-tracker.md`.

### Triage labels

Default label vocabulary (needs-triage, needs-info, ready-for-agent, ready-for-human, wontfix). See `docs/agents/triage-labels.md`.

### Domain docs

Single-context layout — `CONTEXT.md` + `docs/adr/` at repo root (created lazily). See `docs/agents/domain.md`.

# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, invoke the Skill tool with `skill: "graphify"` before doing anything else.
