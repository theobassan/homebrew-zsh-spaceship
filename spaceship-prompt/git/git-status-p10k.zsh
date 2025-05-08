#!/bin/zsh

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_GIT_STATUS_P10K_SHOW="${SPACESHIP_GIT_STATUS_P10K_SHOW=true}"
SPACESHIP_GIT_STATUS_P10K_ASYNC="${SPACESHIP_GIT_STATUS_P10K_ASYNC=true}"

SPACESHIP_GIT_STATUS_P10K_SYMBOL="${SPACESHIP_GIT_STATUS_P10K_SYMBOL=\uf408 }"
SPACESHIP_GIT_STATUS_P10K_BRANCH_SYMBOL="${SPACESHIP_GIT_STATUS_P10K_BRANCH_SYMBOL=\uf418 }"

SPACESHIP_GIT_STATUS_P10K_TAG_SYMBOL="${SPACESHIP_GIT_STATUS_P10K_TAG_SYMBOL=#}"
SPACESHIP_GIT_STATUS_P10K_COMMIT_SYMBOL="${SPACESHIP_GIT_STATUS_P10K_COMMIT_SYMBOL=@}"
SPACESHIP_GIT_STATUS_P10K_REMOTE_BRANCH_SYMBOL="${SPACESHIP_GIT_STATUS_P10K_REMOTE_BRANCH_SYMBOL=:}" #TODO
SPACESHIP_GIT_STATUS_P10K_COMMITS_BEHIND_SYMBOL="${SPACESHIP_GIT_STATUS_P10K_COMMITS_BEHIND_SYMBOL=⇣}"
SPACESHIP_GIT_STATUS_P10K_COMMITS_AHEAD_SYMBOL="${SPACESHIP_GIT_STATUS_P10K_COMMITS_AHEAD_SYMBOL=⇡}"
SPACESHIP_GIT_STATUS_P10K_PUSH_COMMITS_BEHIND_SYMBOL="${SPACESHIP_GIT_STATUS_P10K_PUSH_COMMITS_BEHIND_SYMBOL=⇠}"
SPACESHIP_GIT_STATUS_P10K_PUSH_COMMITS_AHEAD_SYMBOL="${SPACESHIP_GIT_STATUS_P10K_PUSH_COMMITS_AHEAD_SYMBOL=⇢}"
SPACESHIP_GIT_STATUS_P10K_STASHES_SYMBOL="${SPACESHIP_GIT_STATUS_P10K_STASHES_SYMBOL=*}"
SPACESHIP_GIT_STATUS_P10K_CONFLICTED_SYMBOL="${SPACESHIP_GIT_STATUS_P10K_CONFLICTED_SYMBOL=~}"
SPACESHIP_GIT_STATUS_P10K_STAGED_SYMBOL="${SPACESHIP_GIT_STATUS_P10K_STAGED_SYMBOL=+}"
SPACESHIP_GIT_STATUS_P10K_RENAMED_SYMBOL="${SPACESHIP_GIT_STATUS_P10K_RENAMED_SYMBOL="⇄"}"
SPACESHIP_GIT_STATUS_P10K_MODIFIED_SYMBOL="${SPACESHIP_GIT_STATUS_P10K_MODIFIED_SYMBOL=!}"
SPACESHIP_GIT_STATUS_P10K_DELETED_SYMBOL="${SPACESHIP_GIT_STATUS_P10K_DELETED_SYMBOL=-}"
SPACESHIP_GIT_STATUS_P10K_UNTRACKED_SYMBOL="${SPACESHIP_GIT_STATUS_P10K_UNTRACKED_SYMBOL=?}"

SPACESHIP_GIT_STATUS_P10K_CLEAN_COLOR="${SPACESHIP_GIT_STATUS_P10K_CLEAN_COLOR=%76F}"
SPACESHIP_GIT_STATUS_P10K_CONFLICTED_COLOR="${SPACESHIP_GIT_STATUS_P10K_CONFLICTED_COLOR=%196F}"
SPACESHIP_GIT_STATUS_P10K_STAGED_COLOR="${SPACESHIP_GIT_STATUS_P10K_STAGED_COLOR=%4F}"
SPACESHIP_GIT_STATUS_P10K_RENAMED_COLOR="${SPACESHIP_GIT_STATUS_P10K_RENAMED_COLOR=%178F}" #TODO
SPACESHIP_GIT_STATUS_P10K_MODIFIED_COLOR="${SPACESHIP_GIT_STATUS_P10K_MODIFIED_COLOR=%178F}"
SPACESHIP_GIT_STATUS_P10K_DELETED_COLOR="${SPACESHIP_GIT_STATUS_P10K_DELETED_COLOR=%196F}" #TODO
SPACESHIP_GIT_STATUS_P10K_UNTRACKED_COLOR="${SPACESHIP_GIT_STATUS_P10K_UNTRACKED_COLOR=%39F}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

spaceship_git_status_p10k() {
  [[ $SPACESHIP_GIT_STATUS_P10K_SHOW == false ]] && return

  spaceship::is_git || return
  spaceship::exists git || return

  local porcelain_status branch_info git_status=""

  # Get status and branch info once
  porcelain_status=$(command git status --porcelain -b 2> /dev/null)
  branch_info=$(echo "$porcelain_status" | command grep '^## ')
  porcelain_status=$(echo "$porcelain_status" | command grep -v '^## ') # Keep only file lines

  # --- Calculate Counts ---
  local num_untracked num_staged num_modified num_renamed num_deleted num_conflicted num_stashes

  # Untracked ('??')
  num_untracked=$(echo "$porcelain_status" | command grep -cE '^\?\? ')

  # Staged ('A  ', 'M  ', 'D  ', 'C  ', 'R  ')
  num_staged=$(echo "$porcelain_status" | command grep -cE '^(A|M|D|C|R)  ')

  # Modified (' M') - Unstaged modifications to tracked files
  num_modified=$(echo "$porcelain_status" | command grep -cE '^ M ')

  # Renamed with unstaged changes ('RM', 'RD')
  num_renamed=$(echo "$porcelain_status" | command grep -cE '^R(M|D)') # Matches only RM, RD

  # Deleted (' D') - Unstaged deletions of tracked files
  num_deleted=$(echo "$porcelain_status" | command grep -cE '^ D ')

  # Conflicted/Unmerged ('UU', 'AA', 'DD', 'AU', 'UA', 'DU', 'UD')
  num_conflicted=$(echo "$porcelain_status" | command grep -cE '^(UU|AA|DD|AU|UA|DU|UD) ')

  # Stashes
  num_stashes=0
  if command git rev-parse --verify --quiet refs/stash >/dev/null 2>&1; then
    # Use grep -c for counting lines, slightly cleaner than wc | awk
    num_stashes=$(command git stash list | grep -c .)
    # Or if just wc -l is sufficient (handles potential empty output better):
    # num_stashes=$(command git stash list | wc -l)
  fi

  # --- Extract Branch/Ref Info ---
  local ref_display=""
  # Remove '## ' prefix
  branch_info=${branch_info#\#\# }

  if [[ "$branch_info" == 'HEAD (no branch)' ]]; then
    # Detached HEAD: Get short commit hash
    local commit_hash=$(command git rev-parse --short HEAD 2>/dev/null)
    ref_display="${SPACESHIP_GIT_STATUS_P10K_COMMIT_SYMBOL}${commit_hash}"
  elif [[ "$branch_info" == *'Initial commit on'* || "$branch_info" == *'No commits yet on'* ]]; then
    # Initial commit state
    local initial_branch=${branch_info##* on } # Extract branch name after ' on '
    ref_display="${SPACESHIP_GIT_STATUS_P10K_BRANCH_SYMBOL}${initial_branch}"
  elif [[ "$branch_info" == *'...'* ]]; then
    # Branch with remote: main...origin/main [ahead 1]
    local branch_name=${branch_info%%...*}
    local remote_info=${branch_info#*...}
    remote_info=${remote_info%% *} # Remove ahead/behind part if present
    local remote_name=${remote_info#*/} # Extract remote branch name after remote/

    ref_display="${SPACESHIP_GIT_STATUS_P10K_BRANCH_SYMBOL}${branch_name}"
    # Append remote name if it's different from the local branch name
    if [[ "$branch_name" != "$remote_name" ]]; then
      ref_display+="${SPACESHIP_GIT_STATUS_P10K_REMOTE_BRANCH_SYMBOL}${remote_name}"
    fi
  else
    # Could be a local branch without remote, or a tag
    # Check for tag first
    local tag_name=$(command git describe --exact-match --tags HEAD 2>/dev/null)
    if [[ -n "$tag_name" ]]; then
        ref_display="${SPACESHIP_GIT_STATUS_P10K_TAG_SYMBOL}${tag_name}"
    else
        # Assume it's a local branch name (branch_info contains the name directly)
        ref_display="${SPACESHIP_GIT_STATUS_P10K_BRANCH_SYMBOL}${branch_info}"
    fi
  fi

  # --- Ahead/Behind Fork Status ---
  local num_push_ahead=0 num_push_behind=0
  if command git rev-parse --verify --quiet HEAD@{push} >/dev/null 2>&1; then
    local counts
    # Get ahead/behind counts relative to @{push}
    counts=$(command git rev-list --count --left-right HEAD...HEAD@{push} 2>/dev/null)
    if [[ -n "$counts" ]]; then
      local ahead_count behind_count
      # Use read to split the output directly into variables
      read ahead_count behind_count <<< "$counts"
      num_push_ahead=$((ahead_count))
      num_push_behind=$((behind_count))
    fi
  fi

  if (( num_push_ahead > 0 && num_push_behind > 0 )); then
    # Add diverged symbol (optional)
    # git_status+=" ${SPACESHIP_GIT_STATUS_DIVERGED_SYMBOL}"
    git_status+=" ${SPACESHIP_GIT_STATUS_P10K_PUSH_COMMITS_AHEAD_SYMBOL}${num_push_ahead}${SPACESHIP_GIT_STATUS_P10K_PUSH_COMMITS_BEHIND_SYMBOL}${num_push_behind}"
  elif (( num_push_ahead > 0 )); then
    git_status+=" ${SPACESHIP_GIT_STATUS_P10K_PUSH_COMMITS_AHEAD_SYMBOL}${num_push_ahead}"
  elif (( num_push_behind > 0 ));  then
    git_status+=" ${SPACESHIP_GIT_STATUS_P10K_PUSH_COMMITS_BEHIND_SYMBOL}${num_push_behind}"
  fi

  # --- Ahead/Behind Status ---
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

  # Use arithmetic comparison (( ... > 0 ))
  if (( num_ahead > 0 && num_behind > 0 )); then
    # Add diverged symbol if you have one defined
    # git_status+=" ${SPACESHIP_GIT_STATUS_DIVERGED_SYMBOL}"
    git_status+=" ${SPACESHIP_GIT_STATUS_P10K_COMMITS_AHEAD_SYMBOL}${num_ahead}${SPACESHIP_GIT_STATUS_P10K_COMMITS_BEHIND_SYMBOL}${num_behind}"
  elif (( num_ahead > 0 )); then
    git_status+=" ${SPACESHIP_GIT_STATUS_P10K_COMMITS_AHEAD_SYMBOL}${num_ahead}"
  elif (( num_behind > 0 )); then
    git_status+=" ${SPACESHIP_GIT_STATUS_P10K_COMMITS_BEHIND_SYMBOL}${num_behind}"
  fi

  # --- Build Status String ---
  # Order: Stashed, Conflicted, Staged, Renamed, Modified, Deleted, Untracked

  if (( num_stashes > 0 )); then
    git_status+=" ${SPACESHIP_GIT_STATUS_P10K_CLEAN_COLOR}${SPACESHIP_GIT_STATUS_P10K_STASHES_SYMBOL}${num_stashes}"
  fi

  if (( num_conflicted > 0 )); then
    git_status+=" ${SPACESHIP_GIT_STATUS_P10K_CONFLICTED_COLOR}${SPACESHIP_GIT_STATUS_P10K_CONFLICTED_SYMBOL}${num_conflicted}"
  fi

  if (( num_staged > 0 )); then
    git_status+=" ${SPACESHIP_GIT_STATUS_P10K_STAGED_COLOR}${SPACESHIP_GIT_STATUS_P10K_STAGED_SYMBOL}${num_staged}"
  fi

  if (( num_renamed > 0 )); then
    git_status+=" ${SPACESHIP_GIT_STATUS_P10K_RENAMED_COLOR}${SPACESHIP_GIT_STATUS_P10K_RENAMED_SYMBOL}${num_renamed}"
  fi

  if (( num_modified > 0 )); then
    git_status+=" ${SPACESHIP_GIT_STATUS_P10K_MODIFIED_COLOR}${SPACESHIP_GIT_STATUS_P10K_MODIFIED_SYMBOL}${num_modified}"
  fi

  if (( num_deleted > 0 )); then
    git_status+=" ${SPACESHIP_GIT_STATUS_P10K_DELETED_COLOR}${SPACESHIP_GIT_STATUS_P10K_DELETED_SYMBOL}${num_deleted}"
  fi

  if (( num_untracked > 0 )); then
    git_status+=" ${SPACESHIP_GIT_STATUS_P10K_UNTRACKED_COLOR}${SPACESHIP_GIT_STATUS_P10K_UNTRACKED_SYMBOL}${num_untracked}"
  fi

  # --- Final Output ---
  if [[ -n $git_status ]]; then
    spaceship::section \
      "$SPACESHIP_GIT_STATUS_P10K_CLEAN_COLOR${SPACESHIP_GIT_STATUS_P10K_SYMBOL}$ref_display$git_status"
  fi
}
