;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   ;; List of configuration layers to load. If it is the symbol `all' instead
   ;; of a list then all discovered layers will be installed.
   dotspacemacs-configuration-layers
   '(rust
     windows-scripts
     (mu4e :variables mu4e-installation-path "~/code/mu/mu4e" mu4e-maildir "~/.StackBuildersMaildir")
     ;; (elfeed :variables rmh-elfeed-org-files (list "~/.elfeed-list.org"))
     slack
      (ranger :variables ranger-show-preview t ranger-cleanup-on-disable t ranger-ignored-extensions '("mkv" "iso" "mp4") ranger-max-preview-size 10)
     ;; pdf-tools
     chrome
     vim-empty-lines
     asm
     octave
     csv
     erc
     docker
     ;; ansible
     vimscript
     sonic-pi
     ;; eyebrowse
     prodigy
     c-c++
     search-engine
     haskell
     dash
     vagrant
     tmux
     selectric
     html
     shell-scripts
     racket
     php
     elixir
     erlang
     (evil-snipe :variables evil-snipe-enable-alternate-f-and-t-behaviors t)
     restclient
     yaml
     ruby-on-rails
     evil-cleverparens
     evil-commentary
     syntax-checking
     (auto-completion :variables auto-completion-enable-help-tooltip t auto-completion-enable-sort-by-usage t auto-completion-enable-snippets-in-popup t)
     ;; angularjs
     sql
     scheme
     ;; personal-misc
     (git :variables git-enable-github-support t git-gutter-use-fringe t)
     markdown
     html
     (typescript :variables
                 typescript-fmt-on-save t
                 typescript-fmt-tool 'tide)
     ( javascript :variables
                  js-indent-level 2)
     (python :variables python-test-runner '(nose pytest))
     (ruby :variables ruby-enable-enh-ruby-mode t)
     (clojure :variables clojure-enable-fancify-symbols t)
     go
     evernote
     (colors :variables colors-colorize-identifiers 'all)
     theming
     themes-megapack
     ;; python-extra
     ;; groovy
     common-lisp
     lua
     go
     github
     (org :variables org-enable-github-support t org-enable-reveal-js-support t)
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press <SPC f e R> (Vim style) or
     ;; <M-m f e R> (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     ;; auto-completion
     ;; better-defaults
     emacs-lisp
     ;; git
     ;; markdown
     ;; org
     (shell :variables
            shell-default-height 30
            shell-default-position 'bottom)
     ;; spell-checking
     ;; syntax-checking
     version-control
     )
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages then consider to create a layer, you can also put the
   ;; configuration in `dotspacemacs/config'.
   dotspacemacs-additional-packages `(
                                      ;; (eziam-theme
                                      ;;  :location (recipe :repo "thblt/eziam-theme-emacs"
                                      ;;                    :fetcher github
                                      ;;                    :files ("*.el"))
                                      ;;  :upgrade 't)
                                      ;; epkg
                                      ;; (Epkg :location (recipe :fetcher file :path "~/code/epkg/"))
                                      ;; (borg :location (recipe :fetcher file :path "~/code/borg/"))
                                      labburn-theme
                                      evil-rails
                                      evil-easymotion
                                      evil-extra-operator
                                      znc
                                      ox-jira
                                      realgud
                                      ;; realgud-pry
                                      plan9-theme
                                      sourcerer-theme
                                      0xc
                                      fuel
                                      lfe-mode
                                      x-path-walker
                                      pivotal-tracker
                                      suggest
                                      tramp-term
                                      dark-mint-theme
                                      (meme
                                       :location (recipe :repo "larsmagne/meme"
                                                         :fetcher github
                                                         :files ("*"))
                                       :upgrade 't)
                                      yagist
                                      sage-shell-mode
                                      intero
                                      (mocha :location (recipe :fetcher file :path "/home/dancluna/code/mocha.el"))
                                      howdoi
                                      ascii
                                      rainbow-mode
                                      paredit
                                      ruby-refactor
                                      shen-mode
                                      nvm
                                      nov
                                      yarn-mode
                                      (indium :location (recipe :fetcher file :path "/home/dancluna/code/Indium")
                                              :upgrade 't)
                                      package-lint
                                      flycheck-package
                                      ;; doom-themes
                                      ,(dcl/local-package 'rspec-mode)
                                      ;; (yasnippet-ruby-mode
                                      ;;  :location (recipe :repo "bmaland/yasnippet-ruby-mode"
                                      ;;                    :fetcher github
                                      ;;                    :files ("*.el")))
                                      ;; ,(dcl/local-package 'flycheck)
                                      (exercism
                                       :location (recipe :repo "canweriotnow/exercism-emacs"
                                                         :fetcher github
                                                         :files ("*.el"))
                                       :upgrade 't)
                                      (reek
                                       :location (recipe :repo "hanmoi-choi/reek-emacs"
                                                         :fetcher github
                                                         :files ("*.el"))
                                       :upgrade 't)
                                      (shen-elisp
                                       :location (recipe :repo "deech/shen-elisp"
                                                         :fetcher github
                                                         :files ("shen*.el"))
                                       :upgrade 't)
                                      ;; (pmd :location "/home/dancluna/code-of-mine/pmd-el")
                                      (pmd :location (recipe :fetcher file :path "/home/dancluna/code-of-mine/pmd-el"))
                                      ;; (pmd
                                      ;;  :location (recipe :repo "dcluna/pmd.el"
                                      ;;                    :fetcher github
                                      ;;                    :files ("*.el")))
                                      (yarn.el :location "/home/dancluna/code/yarn.el/")
                                      ,(dcl/local-package 'sass-mode)
                                      ;; ,(dcl/local-package 'magit)
                                      ;; (sass-mode :location (recipe :fetcher github :repo "dcluna/sass-mode"))
                                      ;; (embrace :location (recipe :fetcher github :repo "dcluna/embrace.el"))
                                      evil-embrace
                                      ;; floobits
                                      ;; lispyville ;; not yet available as of Thu Apr 21 18:32:36 BRT 2016
                                      editorconfig
                                      ,(dcl/local-package 'stock-ticker)
                                      wsd-mode
                                      )
   ;; A list of packages and/or extensions that will not be install and loaded.
   dotspacemacs-excluded-packages '()
   ;; If non-nil spacemacs will delete any orphan packages, i.e. packages that
   ;; are declared in a layer which is not a member of
   ;; the list `dotspacemacs-configuration-layers'. (default t)
   dotspacemacs-delete-orphan-packages t))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; One of `vim', `emacs' or `hybrid'. Evil is always enabled but if the
   ;; variable is `emacs' then the `holy-mode' is enabled at startup. `hybrid'
   ;; uses emacs key bindings for vim's insert mode, but otherwise leaves evil
   ;; unchanged. (default 'vim)
   dotspacemacs-editing-style 'hybrid
   ;; If non nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading t
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'random
   ;; List of items to show in the startup buffer. If nil it is disabled.
   ;; Possible values are: `recents' `bookmarks' `projects'.
   ;; (default '(recents projects))
   dotspacemacs-startup-lists '(recents projects bookmarks)
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes (dcl/shuffle (if (display-graphic-p)
                                        '(
                                          ;; tron
                                          ;; eziam-dark
                                          ;; eziam-light
                                          seti
                                          sanityinc-tomorrow-eighties
                                          sanityinc-solarized-light
                                          sanityinc-tomorrow-bright
                                          sanityinc-tomorrow-day
                                          sanityinc-tomorrow-blue
                                          sanityinc-tomorrow-night
                                          majapahit-light
                                          plan9
                                          labburn
                                          sourcerer
                                          alect-light
                                          moe-light
                                          ;; doom-dark
                                          doom-one
                                          granger
                                          dark-mint
                                          mccarthy
                                          material
                                          heroku
                                          light-blue
                                          spacemacs-dark
                                          spacemacs-light
                                          solarized-light
                                          solarized-dark
                                          leuven
                                          monokai
                                          zenburn
                                          alect-dark-alt
                                          ample-zen
                                          badwolf
                                          birds-of-paradise-plus
                                          brin
                                          bubbleberry
                                          cherry-blossom
                                          cyberpunk
                                          clues
                                          darkmine
                                          deeper-blue
                                          farmhouse-dark
                                          gruvbox
                                          junio
                                          noctilux
                                          subatomic
                                          purple-haze
                                          ritchie
                                          zonokai-red
                                          )
                                      '(
                                        plan9
                                        ritchie
                                        leuven
                                        alect-light
                                        moe-light
                                        sourcerer
                                        clues
                                        noctilux
                                        badwolf
                                        material
                                        spacemacs-dark
                                        gruvbox
                                        monokai)))
   ;; If non nil the cursor color matches the state color.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font. `powerline-scale' allows to quickly tweak the mode-line
   ;; size to make separators look not too crappy.
   dotspacemacs-default-font '("Source Code Pro"
                               :size 13
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)
   ;; The leader key
   dotspacemacs-leader-key "SPC"
   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m)
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   ;; The command key used for Evil commands (ex-commands) and
   ;; Emacs commands (M-x).
   ;; By default the command key is `:' so ex-commands are executed like in Vim
   ;; with `:' and Emacs commands are executed with `<leader> :'.
   dotspacemacs-command-key "SPC"
   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache
   ;; If non nil then `ido' replaces `helm' for some commands. For now only
   ;; `find-files' (SPC f f), `find-spacemacs-file' (SPC f e s), and
   ;; `find-contrib-file' (SPC f e c) are replaced. (default nil)
   dotspacemacs-use-ido nil
   ;; If non nil, `helm' will try to miminimize the space it uses. (default nil)
   dotspacemacs-helm-resize nil
   ;; if non nil, the helm header is hidden when there is only one source.
   ;; (default nil)
   dotspacemacs-helm-no-header nil
   ;; define the position to display `helm', options are `bottom', `top',
   ;; `left', or `right'. (default 'bottom)
   dotspacemacs-helm-position 'bottom
   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content. (default nil)
   dotspacemacs-enable-paste-micro-state nil
   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4
   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'right-then-bottom
   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t
   ;; If non nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup t
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90
   ;; If non nil unicode symbols are displayed in the mode line. (default t)
   dotspacemacs-mode-line-unicode-symbols t
   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters the
   ;; point when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t
   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil
   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all
   ;; If non nil advises quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
   ;; (default '("ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now. (default nil)
   dotspacemacs-default-package-repository nil
   ))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init'.  You are free to put any
user code."
  (setq-default ruby-version-manager 'rvm)
  (setq-default ruby-enable-ruby-on-rails-support t)
  )

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
 This function is called at the very end of Spacemacs initialization after
layers configuration. You are free to put any user code."
  ;; (require 'borg)
  ;; (borg-initialize)
  (evil-global-set-key 'normal (kbd "K") 'newline-and-indent)
  (evil-global-set-key 'normal (kbd "g b") 'browse-url-at-point)
  (add-hook 'anaconda-mode-hook (lambda ()
                                  (evil-global-set-key 'normal (kbd "C-,") 'pop-tag-mark)))
  (add-hook 'conf-javaprop-mode-hook '(lambda () (conf-quote-normal nil)))
  (add-hook 'org-mode-hook 'auto-fill-mode)
  (global-set-key (kbd "C-x C-b") #'ibuffer)
  ;; (global-set-key (kbd "M-x") #'helm-M-x) ;; not using this anymore because it does not work well with prefix args
  (evil-leader/set-key (kbd "g d") 'magit-diff-staged)
  (server-start)
  ;; (dolist (dir '("~/.emacs.d"))
  ;;   (magit-status dir))
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
  (add-to-list 'auto-mode-alist '("\\.shen\\'" . shen-mode))
  (add-to-list 'auto-mode-alist '("\\.rb_trace\\'" . ruby-trace-mode))
  (setenv "PAGER" "/bin/cat")
  (evil-leader/set-key (kbd "g u") 'magit-set-tracking-upstream)
  (evil-leader/set-key (kbd "g U") 'magit-unset-tracking-upstream)
  (evil-leader/set-key (kbd "o g P c") 'endless/visit-pull-request-url)
  (evil-leader/set-key (kbd "o g y") 'github/copy-branch-url)
  (evil-leader/set-key (kbd "o g Y") 'github/copy-file-url)
  (evil-leader/set-key (kbd "o g p") 'dcl/create-branch-from-pivotal)
  (evil-leader/set-key (kbd "o g j") 'dcl/create-branch-from-jira)
  (evil-leader/set-key (kbd "o g b") 'dcl/magit-checkout-last-branch)
  (evil-leader/set-key (kbd "o g r") 'dcl/magit-branch-rebase)
  (evil-leader/set-key (kbd "o g h") 'magit-history-checkout)
  (evil-leader/set-key (kbd "o p t") 'dcl/pivotal-github-tasks-template)
  (evil-leader/set-key (kbd "o l !") 'dcl/evil-ex-run-current-line)
  (evil-leader/set-key (kbd "o n c") '0xc-convert)
  (evil-leader/set-key (kbd "o a") 'ascii-display)
  (evil-leader/set-key (kbd "o h H") 'howdoi-query)
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
  ;; (diminish 'paredit-mode " ⍢")
  (spacemacs/set-leader-keys-for-major-mode 'python-mode "sp" 'python-shell-print-line-or-region)
  (spacemacs/set-leader-keys-for-major-mode 'ruby-mode "sl" 'ruby-eval-line)
  (spacemacs/set-leader-keys-for-major-mode 'enh-ruby-mode "sl" 'ruby-eval-line)
  (spacemacs/set-leader-keys-for-major-mode 'eshell-mode "ob" 'dcl/eshell-pipe-to-buffer)
  (spacemacs/set-leader-keys-for-major-mode 'eshell-mode "os" 'dcl/eshell-circleci-ssh-to-tramp)
  (spacemacs/set-leader-keys-for-major-mode 'js2-mode "otp" 'mocha-test-at-point)
  (spacemacs/set-leader-keys-for-major-mode 'js2-mode "otf" 'mocha-test-file)
  (spacemacs/set-leader-keys-for-major-mode 'js2-mode "odp" 'mocha-debug-at-point)
  (spacemacs/set-leader-keys-for-major-mode 'js2-mode "odf" 'mocha-debug-file)
  ;; (require 'helm-config)
  ;; (require 'helm)
  (helm-mode 1) ;; for some reason, all the describe-* goodness is not working with Spacemacs v.0.103.2 unless I add this line
  (setq gtags-auto-update nil)
  (let ((helm-dash-mode-alist
         '((python-mode-hook . '("Python" "NumPy"))
           (ruby-mode-hook . '("Ruby" "Ruby on Rails"))
           (js2-mode-hook  . '("JavaScript" "D3JS" "NodeJS" "Ionic"))
           (coffee-mode-hook . '("CofeeScript" "D3JS" "NodeJS" "Ionic"))
           (emacs-lisp-mode-hook . '("Emacs Lisp"))
           )))
    (dolist (alist helm-dash-mode-alist)
      (destructuring-bind (mode-hook . docsets) alist
        (lexical-let ((docset docsets))
          (add-hook mode-hook (lambda () (helm-dash-use-docsets docset)))))))
  (setq dash-helm-dash-docset-path "/home/dancluna/.docsets")
  (evil-leader/set-key-for-mode 'js2-mode "msr" 'skewer-eval-region)
  ;; don't know if this is the "right" way to set the font size, but my eyes hurt w/ smaller fonts
  (add-hook 'after-change-major-mode-hook 'dcl/favorite-text-scale)

  (add-hook 'git-commit-mode 'dcl/set-fill-column-magit-commit-mode)
  ;; (add-hook 'haml-mode 'indent-guide)
  (add-hook 'sass-mode-hook 'rainbow-mode)
  (add-hook 'ruby-mode-hook 'dcl/ruby-special-setup)
  (add-hook 'enh-ruby-mode-hook 'dcl/ruby-special-setup)
  (add-hook 'haml-mode-hook 'dcl/haml-special-setup)
  (add-hook 'coffee-mode-hook 'dcl/coffee-special-setup)
  (add-hook 'compilation-filter-hook 'inf-ruby-auto-enter)
  (if (fboundp 'stock-ticker-global-mode)
      (stock-ticker-global-mode 1))
  (evil-embrace-enable-evil-surround-integration)
  (add-to-list 'evil-normal-state-modes 'erc-mode)
  (add-hook 'haskell-mode-hook 'intero-mode)
  (add-hook 'magit-mode-hook 'dcl/set-local-evil-escape)
  (setup-rails-linters)
  ;; (setq evil-normal-state-cursor '("coral" box))
  ;; (setq evil-normal-state-cursor '("DarkGoldenrod2" box))
  (load "~/code/rspec-mode/rspec-mode") ; I run a local version and this has some extra goodies
  (setq x86-lookup-pdf "~/Documents/books/Programming/64-ia-32-architectures-software-developer-instruction-set-reference-manual-325383.pdf") ;; asm-mode instruction lookup
  (purpose-mode -1)
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
  (setq git-link-open-in-browser nil)
  (setq inf-ruby-breakpoint-pattern "\\(\\[1\\] pry(\\)\\|\\(\\[1\\] haystack\\)\\|\\((rdb:1)\\)\\|\\((byebug)\\)")
  (defadvice slack-start (before load-slack-teams)
    (unless slack-teams (load-file "~/.slack-teams.el.gpg")))
  (dcl/enable-emacspeak)
  ;; (when (and (daemonp) (locate-library "edit-server"))
  ;;   (require 'edit-server)
  ;;   (edit-server-start))
  (evil-ex-define-cmd "slow[pokemode]" 'dcl/filip-slowpoke)
  (evil-ex-define-cmd "fast[pokemode]" 'dcl/normal-delay)
  (add-hook 'prog-mode-hook #'whitespace-cleanup)
  ;; (require 'pmd)
  (require 'indium)
  (add-hook 'js2-mode-hook #'indium-interaction-mode)
  (add-to-list 'evil-emacs-state-modes 'indium-debugger-mode)
  (use-package autoinsert
    :init (progn
            (add-hook 'find-file-hook 'auto-insert)
            (auto-insert-mode 1)))
  (eval-after-load 'autoinsert
    '(progn
       (setq auto-insert-query nil)
       (define-auto-insert '(typescript-mode . "TS skeleton")
         '("Header"
           "\"use strict\";\n"))))
  (setq yas--default-user-snippets-dir (expand-file-name "yasnippets" "/mnt/lmde/home/dancluna"))
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
  (setq nov-text-width 200)
  (add-hook 'minibuffer-setup-hook 'dcl/minibuffer-setup)
  )

(defun dcl/minibuffer-setup ()
  ;; (setq-local face-remapping-alist
  ;;             '((default ( :height 3.0 ))))
  )

(defun dcl/filip-slowpoke ()
  (interactive)
  (message "Escape delay is now %f" (setq evil-escape-delay 0.4)))

(defun dcl/normal-delay ()
  (interactive)
  (message "Escape delay is now %f" (setq evil-escape-delay 0.1)))

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

(defun dcl/set-local-evil-escape ()
  (interactive)
  (setq-local evil-escape-key-sequence "fd"))

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

(defvar dcl-rate-per-hour (string-to-number (getenv "RATE_PER_HOUR")))

(defun dcl/stackbuilders-invoice-template (hours-worked)
  (interactive "nHours worked: \n")
  (kill-new (message "Total due for IT services provided to Stack Builders: $%s USD" (* dcl-rate-per-hour hours-worked))))

(defun dcl/refresh-git-spacemacs ()
  "Calls the script that copies all my dotfiles configs to a git directory."
  (interactive)
  (shell-command "~/dotfiles/refresh-git-dir-script.sh &")
  (unless (get-buffer "*magit: dotfiles")
    (magit-status "~/dotfiles"))
  (pop-to-buffer "*magit: dotfiles")
  (magit-refresh))

(defun dcl/leader-keys-major-mode (mode-list prefix name key-def-pairs)
  (let ((user-prefix (concat "m" prefix)))
    (dolist (mode mode-list)
      (spacemacs/declare-prefix-for-mode mode "mo" "custom")
      (spacemacs/declare-prefix-for-mode mode user-prefix name)
      (dolist (key-def-pair key-def-pairs)
        (destructuring-bind (key def) key-def-pair
          (spacemacs/set-leader-keys-for-major-mode mode (concat prefix key) def))))))

(defmacro dcl/make-helm-source (name desc cand-var action &rest body)
  (let ((candidate-source-fn-name (intern (format "%s-candidates" name)))
        (helm-source-var-name (intern (format "%s-helm-source" name))) )
    `(progn
       (defun ,candidate-source-fn-name ()
         ,@body)
       (defvar ,helm-source-var-name
         '((name . ,(capitalize desc))
           (candidates . ,candidate-source-fn-name)
           (action . (lambda (,cand-var) ,action))))
       (defun ,name ()
         ,(concat "Helm source for " desc)
         (interactive)
         (helm :sources '(,helm-source-var-name))))))
(put 'dcl/make-helm-source 'lisp-indent-function 'defun)

(dcl/make-helm-source dcl/lib-code-magit-status "directories under ~/code"
  dir (magit-status dir) (directory-files "~/code" t))

(defun dcl/local-package (pkg-sym)
  (let ((pkg-location (concat (getenv "CODE_DIR") "/" (symbol-name pkg-sym))) )
    ;; (push pkg-location load-path)
    (list pkg-sym :location  pkg-location)))

(defun dcl/new-blog-post (post-title)
  (interactive "sPost title:")
  (find-file-other-window (format "%s/%s-%s.md" "/home/dancluna/code/dcluna.github.io/_posts" (format-time-string "%Y-%m-%d" (current-time)) post-title)))

(defun dcl/shuffle (list)
  "Destructively shuffles LIST."
  (sort list (lambda (a b) (nth (random 2) '(nil t)))))

(defun dcl/ruby-format-vars-puts (vars &optional sep)
  (mapconcat (lambda (var) (format "%s = #{%s.inspect}" var var)) vars (or sep " | ")))

(defun dcl/ruby-copy-camelized-class (beg end)
  "Camelizes the current region's class name."
  (interactive "r")
  (let* ((class-name (buffer-substring beg end))
         (no-module-or-class-name (replace-regexp-in-string " *\\(module\\|class\\) " "" class-name)))
    (kill-new (message (s-join "::" (s-split "\n" no-module-or-class-name))))))

(defun dcl/wrap-region (beg end start-text end-text)
  "Wraps the currently-active region."
  (interactive "r\nsStart with: \nsEnd with: ")
  (let ((code (buffer-substring beg end)))
    (goto-char beg)
    (delete-region (point) end)
    (insert (format "%s\n%s\n%s" start-text code end-text))))

(defvar ruby-trace-default-location "/tmp/tracer_output.rb_trace" "Location for the current ruby trace file.")

(defun dcl/ruby-trace-region (beg end)
  "Adds a 'Tracer.on' call around region."
  (interactive "r")
  (dcl/wrap-region beg
                   end
                   (format
                    "require 'tracer'; Tracer.stdout = File.open('%s', 'a'); Tracer.on {"
                    ruby-trace-default-location)
                   "}"))

(defun dcl/ruby-gc-trace-region (beg end)
  "Adds a 'GC.start_logging' call around region."
  (interactive "r")
  (dcl/wrap-region beg end
                   "require 'gc_tracer'; GC::Tracer.start_logging(gc_stat: true, gc_latest_gc_info: true, rusage: true) {"
                   "}"))

(defun dcl/ruby-profile-region (beg end)
  "Adds a RubyProf block around region."
  (interactive "r")
  (dcl/wrap-region beg end
                   "require 'ruby-prof'; RubyProf::MultiPrinter.new(RubyProf.profile {"
                   "}).print(path: '/tmp', profile: 'ruby-prof.txt')")
  )

(defun dcl/ruby-benchmark-region (beg end)
  "Adds a 'Benchmark.ms' call around region."
  (interactive "r")
  (dcl/wrap-region beg end "Benchmark.ms {" "}"))

(defmacro dcl/debug-puts-defun (name var-name &rest format-code)
  `(defun ,name (variables)
     (interactive "sVariables (split with ','): ")
     (let ((,var-name (split-string variables ",")))
       ,@format-code)))
(put 'dcl/debug-puts-defun 'lisp-indent-function 'defun)

(dcl/debug-puts-defun dcl/ruby-puts-vars vars
  (dcl/ruby-ensure-newline (insert (format "puts \"var-debug: %s\"" (dcl/ruby-format-vars-puts vars)))))

(dcl/debug-puts-defun dcl/coffee-puts-vars vars
  (dcl/ensure-newline (insert (format "console.log(\"var-debug: %s\")" (dcl/ruby-format-vars-puts vars)))))

(dcl/debug-puts-defun dcl/haml-puts-vars vars
  (dcl/ensure-newline (insert (format "- puts \"var-debug: %s\"" (dcl/ruby-format-vars-puts vars)))))

(defun dcl/haml-special-setup ()
  (dcl/leader-keys-major-mode
   '(haml-mode) "od" "debug"
   '(("p" pmd/print-vars)))
  (setq-local comment-start "//")
  (setq-local before-save-hook (add-to-list 'before-save-hook 'whitespace-cleanup)))

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

(fset 'dcl/eshell-circleci-ssh-to-tramp
      [?i ?c ?d ?  ?/ escape ?E ?l ?r ?: ?l ?d ?W ?\" ?a ?d ?E ?x ?$ ?a ?# escape ?A escape ?\" ?a ?p ?a ?: ?~ ?/ escape])

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

(defun dcl/ruby-special-setup ()
  (dcl/leader-keys-major-mode
   '(enh-ruby-mode ruby-mode) "oB" "bundler"
   '(("l" dcl/bundle-config-local-gem-use)
     ("d" dcl/bundle-config-local-gem-delete)))
  (dcl/leader-keys-major-mode
   '(enh-ruby-mode ruby-mode) "os" "repl"
   '(("b" ruby-send-buffer)))
  (dcl/leader-keys-major-mode
   '(enh-ruby-mode ruby-mode) "ot" "test"
   '(("d" ruby/rspec-verify-directory)
     ("j" dcl/run-jasmine-specs)))
  (dcl/leader-keys-major-mode
   '(enh-ruby-mode ruby-mode) "of" "file"
   '(("y" rails-copy-relative-path)))
  (dcl/leader-keys-major-mode
   '(enh-ruby-mode ruby-mode) "od" "debug"
   '(("p" pmd/print-vars)
     ("r" dcl/ruby-remove-puts-vars)
     ("t" dcl/ruby-trace-region)
     ("f" dcl/ruby-profile-region)
     ("g" dcl/ruby-gc-trace-region)
     ("b" dcl/ruby-benchmark-region)
     ("c" dcl/ruby-rspec-profiling-console)))
  (dcl/leader-keys-major-mode
   '(enh-ruby-mode ruby-mode) "ob" "breakpoints"
   '(("b" ruby-insert-breakpoint)
     ("p" ruby-save-page)
     ("s" ruby-save-screenshot)
     ("r" ruby-remove-breakpoints)))
  (dcl/leader-keys-major-mode
   '(enh-ruby-mode ruby-mode) "ox" "text"
   '(("m" dcl/ruby-copy-camelized-class)))
  (dcl/ruby-embrace-setup)
  (auto-fill-mode 1)
  (setq-local zeal-at-point-docset "ruby,rails")
  (setq-local before-save-hook (add-to-list 'before-save-hook 'whitespace-cleanup)))

(defun ruby/rspec-verify-directory (prefix dir)
  (interactive "P\nDrspec directory: ")
  (rspec-run-single-file dir (concat (rspec-core-options) (if (and prefix (>= (car prefix) 4)) (format " --seed %d" (read-number "Seed: "))))))

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

(defun dcl/perl1line-txt ()
  (interactive)
  (find-file-other-window "/home/dancluna/code/perl1line.txt/perl1line.txt")
  (read-only-mode 1))

(defun dcl/pivotal-ticket-url (ticketid)
  (interactive "sPivotal ticket id: ")
  (format "https://www.pivotaltracker.com/story/show/%s" ticketid))

(defun dcl/pivotal-ticket-id-from-url (url)
  (replace-regexp-in-string ".*/\\([0-9]+\\)$" "\\1" ticketid-or-pivotal-link))

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

(defun dcl/favorite-text-scale ()
  (unless (equal major-mode 'term-mode)
    (text-scale-set 2)))

(defun date-time-at-point (unix-date)
  (interactive (list (thing-at-point 'word t)))
  (message (shell-command-to-string (format "date --date @%s" unix-date))))

(defun dcl/freebsd-user-agent ()
  (interactive)
  (message (kill-new "Mozilla/5.0 (X11; FreeBSD amd64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36")))

(defun helm-dash-use-docsets (&rest docsets)
  ;; (dolist (docset docsets)
  ;;   (add-to-list 'helm-dash-common-docsets docset))
  )

(defun magit-set-tracking-upstream ()
  "Sets current branch to track its upstream"
  (interactive) ;; todo: add a prefix arg to read upstream from here
  (let* ((curbranch (magit-get-current-branch))
         (remote (magit-get-remote curbranch))
         (result nil))
    (setq result (magit-git-success "branch" "--set-upstream" curbranch (format "%s/%s" remote curbranch)))
    (magit-refresh)
    ))

(defun git/get-branch-url ()
  "Returns the name of the remote branch, without 'origin'."
  (replace-regexp-in-string
   "^origin\/"
   ""
   (substring-no-properties (magit-get-push-branch))))

(defun current-line-empty-p ()
  (save-excursion
    (beginning-of-line)
    (looking-at "[[:space:]]*$")))

(defmacro dcl/ensure-newline (&rest body)
  `(progn (unless (current-line-empty-p) (progn (end-of-line) (newline)))
          (progn ,@body)))

(defmacro dcl/ruby-ensure-newline (&rest body)
  `(dcl/ensure-newline ,@body (ruby-indent-line)))

(defun dcl/markdown-embedded-image (alt-text)
  (interactive "sAlt text: ")
  (message (kill-new (format "![%s](data:image/%s;%s)" alt-text (file-name-extension (buffer-file-name)) (base64-encode-string (buffer-substring-no-properties (point-min) (point-max))))))
  )

(defun dcl/tmp-file-name ()
  (format "/tmp/%s_%d" (file-name-base) (random 9999)))

(defun ruby-save-page ()
  (interactive)
  (dcl/ruby-ensure-newline
   (insert (format "save_page('%s.html')" (dcl/tmp-file-name)))))

(defun ruby-save-screenshot ()
  (interactive)
  (dcl/ruby-ensure-newline
   (insert (format "save_screenshot('%s.png')" (dcl/tmp-file-name)))))

(defvar ruby-ignore-breakpoint-format "ignore_breakpoint")

(defun ruby-insert-breakpoint ()
  (interactive)
  (let ((ignore_bp_var (format "%s_%s" ruby-ignore-breakpoint-format (number-to-string (random 99999)))))
    (unless (current-line-empty-p) (progn (end-of-line) (newline)))
    (insert (format "binding.pry unless %s" ignore_bp_var))
    (ruby-indent-line)
    (beginning-of-line)
    (let ((old-point (point)))
      (save-excursion (ruby-beginning-of-defun)
                      (unless (equal old-point (point)) (forward-line))
                      (insert (format "%s = false\n" ignore_bp_var))
                      (forward-line -1)
                      (ruby-indent-line)))))

(defun ruby-remove-breakpoints-in-region (beg end)
  (dolist (bp-pattern (list ruby-ignore-breakpoint-format "binding.pry" "save"))
    (save-excursion (delete-matching-lines bp-pattern beg end))))

(defun ruby-remove-breakpoints ()
  (interactive)
  (let ((rbeg (if (region-active-p) (region-beginning) (save-excursion (beginning-of-defun) (point))))
        (rend (if (region-active-p) (region-end) (1- (save-excursion (end-of-defun) (point))))))
    (ruby-remove-breakpoints-in-region rbeg rend)))

(defmacro dcl/with-custom-region (rbegf rendf &rest body)
  `(let ((rbeg (if (region-active-p) beg (save-excursion ,rbegf (point))))
         (rend (if (region-active-p) end (1- (save-excursion ,rendf (point))))))
     (progn ,@body)))

(defun dcl/ruby-remove-puts-vars ()
  (interactive)
  (dcl/with-custom-region
   (beginning-of-buffer)
   (end-of-buffer)
   (save-excursion (delete-matching-lines "var-debug: " rbeg rend))))

(defun dcl/ruby-rspec-profiling-console ()
  (interactive)
  (projectile-rails-with-root
   (progn
     (with-current-buffer (run-ruby "bundle exec rake rspec_profiling:console"))
     (projectile-rails-mode +1))))

(defun dcl/ruby-embrace-setup ()
  (mapc (lambda (key) (setq-local evil-embrace-evil-surround-keys (cl-remove key evil-embrace-evil-surround-keys))) '(?\{ ?\}))
  (embrace-add-pair ?{ "{" "}")
  (embrace-add-pair ?# "#{" "}")
  (embrace-add-pair ?d "do " " end")
  (embrace-add-pair ?l "->() {" "}"))

(defun ruby-eval-line (lines)
  (interactive "p")
  (dotimes (i lines)
    (ruby-send-region (line-beginning-position) (line-end-position))
    (next-line (signum lines))))

(defun ruby-insert-methods-check ()
  (interactive)
  (forward-char)
  (insert ".methods.uniq.sort"))

(defun rails-copy-relative-path ()
  (interactive)
  (message (kill-new (replace-regexp-in-string (regexp-opt (list (or (projectile-rails-root) ""))) "" (buffer-file-name)))))

(defun us-phone-number ()
  (interactive)
  (message (kill-new "732-757-2923")))

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

(defun magit-unset-tracking-upstream ()
  "Sets current branch to track its upstream"
  (interactive) ;; todo: add a prefix arg to read upstream from here
  (let* ((curbranch (magit-get-current-branch))
         (remote (magit-get-remote curbranch))
         (result nil))
    (setq result (magit-git-success "branch" "--unset-upstream" curbranch))
    (magit-refresh)
    ))

(defun browse-url-current-file ()
  (interactive)
  (helm-aif (buffer-file-name)
      (browse-url it)))

(defun skewer-eval-region (beg end &optional prefix)
  (interactive "r\nP")
  (skewer-eval (buffer-substring beg end) (if prefix #'skewer-post-print #'skewer-post-minibuffer)))

(defmacro with-magit-status-for (project-name project-location &rest body)
  (let ((magit-buffer-name (format "*magit: %s" project-name))
        (project-location project-location))
    `(progn (unless (get-buffer ,magit-buffer-name)
              (magit-status ,project-location))
            (pop-to-buffer ,magit-buffer-name)
            (progn ,@body))))

(defun dcl/magit-checkout-last-branch ()
  (interactive)
  (magit-checkout "-"))

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
    (with-magit-status-for "haystak" "~/client-code/haystak"
     (magit-branch new-branch-name "master")
     (magit-checkout new-branch-name)
     (call-interactively 'magit-push-current-to-pushremote)))
  )

(defun dcl/lastpass-import-table ()
  "Imports to LastPass from Org-table at point."
  (interactive)
  (let ((tmpfile (make-temp-file "lpimp")))
    (org-table-export tmpfile "orgtbl-to-csv")
    (message (shell-command-to-string (format "lpass import < %s" tmpfile)))
    (delete-file tmpfile)))

(defun dcl/create-branch-from-pivotal (pivotal-tracker branch-name)
  (interactive "sPivotal Tracker URL: \nsBranch name: ")
  (let* ((pivotal-tracker-ticket-id (replace-regexp-in-string "^.*/\\([0-9]+\\)$" "\\1" pivotal-tracker))
         (sanitized-branch-name (dcl/sanitize-branch-name branch-name))
         (new-branch-name (format "dl_%s_%s" pivotal-tracker-ticket-id sanitized-branch-name)))
    (magit-branch new-branch-name "master")
    (magit-checkout new-branch-name)
    (call-interactively 'magit-push-current-to-pushremote)))

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

;; creating a tags file from emacs - stolen from https://www.emacswiki.org/emacs/BuildTags
(defun ew/create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (shell-command
   (format "ctags -f %s -e -R %s" "TAGS" (directory-file-name dir-name))))

(defun org-babel-execute:shen (body params)
  ;; (shen/eval body)
  )

;;; linter setup
(defun setup-rails-linters ()
  (dolist (elisp (list "~/code-examples/haml-lint-flycheck" "~/code-examples/sass-lint-flycheck"))
    (load elisp)))

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

(defun dcl/ruby-staged-files-hook ()
  "Runs `rubocop-autocorrect-current-file' and `reek-check-current-file' on currently staged .rb files."
  (interactive)
  (dolist (ruby-file (--filter (string-match-p ".rb$" it) (magit-staged-files)))
    (with-current-buffer (find-file-noselect ruby-file)
      (rubocop-autocorrect-current-file)
      (if (fboundp 'reek-check-current-file)
          (reek-check-current-file)))))

(defun sass-prepare-input-buffer ()
  "Inserts common imports into the temporary buffer with the code to be evaluated."
  (goto-char (point-min))
  (insert-file-contents "/home/dancluna/dotfiles/pre-eval-code.sass"))

(defun dcl/make-test-sh-file (filename)
  "Generates a shell script that runs the current file as an rspec test, for bisecting."
  (interactive "F")
  (let ((test-file (buffer-file-name)))
    (with-temp-file filename
      (insert "#!/bin/bash\n")
      (insert (format "bundle exec rspec %s" test-file)))))

;;; exploit development
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

(defun dcl/enable-emacspeak ()
  "Loads emacspeak if the proper environment variables are set."
  (if-let ((dir (getenv "EMACSPEAK_DIR"))
           (enable (getenv "ENABLE_EMACSPEAK")))
      (load-file (concat dir "/lisp/emacspeak-setup.el"))))

(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Linum-format "%7i ")
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "red3" "ForestGreen" "yellow3" "blue" "magenta3" "DeepSkyBlue" "gray50"])
 '(background-color "#202020")
 '(background-mode dark)
 '(compilation-message-face (quote default))
 '(cursor-color "#cccccc")
 '(cursor-type (quote bar))
 '(default-frame-alist
    (quote
     ((buffer-predicate . spacemacs/useful-buffer-p)
      (vertical-scroll-bars)
      (alpha 85)
      (fullscreen . fullboth))))
 '(diary-entry-marker (quote font-lock-variable-name-face))
 '(emms-mode-line-icon-image-cache
   (quote
    (image :type xpm :ascent center :data "/* XPM */
static char *note[] = {
/* width height num_colors chars_per_pixel */
\"    10   11        2            1\",
/* colors */
\". c #358d8d\",
\"# c None s None\",
/* pixels */
\"###...####\",
\"###.#...##\",
\"###.###...\",
\"###.#####.\",
\"###.#####.\",
\"#...#####.\",
\"....#####.\",
\"#..######.\",
\"#######...\",
\"######....\",
\"#######..#\" };")))
 '(erc-hide-list (quote ("JOIN" "PART" "QUIT")))
 '(evil-escape-key-sequence "jk")
 '(evil-want-Y-yank-to-eol nil)
 '(fci-rule-character-color "#202020")
 '(fci-rule-color "#f6f0e1" t)
 '(foreground-color "#cccccc")
 '(fringe-mode 4 nil (fringe))
 '(global-rbenv-mode t)
 '(gnus-logo-colors (quote ("#259ea2" "#adadad")) t)
 '(gnus-mode-line-image-cache
   (quote
    (image :type xpm :ascent center :data "/* XPM */
static char *gnus-pointer[] = {
/* width height num_colors chars_per_pixel */
\"    18    13        2            1\",
/* colors */
\". c #358d8d\",
\"# c None s None\",
/* pixels */
\"##################\",
\"######..##..######\",
\"#####........#####\",
\"#.##.##..##...####\",
\"#...####.###...##.\",
\"#..###.######.....\",
\"#####.########...#\",
\"###########.######\",
\"####.###.#..######\",
\"######..###.######\",
\"###....####.######\",
\"###..######.######\",
\"###########.######\" };")) t)
 '(highlight-changes-colors (quote ("#FD5FF0" "#AE81FF")))
 '(highlight-tail-colors
   (quote
    (("#3C3D37" . 0)
     ("#679A01" . 20)
     ("#4BBEAE" . 30)
     ("#1DB4D0" . 50)
     ("#9A8F21" . 60)
     ("#A75B00" . 70)
     ("#F309DF" . 85)
     ("#3C3D37" . 100))))
 '(hl-paren-background-colors (quote ("#e8fce8" "#c1e7f8" "#f8e8e8")))
 '(hl-paren-colors (quote ("#40883f" "#0287c8" "#b85c57")))
 '(hl-sexp-background-color "#1c1f26")
 '(indium-nodejs-inspect-brk t)
 '(linum-format " %7i ")
 '(magit-diff-expansion-threshold 5)
 '(magit-diff-use-overlays nil)
 '(main-line-color1 "#1E1E1E")
 '(main-line-color2 "#111111")
 '(main-line-separator-style (quote chamfer))
 '(nrepl-message-colors
   (quote
    ("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3")))
 '(org-babel-load-languages
   (quote
    ((scheme . t)
     (ruby . t)
     (elixir . t)
     (restclient . t)
     (shell . t)
     (clojure . t)
     (python . t)
     (emacs-lisp . t))))
 '(org-latex-classes
   (quote
    (("moderncv" "\\documentclass[12pt,a4paper,sans]{moderncv}"
      ("\\section{%s}" . "\\section*{%s}"))
     ("article" "\\documentclass[11pt]{article}"
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
      ("\\paragraph{%s}" . "\\paragraph*{%s}")
      ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
     ("report" "\\documentclass[11pt]{report}"
      ("\\part{%s}" . "\\part*{%s}")
      ("\\chapter{%s}" . "\\chapter*{%s}")
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
     ("book" "\\documentclass[11pt]{book}"
      ("\\part{%s}" . "\\part*{%s}")
      ("\\chapter{%s}" . "\\chapter*{%s}")
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))))
 '(package-selected-packages
   (quote
    (nov mocha pmd flycheck-package package-lint indium sourcemap orgit org-brain ob-elixir evil-org yarn-mode tide nvm rufo toml-mode racer flycheck-rust cargo rust-mode sayid password-generator impatient-mode godoctor flycheck-bashate evil-lion dante company-php ac-php-core xcscope powershell elfeed-org winum white-sand-theme symon string-inflection rebecca-theme realgud test-simple loc-changes load-relative magithub ghub+ s magit-popup git-commit with-editor apiwrap ghub madhat2r-theme go-rename fuzzy flymd flycheck-credo emoji-cheat-sheet-plus doom-themes all-the-icons memoize font-lock+ company-lua company-emoji browse-at-remote dockerfile-mode docker tablist docker-tramp dash async company-ansible markdown-mode markdown-mode+ eziam-theme ox-reveal vi-tilde-fringe evil-nerd-commenter zonokai-theme znc zenburn-theme zen-and-art-theme zeal-at-point yapfify yaml-mode yagist xterm-color x86-lookup x-path-walker wsd-mode ws-butler window-numbering which-key web-mode web-beautify volatile-highlights vimrc-mode vagrant-tramp vagrant uuidgen use-package underwater-theme ujelly-theme twilight-theme twilight-bright-theme twilight-anti-bright-theme tronesque-theme tramp-term toxi-theme toc-org tao-theme tangotango-theme tango-plus-theme tango-2-theme tagedit sunny-day-theme suggest sublime-themes subatomic256-theme subatomic-theme sql-indent spacemacs-theme spaceline spacegray-theme sourcerer-theme soothe-theme sonic-pi solarized-theme soft-stone-theme soft-morning-theme soft-charcoal-theme smyx-theme smeargle slime-company slim-mode slack shen-mode shen-elisp shell-pop seti-theme selectric-mode scss-mode sage-shell-mode rvm ruby-tools ruby-test-mode ruby-refactor rubocop robe reverse-theme restclient-helm restart-emacs reek rbenv ranger rainbow-mode rainbow-identifiers rainbow-delimiters railscasts-theme racket-mode quelpa pyvenv pytest pylint pyenv-mode py-isort py-autopep8 purple-haze-theme pug-mode professional-theme prodigy planet-theme plan9-theme pivotal-tracker pip-requirements phpunit phpcbf php-extras php-auto-yasnippets phoenix-dark-pink-theme phoenix-dark-mono-theme persp-mode pastels-on-dark-theme paredit-menu paradox ox-jira ox-gfm organic-green-theme org-projectile org-present org-pomodoro org-download org-bullets open-junk-file omtose-phellack-theme oldlace-theme occidental-theme obsidian-theme ob-restclient noctilux-theme niflheim-theme neotree nasm-mode naquadah-theme mustang-theme mu4e-maildirs-extension mu4e-alert move-text monokai-theme monochrome-theme molokai-theme moe-theme mmm-mode minitest minimal-theme meme material-theme markdown-toc majapahit-theme magit-gitflow magit-gh-pulls lush-theme lua-mode lorem-ipsum livid-mode live-py-mode linum-relative link-hint light-soap-theme lfe-mode less-css-mode labburn-theme json-mode js2-refactor js-doc jinja2-mode jedi-direx jbeans-theme jazz-theme ir-black-theme intero insert-shebang inkpot-theme info+ indent-guide ido-vertical-mode hy-mode hungry-delete htmlize howdoi hlint-refactor hl-todo hindent highlight-parentheses highlight-numbers highlight-indentation hide-comnt heroku-theme hemisu-theme help-fns+ helm-themes helm-swoop helm-pydoc helm-purpose helm-projectile helm-mt helm-mode-manager helm-make helm-hoogle helm-gitignore helm-flx helm-descbinds helm-dash helm-css-scss helm-company helm-c-yasnippet helm-ag hc-zenburn-theme haskell-snippets haml-mode gruvbox-theme gruber-darker-theme grandshell-theme gotham-theme google-translate golden-ratio go-guru go-eldoc gnuplot gmail-message-mode github-search github-clone github-browse-file gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe git-gutter-fringe+ gist gh-md geiser geeknote gandalf-theme fuel flycheck-pos-tip flycheck-mix flycheck-haskell flx-ido flatui-theme flatland-theme fish-mode firebelly-theme fill-column-indicator feature-mode farmhouse-theme fancy-battery eyebrowse exercism exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-snipe evil-search-highlight-persist evil-rails evil-quickscope evil-paredit evil-numbers evil-mc evil-matchit evil-magit evil-lisp-state evil-indent-plus evil-iedit-state evil-extra-operator evil-exchange evil-escape evil-embrace evil-ediff evil-easymotion evil-commentary evil-cleverparens evil-args evil-anzu espresso-theme eshell-z eshell-prompt-extras esh-help erlang erc-yt erc-view-log erc-social-graph erc-image erc-hl-nicks enh-ruby-mode engine-mode emmet-mode elisp-slime-nav elfeed-web elfeed-goodies editorconfig edit-server dumb-jump drupal-mode dracula-theme django-theme disaster diff-hl define-word debbugs darktooth-theme darkokai-theme darkmine-theme darkburn-theme dark-mint-theme dakrone-theme dactyl-mode cython-mode cyberpunk-theme csv-mode company-web company-tern company-statistics company-shell company-restclient company-quickhelp company-go company-ghci company-ghc company-cabal company-c-headers company-anaconda common-lisp-snippets column-enforce-mode color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized color-identifiers-mode coffee-mode cmm-mode cmake-mode clues-theme clojure-snippets clj-refactor clean-aindent-mode clang-format cider-eval-sexp-fu chruby cherry-blossom-theme busybee-theme bundler bubbleberry-theme birds-of-paradise-plus-theme badwolf-theme auto-yasnippet auto-highlight-symbol auto-compile ascii apropospriate-theme anti-zenburn-theme ansible-doc ansible ample-zen-theme ample-theme alect-themes alchemist aggressive-indent afternoon-theme adaptive-wrap ace-window ace-link ace-jump-helm-line ac-ispell 0xc)))
 '(paradox-automatically-star t)
 '(pdf-view-midnight-colors (quote ("#DCDCCC" . "#383838")))
 '(pos-tip-background-color "#F1EBDD")
 '(pos-tip-foreground-color "#272822")
 '(powerline-color1 "#1E1E1E")
 '(powerline-color2 "#111111")
 '(rspec-spec-command "rescue rspec")
 '(rspec-use-spring-when-possible nil)
 '(sml/active-background-color "#98ece8")
 '(sml/active-foreground-color "#424242")
 '(sml/inactive-background-color "#4fa8a8")
 '(sml/inactive-foreground-color "#424242")
 '(sql-connection-alist
   (quote
    (("theguarantors_development"
      (sql-product
       (quote postgres))
      (sql-database "theguarantors_development")))))
 '(tls-checktrust t)
 '(vc-annotate-background "#f6f0e1")
 '(vc-annotate-color-map
   (quote
    ((20 . "#e43838")
     (40 . "#f71010")
     (60 . "#ab9c3a")
     (80 . "#9ca30b")
     (100 . "#ef8300")
     (120 . "#958323")
     (140 . "#1c9e28")
     (160 . "#3cb368")
     (180 . "#028902")
     (200 . "#008b45")
     (220 . "#077707")
     (240 . "#259ea2")
     (260 . "#358d8d")
     (280 . "#0eaeae")
     (300 . "#2c53ca")
     (320 . "#0000ff")
     (340 . "#0505cc")
     (360 . "#a020f0"))))
 '(vc-annotate-very-old-color "#a020f0")
 '(weechat-color-list
   (unspecified "#272822" "#3C3D37" "#F70057" "#F92672" "#86C30D" "#A6E22E" "#BEB244" "#E6DB74" "#40CAE4" "#66D9EF" "#FB35EA" "#FD5FF0" "#74DBCD" "#A1EFE4" "#F8F8F2" "#F8F8F0"))
 '(when
      (or
       (not
        (boundp
         (quote ansi-term-color-vector)))
       (not
        (facep
         (aref ansi-term-color-vector 0)))))
 '(winum-scope (quote frame-local))
 '(woman-manpath
   (quote
    ("/usr/man" "/usr/share/man" "/usr/local/share/man"
     ("/bin" . "/usr/share/man")
     ("/usr/bin" . "/usr/share/man")
     ("/sbin" . "/usr/share/man")
     ("/usr/sbin" . "/usr/share/man")
     ("/usr/local/bin" . "/usr/local/man")
     ("/usr/local/bin" . "/usr/local/share/man")
     ("/usr/local/sbin" . "/usr/local/man")
     ("/usr/local/sbin" . "/usr/local/share/man")
     ("/usr/X11R6/bin" . "/usr/X11R6/man")
     ("/usr/bin/X11" . "/usr/X11R6/man")
     ("/usr/games" . "/usr/share/man")
     ("/opt/bin" . "/opt/man")
     ("/opt/sbin" . "/opt/man"))))
 '(woman-path
   (quote
    ("/home/dancluna/.rvm/gems/ruby-2.3.1/gems/bundler-1.13.6/man")))
 '(xterm-color-names
   ["#F1EBDD" "#A33555" "#BF5637" "#666E4D" "#3A6E64" "#665843" "#687366" "#50484e"])
 '(xterm-color-names-bright
   ["#EBE7D9" "#DB4764" "#CE6A38" "#649888" "#848F86" "#857358" "#50484e"])
 '(yas-snippet-dirs
   (quote
    ("/mnt/lmde/home/dancluna/yasnippets" "/home/dancluna/.emacs.d/private/snippets/" yas-installed-snippets-dir "/home/dancluna/.emacs.d/layers/+completion/auto-completion/local/snippets" "/home/dancluna/.emacs.d/elpa/clojure-snippets-20170713.2310/snippets" "/home/dancluna/.emacs.d/elpa/common-lisp-snippets-20170522.2147/snippets" "/home/dancluna/.emacs.d/elpa/haskell-snippets-20160918.1722/snippets"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background nil)))))
)
