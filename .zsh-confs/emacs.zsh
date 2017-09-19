if [ -n "$EMACS" ]; then
    export PAGER="/bin/cat"
fi

export PATH="$HOME/.evm/bin:$PATH"

export EDITOR='emacsclient -s dcl -a "" -nw'
export VISUAL='emacsclient -s dcl -a ""'
