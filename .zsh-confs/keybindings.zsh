dclls(){
    ls
    du -sh
    # add a newline or reset-prompt will eat the size listing
    echo; zle reset-prompt
}; zle -N dclls
# 'ls' key in normal mode
bindkey -M vicmd "\el" dclls

dcl-copy-pwd-to-clipboard() {
   echo $PWD | clip
   echo "Copied $PWD to clipboard"
   echo; zle reset-prompt
}; zle -N dcl-copy-pwd-to-clipboard
bindkey -M vicmd "\ep" dcl-copy-pwd-to-clipboard

dcl-ls-choose (){
    zle -K viins
    LBUFFER+="ls "
    zle expand-or-complete
}; zle -N dcl-ls-choose
bindkey -M vicmd "\eL" dcl-ls-choose

dclemacsclient(){
    env emacsclient -nw -a "" $1
}

dcl-emacsclient-file (){
    zle -K viins
    LBUFFER+="$EDITOR "
    zle expand-or-complete
}; zle -N dcl-emacsclient-file
bindkey -M vicmd "\ee" dcl-emacsclient-file

dcl-kill-process (){
    zle -K viins
    LBUFFER+="kill "
    zle menu-expand-or-complete
}; zle -N dcl-kill-process
bindkey -M vicmd "\ek" dcl-kill-process

autoload -U dclemacsclient
zle -N dclemacsclient

dcl-edit-dotfile(){
    zle dclemacsclient ~/.zshrc
    echo
    zle reset-prompt
}; zle -N dcl-edit-dotfile
bindkey -M vicmd "\ez" dcl-edit-dotfile

dcl-grepi (){
    LBUFFER+=" | grepi "
}; zle -N dcl-grepi
bindkey -M viins "\eg" dcl-grepi
bindkey -M vicmd "\eg" dcl-grepi

dcl-install (){
    LBUFFER+="sudo apt-get install "
    zle -K viins
 }; zle -N dcl-install
bindkey -M vicmd "\eI" dcl-install

dcl-fm (){
    caja `pwd`
    # echoes a newline and resets the prompt to get the 'newline effect'
    echo; zle reset-prompt
}; zle -N dcl-fm
bindkey -M vicmd "\ef" dcl-fm

# togglable echo function
echo-dbg () {
    if [ ! -z "$DCL_DBG" -a "$DCL_DBG" != " " ]; then
        echo $*
    fi
}

export DCL_DBG="true"
export DROPBOX_HOME="/home/$USER/Dropbox"

deploy-ccz (){
    if [ "$#" -lt 2 ]; then
        echo "Usage: $0 exportfilename sourcedir"
        echo "Generates \$exportfilename.ccz file with the contents from \$sourcedir and moves it to current dropbox home ($DROPBOX_HOME)"
    else
        exportfile="$1.ccz"
        sourcedir="$2"
        echo-dbg "Generating $exportfile from directory $sourcedir and moving it to $DROPBOX_HOME"
        zip -r $exportfile $sourcedir && cp $exportfile $DROPBOX_HOME
    fi
}


if [ -n "$EMACS" ]; then
    echo "no vi keybindings inside emacs terms"
else
    # vi keybindings for zsh
    bindkey -v
    zle-keymap-select () {
        if [ $TERM = "screen" ]; then
            if [ $KEYMAP = vicmd ]; then
                echo -ne '\033P\033]12;#ff6565\007\033\\'
            else
                echo -ne '\033P\033]12;grey\007\033\\'
            fi
        elif [ $TERM != "linux" ]; then
            if [ $KEYMAP = vicmd ]; then
                echo -ne "\033]12;#ff6565\007"
            else
                echo -ne "\033]12;grey\007"
            fi
        fi
    }; zle -N zle-keymap-select
    zle-line-init () {
        zle -K viins
        if [ $TERM = "screen" ]; then
            echo -ne '\033P\033]12;grey\007\033\\'
        elif [ $TERM != "linux" ]; then
            echo -ne "\033]12;grey\007"
        fi
        zle vi-cmd-mode
    }; zle -N zle-line-init
fi


# kills the lag from pressing ESC and showing the new cursor
export KEYTIMEOUT=1

# opp for vi-ish text objects
# ls $HOME/code/opp.zsh || (cd $HOME/code/ && git clone https://github.com/hchbaw/opp.zsh.git && cd -)
source $HOME/code/opp.zsh/opp.zsh

# disables 'suspend' in terms - this is particularly annoying with spacemacs' C-z shortcut for getting back to normal mode
bindkey -r "^Z"
