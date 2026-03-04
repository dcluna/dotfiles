;;; claude-code-tmux.el --- Run claude-code-ide sessions inside tmux -*- lexical-binding: t; -*-

;; Author: Daniel Luna
;; Package-Requires: ((emacs "27.1") (claude-code-ide "0.1"))

;;; Commentary:

;; Wraps claude-code-ide terminal sessions in tmux windows so they persist
;; if the Emacs buffer is killed.  All sessions live under one tmux session
;; (default "claude-code.el") and can be reattached from any terminal with
;; `tmux attach -t claude-code.el'.
;;
;; Usage:
;;   (claude-code-tmux-mode 1)   ; enable
;;   (claude-code-tmux-mode -1)  ; disable

;;; Code:

(require 'cl-lib)
(require 'claude-code-ide)

(defgroup claude-code-tmux nil
  "Run claude-code-ide sessions inside tmux."
  :group 'claude-code-ide
  :prefix "claude-code-tmux-")

(defcustom claude-code-tmux-session-name "claude-code.el"
  "Name of the tmux session that holds all Claude Code windows."
  :type 'string
  :group 'claude-code-tmux)

(defcustom claude-code-tmux-window-name-function
  #'claude-code-tmux--default-window-name
  "Function that maps a buffer name to a tmux window name."
  :type 'function
  :group 'claude-code-tmux)

(defun claude-code-tmux--default-window-name (buffer-name)
  "Derive a short tmux window name from BUFFER-NAME.
Examples:
  *claude:~/.emacs.spacemacs/:claude-code-update* -> claude-code-update
  *claude-code[dirname]*                          -> dirname"
  (let ((name buffer-name))
    ;; Take the last colon-separated segment
    (when (string-match ":\\([^:]*\\)\\*?$" name)
      (setq name (match-string 1 name)))
    ;; Strip surrounding *, [, ]
    (replace-regexp-in-string "[*\\[\\]]" "" name)))

(defun claude-code-tmux--build-wrapped-command (claude-cmd env-vars buffer-name)
  "Wrap CLAUDE-CMD with ENV-VARS in a tmux new-window command.
BUFFER-NAME is used to derive the tmux window name.
Returns a shell command string that:
  1. Ensures the tmux session exists
  2. Attaches to it, creating a new window running claude with env vars."
  (let* ((session (shell-quote-argument claude-code-tmux-session-name))
         (window-name (shell-quote-argument
                       (funcall claude-code-tmux-window-name-function buffer-name)))
         ;; Build "env VAR=val VAR2=val2 claude ..." for the innermost shell
         (env-prefix (mapconcat #'identity env-vars " "))
         (inner-cmd (concat env-prefix " " claude-cmd))
         ;; Quote inner-cmd for tmux new-window (one shell layer)
         (quoted-inner (shell-quote-argument inner-cmd))
         ;; Build the sh -c script that tmux attach will run
         (script (format "tmux has-session -t %s 2>/dev/null || tmux new-session -d -s %s; exec tmux attach-session -t %s \\; new-window -n %s %s"
                         session session session window-name quoted-inner)))
    ;; The final command: sh -c '<script>' — quoted once more for vterm/eat
    (format "sh -c %s" (shell-quote-argument script))))

(defun claude-code-tmux--around-create-terminal-session (orig-fn buffer-name working-dir port continue resume session-id)
  "Advice around `claude-code-ide--create-terminal-session'.
Wraps the claude command in a tmux session/window.
ORIG-FN and remaining args are passed through."
  (if (not (executable-find "tmux"))
      (progn
        (message "claude-code-tmux: tmux not found, falling back to plain terminal")
        (funcall orig-fn buffer-name working-dir port continue resume session-id))
    ;; Build the raw claude command and env vars, then wrap in tmux
    (let* ((claude-cmd (claude-code-ide--build-claude-command continue resume session-id))
           (env-vars (list (format "CLAUDE_CODE_SSE_PORT=%d" port)
                           "ENABLE_IDE_INTEGRATION=true"
                           "TERM_PROGRAM=emacs"
                           "FORCE_CODE_TERMINAL=true"))
           (wrapped (claude-code-tmux--build-wrapped-command claude-cmd env-vars buffer-name)))
      ;; Temporarily override --build-claude-command to return our wrapped command
      ;; so the rest of --create-terminal-session (buffer creation, eat/vterm setup) works unchanged.
      (cl-letf (((symbol-function 'claude-code-ide--build-claude-command)
                 (lambda (&rest _args) wrapped)))
        (funcall orig-fn buffer-name working-dir port continue resume session-id)))))

;;;###autoload
(define-minor-mode claude-code-tmux-mode
  "Global minor mode to run claude-code-ide sessions inside tmux.
When enabled, each new Claude Code session runs in a tmux window
under the session named by `claude-code-tmux-session-name'."
  :global t
  :group 'claude-code-tmux
  :lighter " tmux"
  (if claude-code-tmux-mode
      (advice-add 'claude-code-ide--create-terminal-session
                  :around #'claude-code-tmux--around-create-terminal-session)
    (advice-remove 'claude-code-ide--create-terminal-session
                   #'claude-code-tmux--around-create-terminal-session)))

(provide 'claude-code-tmux)
;;; claude-code-tmux.el ends here