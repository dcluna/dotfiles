alias acs='apt-cache search'
alias acsh='apt-cache show'
alias suagi='sudo apt-get install'
alias suagy='sudo apt-get install -y'
alias sagu='sudo apt-get update'
alias grepi='grep -i'
alias ec='emacsclient -nw'
alias lls='ls -lh'
alias gpgshell='/usr/bin/wxGnuPGShell'
alias juntatodosospdfs='gs -q -sPAPERSIZE=letter -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=output.pdf `ls *.pdf`'
alias clip='xclip -selection clipboard'
alias jlok='java -jar /home/$USER/bin/JLokalize.jar'
alias prologia='java -cp /home/$USER/bin/Prologia-I18N_2004-08-20/antlr.jar -jar /home/$USER/bin/Prologia-I18N_2004-08-20/I18N.jar'
alias prologiaccodk='java -cp /home/$USER/bin/Prologia-I18N_2004-08-20/antlr.jar -jar /home/$USER/bin/Prologia-I18N_2004-08-20/I18N.jar "/home/dancluna/code/commcare-odk/app" "/home/dancluna/code/prologiaTranslation" "/home/dancluna/code/prologiaTranslation/info.txt" "/home/dancluna/code/prologiaTranslation/bamboolanguage.properties"'
alias skull="clear && lua ~/code/l33tscripts/3spooky.lua"
alias dropdbg="cp build/outputs/apk/commcare-odk-gradle-debug.apk ~/Dropbox/ccare-odk-ldb.apk"
# editpdf used to be 'flpsed', but it's a lousy program
alias editpdf="xournal"
alias e="emacsclient -c"
alias brspec='bundle exec rspec'
alias ghist='history | grep -i'
alias re="remacsclient -c"
alias rec='remacsclient -nw -a ""'
alias spacevim='docker run -it --rm spacevim/spacevim nvim'

# cleans a block of text between $1 and $2 patterns
function cleanbetween() {
    sed "/$1/,/$2/d"
}

function jpglines() {
    command='if ($m) { $m = 0; print } $m++ if /(\d+).jpg/ && ($1 % ' . $1 . ' == 0)'
    echo $command
    # perl -ne $command
}

function pdfextractpages(){
    page=`basename "${1%.*}_%02d.${1##*.}"` # black magic thanks to http://stackoverflow.com/a/25122981
    # echo "$page"
    pdftk "$1" burst output "$page" 2>&1
}

# alias getnthline='perl -ne "if ($m) { $m = 0; print } $m++ if /(\d+).gif/ && ($1 % $LINES == 0)"'
alias specs='unbuffer bundle exec rspec spec --format Bdd::RSpec::Formatter --fail-fast | tee rspec-output.txt'
alias -g suagiprep="| cut -f 1 -d\ | paste -s -d ' '"
alias functions='declare -f | grep "{$"'
alias rvmglobal='rvm @global do'
alias rvmdefault='rvm default do'

export FIDDLER_HOME='/home/dancluna/bin/Fiddler/app'
alias fiddler="mono $FIDDLER_HOME/Fiddler.exe"
alias monit-tunnel-staging="ssh -L 2812:localhost:2812 durst-portal-staging"
alias monit-tunnel-production="ssh -L 2812:localhost:2812 durst-portal-production"
alias gyb="python3 $GYB_HOME/gyb.py"

function bundle-local-lib-set(){
    bundle config local.$1 /home/dancluna/code/$1
}

# compdef {_,}bundle-local-lib-set

# function _bundle-local-lib-set(){
#     LIBS=$(ls -d /home/dancluna/code/*/)
#     _arguments "1:directory:$LIBS"
# }

function bundle-local-lib-unset(){
    bundle config --delete local.$1
}

alias erc="emacs --execute \"(call-interactively #'erc)\""
alias erc-nw="emacs -nw --execute \"(call-interactively #'erc)\""
alias znc-erc="emacs --execute \"(call-interactively #'znc-erc)\""
alias znc-erc-nw="emacs -nw --execute \"(call-interactively #'znc-erc)\""
alias be="bundle exec"
function generate-pw(){
    pwgen -1 -s $1 | shuf -n 1
}
alias reddit='rtv --enable-media'
alias aslr_on='cat /proc/sys/kernel/randomize_va_space | grep 2 >> /dev/null && echo "on" || echo "off"'
alias bers='bundle exec rails server'
alias berrs='bundle exec rescue rails server'

function vecho(){
    echo "$1" | espeak &
}

CHROME_WINDOW_SIZE="890,900"
CHROME_SCREENSHOT_NAME="chromescreenshot.png"

function chromess(){
    google-chrome --headless --disable-gpu --window-size=$CHROME_WINDOW_SIZE --screenshot=$CHROME_SCREENSHOT_NAME $1
}

alias mitmp="mitmproxy --palette solarized_dark"
alias iotaseedgen="cat /dev/urandom |tr -dc A-Z9|head -c${1:-81}"
alias pairsession="tmcreate pair && tma pair"

alias asciicast2gif='docker run --rm -e DEBUG -e "GIFSICLE_OPTS=--lossy=80" -e "NODE_OPTS=--max-old-space-size=12288" -e "MAGICK_MEMORY_LIMIT=6gb" -e "MAGICK_MAP_LIMIT=12gb" -v $PWD:/data asciinema/asciicast2gif'
alias availablerubies='rbenv install -l | $PAGER'

alias vi='nvim'

# rust utilities
# alias time='hyperfine'
alias top='btm -b'
alias pgsyncd='pgsync --debug'
alias cat='bat --paging=never'
