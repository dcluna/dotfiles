;;; loaddefs.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads nil "tmux-utils" "tmux-utils.el" (0 0 0 0))
;;; Generated autoloads from tmux-utils.el

(autoload 'tmux-utils/visidata-open-files-in-new-windows "tmux-utils" "\
Opens each marked file in dired on a new tmux window, named after the file.

\(fn SESSION)" t nil)

(autoload 'tmux-utils/visidata-open-all-in-new-window "tmux-utils" "\
Opens all marked files in dired on one visidata session in a new tmux window, named as 'WINDOW-NAME'.

\(fn SESSION WINDOW-NAME)" t nil)

(register-definition-prefixes "tmux-utils" '("tmux-utils"))

;;;***

;;;### (autoloads nil "vterm-tmux-navigator" "vterm-tmux-navigator.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from vterm-tmux-navigator.el

(autoload 'vterm-tmux-navigator/vterm-navigate-down "vterm-tmux-navigator" nil t nil)

(autoload 'vterm-tmux-navigator/vterm-navigate-up "vterm-tmux-navigator" nil t nil)

(autoload 'vterm-tmux-navigator/vterm-navigate-left "vterm-tmux-navigator" nil t nil)

(autoload 'vterm-tmux-navigator/vterm-navigate-right "vterm-tmux-navigator" nil t nil)

(autoload 'vterm-tmux-navigator/vterm-navigate-left-window "vterm-tmux-navigator" nil t nil)

(autoload 'vterm-tmux-navigator/vterm-navigate-right-window "vterm-tmux-navigator" nil t nil)

(register-definition-prefixes "vterm-tmux-navigator" '("vterm-tmux-navigator/vterm-send-prefix"))

;;;***

(provide 'loaddefs)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; loaddefs.el ends here
