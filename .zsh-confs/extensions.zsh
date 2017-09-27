# smartcd activation
# [ -r "$HOME/.smartcd_config" ] && ( [ -n $BASH_VERSION ] || [ -n $ZSH_VERSION ] ) && source ~/.smartcd_config

# zsh-autoenv
# export AUTOENV_DEBUG=1
source ~/code/zsh-autoenv/autoenv.zsh

# deer file manager for zsh
source ~/code/deer/deer
zle -N deer
bindkey -M vicmd '\ek' deer

# enhancd
ENHANCD_FILTER=fzy; export ENHANCD_FILTER
source ~/code/enhancd/init.sh
