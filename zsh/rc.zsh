# Create static file completions so they are done only once and not each time a
# new shell is spawned
# Function to auto-generate completions if missing or tool updated
_regen_completion() {
  local cmd=$1 file=$2; shift 2
  if (( $+commands[$cmd] )) && [[ ! -f $file || $(command -v $cmd) -nt $file ]]; then
    $cmd "$@" > $file
  fi
}

# Tools with completions not managed by package managers
_regen_completion mise ~/.zsh/_mise completion zsh
_regen_completion fzf ~/.zsh/_fzf --zsh
unfunction _regen_completion

# Adding new completions to fpath
fpath=(~/.zsh $fpath)

# Add system completions
if [[ "$(uname)" == "Darwin" ]]; then
  fpath=($(brew --prefix zsh)/share/zsh/functions $fpath)
else
  fpath=(/usr/share/zsh/${ZSH_VERSION}/functions $fpath)
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
export TERM="tmux-256color"
export EDITOR="nvim"

export REPOS=$HOME/Documents/repos
export PERSONAL=$HOME/Documents/personal

export GOPATH="${HOME}/go"
export PATH=$PATH:$HOME/bin:/usr/local/go/bin:$HOME/.local/share/nvim/mason/bin:$HOME/.local/bin:$GOPATH/bin:$HOME/.cargo/bin

# opencode
export PATH=$PATH:$HOME/.opencode/bin

# LM Studio
export PATH="$PATH:$HOME/.lmstudio/bin"

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"

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
zinit snippet https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/main/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

zinit snippet OMZP::aws
zinit snippet OMZP::terraform
zinit snippet OMZP::brew
zinit snippet OMZP::golang
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -U compinit && compinit -i
zinit cdreplay -q
typeset -aU fpath

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
# UP and DOWN arrowkeys
if [[ "$(uname)" == "Linux" ]]; then
  bindkey '^[OA' history-search-backward
  bindkey '^[OB' history-search-forward
elif [[ "$(uname)" == "Darwin" ]]; then
  bindkey '^[[A' history-search-backward
  bindkey '^[[B' history-search-forward
  # fix Supr key
  bindkey "^[[3~" delete-char
fi

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
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zmodload zsh/complist

# Shell integrations
eval "$(mise activate zsh)"

# Custom sourcing
source_if_exists $HOME/.env.sh
source_if_exists $DOTFILES/zsh/aliases.zsh

# Creds sourcing
for file in $(ls $HOME/.creds)
do
  source_if_exists "${HOME}/.creds/${file}"
done
