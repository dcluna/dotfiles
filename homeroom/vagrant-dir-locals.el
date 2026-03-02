;;; Directory Local Variables         -*- no-byte-compile: t; -*-
;;; For more information see (info "(emacs) Directory Variables")

((ruby-mode . ((projectile-rails-custom-console-command . "vagrant ssh -c \"cd /vagrant/api && bundle exec rails c\"")
               (robe-ruby-path . "/vagrant/.robe-lib")
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
               (eval . (progn
                         (defun vagrant-devenv-api--bundle-command-advice (orig-fn cmd)
                           "Wrap bundle-command to run inside the Vagrant container."
                           (let ((vagrantfile-dir (locate-dominating-file default-directory "Vagrantfile")))
                             (if vagrantfile-dir
                                 (let ((default-directory vagrantfile-dir)
                                       (vagrant-cmd (format "vagrant ssh -c \"cd /vagrant/api && %s\""
                                                            (replace-regexp-in-string "\"" "\\\\\"" cmd))))
                                   (funcall orig-fn vagrant-cmd))
                               (funcall orig-fn cmd))))
                         (advice-add 'bundle-command :around
                                     #'vagrant-devenv-api--bundle-command-advice))))))
