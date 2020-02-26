if [ -n "$INSIDE_EMACS" ]; then
    export PATH="$PATH:/usr/local/bin"
fi

export PATH="$PATH:/usr/local/global-6.6.2/bin"
export PATH="$PATH:/Users/dluna/.bin"
export CRONITOR_CONFIG="/Users/dluna/.cronitor.json"
alias eman='PAGER=less man -P eless'

eval "$(fasd --init auto)"

[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

. $(brew --prefix asdf)/asdf.sh
. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash

if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
