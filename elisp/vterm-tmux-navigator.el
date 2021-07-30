(defun vterm-tmux-navigator/vterm-send-prefix ()
  (vterm-send-C-b))

;;;###autoload
(defun vterm-tmux-navigator/vterm-navigate-down ()
  (interactive)
  (vterm-tmux-navigator/vterm-send-prefix)
  (vterm-send-down))

;;;###autoload
(defun vterm-tmux-navigator/vterm-navigate-up ()
  (interactive)
  (vterm-tmux-navigator/vterm-send-prefix)
  (vterm-send-up))

;;;###autoload
(defun vterm-tmux-navigator/vterm-navigate-left ()
  (interactive)
  (vterm-tmux-navigator/vterm-send-prefix)
  (vterm-send-left))

;;;###autoload
(defun vterm-tmux-navigator/vterm-navigate-right ()
  (interactive)
  (vterm-tmux-navigator/vterm-send-prefix)
  (vterm-send-right))

;;;###autoload
(defun vterm-tmux-navigator/vterm-navigate-left-window ()
  (interactive)
  (vterm-tmux-navigator/vterm-send-prefix)
  (vterm-send-C-h))

;;;###autoload
(defun vterm-tmux-navigator/vterm-navigate-right-window ()
  (interactive)
  (vterm-tmux-navigator/vterm-send-prefix)
  (vterm-send-C-l))

(provide 'vterm-tmux-navigator)
