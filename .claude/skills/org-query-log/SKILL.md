---
name: org-query-log
description: Log SQL queries to org-babel-compatible org files via emacsclient. TRIGGER when writing or executing any SQL query. DO NOT TRIGGER for non-SQL code.
---

# Org Query Log

When you write or execute a SQL query, log it to an org-babel-compatible org file so the user can review and re-run it in Emacs.

## Prerequisites

The user's Emacs must be running with `emacsclient` available. The following elisp functions must be loaded (defined in the Claude Query Log section of `spacemacs.org`, tangled to `spacemacs-user-config.el`):

- `dcl/claude-query-log-enabled` — defvar, check before logging
- `dcl/claude-query-log-setup` — interactive setup (prompts user)
- `dcl/claude-query-log-current` — returns cached session config
- `dcl/claude-query-log-append` — appends a query block
- `dcl/claude-query-log-append-with-results` — appends a query block with results

## When to trigger

Any time you write a SQL query in conversation — whether or not you execute it.

## Flow

### First query in a conversation

1. Check if logging is enabled:
   ```bash
   emacsclient --eval 'dcl/claude-query-log-enabled'
   ```
   If this returns `nil`, skip logging silently for the rest of the conversation.

2. If enabled, ask the user: **"Want me to log queries to an org file?"**

3. If yes, call setup:
   ```bash
   emacsclient --eval '(dcl/claude-query-log-setup)'
   ```
   This prompts the user in Emacs for a topic and connection. If it returns a file path, setup succeeded. If it errors (user cancelled with C-g), note this and retry on the next query.

4. If the user says no, skip logging for the conversation. If they later ask to start logging, call setup.

### Every query (after setup succeeds)

1. Check if logging is still enabled:
   ```bash
   emacsclient --eval 'dcl/claude-query-log-enabled'
   ```
   If `nil`, skip logging silently. The user may have toggled it mid-session.

2. Write the SQL body to a temp file:
   ```bash
   # Write to /tmp/claude-query-<query_name>.sql
   ```

3. Call append via emacsclient:
   ```bash
   emacsclient --eval '(dcl/claude-query-log-append "query_name" "Brief description of what the query does." "/tmp/claude-query-query_name.sql")'
   ```

4. If you also executed the query and have results, format them as an org table, write to a temp file, and use `append-with-results` instead:
   ```bash
   emacsclient --eval '(dcl/claude-query-log-append-with-results "query_name" "Description." "/tmp/claude-query-query_name.sql" "/tmp/claude-query-query_name-results.org")'
   ```

### If setup previously failed (cancelled)

Say "Let me try setting up the query log again" and retry `dcl/claude-query-log-setup`. If it fails again, write the query in conversation without logging and retry next time.

## Arguments

- **query_name**: snake_case identifier derived from the query's purpose (e.g., `waitlisted_without_site_student`)
- **description**: one-sentence natural language explanation
- **SQL body**: written to temp file, never passed as a string argument (avoids quoting issues)
- **results**: org table written to temp file

## Org table formatting for results

When you have query results to include, format them as an org table:

```
| column1 | column2 |
|---------+---------|
| value1  | value2  |
| value3  | value4  |
```

## Important

- **Never read connection credentials.** You only need connection names, not passwords or hostnames.
- **Do not prompt repeatedly.** Ask about logging once per conversation. After setup, log silently.
- **Retry on cancel.** A cancelled Emacs prompt is assumed accidental. Retry on the next query.
- **The only way to disable logging** is `(setq dcl/claude-query-log-enabled nil)`.
