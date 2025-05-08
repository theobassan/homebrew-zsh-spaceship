#!/bin/zsh

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_GIT_BRANCH_BASSAN_SHOW="${SPACESHIP_GIT_BRANCH_BASSAN_SHOW=true}"
SPACESHIP_GIT_BRANCH_BASSAN_ASYNC="${SPACESHIP_GIT_BRANCH_BASSAN_ASYNC=true}"

SPACESHIP_GIT_BRANCH_BASSAN_BRANCH_SYMBOL="${SPACESHIP_GIT_BRANCH_BASSAN_BRANCH_SYMBOL=\uf418 }"

SPACESHIP_GIT_BRANCH_BASSAN_TAG_SYMBOL="${SPACESHIP_GIT_BRANCH_BASSAN_TAG_SYMBOL=#}"
SPACESHIP_GIT_BRANCH_BASSAN_COMMIT_SYMBOL="${SPACESHIP_GIT_BRANCH_BASSAN_COMMIT_SYMBOL=@}"
SPACESHIP_GIT_BRANCH_BASSAN_REMOTE_BRANCH_SYMBOL="${SPACESHIP_GIT_BRANCH_BASSAN_REMOTE_BRANCH_SYMBOL=:}" #TODO

SPACESHIP_GIT_BRANCH_BASSAN_CLEAN_COLOR="${SPACESHIP_GIT_BASSAN_CLEAN_COLOR}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

spaceship_git_branch_bassan() {
  [[ $SPACESHIP_GIT_BRANCH_BASSAN_SHOW == false ]] && return

  local branch_info git_branch=""

  branch_info=$(echo "$SPACESHIP_GIT_PORCELAIN_STATUS" | command grep '^## ')

  # --- Extract Branch/Ref Info ---
  # Remove '## ' prefix
  branch_info=${branch_info#\#\# }

  if [[ "$branch_info" == 'HEAD (no branch)' ]]; then
    # Detached HEAD: Get short commit hash
    local commit_hash=$(command git rev-parse --short HEAD 2>/dev/null)
    git_branch="${SPACESHIP_GIT_BRANCH_BASSAN_COMMIT_SYMBOL}${commit_hash}"
  elif [[ "$branch_info" == *'Initial commit on'* || "$branch_info" == *'No commits yet on'* ]]; then
    # Initial commit state
    local initial_branch=${branch_info##* on } # Extract branch name after ' on '
    git_branch="${SPACESHIP_GIT_BRANCH_BASSAN_BRANCH_SYMBOL}${initial_branch}"
  elif [[ "$branch_info" == *'...'* ]]; then
    # Branch with remote: main...origin/main [ahead 1]
    local branch_name=${branch_info%%...*}
    local remote_info=${branch_info#*...}
    remote_info=${remote_info%% *} # Remove ahead/behind part if present
    local remote_name=${remote_info#*/} # Extract remote branch name after remote/

    git_branch="${SPACESHIP_GIT_BRANCH_BASSAN_BRANCH_SYMBOL}${branch_name}"
    # Append remote name if it's different from the local branch name
    if [[ "$branch_name" != "$remote_name" ]]; then
      git_branch+="${SPACESHIP_GIT_BRANCH_BASSAN_REMOTE_BRANCH_SYMBOL}${remote_name}"
    fi
  else
    # Could be a local branch without remote, or a tag
    # Check for tag first
    local tag_name=$(command git describe --exact-match --tags HEAD 2>/dev/null)
    if [[ -n "$tag_name" ]]; then
        git_branch="${SPACESHIP_GIT_BRANCH_BASSAN_TAG_SYMBOL}${tag_name}"
    else
        # Assume it's a local branch name (branch_info contains the name directly)
        git_branch="${SPACESHIP_GIT_BRANCH_BASSAN_BRANCH_SYMBOL}${branch_info}"
    fi
  fi

  # --- Final Output ---
  if [[ -n $git_branch ]]; then
    spaceship::section \
      "${SPACESHIP_GIT_BRANCH_BASSAN_CLEAN_COLOR}$git_branch$git_status"
  fi
}
