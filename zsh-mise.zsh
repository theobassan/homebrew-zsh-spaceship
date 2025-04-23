#!/bin/zsh

ZSH_SPACESHIP_MISE_FOLDER="${ZSH_SPACESHIP_MISE_FOLDER:-$(brew --prefix)/opt/spaceship}"

#TODO DIR CONFIG
eval "$(mise activate zsh)"
eval "$(mise hook-env -s zsh)"

function use_mise_auto() {
  if command -v mise &> /dev/null; then
    mise install
  fi
}

# Hook into directory changes
autoload -U add-zsh-hook
add-zsh-hook chpwd use_mise_auto
use_mise_auto
 
#TODO envDIR to SOURCE
function auto_activate_env() {
    if [ -f .venv/bin/activate ]; then
        source .venv/bin/activate
    fi
}

function auto_deactivate_env() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        deactivate
    fi
}

add-zsh-hook chpwd auto_deactivate_env
add-zsh-hook chpwd auto_activate_env

# Run on shell startup
auto_activate_env