;; Borg.el
;; (setq borg-drone-directory (expand-file-name "~/dotfiles/collective/lib"))
;; 
;; (require 'f)
;; 
;; (dolist (dir (f-directories borg-drone-directory))
;;   (add-to-list 'load-path dir))
;; 
;; ;; <<borg-config>>
;; 
;; (add-to-list 'load-path (expand-file-name "~/code/borg"))
;; (require 'borg)
;; (borg-initialize)
;; ;; (require 'magit)
;; ;; (magit-add-section-hook 'magit-status-sections-hook
;; ;;                         'magit-insert-modules-unpulled-from-upstream
;; ;;                         'magit-insert-unpulled-from-upstream)
;; ;; (magit-add-section-hook 'magit-status-sections-hook
;; ;;                         'magit-insert-modules-unpulled-from-pushremote
;; ;;                         'magit-insert-unpulled-from-upstream)
;; ;; (magit-add-section-hook 'magit-status-sections-hook
;; ;;                         'magit-insert-modules-unpushed-to-upstream
;; ;;                         'magit-insert-unpulled-from-upstream)
;; ;; (magit-add-section-hook 'magit-status-sections-hook
;; ;;                         'magit-insert-modules-unpushed-to-pushremote
;; ;;                         'magit-insert-unpulled-from-upstream)
;; ;; (magit-add-section-hook 'magit-status-sections-hook
;; ;;                         'magit-insert-submodules
;; ;;                         'magit-insert-unpulled-from-upstream)
;; function and macro definitions
(defun dcl/get-js-or-src-file (filename)
  (let* ((curline (line-number-at-pos))
         (extension (file-name-extension filename)))
    (concat
     (file-name-sans-extension filename)
     "."
     (cond
      ((equal extension '"ts") "js")
      ((equal extension '"js") "ts")
      (t (error "unknown extension: %s" extension))))))

(defvar smap-cli-location "~/code-examples/smapcli.js" "Location of the smapcli.js script.")

(defun dcl/toggle-ts-and-js-file (filename)
  (interactive (list (buffer-file-name)))
  (let ((curline (line-number-at-pos))
        (curcol (current-column))
        (newfilename (dcl/get-js-or-src-file filename)))
    (find-file newfilename)
    (if (and (equal "js" (file-name-extension newfilename))
             (or (executable-find smap-cli-location)
                 (file-exists-p smap-cli-location)))
        (progn
          (destructuring-bind (file line col) (s-split " " (shell-command-to-string
                                                            (format "%s fromSource -l %s -c %s --sm %s" smap-cli-location curline curcol (concat newfilename ".map"))))
            (goto-line (string-to-number line))
            (move-to-column (string-to-number col))))
      (goto-line curline))))

(defun dcl/run-in-generated-js (fn)
  "Runs FN in the corresponding generated JS file, then restores the buffer."
  (let ((curbuf (current-buffer)))
    (dcl/toggle-ts-and-js-file (buffer-file-name))
    (funcall fn)
    (switch-to-buffer curbuf)))

(defun ts-mocha-test-at-point ()
  (interactive)
  (dcl/run-in-generated-js (lambda () (mocha-test-at-point))))

(defun ts-mocha-test-file ()
  (interactive)
  (dcl/run-in-generated-js (lambda () (mocha-test-file))))

(defun ts-mocha-debug-at-point ()
  (interactive)
  (dcl/run-in-generated-js (lambda () (mocha-debug-at-point))))

(defun ts-mocha-debug-file ()
  (interactive)
  (dcl/run-in-generated-js (lambda () (mocha-debug-file))))

(defun dcl/run-nightwatch-test ()
  (interactive)
  (let ((compilation-read-command t))
    (call-interactively 'compile nil (vector (format "NODE_ENV=test PORT=3001 yarn run test-e2e -- --test ")))))

(defun skewer-eval-region (beg end &optional prefix)
  (interactive "r\nP")
  (skewer-eval (buffer-substring beg end) (if prefix #'skewer-post-print #'skewer-post-minibuffer)))

(defun js/rspec-targetize-file-name (a-file-name extension)
  "Return A-FILE-NAME but converted into a non-spec file name with EXTENSION."
  (concat (file-name-directory a-file-name)
          (rspec-file-name-with-default-extension
           (replace-regexp-in-string "_spec\\.js.coffee" (concat "." extension)
                                     (file-name-nondirectory a-file-name)))))

(defun js/rspec-target-file-for (a-spec-file-name)
  "Find the target for A-SPEC-FILE-NAME."
  (cl-loop for extension in (list "js" "coffee")
           for candidate = (js/rspec-targetize-file-name a-spec-file-name
                                                         extension)
           for filename = (cl-loop for dir in (cons "."
                                                    rspec-primary-source-dirs)
                                   for target = (replace-regexp-in-string
                                                 "/spec/"
                                                 (concat "/" dir "/")
                                                 candidate)
                                   if (file-exists-p target)
                                   return target)
           if filename
           return filename))
(define-derived-mode ruby-trace-mode grep-mode "RbTrace"
  "Highlights matches from a Tracer run."
  ;; (unless (assoc 'ruby-trace-mode hs-special-modes-alist)
  ;;   (push '(ruby-trace-mode
  ;;           "^\\(?:#[0-9]+:\\)?\\(.*?[^/\n]\\):[   ]*\\([1-9][0-9]*\\)[  ]*:\\(?:\\(?:\\w\\|\\(?:::\\)\\)+\\):>:"
  ;;           "^\\(?:#[0-9]+:\\)?\\(.*?[^/\n]\\):[   ]*\\([1-9][0-9]*\\)[  ]*:\\(?:\\(?:\\w\\|\\(?:::\\)\\)+\\):<:"
  ;;           ) hs-special-modes-alist))
  (setq-local compilation-error-regexp-alist '(ruby-trace))
  (setq-local compilation-error-regexp-alist-alist '((ruby-trace "^\\(?:#[0-9]+:\\)?\\(.*?[^/\n]\\):[   ]*\\([1-9][0-9]*\\)[  ]*:" 1 2)))
  ;; (setq-local comment-start "$$$$$!!")
  ;; (setq-local comment-end "$$$$$!!")
  ;; (setq-local hs-special-modes-alist '((ruby-trace-mode ":>:" ":<:")))
  )

(defun dcl/ruby-copy-camelized-class (beg end)
  "Camelizes the current region's class name."
  (interactive "r")
  (let* ((class-name (buffer-substring beg end))
         (no-module-or-class-name (replace-regexp-in-string " *\\(module\\|class\\) " "" class-name)))
    (kill-new (message (s-join "::" (s-split "\n" no-module-or-class-name))))))

(defun dcl/ruby-special-setup ()
  (dcl/leader-keys-major-mode
   '(enh-ruby-mode ruby-mode) "os" "repl"
   '(("b" ruby-send-buffer)))
  (dcl/leader-keys-major-mode
   '(enh-ruby-mode ruby-mode) "ot" "test"
   '(("d" ruby/rspec-verify-directory)
     ("j" dcl/run-jasmine-specs)))
  (dcl/leader-keys-major-mode
   '(enh-ruby-mode ruby-mode) "ox" "text"
   '(("m" dcl/ruby-copy-camelized-class)))
  (dcl/leader-keys-major-mode
   '(enh-ruby-mode ruby-mode) "oT" "toggles"
   '(("r" spacemacs/toggle-rubocop-autocorrect-on-save)))
  (dcl/ruby-embrace-setup)
  (auto-fill-mode 1)
  (setq-local zeal-at-point-docset "ruby,rails")
  (setq-local before-save-hook (add-to-list 'before-save-hook 'whitespace-cleanup)))

(defun ruby/rspec-verify-directory (prefix dir)
  (interactive "P\nDrspec directory: ")
  (rspec-run-single-file dir (concat (rspec-core-options) (if (and prefix (>= (car prefix) 4)) (format " --seed %d" (read-number "Seed: "))))))

(defun dcl/markdown-embedded-image (alt-text)
  (interactive "sAlt text: ")
  (message (kill-new (format "![%s](data:image/%s;%s)" alt-text (file-name-extension (buffer-file-name)) (base64-encode-string (buffer-substring-no-properties (point-min) (point-max)))))))

(defun dcl/ruby-rspec-profiling-console ()
  (interactive)
  (projectile-rails-with-root
   (progn
     (with-current-buffer (run-ruby "bundle exec rake rspec_profiling:console"))
     (projectile-rails-mode +1))))

(require 'evil-embrace)

(defun dcl/ruby-embrace-setup ()
  (mapc (lambda (key) (setq-local evil-embrace-evil-surround-keys (cl-remove key evil-embrace-evil-surround-keys))) '(?\{ ?\}))
  (embrace-add-pair ?{ "{" "}")
  (embrace-add-pair ?# "#{" "}")
  (embrace-add-pair ?d "do " " end")
  (embrace-add-pair ?l "->() {" "}")
  (embrace-add-pair ?S "send(:" ")"))

(defun ruby-eval-line (lines)
  (interactive "p")
  (dotimes (i lines)
    (ruby-send-region (line-beginning-position) (line-end-position))
    (next-line (signum lines))))

(defun rails-copy-relative-path ()
  (interactive)
  (message (kill-new (replace-regexp-in-string (regexp-opt (list (or (projectile-rails-root) ""))) "" (buffer-file-name)))))

  ;;; linter setup
;; (defun setup-rails-linters ()
;;   (dolist (elisp (list "~/code-examples/haml-lint-flycheck" "~/code-examples/sass-lint-flycheck"))
;;     (load elisp)))

(defvar jasmine-compilation-buffer-name "*jasmine:ci*")

;;; taken from http://stackoverflow.com/a/3072831
(defun colorize-compilation-buffer ()
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region (point-min) (point-max))))

(defun dcl/run-jasmine-specs (prefix)
  "Runs jasmine specs in Rails project root directory."
  (interactive "P")
  (projectile-rails-with-root
   (progn
     (let ((compilation-buffer-name-function (lambda (majormode) jasmine-compilation-buffer-name)))
       (compile (concat "bundle exec rake jasmine:ci" (if prefix (let ((seed (read-number "Seed: "))) (format "\\[%s,%s\\]" seed seed)))))
       (with-current-buffer jasmine-compilation-buffer-name
         (setq-local compilation-filter-hook 'colorize-compilation-buffer))))))

(defvar rubocop-files-history (list '(split-string (shell-command-to-string "\"git diff --name-status HEAD master | grep -v '^D' | cut -f 2\"") "\"\\n\"") ))

(defun dcl/rubocop-files (files-command)
  "Runs `rubocop-autocorrect-current-file' and `reek-check-current-file' on FILES."
  (interactive (list (read-from-minibuffer "Rubocop on(Lisp expression): " (format "%s" (car rubocop-files-history)) nil t 'rubocop-files-history)))
  (dolist (ruby-file (--filter (string-match-p ".rb$" it) (eval files-command)))
    (with-current-buffer (find-file-noselect ruby-file)
      (rubocop-autocorrect-current-file)
      )))

(defun dcl/make-test-sh-file (filename)
  "Generates a shell script that runs the current file as an rspec test, for bisecting."
  (interactive "F")
  (let ((test-file (buffer-file-name)))
    (with-temp-file filename
      (insert "#!/bin/bash\n")
      (insert (format "bundle exec rspec %s" test-file)))))
(defun dcl/ruby-date-to-unix-epoch (date)
 "Given DATE, return the corresponding seconds since Unix epoch."
 (interactive "sDate: ")
 (kill-new
  (message (s-chomp
            (shell-command-to-string (format "ruby -r 'active_support/all' -e \"puts '%s'.to_datetime.to_i\"" date))))))
(defun dcl/haml-special-setup ()
  (dcl/leader-keys-major-mode
   '(haml-mode) "od" "debug"
   '(("p" pmd/print-vars)))
  (setq-local comment-start "//")
  (setq-local before-save-hook (add-to-list 'before-save-hook 'whitespace-cleanup)))
(defun dcl-setup-erb-embrace ()
  (when (equal web-mode-engine "erb")
    (embrace-add-pair ?% "<% " " %>")
    (embrace-add-pair ?= "<%= " " %>")
    (embrace-add-pair ?# "#{" "}")))

(add-hook 'web-mode-hook 'dcl-setup-erb-embrace)
(defun dcl/bundle-config-local-gem-use (gem gem-location)
  "Runs `bundle config local.GEM' with gem in GEM-LOCATION."
  (interactive "sGem: \nDLocal gem directory: ")
  (let ((bundle-command (format "bundle config --local local.%s %s" gem gem-location)))
    (message bundle-command)
    (shell-command bundle-command)))

(defun dcl/bundle-config-local-gem-delete (config)
  "Deletes bundle configuration"
  (interactive (list (completing-read "bundle config option: " (s-lines (shell-command-to-string "bundle config | grep -v '^Set' | sed '/^$/d'")))))
  (let ((bundle-command (format "bundle config --delete %s" config)))
    (message bundle-command)
    (shell-command bundle-command)))
(defun sass-prepare-input-buffer ()
  "Inserts common imports into the temporary buffer with the code to be evaluated."
  (goto-char (point-min))
  (insert-file-contents "/home/dancluna/dotfiles/pre-eval-code.sass"))
(defun dcl/coffee-special-setup ()
  (dcl/leader-keys-major-mode
   '(coffee-mode) "od" "debug"
   '(("p" pmd/print-vars)))
  (dcl/leader-keys-major-mode
   '(coffee-mode) "ot" "test"
   '(("j"  dcl/run-jasmine-specs)))
  (setq-local zeal-at-point-docset "coffee,javascript,jQuery")
  (setq-local rspec-spec-file-name-re "\\(_\\|-\\)spec\\.js")
  (setq-local before-save-hook (add-to-list 'before-save-hook 'whitespace-cleanup)))
;; (require 'lsp-ruby)
;; (add-hook 'enh-ruby-mode-hook #'lsp-ruby-enable)
(defun dcl/rspec-custom-hook ()
  (embrace-add-pair ?a "array_including( " " )")
  (embrace-add-pair ?h "hash_including( " " )"))

(add-hook 'rspec-mode-hook 'dcl/rspec-custom-hook)

(setq rspec-reuse-compilation-buffers t)
;; (setq docker-compose-run-buffer-name-function (lambda (service command) (format "*%s %s*" service command)))

(setq docker-compose-run-arguments '("-e PAGER=/bin/cat"))

(setq docker-container-ls-arguments '("--all" "--filter status=running"))
(defun dcluna-make-buffer-name (action args)
  (if (string-equal action "run")
      (-let (((service command) (-take-last 2 args)))
        (format "*%s %s*" service command))
    (docker-compose-make-buffer-name action args)))

(setq docker-compose-run-buffer-name-function 'dcluna-make-buffer-name)
(let ((docker-container-keymap (make-sparse-keymap)))
  (define-key docker-container-keymap "f" 'docker-container-find-file)
  (define-key docker-container-keymap "e" 'docker-container-eshell)
  (define-key docker-container-keymap "d" 'docker-container-dired)
  (evil-leader/set-key-for-mode 'docker-container-mode "c" docker-container-keymap)
  (spacemacs/declare-prefix-for-mode 'docker-container-mode "c" "docker-container"))
(require 'pretty-mode)
(add-hook 'enh-ruby-mode-hook 'dcl/enh-ruby-prettify-symbols)
(setq prettify-symbols-unprettify-at-point t)

(defun dcl/enh-ruby-prettify-symbols ()
  (pretty-deactivate-patterns '(:leq :neq :Rightarrow :nil :neg :lambda :|| :and) 'ruby-mode)  ;bang-style methods aren't very visible with this
  (turn-on-pretty-mode)
  (mapc (lambda (pair) (push pair prettify-symbols-alist))
        '(
          ("def" .      #x192)
          ("return" .   #x27fc)
          ("not "    .   #x00ac)
          ("nil"    .   #x2205)
          ;; ("! "    .   #x00ac)
          ("!="    .   #x2260)
          ("||="      .   #x2254)
          ("||"     . #x2228)
          (" and "    . #x2227)
          ("&&"    . #x2227)
          (" ^ "      .   #x2295)
          ("=~"      .   #x2248)
          ("->"      .   #x21a0)
          ("&."      .   #x21d2)
          ("<=>"     .   #x394)
          ("<=" .  #x2264)
          ("match"   .   #x2248)
          ("include?"   .   #x220b)
          ("yield" .    #x27fb)
          ("true" .     #x22a4)
          ("false" .    #x22a5)
          ("Integer"  .  #x2124)
          ("Float"  .  #x211d)
          ("Set" .      #x2126)))
  (turn-on-prettify-symbols-mode))
(setq erm-source-dir (straight--repos-dir "enhanced-ruby-mode"))
;; creating a tags file from emacs - stolen from https://www.emacswiki.org/emacs/BuildTags
(defun ew/create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (shell-command
   (format "ctags -f %s -e -R %s" "TAGS" (directory-file-name dir-name))))

(defun dcl/leader-keys-major-mode (mode-list prefix name key-def-pairs)
  (let ((user-prefix (concat "m" prefix)))
    (dolist (mode mode-list)
      (spacemacs/declare-prefix-for-mode mode "mo" "custom")
      (spacemacs/declare-prefix-for-mode mode user-prefix name)
      (dolist (key-def-pair key-def-pairs)
        (destructuring-bind (key def) key-def-pair
          (spacemacs/set-leader-keys-for-major-mode mode (concat prefix key) def))))))

;; (defmacro dcl/make-helm-source (name desc cand-var action &rest body)
;;   (let ((candidate-source-fn-name (intern (format "%s-candidates" name)))
;;         (helm-source-var-name (intern (format "%s-helm-source" name))))
;;     `(progn
;;        (defun ,candidate-source-fn-name ()
;;          ,@body)
;;        (defvar ,helm-source-var-name
;;          '((name . ,(capitalize desc))
;;            (candidates . ,candidate-source-fn-name)
;;            (action . (lambda (,cand-var) ,action))))
;;        (defun ,name ()
;;          ,(concat "Helm source for " desc)
;;          (interactive)
;;          (helm :sources '(,helm-source-var-name))))))
;; (put
;;  'dcl/make-helm-source 'lisp-indent-function 'defun)
;;
;; (dcl/make-helm-source dcl/lib-code-magit-status "directories under ~/code"
;;   dir (magit-status dir) (directory-files "~/code" t))

(defun dcl/favorite-text-scale ()
  (unless (equal major-mode 'term-mode)
    (text-scale-set 2)))

(defun date-time-at-point (unix-date)
  (interactive (list (thing-at-point 'word t)))
  (message (shell-command-to-string (format "date --date @%s" unix-date))))

(defun dcl/emamux-vterm ()
  (interactive)
  (vterm "*emamux-vterm*")
  (vterm-send-string "tmux attach -t emamux"))
(defun dcl-set-dotenv (text)
  "Sets environment variables specified in TEXT, one per line."
  (interactive (list (if ( region-active-p )
                         (buffer-substring (region-beginning) (region-end))
                       (buffer-substring (line-beginning-position) (line-end-position)))))
  (mapc (lambda (line)
          (let* ((split (split-string line "="))
                 (envvar (car split))
                 (varval (mapconcat 'identity (cdr split) "")))
            (setenv envvar varval)))
        (split-string text "\n")))
(fset 'dcl/eshell-circleci-ssh-to-tramp
      [?i ?c ?d ?  ?/ escape ?E ?l ?r ?: ?l ?d ?W ?\" ?a ?d ?E ?x ?$ ?a ?# escape ?A escape ?\" ?a ?p ?a ?: ?~ ?/ escape])
(defun dcl/minibuffer-setup ()
  ;; (setq-local face-remapping-alist
  ;;             '((default ( :height 3.0 ))))
  )

(defmacro dcl/add-env-toggle (toggle-var toggle-key &optional toggle-on-expression)
  (let ((toggle-var-interned (intern (s-replace "_" "-" (downcase toggle-var))))
        (toggle-on (or toggle-on-expression "true")))
    `(spacemacs|add-toggle ,toggle-var-interned
       :status (getenv ,toggle-var)
       :on (setenv ,toggle-var ,toggle-on)
       :off (setenv ,toggle-var nil)
       :evil-leader ,(concat "ot" toggle-key)
       ,@(if toggle-on-expression (list :on-message `(format "%s's value is now %s" ,toggle-var (getenv ,toggle-var))))
       ))
  )

(defun dcl/filip-slowpoke ()
  (interactive)
  (message "Escape delay is now %f" (setq evil-escape-delay 0.4)))

(defun dcl/normal-delay ()
  (interactive)
  (message "Escape delay is now %f" (setq evil-escape-delay 0.1)))


(defun us-phone-number ()
  (interactive)
  (message (kill-new "732-757-2923")))

(defun browse-url-current-file ()
  (interactive)
  (helm-aif (buffer-file-name)
      (browse-url it)))
(defun hexstring-at-point ()
  "Return the hex number at point, or nil if none is found."
  (when (thing-at-point-looking-at "[0-9abcdef]+" 500)
    (buffer-substring (match-beginning 0) (match-end 0))
    ))

(put 'hexstring 'thing-at-point 'hexstring-at-point)

(defun dcl/string-to-char-code (prefix)
  "Turns the numeric string at point into a string with words"
  (interactive "P")
  (let* ((numeric-str (thing-at-point 'hexstring t))
         (padded (s-pad-left 8 "0" numeric-str))
         (partitioned (seq-partition padded 2)))
    (kill-new (message (mapconcat 'identity
                                  (mapcar (lambda (char-pair) (format "\\x%s" char-pair))
                                          (if prefix (reverse partitioned) partitioned))
                                  "")))))
(defun dcl/new-blog-post (post-title)
  (interactive "sPost title:")
  (find-file-other-window (format "%s/%s-%s.md" "/code/dcluna.github.io/_posts" (format-time-string "%Y-%m-%d" (current-time)) post-title)))
(defvar dcl-rate-per-hour (string-to-number (or (getenv "RATE_PER_HOUR") "0")))

(defun dcl/stackbuilders-invoice-template (hours-worked)
  (interactive "nHours worked: \n")
  (kill-new (message "Total due for IT services provided to Stack Builders: $%s USD" (* dcl-rate-per-hour hours-worked))))

(defvar revealjs-location (or (getenv "REVEALJS_DIR"))
  "Location of the reveal.js files")

(defun dcl/generate-revealjs-org-presentation (filename)
  "Generates FILENAME (probably an org-mode file) and symlinks the reveal.js files in the same directory."
  (interactive "F")
  (let ((directory (file-name-directory (expand-file-name filename))) )
    (make-directory directory t)
    (find-file filename)
    (assert (equal default-directory directory))
    (unless (file-exists-p "./reveal.js")
      (shell-command (format "ln -s %s reveal.js" revealjs-location)))))
(defvar lastpass-email "dancluna@gmail.com" "Default email for LastPass.")

(defun dcl/lastpass-login ()
  "Logs in LastPass."
  (interactive)
  (let ((email (read-string "Email: " lastpass-email)))
    (message (shell-command-to-string (format "lpass login %s" email)))))

(defun dcl/lastpass-import-table ()
  "Imports to LastPass from Org-table at point."
  (interactive)
  (let ((tmpfile (make-temp-file "lpimp")))
    (org-table-export tmpfile "orgtbl-to-csv")
    (message (shell-command-to-string (format "lpass import < %s" tmpfile)))
    (delete-file tmpfile)))
(defun dcl/pivotal-github-tasks-template (beg end)
  "Copies current region (which should be a list of tasks in pivotal.el) and outputs a task list in Markdown format."
  (interactive "r")
  (let ((task-list (buffer-substring beg end)))
    (kill-new
     (with-temp-buffer
       (insert task-list)
       (goto-char (point-min))
       (while (re-search-forward "^[^-]+--" nil t)
         (replace-match "- [ ]"))
       (buffer-string)))))

(defun dcl/pivotal-ticket-url (ticketid)
  (interactive "sPivotal ticket id: ")
  (format "https://www.pivotaltracker.com/story/show/%s" ticketid))

(defun dcl/pivotal-ticket-id-from-url (url)
  (replace-regexp-in-string ".*/\\([0-9]+\\)$" "\\1" ticketid-or-pivotal-link))

(defun dcl/sanitize-branch-name (string)
  "Returns STRING without any special characters, with normalized whitespace and spaces are transformed into underscores."
  (let ((no-special-chars-string
         (replace-regexp-in-string "\\([^a-zA-Z0-9 \/]\\)" "" string)))
    (replace-regexp-in-string "_$" "" (replace-regexp-in-string "^_" "" (replace-regexp-in-string "__+" "_" (downcase (replace-regexp-in-string "[\s-\/]" "_" no-special-chars-string)))))))

(defun dcl/create-branch-from-jira (jira-url branch-name)
  (interactive "sJIRA url: \nsBranch name: ")
  (let* ((ticket-id (replace-regexp-in-string "^.*/\\([^/]+\\)$" (lambda (text) (downcase (replace-regexp-in-string "-" "_" (match-string 1 text)))) jira-url))
         (sanitized-branch-name (dcl/sanitize-branch-name branch-name))
         (new-branch-name (format "%s_%s" ticket-id sanitized-branch-name)))
    (magit-branch new-branch-name "master")
    (magit-checkout new-branch-name)
    (call-interactively 'magit-push-current-to-pushremote))
  )

(defun dcl/create-branch-from-pivotal (pivotal-tracker branch-name)
  (interactive "sPivotal Tracker URL: \nsBranch name: ")
  (let* ((pivotal-tracker-ticket-id (replace-regexp-in-string "^.*/\\([0-9]+\\)$" "\\1" pivotal-tracker))
         (sanitized-branch-name (dcl/sanitize-branch-name branch-name))
         (new-branch-name (format "dl_%s_%s" pivotal-tracker-ticket-id sanitized-branch-name)))
    (magit-branch new-branch-name "master")
    (magit-checkout new-branch-name)
    (call-interactively 'magit-push-current-to-pushremote)))
(defun dcl/enable-emacspeak ()
  "Loads emacspeak if the proper environment variables are set."
  (if-let ((dir (getenv "EMACSPEAK_DIR"))
           (enable (getenv "ENABLE_EMACSPEAK")))
      (load-file (concat dir "/lisp/emacspeak-setup.el"))))
(defun dcl/set-local-evil-escape ()
  (interactive)
  (setq-local evil-escape-key-sequence "fd"))

(defmacro dcl/many-times-interactive-command (arg-name iter-var-name &rest body)
  (let ((times-sym (gensym "times"))
        (iter-var iter-var-name))
    `(let ((,times-sym (or ,arg-name 1)))
       (dotimes (,iter-var ,times-sym)
         (progn
           ,@body)
         (unless (equal ,times-sym 1)
           (forward-line (signum ,times-sym)))))))

(defun dcl/evil-ex-run-current-line (arg)
  (interactive "p")
  (dcl/many-times-interactive-command arg var (evil-ex (concat "! " (current-line)))))
(defun dcl/magit-branch-rebase ()
  (interactive)
  (let ((curbranch (magit-name-branch "HEAD"))
        (var 0)
        (created nil))
    (while (and (not created) (< var 10))
      (let ((branch-name (format "%s_before_rebase%s"
                                 curbranch
                                 (if (> var 0)
                                     (format "_%d" var)
                                   ""))))
        (when (not (magit-branch-p branch-name))
          (magit-branch branch-name curbranch)
          (message (concat "Created branch " branch-name))
          (setq created t)))
      (setq var (1+ var)))
    (unless created
      (message "before-rebase branch was not created, remove a few of them"))))

(defun git/get-branch-url ()
  "Returns the name of the remote branch, without 'origin'."
  (replace-regexp-in-string
   "^origin\/"
   ""
   (substring-no-properties (magit-get-push-branch))))

;; taken from http://endlessparentheses.com/create-github-prs-from-emacs-with-magit.html
(defun endless/visit-pull-request-url (base)
  "visit the current branch's pr on github and compares it against BASE."
  (interactive (list (magit-read-other-branch-or-commit "Compare with")))
  (browse-url
   (format "%s/compare/%s...%s"
           (replace-regexp-in-string "git@github.com:" "https://www.github.com/"
                                     (replace-regexp-in-string "\.git$" "" (magit-get "remote.origin.url")))
           base
           (git/get-branch-url)
           )))

(defun github/copy-branch-url ()
  "Copies the current branch's url on Github. Does not check if it actually exists before copying."
  (interactive)
  (message
   (kill-new
    (format "%s/tree/%s"
            (replace-regexp-in-string "git@github.com:" "https://github.com/"
                                      (replace-regexp-in-string "\.git$" "" (magit-get "remote.origin.url")))
            (git/get-branch-url)
            ))))

(defun github/copy-file-url (curbranch)
  (interactive (list (magit-read-branch "Branch: ")))
  (let* ((toplevel (replace-regexp-in-string "\/$" "" (magit-toplevel)))
         (curbranch (or curbranch (magit-get-current-branch)))
         (pathtofile (replace-regexp-in-string (regexp-quote toplevel) "" (buffer-file-name))))
    (message
     ;; format: $REMOTE-URL/blob/$BRANCH/$PATHTOFILE
     (kill-new (format "%s/blob/%s%s#%s"
                       (replace-regexp-in-string "\.git$" "" (magit-get "remote.origin.url"))
                       curbranch
                       pathtofile
                       (mapconcat (lambda (pos) (format "L%s" (line-number-at-pos pos)))
                                  (if (region-active-p)
                                      (list (region-beginning) (region-end))
                                    (list (point))) "-"))))))
(defun magit-history-checkout ()
  (interactive)
  (magit-checkout (magit-completing-read "Branch: " (magit-history-branches))))

(defun magit-history-branches ()
  (let ((i 1)
        (history-item nil)
        (current-item 'none)
        (current-branch (magit-rev-parse "--abbrev-ref" "HEAD"))
        (stop nil)
        (branch-list nil))
    (while (not stop)
      (setq history-item (format "@{-%d}" i))
      (setq current-item (magit-rev-parse "--abbrev-ref" history-item))
      (cond ((not (equalp history-item current-item))
             (if (and current-item (not (equalp current-item current-branch)))
                 (add-to-list 'branch-list current-item t)))
            (t (setq stop t)))
      (setq i (1+ i)))
    branch-list))

;;; todo: add this to spacemacs, or magit, or wherever this is defined
(defun dcl/set-fill-column-magit-commit-mode ()
  ;; magit always complains that 'line is too big' w/ the old fill-column values (72, I think). I set this to something a little smaller
  (setq fill-column 52))

(with-eval-after-load 'magit
  (define-key magit-mode-map (kbd "%") 'magit-worktree))
(defun dcl/eshell-pipe-to-buffer (buffer-name)
  (interactive "sBuffer name: ")
  (insert (format " > #<buffer %s>" buffer-name)))
;;; thanks to https://www.emacswiki.org/emacs/EmilioLopes for this code, found in https://www.emacswiki.org/emacs/NxmlMode#toc11
(defun nxml-where ()
  "Display the hierarchy of XML elements the point is on as a path."
  (interactive)
  (let ((path nil))
    (save-excursion
      (save-restriction
        (widen)
        (while (and (< (point-min) (point)) ;; Doesn't error if point is at beginning of buffer
                    (condition-case nil
                        (progn
                          (nxml-backward-up-element) ; always returns nil
                          t)
                      (error nil)))
          (setq path (cons (xmltok-start-tag-local-name) path)))
        (kill-new (if (called-interactively-p t)
                      (message "/%s" (mapconcat 'identity path "/"))
                    (format "/%s" (mapconcat 'identity path "/"))))))))
(defun ediff-copy-both-to-C ()
  (interactive)
  (ediff-copy-diff ediff-current-difference nil 'C nil
                   (concat
                    (ediff-get-region-contents ediff-current-difference 'A ediff-control-buffer)
                    (ediff-get-region-contents ediff-current-difference 'B ediff-control-buffer))))

(defun setup-ediff-mode-map-extras ()
  (define-key ediff-mode-map "d" 'ediff-copy-both-to-C))

(add-hook 'ediff-keymap-setup-hook 'setup-ediff-mode-map-extras)
(fset 'org-mode-convert-causal-lift-entries-to-tsv
   (kmacro-lambda-form [?d ?f ?: ?d ?w ?j ?d ?f ?: ?d ?w ?j ?d ?f ?: ?d ?w ?j ?d ?f ?: ?d ?w ?j ?d ?f ?: ?d ?w ?j ?d ?f ?: ?d ?w ?k ?$ ?v ?0 ?k ?k ?k ?k ?: ?s ?/ ?\C-q ?\C-j ?/ ?\C-q tab ?/ return ?j] 0 "%d"))
(defun dcl/perl1line-txt ()
  (interactive)
  (find-file-other-window "/home/dancluna/code/perl1line.txt/perl1line.txt")
  (read-only-mode 1))
(defun dcl/project-relative-path ()
  (interactive)
  (let ((filename buffer-file-name)
        (root (projectile-project-root)))
    (kill-new (message (replace-regexp-in-string root "" filename)))))
(let ((ghq-keymap (make-sparse-keymap)))
  (define-key ghq-keymap "h" 'ivy-ghq-open)
  (define-key ghq-keymap "g" 'ghq)
  ;; (define-key ghq-keymap "l" 'helm-ghq-list)
  (evil-leader/set-key "o q" ghq-keymap)
  (spacemacs/declare-prefix "o q" "ghq"))

;; (use-package helm-ghq)
(use-package ghq)
(defun sql-describe-line-or-region ()
  "Describes a line/region to the SQL process."
  (interactive)
  (let ((start (or (and (region-active-p) (region-beginning))
                   (line-beginning-position 1)))
        (end (or (and (region-active-p) (region-end))
                 (line-beginning-position 2))))
    (sql-send-string (concat "\\d " (buffer-substring-no-properties start end)))))

(defun sql-explain-line-or-region ()
  "EXPLAINs a line/region to the SQL process."
  (interactive)
  (let ((start (or (and (region-active-p) (region-beginning))
                   (line-beginning-position 1)))
        (end (or (and (region-active-p) (region-end))
                 (line-beginning-position 2))))
    (sql-send-string (concat "EXPLAIN " (buffer-substring-no-properties start end)))))

(defun sql-explain-line-or-region-and-focus ()
  "EXPLAINs a line/region to the SQL process, then goes to the SQL buffer."
  (interactive)
  (let ((sql-pop-to-buffer-after-send-region t))
    (sql-explain-line-or-region)
    (evil-insert-state)))

(defun sql-csv-copy-line-or-region (destination)
  "Copies a line/region from the SQL process to a CSV file."
  (interactive "GCopy to CSV file: ")
  (let ((start (or (and (region-active-p) (region-beginning))
                   (line-beginning-position 1)))
        (end (or (and (region-active-p) (region-end))
                 (line-beginning-position 2))))
    (sql-send-string (format "COPY (\n%s\n) TO STDOUT WITH CSV HEADER \\g '%s'" (buffer-substring-no-properties start end) destination))))

(defun sql-create-temp-view (viewname)
  "Creates a temporary view with `VIEWNAME' with the contents of the active region."
  (interactive "sView name: ")
  (let ((start (or (and (region-active-p) (region-beginning))
                   (line-beginning-position 1)))
        (end (or (and (region-active-p) (region-end))
                 (line-beginning-position 2))))
    (sql-send-string (format "CREATE TEMPORARY VIEW %s as (%s);" viewname (buffer-substring-no-properties start end)))))

(defun sql-create-temp-table (tablename)
  "Creates a temporary table with `TABLENAME' with the contents of the active region."
  (interactive "sTable name: ")
  (let ((start (or (and (region-active-p) (region-beginning))
                   (line-beginning-position 1)))
        (end (or (and (region-active-p) (region-end))
                 (line-beginning-position 2))))
    (sql-send-string (format "CREATE TEMPORARY TABLE %s as (%s);" tablename (buffer-substring-no-properties start end)))))

(defun dcl/sql-goto-end-of-buffer (&rest args)
  (with-current-buffer sql-buffer
    (goto-char (point-max))))

(advice-add 'sql-send-string
            :before
            #'dcl/sql-goto-end-of-buffer)
(let ((sql-keymap (make-sparse-keymap)))
  (define-key sql-keymap "d" 'sql-describe-line-or-region)
  (define-key sql-keymap "e" 'sql-explain-line-or-region)
  (define-key sql-keymap "E" 'sql-explain-line-or-region-and-focus)
  (define-key sql-keymap "c" 'sql-csv-copy-line-or-region)
  (define-key sql-keymap "v" 'sql-create-temp-view)
  (define-key sql-keymap "t" 'sql-create-temp-table)
  (evil-leader/set-key-for-mode 'sql-mode (kbd "o s") sql-keymap)
  (spacemacs/declare-prefix-for-mode 'sql-mode "mos" "REPL" "REPL"))
(add-hook 'sql-mode-hook 'dcl/sql-prettify-symbols)

(defun dcl/sql-prettify-symbols ()
  (mapc (lambda (pair) (push pair prettify-symbols-alist))
        '(
          ("union" . #x222a)
          ;; ("distinct" . (vector #x2203 #x0021 4 4))
          ("distinct" . (list '(Br . Bl) #x2203 #x0021))
          ("count" . #x23)
          ("null" . #x2205)
          ("left join" . #x27d5)
          ("right join" . #x27d6)
          ("inner join" . #x2229)))
  (prettify-symbols-mode 1))
(defun dcl-toggle-forge-sections ()
  (interactive)
  (if (or (-contains? magit-status-sections-hook 'forge-insert-pullreqs) (-contains? magit-status-sections-hook 'forge-insert-issues))
      (progn
        (remove-hook 'magit-status-sections-hook 'forge-insert-pullreqs)
        (remove-hook 'magit-status-sections-hook 'forge-insert-issues)
        (message "Forge sections off"))
    (progn
      (magit-add-section-hook 'magit-status-sections-hook 'forge-insert-pullreqs nil t)
      (magit-add-section-hook 'magit-status-sections-hook 'forge-insert-issues   nil t)
      (message "Forge sections on"))))

;;auto-modes
(add-to-list 'auto-mode-alist '("messages_ccodk_default.txt" . conf-javaprop-mode))
(add-to-list 'auto-mode-alist '("\\.grep\\'" . grep-mode))
(add-to-list 'auto-mode-alist '("\\.cljs\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.boot\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.aws-secrets\\'" . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.vagrantuser\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.irbrc\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.pryrc\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\spec.rb\\'" . rspec-mode))
(add-to-list 'auto-mode-alist '("\\.yml.example\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.cap\\'" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rb_trace\\'" . ruby-trace-mode))
(add-to-list 'auto-mode-alist '("\\.sequelizerc\\'" . js2-mode))

(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
(add-to-list 'auto-mode-alist '("\\.visidatarc\\'" . python-mode))

;; keybindings
(global-set-key (kbd "C-x C-b") #'ibuffer)

(spacemacs/set-leader-keys-for-major-mode 'typescript-mode "ots" 'dcl/toggle-ts-and-js-file)
(spacemacs/set-leader-keys-for-major-mode 'js2-mode "ots" 'dcl/toggle-ts-and-js-file)

;; configuration
(unless (fboundp 'html2text)
  (fset 'html2text (lambda () (shr-render-region (point-min) (point-max)))))
(setenv "PAGER" "/bin/cat")
(add-hook 'after-change-major-mode-hook 'dcl/favorite-text-scale)
;; (add-to-list 'purpose-user-mode-purposes '(enh-ruby-mode . ruby))
;; (add-to-list 'purpose-user-mode-purposes '(inf-ruby-mode . repl))
;; (add-to-list 'purpose-user-mode-purposes '(rspec-compilation-mode . compilation))
;; (purpose-compile-user-configuration)
(add-hook 'minibuffer-setup-hook 'dcl/minibuffer-setup)
(defalias 'display-buffer-in-major-side-window 'window--make-major-side-window)
(setq auth-sources '("~/.authinfo.gpg" "~/.authinfo" "~/.netrc"))
(with-eval-after-load 'org
  (setq org-babel-load-languages (remove '(scala . t) org-babel-load-languages))
  (add-to-list 'org-babel-load-languages '(calc . t)))
(defun dcl/disable-truncate-lines-in-magit-status ()
  (setq-local truncate-lines nil))

(add-hook 'magit-status-mode-hook 'dcl/disable-truncate-lines-in-magit-status)
(setq erc-join-buffer 'bury)
(setq erc-autojoin-channels-alist '(("freenode.net" "#emacs" "#offsec" "#corelan" "#ruby" "#RubyOnRails")))
(setq erc-prompt-for-password nil)
(setq erc-autojoin-timing 'ident)
(setq erc-nick "mondz")

(require 'erc-services)
(erc-services-mode 1)
(setq erc-prompt-for-nickserv-password nil)

(let* ((server "freenode.net")
       (source (auth-source-search :host server))
       (user (plist-get (car source ) :user))
       (passwd (plist-get (nth 0 source) :secret)))
  (setq erc-nickserv-passwords `(
                                 (freenode  ((,user . ,(if (functionp passwd) (funcall passwd) passwd)))))))
(setq winum-scope 'frame-local)
(add-hook 'git-commit-mode-hook 'dcl/set-fill-column-magit-commit-mode)

(add-hook 'magit-mode-hook 'dcl/set-local-evil-escape)

(setq git-link-open-in-browser nil)

(setq git-link-use-commit t)

;; (require 'magit-lfs)

(require 'magit)
(magit-wip-mode 1)

(magit-define-popup-action 'magit-log-popup ?w "WIP log" 'magit-wip-log)

(define-key magit-status-mode-map (kbd "#") 'forge-dispatch)

(setq magit-section-initial-visibility-alist '((untracked . hide)
                                               (stashes . hide)))
(add-hook 'prog-mode-hook #'whitespace-cleanup)
(setq inferior-lisp-program "/home/dancluna/code/sbcl/output")
(setq sly-lisp-implementations
      '((ecl ("ecl"))
        (sbcl ("/usr/bin/sbcl"))))
(dolist (hook '(lisp-mode-hook emacs-lisp-mode-hook clojure-mode-hook))
  (add-hook hook (lambda () (paredit-mode 1) (diminish 'paredit-mode " ⍢"))))
(add-hook 'lisp-mode-hook 'paredit-mode)
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)
(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
(add-hook 'clojure-mode-hook 'paredit-mode)
(add-hook 'clojure-mode-hook 'eldoc-mode)
(setq x86-lookup-pdf "~/Documents/books/Programming/64-ia-32-architectures-software-developer-instruction-set-reference-manual-325383.pdf") ;; asm-mode
(add-hook 'haskell-mode-hook 'intero-mode)
(add-hook 'sass-mode-hook 'rainbow-mode)
(add-hook 'ruby-mode-hook 'dcl/ruby-special-setup)
(add-hook 'enh-ruby-mode-hook 'dcl/ruby-special-setup)
(add-hook 'haml-mode-hook 'dcl/haml-special-setup)
(add-hook 'coffee-mode-hook 'dcl/coffee-special-setup)
(add-hook 'compilation-filter-hook 'inf-ruby-auto-enter)

;; (setup-rails-linters)

;; (load "~/code/rspec-mode/rspec-mode") ; I run a local version and this has some extra goodies

(setq inf-ruby-breakpoint-pattern "\\(\\[1\\] pry(\\)\\|\\(\\[1\\] haystack\\)\\|\\((rdb:1)\\)\\|\\((byebug)\\)")
(progn
  (dcl/add-env-toggle "POLTERGEIST_DEBUG" "p")
  (dcl/add-env-toggle "RUBY_PROF" "rp")
  (dcl/add-env-toggle "RUBY_PROF_MEASURE_MODE" "rm" (completing-read "Measure mode (default: wall): " '(wall process cpu allocations memory gc_time gc_runs)))
  (dcl/add-env-toggle "RUBY_BULLET" "rb")
  (dcl/add-env-toggle "RUBY_PROF_PROFILE_SPECS" "rs")
  (dcl/add-env-toggle "VCR_RERECORD" "rvr")
  (dcl/add-env-toggle "REAL_REQUESTS" "rvq")
  (dcl/add-env-toggle "IM_BATSHIT_CRAZY" "rkc")
  (dcl/add-env-toggle "RSPEC_RETRY_RETRY_COUNT" "rtc")
  (dcl/add-env-toggle "CAPYBARA_TIMEOUT" "rc" (number-to-string (read-number "New Capybara timeout (secs): ")))
  (dcl/add-env-toggle "ADWORDS_TIMEOUT" "rat" (number-to-string (read-number "New Adwords gem timeout (secs): "))))
;; (defcustom run-auto-rubocop nil "Runs Rubocop on every save" :type 'boolean :group 'rubocop)

(setq rubocop-autocorrect-on-save t)

;; (defun dcl-rubocop-silent ()
;;   (when (and run-auto-rubocop (memq major-mode '(enh-ruby-mode ruby-mode)))
;;     (save-window-excursion (rubocop-autocorrect-current-file))))

;; (add-hook 'enh-ruby-mode-hook 'dcl-rubocop-silent)

;; (spacemacs|add-toggle run-auto-rubocop :status run-auto-rubocop :on (setq-local run-auto-rubocop t) :off (setq-local run-auto-rubocop nil))

(spacemacs|add-toggle rubocop-autocorrect-on-save :status rubocop-autocorrect-on-save :on (setq-local rubocop-autocorrect-on-save t) :off (setq-local rubocop-autocorrect-on-save nil))
(defun dcl-rubocop-disable-errors-at-point ()
  "Disables Rubocop error at point."
  (interactive)
  (let* ((errors (mapcar 'flycheck-error-id (flycheck-overlay-errors-at (point)))))
    (comment-dwim nil)
    (insert (concat "rubocop:disable " (mapconcat 'identity errors ", ")))))
;; (add-hook 'enh-ruby-mode-hook 'rufo-minor-mode)
(setq inf-ruby-default-implementation "pry")
(setq rbenv-executable "/usr/local/bin/rbenv")
(defgroup rails-custom nil
  "Group for my custom Rails settings")

(defcustom vcr-record-mode-var
  "VCR_RECORD_MODE"
  "Environment variable to be used to set the record mode. Customize it on a per-project basis."
  :type 'string
  :group 'rails-custom)

(defun vcr/set-record-mode-in-env (record-mode)
  (interactive (list (completing-read "Record mode: " '("unset" "all" "none" "once" "new_episodes") nil t)))
  (if (equal record-mode "unset")
      (setenv vcr-record-mode-var nil)
    (setenv vcr-record-mode-var record-mode)))
(setq rust-format-on-save t)
;; (require 'indium)
;; (add-hook 'js2-mode-hook #'indium-interaction-mode)
;; (require 'yarn)
(defun dcl-json-setup ()
  (setq-local web-beautify-js-program "jsonpp")
  (setq-local web-beautify-args '()))

(add-hook 'json-mode-hook 'dcl-json-setup)
(add-hook 'js2-mode-hook 'dcl-json-setup)

(setq nov-text-width 200)
(defadvice slack-start (before load-slack-teams)
  (unless slack-teams (load-file "~/.slack-teams.el.gpg")))
(defun dcl/load-sql-connections ()
  (interactive)
  (load-file (expand-file-name "~/.ghq/github.com/dcluna/dotfiles/sql-connections.el.gpg")))

(if (fboundp 'sqlformat-on-save-mode)
    (add-hook 'sql-mode-hook 'sqlformat-on-save-mode))

(dcl/load-sql-connections)
(evil-define-key 'normal global-map ";" 'evil-execute-in-god-state)
(evil-define-key 'god global-map [escape] 'evil-god-state-bail)
(add-hook 'org-mode-hook 'auto-fill-mode)
(unless (boundp 'org-latex-classes)
  (setq org-latex-classes '()))

(add-to-list 'org-latex-classes '("awesomecv" "\\documentclass[12pt,a4paper,sans,unicode]{awesome-cv}"
                                  ("\\lettersection{%s}" . "\\lettersection*{%s}")))

(add-to-list 'org-latex-classes '("moderncv" "\\documentclass[12pt,a4paper,sans,unicode]{moderncv}"
                                  ("\\section{%s}" . "\\section*{%s}")
                                  ("\\cvitem{%s}" . "\\cvitem{%s}")))
(dcl/enable-emacspeak)
(add-hook 'conf-javaprop-mode-hook '(lambda () (conf-quote-normal nil)))
;; (helm-mode 1) ;; for some reason, all the describe-* goodness is not working with Spacemacs v.0.103.2 unless I add this line
;; (defvar auto-insert-major-modes '(enh-ruby-mode ruby-mode))

;; (defun auto-insert-on-modes ()
;;   (if (-contains? auto-insert-major-modes major-mode)
;;       (auto-insert)))

(use-package autoinsert
  :init (progn
          ;; (add-hook 'find-file-hook 'auto-insert-on-modes)
          ;; (auto-insert-mode 1)
          ))

(eval-after-load 'autoinsert
    '(progn
       (setq auto-insert-query nil)
       ;; <<custom-auto-inserts>>
       ))
(require 'yasnippet-snippets)
(yasnippet-snippets-initialize)

(defvar dcl-yas-snippets-dir (expand-file-name "yasnippets" "~/") "Personal yasnippets directory")
(setq yas--default-user-snippets-dir dcl-yas-snippets-dir)
(add-to-list 'yas-snippet-dirs dcl-yas-snippets-dir)
;; (add-hook 'yas-before-expand-snippet-hook 'evil-normal-state)
(setq aya-persist-snippets-dir dcl-yas-snippets-dir)
(let ((custom-yas-keymap (make-sparse-keymap)))
  (define-key custom-yas-keymap "i" 'yas-insert-snippet)
  (evil-leader/set-key "o y" custom-yas-keymap)
  (spacemacs/declare-prefix "o y" "yasnippets"))
(eval-after-load 'mode-local
  '(progn
    (setq-mode-local ruby-mode yas-also-auto-indent-first-line t)
    (setq-mode-local enh-ruby-mode yas-also-auto-indent-first-line t)))
(add-to-list 'load-path "/usr/share/emacs/site-lisp/nethack")

;; (require 'nethack)

(setq nethack-program "nethack-lisp")

(add-to-list 'evil-emacs-state-modes 'nh-map-mode)
(add-to-list 'evil-emacs-state-modes 'nh-menu-mode)
(let ((multishell-keymap (make-sparse-keymap)))
  (define-key multishell-keymap "s" 'multishell-pop-to-shell)
  (define-key multishell-keymap "l" 'multishell-list)
  (evil-leader/set-key "o s" multishell-keymap)
  (spacemacs/declare-prefix "o s" "multishell"))
(require 'vlf-setup)
(require 'vlf)
(evil-leader/set-key "o v" vlf-mode-map)
(spacemacs/declare-prefix "o v" "vlf")
(add-to-list 'auto-minor-mode-alist '("spec\/factories\/.*\.rb$" . rspec-mode))
(add-to-list 'auto-minor-mode-alist '("data.org.gpg$" . read-only-mode))
(add-to-list 'auto-minor-mode-alist '("\.s[ac]ss$" . indent-guide-mode))
(define-key evil-motion-state-map "g]" 'evil-jump-to-tag)
(evil-global-set-key 'normal (kbd "K") 'newline-and-indent)
(evil-global-set-key 'normal (kbd "g b") 'browse-url-at-point)

(add-hook 'anaconda-mode-hook (lambda ()
                                (evil-global-set-key 'normal (kbd "C-,") 'pop-tag-mark)))

(evil-leader/set-key "g d" 'magit-diff-staged)

(evil-leader/set-key "g u" 'magit-set-tracking-upstream)
(evil-leader/set-key "g U" 'magit-unset-tracking-upstream)
(evil-leader/set-key "o g P c" 'endless/visit-pull-request-url)
(evil-leader/set-key "o g y" 'github/copy-branch-url)
(evil-leader/set-key "o g Y" 'github/copy-file-url)
(evil-leader/set-key "o g p" 'dcl/create-branch-from-pivotal)
(evil-leader/set-key "o g j" 'dcl/create-branch-from-jira)
(evil-leader/set-key "o g b" 'dcl/magit-checkout-last-branch)
(evil-leader/set-key "o g r" 'dcl/magit-branch-rebase)
(evil-leader/set-key "o g h" 'magit-history-checkout)
(evil-leader/set-key "o g l" 'magit-lfs)
;; (evil-leader/set-key "o p t" 'dcl/pivotal-github-tasks-template)
;; (evil-leader/set-key "o l !" 'dcl/evil-ex-run-current-line)
(evil-leader/set-key "o n c" '0xc-convert)
(evil-leader/set-key "o a" 'ascii-display)
(evil-leader/set-key "o h h" 'howdoi-query)
(evil-leader/set-key "o h t" 'tldr)
;; (evil-leader/set-key "o s" 'embrace-commander)
;; (evil-leader/set-key "o s" 'multishell-pop-to-shell)
(evil-leader/set-key "o p y" 'dcl/project-relative-path)

(spacemacs/set-leader-keys-for-major-mode 'python-mode "sp" 'python-shell-print-line-or-region)
(spacemacs/set-leader-keys-for-major-mode 'ruby-mode "sl" 'ruby-eval-line)
(spacemacs/set-leader-keys-for-major-mode 'enh-ruby-mode "sl" 'ruby-eval-line)
(spacemacs/set-leader-keys-for-major-mode 'eshell-mode "ob" 'dcl/eshell-pipe-to-buffer)
(spacemacs/set-leader-keys-for-major-mode 'eshell-mode "os" 'dcl/eshell-circleci-ssh-to-tramp)
(spacemacs/set-leader-keys-for-major-mode 'js2-mode "otp" 'mocha-test-at-point)
(spacemacs/set-leader-keys-for-major-mode 'js2-mode "otf" 'mocha-test-file)
(spacemacs/set-leader-keys-for-major-mode 'js2-mode "odp" 'mocha-debug-at-point)
(spacemacs/set-leader-keys-for-major-mode 'js2-mode "odf" 'mocha-debug-file)

(spacemacs/set-leader-keys-for-major-mode 'org-mode "oy" 'org-rich-yank)

(evil-leader/set-key-for-mode 'js2-mode "msr" 'skewer-eval-region)

(evil-embrace-enable-evil-surround-integration)

(add-to-list 'evil-normal-state-modes 'erc-mode)

(evil-ex-define-cmd "slow[pokemode]" 'dcl/filip-slowpoke)
(evil-ex-define-cmd "fast[pokemode]" 'dcl/normal-delay)

(defun dcl-revert-buffer ()
  (interactive)
  (revert-buffer nil t))

(evil-ex-define-cmd "rev" 'dcl-revert-buffer)

(add-to-list 'evil-emacs-state-modes 'indium-debugger-mode)
(spacemacs/set-leader-keys-for-major-mode 'typescript-mode "otn" 'dcl/run-nightwatch-test)
(spacemacs/set-leader-keys-for-major-mode 'typescript-mode "otp" 'ts-mocha-test-at-point)
(spacemacs/set-leader-keys-for-major-mode 'typescript-mode "otf" 'ts-mocha-test-file)
(spacemacs/set-leader-keys-for-major-mode 'typescript-mode "odp" 'ts-mocha-debug-at-point)
(spacemacs/set-leader-keys-for-major-mode 'typescript-mode "odf" 'ts-mocha-debug-file)
;; yarn
(let ((yarn-keymap (make-sparse-keymap)))
  (define-key yarn-keymap "a" 'yarn-add)
  (define-key yarn-keymap "D" 'yarn-add-dev)
  (define-key yarn-keymap "r" 'yarn-remove)
  (define-key yarn-keymap "l" 'yarn-ls)
  (define-key yarn-keymap "L" 'yarn-link)
  (define-key yarn-keymap "p" 'yarn-link-package)
  (define-key yarn-keymap "n" 'yarn-unlink)
  (define-key yarn-keymap "i" 'yarn-install)
  (define-key yarn-keymap "I" 'yarn-info)
  (define-key yarn-keymap "u" 'yarn-upgrade)
  (define-key yarn-keymap "w" 'yarn-why)
  (spacemacs/set-leader-keys-for-major-mode 'typescript-mode "oy" yarn-keymap)
  (spacemacs/declare-prefix-for-mode 'typescript-mode "moy" "yarn"))
(let ((helpful-keymap (make-sparse-keymap)))
  (define-key helpful-keymap "f" 'helpful-callable)
  (define-key helpful-keymap "v" 'helpful-variable)
  (define-key helpful-keymap "p" 'helpful-at-point)
  (define-key helpful-keymap "k" 'helpful-key)
  (define-key helpful-keymap "F" 'helpful-function)
  (define-key helpful-keymap "C" 'helpful-command)
  (spacemacs/set-leader-keys "oH" helpful-keymap)
  (spacemacs/declare-prefix "oH" "helpful"))
(let ((comint-search-keymap (make-sparse-keymap))
      (modes '(shell-mode comint-mode)))
  (define-key comint-search-keymap "h" 'helm-comint-input-ring)
  (dolist (mode modes)
    (spacemacs/set-leader-keys-for-major-mode mode "os" comint-search-keymap)
    (spacemacs/declare-prefix-for-mode mode "mos" "comint-search")))
(add-to-list 'load-path "~/.ghq/github.com/dcluna/dotfiles/elisp/")

(if (file-exists-p "~/.ghq/github.com/dcluna/dotfiles/elisp/loaddefs.el")
    (load-file "~/.ghq/github.com/dcluna/dotfiles/elisp/loaddefs.el"))
(let ((dired-mode-visidata-keymap (make-sparse-keymap)))
  (define-key dired-mode-visidata-keymap "n" 'tmux-utils/visidata-open-files-in-new-windows)
  (define-key dired-mode-visidata-keymap "a" 'tmux-utils/visidata-open-all-in-new-window)
  (evil-leader/set-key-for-mode 'dired-mode "ov" dired-mode-visidata-keymap)
  (spacemacs/declare-prefix-for-mode 'dired-mode "ov" "visidata"))
(setq projectile-tags-command "/usr/local/bin/ctags -Re -f \"%s\" %s")
(defvar yas-projectile-local-dir ".yasnippets" "Directory name for project-local yasnippets.")

(defun yas-projectile-local-dir ()
  "Returns the top-level projectile local directory."
  (format "%s%s" (projectile-project-root) yas-projectile-local-dir))

(defun yas-load-local-projectile-dir ()
  "Loads yasnippets under `yas-projectile-local-dir' for the current project."
  (interactive)
  (let* ((local-dir (yas-projectile-local-dir)))
    (yas-load-directory local-dir)
    (message "Loaded snippets under %s" local-dir)))

(defun dcl/maybe-call-yas-with-local-source-and-set-snippet-dirs (original-function &rest args)
  (aif (and (y-or-n-p (format "Use local %s directory?" yas-projectile-local-dir)) (projectile-project-p))
      (lexical-let ((yas-snippet-dirs (cons (message (format "%s%s" it yas-projectile-local-dir)) yas-snippet-dirs)))
        (apply original-function args)
        (setq-local yas-snippet-dirs yas-snippet-dirs))
    (apply original-function args)))

(mapc
 (lambda (fn)
   (advice-add fn :around 'dcl/maybe-call-yas-with-local-source-and-set-snippet-dirs))
 (list 'yas-new-snippet))
(use-package direnv
  :config
  (direnv-mode))
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))
(defun helm-comint-input-ring-action (candidate)
  "Default action for comint history."
  (with-helm-current-buffer
    (set-register ?h candidate)))
(eval-after-load 'gif-screencast
  '(progn
     (evil-ex-define-cmd "gifstart" 'gif-screencast)
     (evil-ex-define-cmd "gifpause" 'gif-screencast-toggle-pause)
     (evil-ex-define-cmd "gifstop" 'gif-screencast-stop)))
(with-eval-after-load 'gif-screencast
  (setq gif-screencast-args '("-x")) ;; To shut up the shutter sound of `screencapture' (see `gif-screencast-command').
  (setq gif-screencast-cropping-program "mogrify") ;; Optional: Used to crop the capture to the Emacs frame.
  (setq gif-screencast-capture-format "ppm")) ;; Optional: Required to crop captured images.
;; (add-to-list 'custom-theme-load-path "~/.emacs.d/straight/repos/cyberpunk-2019/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/straight/repos/Emacs-Tron-Legacy-Theme/")
(push
 '("DEPRECATED" . "#cc9393")
 hl-todo-keyword-faces)
(with-eval-after-load 'time
  (setq display-time-world-list (append zoneinfo-style-world-list '(("Etc/GMT0" "UTC")))))
(setq wakatime-api-key (getenv "WAKATIME_API_KEY"))
(setq wakatime-cli-path "/usr/local/bin/wakatime")
(progn
  (require 'emamux)
  (evil-leader/set-key "o e" emamux:keymap)
  (define-key emamux:keymap "r" #'emamux:send-region)
  (define-key emamux:keymap "s" #'emamux:send-command)
  (define-key emamux:keymap "w" #'emamux:new-window)
  (define-key emamux:keymap "z" #'emamux:zoom-runner)
  (define-key emamux:keymap "j" #'vterm-tmux-navigator/vterm-navigate-down)
  (define-key emamux:keymap "k" #'vterm-tmux-navigator/vterm-navigate-up)
  (define-key emamux:keymap "h" #'vterm-tmux-navigator/vterm-navigate-left)
  (define-key emamux:keymap "l" #'vterm-tmux-navigator/vterm-navigate-right)
  (define-key emamux:keymap "H" #'vterm-tmux-navigator/vterm-navigate-left-window)
  (define-key emamux:keymap "L" #'vterm-tmux-navigator/vterm-navigate-right-window)
  (spacemacs/declare-prefix "o e" "emamux"))
(require 'evil-vterm-tmux-navigator)
(define-key emamux:keymap "n" #'evil-vterm-tmux-navigator-state)
(setq popper-keymap (make-sparse-keymap))
(use-package popper
  :ensure t ; or :straight t
  :bind (:map popper-keymap
              ("l"   . popper-toggle-latest)
              ("c"   . popper-cycle)
              ("t" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          "\\*Async Shell Command\\*"
          help-mode
          compilation-mode
          rspec-compilation-mode
          inf-ruby-mode
          inferior-python-mode))
  (popper-mode +1)
  (popper-echo-mode +1))                ; For echo area hints
(evil-leader/set-key "o p" popper-keymap)
(spacemacs/declare-prefix "o p" "popper")
(defun spacemacs/vterm-send-string (termno)
  "Sends STRINGS to TERMNO vterm buffer."
  (interactive "p")
  (let* ((start (or (and (region-active-p) (region-beginning)
                         (line-beginning-position 1))))
         (end (or (and (region-active-p) (region-end)
                       (line-beginning-position 2))))
         (strings (buffer-substring-no-properties start end)))
    (save-excursion
      (spacemacs/shell-pop-vterm termno)
      (vterm-insert strings)
      (vterm-send-return))))
      ;; (mapc (lambda (str)
      ;;        (vterm-insert str
      ;;            (vterm-send-return)
      ;;            strings))))))
(define-key emamux:keymap "v" #'spacemacs/vterm-send-string)
;; (use-package org-tanglesync
;;   :hook ((org-mode . org-tanglesync-mode)
;;          ;; enable watch-mode globally:
;;          ((prog-mode text-mode) . org-tanglesync-watch-mode))
;;   :custom
;;   (org-tanglesync-watch-files '("/Users/danielluna/Projects/AdQuick/notes.org.gpg")))
(setq org-roam-directory (file-truename "~/.ghq/github.com/dcluna/dotfiles/org-roam"))
(setq org-roam-v2-ack t)
(use-package org-roam-ui
  :straight
  (:host github :repo "org-roam/org-roam-ui" :branch "main" :files ("*.el" "out"))
  :after org-roam
  ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;         a hookable mode anymore, you're advised to pick something yourself
  ;;         if you don't care about startup time, use
  ;; :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))
(add-to-list 'load-path "/usr/local/Cellar/mdk/1.3.0/share/mdk/")

(autoload 'mixal-mode "mixal-mode" t)
(add-to-list 'auto-mode-alist '("\\.mixal\\'" . mixal-mode))

(autoload 'mixvm "mixvm" "mixvm/gud interaction" t)

;; genome-related stuff. I added it inside this function because spacemacs doesn't like literate files too much.
