source_if_exists () {
  if test -r "$1"; then
    source "$1"
  fi
}

autoload -Uz compinit && compinit
autoload -Uz compdef

source_if_exists $HOME/.env.sh

# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

# ASDF Sourcing
source /opt/homebrew/opt/asdf/libexec/asdf.sh

# ohmyzsh plugins
plugins=(git aws asdf terraform brew)

source $ZSH/oh-my-zsh.sh

export PATH=$PATH:$HOME/bin:/opt/homebrew/bin

# Creds sourcing
for file in $(ls $HOME/.creds/*.keys)
do
  source $file
done

#Star Ship
eval "$(starship init zsh)"

# Placing it higher makes it partially overwritten (ls...) for unknown reasons :/
source_if_exists $DOTFILES/zsh/aliases.zsh

