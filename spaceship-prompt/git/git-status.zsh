#!/bin/zsh

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_GIT_STATUS_BASSAN_SHOW="${SPACESHIP_GIT_STATUS_BASSAN_SHOW=true}"
SPACESHIP_GIT_STATUS_BASSAN_ASYNC="${SPACESHIP_GIT_STATUS_BASSAN_ASYNC=true}"

SPACESHIP_GIT_STATUS_BASSAN_COMMITS_BEHIND_SYMBOL="${SPACESHIP_GIT_STATUS_BASSAN_COMMITS_BEHIND_SYMBOL=⇣}"
SPACESHIP_GIT_STATUS_BASSAN_COMMITS_AHEAD_SYMBOL="${SPACESHIP_GIT_STATUS_BASSAN_COMMITS_AHEAD_SYMBOL=⇡}"
SPACESHIP_GIT_STATUS_BASSAN_PUSH_COMMITS_BEHIND_SYMBOL="${SPACESHIP_GIT_STATUS_BASSAN_PUSH_COMMITS_BEHIND_SYMBOL=⇠}"
SPACESHIP_GIT_STATUS_BASSAN_PUSH_COMMITS_AHEAD_SYMBOL="${SPACESHIP_GIT_STATUS_BASSAN_PUSH_COMMITS_AHEAD_SYMBOL=⇢}"
SPACESHIP_GIT_STATUS_BASSAN_STASHES_SYMBOL="${SPACESHIP_GIT_STATUS_BASSAN_STASHES_SYMBOL=*}"
SPACESHIP_GIT_STATUS_BASSAN_CONFLICTED_SYMBOL="${SPACESHIP_GIT_STATUS_BASSAN_CONFLICTED_SYMBOL=~}"
SPACESHIP_GIT_STATUS_BASSAN_RENAMED_SYMBOL="${SPACESHIP_GIT_STATUS_BASSAN_RENAMED_SYMBOL="⇄"}"
SPACESHIP_GIT_STATUS_BASSAN_MODIFIED_SYMBOL="${SPACESHIP_GIT_STATUS_BASSAN_MODIFIED_SYMBOL=!}"
SPACESHIP_GIT_STATUS_BASSAN_DELETED_SYMBOL="${SPACESHIP_GIT_STATUS_BASSAN_DELETED_SYMBOL=-}"
SPACESHIP_GIT_STATUS_BASSAN_ADDED_SYMBOL="${SPACESHIP_GIT_STATUS_BASSAN_ADDED_SYMBOL=+}"
SPACESHIP_GIT_STATUS_BASSAN_STAGED_SYMBOL="${SPACESHIP_GIT_STATUS_BASSAN_STAGED_SYMBOL=+}"
SPACESHIP_GIT_STATUS_BASSAN_UNTRACKED_SYMBOL="${SPACESHIP_GIT_STATUS_BASSAN_UNTRACKED_SYMBOL=?}"

SPACESHIP_GIT_STATUS_BASSAN_CLEAN_COLOR="${SPACESHIP_GIT_BASSAN_CLEAN_COLOR}"
SPACESHIP_GIT_STATUS_BASSAN_MODIFIED_COLOR="${SPACESHIP_GIT_BASSAN_MODIFIED_COLOR}"
SPACESHIP_GIT_STATUS_BASSAN_CONFLICTED_COLOR="${SPACESHIP_GIT_STATUS_BASSAN_CONFLICTED_COLOR=%196F}"
SPACESHIP_GIT_STATUS_BASSAN_RENAMED_COLOR="${SPACESHIP_GIT_STATUS_BASSAN_RENAMED_COLOR=%178F}" #TODO
SPACESHIP_GIT_STATUS_BASSAN_DELETED_COLOR="${SPACESHIP_GIT_STATUS_BASSAN_DELETED_COLOR=%196F}" #TODO
SPACESHIP_GIT_STATUS_BASSAN_ADDED_COLOR="${SPACESHIP_GIT_STATUS_BASSAN_ADDED_COLOR=%39F}"
SPACESHIP_GIT_STATUS_BASSAN_STAGED_COLOR="${SPACESHIP_GIT_STATUS_BASSAN_STAGED_COLOR=%4F}"
SPACESHIP_GIT_STATUS_BASSAN_UNTRACKED_COLOR="${SPACESHIP_GIT_STATUS_BASSAN_UNTRACKED_COLOR=%39F}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

spaceship_git_status_bassan() {
  [[ $SPACESHIP_GIT_STATUS_BASSAN_SHOW == false ]] && return

  spaceship::is_git || return
  spaceship::exists git || return

  local porcelain_status git_status=""

  # Get status and branch info once
  porcelain_status=${SPACESHIP_GIT_PORCELAIN_STATUS}
  porcelain_status=$(echo "$porcelain_status" | command grep -v '^## ') # Keep only file lines

  # --- Calculate Counts ---
  local num_untracked num_staged num_modified num_renamed num_deleted num_conflicted num_stashes test

  # --- Calculate Counts ---
  # --- Calculate Counts ---
  # Untracked ('??')
  num_untracked=$(echo "$porcelain_status" | command grep -cE '^\?\? ')

  # Staged ('A  ', 'M  ', 'D  ', 'C  ', 'R  ') - Purely staged changes
  num_staged=$(echo "$porcelain_status" | command grep -cE '^(A|M|D|C|R)  ')

  # Modified in worktree ( M, AM, MM, CM)
  # This counts files modified in the worktree, including those previously staged.
  # Excludes RM (handled by num_renamed).
  num_modified=$(echo "$porcelain_status" | command grep -cE '^( M|AM|MM|CM) ')

  # Renamed with unstaged changes ('RM', 'RD')
  # R  (purely staged rename) is covered by num_staged.
  num_renamed=$(echo "$porcelain_status" | command grep -cE '^R[MD] ') # Corrected pattern to ^R[MD] if it wasn't already

  # Deleted in worktree ( D, AD, MD, CD)
  # This counts files deleted from the worktree, including those previously staged.
  # Excludes RD (handled by num_renamed) and DD (conflict).
  num_deleted=$(echo "$porcelain_status" | command grep -cE '^( D|AD|MD|CD) ')

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

  # --- Build Status String ---
  # Order: Stashed, Conflicted, Staged, Renamed, Modified, Deleted, Untracked

  if (( num_stashes > 0 )); then
    git_status+=" ${SPACESHIP_GIT_STATUS_BASSAN_CLEAN_COLOR}${SPACESHIP_GIT_STATUS_BASSAN_STASHES_SYMBOL}${num_stashes}"
  fi

  if (( num_conflicted > 0 )); then
    git_status+=" ${SPACESHIP_GIT_STATUS_BASSAN_CONFLICTED_COLOR}${SPACESHIP_GIT_STATUS_BASSAN_CONFLICTED_SYMBOL}${num_conflicted}"
  fi

  if (( num_staged > 0 )); then
    git_status+=" ${SPACESHIP_GIT_STATUS_BASSAN_STAGED_COLOR}${SPACESHIP_GIT_STATUS_BASSAN_STAGED_SYMBOL}${num_staged}"
  fi

  if (( num_renamed > 0 )); then
    git_status+=" ${SPACESHIP_GIT_STATUS_BASSAN_RENAMED_COLOR}${SPACESHIP_GIT_STATUS_BASSAN_RENAMED_SYMBOL}${num_renamed}"
  fi

  if (( num_modified > 0 )); then
    git_status+=" ${SPACESHIP_GIT_STATUS_BASSAN_MODIFIED_COLOR}${SPACESHIP_GIT_STATUS_BASSAN_MODIFIED_SYMBOL}${num_modified}"
  fi

  if (( num_deleted > 0 )); then
    git_status+=" ${SPACESHIP_GIT_STATUS_BASSAN_DELETED_COLOR}${SPACESHIP_GIT_STATUS_BASSAN_DELETED_SYMBOL}${num_deleted}"
  fi

  if (( num_untracked > 0 )); then
    git_status+=" ${SPACESHIP_GIT_STATUS_BASSAN_UNTRACKED_COLOR}${SPACESHIP_GIT_STATUS_BASSAN_UNTRACKED_SYMBOL}${num_untracked}"
  fi

  # --- Final Output ---
  if [[ -n $git_status ]]; then
    spaceship::section \
      "$git_status"
  fi
}
