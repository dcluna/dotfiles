;;; ediff-merge-utils.el --- Ediff merge utilities with auto-writeback -*- lexical-binding: t; -*-

(require 'ediff)

(defun ediff-merge-utils--has-unresolved-conflicts-p ()
  "Check if the current ediff session has unresolved conflicts.
Must be called from the ediff control buffer."
  (let ((n ediff-number-of-differences)
        (found nil))
    (dotimes (i n)
      (when (string= (ediff-get-state-of-merge i) "combined")
        (setq found t)))
    found))

(defun ediff-merge-utils--ensure-trailing-newline (buffer)
  "Ensure BUFFER ends with a newline.
FreeBSD diff3 (macOS) mangles output when files lack trailing
newlines, causing ediff to fail with a regex parse error."
  (with-current-buffer buffer
    (goto-char (point-max))
    (unless (eq (char-before) ?\n)
      (let ((inhibit-read-only t))
        (insert "\n")))))

;;;###autoload
(defun ediff-merge-buffers-writeback (buffer-a buffer-b target-buffer)
  "Merge BUFFER-A and BUFFER-B, writing the result into TARGET-BUFFER.
Creates a temporary ancestor buffer from TARGET-BUFFER's content
so that TARGET-BUFFER itself is never passed to ediff (avoids
corrupting ediff state on read-only or special-mode buffers).

When the user quits ediff:
- If no unresolved conflicts, write merge result into TARGET-BUFFER.
- If unresolved conflicts remain, warn and leave TARGET-BUFFER untouched."
  (interactive
   (let ((bufs (mapcar #'buffer-name (buffer-list))))
     (list (get-buffer (completing-read "Buffer A (old): " bufs nil t))
           (get-buffer (completing-read "Buffer B (new): " bufs nil t))
           (get-buffer (completing-read "Target buffer: " bufs nil t)))))
  ;; Create a plain-text ancestor copy — never hand the target buffer
  ;; to ediff directly, as ediff holds references and modifying the
  ;; buffer (even adding a trailing newline) corrupts diff state.
  (let* ((ancestor-buf (generate-new-buffer "*forge-pr-ancestor*"))
         (target target-buffer))
    (with-current-buffer ancestor-buf
      (insert (with-current-buffer target-buffer
                (buffer-substring-no-properties (point-min) (point-max))))
      (markdown-mode))
    ;; FreeBSD diff3 (macOS default) corrupts output when buffers
    ;; lack trailing newlines — ensure all three have one.
    (ediff-merge-utils--ensure-trailing-newline buffer-a)
    (ediff-merge-utils--ensure-trailing-newline buffer-b)
    (ediff-merge-utils--ensure-trailing-newline ancestor-buf)
    (ediff-merge-buffers-with-ancestor
     buffer-a buffer-b ancestor-buf
     (list
      (lambda ()
        (add-hook
         'ediff-quit-hook
         (lambda ()
           (if (ediff-merge-utils--has-unresolved-conflicts-p)
               (message "Unresolved conflicts remain — %s left untouched."
                        (buffer-name target))
             (let ((result (with-current-buffer ediff-buffer-C
                             (buffer-string))))
               (with-current-buffer target
                 (let ((inhibit-read-only t))
                   (erase-buffer)
                   (insert result)))
               (message "Merge result written to %s." (buffer-name target))))
           ;; Clean up ancestor buffer
           (when (buffer-live-p ancestor-buf)
             (kill-buffer ancestor-buf)))
         nil t))))))

(provide 'ediff-merge-utils)
;;; ediff-merge-utils.el ends here
