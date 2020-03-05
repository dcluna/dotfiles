(defun tmux--read-session ()
  (or (and (getenv "TMUX")
           (s-chomp
            (shell-command-to-string "tmux display-message -p '#S'")))
      (read-string "Session: ")))

(defun tmux--new-window-command (session command &optional window-name)
  (format
   "tmux new-window -t %s: %s %s"
   session
   (if window-name (concat  "-n " window-name) "")
   command))

(defun tmux/dired-command-new-window (session command &optional window-name)
  (interactive (list
                (tmux--read-session)
                (read-string "Command: ")
                (read-string "Window name: ")))
  (dired-do-shell-command
   (tmux--new-window-command session command window-name)
   (list 4)
   (dired-get-marked-files)))

(defun tmux/visidata-new-window (session)
  (interactive (list (tmux--read-session)))
  (dolist (file (dired-get-marked-files))
    (dired-do-shell-command
     (tmux--new-window-command session "vd" (file-name-base file))
     (list 4)
     (list file))))
