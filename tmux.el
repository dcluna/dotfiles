(defun tmux/dired-command-new-window (session command &optional window-name)
  (interactive "sSession: \nsCommand: \nsWindow name: ")
  (dired-do-shell-command
   (format
    "tmux new-window -t %s: %s %s"
    session
    (if window-name (concat  "-n " window-name) "")
    command)
   (list 4)
   (dired-get-marked-files)))
