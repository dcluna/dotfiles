;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   dotspacemacs-scratch-mode 'emacs-lisp-mode
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
   '(
     helm
     rust
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
                                      multi-compile
                                      dumb-jump
                                      tldr
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
  (org-babel-load-file "~/dotfiles/spacemacs.org"))

(defun dcl/local-package (pkg-sym)
  (let ((pkg-location (concat (getenv "CODE_DIR") "/" (symbol-name pkg-sym))) )
    ;; (push pkg-location load-path)
    (list pkg-sym :location  pkg-location)))

(defun dcl/shuffle (list)
  "Destructively shuffles LIST."
  (sort list (lambda (a b) (nth (random 2) '(nil t)))))

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
 '(org-src-tab-acts-natively t)
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
