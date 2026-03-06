;;; Directory Local Variables         -*- no-byte-compile: t; -*-
;;; For more information see (info "(emacs) Directory Variables")

((ruby-mode . ((eval . (setq projectile-rails-custom-console-command
                             (let ((project-name (file-name-nondirectory
                                                  (directory-file-name
                                                   (locate-dominating-file default-directory "Gemfile")))))
                               (format "vagrant ssh -c \"cd /vagrant/%s && direnv exec . bundle exec rails c\"" project-name))))
               (robe-ruby-path . "/vagrant/.robe-lib")
               (robe-port . "33315")
               (eval . (setq inf-ruby-first-prompt-pattern
                             (concat "\\("
                                     "^\\([[0-9]+] \\)?"
                                     "\\(?:"
                                     "[a-z0-9_-]+([a-z0-9_-]+)"  ; Rails 7+: project(env)
                                     "\\|"
                                     "irb([^)]+)"                ; IRB default
                                     "\\|"
                                     "\\(?:[Pp]ry ?\\)([^)]+)"   ; Pry
                                     "\\)"
                                     " ?[0-9:]* ?> *"
                                     "\\)")))
               (eval . (setq inf-ruby-prompt-pattern
                             (concat "\\("
                                     "^\\([[0-9]+] \\)?"
                                     "\\(?:"
                                     "[a-z0-9_-]+([a-z0-9_-]+)"
                                     "\\|"
                                     "irb([^)]+)"
                                     "\\|"
                                     "\\(?:[Pp]ry ?\\)([^)]+)"
                                     "\\)"
                                     " ?[0-9:]* ?[\\]>*\"'/`] *"
                                     "\\)")))
               (eval . (setq inf-ruby-breakpoint-pattern
                             "\\[[0-9]+\\] [a-z0-9_-]+(#<[^>]+>)> *"))
               (rspec-use-vagrant-when-possible . t)
               (eval . (setq rspec-vagrant-cwd
                             (format "/vagrant/%s/"
                                     (file-name-nondirectory
                                      (directory-file-name
                                       (locate-dominating-file default-directory "Gemfile"))))))
               (eval . (progn
                         (defun vagrant-devenv-api--rspec-vagrant-p-advice (orig-fn)
                           "Look for Vagrantfile in parent directories, not just project root."
                           (and rspec-use-vagrant-when-possible
                                (locate-dominating-file default-directory "Vagrantfile")))
                         (advice-add 'rspec-vagrant-p :around
                                     #'vagrant-devenv-api--rspec-vagrant-p-advice)))
               (eval . (progn
                         (defun vagrant-devenv-api--rspec-vagrant-wrapper-advice (orig-fn command)
                           "Inject direnv exec . into rspec command inside Vagrant."
                           (if (rspec-vagrant-p)
                               (format "vagrant ssh -c 'cd %s; direnv exec . %s'"
                                       (shell-quote-argument rspec-vagrant-cwd)
                                       command)
                             (funcall orig-fn command)))
                         (advice-add 'rspec--vagrant-wrapper :around
                                     #'vagrant-devenv-api--rspec-vagrant-wrapper-advice)))
               (robe-vagrant-path-mappings . (("/vagrant/api/" . "/Users/danielluna/Projects/vagrant-devenv/api/")
                                              ("/vagrant/frontend/" . "/Users/danielluna/Projects/vagrant-devenv/frontend/")))
               (eval . (progn
                         (defun vagrant-devenv--translate-robe-path (file)
                           "Translate a Vagrant VM file path to the corresponding host path.
Uses `robe-vagrant-path-mappings' alist to find a matching prefix."
                           (if (and (boundp 'robe-vagrant-path-mappings) robe-vagrant-path-mappings)
                               (let ((mappings robe-vagrant-path-mappings)
                                     (result file))
                                 (while mappings
                                   (let* ((mapping (car mappings))
                                          (vm-prefix (car mapping))
                                          (host-prefix (cdr mapping)))
                                     (when (string-prefix-p vm-prefix file)
                                       (setq result (concat host-prefix (substring file (length vm-prefix)))
                                             mappings nil)))
                                   (setq mappings (cdr mappings)))
                                 result)
                             file))
                         (defun vagrant-devenv--robe-doc-format-file-name-advice (orig-fn file)
                           "Translate VM path to host path before formatting for robe-doc display."
                           (funcall orig-fn (vagrant-devenv--translate-robe-path file)))
                         (advice-add 'robe-doc-format-file-name :around
                                     #'vagrant-devenv--robe-doc-format-file-name-advice)
                         (defun vagrant-devenv--robe-find-file-advice (orig-fn file &rest args)
                           "Translate VM path to host path before opening the file."
                           (apply orig-fn (vagrant-devenv--translate-robe-path file) args))
                         (advice-add 'robe-find-file :around
                                     #'vagrant-devenv--robe-find-file-advice)))
               (eval . (progn
                         (defun vagrant-devenv-api--irb-needs-nomultiline-p-advice (orig-fn &rest args)
                           "Skip `inf-ruby--irb-needs-nomultiline-p' unless using IRB (ruby/yarv)."
                           (if (member inf-ruby-default-implementation '("ruby" "yarv"))
                               (apply orig-fn args)
                             nil))
                         (advice-add 'inf-ruby--irb-needs-nomultiline-p :around
                                     #'vagrant-devenv-api--irb-needs-nomultiline-p-advice)))
               (eval . (progn
                         (defun vagrant-devenv-api--bundle-command-advice (orig-fn cmd)
                           "Wrap bundle-command to run inside the Vagrant container.
When called with a prefix argument (C-u), prompt whether to use Vagrant."
                           (let ((vagrantfile-dir (locate-dominating-file default-directory "Vagrantfile")))
                             (if (and vagrantfile-dir
                                      (or (not current-prefix-arg)
                                          (y-or-n-p "Run inside Vagrant? ")))
                                 (let* ((project-name (file-name-nondirectory
                                                       (directory-file-name
                                                        (locate-dominating-file default-directory "Gemfile"))))
                                        (default-directory vagrantfile-dir)
                                        (vagrant-cmd (format "vagrant ssh -c \"cd /vagrant/%s && %s\""
                                                             project-name
                                                             (replace-regexp-in-string "\"" "\\\\\"" cmd))))
                                   (funcall orig-fn vagrant-cmd))
                               (funcall orig-fn cmd))))
                         (advice-add 'bundle-command :around
                                     #'vagrant-devenv-api--bundle-command-advice))))))
