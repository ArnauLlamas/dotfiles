if [[ "$(uname)" == "Darwin" ]]; then
  autoload -Uz compinit
  compinit
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Helper function
source_if_exists () {
  if test -r "$1"; then
    source "$1"
  fi
}

# Custom variables
export TERM="xterm-256color"
export EDITOR="nvim"

export REPOS=$HOME/Documents/repos
export PERSONAL=$HOME/Documents/personal

export GOPATH="${HOME}/go"

export PATH=$PATH:$HOME/bin:/opt/homebrew/bin:/usr/local/go/bin:$HOME/.local/share/nvim/mason/bin:$HOME/.local/bin:$HOME/.fzf/bin:$GOPATH/bin

# Custom sourcing
source_if_exists $HOME/.env.sh
source_if_exists $DOTFILES/zsh/aliases.zsh

# Creds sourcing
for file in $(ls $HOME/.creds)
do
  source_if_exists "${JOME}/.creds/${file}"
done

## System specifics sourcing
if [[ "$(uname)" == "Linux" ]]; then
  source $HOME/.asdf/asdf.sh
elif [[ "$(uname)" == "Darwin" ]]; then
  source /opt/homebrew/opt/asdf/libexec/asdf.sh
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/.share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# Add in snippets
zinit snippet OMZP::gitfast
zinit snippet OMZP::aws
zinit snippet OMZP::asdf
zinit snippet OMZP::terraform
zinit snippet OMZP::brew
zinit snippet OMZP::golang
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -U compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e

# History
HISTFILE="$HOME"/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zmodload zsh/complist

# Shell integrations
source <(fzf --zsh)
eval "$(zoxide init --cmd cd zsh)"
