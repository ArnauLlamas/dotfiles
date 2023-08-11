alias ll='exa -l'
alias la='exa -la'
alias ls=exa
alias vi='nvim'
alias vim='nvim'
alias python='python3'
alias c='clear'
alias d='docker'
alias dc='docker-compose'
alias s='source ~/.zshrc'
alias vzshrc='nvim ~/.zshrc'

function note() {
  F=$HOME/Documents/Obsidian\ Vault/Drafts.md
  echo "date: $(date)" >> $F
  echo "$@" >> $F
  echo "" >> $F
  echo "---" >> $F
}

export PATH=$PATH:$HOME/bin:/opt/homebrew/bin

# Creds sourcing
for file in $(ls ~/.creds/*.keys);
do
  source $file
done

# KubeCTL auto completion
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)
alias k='kubectl'

# Helm auto completion
[[ $commands[helm] ]] && source <(helm completion zsh)

# K8s util functions
function pods-per-node() {
  k get po -A --output yaml | yq '.items[].spec.nodeName' | sort | uniq -c | sort -nr
}

function pods-in-node() {
  NODE=$1

  if [[ "$NODE" == "" ]]
  then
    echo "Specify a node"
  else
    k get po -A -o wide | grep $NODE
  fi
}
alias pin='pods-in-node'

function top-pods-cpu() {
  NODE=$1

  if [[ "$NODE" == "" ]]
  then
    echo "Specify a node"

  else
    k get po -A -o wide | grep ${NODE} | \
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
    k get po -A -o wide | grep ${NODE} | \
    awk '{print $1, $2}' | \
    while read ns po; do kubectl top pods --no-headers -n $ns $po; done | \
    sort --key 3 -nr | column -t
  fi
}

# Terra{form,grunt}
function t() {
  if [[ -f "terragrunt.hcl" || "$1" == "run-all" ]]
  then
    command terragrunt "$@"
  else
    command terraform "$@"
  fi
}

alias ti="t init"
alias tri="t run-all init"
alias tp="t plan"

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
