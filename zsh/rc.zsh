source_if_exists () {
    if test -r "$1"; then
        source "$1"
    fi
}

source_if_exists $HOME/.env.sh
source_if_exists $DOTFILES/zsh/aliases.zsh

# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

# ASDF Sourcing
source /opt/homebrew/opt/asdf/libexec/asdf.sh

# ohmyzsh plugins
plugins=(git aws asdf terraform brew)

source $ZSH/oh-my-zsh.sh

#Star Ship
eval "$(starship init zsh)"

