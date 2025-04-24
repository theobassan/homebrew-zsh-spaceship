#!/bin/zsh

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

ZSH_SPACESHIP_GIT_P10K_SHOW="${ZSH_SPACESHIP_GIT_P10K_SHOW=true}"

# ------------------------------------------------------------------------------
# Dependencies
# ------------------------------------------------------------------------------

local gitSessionDir="${0:A:h}"
source "$gitSessionDir/git-status-p10k.zsh" || return
spaceship::precompile "$gitSessionDir/git-status-p10k.zsh"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# Show both git branch and git status:
spaceship_git_p10k() {
  [[ $ZSH_SPACESHIP_GIT_P10K_SHOW == false ]] && return

  spaceship::is_git || return

  spaceship::core::refresh_section --sync git_status_p10k

  # Quit if no git ref is found
  local git_status_p10k="$(spaceship::cache::get git_status_p10k)"
  [[ -z $git_status_p10k ]] && return

  local git_data="$(spaceship::core::compose_order git_status_p10k)"

  spaceship::section \
    "$git_data"
}
