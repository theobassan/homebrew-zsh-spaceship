#!/bin/zsh

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_GIT_COMMIT_BASSAN_SHOW="${SPACESHIP_GIT_COMMIT_BASSAN_SHOW=true}"
SPACESHIP_GIT_COMMIT_BASSAN_ASYNC="${SPACESHIP_GIT_COMMIT_BASSAN_ASYNC=true}"

SPACESHIP_GIT_COMMIT_BASSAN_COMMITS_BEHIND_SYMBOL="${SPACESHIP_GIT_COMMIT_BASSAN_COMMITS_BEHIND_SYMBOL=⇣}"
SPACESHIP_GIT_COMMIT_BASSAN_COMMITS_AHEAD_SYMBOL="${SPACESHIP_GIT_COMMIT_BASSAN_COMMITS_AHEAD_SYMBOL=⇡}"
SPACESHIP_GIT_COMMIT_BASSAN_PUSH_COMMITS_BEHIND_SYMBOL="${SPACESHIP_GIT_COMMIT_BASSAN_PUSH_COMMITS_BEHIND_SYMBOL=⇠}"
SPACESHIP_GIT_COMMIT_BASSAN_PUSH_COMMITS_AHEAD_SYMBOL="${SPACESHIP_GIT_COMMIT_BASSAN_PUSH_COMMITS_AHEAD_SYMBOL=⇢}"

SPACESHIP_GIT_COMMIT_BASSAN_CLEAN_COLOR="${SPACESHIP_GIT_BASSAN_CLEAN_COLOR}"
SPACESHIP_GIT_COMMIT_BASSAN_MODIFIED_COLOR="${SPACESHIP_GIT_BASSAN_MODIFIED_COLOR}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

spaceship_git_commit_bassan() {
  [[ $SPACESHIP_GIT_COMMIT_BASSAN_SHOW == false ]] && return

  local porcelain_status branch_info git_commit=""

  # Get status and branch info once
  porcelain_status=${SPACESHIP_GIT_PORCELAIN_STATUS}
  branch_info=$(echo "$porcelain_status" | command grep '^## ')

  #TODO conflicting with commits ahead/behind
  # --- Ahead/Behind Fork Status ---
  #local num_push_ahead=0 num_push_behind=0
  #if command git rev-parse --verify --quiet HEAD@{push} >/dev/null 2>&1; then
  #  local counts
  #  # Get ahead/behind counts relative to @{push}
  #  counts=$(command git rev-list --count --left-right HEAD...HEAD@{push} 2>/dev/null)
  #  if [[ -n "$counts" ]]; then
  #    local ahead_count behind_count
  #    # Use read to split the output directly into variables
  #    read ahead_count behind_count <<< "$counts"
  #    num_push_ahead=$((ahead_count))
  #    num_push_behind=$((behind_count))
  #  fi
  #fi

  #if (( num_push_ahead > 0 && num_push_behind > 0 )); then
  #  # Add diverged symbol (optional)
  #  # git_commit+=" ${SPACESHIP_GIT_STATUS_DIVERGED_SYMBOL}"
  #  git_commit+=" ${SPACESHIP_GIT_COMMIT_BASSAN_PUSH_COMMITS_AHEAD_SYMBOL}${num_push_ahead}${SPACESHIP_GIT_COMMIT_BASSAN_PUSH_COMMITS_BEHIND_SYMBOL}${num_push_behind}"
  #elif (( num_push_ahead > 0 )); then
  #  git_commit+=" ${SPACESHIP_GIT_COMMIT_BASSAN_PUSH_COMMITS_AHEAD_SYMBOL}${num_push_ahead}"
  #elif (( num_push_behind > 0 ));  then
  #  git_commit+=" ${SPACESHIP_GIT_COMMIT_BASSAN_PUSH_COMMITS_BEHIND_SYMBOL}${num_push_behind}"
  #fi

  # --- Ahead/Behind Status ---
  # Remove '## ' prefix
  branch_info=${branch_info#\#\# }
  local num_ahead=0 num_behind=0 # Initialize to 0
  # Extract counts using parameter expansion for efficiency
  if [[ "$branch_info" == *'ahead '* ]]; then
    local ahead_str=${branch_info##*ahead }
    ahead_str=${ahead_str%%]*}
    ahead_str=${ahead_str%%,*}
    num_ahead=$((ahead_str)) # Ensure arithmetic evaluation
  fi
  if [[ "$branch_info" == *'behind '* ]]; then
    local behind_str=${branch_info##*behind }
    behind_str=${behind_str%%]*}
    num_behind=$((behind_str)) # Ensure arithmetic evaluation
  fi

  local latest_commit_summary
  latest_commit_summary=$(command git log -1 --pretty=%s 2>/dev/null)
  # The pattern ensures "wip" or "WIP" is matched as a whole word.
  if [[ -n "$latest_commit_summary" && "$latest_commit_summary" == (|*[^[:alnum:]])(wip|WIP)(|[^[:alnum:]]*) ]]; then
    git_commit+=" ${SPACESHIP_GIT_COMMIT_BASSAN_MODIFIED_COLOR}wip"
  fi
  git_commit+="${SPACESHIP_GIT_BRANCH_BASSAN_CLEAN_COLOR}"

  # Use arithmetic comparison (( ... > 0 ))
  if (( num_ahead > 0 && num_behind > 0 )); then
    # Add diverged symbol if you have one defined
    # git_commit+=" ${SPACESHIP_GIT_STATUS_DIVERGED_SYMBOL}"
    git_commit+=" ${SPACESHIP_GIT_COMMIT_BASSAN_COMMITS_AHEAD_SYMBOL}${num_ahead}${SPACESHIP_GIT_COMMIT_BASSAN_COMMITS_BEHIND_SYMBOL}${num_behind}"
  elif (( num_ahead > 0 )); then
    git_commit+=" ${SPACESHIP_GIT_COMMIT_BASSAN_COMMITS_AHEAD_SYMBOL}${num_ahead}"
  elif (( num_behind > 0 )); then
    git_commit+=" ${SPACESHIP_GIT_COMMIT_BASSAN_COMMITS_BEHIND_SYMBOL}${num_behind}"
  fi

  # --- Final Output ---
  if [[ -n $git_commit ]]; then
    spaceship::section \
      "$git_commit"
  fi
}
