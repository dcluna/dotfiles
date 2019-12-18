antigen use oh-my-zsh

antigen theme https://github.com/denysdovhan/spaceship-zsh-theme spaceship

antigen bundles <<EOBUNDLES
    unixorn/autoupdate-antigen.zshplugin
    oldratlee/hacker-quotes
    tysonwolker/iterm-tab-colors
    amstrad/oh-my-matrix
    cal2195/q
    jreese/zsh-titles
    gko/ssh-connect
    vasyharan/zsh-brew-services
    pkulev/zsh-rustup-completion
    zpm-zsh/ssh
    RobertAudi/tsm
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-syntax-highlighting
    zsh-users/zsh-completions
    dcluna/tmate-zsh-plugin
EOBUNDLES

antigen apply
