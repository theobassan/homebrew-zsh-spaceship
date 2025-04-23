#!/bin/zsh

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_GIT_P10K_SHOW="${SPACESHIP_GIT_P10K_SHOW=true}"
CURRENT_SPACESHIP_GIT_P10K_DIR="${0:A:h}"

# ------------------------------------------------------------------------------
# Dependencies
# ------------------------------------------------------------------------------

source "$CURRENT_SPACESHIP_GIT_P10K_DIR/git-status-p10k.zsh" || return
spaceship::precompile "$CURRENT_SPACESHIP_GIT_P10K_DIR/git-status-p10k.zsh"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# Show both git branch and git status:
spaceship_git_p10k() {
  [[ $SPACESHIP_GIT_P10K_SHOW == false ]] && return

  spaceship::is_git || return

  spaceship::core::refresh_section --sync git_status_p10k

  # Quit if no git ref is found
  local git_status_p10k="$(spaceship::cache::get git_status_p10k)"
  [[ -z $git_status_p10k ]] && return

  local git_data="$(spaceship::core::compose_order git_status_p10k)"

  spaceship::section \
    "$git_data"
}
