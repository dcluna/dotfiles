# export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

function ruby_version(){
    echo $RUBY_VERSION
}

# source ~/.rvm/scripts/rvm # activates rvm early
# sets the current ruby (via rvm) as the right prompt
# ORIGINAL_RPROMPT=$RPROMPT
# set-ruby-version () {
#     RPROMPT=$ORIGINAL_RPROMPT:[%{$fg_no_bold[red]%}$(ruby_version)%{$reset_color%}]
# }
