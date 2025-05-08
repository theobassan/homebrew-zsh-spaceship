#!/bin/zsh

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_GIT_BASSAN_SHOW="${SPACESHIP_GIT_BASSAN_SHOW=true}"
SPACESHIP_GIT_BASSAN_ASYNC="${SPACESHIP_GIT_BASSAN_ASYNC=true}"

SPACESHIP_GIT_BASSAN_SYMBOL="${SPACESHIP_GIT_BASSAN_SYMBOL=\uf408 }"
SPACESHIP_GIT_BASSAN_CLEAN_COLOR="${SPACESHIP_GIT_BASSAN_CLEAN_COLOR=%76F}" #TODO

# ------------------------------------------------------------------------------
# Dependencies
# ------------------------------------------------------------------------------

local gitSessionDir="${0:A:h}"

source "$gitSessionDir/git-branch.zsh" || return
source "$gitSessionDir/git-commit.zsh" || return
source "$gitSessionDir/git-status.zsh" || return

spaceship::precompile "$gitSessionDir/git-branch.zsh"
spaceship::precompile "$gitSessionDir/git-commit.zsh"
spaceship::precompile "$gitSessionDir/git-status.zsh"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# Show both git branch and git status:
spaceship_git_bassan() {
  [[ $SPACESHIP_GIT_BASSAN_SHOW == false ]] && return

  spaceship::is_git || return
  spaceship::exists git || return

  local porcelain_status branch_info git_status=""

  # Get status and branch info once
  porcelain_status=$(command git status --porcelain -b 2> /dev/null)
  export SPACESHIP_GIT_PORCELAIN_STATUS="$porcelain_status"

  spaceship::core::refresh_section --sync git_branch_bassan
  spaceship::core::refresh_section --sync git_commit_bassan
  spaceship::core::refresh_section --sync git_status_bassan

  # Quit if no git ref is found
  local git_branch="$(spaceship::cache::get git_branch_bassan)"
  [[ -z $git_branch ]] && return

  local git_data="$(spaceship::core::compose_order git_branch_bassan git_commit_bassan git_status_bassan)"

  spaceship::section \
    "${SPACESHIP_GIT_BASSAN_CLEAN_COLOR}${SPACESHIP_GIT_BASSAN_SYMBOL}$git_data"
}
