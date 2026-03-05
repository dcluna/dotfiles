;;; claude-code-tmux.el --- Run claude-code.el sessions inside tmux -*- lexical-binding: t; -*-

;; Author: Daniel Luna
;; Package-Requires: ((emacs "27.1") (claude-code "0.1"))

;;; Commentary:

;; Wraps claude-code.el terminal sessions in tmux windows so they persist
;; if the Emacs buffer is killed.  All sessions live under one tmux session
;; (default "claude-code.el") and can be reattached from any terminal with
;; `tmux attach -t claude-code.el'.
;;
;; Usage:
;;   (claude-code-tmux-mode 1)   ; enable
;;   (claude-code-tmux-mode -1)  ; disable

;;; Code:

(require 'cl-lib)

(defgroup claude-code-tmux nil
  "Run claude-code.el sessions inside tmux."
  :group 'claude-code
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

(defcustom claude-code-tmux-env-var-prefixes '("CLAUDE_" "ANTHROPIC_")
  "Prefixes of env vars to propagate into tmux new-window.

Variables in `process-environment' whose names start with any of
these prefixes will be passed via `env VAR=val' inside tmux."
  :type '(repeat string)
  :group 'claude-code-tmux)

(defun claude-code-tmux--default-window-name (buffer-name)
  "Derive a short tmux window name from BUFFER-NAME.

Uses `claude-code--extract-instance-name-from-buffer-name' when
available, falling back to the directory basename.
Examples:
  *claude:~/.emacs.spacemacs/:my-instance* -> my-instance
  *claude:~/.emacs.spacemacs/*             -> emacs.spacemacs"
  (or (and (fboundp 'claude-code--extract-instance-name-from-buffer-name)
           (claude-code--extract-instance-name-from-buffer-name buffer-name))
      (let ((dir (and (fboundp 'claude-code--extract-directory-from-buffer-name)
                      (claude-code--extract-directory-from-buffer-name buffer-name))))
        (when dir
          (file-name-nondirectory (directory-file-name dir))))
      ;; Last resort: strip *...* and take last colon segment
      (let ((name buffer-name))
        (when (string-match ":\\([^:*]+\\)\\*?$" name)
          (setq name (match-string 1 name)))
        (replace-regexp-in-string "[*\\[\\]]" "" name))))

(defun claude-code-tmux--extra-env-vars ()
  "Return env vars from `process-environment' matching configured prefixes.

Returns a list of \"VAR=val\" strings for variables whose names
start with any prefix in `claude-code-tmux-env-var-prefixes'."
  (let (result)
    (dolist (entry process-environment)
      (when (and (string-match "\\`\\([^=]+\\)=" entry)
                 (let ((name (match-string 1 entry)))
                   (cl-some (lambda (prefix) (string-prefix-p prefix name))
                            claude-code-tmux-env-var-prefixes)))
        (push entry result)))
    (nreverse result)))

(defun claude-code-tmux--build-wrapped-command (program switches env-vars buffer-name)
  "Build a shell command that runs PROGRAM with SWITCHES inside tmux.

ENV-VARS is a list of \"VAR=val\" strings to propagate.
BUFFER-NAME is used to derive the tmux window name.

The resulting command:
  sh -c 'tmux has-session -t SESSION 2>/dev/null || \
         tmux new-session -d -s SESSION; \
         exec tmux attach-session -t SESSION \
           \\; new-window -n WINDOW env VAR=val PROGRAM SWITCHES...'"
  (let* ((session (shell-quote-argument claude-code-tmux-session-name))
         (window (shell-quote-argument
                  (funcall claude-code-tmux-window-name-function buffer-name)))
         ;; Inner command: env VAR1=val1 VAR2=val2 program switch1 switch2
         (inner-parts (append
                       (when env-vars
                         (cons "env" (mapcar #'shell-quote-argument env-vars)))
                       (cons (shell-quote-argument program)
                             (mapcar #'shell-quote-argument switches))))
         (inner-cmd (mapconcat #'identity inner-parts " "))
         ;; The sh -c script for tmux
         (script (format
                  "tmux has-session -t %s 2>/dev/null || tmux new-session -d -s %s; exec tmux attach-session -t %s \\; new-window -n %s %s"
                  session session session window inner-cmd)))
    script))

(defun claude-code-tmux--around-term-make (orig-fn backend buffer-name program &optional switches)
  "Advice around `claude-code--term-make' to wrap sessions in tmux.

ORIG-FN is the original `claude-code--term-make'.
BACKEND, BUFFER-NAME, PROGRAM, and SWITCHES are passed through.
When tmux is not found, falls back to the original function."
  (if (not (executable-find "tmux"))
      (progn
        (message "claude-code-tmux: tmux not found, falling back to plain terminal")
        (funcall orig-fn backend buffer-name program switches))
    (let* ((env-vars (claude-code-tmux--extra-env-vars))
           (script (claude-code-tmux--build-wrapped-command
                    program (or switches '()) env-vars buffer-name)))
      (funcall orig-fn backend buffer-name "sh" (list "-c" script)))))

;;;###autoload
(define-minor-mode claude-code-tmux-mode
  "Global minor mode to run claude-code.el sessions inside tmux.

When enabled, each new Claude Code session runs in a tmux window
under the session named by `claude-code-tmux-session-name'."
  :global t
  :group 'claude-code-tmux
  :lighter " tmux"
  (if claude-code-tmux-mode
      (advice-add 'claude-code--term-make
                  :around #'claude-code-tmux--around-term-make)
    (advice-remove 'claude-code--term-make
                   #'claude-code-tmux--around-term-make)))

(provide 'claude-code-tmux)
;;; claude-code-tmux.el ends here