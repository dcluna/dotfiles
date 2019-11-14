;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

;;; I HATE this, but spacemacs does weird stuff with org when loading. Best case scenario is just load my tangled file and not forget to tangle it after meaningful changes.
;; (org-babel-load-file "~/dotfiles/spacemacs.org")
(load-file "~/dotfiles/spacemacs.el")

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
     [default default default italic underline success warning])
   '(ansi-color-names-vector
     ["black" "red3" "ForestGreen" "yellow3" "blue" "magenta3" "DeepSkyBlue" "gray50"])
   '(background-color "#202020")
   '(background-mode dark)
   '(compilation-message-face 'default)
   '(cursor-color "#cccccc")
   '(cursor-type 'bar)
   '(default-frame-alist
      '((buffer-predicate . spacemacs/useful-buffer-p)
        (vertical-scroll-bars)
        (alpha 85)
        (fullscreen . fullboth)))
   '(diary-entry-marker 'font-lock-variable-name-face)
   '(emms-mode-line-icon-image-cache
     '(image :type xpm :ascent center :data "/* XPM */
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
\"#######..#\" };"))
   '(erc-hide-list '("JOIN" "PART" "QUIT"))
   '(evil-escape-key-sequence "jk")
   '(evil-want-Y-yank-to-eol nil)
   '(fci-rule-character-color "#202020")
   '(fci-rule-color "#f6f0e1")
   '(foreground-color "#cccccc")
   '(fringe-mode 4 nil (fringe))
   '(global-rbenv-mode t)
   '(gnus-logo-colors '("#259ea2" "#adadad") t)
   '(gnus-mode-line-image-cache
     '(image :type xpm :ascent center :data "/* XPM */
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
\"###########.######\" };") t)
   '(highlight-changes-colors '("#FD5FF0" "#AE81FF"))
   '(highlight-tail-colors
     '(("#3C3D37" . 0)
       ("#679A01" . 20)
       ("#4BBEAE" . 30)
       ("#1DB4D0" . 50)
       ("#9A8F21" . 60)
       ("#A75B00" . 70)
       ("#F309DF" . 85)
       ("#3C3D37" . 100)))
   '(hl-paren-background-colors '("#e8fce8" "#c1e7f8" "#f8e8e8"))
   '(hl-paren-colors '("#40883f" "#0287c8" "#b85c57"))
   '(hl-sexp-background-color "#1c1f26")
   '(indium-nodejs-inspect-brk t)
   '(linum-format " %7i ")
   '(magit-diff-expansion-threshold 5)
   '(magit-diff-use-overlays nil)
   '(magit-todos-keywords 'hl-todo-keyword-faces)
   '(main-line-color1 "#1E1E1E")
   '(main-line-color2 "#111111")
   '(main-line-separator-style 'chamfer)
   '(nrepl-message-colors
     '("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3"))
   '(org-agenda-files '("~/client-code/genome/agenda.org"))
   '(org-babel-load-languages
     '((scheme . t)
       (ruby . t)
       (elixir . t)
       (restclient . t)
       (shell . t)
       (clojure . t)
       (python . t)
       (emacs-lisp . t)))
   '(org-latex-classes
     '(("moderncv" "\\documentclass[12pt,a4paper,sans,unicode]{moderncv}"
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
        ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))
   '(org-src-tab-acts-natively t)
   '(package-selected-packages
     '(play-crystal ob-crystal inf-crystal flycheck-crystal crystal-mode ameba nov mocha pmd flycheck-package package-lint indium sourcemap orgit org-brain ob-elixir evil-org yarn-mode tide nvm rufo toml-mode racer flycheck-rust cargo rust-mode sayid password-generator impatient-mode godoctor flycheck-bashate evil-lion dante company-php ac-php-core xcscope powershell elfeed-org winum white-sand-theme symon string-inflection rebecca-theme realgud test-simple loc-changes load-relative magithub ghub+ s magit-popup git-commit with-editor apiwrap ghub madhat2r-theme go-rename fuzzy flymd flycheck-credo emoji-cheat-sheet-plus doom-themes all-the-icons memoize font-lock+ company-lua company-emoji browse-at-remote dockerfile-mode docker tablist docker-tramp dash async company-ansible markdown-mode markdown-mode+ eziam-theme ox-reveal vi-tilde-fringe evil-nerd-commenter zonokai-theme znc zenburn-theme zen-and-art-theme zeal-at-point yapfify yaml-mode yagist xterm-color x86-lookup x-path-walker wsd-mode ws-butler window-numbering which-key web-mode web-beautify volatile-highlights vimrc-mode vagrant-tramp vagrant uuidgen use-package underwater-theme ujelly-theme twilight-theme twilight-bright-theme twilight-anti-bright-theme tronesque-theme tramp-term toxi-theme toc-org tao-theme tangotango-theme tango-plus-theme tango-2-theme tagedit sunny-day-theme suggest sublime-themes subatomic256-theme subatomic-theme sql-indent spacemacs-theme spaceline spacegray-theme sourcerer-theme soothe-theme sonic-pi solarized-theme soft-stone-theme soft-morning-theme soft-charcoal-theme smyx-theme smeargle slime-company slim-mode slack shen-mode shen-elisp shell-pop seti-theme selectric-mode scss-mode sage-shell-mode rvm ruby-tools ruby-test-mode ruby-refactor rubocop robe reverse-theme restclient-helm restart-emacs reek rbenv ranger rainbow-mode rainbow-identifiers rainbow-delimiters railscasts-theme racket-mode quelpa pyvenv pytest pylint pyenv-mode py-isort py-autopep8 purple-haze-theme pug-mode professional-theme prodigy planet-theme plan9-theme pivotal-tracker pip-requirements phpunit phpcbf php-extras php-auto-yasnippets phoenix-dark-pink-theme phoenix-dark-mono-theme persp-mode pastels-on-dark-theme paredit-menu paradox ox-jira ox-gfm organic-green-theme org-projectile org-present org-pomodoro org-download org-bullets open-junk-file omtose-phellack-theme oldlace-theme occidental-theme obsidian-theme ob-restclient noctilux-theme niflheim-theme neotree nasm-mode naquadah-theme mustang-theme mu4e-maildirs-extension mu4e-alert move-text monokai-theme monochrome-theme molokai-theme moe-theme mmm-mode minitest minimal-theme meme material-theme markdown-toc majapahit-theme magit-gitflow magit-gh-pulls lush-theme lua-mode lorem-ipsum livid-mode live-py-mode linum-relative link-hint light-soap-theme lfe-mode less-css-mode labburn-theme json-mode js2-refactor js-doc jinja2-mode jedi-direx jbeans-theme jazz-theme ir-black-theme intero insert-shebang inkpot-theme info+ indent-guide ido-vertical-mode hy-mode hungry-delete htmlize howdoi hlint-refactor hl-todo hindent highlight-parentheses highlight-numbers highlight-indentation hide-comnt heroku-theme hemisu-theme help-fns+ helm-themes helm-swoop helm-pydoc helm-purpose helm-projectile helm-mt helm-mode-manager helm-make helm-hoogle helm-gitignore helm-flx helm-descbinds helm-dash helm-css-scss helm-company helm-c-yasnippet helm-ag hc-zenburn-theme haskell-snippets haml-mode gruvbox-theme gruber-darker-theme grandshell-theme gotham-theme google-translate golden-ratio go-guru go-eldoc gnuplot gmail-message-mode github-search github-clone github-browse-file gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe git-gutter-fringe+ gist gh-md geiser geeknote gandalf-theme fuel flycheck-pos-tip flycheck-mix flycheck-haskell flx-ido flatui-theme flatland-theme fish-mode firebelly-theme fill-column-indicator feature-mode farmhouse-theme fancy-battery eyebrowse exercism exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-snipe evil-search-highlight-persist evil-rails evil-quickscope evil-paredit evil-numbers evil-mc evil-matchit evil-magit evil-lisp-state evil-indent-plus evil-iedit-state evil-extra-operator evil-exchange evil-escape evil-embrace evil-ediff evil-easymotion evil-commentary evil-cleverparens evil-args evil-anzu espresso-theme eshell-z eshell-prompt-extras esh-help erlang erc-yt erc-view-log erc-social-graph erc-image erc-hl-nicks enh-ruby-mode engine-mode emmet-mode elisp-slime-nav elfeed-web elfeed-goodies editorconfig edit-server dumb-jump drupal-mode dracula-theme django-theme disaster diff-hl define-word debbugs darktooth-theme darkokai-theme darkmine-theme darkburn-theme dark-mint-theme dakrone-theme dactyl-mode cython-mode cyberpunk-theme csv-mode company-web company-tern company-statistics company-shell company-restclient company-quickhelp company-go company-ghci company-ghc company-cabal company-c-headers company-anaconda common-lisp-snippets column-enforce-mode color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized color-identifiers-mode coffee-mode cmm-mode cmake-mode clues-theme clojure-snippets clj-refactor clean-aindent-mode clang-format cider-eval-sexp-fu chruby cherry-blossom-theme busybee-theme bundler bubbleberry-theme birds-of-paradise-plus-theme badwolf-theme auto-yasnippet auto-highlight-symbol auto-compile ascii apropospriate-theme anti-zenburn-theme ansible-doc ansible ample-zen-theme ample-theme alect-themes alchemist aggressive-indent afternoon-theme adaptive-wrap ace-window ace-link ace-jump-helm-line ac-ispell 0xc))
   '(paradox-automatically-star t)
   '(paradox-github-token t)
   '(pdf-view-midnight-colors '("#DCDCCC" . "#383838"))
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
     '(("theguarantors_folding_bug"
        (sql-product 'postgres)
        (sql-database "theguarantors_folding_bug"))
       ("theguarantors_dev_old"
        (sql-product 'postgres)
        (sql-database "theguarantors_dev_old"))
       ("theguarantors_development"
        (sql-product 'postgres)
        (sql-database "theguarantors_development"))))
   '(tls-checktrust t)
   '(vc-annotate-background "#f6f0e1")
   '(vc-annotate-color-map
     '((20 . "#e43838")
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
       (360 . "#a020f0")))
   '(vc-annotate-very-old-color "#a020f0")
   '(weechat-color-list
     (unspecified "#272822" "#3C3D37" "#F70057" "#F92672" "#86C30D" "#A6E22E" "#BEB244" "#E6DB74" "#40CAE4" "#66D9EF" "#FB35EA" "#FD5FF0" "#74DBCD" "#A1EFE4" "#F8F8F2" "#F8F8F0"))
   '(when
        (or
         (not
          (boundp 'ansi-term-color-vector))
         (not
          (facep
           (aref ansi-term-color-vector 0)))))
   '(winum-scope 'frame-local)
   '(woman-manpath
     '("/usr/man" "/usr/share/man" "/usr/local/share/man"
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
       ("/opt/sbin" . "/opt/man")))
   '(woman-path
     '("/home/dancluna/.rvm/gems/ruby-2.3.1/gems/bundler-1.13.6/man"))
   '(yas-snippet-dirs
     '("/Users/danielluna/yasnippets" "/Users/danielluna/.emacs.d/private/snippets/" yas-installed-snippets-dir "/Users/danielluna/.emacs.d/layers/+completion/auto-completion/local/snippets" "/Users/danielluna/.emacs.d/elpa/clojure-snippets-20170713.2310/snippets" "/Users/danielluna/.emacs.d/elpa/common-lisp-snippets-20170522.2147/snippets" "/Users/danielluna/.emacs.d/elpa/haskell-snippets-20160918.1722/snippets")))
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   )
  )
