(require 'evil)

(evil-define-state vterm-tmux-navigator
  "State to navigate a tmux session nested inside vterm"
  :tag " <T> "
  :message "-- TMUX --")

(defun evil-vterm-tmux-navigator/quit ()
  (interactive)
  (evil-normal-state))

(define-key evil-vterm-tmux-navigator-state-map "j" #'vterm-tmux-navigator/vterm-navigate-down)
(define-key evil-vterm-tmux-navigator-state-map "k" #'vterm-tmux-navigator/vterm-navigate-up)
(define-key evil-vterm-tmux-navigator-state-map "h" #'vterm-tmux-navigator/vterm-navigate-left)
(define-key evil-vterm-tmux-navigator-state-map "l" #'vterm-tmux-navigator/vterm-navigate-right)
(define-key evil-vterm-tmux-navigator-state-map "H" #'vterm-tmux-navigator/vterm-navigate-left-window)
(define-key evil-vterm-tmux-navigator-state-map "L" #'vterm-tmux-navigator/vterm-navigate-right-window)
(define-key evil-vterm-tmux-navigator-state-map (kbd "C-g") #'evil-vterm-tmux-navigator/quit)
(define-key evil-vterm-tmux-navigator-state-map [escape] #'evil-vterm-tmux-navigator/quit)

(setq evil-vterm-tmux-navigator-state-cursor '("#ff007b" box))

(provide 'evil-vterm-tmux-navigator)
