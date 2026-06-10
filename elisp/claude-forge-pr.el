;;; claude-forge-pr.el --- Run Claude's /forge-pr skill asynchronously -*- lexical-binding: t; -*-

(defvar claude-forge-pr-buffer-name "*Claude PR Generator*"
  "Name of the async buffer for Claude PR generation.")

(defvar claude-forge-pr-executable "claude"
  "Path to the Claude CLI executable.")

(defvar claude-forge-pr-shell-cmd-template
  "%s --permission-mode \"auto\" --verbose --output-format \"stream-json\" -p %s < /dev/null"
  "Shell command template for Claude PR generation.
First %s is the executable (shell-quoted), second %s is the prompt (shell-quoted).")

(defun claude-forge-pr--git-branches ()
  "Return list of local git branch names."
  (let ((output (shell-command-to-string "git branch --format='%(refname:short)'")))
    (split-string (string-trim output) "\n" t)))

(defun claude-forge-pr--default-source ()
  "Return default source branch: magit Head if available, else git current branch."
  (or (and (fboundp 'magit-get-current-branch)
           (magit-get-current-branch))
      (string-trim (shell-command-to-string "git rev-parse --abbrev-ref HEAD"))))

(defun claude-forge-pr--default-base ()
  "Return default base branch: magit Merge/Rebase upstream if available, else \"develop\"."
  (or (and (fboundp 'magit-get-upstream-branch)
           (when-let ((upstream (magit-get-upstream-branch)))
             (substring-no-properties upstream)))
      "develop"))

(defun claude-forge-pr--forge-post-buffers ()
  "Return list of buffer names that are forge-post or forge-related buffers, sorted first."
  (let ((forge-bufs nil)
        (other-bufs nil))
    (dolist (buf (buffer-list))
      (let ((name (buffer-name buf)))
        (cond
         ((or (string-match-p "new-pullreq" name)
              (string-match-p "forge" name)
              (string-match-p "pullreq" name))
          (push name forge-bufs))
         ((not (string-match-p "\\` " name))
          (push name other-bufs)))))
    (append (nreverse forge-bufs) (nreverse other-bufs))))

;;;###autoload
(defun claude-forge-pr (source-branch base-branch target-buffer &optional edit-cmd)
  "Run Claude /forge-pr skill asynchronously.
Prompts for SOURCE-BRANCH, BASE-BRANCH, and TARGET-BUFFER.
Defaults to magit Head and Merge/Rebase branches when in a magit buffer.
Forge-post buffers are prioritized in buffer selection.
With prefix argument, edit the shell command before running.
Output streams to the *Claude PR Generator* buffer."
  (interactive
   (let* ((branches (claude-forge-pr--git-branches))
          (source (completing-read "Source branch: " branches nil nil
                                   (claude-forge-pr--default-source)))
          (base (completing-read "Base branch: " branches nil nil
                                 (claude-forge-pr--default-base)))
          (bufs (claude-forge-pr--forge-post-buffers))
          (buf (completing-read "Target buffer: " bufs nil nil (car bufs))))
     (list source base buf current-prefix-arg)))
  (let* ((prompt (format "/forge-pr branch=%s,base=%s,buf=%s"
                         source-branch base-branch target-buffer))
         (output-buf (get-buffer-create claude-forge-pr-buffer-name))
         (shell-cmd (format claude-forge-pr-shell-cmd-template
                            (shell-quote-argument claude-forge-pr-executable)
                            (shell-quote-argument prompt)))
         (shell-cmd (if edit-cmd
                        (read-string "Shell command: " shell-cmd)
                      shell-cmd)))
    (with-current-buffer output-buf
      (erase-buffer)
      (insert (format "Running: %s\n\n" shell-cmd)))
    (display-buffer output-buf)
    (let ((proc (start-process-shell-command
                 "claude-forge-pr" output-buf shell-cmd)))
      (set-process-filter
       proc
       (lambda (proc output)
         (when (buffer-live-p (process-buffer proc))
           (with-current-buffer (process-buffer proc)
             (goto-char (point-max))
             (insert output)))))
      (set-process-sentinel
       proc
       (lambda (proc event)
         (when (string-match-p "finished" event)
           (message "Claude PR Generator finished."))
         (when (string-match-p "exited abnormally" event)
           (message "Claude PR Generator failed: %s" (string-trim event))))))))

(provide 'claude-forge-pr)
;;; claude-forge-pr.el ends here
