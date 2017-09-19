# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"
if [ -n "$EMACS" ]; then
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    export TERM=xterm-256color
    ZSH_THEME="duellj"
else
    ZSH_THEME="duellj"
fi

# funny color schemes
wal -r &

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

plugins=(git ruby rails rake rake-fast rvm node nvm npm nvm-auto nvm-auto)
# plugins=(git ruby autoenv rails rake rake-fast rvm)
# plugins=(git ruby)

source $ZSH/oh-my-zsh.sh

source ~/.zsh-confs/python.zsh

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

export GYB_HOME="$HOME/code/got-your-back"

source ~/.zsh-confs/aliases.zsh
source ~/.zsh-confs/android.zsh

source ~/.zsh-confs/keybindings.zsh

export CLING_HOME="$HOME/code/inst" # cpp interpreter
export PATH="$PATH:$CLING_HOME/bin"
export PATH="$HOME/code/git:$PATH"
export PATH="$HOME/.linuxbrew/bin:$PATH"
export PATH="$HOME/code/apache-storm-0.9.5/bin:$PATH"
export CHROMEDRIVER="/opt/google/chrome-beta/google-chrome-beta"

# docker completion
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i

source ~/.zsh-confs/ruby.zsh

source ~/.zsh-confs/emacs.zsh

export INFOPATH="$HOME/Downloads:$HOME/code/python-info/build:$HOME/code/guix/doc:/usr/local/share/info:/usr/share/info"

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
# [[ -s "$HOME/.gvm/bin/gvm-init.sh" ]] && source "$HOME/.gvm/bin/gvm-init.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# export SOURCES_DIR="$HOME/.zsh-confs/sources.d"

# for file in $SOURCES_DIR/*; do
#     echo "Loading $file"
#     source $file
# done

export PATH="$HOME/bin/elixir-1.1.1/bin:$PATH"

test -s "$HOME/.kiex/scripts/kiex" && source "$HOME/.kiex/scripts/kiex"

PATH="$HOME/perl5/bin${PATH+:}${PATH}"; export PATH;
PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;

# source `which aws_zsh_completer.sh`

source "$HOME/code/zsh-autoenv/autoenv.zsh"

export JAVA_HOME="$HOME/bin/jdk1.8.0_144"

export PATH="$JAVA_HOME/bin:$PATH"

# AWS settings
# The exit status of a pipeline is the exit status of the last command in the pipeline, unless the pipefail option is enabled (see The Set Builtin). If pipefail is enabled, the pipeline's return status is the value of the last (rightmost) command to exit with a non-zero status, or zero if all commands exit successfully.
# set -o pipefail

export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig/"

export PATH="$HOME/.cask/bin:$PATH"

export PATH="$HOME/code-examples:$PATH"

export GOROOT_BOOTSTRAP="$HOME/bin/go"

export GOPATH="$HOME/go"

export PATH="$GOPATH:$PATH"

export CODE_DIR="$HOME/code"

export PATH="$PATH:$CODE_DIR/no-more-secrets/bin"

export PATH="$PATH:$HOME/bin/hashcat-3.00"

export PATH="$HOME/bin/node-v4.5.0-linux-x64/bin:$PATH"

export PATH="$HOME/code-examples:$PATH"

DWARF_FORTRESS_PATH="$HOME/games/df_linux"
export DWARF_FORTRESS_PATH="$DWARF_FORTRESS_PATH/df_linux:$DWARF_FORTRESS_PATH"

# export PATH="$DWARF_FORTRESS_PATH:$PATH"

export SASS_LIBSASS_PATH="$HOME/code/libsass"

export SKIP_HOOKUP=1 git checkout master

export PROCESSING_PATH="$HOME/bin/processing-3.0.2/"

export SONIC_PI_DIR="$HOME/code/sonic-pi"

export XERCES_HOME="/usr/share/java"

export RSPEC_PROFILING="false"
export VORLON="true"

export REVEALJS_DIR="$HOME/bin/reveal.js-3.3.0"

export EXPLOIT_EX_DIR="$HOME/code-examples/exploit-exercises/protostar"

source $HOME/.cargo/env

export AMDAPPSDKROOT="/mnt/lmde/home/dcluna/AMDAPPSDK-3.0"

export DTK_PROGRAM=espeak
export EMACSPEAK_DIR="$HOME/code/emacspeak"
export PATH="$HOME/bin/mbrola:$PATH"
export PATH="$HOME/code/lastpass-cli:$PATH"

export WINEARCH="win32"

export REMACS_DIR="$HOME/code/remacs"
export THEGUARANTORS_DIR="$HOME/client-code/theguarantors.com"
# alias remacs="RUST_BACKTRACE=1 $REMACS_DIR/src/remacs"

if [ -n "$EMACS" ]; then
else
    # 'welcome screen' with ponies
    text=`fortune | iconv -t 'ASCII' 2>>/dev/null`; ponysay "$text"; if [ `shuf -i 1-100 -n 1` -lt 10 ]; then espeak -v mb-us1 "$text" &; fi
fi
nvm_auto_switch

[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

