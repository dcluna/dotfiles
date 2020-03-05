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

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "tmux-utils" '(#("tmux-utils" 0 10 (fontified t face ((:foreground "#ffffaa469bf4") font-lock-function-name-face))))))

;;;***

(provide 'loaddefs)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; loaddefs.el ends here
