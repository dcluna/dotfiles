(defun tmux-utils--read-session ()
  (or (and (getenv "TMUX")
           (s-chomp
            (shell-command-to-string "tmux display-message -p '#S'")))
      (read-string "Session: ")))

(defun tmux-utils--new-window-command (session command &optional window-name)
  (format
   "tmux new-window -t %s: %s %s"
   session
   (if window-name (concat  "-n " window-name) "")
   command))

(defun tmux-utils/dired-command-new-window (session command &optional window-name)
  (interactive (list
                (tmux-utils--read-session)
                (read-string "Command: ")
                (read-string "Window name: ")))
  (dired-do-shell-command
   (tmux-utils--new-window-command session command window-name)
   (list 4)
   (dired-get-marked-files)))

;;;###autoload
(defun tmux-utils/visidata-open-files-in-new-windows (session)
  "Opens each marked file in dired on a new tmux window, named after the file."
  (interactive (list (tmux-utils--read-session)))
  (dolist (file (dired-get-marked-files))
    (dired-do-shell-command
     (tmux-utils--new-window-command session "vd" (file-name-base file))
     (list 4)
     (list file))))

;;;###autoload
(defun tmux-utils/visidata-open-all-in-new-window (session window-name)
  "Opens all marked files in dired on one visidata session in a new tmux window, named as 'WINDOW-NAME'."
  (interactive (list (tmux-utils--read-session) (read-string "Window name: ")))
  (if (equal 0
             (call-process-shell-command
              (tmux-utils--new-window-command
               session
               (format
                "vd %s"
                (mapconcat #'identity (dired-get-marked-files) " "))
               window-name)))
      (message "visidata window %s opened in session %s" window-name session)))

(provide 'tmux-utils)
