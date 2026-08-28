---
name: magit-commit
description: Commit staged changes through Emacs Magit via emacsclient. Writes commit message into COMMIT_EDITMSG buffer, opening it via magit-commit-create if needed. Use when user asks to commit, wants to fill a commit message in Magit, or mentions COMMIT_EDITMSG buffer.
---

# Magit Commit — Commit via Emacs/Magit

Automate writing commit messages into Magit's commit buffer using emacsclient.

## Worktree-aware buffer lookup

**Critical:** In worktree setups, multiple COMMIT_EDITMSG buffers may exist simultaneously. Never use `magit-commit-message-buffer` — it returns the first match, which may belong to a different worktree. Always resolve via the file path for the current git dir.

### Resolve the COMMIT_EDITMSG path

```bash
COMMIT_EDITMSG_PATH="$(git rev-parse --git-dir)/COMMIT_EDITMSG"
```

This returns the correct path per worktree, e.g.:
- Main repo: `.git/COMMIT_EDITMSG`
- Worktree: `.git/worktrees/<name>/COMMIT_EDITMSG`

### Find the buffer visiting that path

```elisp
(get-file-buffer "<COMMIT_EDITMSG_PATH>")
```

## Flow

### 1. Draft the commit message

Analyze staged changes and recent log to draft a message:

```bash
git diff --cached --stat
git diff --cached
git log --oneline -10
```

Write to temp file (avoids elisp quoting issues). **Use a worktree-unique temp file** to avoid races between concurrent agents:

```bash
WORKTREE_ID=$(basename "$(git rev-parse --show-toplevel)")
cat > "/tmp/claude-magit-commit-msg-${WORKTREE_ID}.txt" << 'COMMITEOF'
<commit message here>
COMMITEOF
```

### 2. Check for existing COMMIT_EDITMSG buffer

```bash
COMMIT_EDITMSG_PATH="$(git rev-parse --git-dir)/COMMIT_EDITMSG"
emacsclient --eval "(get-file-buffer \"${COMMIT_EDITMSG_PATH}\")"
```

- Returns a buffer object → buffer exists, go to **step 4**
- Returns `nil` → no buffer, go to **step 3**

### 3. Open the commit buffer via Magit

Stage files first if needed. Set `default-directory` to the worktree root so Magit targets the right repo:

```bash
WORKTREE_ROOT="$(git rev-parse --show-toplevel)"
emacsclient --eval "(let ((default-directory \"${WORKTREE_ROOT}/\")) (magit-commit-create))"
```

Wait 3-5 seconds for pre-commit hooks to run, then check if the buffer appeared:

```bash
sleep 3
COMMIT_EDITMSG_PATH="$(git rev-parse --git-dir)/COMMIT_EDITMSG"
emacsclient --eval "(get-file-buffer \"${COMMIT_EDITMSG_PATH}\")"
```

If still `nil`, **hooks likely blocked it**. Warn user and retry with `--no-verify`:

> **Warning:** Pre-commit hooks prevented the commit buffer from opening. Retrying with `--no-verify` to skip hooks. Review the hook output in the Magit process buffer if needed.

```bash
emacsclient --eval "(let ((default-directory \"${WORKTREE_ROOT}/\") (magit-commit-arguments (list \"--no-verify\"))) (magit-commit-create))"
```

Wait and verify again. If still no buffer, report failure — something else is wrong.

### 4. Insert the commit message

```bash
COMMIT_EDITMSG_PATH="$(git rev-parse --git-dir)/COMMIT_EDITMSG"
WORKTREE_ID=$(basename "$(git rev-parse --show-toplevel)")
emacsclient --eval "
(let ((buf (get-file-buffer \"${COMMIT_EDITMSG_PATH}\")))
  (when buf
    (with-current-buffer buf
      (erase-buffer)
      (insert (with-temp-buffer
                (insert-file-contents \"/tmp/claude-magit-commit-msg-${WORKTREE_ID}.txt\")
                (buffer-string)))
      (goto-char (point-min)))))"
```

Tell the user the message is ready for review in Emacs. They finalize with `C-c C-c`.

### 5. Do NOT finalize

Never call `with-editor-finish` or `server-edit`. User reviews and submits manually.

## Key rules

- **All operations via emacsclient** — no direct `git commit`
- **Temp file for message** — never pass long text as elisp strings
- **Never finalize the commit** — only fill the buffer
- **Warn on hook skip** — make it clear when `--no-verify` is used
- **Co-author line** — append `Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>` to messages
