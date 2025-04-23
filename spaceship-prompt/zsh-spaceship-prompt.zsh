#!/bin/zsh

function spaceship_aws_check() {
  local active_account
  active_account=$(aws sts get-caller-identity 2>/dev/null)

  if [[ -n "$active_account" || -n "$AWS_SESSION_TOKEN" || -n "$AWS_ACCESS_KEY_ID" ]]; then
    echo true
  else
    echo false
  fi
}

function spaceship_gcloud_check() {
  local active_account
  active_account=$(gcloud auth list --filter=status:ACTIVE --format="value(account)" 2>/dev/null)
  
  if [[ -n "$active_account" || -n "$GOOGLE_APPLICATION_CREDENTIALS" ]]; then
    echo true
  else
    echo false
  fi
}

SPACESHIP_OS_ICON_COLOR=39

SPACESHIP_DIR_SHOW=true
SPACESHIP_DIR_PREFIX=""
SPACESHIP_DIR_COLOR=39
 
SPACESHIP_NODE_PREFIX=""
SPACESHIP_NODE_SYMBOL="\ued0d "
SPACESHIP_NODE_COLOR="green"

SPACESHIP_JAVA_PREFIX=""
SPACESHIP_JAVA_SYMBOL="\uedaf "
SPACESHIP_JAVA_COLOR="green"
 
SPACESHIP_GOLANG_PREFIX=""
SPACESHIP_GOLANG_SYMBOL="\ue627 "
SPACESHIP_GOLANG_COLOR="green"
 
SPACESHIP_DOTNET_PREFIX=""
SPACESHIP_DOTNET_SYMBOL="\ue648 "
SPACESHIP_DOTNET_COLOR="green"
 
SPACESHIP_PYTHON_PREFIX=""
SPACESHIP_PYTHON_SYMBOL="\ue606 "
SPACESHIP_PYTHON_COLOR="green"
 
SPACESHIP_VENV_GENERIC_NAMES="none"
SPACESHIP_VENV_PREFIX=""
SPACESHIP_VENV_SYMBOL=""
SPACESHIP_VENV_COLOR="green"

SPACESHIP_PACKAGE_PREFIX=""
SPACESHIP_PACKAGE_SYMBOL="\ueb29 "

SPACESHIP_EXEC_TIME_SHOW=true
SPACESHIP_EXEC_TIME_ELAPSED=0
SPACESHIP_EXEC_TIME_PREFIX=""
SPACESHIP_EXEC_COLOR="yellow"

SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_PREFIX=""
SPACESHIP_TIME_COLOR="yellow"

SPACESHIP_DOCKER_SHOW=true
SPACESHIP_DOCKER_PREFIX=""
SPACESHIP_DOCKER_SYMBOL="\uf21f "
SPACESHIP_DOCKER_SYMBOL_COLOR="cyan"

SPACESHIP_AWS_SHOW="${SPACESHIP_AWS_SHOW:-$(spaceship_aws_check)}"
SPACESHIP_AWS_PREFIX=""
SPACESHIP_AWS_SYMBOL="\uf0ef "

SPACESHIP_GCLOUD_SHOW="${SPACESHIP_GCLOUD_SHOW:-$(spaceship_gcloud_check)}"
SPACESHIP_GCLOUD_PREFIX=""
SPACESHIP_GCLOUD_SYMBOL="\uf1a0 "

if [[ $TERM_PROGRAM == "WarpTerminal" ]]; then
    SPACESHIP_PROMPT_ASYNC=false
fi

ZSH_SPACESHIP_FOLDER="${ZSH_SPACESHIP_FOLDER:-$(brew --prefix)/opt/spaceship}"
source "$ZSH_SPACESHIP_FOLDER/spaceship.zsh-theme"|| return

CURRENT_SPACESHIP_PROMPT_DIR="${0:A:h}"
source "$CURRENT_SPACESHIP_PROMPT_DIR/git/git-p10k.zsh" || return
source "$CURRENT_SPACESHIP_PROMPT_DIR/os-icon/os-icon.zsh" || return

SPACESHIP_PROMPT_ORDER=(
  os_icon
  user
  host
  dir
  node
  java
  golang
  dotnet
  python
  venv
  package
  #ansible
  #terraform
  git_p10k
  async
  line_sep
  battery
  jobs
  exit_code
  sudo
  char
)
 
SPACESHIP_RPROMPT_ORDER=(
  exec_time
  docker
  #docker_compose
  #kubectl
  aws
  gcloud
  #azure
  #ibmcloud
  time
)