#!/bin/zsh

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_GIT_P10K_GIT_STATUS_FOLDER="${SPACESHIP_GIT_P10K_GIT_STATUS_FOLDER:-$(brew --prefix)/opt/gitstatus}"

SPACESHIP_GIT_P10K_SYMBOL="${SPACESHIP_GIT_P10K_SYMBOL:-\uf408 }"
SPACESHIP_GIT_P10K_BRANCH_SYMBOL="${SPACESHIP_GIT_P10K_BRANCH_SYMBOL:-\uf418 }"

SPACESHIP_GIT_P10K_TAG_SYMBOL="${SPACESHIP_GIT_P10K_TAG_SYMBOL:-#}"
SPACESHIP_GIT_P10K_COMMIT_SYMBOL="${SPACESHIP_GIT_P10K_COMMIT_SYMBOL:-@}"
SPACESHIP_GIT_P10K_REMOTE_BRANCH_SYMBOL="${SPACESHIP_GIT_P10K_REMOTE_BRANCH_SYMBOL:-:}"
SPACESHIP_GIT_P10K_COMMITS_BEHIND_SYMBOL="${SPACESHIP_GIT_P10K_COMMITS_BEHIND_SYMBOL:-⇣}"
SPACESHIP_GIT_P10K_COMMITS_AHEAD_SYMBOL="${SPACESHIP_GIT_P10K_COMMITS_AHEAD_SYMBOL:-⇡}"
SPACESHIP_GIT_P10K_PUSH_COMMITS_BEHIND_SYMBOL="${SPACESHIP_GIT_P10K_PUSH_COMMITS_BEHIND_SYMBOL:-⇠}"
SPACESHIP_GIT_P10K_PUSH_COMMITS_AHEAD_SYMBOL="${SPACESHIP_GIT_P10K_PUSH_COMMITS_AHEAD_SYMBOL:-⇢}"
SPACESHIP_GIT_P10K_STASHES_SYMBOL="${SPACESHIP_GIT_P10K_STASHES_SYMBOL:-*}"
SPACESHIP_GIT_P10K_CONFLICTED_SYMBOL="${SPACESHIP_GIT_P10K_CONFLICTED_SYMBOL:-~}"
SPACESHIP_GIT_P10K_STAGED_SYMBOL="${SPACESHIP_GIT_P10K_STAGED_SYMBOL:-+}"
SPACESHIP_GIT_P10K_UNSTAGED_SYMBOL="${SPACESHIP_GIT_P10K_UNSTAGED_SYMBOL:-!}"
SPACESHIP_GIT_P10K_UNTRACKED_SYMBOL="${SPACESHIP_GIT_P10K_UNTRACKED_SYMBOL:-?}"

SPACESHIP_GIT_P10K_CLEAN_COLOR="${SPACESHIP_GIT_P10K_CLEAN_COLOR:-%76F}"
SPACESHIP_GIT_P10K_MODIFIED_COLOR="${SPACESHIP_GIT_P10K_MODIFIED_COLOR:-%178F}"
SPACESHIP_GIT_P10K_UNTRACKED_COLOR="${SPACESHIP_GIT_P10K_UNTRACKED_COLOR:-%39F}"
SPACESHIP_GIT_P10K_CONFLICTED_COLOR="${SPACESHIP_GIT_P10K_CONFLICTED_COLOR:-%196F}"

# ------------------------------------------------------------------------------
# Dependencies
# ------------------------------------------------------------------------------

source "$SPACESHIP_GIT_P10K_GIT_STATUS_FOLDER/gitstatus.plugin.zsh" || return

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

spaceship_git_status_p10k() {
  # Copied and modified from Roman Perepelitsa (romkatv) under MIT License
  # https://github.com/romkatv/powerlevel10k/blob/8fa10f43a0f65a5e15417128be63e68e1d5b1f66/config/p10k-lean.zsh#L359

  gitstatus_query 'MY'                  || return 1  # error
  [[ $VCS_STATUS_RESULT == 'ok-sync' ]] || return 0  # not a git repo

  local git_status

  if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
    local branch=${(V)VCS_STATUS_LOCAL_BRANCH}
    (( $#branch > 32 )) && branch[13,-13]="…"
    git_status+="${SPACESHIP_GIT_P10K_CLEAN_COLOR}${SPACESHIP_GIT_P10K_BRANCH_SYMBOL}${branch//\%/%%}"
  fi
  
  [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]] &&
    git_status+="${SPACESHIP_GIT_P10K_CLEAN_COLOR}${SPACESHIP_GIT_P10K_REMOTE_BRANCH_SYMBOL}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}"

  [[ -z $VCS_STATUS_LOCAL_BRANCH && -z $VCS_STATUS_TAG ]] &&
    git_status+="${SPACESHIP_GIT_P10K_CLEAN_COLOR}${SPACESHIP_GIT_P10K_COMMIT_SYMBOL}${VCS_STATUS_COMMIT[1,8]}"

  if [[ -n $VCS_STATUS_TAG && -z $VCS_STATUS_LOCAL_BRANCH ]]; then
    local tag=${(V)VCS_STATUS_TAG}
    (( $#tag > 32 )) && tag[13,-13]="…"
    git_status+="${SPACESHIP_GIT_P10K_CLEAN_COLOR}${SPACESHIP_GIT_P10K_TAG_SYMBOL}${tag//\%/%%}"
  fi

  [[ $VCS_STATUS_COMMIT_SUMMARY == (|*[^[:alnum:]])(wip|WIP)(|[^[:alnum:]]*) ]] &&
    git_status+=" ${SPACESHIP_GIT_P10K_MODIFIED_COLOR}wip"
  
  if (( VCS_STATUS_COMMITS_AHEAD || VCS_STATUS_COMMITS_BEHIND )); then
    # ⇣42 if behind the remote.
    (( VCS_STATUS_COMMITS_BEHIND )) && git_status+=" ${SPACESHIP_GIT_P10K_CLEAN_COLOR}${SPACESHIP_GIT_P10K_COMMITS_BEHIND_SYMBOL}${VCS_STATUS_COMMITS_BEHIND}"
    # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
    (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && git_status+=" "
    (( VCS_STATUS_COMMITS_AHEAD  )) && git_status+="${SPACESHIP_GIT_P10K_CLEAN_COLOR}${SPACESHIP_GIT_P10K_COMMITS_AHEAD_SYMBOL}${VCS_STATUS_COMMITS_AHEAD}"
  fi

  # ⇠42 if behind the push remote.
  (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && git_status+=" ${SPACESHIP_GIT_P10K_CLEAN_COLOR}${SPACESHIP_GIT_P10K_PUSH_COMMITS_BEHIND_SYMBOL}${VCS_STATUS_PUSH_COMMITS_BEHIND}"
  (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && git_status+=" "
  # ⇢42 if ahead of the push remote; no leading space if also behind: ⇠42⇢42.
  (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && git_status+="${SPACESHIP_GIT_P10K_CLEAN_COLOR}${SPACESHIP_GIT_P10K_PUSH_COMMITS_AHEAD_SYMBOL}${VCS_STATUS_PUSH_COMMITS_AHEAD}"
  # *42 if have stashes.
  (( VCS_STATUS_STASHES        )) && git_status+=" ${SPACESHIP_GIT_P10K_CLEAN_COLOR}${SPACESHIP_GIT_P10K_STASHES_SYMBOL}${VCS_STATUS_STASHES}"
  # 'merge' if the repo is in an unusual state.
  [[ -n $VCS_STATUS_ACTION     ]] && git_status+=" ${SPACESHIP_GIT_P10K_CONFLICTED_COLOR}${VCS_STATUS_ACTION}"
  # ~42 if have merge conflicts.
  (( VCS_STATUS_NUM_CONFLICTED )) && git_status+=" ${SPACESHIP_GIT_P10K_CONFLICTED_COLOR}${SPACESHIP_GIT_P10K_CONFLICTED_SYMBOL}${VCS_STATUS_NUM_CONFLICTED}"
  # +42 if have staged changes.
  (( VCS_STATUS_NUM_STAGED )) && git_status+=" ${SPACESHIP_GIT_P10K_MODIFIED_COLOR}${SPACESHIP_GIT_P10K_STAGED_SYMBOL}${VCS_STATUS_NUM_STAGED}"
  # !42 if have unstaged changes.
  (( VCS_STATUS_NUM_UNSTAGED   )) && git_status+=" ${SPACESHIP_GIT_P10K_MODIFIED_COLOR}${SPACESHIP_GIT_P10K_UNSTAGED_SYMBOL}${VCS_STATUS_NUM_UNSTAGED}"
  # ?42 if have untracked files. It's really a question mark, your font isn't broken.
  (( VCS_STATUS_NUM_UNTRACKED  )) && git_status+=" ${SPACESHIP_GIT_P10K_UNTRACKED_COLOR}${SPACESHIP_GIT_P10K_UNTRACKED_SYMBOL}${VCS_STATUS_NUM_UNTRACKED}"
  
  if [[ -n $git_status ]]; then
    spaceship::section \
      "$SPACESHIP_GIT_P10K_CLEAN_COLOR${SPACESHIP_GIT_P10K_SYMBOL}$git_status"
  fi
  
}

# Start gitstatusd instance with name "MY". The same name is passed to
# gitstatus_query in spaceship_git_status_p10k. The flags with -1 as values
# enable staged, unstaged, conflicted and untracked counters.
gitstatus_stop 'MY' && gitstatus_start -s -1 -u -1 -c -1 -d -1 'MY'
