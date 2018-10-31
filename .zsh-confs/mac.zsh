if [ -n "$INSIDE_EMACS" ]; then
    export PATH="$PATH:/usr/local/bin"
fi

export PATH="$PATH:/usr/local/global-6.6.2/bin"
alias eman='PAGER=less man -P eless'
