if [ -n "$INSIDE_EMACS" ]; then
    export PATH="$PATH:/usr/local/bin"
fi

export PATH="$PATH:/usr/local/global-6.6.2/bin"
export PATH="$PATH:$HOME/.bin"
export CRONITOR_CONFIG="/Users/dluna/.cronitor.json"
alias eman='PAGER=less man -P eless'

[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# already loaded in https://github.com/dcluna/dotfiles/blob/022618eee2cbe1faace2486cd374e1837ac81f2e/.zshrc#L153

if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
