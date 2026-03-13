---
name: tmux-tty
description: Route interactive/TTY commands through tmux for reliable execution and audit trail. TRIGGER when about to run a REPL (psql, irb, pry, rails console, python, node, redis-cli, mysql, sqlite3, mongosh, ipython), a command with interactive flags (--pry, --rescue, --debug), or when preferring an interactive session over piped input (e.g., psql over echo|psql). DO NOT TRIGGER for non-interactive commands.
---

# Tmux TTY — Interactive Commands via tmux

When you need to run an interactive or TTY-enabled command, route it through `tmux-agent-run` instead of running it directly via Bash. This ensures the command gets a proper TTY, avoids hanging, and leaves an audit trail the user can inspect.

## When to use this

1. **Known REPLs/interactive tools:** `psql`, `mysql`, `sqlite3`, `rails console`, `rails dbconsole`, `irb`, `pry`, `node` (no args), `python`/`python3` (no args), `ipython`, `redis-cli`, `mongosh`
2. **Interactive flags on known tools:** `--pry`, `--rescue`, `--debug` (NOT `-i` which is ambiguous — `sed -i` and `grep -i` are not interactive)
3. **Commands that prompt for input:** `ssh`, password prompts
4. **Prefer TTY version:** when running SQL queries, prefer `psql` via tmux over piping through `echo | psql` — the interactive session is richer and leaves an audit trail

## How to use

### Basic command (sentinel-based capture)

```bash
tmux-agent-run --window <tool>:<context> COMMAND...
```

The script wraps your command, sends it to a tmux window, waits for completion using a sentinel marker, and returns the output. Exit codes are propagated.

### Multi-step REPL session

Launch a REPL, then send follow-up commands to the same window:

```bash
# Launch psql and wait for the prompt
tmux-agent-run --window psql:user-balances --wait-for 'mydb[=#]>' psql -d mydb
# Send queries to the running psql session
tmux-agent-run --window psql:user-balances --wait-for 'mydb[=#]>' 'SELECT * FROM users LIMIT 5;'
tmux-agent-run --window psql:user-balances --wait-for 'mydb[=#]>' 'SELECT count(*) FROM users WHERE active = true;'
# Quit when done
tmux-agent-run --window psql:user-balances --send-only '\q'
```

### Fire and forget (no output capture)

```bash
tmux-agent-run --window redis:cache --send-only redis-cli FLUSHDB
```

### Wait for a pattern (debuggers, pry)

```bash
tmux-agent-run --window pry:auth --wait-for 'pry\(.*\)>' bundle exec pry
```

## Window naming

Format: `<tool>:<context>`

- `<tool>` = program being run (psql, pry, irb, rspec-debug, etc.)
- `<context>` = short description of what you're investigating
- Examples: `psql:users-query`, `rspec-debug:order-total-spec`, `pry:auth-middleware`
- **Always include meaningful context.** Never use just the bare tool name.

## RSpec debug flow

RSpec is normally non-interactive — run it via Bash as usual. Use tmux **only** for interactive debugging with pry-rescue.

**When to trigger:**
- User explicitly asks to debug a failing spec
- You've tried the non-interactive path and the error/backtrace doesn't reveal the root cause

**When NOT to trigger:**
- Normal `rspec` runs
- Failures with clear error messages

**Flow:**

1. Launch rspec with pry-rescue:
   ```bash
   tmux-agent-run --window rspec-debug:<spec-context> --wait-for 'pry\(.*\)>' \
     bundle exec rspec --require pry-rescue/rspec spec/path/to_failing_spec.rb
   ```

2. When the test fails, pry-rescue drops into a pry session. The `--wait-for` pattern detects the prompt and returns the pane output.

3. Interact with pry — send commands and capture output:
   ```bash
   tmux-agent-run --window rspec-debug:<spec-context> --wait-for 'pry\(.*\)>' whereami
   tmux-agent-run --window rspec-debug:<spec-context> --wait-for 'pry\(.*\)>' ls
   tmux-agent-run --window rspec-debug:<spec-context> --wait-for 'pry\(.*\)>' some_variable
   ```

4. When done, exit pry:
   ```bash
   tmux-agent-run --window rspec-debug:<spec-context> --send-only exit
   ```

## Quoting

Arguments after flags are joined with spaces and sent to the tmux shell as a single string. For commands with special characters, wrap the entire command in single quotes:

```bash
tmux-agent-run --window psql:check-users 'psql -d mydb -c "SELECT * FROM users WHERE name = '"'"'Alice'"'"'"'
```

Or use the `--` separator to be explicit about where flags end:

```bash
tmux-agent-run --window psql:check-users -- psql -d mydb -c "SELECT * FROM users"
```

## Key rules

- **Always use `tmux-agent-run`** instead of running interactive commands directly via Bash
- **Reuse windows** for related follow-up work (e.g., multiple queries against same DB)
- **Create new windows** when switching to a different tool or unrelated task
- **Never kill windows** — they are the audit trail. The user can inspect or close them
- **On timeout**, inform the user and suggest they check the tmux session (`tmux attach -t claude-agents`)
- The shared session name is `claude-agents` (default, configurable via `--session`)

## Flags reference

| Flag | Default | Description |
|------|---------|-------------|
| `--session` | `claude-agents` | Tmux session name |
| `--window` | Required | Window name in `<tool>:<context>` format |
| `--timeout` | `30` | Max seconds to wait for output |
| `--wait-for` | _(none)_ | ERE regex to wait for instead of sentinel |
| `--send-only` | _(off)_ | Send keys without waiting |
