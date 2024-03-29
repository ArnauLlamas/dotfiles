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
if [[ "$(uname)" == "Linux" ]]; then
  source $HOME/.asdf/asdf.sh
elif [[ "$(uname)" == "Darwin" ]]; then
  source /opt/homebrew/opt/asdf/libexec/asdf.sh
fi
# ohmyzsh plugins
plugins=(gitfast aws asdf terraform brew kind golang)

source $ZSH/oh-my-zsh.sh

export PATH=$PATH:$HOME/bin:/opt/homebrew/bin:/usr/local/go/bin:$HOME/.local/share/nvim/mason/bin:$HOME/.local/bin
export GOROOT="$(go env GOROOT)"
export GOPATH="$(go env GOPATH)"
export TERM="xterm-256color"

# Creds sourcing
for file in $(ls $HOME/.creds/)
do
  source_if_exists $file
done

# Repos folder
export REPOS=$HOME/Documents/repos
export PERSONAL=$HOME/Documents/personal

#Star Ship
eval "$(starship init zsh)"

# Placing it higher makes it partially overwritten (ls...) for unknown reasons :/
source_if_exists $DOTFILES/zsh/aliases.zsh

eval "$(zoxide init --cmd cd zsh)"
