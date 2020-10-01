# antibody use oh-my-zsh

function antibody_reload_file() {
    source <(antibody init)
    antibody bundle < $HOME/.ghq/github.com/dcluna/dotfiles/.zsh-confs/antibody-bundles.txt > $HOME/.ghq/github.com/dcluna/dotfiles/.zsh-confs/antibody-bundles-script.sh
}
# antibody apply
