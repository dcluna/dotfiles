if [ -n "$INSIDE_EMACS" ]; then
    export PATH="$PATH:/usr/local/bin"
fi

export PATH="$PATH:/usr/local/global-6.6.2/bin"
export PATH="$PATH:/Users/dluna/.bin"
export CRONITOR_CONFIG="/Users/dluna/.cronitor.json"
alias eman='PAGER=less man -P eless'

eval "$(fasd --init auto)"
