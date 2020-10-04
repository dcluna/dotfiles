# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export ZSH_CUSTOM="$ZSH/custom"
export ZSH_DISABLE_COMPFIX="true"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"
# if [ -n "$EMACS" ]; then
#     export LANG=en_US.UTF-8
#     export LC_ALL=en_US.UTF-8
#     export TERM=xterm-256color
#     ZSH_THEME="dogenpunk"
# else

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wi2gold:$HOME/bin/android-ndk-r10d:$HOME/bin/jdk1.8.0_31/bin:$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
# export MANPATH="/usr/local/man:$MANPATH"

plugins=(git ruby rails rake rake-fast rbenv node npm yarn rust osx history-substring-search docker docker-compose pyenv history)
# plugins=(git ruby autoenv rails rake rake-fast rvm)
# plugins=(git ruby)

if type brew &>/dev/null; then
    # FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
    FPATH=/usr/local/share/zsh/site-functions:$FPATH
fi

source $ZSH/oh-my-zsh.sh

# source <(antibody init)
# source /usr/local/share/antigen/antigen.zsh

for file in `ls ~/dotfiles/.zsh-confs/*.zsh`; do
    source $file
done

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
# export EDITOR='emacsclient -a "" -nw'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# docker completion
# fpath=(~/.zsh/completion $fpath)
# autoload -Uz compinit
# if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
#   compinit -i;
# else
#   compinit -i -C;
# fi;

# enable vi-mode by default in new shells
# spaceship_vi_mode_enable

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
# eval "$(nodenv init -)"
#if [[  -n "$EMACS" || -n "$TMUX"  ]]; then
#else
#    # VOICE='-v mb-us1'
#    # 'welcome screen' with ponies
#    text=`fortune | iconv -t 'ASCII' 2>>/dev/null`; ( ponysay "$text" &; coinmon -t 99 -C 3 & );
#fi
#nvm_auto_switch
#
# [[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# added by Anaconda2 installer
# export PATH="/home/dancluna/anaconda2/bin:$PATH"
export PATH="$PATH:/home/dancluna/anaconda2/bin"
export PATH="$PATH:/home/dancluna/.bin"

# show my stock tickers on every new term
if [ -n "$TMUX" ] && [ -z "$EMACS" ]; then
    source hacker-quotes.plugin.zsh
    # ~/.ghq/github.com/pstadler/ticker.sh/ticker.sh $(cat ~/dotfiles/.ticker.conf)
else
fi

eval "$(direnv hook zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
# if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# source asdf
# . $(brew --prefix asdf)/asdf.sh
. /usr/local/opt/asdf/asdf.sh
. /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash
. ~/.asdf/plugins/java/set-java-home.zsh

if [ -e /Users/danielluna/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/danielluna/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

if [[ -z "$INSIDE_EMACS" ]]; then
  alias ls='exa'
fi

eval "$(starship init zsh)"

# enables vi mode
# taken from http://stratus3d.com/blog/2017/10/26/better-vi-mode-in-zshell/
bindkey -v
bindkey -M vicmd "^V" edit-command-line
