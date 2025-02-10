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
function to() {
  if [[ -f "terragrunt.hcl" || "$1" == "run-all" ]]
  then
    command terragrunt "$@"
  else
    command tofu "$@"
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
alias cat='bat'
alias vi='nvim'
alias vif='nvim $(fzf)'
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
alias tt='toggle_transparency'

# gh
alias ghlogin='gh auth login --hostname github.com --web --git-protocol https'

# git
gd () {
  if [[ "$1" == "" ]]; then
    GD_PATH=":!*lock*"
  else GD_PATH=$1
  fi
  git diff -- ${GD_PATH} 
}
gds () {
  if [[ "$1" == "" ]]; then
    GD_PATH=":!*lock*"
  else GD_PATH=$1
  fi
  git diff --staged -- ${GD_PATH}
}
gcfc () {
  git checkout $(git log --format=reference | fzf | awk '{ print $1 }')
}
gcf () {
  git log --format=reference | fzf | awk '{ print $1 }'
}
grevf () {
  git revert $(git log --format=reference | fzf | awk '{ print $1 }')
}
gbf () {
  git checkout $(git branch -a | grep -v 'HEAD' | grep -v '*' | awk -F'remotes/origin/' 'NF==2{ print $2 }; NF==1{ print $1 }' | tr -d ' ' |  sort | uniq | fzf)
}
gpf () {
  git pull origin $(git branch -a | grep -v 'HEAD' | grep -v '*' | awk -F'remotes/origin/' 'NF==2{ print $2 }; NF==1{ print $1 }' | tr -d ' ' |  sort | uniq | fzf)
}
gwa () {
  if [[ "$1" == "" ]]; then
    echo "Provide a name for the worktree"
    return 1
  else
    WT_NAME=$1
  fi

  if [[ "$2" == "" ]]; then
    BRANCH=$(git remote show origin | grep HEAD | cut -d: -f2 | tr -d " ")
  else
    BRANCH=$2
  fi

  git worktree add "$REPOS/$(basename `git rev-parse --show-toplevel`)-$WT_NAME" "$BRANCH"
}
gwf () {
  cd $(gwl | fzf | awk '{ print $1 }')
}
alias cdg='if [ "`git rev-parse --show-cdup`" != "" ]; then cd `git rev-parse --show-cdup`; fi'
alias gb='git checkout'
alias gbn='git checkout -b'
alias gbd='git checkout $(git remote show origin | grep HEAD | cut -d: -f2 | tr -d " ")'
alias gbc='git branch --show-current'
alias gs='git status'
alias ga='git add'
alias gaa='git add -A'
alias gap='git add --patch'
alias gp='git pull'
alias gpc='git pull origin $(git branch --show-current)'
alias gpd='git pull origin $(git remote show origin | grep HEAD | cut -d: -f2 | tr -d " ")'
alias gcm='git commit -m'
alias gcempty='git commit --allow-empty --allow-empty-message'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gP='git push origin $(git branch --show-current)'
alias gPf='git push --force origin $(git branch --show-current)'
alias gwl='git worktree list'
alias gwr='git worktree remove'
alias gwrc='git worktree remove .'
alias gss='git stash'
alias gssp='git stash pop'
alias gssP='git stash push'
alias gssl='git stash list'
alias gl='git log'
alias gr='git restore'
alias grs='git restore --staged'
alias grev='git revert'
alias gR='git reset'
alias gtf='git checkout $(git tag | fzf)'

alias s='source ~/.zshrc'
alias vzshrc='nvim ~/.zshrc'
alias valias='nvim $DOTFILES/zsh/aliases.zsh'

# tmux aliases
alias ts'tmux source ~/.tmux.conf'
alias tm='tmux new-session -A -D -s'
alias tmm='tm main'
alias tms='tmux-sessionizer'

# k8s aliases
alias k='kubectl'
alias pin='pods-in-node'
alias kx='kubectx'
alias kn='kubens'

# Terra aliases
alias tei="te init"
alias tep="te plan"
alias tec="te console"
alias teri="te run-all init"
alias terp="te run-all plan"
alias ti="t init"
alias tp="t plan"
alias tc="t console"
alias tri="t run-all init"
alias trp="t run-all plan"
