function current_venv {
    if [ ! -z "$VIRTUAL_ENV" -a "$VIRTUAL_ENV" != " " ]; then
        echo `basename $VIRTUAL_ENV`
    fi
}

function cdvenv {
    cd $VIRTUAL_ENV
}

# sets the current virtualenv as the right prompt
RPROMPT=$RPROMPT:[%{$fg_no_bold[yellow]%}$(current_venv)%{$reset_color%}]

# pywal
PATH="${PATH}:${HOME}/.local/bin/"
