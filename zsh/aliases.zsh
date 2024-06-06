# Functions
function note() {
  F=$HOME/Documents/Obsidian\ Vault/Drafts.md
  echo "date: $(date)" >> $F
  echo "$@" >> $F
  echo "" >> $F
  echo "---" >> $F
}

# KubeCTL auto completion
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# Helm auto completion
[[ $commands[helm] ]] && source <(helm completion zsh)

# K8s util functions
function pods-per-node() {
  kubectl get po -A --output yaml | yq '.items[].spec.nodeName' | sort | uniq -c | sort -nr
}

function pods-in-node() {
  NODE=$1

  if [[ "$NODE" == "" ]]
  then
    echo "Specify a node"
  else
    kubectl get po -A -o wide | grep $NODE
  fi
}

function top-pods-cpu() {
  NODE=$1

  if [[ "$NODE" == "" ]]
  then
    echo "Specify a node"

  else
    kubectl get po -A -o wide | grep ${NODE} | \
    awk '{print $1, $2}' | \
    while read ns po; do k top pods --no-headers -n $ns $po; done | \
    sort --key 2 -nr | column -t
  fi
}

function top-pods-ram() {
  NODE=$1

  if [[ "$NODE" == "" ]]
  then
    echo "Specify a node"

  else
    kubectl get po -A -o wide | grep ${NODE} | \
    awk '{print $1, $2}' | \
    while read ns po; do kubectl top pods --no-headers -n $ns $po; done | \
    sort --key 3 -nr | column -t
  fi
}

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /home/arnau/.asdf/installs/opentofu/1.6.2/bin/tofu tofu

# Opentofu/Terragrunt
function t() {
  if [[ -f "terragrunt.hcl" || "$1" == "run-all" ]]
  then
    command terragrunt "$@"
  else
    command tofu "$@"
  fi
}

# Terra{form,grunt}
function te() {
  if [[ -f "terragrunt.hcl" || "$1" == "run-all" ]]
  then
    command terragrunt "$@"
  else
    command terraform "$@"
  fi
}

# General utilities
function genpass() {
  BASE=$1

  if [[ "$BASE" == "" ]];
  then
    BASE=32
  fi

  openssl rand -base64 $BASE
}

function puller() {
  for i in $(ls); do cd $i && git pull && cd -; done
}

# Aliases
alias ll='eza -l'
alias la='eza -la'
alias ls='eza'
alias vi='nvim'
alias vim='nvim'
alias python='python3'
alias c='clear'
alias d='docker'
alias dc='docker-compose'
alias docker-clean='docker rmi -f $(docker images -f "dangling=true" -q)'
alias dclean='docker-clean'
if [[ "$(uname)" == "Darwin" ]]; then
  alias sed='gsed'
fi
alias yl='yq -C | less -R'

alias co='git checkout $(git for-each-ref refs/heads/ --format="%(refname:short)" | fzf)'
alias ghlogin='gh auth login --hostname github.com --web --git-protocol https'

alias s='source ~/.zshrc'
alias vzshrc='nvim ~/.zshrc'
alias valias='nvim $DOTFILES/zsh/aliases.zsh'

# tmux aliases
alias tms='tmux source ~/.tmux.conf'
alias tm='tmux new-session -A -D -s'
alias tmm='tm main'

# k8s aliases
alias k='kubectl'
alias pin='pods-in-node'

# Terra aliases
alias tei="te init"
alias tep="te plan"
alias teri="te run-all init"
alias terp="te run-all plan"
alias ti="t init"
alias tp="t plan"
alias tri="t run-all init"
alias trp="t run-all plan"
