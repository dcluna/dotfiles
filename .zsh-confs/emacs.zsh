if [ -n "$EMACS" ]; then
    export PAGER="/bin/cat"
fi

export PATH="$HOME/.evm/bin:$PATH"

export EDITOR='emacsclient -a "" -nw'
export VISUAL='emacsclient -a ""'

export REMACS_DIR="$HOME/code/remacs"

export DTK_PROGRAM=espeak
export EMACSPEAK_DIR="$HOME/code/emacspeak"

export PATH="$HOME/bin/mbrola:$PATH"

export MANPAGER="eless"
