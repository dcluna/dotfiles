;; Straight.el
(setq straight-repository-branch "develop")

(defvaralias 'native-comp-deferred-compilation-deny-list 'native-comp-jit-compilation-deny-list)

(let ((bootstrap-file (concat user-emacs-directory "straight/repos/straight.el/bootstrap.el"))
      (bootstrap-version 3))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
        "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
        'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(setq straight-enable-package-integration nil
      straight-enable-use-package-integration t
      straight-vc-git-upstream-remote "origin"
      straight-vc-git-primary-remote "my-version")


(setq straight-packages '(
                          (lem :fetcher codeberg :repo "martianh/lem.el" :files ("lisp/*.el"))
                          (elfeed-tube :host github :repo "karthink/elfeed-tube" :files ("*.el"))
                          (mastodon-alt :host github :repo "rougier/mastodon-alt" :files ("*.el"))
                          (prism :host github :repo "alphapapa/prism.el" :files ("*.el"))
                          (myron-themes :host github :repo "neeasade/myron-themes" :files ("*.el" "themes/*.el"))
                          (codeium :type git :host github :repo "Exafunction/codeium.el")
                          tramp
                          persistent-scratch
                          (org-ai :type git :host github :repo "rksm/org-ai"
                                  :local-repo "org-ai"
                                  :files ("*.el" "README.md"))
                          (gptel :host github :repo "karthink/gptel")
                          (chat :host github :repo "iwahbe/chat.el" :files ("*.el"))
                          ;; (gpt :host github :repo "stuhlmueller/gpt.el")
                          (ivy-ghq :host github :repo "analyticd/ivy-ghq" :files ("*.el"))
                          mini-frame
                          (org-roam-ui :host github :repo "org-roam/org-roam-ui" :branch "main" :files ("*.el" "out"))
                          org-roam
                          ;; magit-section
                          (homebrew :type git :host github :repo "jdormit/homebrew.el")
                          git-link
                          ;; (cyberpunk-2019 :type git :host github :repo "the-frey/cyberpunk-2019")
                          ;; (forge :type git :host github :repo "magit/forge")
                          minitest
                          helpful
                          (enh-ruby-mode :type git :host github :repo "zenspider/enhanced-ruby-mode")
                          hydra
                          znc
                          gist
                          docker
                          ;; groovy-mode
                          anaphora
                          exec-path-from-shell
                          (pmd :type git :host github :repo "dcluna/pmd.el")
                          ;; (emacs-direnv  :type git :host github :repo "wbolster/emacs-direnv")
                          rake
                          robe
                          (rspec-mode :type git :host github :repo "pezra/rspec-mode")
                          ;; (rmsbolt :type git :host gitlab :repo "jgkamat/rmsbolt")
                          pretty-mode
                          ;; helm-ghq
                          ghq
                          ;; graphql-mode
                          ;; lsp-mode
                          jq-mode
                          (rubocop :type git :host github :repo "dcluna/rubocop-emacs"
                                   :upstream (:host github :repo "bbatsov/rubocop-emacs"))
                          ;; org
                          (vlf :type git :host github :repo "m00natic/vlfi")
                          evil-numbers
                          auto-minor-mode))
                          ;; (helm-c-yasnippet :type git :host github :repo "dcluna/helm-c-yasnippet"
                          ;;                   :branch "fix-helm-insert-on-region"
                          ;;                   :upstream (:host github
                          ;;                                    :repo "emacs-jp/helm-c-yasnippet"))
(defun my-straight-installed-p (package)
  "Return non-nil if PACKAGE is installed by `straight'."
  (gethash (if (symbolp package) (symbol-name package) package) straight--recipe-cache))

(defun my--advice-package-installed-p (original-function &rest args)
  "Return t if package is installed via `straight' package manager. Otherwise
call the original function `package-installed-p'."
  (or (my-straight-installed-p (car args))
      (apply original-function args)))
(advice-add 'package-installed-p :around 'my--advice-package-installed-p)

(defun my--advice-package-activate (original-function &rest args)
  "Return t if package is installed via `straight' package manager. Otherwise
call the original function `package-activate'."
  (if (my-straight-installed-p (car args))
      (progn
        ;; (message "%s already installed" (car args))
        (unless (memq (car args) package-activated-list)
          ;; Not sure if package-activated-list needs to be updated here ...
          (push (car args) package-activated-list))
        t)
    (apply original-function args)))
(advice-add 'package-activate :around 'my--advice-package-activate)
;; (defhydra hydra-straight-helper (:hint nil)
;;   "
;; _c_heck all       |_f_etch all     |_m_erge all      |_n_ormalize all   |p_u_sh all
;; _C_heck package   |_F_etch package |_M_erge package  |_N_ormlize package|p_U_sh package
;; ----------------^^+--------------^^+---------------^^+----------------^^+------------||_q_uit||
;; _r_ebuild all     |_p_ull all      |_v_ersions freeze|_w_atcher start   |_g_et recipe
;; _R_ebuild package |_P_ull package  |_V_ersions thaw  |_W_atcher quit    |prun_e_ build"
;;   ("c" straight-check-all)
;;   ("C" straight-check-package)
;;   ("r" straight-rebuild-all)
;;   ("R" straight-rebuild-package)
;;   ("f" straight-fetch-all)
;;   ("F" straight-fetch-package)
;;   ("p" straight-pull-all)
;;   ("P" straight-pull-package)
;;   ("m" straight-merge-all)
;;   ("M" straight-merge-package)
;;   ("n" straight-normalize-all)
;;   ("N" straight-normalize-package)
;;   ("u" straight-push-all)
;;   ("U" straight-push-package)
;;   ("v" straight-freeze-versions)
;;   ("V" straight-thaw-versions)
;;   ("w" straight-watcher-start)
;;   ("W" straight-watcher-quit)
;;   ("g" straight-get-recipe)
;;   ("e" straight-prune-build)
;;   ("q" nil))

;; (spacemacs/set-leader-keys "oS" 'hydra-straight-helper/body)
;; load straight.el packages
(mapc #'straight-use-package straight-packages)
;; spacemacs initialization routines
(defun dcl/shuffle (list)
  "Destructively shuffles LIST."
  (sort list (lambda (a b) (nth (random 2) '(nil t)))))

(defvar dcl/light-themes
  (dcl/shuffle
   '(acme twilight-bright hemisu-light apropospriate-light flatui
                     kaolin-light kaolin-valley-light sanityinc-solarized-light sanityinc-tomorrow-day
                     doom-tomorrow-day majapahit-light plan9 alect-light
                     gruvbox-light-hard solarized-gruvbox-light moe-light mccarthy
                     soft-stone tango-plus avk-daylight
                     spacemacs-light solarized-light eink leuven
                     ritchie minimal-light doom-nord-light hydandata-light
                     organic-green)))

(defvar dcl/dark-themes
  (dcl/shuffle
   '(kaolin-dark kaolin-aurora kaolin-bubblegum kaolin-eclipse
                 kaolin-temple kaolin-galaxy kaolin-ocean kaolin-valley-dark
                 kaolin-mono-dark seti sanityinc-tomorrow-eighties sanityinc-tomorrow-bright
                 sanityinc-tomorrow-blue sanityinc-tomorrow-night labburn sourcerer
                 avk-darkblue-white avk-darkblue-yellow
                 hickey doom-wilmersdorf
                 moe-dark doom-one granger dark-mint
                 material heroku light-blue spacemacs-dark
                 solarized-dark grayscale sunburn creamsody
                 underwater monokai zenburn alect-dark-alt
                 ample-zen badwolf birds-of-paradise-plus brin bubbleberry cherry-blossom atom-dark atom-one-dark
                 creamsody cyberpunk clues
                 darkmine deeper-blue farmhouse-dark gruvbox
                 junio noctilux subatomic purple-haze github-modern tao-yin gotham)))


(require 'dash)

(defvar dcl/all-themes
  (-flatten (-zip-with (lambda (a b) (list a b)) dcl/light-themes dcl/dark-themes))
  "Themes ready for localization package.")

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
 You should not put any user code in this function besides modifying the variable
 values."
  (setq-default
   dotspacemacs-scratch-mode 'sql-mode
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
     kubernetes
     openai
     (elfeed :variables rmh-elfeed-org-files (list (expand-file-name "~/dotfiles/elfeed.org")))
     finance
     ;; (scala :variables scala-backend 'scala-metals)
     imenu-list
     nixos
     ess
     ipython-notebook
     react
     dap
     latex
     javascript
     lsp
     crystal
     perl5
     emoji
     (parinfer :variables parinfer-auto-switch-indent-mode t parinfer-auto-switch-indent-mode-when-closing t)
     (ivy :variables ivy-wrap t ivy-height 25 ivy-enable-advanced-buffer-information t)
     rust
     ;; (mu4e :variables mu4e-installation-path "~/code/mu/mu4e" mu4e-maildir "~/.StackBuildersMaildir")
     (ranger :variables ranger-show-preview t ranger-cleanup-on-disable t ranger-ignored-extensions '("mkv" "iso" "mp4") ranger-max-preview-size 10)
     asm
     csv
     ;; erc
     docker
     vimscript
     c-c++
     search-engine
     ;; haskell
     dash
     shell-scripts
     ;; racket
     ;; php
     elixir
     erlang
     (evil-snipe :variables evil-snipe-enable-alternate-f-and-t-behaviors t)
     ;; restclient
     yaml
     ruby-on-rails
     evil-commentary
     syntax-checking
     (auto-completion :variables
                      auto-completion-enable-help-tooltip 'manual
                      auto-completion-enable-sort-by-usage t
                      auto-completion-enable-snippets-in-popup t
                      auto-completion-idle-delay 0.3
                      :disabled-for org spacemacs-org)
     sql
     ;; scheme
     ;; personal-misc
     (git :variables git-enable-github-support t git-gutter-use-fringe t git-enable-magit-gitflow nil git-enable-magit-delta-plugin nil)
     markdown
     html
     (typescript :variables
                 typescript-fmt-on-save t
                 typescript-fmt-tool 'tide)
     (javascript :variables
                 js-indent-level 2)
     (python :variables python-test-runner '(pytest) python-backend 'anaconda)
     (ruby :variables ruby-enable-enh-ruby-mode t ruby-test-runner 'rspec)
     ;; (clojure :variables clojure-enable-fancify-symbols t)
     (colors :variables
             colors-colorize-identifiers 'all)
             ;; colors-enable-nyan-cat-progress-bar (display-graphic-p)
             ;; nyan-minimum-window-width 64)
     theming
     themes-megapack
     common-lisp
     lua
     (go :variables go-tab-width 4 go-format-before-save t)
     ;; github
     (org :variables org-enable-github-support t org-enable-reveal-js-support t org-enable-roam-support t org-enable-sticky-header t org-enable-appear-support t)
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
     (version-control :variables
                      version-control-diff-tool 'diff-hl))


   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages then consider to create a layer, you can also put the
   ;; configuration in `dotspacemacs/config'.
   dotspacemacs-additional-packages `(
                                      session
                                      osm
                                      casual
                                      solaire
                                      elfeed-tube-mpv
                                      discover
                                      ellama
                                      catppuccin
                                      avk-emacs-themes
                                      mastodon
                                      envrc
                                      codegpt
                                      eat
                                      (copilot :location (recipe
                                                          :fetcher github
                                                          :repo "zerolfx/copilot.el"
                                                          :files ("*.el" "dist")))
                                      evil-god-state
                                      popper
                                      ;; persistent-scratch
                                      ;; indium
                                      sqlformat
                                      ;; rufo
                                      edit-server
                                      org-tanglesync
                                      emamux
                                      ivy-prescient
                                      acme-theme
                                      reveal-in-osx-finder
                                      ;; jest
                                      inflections
                                      ;; (multi-vterm :location (recipe :fetcher github :repo "suonlight/multi-vterm" :files ("*.el") :upgrade 't))
                                      copy-as-format
                                      ;; gif-screencast
                                      kaolin-themes
                                      sunburn-theme
                                      grayscale-theme
                                      iodine-theme
                                      hydandata-light-theme
                                      github-modern-theme
                                      ;; multishell
                                      ob-elixir
                                      ;; org-jira
                                      (org-rich-yank :location (recipe :fetcher github :repo "unhammer/org-rich-yank" :files ("*.el") :upgrade 't))
                                      ;; ialign
                                      ;; beacon
                                      helpful
                                      (rusti :location (recipe :fetcher github :repo "ruediger/rusti.el" :files ("rusti.el") :upgrade 't))
                                      eink-theme
                                      doom-themes
                                      creamsody-theme
                                      borland-blue-theme
                                      atom-one-dark-theme
                                      atom-dark-theme
                                      abyss-theme
                                      easy-jekyll
                                      ;; flymake-solidity
                                      ;; solidity-mode
                                      sx
                                      ;; ts-comint
                                      ;; vagrant-tramp
                                      ;; ob-php
                                      ;; ob-typescript
                                      labburn-theme
                                      evil-rails
                                      evil-easymotion
                                      evil-extra-operator
                                      realgud
                                      ;; realgud-pry
                                      plan9-theme
                                      sourcerer-theme
                                      0xc
                                      ;; fuel
                                      ;; lfe-mode
                                      x-path-walker
                                      ;; pivotal-tracker
                                      suggest
                                      tramp-term
                                      dark-mint-theme
                                      yagist
                                      ;; sage-shell-mode
                                      ;; intero
                                      ;; (howdoi :location (recipe
                                      ;;                    :repo "dcluna/emacs-howdoi"
                                      ;;                    :fetcher github
                                      ;;                    :branch "html2text-emacs26")
                                      ;;         :upgrade 't)
                                      multi-compile
                                      dumb-jump
                                      tldr
                                      rainbow-mode
                                      paredit
                                      ruby-refactor
                                      ;; nvm
                                      ;; nov
                                      ;; yarn-mode
                                      package-lint
                                      flycheck-package
                                      (doom-snippets
                                       :location (recipe :repo "hlissner/doom-snippets"
                                                         :fetcher github
                                                         :files ("*")))

                                      (yasnippet-ruby-mode
                                       :location (recipe :repo "bmaland/yasnippet-ruby-mode"
                                                         :fetcher github
                                                         :files ("*")))

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
                                      evil-embrace
                                      editorconfig)
                                      ;; wsd-mode


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
   dotspacemacs-line-numbers t
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
   dotspacemacs-startup-lists '((recents . 20) (projects . 20) (bookmarks . 5))
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes (if (display-graphic-p)
                           dcl/all-themes
                         (dcl/shuffle '(
                                        twilight-bright
                                        hemisu-light
                                        apropospriate-light
                                        flatui
                                        doom-one
                                        plan9
                                        organic-green
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
   dotspacemacs-default-font (cons (car (dcl/shuffle (list
                                                      "Azeret Mono" "Bitstream Vera Sans Mono" "Martian Mono" "Hack Nerd Font")))
                                   '(
                                     :size 13
                                     :weight normal
                                     :width normal
                                     :powerline-scale 1.1))
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
   dotspacemacs-fullscreen-at-startup nil
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
   dotspacemacs-mode-line-theme 'doom
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
  (setq-default ruby-version-manager 'rbenv)
  (setq-default ruby-enable-ruby-on-rails-support t)
  (setq configuration-layer-elpa-archives
        '(("melpa-stable" . "stable.melpa.org/packages/")
          ("melpa" . "melpa.org/packages/")
          ("org" . "orgmode.org/elpa/")
          ("nongnu" . "elpa.nongnu.org/nongnu/")
          ("gnu" . "elpa.gnu.org/packages/")
          ("jcs-elpa" . "https://jcs-emacs.github.io/jcs-elpa/packages/")))
  (add-to-list 'package-pinned-packages '(ensime . "melpa-stable"))
  ;; (if (and (require 'server) (fboundp 'server-running-p) (server-running-p "adquick"))
  ;;     (progn
  ;;       (setq server-name "server"))
  ;;     (if (file-exists-p "~/.hammerspoon/spacehammer.el") (load-file (expand-file-name "~/.hammerspoon/spacehammer.el"))))
  (server-start)
  (add-to-list 'package-pinned-packages '(magit . "melpa-stable"))
  (setq package-archive-priorities '(("melpa"    . 5)
                                     ("jcs-elpa" . 0))))
  ;; (add-to-list 'package-pinned-packages '(dash . "melpa-stable"))
  ;; (add-to-list 'package-pinned-packages '(async . "melpa-stable"))

(defun dotspacemacs/user-config ()
  (load-file (expand-file-name "~/dotfiles/spacemacs-user-config.el")))
